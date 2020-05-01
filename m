Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 378BC1C1868
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730238AbgEAOrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 10:47:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:52552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729443AbgEAOpJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 10:45:09 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB8FF24981;
        Fri,  1 May 2020 14:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588344306;
        bh=4gNsSKRwbhAO1xjPEvB+/c/XsK7NJbOKVdIgFDsBe1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E87qs60j8s72oMgPJm9dYitYFtjgSdGp0No4aBoONQD+OAVJxAtSKXvWV04mG3kiK
         ToNICDH50EColhQewqhDluytEjbPWFulmRUYHo2QFRHKnICI3w8JgsJ00Mewcl++fM
         IXND3Bcz3u0dC1vqfE1WCbonscnqDpEbu9bE3Pmk=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUWuT-00FCdK-GV; Fri, 01 May 2020 16:45:01 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joerg Reuter <jreuter@yaina.de>, netdev@vger.kernel.org,
        linux-hams@vger.kernel.org
Subject: [PATCH 11/37] docs: networking: convert z8530drv.txt to ReST
Date:   Fri,  1 May 2020 16:44:33 +0200
Message-Id: <5be8d03611c9420ff713323c9aa1b16834e3e8a2.1588344146.git.mchehab+huawei@kernel.org>
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
- mark tables as such;
- mark code blocks and literals as such;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/index.rst            |   1 +
 .../networking/{z8530drv.txt => z8530drv.rst} | 609 +++++++++---------
 MAINTAINERS                                   |   2 +-
 drivers/net/hamradio/Kconfig                  |   4 +-
 drivers/net/hamradio/scc.c                    |   2 +-
 5 files changed, 324 insertions(+), 294 deletions(-)
 rename Documentation/networking/{z8530drv.txt => z8530drv.rst} (57%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 1630801cec19..f5733ca4fbcb 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -121,6 +121,7 @@ Contents:
    xfrm_proc
    xfrm_sync
    xfrm_sysctl
+   z8530drv
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/z8530drv.txt b/Documentation/networking/z8530drv.rst
similarity index 57%
rename from Documentation/networking/z8530drv.txt
rename to Documentation/networking/z8530drv.rst
index 2206abbc3e1b..d2942760f167 100644
--- a/Documentation/networking/z8530drv.txt
+++ b/Documentation/networking/z8530drv.rst
@@ -1,33 +1,30 @@
+.. SPDX-License-Identifier: GPL-2.0
+.. include:: <isonum.txt>
+
+=========================================================
+SCC.C - Linux driver for Z8530 based HDLC cards for AX.25
+=========================================================
+
+
 This is a subset of the documentation. To use this driver you MUST have the
 full package from:
 
 Internet:
-=========
 
-1. ftp://ftp.ccac.rwth-aachen.de/pub/jr/z8530drv-utils_3.0-3.tar.gz
+    1. ftp://ftp.ccac.rwth-aachen.de/pub/jr/z8530drv-utils_3.0-3.tar.gz
 
-2. ftp://ftp.pspt.fi/pub/ham/linux/ax25/z8530drv-utils_3.0-3.tar.gz
+    2. ftp://ftp.pspt.fi/pub/ham/linux/ax25/z8530drv-utils_3.0-3.tar.gz
 
 Please note that the information in this document may be hopelessly outdated.
 A new version of the documentation, along with links to other important
 Linux Kernel AX.25 documentation and programs, is available on
 http://yaina.de/jreuter
 
------------------------------------------------------------------------------
+Copyright |copy| 1993,2000 by Joerg Reuter DL1BKE <jreuter@yaina.de>
 
+portions Copyright |copy| 1993 Guido ten Dolle PE1NNZ
 
-	 SCC.C - Linux driver for Z8530 based HDLC cards for AX.25      
-
-   ********************************************************************
-
-        (c) 1993,2000 by Joerg Reuter DL1BKE <jreuter@yaina.de>
-
-        portions (c) 1993 Guido ten Dolle PE1NNZ
-
-        for the complete copyright notice see >> Copying.Z8530DRV <<
-
-   ******************************************************************** 
-
+for the complete copyright notice see >> Copying.Z8530DRV <<
 
 1. Initialization of the driver
 ===============================
@@ -50,7 +47,7 @@ AX.25-HOWTO on how to emulate a KISS TNC on network device drivers.
 (If you're going to compile the driver as a part of the kernel image,
  skip this chapter and continue with 1.2)
 
-Before you can use a module, you'll have to load it with
+Before you can use a module, you'll have to load it with::
 
 	insmod scc.o
 
@@ -75,61 +72,73 @@ The file itself consists of two main sections.
 ==========================================
 
 The hardware setup section defines the following parameters for each
-Z8530:
+Z8530::
 
-chip    1
-data_a  0x300                   # data port A
-ctrl_a  0x304                   # control port A
-data_b  0x301                   # data port B
-ctrl_b  0x305                   # control port B
-irq     5                       # IRQ No. 5
-pclock  4915200                 # clock
-board   BAYCOM                  # hardware type
-escc    no                      # enhanced SCC chip? (8580/85180/85280)
-vector  0                       # latch for interrupt vector
-special no                      # address of special function register
-option  0                       # option to set via sfr
+    chip    1
+    data_a  0x300                   # data port A
+    ctrl_a  0x304                   # control port A
+    data_b  0x301                   # data port B
+    ctrl_b  0x305                   # control port B
+    irq     5                       # IRQ No. 5
+    pclock  4915200                 # clock
+    board   BAYCOM                  # hardware type
+    escc    no                      # enhanced SCC chip? (8580/85180/85280)
+    vector  0                       # latch for interrupt vector
+    special no                      # address of special function register
+    option  0                       # option to set via sfr
 
 
-chip	- this is just a delimiter to make sccinit a bit simpler to
+chip
+	- this is just a delimiter to make sccinit a bit simpler to
 	  program. A parameter has no effect.
 
-data_a  - the address of the data port A of this Z8530 (needed)
-ctrl_a  - the address of the control port A (needed)
-data_b  - the address of the data port B (needed)
-ctrl_b  - the address of the control port B (needed)
+data_a
+	- the address of the data port A of this Z8530 (needed)
+ctrl_a
+	- the address of the control port A (needed)
+data_b
+	- the address of the data port B (needed)
+ctrl_b
+	- the address of the control port B (needed)
 
-irq     - the used IRQ for this chip. Different chips can use different
-          IRQs or the same. If they share an interrupt, it needs to be
+irq
+	- the used IRQ for this chip. Different chips can use different
+	  IRQs or the same. If they share an interrupt, it needs to be
 	  specified within one chip-definition only.
 
 pclock  - the clock at the PCLK pin of the Z8530 (option, 4915200 is
-          default), measured in Hertz
+	  default), measured in Hertz
 
