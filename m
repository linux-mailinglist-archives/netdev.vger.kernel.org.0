Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 510411C18A5
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729814AbgEAOse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 10:48:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:52676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729375AbgEAOpI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 10:45:08 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F210424957;
        Fri,  1 May 2020 14:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588344305;
        bh=VMY4rTaMjFiAbEot2p58ZYqw+5MMQ8SFn49S3iC3TiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KLH3o1S11gwM0xok1neh+nlU/5gFvdKfbfwmKCYmFxnFYK5GyAAvcfqD50kfEawfY
         0wEBIDZF5b80oAEy0xk9AwzJkUIG/BYGEPDGdaqRn1wrzXb0Vo2tpKkUcMEGXmXtFW
         0E1FNBp1kFlnjyQvqfedKIdOVLWoYsRXr3Ky5umE=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUWuT-00FCeD-P7; Fri, 01 May 2020 16:45:01 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 21/37] docs: networking: device drivers: convert dlink/dl2k.txt to ReST
Date:   Fri,  1 May 2020 16:44:43 +0200
Message-Id: <5c65b062416ecdac93cf12826ea04d95776cf8c4.1588344146.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588344146.git.mchehab+huawei@kernel.org>
References: <cover.1588344146.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- mark code blocks and literals as such;
- mark lists as such;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../dlink/{dl2k.txt => dl2k.rst}              | 228 ++++++++++--------
 .../networking/device_drivers/index.rst       |   1 +
 drivers/net/ethernet/dlink/dl2k.c             |   2 +-
 3 files changed, 132 insertions(+), 99 deletions(-)
 rename Documentation/networking/device_drivers/dlink/{dl2k.txt => dl2k.rst} (59%)

diff --git a/Documentation/networking/device_drivers/dlink/dl2k.txt b/Documentation/networking/device_drivers/dlink/dl2k.rst
similarity index 59%
rename from Documentation/networking/device_drivers/dlink/dl2k.txt
rename to Documentation/networking/device_drivers/dlink/dl2k.rst
index cba74f7a3abc..ccdb5d0d7460 100644
--- a/Documentation/networking/device_drivers/dlink/dl2k.txt
+++ b/Documentation/networking/device_drivers/dlink/dl2k.rst
@@ -1,10 +1,13 @@
+.. SPDX-License-Identifier: GPL-2.0
 
-    D-Link DL2000-based Gigabit Ethernet Adapter Installation
-    for Linux
-    May 23, 2002
+=========================================================
+D-Link DL2000-based Gigabit Ethernet Adapter Installation
+=========================================================
+
+May 23, 2002
+
+.. Contents
 
-Contents
-========
  - Compatibility List
  - Quick Install
  - Compiling the Driver
@@ -15,12 +18,13 @@ Contents
 
 
 Compatibility List
-=================
+==================
+
 Adapter Support:
 
-D-Link DGE-550T Gigabit Ethernet Adapter.
-D-Link DGE-550SX Gigabit Ethernet Adapter.
-D-Link DL2000-based Gigabit Ethernet Adapter.
+- D-Link DGE-550T Gigabit Ethernet Adapter.
+- D-Link DGE-550SX Gigabit Ethernet Adapter.
+- D-Link DL2000-based Gigabit Ethernet Adapter.
 
 
 The driver support Linux kernel 2.4.7 later. We had tested it
@@ -34,28 +38,32 @@ on the environments below.
 
 Quick Install
 =============
-Install linux driver as following command:
+Install linux driver as following command::
+
+    1. make all
+    2. insmod dl2k.ko
+    3. ifconfig eth0 up 10.xxx.xxx.xxx netmask 255.0.0.0
+			^^^^^^^^^^^^^^^\	    ^^^^^^^^\
+					IP		     NETMASK
 
-1. make all
-2. insmod dl2k.ko
-3. ifconfig eth0 up 10.xxx.xxx.xxx netmask 255.0.0.0
-		    ^^^^^^^^^^^^^^^\	    ^^^^^^^^\
-				    IP		     NETMASK
 Now eth0 should active, you can test it by "ping" or get more information by
 "ifconfig". If tested ok, continue the next step.
 
