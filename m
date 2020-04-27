Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B889A1BB13B
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 00:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgD0WFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 18:05:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:47936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726263AbgD0WB6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 18:01:58 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C219208FE;
        Mon, 27 Apr 2020 22:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588024916;
        bh=jMwRF4jq34G/aXefFdgvn6mcpepq9sc5FxTVXWThGbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K7J/M9OfsnV2EdmyX0RjJEuw5NXKVURJlUQikBbdBUjumoCaDBcSn80IJqHdtwT9T
         zYuLmPAXTnLq52Hl0YRNU4NW1olPsNb0pGqqOHcSjgNFu/hbXkdwV3Jg9vR8gjW9DU
         GAjuZL6OtwXTa5AiVYbb28kLFFVYzcniM7DFdz4M=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jTBp4-000Iny-Jt; Tue, 28 Apr 2020 00:01:54 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        netdev@vger.kernel.org
Subject: [PATCH 05/38] docs: networking: convert arcnet.txt to ReST
Date:   Tue, 28 Apr 2020 00:01:20 +0200
Message-Id: <b549984929e7bc48c97e29149fd2b587788aaf0f.1588024424.git.mchehab+huawei@kernel.org>
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
- use document title markup;
- add notes markups;
- mark code blocks and literals as such;
- mark tables as such;
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../networking/{arcnet.txt => arcnet.rst}     | 348 ++++++++++--------
 Documentation/networking/index.rst            |   1 +
 drivers/net/arcnet/Kconfig                    |   6 +-
 3 files changed, 197 insertions(+), 158 deletions(-)
 rename Documentation/networking/{arcnet.txt => arcnet.rst} (76%)

diff --git a/Documentation/networking/arcnet.txt b/Documentation/networking/arcnet.rst
similarity index 76%
rename from Documentation/networking/arcnet.txt
rename to Documentation/networking/arcnet.rst
index aff97f47c05c..e93d9820f0f1 100644
--- a/Documentation/networking/arcnet.txt
+++ b/Documentation/networking/arcnet.rst
@@ -1,11 +1,18 @@
-----------------------------------------------------------------------------
-NOTE:  See also arcnet-hardware.txt in this directory for jumper-setting
-and cabling information if you're like many of us and didn't happen to get a
-manual with your ARCnet card.
-----------------------------------------------------------------------------
+.. SPDX-License-Identifier: GPL-2.0
+
+======
+ARCnet
+======
+
+.. note::
+
+   See also arcnet-hardware.txt in this directory for jumper-setting
+   and cabling information if you're like many of us and didn't happen to get a
+   manual with your ARCnet card.
 
 Since no one seems to listen to me otherwise, perhaps a poem will get your
-attention:
+attention::
+
 		This driver's getting fat and beefy,
 		But my cat is still named Fifi.
 
@@ -24,28 +31,21 @@ Come on, be a sport!  Send me a success report!
 (hey, that was even better than my original poem... this is getting bad!)
 
 
---------
-WARNING:
---------
+.. warning::
 
-If you don't e-mail me about your success/failure soon, I may be forced to
-start SINGING.  And we don't want that, do we?
+   If you don't e-mail me about your success/failure soon, I may be forced to
+   start SINGING.  And we don't want that, do we?
 
