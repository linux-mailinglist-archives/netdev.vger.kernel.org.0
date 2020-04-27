Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C84221BB0E8
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 00:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbgD0WCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 18:02:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:48144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726396AbgD0WCF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 18:02:05 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F31C21974;
        Mon, 27 Apr 2020 22:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588024917;
        bh=xxN6APHaqJl4kkyZpYkfCgEVb/bPQ9wvvkv/aTl4BEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=exSpkvSGHkbt2xFb0Hb2fvvVzmD786b7HXJCVqYUrnpIjhMs3e/ukrCzINGhLXNXF
         iPgdg+IvvK12xoXDXatxGc7wGw2Utzq1+22wBcBG0kdP++eR8ElIKmx1Iwu2BqUFnP
         yyTarIGMEpFeQmm4QEV6NrYF6RTXp+ddW8wHgYeQ=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jTBp4-000IoN-NY; Tue, 28 Apr 2020 00:01:54 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: [PATCH 09/38] docs: networking: convert bonding.txt to ReST
Date:   Tue, 28 Apr 2020 00:01:24 +0200
Message-Id: <0bd4bc995477514e91e35994d3fdd2306ed7abd3.1588024424.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588024424.git.mchehab+huawei@kernel.org>
References: <cover.1588024424.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- adjust titles and chapters, adding proper markups;
- comment out text-only TOC from html/pdf output;
- mark code blocks and literals as such;
- mark tables as such;
- add notes markups;
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../networking/{bonding.txt => bonding.rst}   | 1275 +++++++++--------
 .../networking/device_drivers/intel/e100.rst  |    2 +-
 .../networking/device_drivers/intel/ixgb.rst  |    2 +-
 Documentation/networking/index.rst            |    1 +
 drivers/net/Kconfig                           |    2 +-
 5 files changed, 668 insertions(+), 614 deletions(-)
 rename Documentation/networking/{bonding.txt => bonding.rst} (75%)

diff --git a/Documentation/networking/bonding.txt b/Documentation/networking/bonding.rst
similarity index 75%
rename from Documentation/networking/bonding.txt
rename to Documentation/networking/bonding.rst
index e3abfbd32f71..dd49f95d28d3 100644
--- a/Documentation/networking/bonding.txt
+++ b/Documentation/networking/bonding.rst
@@ -1,10 +1,15 @@
+.. SPDX-License-Identifier: GPL-2.0
 
-		Linux Ethernet Bonding Driver HOWTO
+===================================
+Linux Ethernet Bonding Driver HOWTO
+===================================
 
-		Latest update: 27 April 2011
+Latest update: 27 April 2011
+
+Initial release: Thomas Davis <tadavis at lbl.gov>
+
+Corrections, HA extensions: 2000/10/03-15:
 
-Initial release : Thomas Davis <tadavis at lbl.gov>
-Corrections, HA extensions : 2000/10/03-15 :
   - Willy Tarreau <willy at meta-x.org>
   - Constantine Gavrilov <const-g at xpert.com>
   - Chad N. Tindel <ctindel at ieee dot org>
@@ -13,98 +18,98 @@ Corrections, HA extensions : 2000/10/03-15 :
 
 Reorganized and updated Feb 2005 by Jay Vosburgh
 Added Sysfs information: 2006/04/24
+
   - Mitch Williams <mitch.a.williams at intel.com>
 
 Introduction
 ============
 
-	The Linux bonding driver provides a method for aggregating
+The Linux bonding driver provides a method for aggregating
 multiple network interfaces into a single logical "bonded" interface.
 The behavior of the bonded interfaces depends upon the mode; generally
 speaking, modes provide either hot standby or load balancing services.
 Additionally, link integrity monitoring may be performed.
-	
-	The bonding driver originally came from Donald Becker's
+
+The bonding driver originally came from Donald Becker's
 beowulf patches for kernel 2.0. It has changed quite a bit since, and
 the original tools from extreme-linux and beowulf sites will not work
 with this version of the driver.
 
-	For new versions of the driver, updated userspace tools, and
+For new versions of the driver, updated userspace tools, and
 who to ask for help, please follow the links at the end of this file.
 
-Table of Contents
-=================
+.. Table of Contents
 
-1. Bonding Driver Installation
+   1. Bonding Driver Installation
 
-2. Bonding Driver Options
+   2. Bonding Driver Options
 
-3. Configuring Bonding Devices
-3.1	Configuration with Sysconfig Support
-3.1.1		Using DHCP with Sysconfig
-3.1.2		Configuring Multiple Bonds with Sysconfig
-3.2	Configuration with Initscripts Support
-3.2.1		Using DHCP with Initscripts
-3.2.2		Configuring Multiple Bonds with Initscripts
-3.3	Configuring Bonding Manually with Ifenslave
-3.3.1		Configuring Multiple Bonds Manually
-3.4	Configuring Bonding Manually via Sysfs
-3.5	Configuration with Interfaces Support
-3.6	Overriding Configuration for Special Cases
-3.7 Configuring LACP for 802.3ad mode in a more secure way
+   3. Configuring Bonding Devices
+   3.1	Configuration with Sysconfig Support
+   3.1.1		Using DHCP with Sysconfig
+   3.1.2		Configuring Multiple Bonds with Sysconfig
+   3.2	Configuration with Initscripts Support
+   3.2.1		Using DHCP with Initscripts
+   3.2.2		Configuring Multiple Bonds with Initscripts
+   3.3	Configuring Bonding Manually with Ifenslave
+   3.3.1		Configuring Multiple Bonds Manually
+   3.4	Configuring Bonding Manually via Sysfs
+   3.5	Configuration with Interfaces Support
+   3.6	Overriding Configuration for Special Cases
+   3.7 Configuring LACP for 802.3ad mode in a more secure way
 
-4. Querying Bonding Configuration
-4.1	Bonding Configuration
-4.2	Network Configuration
+   4. Querying Bonding Configuration
+   4.1	Bonding Configuration
+   4.2	Network Configuration
 
-5. Switch Configuration
+   5. Switch Configuration
 
-6. 802.1q VLAN Support
+   6. 802.1q VLAN Support
 
-7. Link Monitoring
-7.1	ARP Monitor Operation
-7.2	Configuring Multiple ARP Targets
-7.3	MII Monitor Operation
+   7. Link Monitoring
+   7.1	ARP Monitor Operation
+   7.2	Configuring Multiple ARP Targets
+   7.3	MII Monitor Operation
 
-8. Potential Trouble Sources
-8.1	Adventures in Routing
-8.2	Ethernet Device Renaming
-8.3	Painfully Slow Or No Failed Link Detection By Miimon
+   8. Potential Trouble Sources
+   8.1	Adventures in Routing
+   8.2	Ethernet Device Renaming
+   8.3	Painfully Slow Or No Failed Link Detection By Miimon
 
-9. SNMP agents
+   9. SNMP agents
 
-10. Promiscuous mode
+   10. Promiscuous mode
 
-11. Configuring Bonding for High Availability
-11.1	High Availability in a Single Switch Topology
-11.2	High Availability in a Multiple Switch Topology
-11.2.1		HA Bonding Mode Selection for Multiple Switch Topology
-11.2.2		HA Link Monitoring for Multiple Switch Topology
+   11. Configuring Bonding for High Availability
+   11.1	High Availability in a Single Switch Topology
+   11.2	High Availability in a Multiple Switch Topology
+   11.2.1		HA Bonding Mode Selection for Multiple Switch Topology
+   11.2.2		HA Link Monitoring for Multiple Switch Topology
 
-12. Configuring Bonding for Maximum Throughput
-12.1	Maximum Throughput in a Single Switch Topology
-12.1.1		MT Bonding Mode Selection for Single Switch Topology
-12.1.2		MT Link Monitoring for Single Switch Topology
-12.2	Maximum Throughput in a Multiple Switch Topology
-12.2.1		MT Bonding Mode Selection for Multiple Switch Topology
-12.2.2		MT Link Monitoring for Multiple Switch Topology
+   12. Configuring Bonding for Maximum Throughput
+   12.1	Maximum Throughput in a Single Switch Topology
+   12.1.1		MT Bonding Mode Selection for Single Switch Topology
+   12.1.2		MT Link Monitoring for Single Switch Topology
+   12.2	Maximum Throughput in a Multiple Switch Topology
+   12.2.1		MT Bonding Mode Selection for Multiple Switch Topology
+   12.2.2		MT Link Monitoring for Multiple Switch Topology
 
-13. Switch Behavior Issues
-13.1	Link Establishment and Failover Delays
-13.2	Duplicated Incoming Packets
+   13. Switch Behavior Issues
+   13.1	Link Establishment and Failover Delays
+   13.2	Duplicated Incoming Packets
 
-14. Hardware Specific Considerations
-14.1	IBM BladeCenter
+   14. Hardware Specific Considerations
+   14.1	IBM BladeCenter
 
-15. Frequently Asked Questions
+   15. Frequently Asked Questions
 
-16. Resources and Links
+   16. Resources and Links
 
 
 1. Bonding Driver Installation
 ==============================
 
-	Most popular distro kernels ship with the bonding driver
+Most popular distro kernels ship with the bonding driver
 already available as a module. If your distro does not, or you
 have need to compile bonding from source (e.g., configuring and
 installing a mainline kernel from kernel.org), you'll need to perform
@@ -113,54 +118,54 @@ the following steps:
 1.1 Configure and build the kernel with bonding
 -----------------------------------------------
 