-board   - the "type" of the board:
+board
+	- the "type" of the board:
 
+	   =======================  ========
 	   SCC type                 value
-	   ---------------------------------
+	   =======================  ========
 	   PA0HZP SCC card          PA0HZP
 	   EAGLE card               EAGLE
 	   PC100 card               PC100
 	   PRIMUS-PC (DG9BL) card   PRIMUS
 	   BayCom (U)SCC card       BAYCOM
+	   =======================  ========
 
-escc    - if you want support for ESCC chips (8580, 85180, 85280), set
-          this to "yes" (option, defaults to "no")
+escc
+	- if you want support for ESCC chips (8580, 85180, 85280), set
+	  this to "yes" (option, defaults to "no")
 
-vector  - address of the vector latch (aka "intack port") for PA0HZP
-          cards. There can be only one vector latch for all chips!
+vector
+	- address of the vector latch (aka "intack port") for PA0HZP
+	  cards. There can be only one vector latch for all chips!
 	  (option, defaults to 0)
 
-special - address of the special function register on several cards.
-          (option, defaults to 0)
+special
+	- address of the special function register on several cards.
+	  (option, defaults to 0)
 
 option  - The value you write into that register (option, default is 0)
 
 You can specify up to four chips (8 channels). If this is not enough,
-just change
+just change::
 
 	#define MAXSCC 4
 
@@ -138,75 +147,81 @@ to a higher value.
 Example for the BAYCOM USCC:
 ----------------------------
 
-chip    1
-data_a  0x300                   # data port A
-ctrl_a  0x304                   # control port A
-data_b  0x301                   # data port B
-ctrl_b  0x305                   # control port B
-irq     5                       # IRQ No. 5 (#)
-board   BAYCOM                  # hardware type (*)
-#
-# SCC chip 2
-#
-chip    2
-data_a  0x302
-ctrl_a  0x306
-data_b  0x303
-ctrl_b  0x307
-board   BAYCOM
+::
+
+	chip    1
+	data_a  0x300                   # data port A
+	ctrl_a  0x304                   # control port A
+	data_b  0x301                   # data port B
+	ctrl_b  0x305                   # control port B
+	irq     5                       # IRQ No. 5 (#)
+	board   BAYCOM                  # hardware type (*)
+	#
+	# SCC chip 2
+	#
+	chip    2
+	data_a  0x302
+	ctrl_a  0x306
+	data_b  0x303
+	ctrl_b  0x307
+	board   BAYCOM
 
 An example for a PA0HZP card:
 -----------------------------
 