-4. cp dl2k.ko /lib/modules/`uname -r`/kernel/drivers/net
-5. Add the following line to /etc/modprobe.d/dl2k.conf:
+4. ``cp dl2k.ko /lib/modules/`uname -r`/kernel/drivers/net``
+5. Add the following line to /etc/modprobe.d/dl2k.conf::
+
 	alias eth0 dl2k
-6. Run depmod to updated module indexes.
-7. Run "netconfig" or "netconf" to create configuration script ifcfg-eth0
+
+6. Run ``depmod`` to updated module indexes.
+7. Run ``netconfig`` or ``netconf`` to create configuration script ifcfg-eth0
    located at /etc/sysconfig/network-scripts or create it manually.
+
    [see - Configuration Script Sample]
 8. Driver will automatically load and configure at next boot time.
 
 Compiling the Driver
 ====================
-  In Linux, NIC drivers are most commonly configured as loadable modules.
+In Linux, NIC drivers are most commonly configured as loadable modules.
 The approach of building a monolithic kernel has become obsolete. The driver
 can be compiled as part of a monolithic kernel, but is strongly discouraged.
 The remainder of this section assumes the driver is built as a loadable module.
@@ -73,93 +81,108 @@ to compile and link the driver:
 CD-ROM drive
 ------------
 
-[root@XXX /] mkdir cdrom
-[root@XXX /] mount -r -t iso9660 -o conv=auto /dev/cdrom /cdrom
-[root@XXX /] cd root
-[root@XXX /root] mkdir dl2k
-[root@XXX /root] cd dl2k
-[root@XXX dl2k] cp /cdrom/linux/dl2k.tgz /root/dl2k
-[root@XXX dl2k] tar xfvz dl2k.tgz
-[root@XXX dl2k] make all
+::
+
+    [root@XXX /] mkdir cdrom
+    [root@XXX /] mount -r -t iso9660 -o conv=auto /dev/cdrom /cdrom
+    [root@XXX /] cd root
+    [root@XXX /root] mkdir dl2k
+    [root@XXX /root] cd dl2k
+    [root@XXX dl2k] cp /cdrom/linux/dl2k.tgz /root/dl2k
+    [root@XXX dl2k] tar xfvz dl2k.tgz
+    [root@XXX dl2k] make all
 
 Floppy disc drive
 -----------------
 
-[root@XXX /] cd root
-[root@XXX /root] mkdir dl2k
-[root@XXX /root] cd dl2k
-[root@XXX dl2k] mcopy a:/linux/dl2k.tgz /root/dl2k
-[root@XXX dl2k] tar xfvz dl2k.tgz
-[root@XXX dl2k] make all
+::
+
+    [root@XXX /] cd root
+    [root@XXX /root] mkdir dl2k
+    [root@XXX /root] cd dl2k
+    [root@XXX dl2k] mcopy a:/linux/dl2k.tgz /root/dl2k
+    [root@XXX dl2k] tar xfvz dl2k.tgz
+    [root@XXX dl2k] make all
 
 Installing the Driver
 =====================
 
-  Manual Installation
-  -------------------
+Manual Installation
+-------------------
+
   Once the driver has been compiled, it must be loaded, enabled, and bound
   to a protocol stack in order to establish network connectivity. To load a
-  module enter the command:
+  module enter the command::
 
-  insmod dl2k.o
+    insmod dl2k.o
 
-  or
+  or::
 
-  insmod dl2k.o <optional parameter>	; add parameter
+    insmod dl2k.o <optional parameter>	; add parameter
 
-  ===============================================================
-   example: insmod dl2k.o media=100mbps_hd
-   or	    insmod dl2k.o media=3
-   or	    insmod dl2k.o media=3,2	; for 2 cards
-  ===============================================================
+---------------------------------------------------------
+
+  example::
+
+    insmod dl2k.o media=100mbps_hd
+
+   or::
+
+    insmod dl2k.o media=3
+
+   or::
+
+    insmod dl2k.o media=3,2	; for 2 cards
+
+---------------------------------------------------------
 
   Please reference the list of the command line parameters supported by
   the Linux device driver below.
 
   The insmod command only loads the driver and gives it a name of the form
   eth0, eth1, etc. To bring the NIC into an operational state,
-  it is necessary to issue the following command:
+  it is necessary to issue the following command::
 
-  ifconfig eth0 up
+    ifconfig eth0 up
 
   Finally, to bind the driver to the active protocol (e.g., TCP/IP with
-  Linux), enter the following command:
+  Linux), enter the following command::
 
