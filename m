Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A64FF1C1869
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730259AbgEAOrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 10:47:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729469AbgEAOpJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 10:45:09 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE66424985;
        Fri,  1 May 2020 14:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588344306;
        bh=w+4GBMl99/3d07A5vaEMUYBeN/MZRFOXk5BCqPYqcxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AJKHe6B5u1y2rg8O2CXeQNMWc0ieQh9JxVfl90Z0H2Fyt1102PRlEyDt4pb+YyQg7
         B10HitFNTPJFMJ/p/WgMGK2hO/Swu5UYTkxOSQHhApilCvhlB+IAQk6GBY6SO3PuIL
         sIgzEiA0Y11IDYdDs0Kd2ipnQtgup4TTTsW2kqS0=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUWuT-00FCdh-Kk; Fri, 01 May 2020 16:45:01 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 16/37] docs: networking: device drivers: convert chelsio/cxgb.txt to ReST
Date:   Fri,  1 May 2020 16:44:38 +0200
Message-Id: <ac3758c0b78956936c6011d7517a4bdfde3a352e.1588344146.git.mchehab+huawei@kernel.org>
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
- use copyright symbol;
- adjust titles and chapters, adding proper markups;
- comment out text-only TOC from html/pdf output;
- mark code blocks and literals as such;
- add notes markups;
- mark tables as such;
- mark lists as such;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../chelsio/{cxgb.txt => cxgb.rst}            | 183 +++++++++++-------
 .../networking/device_drivers/index.rst       |   1 +
 drivers/net/ethernet/chelsio/Kconfig          |   2 +-
 3 files changed, 114 insertions(+), 72 deletions(-)
 rename Documentation/networking/device_drivers/chelsio/{cxgb.txt => cxgb.rst} (81%)

diff --git a/Documentation/networking/device_drivers/chelsio/cxgb.txt b/Documentation/networking/device_drivers/chelsio/cxgb.rst
similarity index 81%
rename from Documentation/networking/device_drivers/chelsio/cxgb.txt
rename to Documentation/networking/device_drivers/chelsio/cxgb.rst
index 20a887615c4a..435dce5fa2c7 100644
--- a/Documentation/networking/device_drivers/chelsio/cxgb.txt
+++ b/Documentation/networking/device_drivers/chelsio/cxgb.rst
@@ -1,13 +1,18 @@
-                 Chelsio N210 10Gb Ethernet Network Controller
+.. SPDX-License-Identifier: GPL-2.0
+.. include:: <isonum.txt>
 
-                         Driver Release Notes for Linux
+=============================================
+Chelsio N210 10Gb Ethernet Network Controller
+=============================================
 
-                                 Version 2.1.1
+Driver Release Notes for Linux
 
-                                 June 20, 2005
+Version 2.1.1
+
+June 20, 2005
+
+.. Contents
 
-CONTENTS
-========
  INTRODUCTION
  FEATURES
  PERFORMANCE
@@ -16,7 +21,7 @@ CONTENTS
  SUPPORT
 
 
-INTRODUCTION
+Introduction
 ============
 
  This document describes the Linux driver for Chelsio 10Gb Ethernet Network
@@ -24,11 +29,11 @@ INTRODUCTION
  compatible with the Chelsio N110 model 10Gb NICs.
 
 
-FEATURES
+Features
 ========
 
- Adaptive Interrupts (adaptive-rx)
- ---------------------------------
+Adaptive Interrupts (adaptive-rx)
+---------------------------------
 
   This feature provides an adaptive algorithm that adjusts the interrupt
   coalescing parameters, allowing the driver to dynamically adapt the latency
@@ -39,24 +44,24 @@ FEATURES
   ethtool manpage for additional usage information.
 
   By default, adaptive-rx is disabled.
-  To enable adaptive-rx:
+  To enable adaptive-rx::
 
       ethtool -C <interface> adaptive-rx on
 
-  To disable adaptive-rx, use ethtool:
+  To disable adaptive-rx, use ethtool::
 
       ethtool -C <interface> adaptive-rx off
 
   After disabling adaptive-rx, the timer latency value will be set to 50us.