-chip 1
-data_a 0x153
-data_b 0x151
-ctrl_a 0x152
-ctrl_b 0x150
-irq 9
-pclock 4915200
-board PA0HZP
-vector 0x168
-escc no
-#
-#
-#
-chip 2
-data_a 0x157
-data_b 0x155
-ctrl_a 0x156
-ctrl_b 0x154
-irq 9
-pclock 4915200
-board PA0HZP
-vector 0x168
-escc no
+::
+
+	chip 1
+	data_a 0x153
+	data_b 0x151
+	ctrl_a 0x152
+	ctrl_b 0x150
+	irq 9
+	pclock 4915200
+	board PA0HZP
+	vector 0x168
+	escc no
+	#
+	#
+	#
+	chip 2
+	data_a 0x157
+	data_b 0x155
+	ctrl_a 0x156
+	ctrl_b 0x154
+	irq 9
+	pclock 4915200
+	board PA0HZP
+	vector 0x168
+	escc no
 
 A DRSI would should probably work with this:
 --------------------------------------------
 (actually: two DRSI cards...)
 
-chip 1
-data_a 0x303
-data_b 0x301
-ctrl_a 0x302
-ctrl_b 0x300
-irq 7
-pclock 4915200
-board DRSI
-escc no
-#
-#
-#
-chip 2
-data_a 0x313
-data_b 0x311
-ctrl_a 0x312
-ctrl_b 0x310
-irq 7
-pclock 4915200
-board DRSI
-escc no
+::
+
+	chip 1
+	data_a 0x303
+	data_b 0x301
+	ctrl_a 0x302
+	ctrl_b 0x300
+	irq 7
+	pclock 4915200
+	board DRSI
+	escc no
+	#
+	#
+	#
+	chip 2
+	data_a 0x313
+	data_b 0x311
+	ctrl_a 0x312
+	ctrl_b 0x310
+	irq 7
+	pclock 4915200
+	board DRSI
+	escc no
 
 Note that you cannot use the on-board baudrate generator off DRSI
 cards. Use "mode dpll" for clock source (see below).
@@ -220,17 +235,19 @@ The utility "gencfg"
 If you only know the parameters for the PE1CHL driver for DOS,
 run gencfg. It will generate the correct port addresses (I hope).
 Its parameters are exactly the same as the ones you use with
-the "attach scc" command in net, except that the string "init" must 
-not appear. Example:
+the "attach scc" command in net, except that the string "init" must
+not appear. Example::
 
-gencfg 2 0x150 4 2 0 1 0x168 9 4915200 
+	gencfg 2 0x150 4 2 0 1 0x168 9 4915200
 
 will print a skeleton z8530drv.conf for the OptoSCC to stdout.
 
-gencfg 2 0x300 2 4 5 -4 0 7 4915200 0x10
+::
+
+	gencfg 2 0x300 2 4 5 -4 0 7 4915200 0x10
 
 does the same for the BAYCOM USCC card. In my opinion it is much easier
-to edit scc_config.h... 
+to edit scc_config.h...
 
 
 1.2.2 channel configuration
@@ -239,58 +256,58 @@ to edit scc_config.h...
 The channel definition is divided into three sub sections for each
 channel:
 
-An example for scc0:
+An example for scc0::
 
-# DEVICE
+	# DEVICE
 
-device scc0	# the device for the following params
+	device scc0	# the device for the following params
 
-# MODEM / BUFFERS
+	# MODEM / BUFFERS
 
