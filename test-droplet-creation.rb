#!/usr/bin/ruby
require 'barge'
require 'net/ssh'

# Creating droplets
def create
	slugs = ['centos-7-0-x64']
	regs = ['nyc3']
  sizes = ['512mb', '1gb', '2gb']
	barge = Barge::Client.new(access_token: 'token')
	regs.each do |reg|
		slugs.each do |slug|
      sizes.each do |size|
			puts "Creating #{slug}-#{size}"
			puts barge.droplet.create(name: "#{slug}-#{size}", region: "#{reg}", size: "#{size}", image: "#{slug}", ssh_keys:[ ssh_key_id ]).success?
        end
		end
	end
end

# Attempting an SSH login
def ssh
    barge = Barge::Client.new(access_token: 'token')
    arr = 0..100
    data = barge.droplet.all
	begin
    arr.each do |x|
        host = barge.droplet.all.droplets[x].networks.v4[0].ip_address
		drop = data.droplets[x].id
        user = 'root'
		puts "  Trying Droplet #{drop} @ #{host}"
			begin
				Net::SSH.start( "#{host}", "#{user}", :paranoid => true, :timeout => 3 ) do|ssh|
					output = ssh.exec!("hostname")
           			puts "Success: " + output
				end
			rescue Timeout::Error
				puts "    Failed: Timed out for #{drop}"
			rescue Errno::EHOSTUNREACH
				puts "    Failed: Host Unreachable on #{drop}"
			rescue Errno::ECONNREFUSED
				puts "    Failed: Connection refused on #{drop}"
			rescue
				puts "    Failed: Asked for password on #{drop}"
			end
		end
	end
	# ignores 'arr' if under 100
	rescue
end

# Destroy the Droplet
def destroy
    barge = Barge::Client.new(access_token: 'token')
    arr = 0..100
    data = barge.droplet.all
    arr.each do |x|
        drop = data.droplets[x].id
        puts "Destroying #{drop}"
        puts barge.droplet.destroy("#{drop}").success?
    end
	# ignores 'arr' if under 100
	rescue
end

# Powers off Droplet
def poweroff
    barge = Barge::Client.new(access_token: 'token')
    arr = 0..100
    data = barge.droplet.all
    arr.each do |x|
        drop = data.droplets[x].id
        puts "Powering Off #{drop}"
        puts barge.droplet.power_off("#{drop}").success?
    end
	# ignores 'arr' if under 100
	rescue
end

# Powers on Droplet
def poweron
    barge = Barge::Client.new(access_token: 'token')
    arr = 0..100
    data = barge.droplet.all
    arr.each do |x|
        drop = data.droplets[x].id
        puts "Powering On #{drop}"
        puts barge.droplet.power_on("#{drop}").success?
    end
	# ignores 'arr' if under 100
	rescue
end

# Power-cycles the droplet
def powercycle
    barge = Barge::Client.new(access_token: 'token')
    arr = 0..100
    data = barge.droplet.all
    arr.each do |x|
        drop = data.droplets[x].id
        puts "Power Cycling #{drop}"
        puts barge.droplet.power_cycle("#{drop}").success?
    end
	# ignores 'arr' if under 100
	rescue
end

# Reboots droplet
def reboot
    barge = Barge::Client.new(access_token: 'token')
    arr = 0..100
    data = barge.droplet.all
    arr.each do |x|
        drop = data.droplets[x].id
        puts "Rebooting #{drop}"
        puts barge.droplet.reboot("#{drop}").success?
    end
	# ignores 'arr' if under 100
	rescue
end

# Shutdowns droplet
def shutdown
    barge = Barge::Client.new(access_token: 'token')
    arr = 0..100
    data = barge.droplet.all
    arr.each do |x|
        drop = data.droplets[x].id
        puts "Shutting Down #{drop}"
        puts barge.droplet.shutdown("#{drop}").success?
    end
	# ignores 'arr' if under 100
	rescue
end

# Loop
while 1
  create
  sleep 120
  ssh
  sleep 5
  poweroff
  sleep 5
  poweron
  sleep 5
  powercycle
  sleep 5
  reboot
  sleep 5
  shutdown
  sleep 5
  destroy
end