-  ifup eth0
+    ifup eth0
 
   Note that this is meaningful only if the system can find a configuration
   script that contains the necessary network information. A sample will be
   given in the next paragraph.
 
-  The commands to unload a driver are as follows:
+  The commands to unload a driver are as follows::
 
-  ifdown eth0
-  ifconfig eth0 down
-  rmmod dl2k.o
+    ifdown eth0
+    ifconfig eth0 down
+    rmmod dl2k.o
 
   The following are the commands to list the currently loaded modules and
-  to see the current network configuration.
+  to see the current network configuration::
 
-  lsmod
-  ifconfig
+    lsmod
+    ifconfig
 
 
-  Automated Installation
-  ----------------------
+Automated Installation
+----------------------
   This section describes how to install the driver such that it is
   automatically loaded and configured at boot time. The following description
   is based on a Red Hat 6.0/7.0 distribution, but it can easily be ported to
   other distributions as well.
 
-  Red Hat v6.x/v7.x
-  -----------------
+Red Hat v6.x/v7.x
+-----------------
   1. Copy dl2k.o to the network modules directory, typically
      /lib/modules/2.x.x-xx/net or /lib/modules/2.x.x/kernel/drivers/net.
   2. Locate the boot module configuration file, most commonly in the
-     /etc/modprobe.d/ directory. Add the following lines:
+     /etc/modprobe.d/ directory. Add the following lines::
 
-     alias ethx dl2k
-     options dl2k <optional parameters>
+	alias ethx dl2k
+	options dl2k <optional parameters>
 
      where ethx will be eth0 if the NIC is the only ethernet adapter, eth1 if
      one other ethernet adapter is installed, etc. Refer to the table in the
@@ -180,11 +203,15 @@ parameter. Below is a list of the command line parameters supported by the
 Linux device
 driver.
 
-mtu=packet_size			- Specifies the maximum packet size. default
+
+===============================   ==============================================
+mtu=packet_size			  Specifies the maximum packet size. default
 				  is 1500.
 
-media=media_type		- Specifies the media type the NIC operates at.
+media=media_type		  Specifies the media type the NIC operates at.
 				  autosense	Autosensing active media.
+
+				  ===========	=========================
 				  10mbps_hd	10Mbps half duplex.
 				  10mbps_fd	10Mbps full duplex.
 				  100mbps_hd	100Mbps half duplex.
@@ -198,85 +225,90 @@ media=media_type		- Specifies the media type the NIC operates at.
 				  4		100Mbps full duplex.
 				  5          	1000Mbps half duplex.
 				  6          	1000Mbps full duplex.
+				  ===========	=========================
 
 				  By default, the NIC operates at autosense.
 				  1000mbps_fd and 1000mbps_hd types are only
 				  available for fiber adapter.
 
-vlan=n				- Specifies the VLAN ID. If vlan=0, the
+vlan=n				  Specifies the VLAN ID. If vlan=0, the
 				  Virtual Local Area Network (VLAN) function is
 				  disable.
 
-jumbo=[0|1]			- Specifies the jumbo frame support. If jumbo=1,
+jumbo=[0|1]			  Specifies the jumbo frame support. If jumbo=1,
 				  the NIC accept jumbo frames. By default, this
 				  function is disabled.
 				  Jumbo frame usually improve the performance
 				  int gigabit.
-				  This feature need jumbo frame compatible 
+				  This feature need jumbo frame compatible
 				  remote.
-				  
-rx_coalesce=m			- Number of rx frame handled each interrupt.
-rx_timeout=n			- Rx DMA wait time for an interrupt. 
-				  If set rx_coalesce > 0, hardware only assert 
-				  an interrupt for m frames. Hardware won't 
+
+rx_coalesce=m			  Number of rx frame handled each interrupt.
+rx_timeout=n			  Rx DMA wait time for an interrupt.
+				  If set rx_coalesce > 0, hardware only assert
+				  an interrupt for m frames. Hardware won't
 				  assert rx interrupt until m frames received or
-				  reach timeout of n * 640 nano seconds. 
-				  Set proper rx_coalesce and rx_timeout can 
+				  reach timeout of n * 640 nano seconds.
+				  Set proper rx_coalesce and rx_timeout can
 				  reduce congestion collapse and overload which
 				  has been a bottleneck for high speed network.