-speed 1200		# the default baudrate
-clock dpll		# clock source: 
-			# 	dpll     = normal half duplex operation
-			# 	external = MODEM provides own Rx/Tx clock
-			#	divider  = use full duplex divider if
-			#		   installed (1)
-mode nrzi		# HDLC encoding mode
-			#	nrzi = 1k2 MODEM, G3RUH 9k6 MODEM
-			#	nrz  = DF9IC 9k6 MODEM
-			#
-bufsize	384		# size of buffers. Note that this must include
-			# the AX.25 header, not only the data field!
-			# (optional, defaults to 384)
+	speed 1200		# the default baudrate
+	clock dpll		# clock source:
+				# 	dpll     = normal half duplex operation
+				# 	external = MODEM provides own Rx/Tx clock
+				#	divider  = use full duplex divider if
+				#		   installed (1)
+	mode nrzi		# HDLC encoding mode
+				#	nrzi = 1k2 MODEM, G3RUH 9k6 MODEM
+				#	nrz  = DF9IC 9k6 MODEM
+				#
+	bufsize	384		# size of buffers. Note that this must include
+				# the AX.25 header, not only the data field!
+				# (optional, defaults to 384)
 
-# KISS (Layer 1)
+	# KISS (Layer 1)
 
-txdelay 36              # (see chapter 1.4)
-persist 64
-slot    8
-tail    8
-fulldup 0
-wait    12
-min     3
-maxkey  7
-idle    3
-maxdef  120
-group   0
-txoff   off
-softdcd on                   
-slip    off
+	txdelay 36              # (see chapter 1.4)
+	persist 64
+	slot    8
+	tail    8
+	fulldup 0
+	wait    12
+	min     3
+	maxkey  7
+	idle    3
+	maxdef  120
+	group   0
+	txoff   off
+	softdcd on
+	slip    off
 
 The order WITHIN these sections is unimportant. The order OF these
 sections IS important. The MODEM parameters are set with the first
 recognized KISS parameter...
 
 Please note that you can initialize the board only once after boot
-(or insmod). You can change all parameters but "mode" and "clock" 
-later with the Sccparam program or through KISS. Just to avoid 
-security holes... 
+(or insmod). You can change all parameters but "mode" and "clock"
+later with the Sccparam program or through KISS. Just to avoid
+security holes...
 
 (1) this divider is usually mounted on the SCC-PBC (PA0HZP) or not
-    present at all (BayCom). It feeds back the output of the DPLL 
-    (digital pll) as transmit clock. Using this mode without a divider 
-    installed will normally result in keying the transceiver until 
+    present at all (BayCom). It feeds back the output of the DPLL
+    (digital pll) as transmit clock. Using this mode without a divider
+    installed will normally result in keying the transceiver until
     maxkey expires --- of course without sending anything (useful).
 
 2. Attachment of a channel by your AX.25 software
@@ -299,15 +316,15 @@ security holes...
 2.1 Kernel AX.25
 ================
 
-To set up an AX.25 device you can simply type:
+To set up an AX.25 device you can simply type::
 
 	ifconfig scc0 44.128.1.1 hw ax25 dl0tha-7
 
-This will create a network interface with the IP number 44.128.20.107 
-and the callsign "dl0tha". If you do not have any IP number (yet) you 
-can use any of the 44.128.0.0 network. Note that you do not need 
-axattach. The purpose of axattach (like slattach) is to create a KISS 
-network device linked to a TTY. Please read the documentation of the 
+This will create a network interface with the IP number 44.128.20.107
+and the callsign "dl0tha". If you do not have any IP number (yet) you
+can use any of the 44.128.0.0 network. Note that you do not need
+axattach. The purpose of axattach (like slattach) is to create a KISS
+network device linked to a TTY. Please read the documentation of the
 ax25-utils and the AX.25-HOWTO to learn how to set the parameters of
 the kernel AX.25.
 
@@ -318,16 +335,16 @@ Since the TTY driver (aka KISS TNC emulation) is gone you need
 to emulate the old behaviour. The cost of using these programs is
 that you probably need to compile the kernel AX.25, regardless of whether
 you actually use it or not. First setup your /etc/ax25/axports,
-for example:
+for example::
 
 	9k6	dl0tha-9  9600  255 4 9600 baud port (scc3)
 	axlink	dl0tha-15 38400 255 4 Link to NOS
 
-Now "ifconfig" the scc device:
+Now "ifconfig" the scc device::
 
 	ifconfig scc3 44.128.1.1 hw ax25 dl0tha-9
 
-You can now axattach a pseudo-TTY:
+You can now axattach a pseudo-TTY::
 
 	axattach /dev/ptys0 axlink
 
@@ -335,11 +352,11 @@ and start your NOS and attach /dev/ptys0 there. The problem is that
 NOS is reachable only via digipeating through the kernel AX.25
 (disastrous on a DAMA controlled channel). To solve this problem,
 configure "rxecho" to echo the incoming frames from "9k6" to "axlink"