-  You may set the timer latency after disabling adaptive-rx:
+  You may set the timer latency after disabling adaptive-rx::
 
       ethtool -C <interface> rx-usecs <microseconds>
 
-  An example to set the timer latency value to 100us on eth0:
+  An example to set the timer latency value to 100us on eth0::
 
       ethtool -C eth0 rx-usecs 100
 
-  You may also provide a timer latency value while disabling adaptive-rx:
+  You may also provide a timer latency value while disabling adaptive-rx::
 
       ethtool -C <interface> adaptive-rx off rx-usecs <microseconds>
 
@@ -64,13 +69,13 @@ FEATURES
   will be set to the specified value until changed by the user or until
   adaptive-rx is enabled.
 
-  To view the status of the adaptive-rx and timer latency values:
+  To view the status of the adaptive-rx and timer latency values::
 
       ethtool -c <interface>
 
 
- TCP Segmentation Offloading (TSO) Support
- -----------------------------------------
+TCP Segmentation Offloading (TSO) Support
+-----------------------------------------
 
   This feature, also known as "large send", enables a system's protocol stack
   to offload portions of outbound TCP processing to a network interface card
@@ -80,20 +85,20 @@ FEATURES
   Please see the ethtool manpage for additional usage information.
 
   By default, TSO is enabled.
-  To disable TSO:
+  To disable TSO::
 
       ethtool -K <interface> tso off
 
-  To enable TSO:
+  To enable TSO::
 
       ethtool -K <interface> tso on
 
-  To view the status of TSO:
+  To view the status of TSO::
 
       ethtool -k <interface>
 
 
-PERFORMANCE
+Performance
 ===========
 
  The following information is provided as an example of how to change system
@@ -111,59 +116,81 @@ PERFORMANCE
  your system. You may want to write a script that runs at boot-up which
  includes the optimal settings for your system.
 
-  Setting PCI Latency Timer:
-      setpci -d 1425:* 0x0c.l=0x0000F800
+  Setting PCI Latency Timer::
+
+      setpci -d 1425::
+
+* 0x0c.l=0x0000F800
+
+  Disabling TCP timestamp::
 
-  Disabling TCP timestamp:
       sysctl -w net.ipv4.tcp_timestamps=0
 
-  Disabling SACK:
+  Disabling SACK::
+
       sysctl -w net.ipv4.tcp_sack=0
 
-  Setting large number of incoming connection requests:
+  Setting large number of incoming connection requests::
+
       sysctl -w net.ipv4.tcp_max_syn_backlog=3000
 
-  Setting maximum receive socket buffer size:
+  Setting maximum receive socket buffer size::
+
       sysctl -w net.core.rmem_max=1024000
 
-  Setting maximum send socket buffer size:
+  Setting maximum send socket buffer size::
+
       sysctl -w net.core.wmem_max=1024000
 
-  Set smp_affinity (on a multiprocessor system) to a single CPU:
+  Set smp_affinity (on a multiprocessor system) to a single CPU::
+
       echo 1 > /proc/irq/<interrupt_number>/smp_affinity
 
-  Setting default receive socket buffer size:
+  Setting default receive socket buffer size::
+
       sysctl -w net.core.rmem_default=524287
 
-  Setting default send socket buffer size:
+  Setting default send socket buffer size::
+
       sysctl -w net.core.wmem_default=524287
 
-  Setting maximum option memory buffers:
+  Setting maximum option memory buffers::
+
       sysctl -w net.core.optmem_max=524287
 