-				  
+
 				  For example, rx_coalesce=10 rx_timeout=800.
-				  that is, hardware assert only 1 interrupt 
-				  for 10 frames received or timeout of 512 us. 
+				  that is, hardware assert only 1 interrupt
+				  for 10 frames received or timeout of 512 us.
 
-tx_coalesce=n			- Number of tx frame handled each interrupt.
-				  Set n > 1 can reduce the interrupts 
+tx_coalesce=n			  Number of tx frame handled each interrupt.
+				  Set n > 1 can reduce the interrupts
 				  congestion usually lower performance of
 				  high speed network card. Default is 16.
-				  
-tx_flow=[1|0]			- Specifies the Tx flow control. If tx_flow=0, 
+
+tx_flow=[1|0]			  Specifies the Tx flow control. If tx_flow=0,
 				  the Tx flow control disable else driver
 				  autodetect.
-rx_flow=[1|0]			- Specifies the Rx flow control. If rx_flow=0, 
+rx_flow=[1|0]			  Specifies the Rx flow control. If rx_flow=0,
 				  the Rx flow control enable else driver
 				  autodetect.
+===============================   ==============================================
 
 
 Configuration Script Sample
 ===========================
-Here is a sample of a simple configuration script:
+Here is a sample of a simple configuration script::
 
-DEVICE=eth0
-USERCTL=no
-ONBOOT=yes
-POOTPROTO=none
-BROADCAST=207.200.5.255
-NETWORK=207.200.5.0
-NETMASK=255.255.255.0
-IPADDR=207.200.5.2
+    DEVICE=eth0
+    USERCTL=no
+    ONBOOT=yes
+    POOTPROTO=none
+    BROADCAST=207.200.5.255
+    NETWORK=207.200.5.0
+    NETMASK=255.255.255.0
+    IPADDR=207.200.5.2
 
 
 Troubleshooting
 ===============
 Q1. Source files contain ^ M behind every line.
-	Make sure all files are Unix file format (no LF). Try the following
-    shell command to convert files.
+
+    Make sure all files are Unix file format (no LF). Try the following
+    shell command to convert files::
 
 	cat dl2k.c | col -b > dl2k.tmp
 	mv dl2k.tmp dl2k.c
 
-	OR
+    OR::
 
 	cat dl2k.c | tr -d "\r" > dl2k.tmp
 	mv dl2k.tmp dl2k.c
 
-Q2: Could not find header files (*.h) ?
-	To compile the driver, you need kernel header files. After
+Q2: Could not find header files (``*.h``)?
+
+    To compile the driver, you need kernel header files. After
     installing the kernel source, the header files are usually located in
     /usr/src/linux/include, which is the default include directory configured
     in Makefile. For some distributions, there is a copy of header files in
     /usr/src/include/linux and /usr/src/include/asm, that you can change the
     INCLUDEDIR in Makefile to /usr/include without installing kernel source.
-	Note that RH 7.0 didn't provide correct header files in /usr/include,
+
+    Note that RH 7.0 didn't provide correct header files in /usr/include,
     including those files will make a wrong version driver.
 
diff --git a/Documentation/networking/device_drivers/index.rst b/Documentation/networking/device_drivers/index.rst
index 09728e964ce1..e5d1863379cb 100644
--- a/Documentation/networking/device_drivers/index.rst
+++ b/Documentation/networking/device_drivers/index.rst
@@ -36,6 +36,7 @@ Contents:
    davicom/dm9000
    dec/de4x5
    dec/dmfe
+   dlink/dl2k
 
 .. only::  subproject and html
 
diff --git a/drivers/net/ethernet/dlink/dl2k.c b/drivers/net/ethernet/dlink/dl2k.c
index 643090555cc7..5143722c4419 100644
--- a/drivers/net/ethernet/dlink/dl2k.c
+++ b/drivers/net/ethernet/dlink/dl2k.c
@@ -1869,7 +1869,7 @@ Compile command:
 
 gcc -D__KERNEL__ -DMODULE -I/usr/src/linux/include -Wall -Wstrict-prototypes -O2 -c dl2k.c
 
-Read Documentation/networking/device_drivers/dlink/dl2k.txt for details.
+Read Documentation/networking/device_drivers/dlink/dl2k.rst for details.
 
 */
 
-- 
2.25.4