-and outgoing frames from "axlink" to "9k6" and start:
+and outgoing frames from "axlink" to "9k6" and start::
 
 	rxecho
 
-Or simply use "kissbridge" coming with z8530drv-utils:
+Or simply use "kissbridge" coming with z8530drv-utils::
 
 	ifconfig scc3 hw ax25 dl0tha-9
 	kissbridge scc3 /dev/ptys0
@@ -351,55 +368,57 @@ Or simply use "kissbridge" coming with z8530drv-utils:
 3.1 Displaying SCC Parameters:
 ==============================
 
-Once a SCC channel has been attached, the parameter settings and 
-some statistic information can be shown using the param program:
+Once a SCC channel has been attached, the parameter settings and
+some statistic information can be shown using the param program::
 
-dl1bke-u:~$ sccstat scc0
+	dl1bke-u:~$ sccstat scc0
 
-Parameters:
+	Parameters:
 
-speed       : 1200 baud
-txdelay     : 36
-persist     : 255
-slottime    : 0
-txtail      : 8
-fulldup     : 1
-waittime    : 12
-mintime     : 3 sec
-maxkeyup    : 7 sec
-idletime    : 3 sec
-maxdefer    : 120 sec
-group       : 0x00
-txoff       : off
-softdcd     : on
-SLIP        : off
+	speed       : 1200 baud
+	txdelay     : 36
+	persist     : 255
+	slottime    : 0
+	txtail      : 8
+	fulldup     : 1
+	waittime    : 12
+	mintime     : 3 sec
+	maxkeyup    : 7 sec
+	idletime    : 3 sec
+	maxdefer    : 120 sec
+	group       : 0x00
+	txoff       : off
+	softdcd     : on
+	SLIP        : off
 
-Status:
+	Status:
 
-HDLC                  Z8530           Interrupts         Buffers
------------------------------------------------------------------------
-Sent       :     273  RxOver :     0  RxInts :   125074  Size    :  384
-Received   :    1095  TxUnder:     0  TxInts :     4684  NoSpace :    0
-RxErrors   :    1591                  ExInts :    11776
-TxErrors   :       0                  SpInts :     1503
-Tx State   :    idle
+	HDLC                  Z8530           Interrupts         Buffers
+	-----------------------------------------------------------------------
+	Sent       :     273  RxOver :     0  RxInts :   125074  Size    :  384
+	Received   :    1095  TxUnder:     0  TxInts :     4684  NoSpace :    0
+	RxErrors   :    1591                  ExInts :    11776
+	TxErrors   :       0                  SpInts :     1503
+	Tx State   :    idle
 
 
 The status info shown is:
 
-Sent		- number of frames transmitted
-Received	- number of frames received
-RxErrors	- number of receive errors (CRC, ABORT)
-TxErrors	- number of discarded Tx frames (due to various reasons) 
-Tx State	- status of the Tx interrupt handler: idle/busy/active/tail (2)
-RxOver		- number of receiver overruns
-TxUnder		- number of transmitter underruns
-RxInts		- number of receiver interrupts
-TxInts		- number of transmitter interrupts
-EpInts		- number of receiver special condition interrupts
-SpInts		- number of external/status interrupts
-Size		- maximum size of an AX.25 frame (*with* AX.25 headers!)
-NoSpace		- number of times a buffer could not get allocated
+==============	==============================================================
+Sent		number of frames transmitted
+Received	number of frames received
+RxErrors	number of receive errors (CRC, ABORT)
+TxErrors	number of discarded Tx frames (due to various reasons)
+Tx State	status of the Tx interrupt handler: idle/busy/active/tail (2)
+RxOver		number of receiver overruns
+TxUnder		number of transmitter underruns
+RxInts		number of receiver interrupts
+TxInts		number of transmitter interrupts
+EpInts		number of receiver special condition interrupts
+SpInts		number of external/status interrupts
+Size		maximum size of an AX.25 frame (*with* AX.25 headers!)
+NoSpace		number of times a buffer could not get allocated
+==============	==============================================================
 
 An overrun is abnormal. If lots of these occur, the product of
 baudrate and number of interfaces is too high for the processing
@@ -411,32 +430,34 @@ driver or the kernel AX.25.
 ======================
 
 
-The setting of parameters of the emulated KISS TNC is done in the 
+The setting of parameters of the emulated KISS TNC is done in the
 same way in the SCC driver. You can change parameters by using