-  Setting maximum backlog (# of unprocessed packets before kernel drops):
+  Setting maximum backlog (# of unprocessed packets before kernel drops)::
+
       sysctl -w net.core.netdev_max_backlog=300000
 
-  Setting TCP read buffers (min/default/max):
+  Setting TCP read buffers (min/default/max)::
+
       sysctl -w net.ipv4.tcp_rmem="10000000 10000000 10000000"
 
-  Setting TCP write buffers (min/pressure/max):
+  Setting TCP write buffers (min/pressure/max)::
+
       sysctl -w net.ipv4.tcp_wmem="10000000 10000000 10000000"
 
-  Setting TCP buffer space (min/pressure/max):
+  Setting TCP buffer space (min/pressure/max)::
+
       sysctl -w net.ipv4.tcp_mem="10000000 10000000 10000000"
 
   TCP window size for single connections:
+
    The receive buffer (RX_WINDOW) size must be at least as large as the
    Bandwidth-Delay Product of the communication link between the sender and
    receiver. Due to the variations of RTT, you may want to increase the buffer
    size up to 2 times the Bandwidth-Delay Product. Reference page 289 of
    "TCP/IP Illustrated, Volume 1, The Protocols" by W. Richard Stevens.
-   At 10Gb speeds, use the following formula:
+
+   At 10Gb speeds, use the following formula::
+
        RX_WINDOW >= 1.25MBytes * RTT(in milliseconds)
        Example for RTT with 100us: RX_WINDOW = (1,250,000 * 0.1) = 125,000
+
    RX_WINDOW sizes of 256KB - 512KB should be sufficient.
-   Setting the min, max, and default receive buffer (RX_WINDOW) size:
+
+   Setting the min, max, and default receive buffer (RX_WINDOW) size::
+
        sysctl -w net.ipv4.tcp_rmem="<min> <default> <max>"
 
   TCP window size for multiple connections:
@@ -174,30 +201,35 @@ PERFORMANCE
    not supported on the machine. Experimentation may be necessary to attain
    the correct value. This method is provided as a starting point for the
    correct receive buffer size.
+
    Setting the min, max, and default receive buffer (RX_WINDOW) size is
    performed in the same manner as single connection.
 
 
-DRIVER MESSAGES
+Driver Messages
 ===============
 
  The following messages are the most common messages logged by syslog. These
  may be found in /var/log/messages.
 
-  Driver up:
+  Driver up::
+
      Chelsio Network Driver - version 2.1.1
 
-  NIC detected:
+  NIC detected::
+
      eth#: Chelsio N210 1x10GBaseX NIC (rev #), PCIX 133MHz/64-bit
 
-  Link up:
+  Link up::
+
      eth#: link is up at 10 Gbps, full duplex
 
-  Link down:
+  Link down::
+
      eth#: link is down
 
 
-KNOWN ISSUES
+Known Issues
 ============
 
  These issues have been identified during testing. The following information
@@ -214,27 +246,33 @@ KNOWN ISSUES
 
       To eliminate the TCP retransmits, set smp_affinity on the particular
       interrupt to a single CPU. You can locate the interrupt (IRQ) used on
-      the N110/N210 by using ifconfig:
-          ifconfig <dev_name> | grep Interrupt
-      Set the smp_affinity to a single CPU:
-          echo 1 > /proc/irq/<interrupt_number>/smp_affinity
+      the N110/N210 by using ifconfig::
+
+	  ifconfig <dev_name> | grep Interrupt
+
+      Set the smp_affinity to a single CPU::
+
+	  echo 1 > /proc/irq/<interrupt_number>/smp_affinity
 
       It is highly suggested that you do not run the irqbalance daemon on your
       system, as this will change any smp_affinity setting you have applied.
       The irqbalance daemon runs on a 10 second interval and binds interrupts
-      to the least loaded CPU determined by the daemon. To disable this daemon:
-          chkconfig --level 2345 irqbalance off
+      to the least loaded CPU determined by the daemon. To disable this daemon::
+
+	  chkconfig --level 2345 irqbalance off
 
       By default, some Linux distributions enable the kernel feature,
       irqbalance, which performs the same function as the daemon. To disable
-      this feature, add the following line to your bootloader:
-          noirqbalance
+      this feature, add the following line to your bootloader::
 
-          Example using the Grub bootloader:
-              title Red Hat Enterprise Linux AS (2.4.21-27.ELsmp)
-              root (hd0,0)
-              kernel /vmlinuz-2.4.21-27.ELsmp ro root=/dev/hda3 noirqbalance
-              initrd /initrd-2.4.21-27.ELsmp.img
+	  noirqbalance
+
+	  Example using the Grub bootloader::
+
+	      title Red Hat Enterprise Linux AS (2.4.21-27.ELsmp)
+	      root (hd0,0)
+	      kernel /vmlinuz-2.4.21-27.ELsmp ro root=/dev/hda3 noirqbalance
+	      initrd /initrd-2.4.21-27.ELsmp.img
 
   2. After running insmod, the driver is loaded and the incorrect network
      interface is brought up without running ifup.
@@ -277,12 +315,13 @@ KNOWN ISSUES
       AMD's provides three workarounds for this problem, however, Chelsio
       recommends the first option for best performance with this bug:
 
-        For 133Mhz secondary bus operation, limit the transaction length and
-        the number of outstanding transactions, via BIOS configuration
-        programming of the PCI-X card, to the following:
+	For 133Mhz secondary bus operation, limit the transaction length and
+	the number of outstanding transactions, via BIOS configuration
+	programming of the PCI-X card, to the following:
 
-           Data Length (bytes): 1k
-           Total allowed outstanding transactions: 2
+	   Data Length (bytes): 1k
+
+	   Total allowed outstanding transactions: 2
 
       Please refer to AMD 8131-HT/PCI-X Errata 26310 Rev 3.08 August 2004,
       section 56, "133-MHz Mode Split Completion Data Corruption" for more
@@ -293,8 +332,10 @@ KNOWN ISSUES
       have issues with these settings, please revert to the "safe" settings
       and duplicate the problem before submitting a bug or asking for support.
 
-      NOTE: The default setting on most systems is 8 outstanding transactions
-            and 2k bytes data length.
+      .. note::
+
+	    The default setting on most systems is 8 outstanding transactions
+	    and 2k bytes data length.
 
   4. On multiprocessor systems, it has been noted that an application which
      is handling 10Gb networking can switch between CPUs causing degraded
@@ -320,14 +361,16 @@ KNOWN ISSUES
       particular CPU: runon 0 ifup eth0
 
 
-SUPPORT
+Support
 =======
 
  If you have problems with the software or hardware, please contact our
  customer support team via email at support@chelsio.com or check our website
  at http://www.chelsio.com
 
-===============================================================================
+-------------------------------------------------------------------------------
+
+::
 
  Chelsio Communications
  370 San Aleso Ave.
@@ -343,10 +386,8 @@ You should have received a copy of the GNU General Public License along
 with this program; if not, write to the Free Software Foundation, Inc.,
 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 
-THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR IMPLIED
+THIS SOFTWARE IS PROVIDED ``AS IS`` AND WITHOUT ANY EXPRESS OR IMPLIED
 WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
 
- Copyright (c) 2003-2005 Chelsio Communications. All rights reserved.
-
-===============================================================================
+Copyright |copy| 2003-2005 Chelsio Communications. All rights reserved.
diff --git a/Documentation/networking/device_drivers/index.rst b/Documentation/networking/device_drivers/index.rst
index 7dde314fc957..23c4ec9c9125 100644
--- a/Documentation/networking/device_drivers/index.rst
+++ b/Documentation/networking/device_drivers/index.rst
@@ -31,6 +31,7 @@ Contents:
    3com/vortex
    amazon/ena
    aquantia/atlantic
+   chelsio/cxgb
 
 .. only::  subproject and html
 
diff --git a/drivers/net/ethernet/chelsio/Kconfig b/drivers/net/ethernet/chelsio/Kconfig
index 9909bfda167e..82cdfa51ce37 100644
--- a/drivers/net/ethernet/chelsio/Kconfig
+++ b/drivers/net/ethernet/chelsio/Kconfig
@@ -26,7 +26,7 @@ config CHELSIO_T1
 	  This driver supports Chelsio gigabit and 10-gigabit
 	  Ethernet cards. More information about adapter features and
 	  performance tuning is in
-	  <file:Documentation/networking/device_drivers/chelsio/cxgb.txt>.
+	  <file:Documentation/networking/device_drivers/chelsio/cxgb.rst>.
 
 	  For general information about Chelsio and our products, visit
 	  our website at <http://www.chelsio.com>.
-- 
2.25.4