-	The current version of the bonding driver is available in the
+The current version of the bonding driver is available in the
 drivers/net/bonding subdirectory of the most recent kernel source
 (which is available on http://kernel.org).  Most users "rolling their
 own" will want to use the most recent kernel from kernel.org.
 
-	Configure kernel with "make menuconfig" (or "make xconfig" or
+Configure kernel with "make menuconfig" (or "make xconfig" or
 "make config"), then select "Bonding driver support" in the "Network
 device support" section.  It is recommended that you configure the
 driver as module since it is currently the only way to pass parameters
 to the driver or configure more than one bonding device.
 
-	Build and install the new kernel and modules.
+Build and install the new kernel and modules.
 
 1.2 Bonding Control Utility
--------------------------------------
+---------------------------
 
-	 It is recommended to configure bonding via iproute2 (netlink)
+It is recommended to configure bonding via iproute2 (netlink)
 or sysfs, the old ifenslave control utility is obsolete.
 
 2. Bonding Driver Options
 =========================
 
-	Options for the bonding driver are supplied as parameters to the
+Options for the bonding driver are supplied as parameters to the
 bonding module at load time, or are specified via sysfs.
 
-	Module options may be given as command line arguments to the
+Module options may be given as command line arguments to the
 insmod or modprobe command, but are usually specified in either the
-/etc/modprobe.d/*.conf configuration files, or in a distro-specific
+``/etc/modprobe.d/*.conf`` configuration files, or in a distro-specific
 configuration file (some of which are detailed in the next section).
 
-	Details on bonding support for sysfs is provided in the
+Details on bonding support for sysfs is provided in the
 "Configuring Bonding Manually via Sysfs" section, below.
 
-	The available bonding driver parameters are listed below. If a
+The available bonding driver parameters are listed below. If a
 parameter is not specified the default value is used.  When initially
 configuring a bond, it is recommended "tail -f /var/log/messages" be
 run in a separate window to watch for bonding driver error messages.
 
-	It is critical that either the miimon or arp_interval and
+It is critical that either the miimon or arp_interval and
 arp_ip_target parameters be specified, otherwise serious network
 degradation will occur during link failures.  Very few devices do not
 support at least miimon, so there is really no reason not to use it.
 
-	Options with textual values will accept either the text name
+Options with textual values will accept either the text name
 or, for backwards compatibility, the option value.  E.g.,
 "mode=802.3ad" and "mode=4" set the same mode.
 
-	The parameters are as follows:
+The parameters are as follows:
 
 active_slave
 
@@ -246,10 +251,13 @@ ad_user_port_key
 
 	In an AD system, the port-key has three parts as shown below -
 
+	   =====  ============
 	   Bits   Use
+	   =====  ============
 	   00     Duplex
 	   01-05  Speed
 	   06-15  User-defined
+	   =====  ============
 
 	This defines the upper 10 bits of the port key. The values can be
 	from 0 - 1023. If not given, the system defaults to 0.
@@ -699,7 +707,7 @@ mode
 		swapped with the new curr_active_slave that was
 		chosen.
 
-num_grat_arp
+num_grat_arp,
 num_unsol_na
 
 	Specify the number of peer notifications (gratuitous ARPs and
@@ -729,13 +737,13 @@ packets_per_slave
 
 peer_notif_delay
 
-        Specify the delay, in milliseconds, between each peer
-        notification (gratuitous ARP and unsolicited IPv6 Neighbor
-        Advertisement) when they are issued after a failover event.
-        This delay should be a multiple of the link monitor interval
-        (arp_interval or miimon, whichever is active). The default
-        value is 0 which means to match the value of the link monitor
-        interval.
+	Specify the delay, in milliseconds, between each peer
+	notification (gratuitous ARP and unsolicited IPv6 Neighbor
+	Advertisement) when they are issued after a failover event.
+	This delay should be a multiple of the link monitor interval
+	(arp_interval or miimon, whichever is active). The default
+	value is 0 which means to match the value of the link monitor
+	interval.
 
 primary
 
@@ -977,88 +985,88 @@ lp_interval
 3. Configuring Bonding Devices
 ==============================
 
-	You can configure bonding using either your distro's network
+You can configure bonding using either your distro's network
 initialization scripts, or manually using either iproute2 or the
 sysfs interface.  Distros generally use one of three packages for the
 network initialization scripts: initscripts, sysconfig or interfaces.
 Recent versions of these packages have support for bonding, while older
 versions do not.
 
-	We will first describe the options for configuring bonding for
+We will first describe the options for configuring bonding for
 distros using versions of initscripts, sysconfig and interfaces with full
 or partial support for bonding, then provide information on enabling
 bonding without support from the network initialization scripts (i.e.,
 older versions of initscripts or sysconfig).
 
-	If you're unsure whether your distro uses sysconfig,
+If you're unsure whether your distro uses sysconfig,
 initscripts or interfaces, or don't know if it's new enough, have no fear.
 Determining this is fairly straightforward.
 
-	First, look for a file called interfaces in /etc/network directory.
+First, look for a file called interfaces in /etc/network directory.
 If this file is present in your system, then your system use interfaces. See
 Configuration with Interfaces Support.
 
-	Else, issue the command:
+Else, issue the command::
 
-$ rpm -qf /sbin/ifup
+	$ rpm -qf /sbin/ifup
 
-	It will respond with a line of text starting with either
+It will respond with a line of text starting with either
 "initscripts" or "sysconfig," followed by some numbers.  This is the
 package that provides your network initialization scripts.
 
-	Next, to determine if your installation supports bonding,
-issue the command:
+Next, to determine if your installation supports bonding,
+issue the command::
 
-$ grep ifenslave /sbin/ifup
+    $ grep ifenslave /sbin/ifup
 
-	If this returns any matches, then your initscripts or
+If this returns any matches, then your initscripts or
 sysconfig has support for bonding.
 
 3.1 Configuration with Sysconfig Support
 ----------------------------------------
 
-	This section applies to distros using a version of sysconfig
+This section applies to distros using a version of sysconfig
 with bonding support, for example, SuSE Linux Enterprise Server 9.
 
-	SuSE SLES 9's networking configuration system does support
+SuSE SLES 9's networking configuration system does support
 bonding, however, at this writing, the YaST system configuration
 front end does not provide any means to work with bonding devices.
 Bonding devices can be managed by hand, however, as follows.
 
-	First, if they have not already been configured, configure the
+First, if they have not already been configured, configure the
 slave devices.  On SLES 9, this is most easily done by running the
 yast2 sysconfig configuration utility.  The goal is for to create an
 ifcfg-id file for each slave device.  The simplest way to accomplish
 this is to configure the devices for DHCP (this is only to get the
 file ifcfg-id file created; see below for some issues with DHCP).  The
-name of the configuration file for each device will be of the form:
+name of the configuration file for each device will be of the form::
 
-ifcfg-id-xx:xx:xx:xx:xx:xx
+    ifcfg-id-xx:xx:xx:xx:xx:xx
 
-	Where the "xx" portion will be replaced with the digits from
+Where the "xx" portion will be replaced with the digits from
 the device's permanent MAC address.
 
-	Once the set of ifcfg-id-xx:xx:xx:xx:xx:xx files has been
+Once the set of ifcfg-id-xx:xx:xx:xx:xx:xx files has been
 created, it is necessary to edit the configuration files for the slave
 devices (the MAC addresses correspond to those of the slave devices).
 Before editing, the file will contain multiple lines, and will look
-something like this:
+something like this::
 
-BOOTPROTO='dhcp'
-STARTMODE='on'
-USERCTL='no'
-UNIQUE='XNzu.WeZGOGF+4wE'
-_nm_name='bus-pci-0001:61:01.0'
+	BOOTPROTO='dhcp'
+	STARTMODE='on'
+	USERCTL='no'
+	UNIQUE='XNzu.WeZGOGF+4wE'
+	_nm_name='bus-pci-0001:61:01.0'
 
-	Change the BOOTPROTO and STARTMODE lines to the following:
+Change the BOOTPROTO and STARTMODE lines to the following::
 
-BOOTPROTO='none'
-STARTMODE='off'
+	BOOTPROTO='none'
+	STARTMODE='off'
 
-	Do not alter the UNIQUE or _nm_name lines.  Remove any other
+Do not alter the UNIQUE or _nm_name lines.  Remove any other
 lines (USERCTL, etc).
 
-	Once the ifcfg-id-xx:xx:xx:xx:xx:xx files have been modified,
+Once the ifcfg-id-xx:xx:xx:xx:xx:xx files have been modified,
 it's time to create the configuration file for the bonding device
 itself.  This file is named ifcfg-bondX, where X is the number of the
 bonding device to create, starting at 0.  The first such file is
@@ -1066,49 +1074,52 @@ ifcfg-bond0, the second is ifcfg-bond1, and so on.  The sysconfig
 network configuration system will correctly start multiple instances
 of bonding.
 
-	The contents of the ifcfg-bondX file is as follows:
+The contents of the ifcfg-bondX file is as follows::
 
-BOOTPROTO="static"
-BROADCAST="10.0.2.255"
-IPADDR="10.0.2.10"
-NETMASK="255.255.0.0"
-NETWORK="10.0.2.0"
-REMOTE_IPADDR=""
-STARTMODE="onboot"
-BONDING_MASTER="yes"
-BONDING_MODULE_OPTS="mode=active-backup miimon=100"
-BONDING_SLAVE0="eth0"
-BONDING_SLAVE1="bus-pci-0000:06:08.1"
+	BOOTPROTO="static"
+	BROADCAST="10.0.2.255"
+	IPADDR="10.0.2.10"
+	NETMASK="255.255.0.0"
+	NETWORK="10.0.2.0"
+	REMOTE_IPADDR=""
+	STARTMODE="onboot"
+	BONDING_MASTER="yes"
+	BONDING_MODULE_OPTS="mode=active-backup miimon=100"
+	BONDING_SLAVE0="eth0"
+	BONDING_SLAVE1="bus-pci-0000:06:08.1"
 
-	Replace the sample BROADCAST, IPADDR, NETMASK and NETWORK
+Replace the sample BROADCAST, IPADDR, NETMASK and NETWORK
 values with the appropriate values for your network.
 
-	The STARTMODE specifies when the device is brought online.
+The STARTMODE specifies when the device is brought online.
 The possible values are:
 
-	onboot:	 The device is started at boot time.  If you're not
+	======== ======================================================
+	onboot	 The device is started at boot time.  If you're not
 		 sure, this is probably what you want.
 
-	manual:	 The device is started only when ifup is called
+	manual	 The device is started only when ifup is called
 		 manually.  Bonding devices may be configured this
 		 way if you do not wish them to start automatically
 		 at boot for some reason.
 
-	hotplug: The device is started by a hotplug event.  This is not
+	hotplug  The device is started by a hotplug event.  This is not
 		 a valid choice for a bonding device.
 
-	off or ignore: The device configuration is ignored.
+	off or   The device configuration is ignored.
+	ignore
+	======== ======================================================
 
-	The line BONDING_MASTER='yes' indicates that the device is a
+The line BONDING_MASTER='yes' indicates that the device is a
 bonding master device.  The only useful value is "yes."
 
-	The contents of BONDING_MODULE_OPTS are supplied to the
+The contents of BONDING_MODULE_OPTS are supplied to the
 instance of the bonding module for this device.  Specify the options
 for the bonding mode, link monitoring, and so on here.  Do not include
 the max_bonds bonding parameter; this will confuse the configuration
 system if you have multiple bonding devices.
 
-	Finally, supply one BONDING_SLAVEn="slave device" for each
+Finally, supply one BONDING_SLAVEn="slave device" for each
 slave.  where "n" is an increasing value, one for each slave.  The
 "slave device" is either an interface name, e.g., "eth0", or a device
 specifier for the network device.  The interface name is easier to
@@ -1120,34 +1131,34 @@ changes (for example, it is moved from one PCI slot to another).  The
 example above uses one of each type for demonstration purposes; most
 configurations will choose one or the other for all slave devices.
 
-	When all configuration files have been modified or created,
+When all configuration files have been modified or created,
 networking must be restarted for the configuration changes to take
-effect.  This can be accomplished via the following:
+effect.  This can be accomplished via the following::
 
-# /etc/init.d/network restart
+	# /etc/init.d/network restart
 
-	Note that the network control script (/sbin/ifdown) will
+Note that the network control script (/sbin/ifdown) will
 remove the bonding module as part of the network shutdown processing,
 so it is not necessary to remove the module by hand if, e.g., the
 module parameters have changed.
 
-	Also, at this writing, YaST/YaST2 will not manage bonding
+Also, at this writing, YaST/YaST2 will not manage bonding
 devices (they do not show bonding interfaces on its list of network
 devices).  It is necessary to edit the configuration file by hand to
 change the bonding configuration.
 
-	Additional general options and details of the ifcfg file
-format can be found in an example ifcfg template file:
+Additional general options and details of the ifcfg file
+format can be found in an example ifcfg template file::
 
-/etc/sysconfig/network/ifcfg.template
+	/etc/sysconfig/network/ifcfg.template
 
-	Note that the template does not document the various BONDING_
+Note that the template does not document the various ``BONDING_*``
 settings described above, but does describe many of the other options.
 
 3.1.1 Using DHCP with Sysconfig
 -------------------------------
 
-	Under sysconfig, configuring a device with BOOTPROTO='dhcp'
+Under sysconfig, configuring a device with BOOTPROTO='dhcp'
 will cause it to query DHCP for its IP address information.  At this
 writing, this does not function for bonding devices; the scripts
 attempt to obtain the device address from DHCP prior to adding any of
@@ -1157,7 +1168,7 @@ sent to the network.
 3.1.2 Configuring Multiple Bonds with Sysconfig
 -----------------------------------------------
 
-	The sysconfig network initialization system is capable of
+The sysconfig network initialization system is capable of
 handling multiple bonding devices.  All that is necessary is for each
 bonding instance to have an appropriately configured ifcfg-bondX file
 (as described above).  Do not specify the "max_bonds" parameter to any
@@ -1165,14 +1176,14 @@ instance of bonding, as this will confuse sysconfig.  If you require
 multiple bonding devices with identical parameters, create multiple
 ifcfg-bondX files.
 
-	Because the sysconfig scripts supply the bonding module
+Because the sysconfig scripts supply the bonding module
 options in the ifcfg-bondX file, it is not necessary to add them to
-the system /etc/modules.d/*.conf configuration files.
+the system ``/etc/modules.d/*.conf`` configuration files.
 
 3.2 Configuration with Initscripts Support
 ------------------------------------------
 
-	This section applies to distros using a recent version of
+This section applies to distros using a recent version of
 initscripts with bonding support, for example, Red Hat Enterprise Linux
 version 3 or later, Fedora, etc.  On these systems, the network
 initialization scripts have knowledge of bonding, and can be configured to
@@ -1180,7 +1191,7 @@ control bonding devices.  Note that older versions of the initscripts
 package have lower levels of support for bonding; this will be noted where
 applicable.
 
-	These distros will not automatically load the network adapter
+These distros will not automatically load the network adapter
 driver unless the ethX device is configured with an IP address.
 Because of this constraint, users must manually configure a
 network-script file for all physical adapters that will be members of
@@ -1188,19 +1199,19 @@ a bondX link.  Network script files are located in the directory:
 
 /etc/sysconfig/network-scripts
 
-	The file name must be prefixed with "ifcfg-eth" and suffixed
+The file name must be prefixed with "ifcfg-eth" and suffixed
 with the adapter's physical adapter number.  For example, the script
 for eth0 would be named /etc/sysconfig/network-scripts/ifcfg-eth0.
-Place the following text in the file:
+Place the following text in the file::
 
-DEVICE=eth0
-USERCTL=no
-ONBOOT=yes
-MASTER=bond0
-SLAVE=yes
-BOOTPROTO=none
+	DEVICE=eth0
+	USERCTL=no
+	ONBOOT=yes
+	MASTER=bond0
+	SLAVE=yes
+	BOOTPROTO=none
 
-	The DEVICE= line will be different for every ethX device and
+The DEVICE= line will be different for every ethX device and
 must correspond with the name of the file, i.e., ifcfg-eth1 must have
 a device line of DEVICE=eth1.  The setting of the MASTER= line will
 also depend on the final bonding interface name chosen for your bond.
@@ -1208,69 +1219,70 @@ As with other network devices, these typically start at 0, and go up
 one for each device, i.e., the first bonding instance is bond0, the
 second is bond1, and so on.
 
-	Next, create a bond network script.  The file name for this
+Next, create a bond network script.  The file name for this
 script will be /etc/sysconfig/network-scripts/ifcfg-bondX where X is
 the number of the bond.  For bond0 the file is named "ifcfg-bond0",
 for bond1 it is named "ifcfg-bond1", and so on.  Within that file,
-place the following text:
+place the following text::
 
-DEVICE=bond0
-IPADDR=192.168.1.1
-NETMASK=255.255.255.0
-NETWORK=192.168.1.0
-BROADCAST=192.168.1.255
-ONBOOT=yes
-BOOTPROTO=none
-USERCTL=no
+	DEVICE=bond0
+	IPADDR=192.168.1.1
+	NETMASK=255.255.255.0
+	NETWORK=192.168.1.0
+	BROADCAST=192.168.1.255
+	ONBOOT=yes
+	BOOTPROTO=none
+	USERCTL=no
 
-	Be sure to change the networking specific lines (IPADDR,
+Be sure to change the networking specific lines (IPADDR,
 NETMASK, NETWORK and BROADCAST) to match your network configuration.
 
-	For later versions of initscripts, such as that found with Fedora
+For later versions of initscripts, such as that found with Fedora
 7 (or later) and Red Hat Enterprise Linux version 5 (or later), it is possible,
 and, indeed, preferable, to specify the bonding options in the ifcfg-bond0
-file, e.g. a line of the format:
+file, e.g. a line of the format::
 
-BONDING_OPTS="mode=active-backup arp_interval=60 arp_ip_target=192.168.1.254"
+  BONDING_OPTS="mode=active-backup arp_interval=60 arp_ip_target=192.168.1.254"
 
-	will configure the bond with the specified options.  The options
+will configure the bond with the specified options.  The options
 specified in BONDING_OPTS are identical to the bonding module parameters
 except for the arp_ip_target field when using versions of initscripts older
 than and 8.57 (Fedora 8) and 8.45.19 (Red Hat Enterprise Linux 5.2).  When
 using older versions each target should be included as a separate option and
 should be preceded by a '+' to indicate it should be added to the list of
-queried targets, e.g.,
+queried targets, e.g.,::
 
-	arp_ip_target=+192.168.1.1 arp_ip_target=+192.168.1.2
+    arp_ip_target=+192.168.1.1 arp_ip_target=+192.168.1.2
 
-	is the proper syntax to specify multiple targets.  When specifying
-options via BONDING_OPTS, it is not necessary to edit /etc/modprobe.d/*.conf.
+is the proper syntax to specify multiple targets.  When specifying
+options via BONDING_OPTS, it is not necessary to edit
+``/etc/modprobe.d/*.conf``.
 
-	For even older versions of initscripts that do not support
+For even older versions of initscripts that do not support
 BONDING_OPTS, it is necessary to edit /etc/modprobe.d/*.conf, depending upon
 your distro) to load the bonding module with your desired options when the
 bond0 interface is brought up.  The following lines in /etc/modprobe.d/*.conf
 will load the bonding module, and select its options:
 
-alias bond0 bonding
-options bond0 mode=balance-alb miimon=100
+	alias bond0 bonding
+	options bond0 mode=balance-alb miimon=100
 
-	Replace the sample parameters with the appropriate set of
+Replace the sample parameters with the appropriate set of
 options for your configuration.
 
-	Finally run "/etc/rc.d/init.d/network restart" as root.  This
+Finally run "/etc/rc.d/init.d/network restart" as root.  This
 will restart the networking subsystem and your bond link should be now
 up and running.
 
 3.2.1 Using DHCP with Initscripts
 ---------------------------------
 
-	Recent versions of initscripts (the versions supplied with Fedora
+Recent versions of initscripts (the versions supplied with Fedora
 Core 3 and Red Hat Enterprise Linux 4, or later versions, are reported to
 work) have support for assigning IP information to bonding devices via
 DHCP.
 
-	To configure bonding for DHCP, configure it as described
+To configure bonding for DHCP, configure it as described
 above, except replace the line "BOOTPROTO=none" with "BOOTPROTO=dhcp"
 and add a line consisting of "TYPE=Bonding".  Note that the TYPE value
 is case sensitive.
@@ -1278,7 +1290,7 @@ is case sensitive.
 3.2.2 Configuring Multiple Bonds with Initscripts
 -------------------------------------------------
 
-	Initscripts packages that are included with Fedora 7 and Red Hat
+Initscripts packages that are included with Fedora 7 and Red Hat
 Enterprise Linux 5 support multiple bonding interfaces by simply
 specifying the appropriate BONDING_OPTS= in ifcfg-bondX where X is the
 number of the bond.  This support requires sysfs support in the kernel,
@@ -1290,77 +1302,77 @@ below.
 3.3 Configuring Bonding Manually with iproute2
 -----------------------------------------------
 
-	This section applies to distros whose network initialization
+This section applies to distros whose network initialization
 scripts (the sysconfig or initscripts package) do not have specific
 knowledge of bonding.  One such distro is SuSE Linux Enterprise Server
 version 8.
 
-	The general method for these systems is to place the bonding
+The general method for these systems is to place the bonding
 module parameters into a config file in /etc/modprobe.d/ (as
 appropriate for the installed distro), then add modprobe and/or
 `ip link` commands to the system's global init script.  The name of
 the global init script differs; for sysconfig, it is
 /etc/init.d/boot.local and for initscripts it is /etc/rc.d/rc.local.
 
-	For example, if you wanted to make a simple bond of two e100
+For example, if you wanted to make a simple bond of two e100
 devices (presumed to be eth0 and eth1), and have it persist across
 reboots, edit the appropriate file (/etc/init.d/boot.local or
-/etc/rc.d/rc.local), and add the following:
+/etc/rc.d/rc.local), and add the following::
 
-modprobe bonding mode=balance-alb miimon=100
-modprobe e100
-ifconfig bond0 192.168.1.1 netmask 255.255.255.0 up
-ip link set eth0 master bond0
-ip link set eth1 master bond0
+	modprobe bonding mode=balance-alb miimon=100
+	modprobe e100
+	ifconfig bond0 192.168.1.1 netmask 255.255.255.0 up
+	ip link set eth0 master bond0
+	ip link set eth1 master bond0
 
-	Replace the example bonding module parameters and bond0
+Replace the example bonding module parameters and bond0
 network configuration (IP address, netmask, etc) with the appropriate
 values for your configuration.
 
-	Unfortunately, this method will not provide support for the
+Unfortunately, this method will not provide support for the
 ifup and ifdown scripts on the bond devices.  To reload the bonding
-configuration, it is necessary to run the initialization script, e.g.,
+configuration, it is necessary to run the initialization script, e.g.,::
 
-# /etc/init.d/boot.local
+	# /etc/init.d/boot.local
 
-	or
+or::
 
-# /etc/rc.d/rc.local
+	# /etc/rc.d/rc.local
 
-	It may be desirable in such a case to create a separate script
+It may be desirable in such a case to create a separate script
 which only initializes the bonding configuration, then call that
 separate script from within boot.local.  This allows for bonding to be
 enabled without re-running the entire global init script.
 
-	To shut down the bonding devices, it is necessary to first
+To shut down the bonding devices, it is necessary to first
 mark the bonding device itself as being down, then remove the
 appropriate device driver modules.  For our example above, you can do
-the following:
+the following::
 
-# ifconfig bond0 down
-# rmmod bonding
-# rmmod e100
+	# ifconfig bond0 down
+	# rmmod bonding
+	# rmmod e100
 
-	Again, for convenience, it may be desirable to create a script
+Again, for convenience, it may be desirable to create a script
 with these commands.
 
 
 3.3.1 Configuring Multiple Bonds Manually
 -----------------------------------------
 
-	This section contains information on configuring multiple
+This section contains information on configuring multiple
 bonding devices with differing options for those systems whose network
 initialization scripts lack support for configuring multiple bonds.
 
-	If you require multiple bonding devices, but all with the same
+If you require multiple bonding devices, but all with the same
 options, you may wish to use the "max_bonds" module parameter,
 documented above.
 
-	To create multiple bonding devices with differing options, it is
+To create multiple bonding devices with differing options, it is
 preferable to use bonding parameters exported by sysfs, documented in the
 section below.
 
-	For versions of bonding without sysfs support, the only means to
+For versions of bonding without sysfs support, the only means to
 provide multiple instances of bonding with differing options is to load
 the bonding driver multiple times.  Note that current versions of the
 sysconfig network initialization scripts handle this automatically; if
@@ -1368,35 +1380,35 @@ your distro uses these scripts, no special action is needed.  See the
 section Configuring Bonding Devices, above, if you're not sure about your
 network initialization scripts.
 
-	To load multiple instances of the module, it is necessary to
+To load multiple instances of the module, it is necessary to
 specify a different name for each instance (the module loading system
 requires that every loaded module, even multiple instances of the same
 module, have a unique name).  This is accomplished by supplying multiple
-sets of bonding options in /etc/modprobe.d/*.conf, for example:
+sets of bonding options in ``/etc/modprobe.d/*.conf``, for example::
 
-alias bond0 bonding
-options bond0 -o bond0 mode=balance-rr miimon=100
+	alias bond0 bonding
+	options bond0 -o bond0 mode=balance-rr miimon=100
 
-alias bond1 bonding
-options bond1 -o bond1 mode=balance-alb miimon=50
+	alias bond1 bonding
+	options bond1 -o bond1 mode=balance-alb miimon=50
 
-	will load the bonding module two times.  The first instance is
+will load the bonding module two times.  The first instance is
 named "bond0" and creates the bond0 device in balance-rr mode with an
 miimon of 100.  The second instance is named "bond1" and creates the
 bond1 device in balance-alb mode with an miimon of 50.
 
-	In some circumstances (typically with older distributions),
+In some circumstances (typically with older distributions),
 the above does not work, and the second bonding instance never sees
 its options.  In that case, the second options line can be substituted
-as follows:
+as follows::
 
-install bond1 /sbin/modprobe --ignore-install bonding -o bond1 \
-	mode=balance-alb miimon=50
+	install bond1 /sbin/modprobe --ignore-install bonding -o bond1 \
+				     mode=balance-alb miimon=50
 
-	This may be repeated any number of times, specifying a new and
+This may be repeated any number of times, specifying a new and
 unique name in place of bond1 for each subsequent instance.
 
-	It has been observed that some Red Hat supplied kernels are unable
+It has been observed that some Red Hat supplied kernels are unable
 to rename modules at load time (the "-o bond1" part).  Attempts to pass
 that option to modprobe will produce an "Operation not permitted" error.
 This has been reported on some Fedora Core kernels, and has been seen on
@@ -1407,18 +1419,18 @@ kernels, and also lack sysfs support).
 3.4 Configuring Bonding Manually via Sysfs
 ------------------------------------------
 
-	Starting with version 3.0.0, Channel Bonding may be configured
+Starting with version 3.0.0, Channel Bonding may be configured
 via the sysfs interface.  This interface allows dynamic configuration
 of all bonds in the system without unloading the module.  It also
 allows for adding and removing bonds at runtime.  Ifenslave is no
 longer required, though it is still supported.
 
-	Use of the sysfs interface allows you to use multiple bonds
+Use of the sysfs interface allows you to use multiple bonds
 with different configurations without having to reload the module.
 It also allows you to use multiple, differently configured bonds when
 bonding is compiled into the kernel.
 
-	You must have the sysfs filesystem mounted to configure
+You must have the sysfs filesystem mounted to configure
 bonding this way.  The examples in this document assume that you
 are using the standard mount point for sysfs, e.g. /sys.  If your
 sysfs filesystem is mounted elsewhere, you will need to adjust the
@@ -1426,38 +1438,45 @@ example paths accordingly.
 
 Creating and Destroying Bonds
 -----------------------------
-To add a new bond foo:
-# echo +foo > /sys/class/net/bonding_masters
+To add a new bond foo::
 
-To remove an existing bond bar:
-# echo -bar > /sys/class/net/bonding_masters
+	# echo +foo > /sys/class/net/bonding_masters
 
-To show all existing bonds:
-# cat /sys/class/net/bonding_masters
+To remove an existing bond bar::
 
-NOTE: due to 4K size limitation of sysfs files, this list may be
-truncated if you have more than a few hundred bonds.  This is unlikely
-to occur under normal operating conditions.
+	# echo -bar > /sys/class/net/bonding_masters
+
+To show all existing bonds::
+
+	# cat /sys/class/net/bonding_masters
+
+.. note::
+
+   due to 4K size limitation of sysfs files, this list may be
+   truncated if you have more than a few hundred bonds.  This is unlikely
+   to occur under normal operating conditions.
 
 Adding and Removing Slaves
 --------------------------
-	Interfaces may be enslaved to a bond using the file
+Interfaces may be enslaved to a bond using the file
 /sys/class/net/<bond>/bonding/slaves.  The semantics for this file
 are the same as for the bonding_masters file.
 
-To enslave interface eth0 to bond bond0:
-# ifconfig bond0 up
-# echo +eth0 > /sys/class/net/bond0/bonding/slaves
+To enslave interface eth0 to bond bond0::
 
-To free slave eth0 from bond bond0:
-# echo -eth0 > /sys/class/net/bond0/bonding/slaves
+	# ifconfig bond0 up
+	# echo +eth0 > /sys/class/net/bond0/bonding/slaves
 
-	When an interface is enslaved to a bond, symlinks between the
+To free slave eth0 from bond bond0::
+
+	# echo -eth0 > /sys/class/net/bond0/bonding/slaves
+
+When an interface is enslaved to a bond, symlinks between the
 two are created in the sysfs filesystem.  In this case, you would get
 /sys/class/net/bond0/slave_eth0 pointing to /sys/class/net/eth0, and
 /sys/class/net/eth0/master pointing to /sys/class/net/bond0.
 
-	This means that you can tell quickly whether or not an
+This means that you can tell quickly whether or not an
 interface is enslaved by looking for the master symlink.  Thus:
 # echo -eth0 > /sys/class/net/eth0/master/bonding/slaves
 will free eth0 from whatever bond it is enslaved to, regardless of
@@ -1465,127 +1484,143 @@ the name of the bond interface.
 
 Changing a Bond's Configuration
 -------------------------------
-	Each bond may be configured individually by manipulating the
+Each bond may be configured individually by manipulating the
 files located in /sys/class/net/<bond name>/bonding
 
-	The names of these files correspond directly with the command-
+The names of these files correspond directly with the command-
 line parameters described elsewhere in this file, and, with the
 exception of arp_ip_target, they accept the same values.  To see the
 current setting, simply cat the appropriate file.
 
-	A few examples will be given here; for specific usage
+A few examples will be given here; for specific usage
 guidelines for each parameter, see the appropriate section in this
 document.
 
-To configure bond0 for balance-alb mode:
-# ifconfig bond0 down
-# echo 6 > /sys/class/net/bond0/bonding/mode
- - or -
-# echo balance-alb > /sys/class/net/bond0/bonding/mode
-	NOTE: The bond interface must be down before the mode can be
-changed.
-
-To enable MII monitoring on bond0 with a 1 second interval:
-# echo 1000 > /sys/class/net/bond0/bonding/miimon
-	NOTE: If ARP monitoring is enabled, it will disabled when MII
-monitoring is enabled, and vice-versa.
-
-To add ARP targets:
-# echo +192.168.0.100 > /sys/class/net/bond0/bonding/arp_ip_target
-# echo +192.168.0.101 > /sys/class/net/bond0/bonding/arp_ip_target
-	NOTE:  up to 16 target addresses may be specified.
-
-To remove an ARP target:
-# echo -192.168.0.100 > /sys/class/net/bond0/bonding/arp_ip_target
-
-To configure the interval between learning packet transmits:
-# echo 12 > /sys/class/net/bond0/bonding/lp_interval
-	NOTE: the lp_interval is the number of seconds between instances where
-the bonding driver sends learning packets to each slaves peer switch.  The
-default interval is 1 second.
+To configure bond0 for balance-alb mode::
+
+	# ifconfig bond0 down
+	# echo 6 > /sys/class/net/bond0/bonding/mode
+	- or -
+	# echo balance-alb > /sys/class/net/bond0/bonding/mode
+
+.. note::
+
+   The bond interface must be down before the mode can be changed.
+
+To enable MII monitoring on bond0 with a 1 second interval::
+
+	# echo 1000 > /sys/class/net/bond0/bonding/miimon
+
+.. note::
+
+   If ARP monitoring is enabled, it will disabled when MII
+   monitoring is enabled, and vice-versa.
+
+To add ARP targets::
+
+	# echo +192.168.0.100 > /sys/class/net/bond0/bonding/arp_ip_target
+	# echo +192.168.0.101 > /sys/class/net/bond0/bonding/arp_ip_target
+
+.. note::
+
+   up to 16 target addresses may be specified.
+
+To remove an ARP target::
+
+	# echo -192.168.0.100 > /sys/class/net/bond0/bonding/arp_ip_target
+
+To configure the interval between learning packet transmits::
+
+	# echo 12 > /sys/class/net/bond0/bonding/lp_interval
+
+.. note::
+
+   the lp_interval is the number of seconds between instances where
+   the bonding driver sends learning packets to each slaves peer switch.  The
+   default interval is 1 second.
 
 Example Configuration
 ---------------------
-	We begin with the same example that is shown in section 3.3,
+We begin with the same example that is shown in section 3.3,
 executed with sysfs, and without using ifenslave.
 
-	To make a simple bond of two e100 devices (presumed to be eth0
+To make a simple bond of two e100 devices (presumed to be eth0
 and eth1), and have it persist across reboots, edit the appropriate
 file (/etc/init.d/boot.local or /etc/rc.d/rc.local), and add the
-following:
+following::
 
-modprobe bonding
-modprobe e100
-echo balance-alb > /sys/class/net/bond0/bonding/mode
-ifconfig bond0 192.168.1.1 netmask 255.255.255.0 up
-echo 100 > /sys/class/net/bond0/bonding/miimon
-echo +eth0 > /sys/class/net/bond0/bonding/slaves
-echo +eth1 > /sys/class/net/bond0/bonding/slaves
+	modprobe bonding
+	modprobe e100
+	echo balance-alb > /sys/class/net/bond0/bonding/mode
+	ifconfig bond0 192.168.1.1 netmask 255.255.255.0 up
+	echo 100 > /sys/class/net/bond0/bonding/miimon
+	echo +eth0 > /sys/class/net/bond0/bonding/slaves
+	echo +eth1 > /sys/class/net/bond0/bonding/slaves
 
-	To add a second bond, with two e1000 interfaces in
+To add a second bond, with two e1000 interfaces in
 active-backup mode, using ARP monitoring, add the following lines to
-your init script:
+your init script::
 
-modprobe e1000
-echo +bond1 > /sys/class/net/bonding_masters
-echo active-backup > /sys/class/net/bond1/bonding/mode
-ifconfig bond1 192.168.2.1 netmask 255.255.255.0 up
-echo +192.168.2.100 /sys/class/net/bond1/bonding/arp_ip_target
-echo 2000 > /sys/class/net/bond1/bonding/arp_interval
-echo +eth2 > /sys/class/net/bond1/bonding/slaves
-echo +eth3 > /sys/class/net/bond1/bonding/slaves
+	modprobe e1000
+	echo +bond1 > /sys/class/net/bonding_masters
+	echo active-backup > /sys/class/net/bond1/bonding/mode
+	ifconfig bond1 192.168.2.1 netmask 255.255.255.0 up
+	echo +192.168.2.100 /sys/class/net/bond1/bonding/arp_ip_target
+	echo 2000 > /sys/class/net/bond1/bonding/arp_interval
+	echo +eth2 > /sys/class/net/bond1/bonding/slaves
+	echo +eth3 > /sys/class/net/bond1/bonding/slaves
 
 3.5 Configuration with Interfaces Support
 -----------------------------------------
 
-        This section applies to distros which use /etc/network/interfaces file
+This section applies to distros which use /etc/network/interfaces file
 to describe network interface configuration, most notably Debian and it's
 derivatives.
 
-	The ifup and ifdown commands on Debian don't support bonding out of
+The ifup and ifdown commands on Debian don't support bonding out of
 the box. The ifenslave-2.6 package should be installed to provide bonding
-support.  Once installed, this package will provide bond-* options to be used
-into /etc/network/interfaces.
+support.  Once installed, this package will provide ``bond-*`` options
+to be used into /etc/network/interfaces.
 
-	Note that ifenslave-2.6 package will load the bonding module and use
+Note that ifenslave-2.6 package will load the bonding module and use
 the ifenslave command when appropriate.
 
 Example Configurations
 ----------------------
 
 In /etc/network/interfaces, the following stanza will configure bond0, in
-active-backup mode, with eth0 and eth1 as slaves.
+active-backup mode, with eth0 and eth1 as slaves::
 
-auto bond0
-iface bond0 inet dhcp
-	bond-slaves eth0 eth1
-	bond-mode active-backup
-	bond-miimon 100
-	bond-primary eth0 eth1
+	auto bond0
+	iface bond0 inet dhcp
+		bond-slaves eth0 eth1
+		bond-mode active-backup
+		bond-miimon 100
+		bond-primary eth0 eth1
 
 If the above configuration doesn't work, you might have a system using
 upstart for system startup. This is most notably true for recent
 Ubuntu versions. The following stanza in /etc/network/interfaces will
-produce the same result on those systems.
+produce the same result on those systems::
 
-auto bond0
-iface bond0 inet dhcp
-	bond-slaves none
-	bond-mode active-backup
-	bond-miimon 100
+	auto bond0
+	iface bond0 inet dhcp
+		bond-slaves none
+		bond-mode active-backup
+		bond-miimon 100
 
-auto eth0
-iface eth0 inet manual
-	bond-master bond0
-	bond-primary eth0 eth1
+	auto eth0
+	iface eth0 inet manual
+		bond-master bond0
+		bond-primary eth0 eth1
 
-auto eth1
-iface eth1 inet manual
-	bond-master bond0
-	bond-primary eth0 eth1
+	auto eth1
+	iface eth1 inet manual
+		bond-master bond0
+		bond-primary eth0 eth1
 
-For a full list of bond-* supported options in /etc/network/interfaces and some
-more advanced examples tailored to you particular distros, see the files in
+For a full list of ``bond-*`` supported options in /etc/network/interfaces and
+some more advanced examples tailored to you particular distros, see the files in
 /usr/share/doc/ifenslave-2.6.
 
 3.6 Overriding Configuration for Special Cases
@@ -1610,31 +1645,31 @@ tx_queues can be used to change this value.  There is no sysfs parameter
 available as the allocation is done at module init time.
 
 The output of the file /proc/net/bonding/bondX has changed so the output Queue
-ID is now printed for each slave:
+ID is now printed for each slave::
 
-Bonding Mode: fault-tolerance (active-backup)
-Primary Slave: None
-Currently Active Slave: eth0
-MII Status: up
-MII Polling Interval (ms): 0
-Up Delay (ms): 0
-Down Delay (ms): 0
+	Bonding Mode: fault-tolerance (active-backup)
+	Primary Slave: None
+	Currently Active Slave: eth0
+	MII Status: up
+	MII Polling Interval (ms): 0
+	Up Delay (ms): 0
+	Down Delay (ms): 0
 
-Slave Interface: eth0
-MII Status: up
-Link Failure Count: 0
-Permanent HW addr: 00:1a:a0:12:8f:cb
-Slave queue ID: 0
+	Slave Interface: eth0
+	MII Status: up
+	Link Failure Count: 0
+	Permanent HW addr: 00:1a:a0:12:8f:cb
+	Slave queue ID: 0
 
-Slave Interface: eth1
-MII Status: up
-Link Failure Count: 0
-Permanent HW addr: 00:1a:a0:12:8f:cc
-Slave queue ID: 2
+	Slave Interface: eth1
+	MII Status: up
+	Link Failure Count: 0
+	Permanent HW addr: 00:1a:a0:12:8f:cc
+	Slave queue ID: 2
 
-The queue_id for a slave can be set using the command:
+The queue_id for a slave can be set using the command::
 
-# echo "eth1:2" > /sys/class/net/bond0/bonding/queue_id
+	# echo "eth1:2" > /sys/class/net/bond0/bonding/queue_id
 
 Any interface that needs a queue_id set should set it with multiple calls
 like the one above until proper priorities are set for all interfaces.  On
@@ -1645,12 +1680,12 @@ These queue id's can be used in conjunction with the tc utility to configure
 a multiqueue qdisc and filters to bias certain traffic to transmit on certain
 slave devices.  For instance, say we wanted, in the above configuration to
 force all traffic bound to 192.168.1.100 to use eth1 in the bond as its output
-device. The following commands would accomplish this:
+device. The following commands would accomplish this::
 
-# tc qdisc add dev bond0 handle 1 root multiq
+	# tc qdisc add dev bond0 handle 1 root multiq
 
-# tc filter add dev bond0 protocol ip parent 1: prio 1 u32 match ip dst \
-	192.168.1.100 action skbedit queue_mapping 2
+	# tc filter add dev bond0 protocol ip parent 1: prio 1 u32 match ip \
+		dst 192.168.1.100 action skbedit queue_mapping 2
 
 These commands tell the kernel to attach a multiqueue queue discipline to the
 bond0 interface and filter traffic enqueued to it, such that packets with a dst
@@ -1663,7 +1698,7 @@ that normal output policy selection should take place.  One benefit to simply
 leaving the qid for a slave to 0 is the multiqueue awareness in the bonding
 driver that is now present.  This awareness allows tc filters to be placed on
 slave devices as well as bond devices and the bonding driver will simply act as
-a pass-through for selecting output queues on the slave device rather than 
+a pass-through for selecting output queues on the slave device rather than
 output port selection.
 
 This feature first appeared in bonding driver version 3.7.0 and support for
@@ -1689,31 +1724,31 @@ few bonding parameters:
    (a) ad_actor_system : You can set a random mac-address that can be used for
        these LACPDU exchanges. The value can not be either NULL or Multicast.
        Also it's preferable to set the local-admin bit. Following shell code
-       generates a random mac-address as described above.
+       generates a random mac-address as described above::
 
-       # sys_mac_addr=$(printf '%02x:%02x:%02x:%02x:%02x:%02x' \
-                                $(( (RANDOM & 0xFE) | 0x02 )) \
-                                $(( RANDOM & 0xFF )) \
-                                $(( RANDOM & 0xFF )) \
-                                $(( RANDOM & 0xFF )) \
-                                $(( RANDOM & 0xFF )) \
-                                $(( RANDOM & 0xFF )))
-       # echo $sys_mac_addr > /sys/class/net/bond0/bonding/ad_actor_system
+	      # sys_mac_addr=$(printf '%02x:%02x:%02x:%02x:%02x:%02x' \
+				       $(( (RANDOM & 0xFE) | 0x02 )) \
+				       $(( RANDOM & 0xFF )) \
+				       $(( RANDOM & 0xFF )) \
+				       $(( RANDOM & 0xFF )) \
+				       $(( RANDOM & 0xFF )) \
+				       $(( RANDOM & 0xFF )))
+	      # echo $sys_mac_addr > /sys/class/net/bond0/bonding/ad_actor_system
 
    (b) ad_actor_sys_prio : Randomize the system priority. The default value
        is 65535, but system can take the value from 1 - 65535. Following shell
-       code generates random priority and sets it.
+       code generates random priority and sets it::
 
-       # sys_prio=$(( 1 + RANDOM + RANDOM ))
-       # echo $sys_prio > /sys/class/net/bond0/bonding/ad_actor_sys_prio
+	    # sys_prio=$(( 1 + RANDOM + RANDOM ))
+	    # echo $sys_prio > /sys/class/net/bond0/bonding/ad_actor_sys_prio
 
    (c) ad_user_port_key : Use the user portion of the port-key. The default
        keeps this empty. These are the upper 10 bits of the port-key and value
        ranges from 0 - 1023. Following shell code generates these 10 bits and
-       sets it.
+       sets it::
 
-       # usr_port_key=$(( RANDOM & 0x3FF ))
-       # echo $usr_port_key > /sys/class/net/bond0/bonding/ad_user_port_key
+	    # usr_port_key=$(( RANDOM & 0x3FF ))
+	    # echo $usr_port_key > /sys/class/net/bond0/bonding/ad_user_port_key
 
 
 4 Querying Bonding Configuration
@@ -1722,81 +1757,81 @@ few bonding parameters:
 4.1 Bonding Configuration
 -------------------------
 
-	Each bonding device has a read-only file residing in the
+Each bonding device has a read-only file residing in the
 /proc/net/bonding directory.  The file contents include information
 about the bonding configuration, options and state of each slave.
 
-	For example, the contents of /proc/net/bonding/bond0 after the
+For example, the contents of /proc/net/bonding/bond0 after the
 driver is loaded with parameters of mode=0 and miimon=1000 is
-generally as follows:
+generally as follows::
 
 	Ethernet Channel Bonding Driver: 2.6.1 (October 29, 2004)
-        Bonding Mode: load balancing (round-robin)
-        Currently Active Slave: eth0
-        MII Status: up
-        MII Polling Interval (ms): 1000
-        Up Delay (ms): 0
-        Down Delay (ms): 0
+	Bonding Mode: load balancing (round-robin)
+	Currently Active Slave: eth0
+	MII Status: up
+	MII Polling Interval (ms): 1000
+	Up Delay (ms): 0
+	Down Delay (ms): 0
 
-        Slave Interface: eth1
-        MII Status: up
-        Link Failure Count: 1
+	Slave Interface: eth1
+	MII Status: up
+	Link Failure Count: 1
 
-        Slave Interface: eth0
-        MII Status: up
-        Link Failure Count: 1
+	Slave Interface: eth0
+	MII Status: up
+	Link Failure Count: 1
 
-	The precise format and contents will change depending upon the
+The precise format and contents will change depending upon the
 bonding configuration, state, and version of the bonding driver.
 
 4.2 Network configuration
 -------------------------
 
-	The network configuration can be inspected using the ifconfig
+The network configuration can be inspected using the ifconfig
 command.  Bonding devices will have the MASTER flag set; Bonding slave
 devices will have the SLAVE flag set.  The ifconfig output does not
 contain information on which slaves are associated with which masters.
 
-	In the example below, the bond0 interface is the master
+In the example below, the bond0 interface is the master
 (MASTER) while eth0 and eth1 are slaves (SLAVE). Notice all slaves of
 bond0 have the same MAC address (HWaddr) as bond0 for all modes except
-TLB and ALB that require a unique MAC address for each slave.
+TLB and ALB that require a unique MAC address for each slave::
 
-# /sbin/ifconfig
-bond0     Link encap:Ethernet  HWaddr 00:C0:F0:1F:37:B4
-          inet addr:XXX.XXX.XXX.YYY  Bcast:XXX.XXX.XXX.255  Mask:255.255.252.0
-          UP BROADCAST RUNNING MASTER MULTICAST  MTU:1500  Metric:1
-          RX packets:7224794 errors:0 dropped:0 overruns:0 frame:0
-          TX packets:3286647 errors:1 dropped:0 overruns:1 carrier:0
-          collisions:0 txqueuelen:0
+  # /sbin/ifconfig
+  bond0     Link encap:Ethernet  HWaddr 00:C0:F0:1F:37:B4
+	    inet addr:XXX.XXX.XXX.YYY  Bcast:XXX.XXX.XXX.255  Mask:255.255.252.0
+	    UP BROADCAST RUNNING MASTER MULTICAST  MTU:1500  Metric:1
+	    RX packets:7224794 errors:0 dropped:0 overruns:0 frame:0
+	    TX packets:3286647 errors:1 dropped:0 overruns:1 carrier:0
+	    collisions:0 txqueuelen:0
 
-eth0      Link encap:Ethernet  HWaddr 00:C0:F0:1F:37:B4
-          UP BROADCAST RUNNING SLAVE MULTICAST  MTU:1500  Metric:1
-          RX packets:3573025 errors:0 dropped:0 overruns:0 frame:0
-          TX packets:1643167 errors:1 dropped:0 overruns:1 carrier:0
-          collisions:0 txqueuelen:100
-          Interrupt:10 Base address:0x1080
+  eth0      Link encap:Ethernet  HWaddr 00:C0:F0:1F:37:B4
+	    UP BROADCAST RUNNING SLAVE MULTICAST  MTU:1500  Metric:1
+	    RX packets:3573025 errors:0 dropped:0 overruns:0 frame:0
+	    TX packets:1643167 errors:1 dropped:0 overruns:1 carrier:0
+	    collisions:0 txqueuelen:100
+	    Interrupt:10 Base address:0x1080
 
-eth1      Link encap:Ethernet  HWaddr 00:C0:F0:1F:37:B4
-          UP BROADCAST RUNNING SLAVE MULTICAST  MTU:1500  Metric:1
-          RX packets:3651769 errors:0 dropped:0 overruns:0 frame:0
-          TX packets:1643480 errors:0 dropped:0 overruns:0 carrier:0
-          collisions:0 txqueuelen:100
-          Interrupt:9 Base address:0x1400
+  eth1      Link encap:Ethernet  HWaddr 00:C0:F0:1F:37:B4
+	    UP BROADCAST RUNNING SLAVE MULTICAST  MTU:1500  Metric:1
+	    RX packets:3651769 errors:0 dropped:0 overruns:0 frame:0
+	    TX packets:1643480 errors:0 dropped:0 overruns:0 carrier:0
+	    collisions:0 txqueuelen:100
+	    Interrupt:9 Base address:0x1400
 
 5. Switch Configuration
 =======================
 
-	For this section, "switch" refers to whatever system the
+For this section, "switch" refers to whatever system the
 bonded devices are directly connected to (i.e., where the other end of
 the cable plugs into).  This may be an actual dedicated switch device,
 or it may be another regular system (e.g., another computer running
 Linux),
 
-	The active-backup, balance-tlb and balance-alb modes do not
+The active-backup, balance-tlb and balance-alb modes do not
 require any specific configuration of the switch.
 
-	The 802.3ad mode requires that the switch have the appropriate
+The 802.3ad mode requires that the switch have the appropriate
 ports configured as an 802.3ad aggregation.  The precise method used
 to configure this varies from switch to switch, but, for example, a
 Cisco 3550 series switch requires that the appropriate ports first be
@@ -1804,7 +1839,7 @@ grouped together in a single etherchannel instance, then that
 etherchannel is set to mode "lacp" to enable 802.3ad (instead of
 standard EtherChannel).
 
-	The balance-rr, balance-xor and broadcast modes generally
+The balance-rr, balance-xor and broadcast modes generally
 require that the switch have the appropriate ports grouped together.
 The nomenclature for such a group differs between switches, it may be
 called an "etherchannel" (as in the Cisco example, above), a "trunk
@@ -1820,7 +1855,7 @@ with another EtherChannel group.
 6. 802.1q VLAN Support
 ======================
 
-	It is possible to configure VLAN devices over a bond interface
+It is possible to configure VLAN devices over a bond interface
 using the 8021q driver.  However, only packets coming from the 8021q
 driver and passing through bonding will be tagged by default.  Self
 generated packets, for example, bonding's learning packets or ARP
@@ -1829,7 +1864,7 @@ tagged internally by bonding itself.  As a result, bonding must
 "learn" the VLAN IDs configured above it, and use those IDs to tag
 self generated packets.
 
-	For reasons of simplicity, and to support the use of adapters
+For reasons of simplicity, and to support the use of adapters
 that can do VLAN hardware acceleration offloading, the bonding
 interface declares itself as fully hardware offloading capable, it gets
 the add_vid/kill_vid notifications to gather the necessary
@@ -1839,7 +1874,7 @@ should go through an adapter that is not offloading capable are
 "un-accelerated" by the bonding driver so the VLAN tag sits in the
 regular location.
 
-	VLAN interfaces *must* be added on top of a bonding interface
+VLAN interfaces *must* be added on top of a bonding interface
 only after enslaving at least one slave.  The bonding interface has a
 hardware address of 00:00:00:00:00:00 until the first slave is added.
 If the VLAN interface is created prior to the first enslavement, it
@@ -1847,23 +1882,23 @@ would pick up the all-zeroes hardware address.  Once the first slave
 is attached to the bond, the bond device itself will pick up the
 slave's hardware address, which is then available for the VLAN device.
 
-	Also, be aware that a similar problem can occur if all slaves
+Also, be aware that a similar problem can occur if all slaves
 are released from a bond that still has one or more VLAN interfaces on
 top of it.  When a new slave is added, the bonding interface will
 obtain its hardware address from the first slave, which might not
 match the hardware address of the VLAN interfaces (which was
 ultimately copied from an earlier slave).
 
-	There are two methods to insure that the VLAN device operates
+There are two methods to insure that the VLAN device operates
 with the correct hardware address if all slaves are removed from a
 bond interface:
 
-	1. Remove all VLAN interfaces then recreate them
+1. Remove all VLAN interfaces then recreate them
 
-	2. Set the bonding interface's hardware address so that it
+2. Set the bonding interface's hardware address so that it
 matches the hardware address of the VLAN interfaces.
 
-	Note that changing a VLAN interface's HW address would set the
+Note that changing a VLAN interface's HW address would set the
 underlying device -- i.e. the bonding interface -- to promiscuous
 mode, which might not be what you want.
 
@@ -1871,24 +1906,24 @@ mode, which might not be what you want.
 7. Link Monitoring
 ==================
 
-	The bonding driver at present supports two schemes for
+The bonding driver at present supports two schemes for
 monitoring a slave device's link state: the ARP monitor and the MII
 monitor.
 
-	At the present time, due to implementation restrictions in the
+At the present time, due to implementation restrictions in the
 bonding driver itself, it is not possible to enable both ARP and MII
 monitoring simultaneously.
 
 7.1 ARP Monitor Operation
 -------------------------
 
-	The ARP monitor operates as its name suggests: it sends ARP
+The ARP monitor operates as its name suggests: it sends ARP
 queries to one or more designated peer systems on the network, and
 uses the response as an indication that the link is operating.  This
 gives some assurance that traffic is actually flowing to and from one
 or more peers on the local network.
 
-	The ARP monitor relies on the device driver itself to verify
+The ARP monitor relies on the device driver itself to verify
 that traffic is flowing.  In particular, the driver must keep up to
 date the last receive time, dev->last_rx.  Drivers that use NETIF_F_LLTX
 flag must also update netdev_queue->trans_start.  If they do not, then the
@@ -1900,36 +1935,36 @@ your device driver is not updating last_rx and trans_start.
 7.2 Configuring Multiple ARP Targets
 ------------------------------------
 
-	While ARP monitoring can be done with just one target, it can
+While ARP monitoring can be done with just one target, it can
 be useful in a High Availability setup to have several targets to
 monitor.  In the case of just one target, the target itself may go
 down or have a problem making it unresponsive to ARP requests.  Having
 an additional target (or several) increases the reliability of the ARP
 monitoring.
 
-	Multiple ARP targets must be separated by commas as follows:
+Multiple ARP targets must be separated by commas as follows::
 
-# example options for ARP monitoring with three targets
-alias bond0 bonding
-options bond0 arp_interval=60 arp_ip_target=192.168.0.1,192.168.0.3,192.168.0.9
+ # example options for ARP monitoring with three targets
+ alias bond0 bonding
+ options bond0 arp_interval=60 arp_ip_target=192.168.0.1,192.168.0.3,192.168.0.9
 
-	For just a single target the options would resemble:
+For just a single target the options would resemble::
 
-# example options for ARP monitoring with one target
-alias bond0 bonding
-options bond0 arp_interval=60 arp_ip_target=192.168.0.100
+    # example options for ARP monitoring with one target
+    alias bond0 bonding
+    options bond0 arp_interval=60 arp_ip_target=192.168.0.100
 
 
 7.3 MII Monitor Operation
 -------------------------
 
-	The MII monitor monitors only the carrier state of the local
+The MII monitor monitors only the carrier state of the local
 network interface.  It accomplishes this in one of three ways: by
 depending upon the device driver to maintain its carrier state, by
 querying the device's MII registers, or by making an ethtool query to
 the device.
 
-	If the use_carrier module parameter is 1 (the default value),
+If the use_carrier module parameter is 1 (the default value),
 then the MII monitor will rely on the driver for carrier state
 information (via the netif_carrier subsystem).  As explained in the
 use_carrier parameter information, above, if the MII monitor fails to
@@ -1937,7 +1972,7 @@ detect carrier loss on the device (e.g., when the cable is physically
 disconnected), it may be that the driver does not support
 netif_carrier.
 
-	If use_carrier is 0, then the MII monitor will first query the
+If use_carrier is 0, then the MII monitor will first query the
 device's (via ioctl) MII registers and check the link state.  If that
 request fails (not just that it returns carrier down), then the MII
 monitor will make an ethtool ETHOOL_GLINK request to attempt to obtain
@@ -1952,25 +1987,25 @@ up.
 8.1 Adventures in Routing
 -------------------------
 
-	When bonding is configured, it is important that the slave
+When bonding is configured, it is important that the slave
 devices not have routes that supersede routes of the master (or,
 generally, not have routes at all).  For example, suppose the bonding
 device bond0 has two slaves, eth0 and eth1, and the routing table is
-as follows:
+as follows::
 
-Kernel IP routing table
-Destination     Gateway         Genmask         Flags   MSS Window  irtt Iface
-10.0.0.0        0.0.0.0         255.255.0.0     U        40 0          0 eth0
-10.0.0.0        0.0.0.0         255.255.0.0     U        40 0          0 eth1
-10.0.0.0        0.0.0.0         255.255.0.0     U        40 0          0 bond0
-127.0.0.0       0.0.0.0         255.0.0.0       U        40 0          0 lo
+  Kernel IP routing table
+  Destination     Gateway         Genmask         Flags   MSS Window  irtt Iface
+  10.0.0.0        0.0.0.0         255.255.0.0     U        40 0          0 eth0
+  10.0.0.0        0.0.0.0         255.255.0.0     U        40 0          0 eth1
+  10.0.0.0        0.0.0.0         255.255.0.0     U        40 0          0 bond0
+  127.0.0.0       0.0.0.0         255.0.0.0       U        40 0          0 lo
 
-	This routing configuration will likely still update the
+This routing configuration will likely still update the
 receive/transmit times in the driver (needed by the ARP monitor), but
 may bypass the bonding driver (because outgoing traffic to, in this
 case, another host on network 10 would use eth0 or eth1 before bond0).
 
-	The ARP monitor (and ARP itself) may become confused by this
+The ARP monitor (and ARP itself) may become confused by this
 configuration, because ARP requests (generated by the ARP monitor)
 will be sent on one interface (bond0), but the corresponding reply
 will arrive on a different interface (eth0).  This reply looks to ARP
@@ -1978,7 +2013,7 @@ as an unsolicited ARP reply (because ARP matches replies on an
 interface basis), and is discarded.  The MII monitor is not affected
 by the state of the routing table.
 
-	The solution here is simply to insure that slaves do not have
+The solution here is simply to insure that slaves do not have
 routes of their own, and if for some reason they must, those routes do
 not supersede routes of their master.  This should generally be the
 case, but unusual configurations or errant manual or automatic static
@@ -1987,22 +2022,22 @@ route additions may cause trouble.
 8.2 Ethernet Device Renaming
 ----------------------------
 
-	On systems with network configuration scripts that do not
+On systems with network configuration scripts that do not
 associate physical devices directly with network interface names (so
 that the same physical device always has the same "ethX" name), it may
 be necessary to add some special logic to config files in
 /etc/modprobe.d/.
 
-	For example, given a modules.conf containing the following:
+For example, given a modules.conf containing the following::
 
-alias bond0 bonding
-options bond0 mode=some-mode miimon=50
-alias eth0 tg3
-alias eth1 tg3
-alias eth2 e1000
-alias eth3 e1000
+	alias bond0 bonding
+	options bond0 mode=some-mode miimon=50
+	alias eth0 tg3
+	alias eth1 tg3
+	alias eth2 e1000
+	alias eth3 e1000
 
-	If neither eth0 and eth1 are slaves to bond0, then when the
+If neither eth0 and eth1 are slaves to bond0, then when the
 bond0 interface comes up, the devices may end up reordered.  This
 happens because bonding is loaded first, then its slave device's
 drivers are loaded next.  Since no other drivers have been loaded,
@@ -2010,36 +2045,36 @@ when the e1000 driver loads, it will receive eth0 and eth1 for its
 devices, but the bonding configuration tries to enslave eth2 and eth3
 (which may later be assigned to the tg3 devices).
 
-	Adding the following:
+Adding the following::
 
-add above bonding e1000 tg3
+	add above bonding e1000 tg3
 
-	causes modprobe to load e1000 then tg3, in that order, when
+causes modprobe to load e1000 then tg3, in that order, when
 bonding is loaded.  This command is fully documented in the
 modules.conf manual page.
 
-	On systems utilizing modprobe an equivalent problem can occur.
+On systems utilizing modprobe an equivalent problem can occur.
 In this case, the following can be added to config files in
-/etc/modprobe.d/ as:
+/etc/modprobe.d/ as::
 
-softdep bonding pre: tg3 e1000
+	softdep bonding pre: tg3 e1000
 
-	This will load tg3 and e1000 modules before loading the bonding one.
+This will load tg3 and e1000 modules before loading the bonding one.
 Full documentation on this can be found in the modprobe.d and modprobe
 manual pages.
 
 8.3. Painfully Slow Or No Failed Link Detection By Miimon
 ---------------------------------------------------------
 
-	By default, bonding enables the use_carrier option, which
+By default, bonding enables the use_carrier option, which
 instructs bonding to trust the driver to maintain carrier state.
 
-	As discussed in the options section, above, some drivers do
+As discussed in the options section, above, some drivers do
 not support the netif_carrier_on/_off link state tracking system.
 With use_carrier enabled, bonding will always see these links as up,
 regardless of their actual state.
 
-	Additionally, other drivers do support netif_carrier, but do
+Additionally, other drivers do support netif_carrier, but do
 not maintain it in real time, e.g., only polling the link state at
 some fixed interval.  In this case, miimon will detect failures, but
 only after some long period of time has expired.  If it appears that
@@ -2051,7 +2086,7 @@ use_carrier=0 method of querying the registers directly works).  If
 use_carrier=0 does not improve the failover, then the driver may cache
 the registers, or the problem may be elsewhere.
 
-	Also, remember that miimon only checks for the device's
+Also, remember that miimon only checks for the device's
 carrier state.  It has no way to determine the state of devices on or
 beyond other ports of a switch, or if a switch is refusing to pass
 traffic while still maintaining carrier on.
@@ -2059,7 +2094,7 @@ traffic while still maintaining carrier on.
 9. SNMP agents
 ===============
 
-	If running SNMP agents, the bonding driver should be loaded
+If running SNMP agents, the bonding driver should be loaded
 before any network drivers participating in a bond.  This requirement
 is due to the interface index (ipAdEntIfIndex) being associated to
 the first interface found with a given IP address.  That is, there is
@@ -2070,6 +2105,8 @@ with the eth0 interface.  This configuration is shown below, the IP
 address 192.168.1.1 has an interface index of 2 which indexes to eth0
 in the ifDescr table (ifDescr.2).
 
+::
+
      interfaces.ifTable.ifEntry.ifDescr.1 = lo
      interfaces.ifTable.ifEntry.ifDescr.2 = eth0
      interfaces.ifTable.ifEntry.ifDescr.3 = eth1
@@ -2081,7 +2118,7 @@ in the ifDescr table (ifDescr.2).
      ip.ipAddrTable.ipAddrEntry.ipAdEntIfIndex.10.74.20.94 = 4
      ip.ipAddrTable.ipAddrEntry.ipAdEntIfIndex.127.0.0.1 = 1
 
-	This problem is avoided by loading the bonding driver before
+This problem is avoided by loading the bonding driver before
 any network drivers participating in a bond.  Below is an example of
 loading the bonding driver first, the IP address 192.168.1.1 is
 correctly associated with ifDescr.2.
@@ -2097,7 +2134,7 @@ correctly associated with ifDescr.2.
      ip.ipAddrTable.ipAddrEntry.ipAdEntIfIndex.10.74.20.94 = 5
      ip.ipAddrTable.ipAddrEntry.ipAdEntIfIndex.127.0.0.1 = 1
 
-	While some distributions may not report the interface name in
+While some distributions may not report the interface name in
 ifDescr, the association between the IP address and IfIndex remains
 and SNMP functions such as Interface_Scan_Next will report that
 association.
@@ -2105,34 +2142,34 @@ association.
 10. Promiscuous mode
 ====================
 
-	When running network monitoring tools, e.g., tcpdump, it is
+When running network monitoring tools, e.g., tcpdump, it is
 common to enable promiscuous mode on the device, so that all traffic
 is seen (instead of seeing only traffic destined for the local host).
 The bonding driver handles promiscuous mode changes to the bonding
 master device (e.g., bond0), and propagates the setting to the slave
 devices.
 
-	For the balance-rr, balance-xor, broadcast, and 802.3ad modes,
+For the balance-rr, balance-xor, broadcast, and 802.3ad modes,
 the promiscuous mode setting is propagated to all slaves.
 
-	For the active-backup, balance-tlb and balance-alb modes, the
+For the active-backup, balance-tlb and balance-alb modes, the
 promiscuous mode setting is propagated only to the active slave.
 
-	For balance-tlb mode, the active slave is the slave currently
+For balance-tlb mode, the active slave is the slave currently
 receiving inbound traffic.
 
-	For balance-alb mode, the active slave is the slave used as a
+For balance-alb mode, the active slave is the slave used as a
 "primary."  This slave is used for mode-specific control traffic, for
 sending to peers that are unassigned or if the load is unbalanced.
 
-	For the active-backup, balance-tlb and balance-alb modes, when
+For the active-backup, balance-tlb and balance-alb modes, when
 the active slave changes (e.g., due to a link failure), the
 promiscuous setting will be propagated to the new active slave.
 
 11. Configuring Bonding for High Availability
 =============================================
 
-	High Availability refers to configurations that provide
+High Availability refers to configurations that provide
 maximum network availability by having redundant or backup devices,
 links or switches between the host and the rest of the world.  The
 goal is to provide the maximum availability of network connectivity
@@ -2142,7 +2179,7 @@ could provide higher throughput.
 11.1 High Availability in a Single Switch Topology
 --------------------------------------------------
 
-	If two hosts (or a host and a single switch) are directly
+If two hosts (or a host and a single switch) are directly
 connected via multiple physical links, then there is no availability
 penalty to optimizing for maximum bandwidth.  In this case, there is
 only one switch (or peer), so if it fails, there is no alternative
@@ -2150,32 +2187,32 @@ access to fail over to.  Additionally, the bonding load balance modes
 support link monitoring of their members, so if individual links fail,
 the load will be rebalanced across the remaining devices.
 
-	See Section 12, "Configuring Bonding for Maximum Throughput"
+See Section 12, "Configuring Bonding for Maximum Throughput"
 for information on configuring bonding with one peer device.
 
 11.2 High Availability in a Multiple Switch Topology
 ----------------------------------------------------
 
-	With multiple switches, the configuration of bonding and the
+With multiple switches, the configuration of bonding and the
 network changes dramatically.  In multiple switch topologies, there is
 a trade off between network availability and usable bandwidth.
 
-	Below is a sample network, configured to maximize the
-availability of the network:
+Below is a sample network, configured to maximize the
+availability of the network::
 
-                |                                     |
-                |port3                           port3|
-          +-----+----+                          +-----+----+
-          |          |port2       ISL      port2|          |
-          | switch A +--------------------------+ switch B |
-          |          |                          |          |
-          +-----+----+                          +-----++---+
-                |port1                           port1|
-                |             +-------+               |
-                +-------------+ host1 +---------------+
-                         eth0 +-------+ eth1
+		|                                     |
+		|port3                           port3|
+	  +-----+----+                          +-----+----+
+	  |          |port2       ISL      port2|          |
+	  | switch A +--------------------------+ switch B |
+	  |          |                          |          |
+	  +-----+----+                          +-----++---+
+		|port1                           port1|
+		|             +-------+               |
+		+-------------+ host1 +---------------+
+			 eth0 +-------+ eth1
 
-	In this configuration, there is a link between the two
+In this configuration, there is a link between the two
 switches (ISL, or inter switch link), and multiple ports connecting to
 the outside world ("port3" on each switch).  There is no technical
 reason that this could not be extended to a third switch.
@@ -2183,19 +2220,21 @@ reason that this could not be extended to a third switch.
 11.2.1 HA Bonding Mode Selection for Multiple Switch Topology
 -------------------------------------------------------------
 
-	In a topology such as the example above, the active-backup and
+In a topology such as the example above, the active-backup and
 broadcast modes are the only useful bonding modes when optimizing for
 availability; the other modes require all links to terminate on the
 same peer for them to behave rationally.
 
-active-backup: This is generally the preferred mode, particularly if
+active-backup:
+	This is generally the preferred mode, particularly if
 	the switches have an ISL and play together well.  If the
 	network configuration is such that one switch is specifically
 	a backup switch (e.g., has lower capacity, higher cost, etc),
 	then the primary option can be used to insure that the
 	preferred link is always used when it is available.
 
-broadcast: This mode is really a special purpose mode, and is suitable
+broadcast:
+	This mode is really a special purpose mode, and is suitable
 	only for very specific needs.  For example, if the two
 	switches are not connected (no ISL), and the networks beyond
 	them are totally independent.  In this case, if it is
@@ -2205,7 +2244,7 @@ broadcast: This mode is really a special purpose mode, and is suitable
 11.2.2 HA Link Monitoring Selection for Multiple Switch Topology
 ----------------------------------------------------------------
 
-	The choice of link monitoring ultimately depends upon your
+The choice of link monitoring ultimately depends upon your
 switch.  If the switch can reliably fail ports in response to other
 failures, then either the MII or ARP monitors should work.  For
 example, in the above example, if the "port3" link fails at the remote
@@ -2213,7 +2252,7 @@ end, the MII monitor has no direct means to detect this.  The ARP
 monitor could be configured with a target at the remote end of port3,
 thus detecting that failure without switch support.
 
-	In general, however, in a multiple switch topology, the ARP
+In general, however, in a multiple switch topology, the ARP
 monitor can provide a higher level of reliability in detecting end to
 end connectivity failures (which may be caused by the failure of any
 individual component to pass traffic for any reason).  Additionally,
@@ -2222,7 +2261,7 @@ one for each switch in the network).  This will insure that,
 regardless of which switch is active, the ARP monitor has a suitable
 target to query.
 
-	Note, also, that of late many switches now support a functionality
+Note, also, that of late many switches now support a functionality
 generally referred to as "trunk failover."  This is a feature of the
 switch that causes the link state of a particular switch port to be set
 down (or up) when the state of another switch port goes down (or up).
@@ -2238,18 +2277,18 @@ suitable switches.
 12.1 Maximizing Throughput in a Single Switch Topology
 ------------------------------------------------------
 
-	In a single switch configuration, the best method to maximize
+In a single switch configuration, the best method to maximize
 throughput depends upon the application and network environment.  The
 various load balancing modes each have strengths and weaknesses in
 different environments, as detailed below.
 
-	For this discussion, we will break down the topologies into
+For this discussion, we will break down the topologies into
 two categories.  Depending upon the destination of most traffic, we
 categorize them into either "gatewayed" or "local" configurations.
 
-	In a gatewayed configuration, the "switch" is acting primarily
+In a gatewayed configuration, the "switch" is acting primarily
 as a router, and the majority of traffic passes through this router to
-other networks.  An example would be the following:
+other networks.  An example would be the following::
 
 
      +----------+                     +----------+
@@ -2259,25 +2298,25 @@ other networks.  An example would be the following:
      |          |eth1            port2|          | here somewhere
      +----------+                     +----------+
 
-	The router may be a dedicated router device, or another host
+The router may be a dedicated router device, or another host
 acting as a gateway.  For our discussion, the important point is that
 the majority of traffic from Host A will pass through the router to
 some other network before reaching its final destination.
 
-	In a gatewayed network configuration, although Host A may
+In a gatewayed network configuration, although Host A may
 communicate with many other systems, all of its traffic will be sent
 and received via one other peer on the local network, the router.
 
-	Note that the case of two systems connected directly via
+Note that the case of two systems connected directly via
 multiple physical links is, for purposes of configuring bonding, the
 same as a gatewayed configuration.  In that case, it happens that all
 traffic is destined for the "gateway" itself, not some other network
 beyond the gateway.
 
-	In a local configuration, the "switch" is acting primarily as
+In a local configuration, the "switch" is acting primarily as
 a switch, and the majority of traffic passes through this switch to
 reach other stations on the same network.  An example would be the
-following:
+following::
 
     +----------+            +----------+       +--------+
     |          |eth0   port1|          +-------+ Host B |
@@ -2287,19 +2326,19 @@ following:
     +----------+            +----------+port4             +--------+
 
 
-	Again, the switch may be a dedicated switch device, or another
+Again, the switch may be a dedicated switch device, or another
 host acting as a gateway.  For our discussion, the important point is
 that the majority of traffic from Host A is destined for other hosts
 on the same local network (Hosts B and C in the above example).
 
-	In summary, in a gatewayed configuration, traffic to and from
+In summary, in a gatewayed configuration, traffic to and from
 the bonded device will be to the same MAC level peer on the network
 (the gateway itself, i.e., the router), regardless of its final
 destination.  In a local configuration, traffic flows directly to and
 from the final destinations, thus, each destination (Host B, Host C)
 will be addressed directly by their individual MAC addresses.
 
-	This distinction between a gatewayed and a local network
+This distinction between a gatewayed and a local network
 configuration is important because many of the load balancing modes
 available use the MAC addresses of the local network source and
 destination to make load balancing decisions.  The behavior of each
@@ -2309,11 +2348,12 @@ mode is described below.
 12.1.1 MT Bonding Mode Selection for Single Switch Topology
 -----------------------------------------------------------
 
-	This configuration is the easiest to set up and to understand,
+This configuration is the easiest to set up and to understand,
 although you will have to decide which bonding mode best suits your
 needs.  The trade offs for each mode are detailed below:
 
-balance-rr: This mode is the only mode that will permit a single
+balance-rr:
+	This mode is the only mode that will permit a single
 	TCP/IP connection to stripe traffic across multiple
 	interfaces. It is therefore the only mode that will allow a
 	single TCP/IP stream to utilize more than one interface's
@@ -2351,7 +2391,8 @@ balance-rr: This mode is the only mode that will permit a single
 	This mode requires the switch to have the appropriate ports
 	configured for "etherchannel" or "trunking."
 
-active-backup: There is not much advantage in this network topology to
+active-backup:
+	There is not much advantage in this network topology to
 	the active-backup mode, as the inactive backup devices are all
 	connected to the same peer as the primary.  In this case, a
 	load balancing mode (with link monitoring) will provide the
@@ -2361,7 +2402,8 @@ active-backup: There is not much advantage in this network topology to
 	have value if the hardware available does not support any of
 	the load balance modes.
 
-balance-xor: This mode will limit traffic such that packets destined
+balance-xor:
+	This mode will limit traffic such that packets destined
 	for specific peers will always be sent over the same
 	interface.  Since the destination is determined by the MAC
 	addresses involved, this mode works best in a "local" network
@@ -2373,10 +2415,12 @@ balance-xor: This mode will limit traffic such that packets destined
 	As with balance-rr, the switch ports need to be configured for
 	"etherchannel" or "trunking."
 
-broadcast: Like active-backup, there is not much advantage to this
+broadcast:
+	Like active-backup, there is not much advantage to this
 	mode in this type of network topology.
 
-802.3ad: This mode can be a good choice for this type of network
+802.3ad:
+	This mode can be a good choice for this type of network
 	topology.  The 802.3ad mode is an IEEE standard, so all peers
 	that implement 802.3ad should interoperate well.  The 802.3ad
 	protocol includes automatic configuration of the aggregates,
@@ -2390,7 +2434,7 @@ broadcast: Like active-backup, there is not much advantage to this
 	the same speed and duplex.  Also, as with all bonding load
 	balance modes other than balance-rr, no single connection will
 	be able to utilize more than a single interface's worth of
-	bandwidth.  
+	bandwidth.
 
 	Additionally, the linux bonding 802.3ad implementation
 	distributes traffic by peer (using an XOR of MAC addresses
@@ -2404,7 +2448,8 @@ broadcast: Like active-backup, there is not much advantage to this
 	Finally, the 802.3ad mode mandates the use of the MII monitor,
 	therefore, the ARP monitor is not available in this mode.
 
-balance-tlb: The balance-tlb mode balances outgoing traffic by peer.
+balance-tlb:
+	The balance-tlb mode balances outgoing traffic by peer.
 	Since the balancing is done according to MAC address, in a
 	"gatewayed" configuration (as described above), this mode will
 	send all traffic across a single device.  However, in a
@@ -2422,7 +2467,8 @@ balance-tlb: The balance-tlb mode balances outgoing traffic by peer.
 	network device driver of the slave interfaces, and the ARP
 	monitor is not available.
 
-balance-alb: This mode is everything that balance-tlb is, and more.
+balance-alb:
+	This mode is everything that balance-tlb is, and more.
 	It has all of the features (and restrictions) of balance-tlb,
 	and will also balance incoming traffic from local network
 	peers (as described in the Bonding Module Options section,
@@ -2435,7 +2481,7 @@ balance-alb: This mode is everything that balance-tlb is, and more.
 12.1.2 MT Link Monitoring for Single Switch Topology
 ----------------------------------------------------
 
-	The choice of link monitoring may largely depend upon which
+The choice of link monitoring may largely depend upon which
 mode you choose to use.  The more advanced load balancing modes do not
 support the use of the ARP monitor, and are thus restricted to using
 the MII monitor (which does not provide as high a level of end to end
@@ -2444,27 +2490,27 @@ assurance as the ARP monitor).
 12.2 Maximum Throughput in a Multiple Switch Topology
 -----------------------------------------------------
 
-	Multiple switches may be utilized to optimize for throughput
+Multiple switches may be utilized to optimize for throughput
 when they are configured in parallel as part of an isolated network
-between two or more systems, for example:
+between two or more systems, for example::
 
-                       +-----------+
-                       |  Host A   | 
-                       +-+---+---+-+
-                         |   |   |
-                +--------+   |   +---------+
-                |            |             |
-         +------+---+  +-----+----+  +-----+----+
-         | Switch A |  | Switch B |  | Switch C |
-         +------+---+  +-----+----+  +-----+----+
-                |            |             |
-                +--------+   |   +---------+
-                         |   |   |
-                       +-+---+---+-+
-                       |  Host B   | 
-                       +-----------+
+		       +-----------+
+		       |  Host A   |
+		       +-+---+---+-+
+			 |   |   |
+		+--------+   |   +---------+
+		|            |             |
+	 +------+---+  +-----+----+  +-----+----+
+	 | Switch A |  | Switch B |  | Switch C |
+	 +------+---+  +-----+----+  +-----+----+
+		|            |             |
+		+--------+   |   +---------+
+			 |   |   |
+		       +-+---+---+-+
+		       |  Host B   |
+		       +-----------+
 
-	In this configuration, the switches are isolated from one
+In this configuration, the switches are isolated from one
 another.  One reason to employ a topology such as this is for an
 isolated network with many hosts (a cluster configured for high
 performance, for example), using multiple smaller switches can be more
@@ -2472,14 +2518,14 @@ cost effective than a single larger switch, e.g., on a network with 24
 hosts, three 24 port switches can be significantly less expensive than
 a single 72 port switch.
 
-	If access beyond the network is required, an individual host
+If access beyond the network is required, an individual host
 can be equipped with an additional network device connected to an
 external network; this host then additionally acts as a gateway.
 
 12.2.1 MT Bonding Mode Selection for Multiple Switch Topology
 -------------------------------------------------------------
 
-	In actual practice, the bonding mode typically employed in
+In actual practice, the bonding mode typically employed in
 configurations of this type is balance-rr.  Historically, in this
 network configuration, the usual caveats about out of order packet
 delivery are mitigated by the use of network adapters that do not do
@@ -2492,7 +2538,7 @@ utilize greater than one interface's bandwidth.
 12.2.2 MT Link Monitoring for Multiple Switch Topology
 ------------------------------------------------------
 
-	Again, in actual practice, the MII monitor is most often used
+Again, in actual practice, the MII monitor is most often used
 in this configuration, as performance is given preference over
 availability.  The ARP monitor will function in this topology, but its
 advantages over the MII monitor are mitigated by the volume of probes
@@ -2505,10 +2551,10 @@ host in the network is configured with bonding).
 13.1 Link Establishment and Failover Delays
 -------------------------------------------
 
-	Some switches exhibit undesirable behavior with regard to the
+Some switches exhibit undesirable behavior with regard to the
 timing of link up and down reporting by the switch.
 
-	First, when a link comes up, some switches may indicate that
+First, when a link comes up, some switches may indicate that
 the link is up (carrier available), but not pass traffic over the
 interface for some period of time.  This delay is typically due to
 some type of autonegotiation or routing protocol, but may also occur
@@ -2517,12 +2563,12 @@ failure).  If you find this to be a problem, specify an appropriate
 value to the updelay bonding module option to delay the use of the
 relevant interface(s).
 
-	Second, some switches may "bounce" the link state one or more
+Second, some switches may "bounce" the link state one or more
 times while a link is changing state.  This occurs most commonly while
 the switch is initializing.  Again, an appropriate updelay value may
 help.
 
-	Note that when a bonding interface has no active links, the
+Note that when a bonding interface has no active links, the
 driver will immediately reuse the first link that goes up, even if the
 updelay parameter has been specified (the updelay is ignored in this
 case).  If there are slave interfaces waiting for the updelay timeout
@@ -2532,7 +2578,7 @@ value of updelay has been overestimated, and since this occurs only in
 cases with no connectivity, there is no additional penalty for
 ignoring the updelay.
 
-	In addition to the concerns about switch timings, if your
+In addition to the concerns about switch timings, if your
 switches take a long time to go into backup mode, it may be desirable
 to not activate a backup interface immediately after a link goes down.
 Failover may be delayed via the downdelay bonding module option.
@@ -2540,31 +2586,31 @@ Failover may be delayed via the downdelay bonding module option.
 13.2 Duplicated Incoming Packets
 --------------------------------
 
-	NOTE: Starting with version 3.0.2, the bonding driver has logic to
+NOTE: Starting with version 3.0.2, the bonding driver has logic to
 suppress duplicate packets, which should largely eliminate this problem.
 The following description is kept for reference.
 
-	It is not uncommon to observe a short burst of duplicated
+It is not uncommon to observe a short burst of duplicated
 traffic when the bonding device is first used, or after it has been
 idle for some period of time.  This is most easily observed by issuing
 a "ping" to some other host on the network, and noticing that the
 output from ping flags duplicates (typically one per slave).
 
-	For example, on a bond in active-backup mode with five slaves
-all connected to one switch, the output may appear as follows:
+For example, on a bond in active-backup mode with five slaves
+all connected to one switch, the output may appear as follows::
 
-# ping -n 10.0.4.2
-PING 10.0.4.2 (10.0.4.2) from 10.0.3.10 : 56(84) bytes of data.
-64 bytes from 10.0.4.2: icmp_seq=1 ttl=64 time=13.7 ms
-64 bytes from 10.0.4.2: icmp_seq=1 ttl=64 time=13.8 ms (DUP!)
-64 bytes from 10.0.4.2: icmp_seq=1 ttl=64 time=13.8 ms (DUP!)
-64 bytes from 10.0.4.2: icmp_seq=1 ttl=64 time=13.8 ms (DUP!)
-64 bytes from 10.0.4.2: icmp_seq=1 ttl=64 time=13.8 ms (DUP!)
-64 bytes from 10.0.4.2: icmp_seq=2 ttl=64 time=0.216 ms
-64 bytes from 10.0.4.2: icmp_seq=3 ttl=64 time=0.267 ms
-64 bytes from 10.0.4.2: icmp_seq=4 ttl=64 time=0.222 ms
+	# ping -n 10.0.4.2
+	PING 10.0.4.2 (10.0.4.2) from 10.0.3.10 : 56(84) bytes of data.
+	64 bytes from 10.0.4.2: icmp_seq=1 ttl=64 time=13.7 ms
+	64 bytes from 10.0.4.2: icmp_seq=1 ttl=64 time=13.8 ms (DUP!)
+	64 bytes from 10.0.4.2: icmp_seq=1 ttl=64 time=13.8 ms (DUP!)
+	64 bytes from 10.0.4.2: icmp_seq=1 ttl=64 time=13.8 ms (DUP!)
+	64 bytes from 10.0.4.2: icmp_seq=1 ttl=64 time=13.8 ms (DUP!)
+	64 bytes from 10.0.4.2: icmp_seq=2 ttl=64 time=0.216 ms
+	64 bytes from 10.0.4.2: icmp_seq=3 ttl=64 time=0.267 ms
+	64 bytes from 10.0.4.2: icmp_seq=4 ttl=64 time=0.222 ms
 
-	This is not due to an error in the bonding driver, rather, it
+This is not due to an error in the bonding driver, rather, it
 is a side effect of how many switches update their MAC forwarding
 tables.  Initially, the switch does not associate the MAC address in
 the packet with a particular switch port, and so it may send the
@@ -2574,7 +2620,7 @@ single switch, when the switch (temporarily) floods the traffic to all
 ports, the bond device receives multiple copies of the same packet
 (one per slave device).
 
-	The duplicated packet behavior is switch dependent, some
+The duplicated packet behavior is switch dependent, some
 switches exhibit this, and some do not.  On switches that display this
 behavior, it can be induced by clearing the MAC forwarding table (on
 most Cisco switches, the privileged command "clear mac address-table
@@ -2583,16 +2629,16 @@ dynamic" will accomplish this).
 14. Hardware Specific Considerations
 ====================================
 
-	This section contains additional information for configuring
+This section contains additional information for configuring
 bonding on specific hardware platforms, or for interfacing bonding
 with particular switches or other devices.
 
 14.1 IBM BladeCenter
 --------------------
 
-	This applies to the JS20 and similar systems.
+This applies to the JS20 and similar systems.
 
-	On the JS20 blades, the bonding driver supports only
+On the JS20 blades, the bonding driver supports only
 balance-rr, active-backup, balance-tlb and balance-alb modes.  This is
 largely due to the network topology inside the BladeCenter, detailed
 below.
@@ -2600,7 +2646,7 @@ below.
 JS20 network adapter information
 --------------------------------
 
-	All JS20s come with two Broadcom Gigabit Ethernet ports
+All JS20s come with two Broadcom Gigabit Ethernet ports
 integrated on the planar (that's "motherboard" in IBM-speak).  In the
 BladeCenter chassis, the eth0 port of all JS20 blades is hard wired to
 I/O Module #1; similarly, all eth1 ports are wired to I/O Module #2.
@@ -2608,36 +2654,36 @@ An add-on Broadcom daughter card can be installed on a JS20 to provide
 two more Gigabit Ethernet ports.  These ports, eth2 and eth3, are
 wired to I/O Modules 3 and 4, respectively.
 
-	Each I/O Module may contain either a switch or a passthrough
+Each I/O Module may contain either a switch or a passthrough
 module (which allows ports to be directly connected to an external
 switch).  Some bonding modes require a specific BladeCenter internal
 network topology in order to function; these are detailed below.
 
-	Additional BladeCenter-specific networking information can be
+Additional BladeCenter-specific networking information can be
 found in two IBM Redbooks (www.ibm.com/redbooks):
 
-"IBM eServer BladeCenter Networking Options"
-"IBM eServer BladeCenter Layer 2-7 Network Switching"
+- "IBM eServer BladeCenter Networking Options"
+- "IBM eServer BladeCenter Layer 2-7 Network Switching"
 
 BladeCenter networking configuration
 ------------------------------------
 
-	Because a BladeCenter can be configured in a very large number
+Because a BladeCenter can be configured in a very large number
 of ways, this discussion will be confined to describing basic
 configurations.
 
-	Normally, Ethernet Switch Modules (ESMs) are used in I/O
+Normally, Ethernet Switch Modules (ESMs) are used in I/O
 modules 1 and 2.  In this configuration, the eth0 and eth1 ports of a
 JS20 will be connected to different internal switches (in the
 respective I/O modules).
 
-	A passthrough module (OPM or CPM, optical or copper,
+A passthrough module (OPM or CPM, optical or copper,
 passthrough module) connects the I/O module directly to an external
 switch.  By using PMs in I/O module #1 and #2, the eth0 and eth1
 interfaces of a JS20 can be redirected to the outside world and
 connected to a common external switch.
 
-	Depending upon the mix of ESMs and PMs, the network will
+Depending upon the mix of ESMs and PMs, the network will
 appear to bonding as either a single switch topology (all PMs) or as a
 multiple switch topology (one or more ESMs, zero or more PMs).  It is
 also possible to connect ESMs together, resulting in a configuration
@@ -2647,24 +2693,24 @@ Topology," above.
 Requirements for specific modes
 -------------------------------
 
-	The balance-rr mode requires the use of passthrough modules
+The balance-rr mode requires the use of passthrough modules
 for devices in the bond, all connected to an common external switch.
 That switch must be configured for "etherchannel" or "trunking" on the
 appropriate ports, as is usual for balance-rr.
 
-	The balance-alb and balance-tlb modes will function with
+The balance-alb and balance-tlb modes will function with
 either switch modules or passthrough modules (or a mix).  The only
 specific requirement for these modes is that all network interfaces
 must be able to reach all destinations for traffic sent over the
 bonding device (i.e., the network must converge at some point outside
 the BladeCenter).
 
-	The active-backup mode has no additional requirements.
+The active-backup mode has no additional requirements.
 
 Link monitoring issues
 ----------------------
 
-	When an Ethernet Switch Module is in place, only the ARP
+When an Ethernet Switch Module is in place, only the ARP
 monitor will reliably detect link loss to an external switch.  This is
 nothing unusual, but examination of the BladeCenter cabinet would
 suggest that the "external" network ports are the ethernet ports for
@@ -2672,166 +2718,173 @@ the system, when it fact there is a switch between these "external"
 ports and the devices on the JS20 system itself.  The MII monitor is
 only able to detect link failures between the ESM and the JS20 system.
 
-	When a passthrough module is in place, the MII monitor does
+When a passthrough module is in place, the MII monitor does
 detect failures to the "external" port, which is then directly
 connected to the JS20 system.
 
 Other concerns
 --------------
 
-	The Serial Over LAN (SoL) link is established over the primary
+The Serial Over LAN (SoL) link is established over the primary
 ethernet (eth0) only, therefore, any loss of link to eth0 will result
 in losing your SoL connection.  It will not fail over with other
 network traffic, as the SoL system is beyond the control of the
 bonding driver.
 
-	It may be desirable to disable spanning tree on the switch
+It may be desirable to disable spanning tree on the switch
 (either the internal Ethernet Switch Module, or an external switch) to
 avoid fail-over delay issues when using bonding.
 
-	
+
 15. Frequently Asked Questions
 ==============================
 
 1.  Is it SMP safe?
+-------------------
 
-	Yes. The old 2.0.xx channel bonding patch was not SMP safe.
+Yes. The old 2.0.xx channel bonding patch was not SMP safe.
 The new driver was designed to be SMP safe from the start.
 
 2.  What type of cards will work with it?
+-----------------------------------------
 
-	Any Ethernet type cards (you can even mix cards - a Intel
+Any Ethernet type cards (you can even mix cards - a Intel
 EtherExpress PRO/100 and a 3com 3c905b, for example).  For most modes,
 devices need not be of the same speed.
 
-	Starting with version 3.2.1, bonding also supports Infiniband
+Starting with version 3.2.1, bonding also supports Infiniband
 slaves in active-backup mode.
 
 3.  How many bonding devices can I have?
+----------------------------------------
 
-	There is no limit.
+There is no limit.
 
 4.  How many slaves can a bonding device have?
+----------------------------------------------
 
-	This is limited only by the number of network interfaces Linux
+This is limited only by the number of network interfaces Linux
 supports and/or the number of network cards you can place in your
 system.
 
 5.  What happens when a slave link dies?
+----------------------------------------
 
-	If link monitoring is enabled, then the failing device will be
+If link monitoring is enabled, then the failing device will be
 disabled.  The active-backup mode will fail over to a backup link, and
 other modes will ignore the failed link.  The link will continue to be
 monitored, and should it recover, it will rejoin the bond (in whatever
 manner is appropriate for the mode). See the sections on High
 Availability and the documentation for each mode for additional
 information.
-	
-	Link monitoring can be enabled via either the miimon or
+
+Link monitoring can be enabled via either the miimon or
 arp_interval parameters (described in the module parameters section,
 above).  In general, miimon monitors the carrier state as sensed by
 the underlying network device, and the arp monitor (arp_interval)
 monitors connectivity to another host on the local network.
 
-	If no link monitoring is configured, the bonding driver will
+If no link monitoring is configured, the bonding driver will
 be unable to detect link failures, and will assume that all links are
 always available.  This will likely result in lost packets, and a
 resulting degradation of performance.  The precise performance loss
 depends upon the bonding mode and network configuration.
 
 6.  Can bonding be used for High Availability?
+----------------------------------------------
 
-	Yes.  See the section on High Availability for details.
+Yes.  See the section on High Availability for details.
 
 7.  Which switches/systems does it work with?
+---------------------------------------------
 
-	The full answer to this depends upon the desired mode.
+The full answer to this depends upon the desired mode.
 
-	In the basic balance modes (balance-rr and balance-xor), it
+In the basic balance modes (balance-rr and balance-xor), it
 works with any system that supports etherchannel (also called
 trunking).  Most managed switches currently available have such
 support, and many unmanaged switches as well.
 
-	The advanced balance modes (balance-tlb and balance-alb) do
+The advanced balance modes (balance-tlb and balance-alb) do
 not have special switch requirements, but do need device drivers that
 support specific features (described in the appropriate section under
 module parameters, above).
 
-	In 802.3ad mode, it works with systems that support IEEE
+In 802.3ad mode, it works with systems that support IEEE
 802.3ad Dynamic Link Aggregation.  Most managed and many unmanaged
 switches currently available support 802.3ad.
 
-        The active-backup mode should work with any Layer-II switch.
+The active-backup mode should work with any Layer-II switch.
 
 8.  Where does a bonding device get its MAC address from?
+---------------------------------------------------------
 
-	When using slave devices that have fixed MAC addresses, or when
+When using slave devices that have fixed MAC addresses, or when
 the fail_over_mac option is enabled, the bonding device's MAC address is
 the MAC address of the active slave.
 
-	For other configurations, if not explicitly configured (with
+For other configurations, if not explicitly configured (with
 ifconfig or ip link), the MAC address of the bonding device is taken from
 its first slave device.  This MAC address is then passed to all following
 slaves and remains persistent (even if the first slave is removed) until
 the bonding device is brought down or reconfigured.
 
-	If you wish to change the MAC address, you can set it with
-ifconfig or ip link:
+If you wish to change the MAC address, you can set it with
+ifconfig or ip link::
 
-# ifconfig bond0 hw ether 00:11:22:33:44:55
+	# ifconfig bond0 hw ether 00:11:22:33:44:55
 
-# ip link set bond0 address 66:77:88:99:aa:bb
+	# ip link set bond0 address 66:77:88:99:aa:bb
 
-	The MAC address can be also changed by bringing down/up the
-device and then changing its slaves (or their order):
+The MAC address can be also changed by bringing down/up the
+device and then changing its slaves (or their order)::
 
-# ifconfig bond0 down ; modprobe -r bonding
-# ifconfig bond0 .... up
-# ifenslave bond0 eth...
+	# ifconfig bond0 down ; modprobe -r bonding
+	# ifconfig bond0 .... up
+	# ifenslave bond0 eth...
 
-	This method will automatically take the address from the next
+This method will automatically take the address from the next
 slave that is added.
 
-	To restore your slaves' MAC addresses, you need to detach them
-from the bond (`ifenslave -d bond0 eth0'). The bonding driver will
+To restore your slaves' MAC addresses, you need to detach them
+from the bond (``ifenslave -d bond0 eth0``). The bonding driver will
 then restore the MAC addresses that the slaves had before they were
 enslaved.
 
 16. Resources and Links
 =======================
 
-	The latest version of the bonding driver can be found in the latest
+The latest version of the bonding driver can be found in the latest
 version of the linux kernel, found on http://kernel.org
 
-	The latest version of this document can be found in the latest kernel
-source (named Documentation/networking/bonding.txt).
+The latest version of this document can be found in the latest kernel
+source (named Documentation/networking/bonding.rst).
 
-	Discussions regarding the usage of the bonding driver take place on the
+Discussions regarding the usage of the bonding driver take place on the
 bonding-devel mailing list, hosted at sourceforge.net. If you have questions or
 problems, post them to the list.  The list address is:
 
 bonding-devel@lists.sourceforge.net
 
-	The administrative interface (to subscribe or unsubscribe) can
+The administrative interface (to subscribe or unsubscribe) can
 be found at:
 
 https://lists.sourceforge.net/lists/listinfo/bonding-devel
 
-	Discussions regarding the development of the bonding driver take place
+Discussions regarding the development of the bonding driver take place
 on the main Linux network mailing list, hosted at vger.kernel.org. The list
 address is:
 
 netdev@vger.kernel.org
 
-	The administrative interface (to subscribe or unsubscribe) can
+The administrative interface (to subscribe or unsubscribe) can
 be found at:
 
 http://vger.kernel.org/vger-lists.html#netdev
 
 Donald Becker's Ethernet Drivers and diag programs may be found at :
- - http://web.archive.org/web/*/http://www.scyld.com/network/ 
+
+ - http://web.archive.org/web/%2E/http://www.scyld.com/network/
 
 You will also find a lot of information regarding Ethernet, NWay, MII,
 etc. at www.scyld.com.
-
--- END --
diff --git a/Documentation/networking/device_drivers/intel/e100.rst b/Documentation/networking/device_drivers/intel/e100.rst
index caf023cc88de..3ac21e7119a7 100644
--- a/Documentation/networking/device_drivers/intel/e100.rst
+++ b/Documentation/networking/device_drivers/intel/e100.rst
@@ -33,7 +33,7 @@ The following features are now available in supported kernels:
  - SNMP
 
 Channel Bonding documentation can be found in the Linux kernel source:
-/Documentation/networking/bonding.txt
+/Documentation/networking/bonding.rst
 
 
 Identifying Your Adapter
diff --git a/Documentation/networking/device_drivers/intel/ixgb.rst b/Documentation/networking/device_drivers/intel/ixgb.rst
index 945018207a92..ab624f1a44a8 100644
--- a/Documentation/networking/device_drivers/intel/ixgb.rst
+++ b/Documentation/networking/device_drivers/intel/ixgb.rst
@@ -37,7 +37,7 @@ The following features are available in this kernel:
  - SNMP
 
 Channel Bonding documentation can be found in the Linux kernel source:
-/Documentation/networking/bonding.txt
+/Documentation/networking/bonding.rst
 
 The driver information previously displayed in the /proc filesystem is not
 supported in this release.  Alternatively, you can use ethtool (version 1.6
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index fbf845fbaff7..22b872834ef0 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -44,6 +44,7 @@ Contents:
    atm
    ax25
    baycom
+   bonding
 
 .. only::  subproject and html
 
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index b103fbdd0f68..4ab6d343fd86 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -50,7 +50,7 @@ config BONDING
 	  The driver supports multiple bonding modes to allow for both high
 	  performance and high availability operation.
 
-	  Refer to <file:Documentation/networking/bonding.txt> for more
+	  Refer to <file:Documentation/networking/bonding.rst> for more
 	  information.
 
 	  To compile this driver as a module, choose M here: the module
-- 
2.25.4

