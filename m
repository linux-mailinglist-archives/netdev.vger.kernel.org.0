Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F32571C185D
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730137AbgEAOqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 10:46:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:52788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729502AbgEAOpK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 10:45:10 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED0B524982;
        Fri,  1 May 2020 14:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588344306;
        bh=Oc7YPefTP4LbfGthW3bo/1jad2PWEOiKVFe+gs+mTuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NSXTMX2VW39JYGJ/ciJez5BmshjkTjf/4yw1tUnWQMSWaZ1aH0n16VJ7NgdYMFEO2
         utNxVnBbsX+Tn5FZNLsqvuWFVfO+7SWJdlD5dpwBE4++t16mLZo7onh6tsbRDwOvKU
         oy4A7yhs2tCz/2d//HeiyVxFQEYSIDiefszPqPfs=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUWuT-00FCdO-HK; Fri, 01 May 2020 16:45:01 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 12/37] docs: networking: device drivers: convert 3com/3c509.txt to ReST
Date:   Fri,  1 May 2020 16:44:34 +0200
Message-Id: <fb77f8d3b1df3c55b68ebf0d40e0fdcfcb30ae42.1588344146.git.mchehab+huawei@kernel.org>
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
- adjust titles and chapters, adding proper markups;
- mark code blocks and literals as such;
- add notes markups;
- mark tables as such;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../3com/{3c509.txt => 3c509.rst}             | 158 +++++++++++-------
 .../networking/device_drivers/index.rst       |   1 +
 2 files changed, 98 insertions(+), 61 deletions(-)
 rename Documentation/networking/device_drivers/3com/{3c509.txt => 3c509.rst} (68%)

diff --git a/Documentation/networking/device_drivers/3com/3c509.txt b/Documentation/networking/device_drivers/3com/3c509.rst
similarity index 68%
rename from Documentation/networking/device_drivers/3com/3c509.txt
rename to Documentation/networking/device_drivers/3com/3c509.rst
index fbf722e15ac3..47f706bacdd9 100644
--- a/Documentation/networking/device_drivers/3com/3c509.txt
+++ b/Documentation/networking/device_drivers/3com/3c509.rst
@@ -1,17 +1,21 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=============================================================================
 Linux and the 3Com EtherLink III Series Ethercards (driver v1.18c and higher)
-----------------------------------------------------------------------------
+=============================================================================
 
 This file contains the instructions and caveats for v1.18c and higher versions
 of the 3c509 driver. You should not use the driver without reading this file.
 
 release 1.0
+
 28 February 2002
+
 Current maintainer (corrections to):
   David Ruggiero <jdr@farfalle.com>
 
-----------------------------------------------------------------------------
-
-(0) Introduction
+Introduction
+============
 
 The following are notes and information on using the 3Com EtherLink III series
 ethercards in Linux. These cards are commonly known by the most widely-used
@@ -21,11 +25,11 @@ be (but sometimes are) confused with the similarly-numbered PCI-bus "3c905"
 provided by the module 3c509.c, which has code to support all of the following
 models:
 
-  3c509 (original ISA card)
-  3c509B (later revision of the ISA card; supports full-duplex)
-  3c589 (PCMCIA)
-  3c589B (later revision of the 3c589; supports full-duplex)
-  3c579 (EISA)
+ - 3c509 (original ISA card)
+ - 3c509B (later revision of the ISA card; supports full-duplex)
+ - 3c589 (PCMCIA)
+ - 3c589B (later revision of the 3c589; supports full-duplex)
+ - 3c579 (EISA)
 
 Large portions of this documentation were heavily borrowed from the guide
 written the original author of the 3c509 driver, Donald Becker. The master
@@ -33,32 +37,34 @@ copy of that document, which contains notes on older versions of the driver,
 currently resides on Scyld web server: http://www.scyld.com/.
 
 
-(1) Special Driver Features
+Special Driver Features
+=======================
 
 Overriding card settings
 
 The driver allows boot- or load-time overriding of the card's detected IOADDR,
 IRQ, and transceiver settings, although this capability shouldn't generally be
 needed except to enable full-duplex mode (see below). An example of the syntax
-for LILO parameters for doing this:
+for LILO parameters for doing this::
 
-    ether=10,0x310,3,0x3c509,eth0 
+    ether=10,0x310,3,0x3c509,eth0
 
 This configures the first found 3c509 card for IRQ 10, base I/O 0x310, and
 transceiver type 3 (10base2). The flag "0x3c509" must be set to avoid conflicts
 with other card types when overriding the I/O address. When the driver is
 loaded as a module, only the IRQ may be overridden. For example,
 setting two cards to IRQ10 and IRQ11 is done by using the irq module