-the kissparms program from the ax25-utils package or use the program 
-"sccparam":
+the kissparms program from the ax25-utils package or use the program
+"sccparam"::
 
      sccparam <device> <paramname> <decimal-|hexadecimal value>
 
 You can change the following parameters:
 
-param	    : value
-------------------------
-speed       : 1200
-txdelay     : 36
-persist     : 255
-slottime    : 0
-txtail      : 8
-fulldup     : 1
-waittime    : 12
-mintime     : 3
-maxkeyup    : 7
-idletime    : 3
-maxdefer    : 120
-group       : 0x00
-txoff       : off
-softdcd     : on
-SLIP        : off
+===========   =====
+param	      value
+===========   =====
+speed         1200
+txdelay       36
+persist       255
+slottime      0
+txtail        8
+fulldup       1
+waittime      12
+mintime       3
+maxkeyup      7
+idletime      3
+maxdefer      120
+group         0x00
+txoff         off
+softdcd       on
+SLIP          off
+===========   =====
 
 
 The parameters have the following meaning:
@@ -447,92 +468,92 @@ speed:
      Example: sccparam /dev/scc3 speed 9600
 
 txdelay:
-     The delay (in units of 10 ms) after keying of the 
-     transmitter, until the first byte is sent. This is usually 
-     called "TXDELAY" in a TNC.  When 0 is specified, the driver 
-     will just wait until the CTS signal is asserted. This 
-     assumes the presence of a timer or other circuitry in the 
-     MODEM and/or transmitter, that asserts CTS when the 
+     The delay (in units of 10 ms) after keying of the
+     transmitter, until the first byte is sent. This is usually
+     called "TXDELAY" in a TNC.  When 0 is specified, the driver
+     will just wait until the CTS signal is asserted. This
+     assumes the presence of a timer or other circuitry in the
+     MODEM and/or transmitter, that asserts CTS when the
      transmitter is ready for data.
      A normal value of this parameter is 30-36.
 
      Example: sccparam /dev/scc0 txd 20
 
 persist:
-     This is the probability that the transmitter will be keyed 
-     when the channel is found to be free.  It is a value from 0 
-     to 255, and the probability is (value+1)/256.  The value 
-     should be somewhere near 50-60, and should be lowered when 
+     This is the probability that the transmitter will be keyed
+     when the channel is found to be free.  It is a value from 0
+     to 255, and the probability is (value+1)/256.  The value
+     should be somewhere near 50-60, and should be lowered when
      the channel is used more heavily.
 
      Example: sccparam /dev/scc2 persist 20
 
 slottime:
-     This is the time between samples of the channel. It is 
-     expressed in units of 10 ms.  About 200-300 ms (value 20-30) 
+     This is the time between samples of the channel. It is
+     expressed in units of 10 ms.  About 200-300 ms (value 20-30)
      seems to be a good value.
 
      Example: sccparam /dev/scc0 slot 20
 
 tail:
-     The time the transmitter will remain keyed after the last 
-     byte of a packet has been transferred to the SCC. This is 
-     necessary because the CRC and a flag still have to leave the 
-     SCC before the transmitter is keyed down. The value depends 
-     on the baudrate selected.  A few character times should be 
+     The time the transmitter will remain keyed after the last
+     byte of a packet has been transferred to the SCC. This is
+     necessary because the CRC and a flag still have to leave the
+     SCC before the transmitter is keyed down. The value depends
+     on the baudrate selected.  A few character times should be
      sufficient, e.g. 40ms at 1200 baud. (value 4)
      The value of this parameter is in 10 ms units.
 
      Example: sccparam /dev/scc2 4
 
 full:
-     The full-duplex mode switch. This can be one of the following 
+     The full-duplex mode switch. This can be one of the following
      values:
 
-     0:   The interface will operate in CSMA mode (the normal 
-          half-duplex packet radio operation)
-     1:   Fullduplex mode, i.e. the transmitter will be keyed at 
-          any time, without checking the received carrier.  It 
-          will be unkeyed when there are no packets to be sent.
-     2:   Like 1, but the transmitter will remain keyed, also 
-          when there are no packets to be sent.  Flags will be 
-          sent in that case, until a timeout (parameter 10) 
-          occurs.
+     0:   The interface will operate in CSMA mode (the normal
+	  half-duplex packet radio operation)
+     1:   Fullduplex mode, i.e. the transmitter will be keyed at
+	  any time, without checking the received carrier.  It
+	  will be unkeyed when there are no packets to be sent.
+     2:   Like 1, but the transmitter will remain keyed, also
+	  when there are no packets to be sent.  Flags will be
+	  sent in that case, until a timeout (parameter 10)
+	  occurs.
 
      Example: sccparam /dev/scc0 fulldup off
 
 wait:
-     The initial waittime before any transmit attempt, after the 
-     frame has been queue for transmit.  This is the length of 
+     The initial waittime before any transmit attempt, after the
+     frame has been queue for transmit.  This is the length of
      the first slot in CSMA mode.  In full duplex modes it is
      set to 0 for maximum performance.
-     The value of this parameter is in 10 ms units. 
+     The value of this parameter is in 10 ms units.
 
      Example: sccparam /dev/scc1 wait 4
 
 maxkey:
-     The maximal time the transmitter will be keyed to send 
-     packets, in seconds.  This can be useful on busy CSMA 
-     channels, to avoid "getting a bad reputation" when you are 
-     generating a lot of traffic.  After the specified time has 
+     The maximal time the transmitter will be keyed to send
+     packets, in seconds.  This can be useful on busy CSMA
+     channels, to avoid "getting a bad reputation" when you are
+     generating a lot of traffic.  After the specified time has
      elapsed, no new frame will be started. Instead, the trans-
-     mitter will be switched off for a specified time (parameter 
-     min), and then the selected algorithm for keyup will be 
+     mitter will be switched off for a specified time (parameter
+     min), and then the selected algorithm for keyup will be
      started again.
-     The value 0 as well as "off" will disable this feature, 
-     and allow infinite transmission time. 
+     The value 0 as well as "off" will disable this feature,
+     and allow infinite transmission time.
 
      Example: sccparam /dev/scc0 maxk 20
 
 min:
-     This is the time the transmitter will be switched off when 
+     This is the time the transmitter will be switched off when
      the maximum transmission time is exceeded.
 
      Example: sccparam /dev/scc3 min 10
 
-idle
-     This parameter specifies the maximum idle time in full duplex 
-     2 mode, in seconds.  When no frames have been sent for this 
+idle:
+     This parameter specifies the maximum idle time in full duplex
+     2 mode, in seconds.  When no frames have been sent for this
      time, the transmitter will be keyed down.  A value of 0 is
      has same result as the fullduplex mode 1. This parameter
      can be disabled.
@@ -541,7 +562,7 @@ idle
 
 maxdefer
      This is the maximum time (in seconds) to wait for a free channel
-     to send. When this timer expires the transmitter will be keyed 
+     to send. When this timer expires the transmitter will be keyed
      IMMEDIATELY. If you love to get trouble with other users you
      should set this to a very low value ;-)
 
@@ -555,32 +576,38 @@ txoff:
      Example: sccparam /dev/scc2 txoff on
 
 group:
-     It is possible to build special radio equipment to use more than 
-     one frequency on the same band, e.g. using several receivers and 
+     It is possible to build special radio equipment to use more than
+     one frequency on the same band, e.g. using several receivers and
      only one transmitter that can be switched between frequencies.
-     Also, you can connect several radios that are active on the same 
-     band.  In these cases, it is not possible, or not a good idea, to 
-     transmit on more than one frequency.  The SCC driver provides a 
-     method to lock transmitters on different interfaces, using the 
-     "param <interface> group <x>" command.  This will only work when 
+     Also, you can connect several radios that are active on the same
+     band.  In these cases, it is not possible, or not a good idea, to
+     transmit on more than one frequency.  The SCC driver provides a
+     method to lock transmitters on different interfaces, using the
+     "param <interface> group <x>" command.  This will only work when
      you are using CSMA mode (parameter full = 0).
-     The number <x> must be 0 if you want no group restrictions, and 
+
+     The number <x> must be 0 if you want no group restrictions, and
      can be computed as follows to create restricted groups:
      <x> is the sum of some OCTAL numbers:
 
-     200  This transmitter will only be keyed when all other 
-          transmitters in the group are off.
-     100  This transmitter will only be keyed when the carrier 
-          detect of all other interfaces in the group is off.
-     0xx  A byte that can be used to define different groups.  
-          Interfaces are in the same group, when the logical AND 
-          between their xx values is nonzero.
+
+     ===  =======================================================
+     200  This transmitter will only be keyed when all other
+	  transmitters in the group are off.
+     100  This transmitter will only be keyed when the carrier
+	  detect of all other interfaces in the group is off.
+     0xx  A byte that can be used to define different groups.
+	  Interfaces are in the same group, when the logical AND
+	  between their xx values is nonzero.
+     ===  =======================================================
 
      Examples:
-     When 2 interfaces use group 201, their transmitters will never be 
+
+     When 2 interfaces use group 201, their transmitters will never be
      keyed at the same time.
-     When 2 interfaces use group 101, the transmitters will only key 
-     when both channels are clear at the same time.  When group 301, 
+
+     When 2 interfaces use group 101, the transmitters will only key
+     when both channels are clear at the same time.  When group 301,
      the transmitters will not be keyed at the same time.
 
      Don't forget to convert the octal numbers into decimal before
@@ -595,19 +622,19 @@ softdcd:
      Example: sccparam /dev/scc0 soft on
 
 
-4. Problems 
+4. Problems
 ===========
 
 If you have tx-problems with your BayCom USCC card please check
 the manufacturer of the 8530. SGS chips have a slightly
-different timing. Try Zilog...  A solution is to write to register 8 
-instead to the data port, but this won't work with the ESCC chips. 
+different timing. Try Zilog...  A solution is to write to register 8
+instead to the data port, but this won't work with the ESCC chips.
 *SIGH!*
 
 A very common problem is that the PTT locks until the maxkeyup timer
 expires, although interrupts and clock source are correct. In most
 cases compiling the driver with CONFIG_SCC_DELAY (set with
-make config) solves the problems. For more hints read the (pseudo) FAQ 
+make config) solves the problems. For more hints read the (pseudo) FAQ
 and the documentation coming with z8530drv-utils.
 
 I got reports that the driver has problems on some 386-based systems.
@@ -651,7 +678,9 @@ got it up-and-running?
 Many thanks to Linus Torvalds and Alan Cox for including the driver
 in the Linux standard distribution and their support.
 
-Joerg Reuter	ampr-net: dl1bke@db0pra.ampr.org
-		AX-25   : DL1BKE @ DB0ABH.#BAY.DEU.EU
-		Internet: jreuter@yaina.de
-		WWW     : http://yaina.de/jreuter
+::
+
+	Joerg Reuter	ampr-net: dl1bke@db0pra.ampr.org
+			AX-25   : DL1BKE @ DB0ABH.#BAY.DEU.EU
+			Internet: jreuter@yaina.de
+			WWW     : http://yaina.de/jreuter
diff --git a/MAINTAINERS b/MAINTAINERS
index 469e6c3149fe..a480267571b9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18690,7 +18690,7 @@ L:	linux-hams@vger.kernel.org
 S:	Maintained
 W:	http://yaina.de/jreuter/
 W:	http://www.qsl.net/dl1bke/
-F:	Documentation/networking/z8530drv.txt
+F:	Documentation/networking/z8530drv.rst
 F:	drivers/net/hamradio/*scc.c
 F:	drivers/net/hamradio/z8530.h
 
diff --git a/drivers/net/hamradio/Kconfig b/drivers/net/hamradio/Kconfig
index fe409819b56d..f4500f04147d 100644
--- a/drivers/net/hamradio/Kconfig
+++ b/drivers/net/hamradio/Kconfig
@@ -84,7 +84,7 @@ config SCC
 	---help---
 	  These cards are used to connect your Linux box to an amateur radio
 	  in order to communicate with other computers. If you want to use
-	  this, read <file:Documentation/networking/z8530drv.txt> and the
+	  this, read <file:Documentation/networking/z8530drv.rst> and the
 	  AX25-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>. Also make sure to say Y
 	  to "Amateur Radio AX.25 Level 2" support.
@@ -98,7 +98,7 @@ config SCC_DELAY
 	help
 	  Say Y here if you experience problems with the SCC driver not
 	  working properly; please read
-	  <file:Documentation/networking/z8530drv.txt> for details.
+	  <file:Documentation/networking/z8530drv.rst> for details.
 
 	  If unsure, say N.
 
diff --git a/drivers/net/hamradio/scc.c b/drivers/net/hamradio/scc.c
index 6c03932d8a6b..33fdd55c6122 100644
--- a/drivers/net/hamradio/scc.c
+++ b/drivers/net/hamradio/scc.c
@@ -7,7 +7,7 @@
  *            ------------------
  *
  * You can find a subset of the documentation in 
- * Documentation/networking/z8530drv.txt.
+ * Documentation/networking/z8530drv.rst.
  */
 
 /*
-- 
2.25.4