-(You know, it might be argued that I'm pushing this point a little too much. 
-If you think so, why not flame me in a quick little e-mail?  Please also
-include the type of card(s) you're using, software, size of network, and
-whether it's working or not.)
+   (You know, it might be argued that I'm pushing this point a little too much.
+   If you think so, why not flame me in a quick little e-mail?  Please also
+   include the type of card(s) you're using, software, size of network, and
+   whether it's working or not.)
 
-My e-mail address is: apenwarr@worldvisions.ca
+   My e-mail address is: apenwarr@worldvisions.ca
 
-
----------------------------------------------------------------------------
-
-			
 These are the ARCnet drivers for Linux.
 
-
-This new release (2.91) has been put together by David Woodhouse 
+This new release (2.91) has been put together by David Woodhouse
 <dwmw2@infradead.org>, in an attempt to tidy up the driver after adding support
 for yet another chipset. Now the generic support has been separated from the
 individual chipset drivers, and the source files aren't quite so packed with
@@ -62,12 +62,13 @@ included and seems to be working fine!
 Where do I discuss these drivers?
 ---------------------------------
 
-Tomasz has been so kind as to set up a new and improved mailing list. 
+Tomasz has been so kind as to set up a new and improved mailing list.
 Subscribe by sending a message with the BODY "subscribe linux-arcnet YOUR
 REAL NAME" to listserv@tichy.ch.uj.edu.pl.  Then, to submit messages to the
 list, mail to linux-arcnet@tichy.ch.uj.edu.pl.
 
 There are archives of the mailing list at:
+
 	http://epistolary.org/mailman/listinfo.cgi/arcnet
 
 The people on linux-net@vger.kernel.org (now defunct, replaced by
@@ -80,17 +81,20 @@ Other Drivers and Info
 ----------------------
 
 You can try my ARCNET page on the World Wide Web at:
-	http://www.qis.net/~jschmitz/arcnet/	
+
+	http://www.qis.net/~jschmitz/arcnet/
 
 Also, SMC (one of the companies that makes ARCnet cards) has a WWW site you
 might be interested in, which includes several drivers for various cards
 including ARCnet.  Try:
+
 	http://www.smc.com/
-	
+
 Performance Technologies makes various network software that supports
 ARCnet:
+
 	http://www.perftech.com/ or ftp to ftp.perftech.com.
-	
+
 Novell makes a networking stack for DOS which includes ARCnet drivers.  Try
 FTPing to ftp.novell.com.
 
@@ -99,19 +103,20 @@ one you'll want to use with ARCnet cards) from
 oak.oakland.edu:/simtel/msdos/pktdrvr. It won't work perfectly on a 386+
 without patches, though, and also doesn't like several cards.  Fixed
 versions are available on my WWW page, or via e-mail if you don't have WWW
-access. 
+access.
 
 
 Installing the Driver
 ---------------------
 
-All you will need to do in order to install the driver is:
+All you will need to do in order to install the driver is::
+
 	make config
-		(be sure to choose ARCnet in the network devices 
+		(be sure to choose ARCnet in the network devices
 		and at least one chipset driver.)
 	make clean
 	make zImage
-	
+
 If you obtained this ARCnet package as an upgrade to the ARCnet driver in
 your current kernel, you will need to first copy arcnet.c over the one in
 the linux/drivers/net directory.
@@ -125,10 +130,12 @@ There are four chipset options:
 
 This is the normal ARCnet card, which you've probably got. This is the only
 chipset driver which will autoprobe if not told where the card is.
-It following options on the command line:
+It following options on the command line::
+
  com90xx=[<io>[,<irq>[,<shmem>]]][,<name>] | <name>
 
-If you load the chipset support as a module, the options are:
+If you load the chipset support as a module, the options are::
+
  io=<io> irq=<irq> shmem=<shmem> device=<name>
 
 To disable the autoprobe, just specify "com90xx=" on the kernel command line.
@@ -136,14 +143,17 @@ To specify the name alone, but allow autoprobe, just put "com90xx=<name>"
 
  2. ARCnet COM20020 chipset.
 
-This is the new chipset from SMC with support for promiscuous mode (packet 
+This is the new chipset from SMC with support for promiscuous mode (packet
 sniffing), extra diagnostic information, etc. Unfortunately, there is no
 sensible method of autoprobing for these cards. You must specify the I/O
 address on the kernel command line.
-The command line options are:
+
+The command line options are::
+
  com20020=<io>[,<irq>[,<node_ID>[,backplane[,CKP[,timeout]]]]][,name]
 
-If you load the chipset support as a module, the options are:
+If you load the chipset support as a module, the options are::
+
  io=<io> irq=<irq> node=<node_ID> backplane=<backplane> clock=<CKP>
  timeout=<timeout> device=<name>
 
@@ -160,8 +170,10 @@ you have a card which doesn't support shared memory, or (strangely) in case
 you have so many ARCnet cards in your machine that you run out of shmem slots.
 If you don't give the IO address on the kernel command line, then the driver
 will not find the card.
-The command line options are:
- com90io=<io>[,<irq>][,<name>] 
+
+The command line options are::
+
+ com90io=<io>[,<irq>][,<name>]
 
 If you load the chipset support as a module, the options are:
  io=<io> irq=<irq> device=<name>
@@ -169,44 +181,49 @@ If you load the chipset support as a module, the options are:
  4. ARCnet RIM I cards.
 
 These are COM90xx chips which are _completely_ memory mapped. The support for
-these is not tested. If you have one, please mail the author with a success 
+these is not tested. If you have one, please mail the author with a success
 report. All options must be specified, except the device name.
-Command line options:
+Command line options::
+
  arcrimi=<shmem>,<irq>,<node_ID>[,<name>]
 
-If you load the chipset support as a module, the options are:
+If you load the chipset support as a module, the options are::
+
  shmem=<shmem> irq=<irq> node=<node_ID> device=<name>
 
 
 Loadable Module Support
 -----------------------
 
-Configure and rebuild Linux.  When asked, answer 'm' to "Generic ARCnet 
+Configure and rebuild Linux.  When asked, answer 'm' to "Generic ARCnet
 support" and to support for your ARCnet chipset if you want to use the
-loadable module. You can also say 'y' to "Generic ARCnet support" and 'm' 
+loadable module. You can also say 'y' to "Generic ARCnet support" and 'm'
 to the chipset support if you wish.
 
+::
+
 	make config
-	make clean	
+	make clean
 	make zImage
 	make modules
-	
+
 If you're using a loadable module, you need to use insmod to load it, and
 you can specify various characteristics of your card on the command
 line.  (In recent versions of the driver, autoprobing is much more reliable
 and works as a module, so most of this is now unnecessary.)
 
-For example:
+For example::
+
 	cd /usr/src/linux/modules
 	insmod arcnet.o
 	insmod com90xx.o
 	insmod com20020.o io=0x2e0 device=eth1
-	
+
 
 Using the Driver
 ----------------
 
-If you build your kernel with ARCnet COM90xx support included, it should 
+If you build your kernel with ARCnet COM90xx support included, it should
 probe for your card automatically when you boot. If you use a different
 chipset driver complied into the kernel, you must give the necessary options
 on the kernel command line, as detailed above.
@@ -224,69 +241,78 @@ Multiple Cards in One Computer
 ------------------------------
 
 Linux has pretty good support for this now, but since I've been busy, the
-ARCnet driver has somewhat suffered in this respect. COM90xx support, if 
-compiled into the kernel, will (try to) autodetect all the installed cards. 
+ARCnet driver has somewhat suffered in this respect. COM90xx support, if
+compiled into the kernel, will (try to) autodetect all the installed cards.
 
-If you have other cards, with support compiled into the kernel, then you can 
-just repeat the options on the kernel command line, e.g.:
-LILO: linux com20020=0x2e0 com20020=0x380 com90io=0x260
+If you have other cards, with support compiled into the kernel, then you can
+just repeat the options on the kernel command line, e.g.::
+
+	LILO: linux com20020=0x2e0 com20020=0x380 com90io=0x260
+
+If you have the chipset support built as a loadable module, then you need to
+do something like this::
 
-If you have the chipset support built as a loadable module, then you need to 
-do something like this:
 	insmod -o arc0 com90xx
 	insmod -o arc1 com20020 io=0x2e0
 	insmod -o arc2 com90xx
+
 The ARCnet drivers will now sort out their names automatically.
 
 
 How do I get it to work with...?
 --------------------------------
 
-NFS: Should be fine linux->linux, just pretend you're using Ethernet cards. 
-        oak.oakland.edu:/simtel/msdos/nfs has some nice DOS clients.  There
-        is also a DOS-based NFS server called SOSS.  It doesn't multitask
-        quite the way Linux does (actually, it doesn't multitask AT ALL) but
-        you never know what you might need.
-        
-        With AmiTCP (and possibly others), you may need to set the following
-        options in your Amiga nfstab:  MD 1024 MR 1024 MW 1024
-        (Thanks to Christian Gottschling <ferksy@indigo.tng.oche.de>
+NFS:
+	Should be fine linux->linux, just pretend you're using Ethernet cards.
+	oak.oakland.edu:/simtel/msdos/nfs has some nice DOS clients.  There
+	is also a DOS-based NFS server called SOSS.  It doesn't multitask
+	quite the way Linux does (actually, it doesn't multitask AT ALL) but
+	you never know what you might need.
+
+	With AmiTCP (and possibly others), you may need to set the following
+	options in your Amiga nfstab:  MD 1024 MR 1024 MW 1024
+	(Thanks to Christian Gottschling <ferksy@indigo.tng.oche.de>
 	for this.)
-	
+
 	Probably these refer to maximum NFS data/read/write block sizes.  I
 	don't know why the defaults on the Amiga didn't work; write to me if
 	you know more.
 
-DOS: If you're using the freeware arcether.com, you might want to install
-        the driver patch from my web page.  It helps with PC/TCP, and also
-        can get arcether to load if it timed out too quickly during
-        initialization.  In fact, if you use it on a 386+ you REALLY need
-        the patch, really.
-	
-Windows:  See DOS :)  Trumpet Winsock works fine with either the Novell or
+DOS:
+	If you're using the freeware arcether.com, you might want to install
+	the driver patch from my web page.  It helps with PC/TCP, and also
+	can get arcether to load if it timed out too quickly during
+	initialization.  In fact, if you use it on a 386+ you REALLY need
+	the patch, really.
+
+Windows:
+	See DOS :)  Trumpet Winsock works fine with either the Novell or
 	Arcether client, assuming you remember to load winpkt of course.
 
-LAN Manager and Windows for Workgroups: These programs use protocols that
-        are incompatible with the Internet standard.  They try to pretend
-        the cards are Ethernet, and confuse everyone else on the network. 
-        
-        However, v2.00 and higher of the Linux ARCnet driver supports this
-        protocol via the 'arc0e' device.  See the section on "Multiprotocol
-        Support" for more information.
+LAN Manager and Windows for Workgroups:
+	These programs use protocols that
+	are incompatible with the Internet standard.  They try to pretend
+	the cards are Ethernet, and confuse everyone else on the network.
+
+	However, v2.00 and higher of the Linux ARCnet driver supports this
+	protocol via the 'arc0e' device.  See the section on "Multiprotocol
+	Support" for more information.
 
 	Using the freeware Samba server and clients for Linux, you can now
 	interface quite nicely with TCP/IP-based WfWg or Lan Manager
 	networks.
-	
-Windows 95: Tools are included with Win95 that let you use either the LANMAN
+
+Windows 95:
+	Tools are included with Win95 that let you use either the LANMAN
 	style network drivers (NDIS) or Novell drivers (ODI) to handle your
 	ARCnet packets.  If you use ODI, you'll need to use the 'arc0'
-	device with Linux.  If you use NDIS, then try the 'arc0e' device. 
+	device with Linux.  If you use NDIS, then try the 'arc0e' device.
 	See the "Multiprotocol Support" section below if you need arc0e,
 	you're completely insane, and/or you need to build some kind of
 	hybrid network that uses both encapsulation types.
 
-OS/2: I've been told it works under Warp Connect with an ARCnet driver from
+OS/2:
+	I've been told it works under Warp Connect with an ARCnet driver from
 	SMC.  You need to use the 'arc0e' interface for this.  If you get
 	the SMC driver to work with the TCP/IP stuff included in the
 	"normal" Warp Bonus Pack, let me know.
@@ -295,7 +321,8 @@ OS/2: I've been told it works under Warp Connect with an ARCnet driver from
 	which should use the same protocol as WfWg does.  I had no luck
 	installing it under Warp, however.  Please mail me with any results.
 
-NetBSD/AmiTCP: These use an old version of the Internet standard ARCnet
+NetBSD/AmiTCP:
+	These use an old version of the Internet standard ARCnet
 	protocol (RFC1051) which is compatible with the Linux driver v2.10
 	ALPHA and above using the arc0s device. (See "Multiprotocol ARCnet"
 	below.)  ** Newer versions of NetBSD apparently support RFC1201.
@@ -307,16 +334,17 @@ Using Multiprotocol ARCnet
 The ARCnet driver v2.10 ALPHA supports three protocols, each on its own
 "virtual network device":
 
-	arc0  - RFC1201 protocol, the official Internet standard which just
-		happens to be 100% compatible with Novell's TRXNET driver. 
+	======  ===============================================================
+	arc0	RFC1201 protocol, the official Internet standard which just
+		happens to be 100% compatible with Novell's TRXNET driver.
 		Version 1.00 of the ARCnet driver supported _only_ this
 		protocol.  arc0 is the fastest of the three protocols (for
 		whatever reason), and allows larger packets to be used
-		because it supports RFC1201 "packet splitting" operations. 
+		because it supports RFC1201 "packet splitting" operations.
 		Unless you have a specific need to use a different protocol,
 		I strongly suggest that you stick with this one.
-		
-	arc0e - "Ethernet-Encapsulation" which sends packets over ARCnet
+
+	arc0e	"Ethernet-Encapsulation" which sends packets over ARCnet
 		that are actually a lot like Ethernet packets, including the
 		6-byte hardware addresses.  This protocol is compatible with
 		Microsoft's NDIS ARCnet driver, like the one in WfWg and
@@ -328,8 +356,8 @@ The ARCnet driver v2.10 ALPHA supports three protocols, each on its own
 		fit.  arc0e also works slightly more slowly than arc0, for
 		reasons yet to be determined.  (Probably it's the smaller
 		MTU that does it.)
-		
-	arc0s - The "[s]imple" RFC1051 protocol is the "previous" Internet
+
+	arc0s	The "[s]imple" RFC1051 protocol is the "previous" Internet
 		standard that is completely incompatible with the new
 		standard.  Some software today, however, continues to
 		support the old standard (and only the old standard)
@@ -338,9 +366,10 @@ The ARCnet driver v2.10 ALPHA supports three protocols, each on its own
 		smaller than the Internet "requirement," so it's quite
 		possible that you may run into problems.  It's also slower
 		than RFC1201 by about 25%, for the same reason as arc0e.
-		
+
 		The arc0s support was contributed by Tomasz Motylewski
 		and modified somewhat by me.  Bugs are probably my fault.
+	======  ===============================================================
 
 You can choose not to compile arc0e and arc0s into the driver if you want -
 this will save you a bit of memory and avoid confusion when eg. trying to
@@ -358,19 +387,21 @@ can set up your network then:
    two available protocols.  As mentioned above, it's a good idea to use
    only arc0 unless you have a good reason (like some other software, ie.
    WfWg, that only works with arc0e).
-   
-   If you need only arc0, then the following commands should get you going:
-   	ifconfig arc0 MY.IP.ADD.RESS
-   	route add MY.IP.ADD.RESS arc0
-   	route add -net SUB.NET.ADD.RESS arc0
-   	[add other local routes here]
-   	
-   If you need arc0e (and only arc0e), it's a little different:
-   	ifconfig arc0 MY.IP.ADD.RESS
-   	ifconfig arc0e MY.IP.ADD.RESS
-   	route add MY.IP.ADD.RESS arc0e
-   	route add -net SUB.NET.ADD.RESS arc0e
-   
+
+   If you need only arc0, then the following commands should get you going::
+
+	ifconfig arc0 MY.IP.ADD.RESS
+	route add MY.IP.ADD.RESS arc0
+	route add -net SUB.NET.ADD.RESS arc0
+	[add other local routes here]
+
+   If you need arc0e (and only arc0e), it's a little different::
+
+	ifconfig arc0 MY.IP.ADD.RESS
+	ifconfig arc0e MY.IP.ADD.RESS
+	route add MY.IP.ADD.RESS arc0e
+	route add -net SUB.NET.ADD.RESS arc0e
+
    arc0s works much the same way as arc0e.
 
 
@@ -391,29 +422,32 @@ can set up your network then:
    XT (patience), however, does not have its own Internet IP address and so
    I assigned it one on a "private subnet" (as defined by RFC1597).
 
-   To start with, take a simple network with just insight and freedom. 
+   To start with, take a simple network with just insight and freedom.
    Insight needs to:
-   	- talk to freedom via RFC1201 (arc0) protocol, because I like it
+
+	- talk to freedom via RFC1201 (arc0) protocol, because I like it
 	  more and it's faster.
 	- use freedom as its Internet gateway.
-	
-   That's pretty easy to do.  Set up insight like this:
-   	ifconfig arc0 insight
-   	route add insight arc0
-   	route add freedom arc0	/* I would use the subnet here (like I said
+
+   That's pretty easy to do.  Set up insight like this::
+
+	ifconfig arc0 insight
+	route add insight arc0
+	route add freedom arc0	/* I would use the subnet here (like I said
 					to to in "single protocol" above),
-   					but the rest of the subnet
-   					unfortunately lies across the PPP
-   					link on freedom, which confuses
-   					things. */
-   	route add default gw freedom
-   	
-   And freedom gets configured like so:
-   	ifconfig arc0 freedom
-   	route add freedom arc0
-   	route add insight arc0
-   	/* and default gateway is configured by pppd */
-   	
+					but the rest of the subnet
+					unfortunately lies across the PPP
+					link on freedom, which confuses
+					things. */
+	route add default gw freedom
+
+   And freedom gets configured like so::
+
+	ifconfig arc0 freedom
+	route add freedom arc0
+	route add insight arc0
+	/* and default gateway is configured by pppd */
+
    Great, now insight talks to freedom directly on arc0, and sends packets
    to the Internet through freedom.  If you didn't know how to do the above,
    you should probably stop reading this section now because it only gets
@@ -425,7 +459,7 @@ can set up your network then:
    Internet.  (Recall that patience has a "private IP address" which won't
    work on the Internet; that's okay, I configured Linux IP masquerading on
    freedom for this subnet).
-   
+
    So patience (necessarily; I don't have another IP number from my
    provider) has an IP address on a different subnet than freedom and
    insight, but needs to use freedom as an Internet gateway.  Worse, most
@@ -435,53 +469,54 @@ can set up your network then:
    insight, patience WILL send through its default gateway, regardless of
    the fact that both freedom and insight (courtesy of the arc0e device)
    could understand a direct transmission.
-   
-   I compensate by giving freedom an extra IP address - aliased 'gatekeeper'
-   - that is on my private subnet, the same subnet that patience is on.  I
+
+   I compensate by giving freedom an extra IP address - aliased 'gatekeeper' -
+   that is on my private subnet, the same subnet that patience is on.  I
    then define gatekeeper to be the default gateway for patience.
-   
-   To configure freedom (in addition to the commands above):
-   	ifconfig arc0e gatekeeper
-   	route add gatekeeper arc0e
-   	route add patience arc0e
-   
+
+   To configure freedom (in addition to the commands above)::
+
+	ifconfig arc0e gatekeeper
+	route add gatekeeper arc0e
+	route add patience arc0e
+
    This way, freedom will send all packets for patience through arc0e,
    giving its IP address as gatekeeper (on the private subnet).  When it
    talks to insight or the Internet, it will use its "freedom" Internet IP
    address.
-   
-   You will notice that we haven't configured the arc0e device on insight. 
+
+   You will notice that we haven't configured the arc0e device on insight.
    This would work, but is not really necessary, and would require me to
    assign insight another special IP number from my private subnet.  Since
    both insight and patience are using freedom as their default gateway, the
    two can already talk to each other.
-   
+
    It's quite fortunate that I set things up like this the first time (cough
    cough) because it's really handy when I boot insight into DOS.  There, it
-   runs the Novell ODI protocol stack, which only works with RFC1201 ARCnet. 
+   runs the Novell ODI protocol stack, which only works with RFC1201 ARCnet.
    In this mode it would be impossible for insight to communicate directly
    with patience, since the Novell stack is incompatible with Microsoft's
    Ethernet-Encap.  Without changing any settings on freedom or patience, I
    simply set freedom as the default gateway for insight (now in DOS,
    remember) and all the forwarding happens "automagically" between the two
    hosts that would normally not be able to communicate at all.
-   
+
    For those who like diagrams, I have created two "virtual subnets" on the
-   same physical ARCnet wire.  You can picture it like this:
-   
-                                                    
-          [RFC1201 NETWORK]                   [ETHER-ENCAP NETWORK]
+   same physical ARCnet wire.  You can picture it like this::
+
+
+	  [RFC1201 NETWORK]                   [ETHER-ENCAP NETWORK]
       (registered Internet subnet)           (RFC1597 private subnet)
-  
-                             (IP Masquerade)
-          /---------------\         *            /---------------\
-          |               |         *            |               |
-          |               +-Freedom-*-Gatekeeper-+               |
-          |               |    |    *            |               |
-          \-------+-------/    |    *            \-------+-------/
-                  |            |                         |
-               Insight         |                      Patience
-                           (Internet)
+
+			     (IP Masquerade)
+	  /---------------\         *            /---------------\
+	  |               |         *            |               |
+	  |               +-Freedom-*-Gatekeeper-+               |
+	  |               |    |    *            |               |
+	  \-------+-------/    |    *            \-------+-------/
+		  |            |                         |
+	       Insight         |                      Patience
+			   (Internet)
 
 
 
@@ -491,6 +526,7 @@ It works: what now?
 Send mail describing your setup, preferably including driver version, kernel
 version, ARCnet card model, CPU type, number of systems on your network, and
 list of software in use to me at the following address:
+
 	apenwarr@worldvisions.ca
 
 I do send (sometimes automated) replies to all messages I receive.  My email
@@ -525,7 +561,7 @@ this, you should grab the pertinent RFCs. (some are listed near the top of
 arcnet.c).  arcdump assumes your card is at 0xD0000.  If it isn't, edit the
 script.
 
-Buffers 0 and 1 are used for receiving, and Buffers 2 and 3 are for sending. 
+Buffers 0 and 1 are used for receiving, and Buffers 2 and 3 are for sending.
 Ping-pong buffers are implemented both ways.
 
 If your debug level includes D_DURING and you did NOT define SLOW_XMIT_COPY,
@@ -535,9 +571,11 @@ decides that the driver is broken).  During a transmit, unused parts of the
 buffer will be cleared to 0x42 as well.  This is to make it easier to figure
 out which bytes are being used by a packet.
 
-You can change the debug level without recompiling the kernel by typing:
+You can change the debug level without recompiling the kernel by typing::
+
 	ifconfig arc0 down metric 1xxx
 	/etc/rc.d/rc.inet1
+
 where "xxx" is the debug level you want.  For example, "metric 1015" would put
 you at debug level 15.  Debug level 7 is currently the default.
 
@@ -546,7 +584,7 @@ combination of different debug flags; so debug level 7 is really 1+2+4 or
 D_NORMAL+D_EXTRA+D_INIT.  To include D_DURING, you would add 16 to this,
 resulting in debug level 23.
 
-If you don't understand that, you probably don't want to know anyway. 
+If you don't understand that, you probably don't want to know anyway.
 E-mail me about your problem.
 
 
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 5da18e024fcb..3e0a4bb23ef9 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -40,6 +40,7 @@ Contents:
    6pack
    altera_tse
    arcnet-hardware
+   arcnet
 
 .. only::  subproject and html
 
diff --git a/drivers/net/arcnet/Kconfig b/drivers/net/arcnet/Kconfig
index 27551bf3d7e4..43eef60653b2 100644
--- a/drivers/net/arcnet/Kconfig
+++ b/drivers/net/arcnet/Kconfig
@@ -9,7 +9,7 @@ menuconfig ARCNET
 	---help---
 	  If you have a network card of this type, say Y and check out the
 	  (arguably) beautiful poetry in
-	  <file:Documentation/networking/arcnet.txt>.
+	  <file:Documentation/networking/arcnet.rst>.
 
 	  You need both this driver, and the driver for the particular ARCnet
 	  chipset of your card. If you don't know, then it's probably a
@@ -28,7 +28,7 @@ config ARCNET_1201
 	  arc0 device.  You need to say Y here to communicate with
 	  industry-standard RFC1201 implementations, like the arcether.com
 	  packet driver or most DOS/Windows ODI drivers.  Please read the
-	  ARCnet documentation in <file:Documentation/networking/arcnet.txt>
+	  ARCnet documentation in <file:Documentation/networking/arcnet.rst>
 	  for more information about using arc0.
 
 config ARCNET_1051
@@ -42,7 +42,7 @@ config ARCNET_1051
 	  industry-standard RFC1201 implementations, like the arcether.com
 	  packet driver or most DOS/Windows ODI drivers. RFC1201 is included
 	  automatically as the arc0 device. Please read the ARCnet
-	  documentation in <file:Documentation/networking/arcnet.txt> for more
+	  documentation in <file:Documentation/networking/arcnet.rst> for more
 	  information about using arc0e and arc0s.
 
 config ARCNET_RAW
-- 
2.25.4