-option:
+option::
 
    options 3c509 irq=10,11
 
 
-(2) Full-duplex mode
+Full-duplex mode
+================
 
 The v1.18c driver added support for the 3c509B's full-duplex capabilities.
 In order to enable and successfully use full-duplex mode, three conditions
-must be met: 
+must be met:
 
 (a) You must have a Etherlink III card model whose hardware supports full-
 duplex operations. Currently, the only members of the 3c509 family that are
@@ -78,27 +84,32 @@ duplex-capable  Ethernet switch (*not* a hub), or a full-duplex-capable NIC on
 another system that's connected directly to the 3c509B via a crossover cable.
 
 Full-duplex mode can be enabled using 'ethtool'.
- 
-/////Extremely important caution concerning full-duplex mode/////
-Understand that the 3c509B's hardware's full-duplex support is much more
-limited than that provide by more modern network interface cards. Although
-at the physical layer of the network it fully supports full-duplex operation,
-the card was designed before the current Ethernet auto-negotiation (N-way)
-spec was written. This means that the 3c509B family ***cannot and will not
-auto-negotiate a full-duplex connection with its link partner under any
-circumstances, no matter how it is initialized***. If the full-duplex mode
-of the 3c509B is enabled, its link partner will very likely need to be
-independently _forced_ into full-duplex mode as well; otherwise various nasty
-failures will occur - at the very least, you'll see massive numbers of packet
-collisions. This is one of very rare circumstances where disabling auto-
-negotiation and forcing the duplex mode of a network interface card or switch
-would ever be necessary or desirable.
 
+.. warning::
 
-(3) Available Transceiver Types
+  Extremely important caution concerning full-duplex mode
+
+  Understand that the 3c509B's hardware's full-duplex support is much more
+  limited than that provide by more modern network interface cards. Although
+  at the physical layer of the network it fully supports full-duplex operation,
+  the card was designed before the current Ethernet auto-negotiation (N-way)
+  spec was written. This means that the 3c509B family ***cannot and will not
+  auto-negotiate a full-duplex connection with its link partner under any
+  circumstances, no matter how it is initialized***. If the full-duplex mode
+  of the 3c509B is enabled, its link partner will very likely need to be
+  independently _forced_ into full-duplex mode as well; otherwise various nasty
+  failures will occur - at the very least, you'll see massive numbers of packet
+  collisions. This is one of very rare circumstances where disabling auto-
+  negotiation and forcing the duplex mode of a network interface card or switch
+  would ever be necessary or desirable.
+
+
+Available Transceiver Types
+===========================
 
 For versions of the driver v1.18c and above, the available transceiver types are:
- 
+
+== =========================================================================
 0  transceiver type from EEPROM config (normally 10baseT); force half-duplex
 1  AUI (thick-net / DB15 connector)
 2  (undefined)
@@ -106,6 +117,7 @@ For versions of the driver v1.18c and above, the available transceiver types are
 4  10baseT (RJ-45 connector); force half-duplex mode
 8  transceiver type and duplex mode taken from card's EEPROM config settings
 12 10baseT (RJ-45 connector); force full-duplex mode
+== =========================================================================
 
 Prior to driver version 1.18c, only transceiver codes 0-4 were supported. Note
 that the new transceiver codes 8 and 12 are the *only* ones that will enable
@@ -116,26 +128,30 @@ it must always be explicitly enabled via one of these code in order to be
 activated.
 
 The transceiver type can be changed using 'ethtool'.
-  
 
-(4a) Interpretation of error messages and common problems
+
+Interpretation of error messages and common problems
+----------------------------------------------------
 
 Error Messages
+^^^^^^^^^^^^^^
 
-eth0: Infinite loop in interrupt, status 2011. 
+eth0: Infinite loop in interrupt, status 2011.
 These are "mostly harmless" message indicating that the driver had too much
 work during that interrupt cycle. With a status of 0x2011 you are receiving
 packets faster than they can be removed from the card. This should be rare
 or impossible in normal operation. Possible causes of this error report are:
- 
+
    - a "green" mode enabled that slows the processor down when there is no
-     keyboard activity. 
+     keyboard activity.
 
    - some other device or device driver hogging the bus or disabling interrupts.
      Check /proc/interrupts for excessive interrupt counts. The timer tick
