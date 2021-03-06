library(tidyverse)
library(dplyr)
library(lubridate)
library(ggplot2)

#reading and cleaning the data from the txt file

if(!file.exists("hpc.zip")){ 
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
                destfile = "hpc.zip", method = "curl")
  
}

unzip("hpc.zip")

hpc <- read.table("household_power_consumption.txt",sep = ";", na.strings = "?", header = TRUE)
file.remove("household_power_consumption.txt")
hpc <- as_tibble(hpc)

# combining date and time columns
hpc$date_time <- paste(hpc$Date, hpc$Time) 

# converting combined date and time column into a POSIXct object using lubridate
hpc$date_time <- dmy_hms(hpc$date_time) 

hpc <- hpc %>% select(date_time, everything()) %>%
  select(date_time, 4:10) #filtering unneeded columns out

hpc <- hpc %>% filter(date_time >= ymd_hms("2007-02-01 00:00:00") 
                      & date_time <= ymd_hms("2007-02-03 00:00:00")) #selecting required date range

hpc$day <- wday(hpc$date_time, label = TRUE, abbr = FALSE) #getting day names

hpc <- hpc %>% select(day, everything())

# Print plot 3

png(file="plot3.png", height = 480, width = 480)

with(hpc, plot(type = "l", date_time, Sub_metering_1,
               ylab = "Energy sub metering",
               xlab = "", col = "black"))

with(hpc,lines(date_time, Sub_metering_2, col = "red"))

with(hpc,lines(date_time, Sub_metering_3, col = "blue"))

legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col=c("black","red","blue"), lty = 1, cex = 0.8, inset = 0.000001)

dev.off()