-     interrupt should always be incrementing faster than the others. 
+     interrupt should always be incrementing faster than the others.
+
+No received packets
+^^^^^^^^^^^^^^^^^^^
 
-No received packets 
 If a 3c509, 3c562 or 3c589 can successfully transmit packets, but never
 receives packets (as reported by /proc/net/dev or 'ifconfig') you likely
 have an interrupt line problem. Check /proc/interrupts to verify that the
@@ -146,26 +162,37 @@ or IRQ5, and the easiest solution is to move the 3c509 to a different
 interrupt line. If the device is receiving packets but 'ping' doesn't work,
 you have a routing problem.
 
-Tx Carrier Errors Reported in /proc/net/dev 
+Tx Carrier Errors Reported in /proc/net/dev
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+
 If an EtherLink III appears to transmit packets, but the "Tx carrier errors"
 field in /proc/net/dev increments as quickly as the Tx packet count, you
-likely have an unterminated network or the incorrect media transceiver selected. 
+likely have an unterminated network or the incorrect media transceiver selected.
+
+3c509B card is not detected on machines with an ISA PnP BIOS.
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
-3c509B card is not detected on machines with an ISA PnP BIOS. 
 While the updated driver works with most PnP BIOS programs, it does not work
 with all. This can be fixed by disabling PnP support using the 3Com-supplied
-setup program. 
+setup program.
+
+3c509 card is not detected on overclocked machines
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
-3c509 card is not detected on overclocked machines 
 Increase the delay time in id_read_eeprom() from the current value, 500,
-to an absurdly high value, such as 5000. 
+to an absurdly high value, such as 5000.
 
 
-(4b) Decoding Status and Error Messages
+Decoding Status and Error Messages
+----------------------------------
 
-The bits in the main status register are: 
 
+The bits in the main status register are:
+
+=====	======================================
 value 	description
+=====	======================================
 0x01 	Interrupt latch
 0x02 	Tx overrun, or Rx underrun
 0x04 	Tx complete
@@ -174,30 +201,38 @@ value 	description
 0x20 	A Rx packet has started to arrive
 0x40 	The driver has requested an interrupt
 0x80 	Statistics counter nearly full
+=====	======================================
 
-The bits in the transmit (Tx) status word are: 
+The bits in the transmit (Tx) status word are:
 
-value 	description
-0x02 	Out-of-window collision.
-0x04 	Status stack overflow (normally impossible).
-0x08 	16 collisions.
-0x10 	Tx underrun (not enough PCI bus bandwidth).
-0x20 	Tx jabber.
-0x40 	Tx interrupt requested.
-0x80 	Status is valid (this should always be set).
+=====	============================================
+value	description
+=====	============================================
+0x02	Out-of-window collision.
+0x04	Status stack overflow (normally impossible).
+0x08	16 collisions.
+0x10	Tx underrun (not enough PCI bus bandwidth).
+0x20	Tx jabber.
+0x40	Tx interrupt requested.
+0x80	Status is valid (this should always be set).
+=====	============================================
 
 
-When a transmit error occurs the driver produces a status message such as 
+When a transmit error occurs the driver produces a status message such as::
 
    eth0: Transmit error, Tx status register 82
 
 The two values typically seen here are:
 
-0x82 
+0x82
+^^^^
+
 Out of window collision. This typically occurs when some other Ethernet
-host is incorrectly set to full duplex on a half duplex network. 
+host is incorrectly set to full duplex on a half duplex network.
+
+0x88
+^^^^
 
-0x88 
 16 collisions. This typically occurs when the network is exceptionally busy
 or when another host doesn't correctly back off after a collision. If this
 error is mixed with 0x82 errors it is the result of a host incorrectly set
@@ -207,7 +242,8 @@ Both of these errors are the result of network problems that should be
 corrected. They do not represent driver malfunction.
 
 
-(5) Revision history (this file)
+Revision history (this file)
+============================
 
 28Feb02 v1.0  DR   New; major portions based on Becker original 3c509 docs
 
diff --git a/Documentation/networking/device_drivers/index.rst b/Documentation/networking/device_drivers/index.rst
index a191faaf97de..402a9188f446 100644
--- a/Documentation/networking/device_drivers/index.rst
+++ b/Documentation/networking/device_drivers/index.rst
@@ -27,6 +27,7 @@ Contents:
    netronome/nfp
    pensando/ionic
    stmicro/stmmac
+   3com/3c509
 
 .. only::  subproject and html
 
-- 
2.25.4

