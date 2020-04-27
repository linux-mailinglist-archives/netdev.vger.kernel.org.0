Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9FD81BB106
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 00:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbgD0WD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 18:03:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:48010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726379AbgD0WCB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 18:02:01 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B76BF221F8;
        Mon, 27 Apr 2020 22:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588024917;
        bh=lXhYJshvY+E2bLepbms4Sk4pPLOw0GiZCYcROXRLt8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HGCDaalGqipN3A4o7+Cz6SHP7nPXkSvaNvzXlI6jZDfOALnbtJXGzrZvk2/ufQEB5
         lN2VuOVA/GViWVT+uJ/hTWByKL4W+1JqcataytRgucOe5p5UGoNYMb/OXqy9g9b6nn
         4XA2gUpc5iB5lO7cwthY7axaL0kw/RZLUu7HP7kU=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jTBp5-000Ip9-0C; Tue, 28 Apr 2020 00:01:55 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 19/38] docs: networking: convert eql.txt to ReST
Date:   Tue, 28 Apr 2020 00:01:34 +0200
Message-Id: <ea283513f8fd7e796c82ab56589b2023e1a6c71d.1588024424.git.mchehab+huawei@kernel.org>
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
- add a document title;
- adjust titles and chapters, adding proper markups;
- mark code blocks and literals as such;
- mark tables as such;
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/{eql.txt => eql.rst} | 445 ++++++------------
 Documentation/networking/index.rst            |   1 +
 drivers/net/Kconfig                           |   2 +-
 3 files changed, 147 insertions(+), 301 deletions(-)
 rename Documentation/networking/{eql.txt => eql.rst} (62%)

diff --git a/Documentation/networking/eql.txt b/Documentation/networking/eql.rst
similarity index 62%
rename from Documentation/networking/eql.txt
rename to Documentation/networking/eql.rst
index 0f1550150f05..a628c4c81166 100644
--- a/Documentation/networking/eql.txt
+++ b/Documentation/networking/eql.rst
@@ -1,5 +1,11 @@
-  EQL Driver: Serial IP Load Balancing HOWTO
+.. SPDX-License-Identifier: GPL-2.0
+
+==========================================
+EQL Driver: Serial IP Load Balancing HOWTO
+==========================================
+
   Simon "Guru Aleph-Null" Janes, simon@ncm.com
+
   v1.1, February 27, 1995
 
   This is the manual for the EQL device driver. EQL is a software device
@@ -12,7 +18,8 @@
   which was only created to patch cleanly in the very latest kernel
   source trees. (Yes, it worked fine.)
 
-  1.  Introduction
+1. Introduction
+===============
 
   Which is worse? A huge fee for a 56K leased line or two phone lines?
   It's probably the former.  If you find yourself craving more bandwidth,
@@ -41,47 +48,40 @@
   Hey, we can all dream you know...
 
 
-  2.  Kernel Configuration
+2. Kernel Configuration
+=======================
 
   Here I describe the general steps of getting a kernel up and working
   with the eql driver.	From patching, building, to installing.
 
 
-  2.1.	Patching The Kernel
+2.1. Patching The Kernel
+------------------------
 
   If you do not have or cannot get a copy of the kernel with the eql
   driver folded into it, get your copy of the driver from
   ftp://slaughter.ncm.com/pub/Linux/LOAD_BALANCING/eql-1.1.tar.gz.
   Unpack this archive someplace obvious like /usr/local/src/.  It will
-  create the following files:
+  create the following files::
 
-
-
-       ______________________________________________________________________
        -rw-r--r-- guru/ncm	198 Jan 19 18:53 1995 eql-1.1/NO-WARRANTY
        -rw-r--r-- guru/ncm	30620 Feb 27 21:40 1995 eql-1.1/eql-1.1.patch
        -rwxr-xr-x guru/ncm	16111 Jan 12 22:29 1995 eql-1.1/eql_enslave
        -rw-r--r-- guru/ncm	2195 Jan 10 21:48 1995 eql-1.1/eql_enslave.c
-       ______________________________________________________________________
 
   Unpack a recent kernel (something after 1.1.92) someplace convenient
   like say /usr/src/linux-1.1.92.eql. Use symbolic links to point
   /usr/src/linux to this development directory.
 
 
-  Apply the patch by running the commands:
+  Apply the patch by running the commands::
 
-
-       ______________________________________________________________________
        cd /usr/src
        patch </usr/local/src/eql-1.1/eql-1.1.patch
-       ______________________________________________________________________
 
 
-
-
-
-  2.2.	Building The Kernel
+2.2. Building The Kernel
+------------------------
 
   After patching the kernel, run make config and configure the kernel
   for your hardware.
@@ -90,7 +90,8 @@
   After configuration, make and install according to your habit.
 
 
-  3.  Network Configuration
+3. Network Configuration
+========================
 
   So far, I have only used the eql device with the DSLIP SLIP connection
   manager by Matt Dillon (-- "The man who sold his soul to code so much
@@ -100,37 +101,27 @@
   connection.
 
 
-  3.1.	/etc/rc.d/rc.inet1
+3.1. /etc/rc.d/rc.inet1
+-----------------------
 
   In rc.inet1, ifconfig the eql device to the IP address you usually use
   for your machine, and the MTU you prefer for your SLIP lines.	One
   could argue that MTU should be roughly half the usual size for two
   modems, one-third for three, one-fourth for four, etc...  But going
   too far below 296 is probably overkill. Here is an example ifconfig
-  command that sets up the eql device:
+  command that sets up the eql device::
 
-
-
-       ______________________________________________________________________
        ifconfig eql 198.67.33.239 mtu 1006
-       ______________________________________________________________________
-
-
-
-
 
   Once the eql device is up and running, add a static default route to
   it in the routing table using the cool new route syntax that makes
-  life so much easier:
+  life so much easier::
 
-
-
-       ______________________________________________________________________
        route add default eql
-       ______________________________________________________________________
 
 
-  3.2.	Enslaving Devices By Hand
+3.2. Enslaving Devices By Hand
+------------------------------
 
   Enslaving devices by hand requires two utility programs: eql_enslave
   and eql_emancipate (-- eql_emancipate hasn't been written because when
@@ -140,87 +131,56 @@
 
 
   The syntax for enslaving a device is "eql_enslave <master-name>
-  <slave-name> <estimated-bps>".  Here are some example enslavings:
+  <slave-name> <estimated-bps>".  Here are some example enslavings::
 
-
-
-       ______________________________________________________________________
        eql_enslave eql sl0 28800
        eql_enslave eql ppp0 14400
        eql_enslave eql sl1 57600
-       ______________________________________________________________________
-
-
-
-
 
   When you want to free a device from its life of slavery, you can
   either down the device with ifconfig (eql will automatically bury the
   dead slave and remove it from its queue) or use eql_emancipate to free
   it. (-- Or just ifconfig it down, and the eql driver will take it out
-  for you.--)
+  for you.--)::
 
-
-
-       ______________________________________________________________________
        eql_emancipate eql sl0
        eql_emancipate eql ppp0
        eql_emancipate eql sl1
-       ______________________________________________________________________
 
 
-
-
-
-  3.3.	DSLIP Configuration for the eql Device
+3.3. DSLIP Configuration for the eql Device
+-------------------------------------------
 
   The general idea is to bring up and keep up as many SLIP connections
   as you need, automatically.
 
 
-  3.3.1.  /etc/slip/runslip.conf
-
-  Here is an example runslip.conf:
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-  ______________________________________________________________________
-  name		sl-line-1
-  enabled
-  baud		38400
-  mtu		576
-  ducmd		-e /etc/slip/dialout/cua2-288.xp -t 9
-  command	 eql_enslave eql $interface 28800
-  address	 198.67.33.239
-  line		/dev/cua2
-
-  name		sl-line-2
-  enabled
-  baud		38400
-  mtu		576
-  ducmd		-e /etc/slip/dialout/cua3-288.xp -t 9
-  command	 eql_enslave eql $interface 28800
-  address	 198.67.33.239
-  line		/dev/cua3
-  ______________________________________________________________________
-
-
-
-
-
-  3.4.	Using PPP and the eql Device
+3.3.1.  /etc/slip/runslip.conf
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+  Here is an example runslip.conf::
+
+	  name		sl-line-1
+	  enabled
+	  baud		38400
+	  mtu		576
+	  ducmd		-e /etc/slip/dialout/cua2-288.xp -t 9
+	  command	 eql_enslave eql $interface 28800
+	  address	 198.67.33.239
+	  line		/dev/cua2
+
+	  name		sl-line-2
+	  enabled
+	  baud		38400
+	  mtu		576
+	  ducmd		-e /etc/slip/dialout/cua3-288.xp -t 9
+	  command	 eql_enslave eql $interface 28800
+	  address	 198.67.33.239
+	  line		/dev/cua3
+
+
+3.4. Using PPP and the eql Device
+---------------------------------
 
   I have not yet done any load-balancing testing for PPP devices, mainly
   because I don't have a PPP-connection manager like SLIP has with
@@ -235,7 +195,8 @@
   year.
 
 
-  4.  About the Slave Scheduler Algorithm
+4. About the Slave Scheduler Algorithm
+======================================
 
   The slave scheduler probably could be replaced with a dozen other
   things and push traffic much faster.	The formula in the current set
@@ -254,7 +215,8 @@
   traffic and the "slower" modem starved.
 
 
-  5.  Testers' Reports
+5. Testers' Reports
+===================
 
   Some people have experimented with the eql device with newer
   kernels (than 1.1.75).  I have since updated the driver to patch
@@ -262,87 +224,29 @@
   balancing" driver config option.
 
 
-  o  icee from LinuxNET patched 1.1.86 without any rejects and was able
+  -  icee from LinuxNET patched 1.1.86 without any rejects and was able
      to boot the kernel and enslave a couple of ISDN PPP links.
 
-  5.1.	Randolph Bentson's Test Report
+5.1. Randolph Bentson's Test Report
+-----------------------------------
 
+  ::
 
+    From bentson@grieg.seaslug.org Wed Feb  8 19:08:09 1995
+    Date: Tue, 7 Feb 95 22:57 PST
+    From: Randolph Bentson <bentson@grieg.seaslug.org>
+    To: guru@ncm.com
+    Subject: EQL driver tests
 
 
+    I have been checking out your eql driver.  (Nice work, that!)
+    Although you may already done this performance testing, here
+    are some data I've discovered.
 
+    Randolph Bentson
+    bentson@grieg.seaslug.org
 
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-  From bentson@grieg.seaslug.org Wed Feb  8 19:08:09 1995
-  Date: Tue, 7 Feb 95 22:57 PST
-  From: Randolph Bentson <bentson@grieg.seaslug.org>
-  To: guru@ncm.com
-  Subject: EQL driver tests
-
-
-  I have been checking out your eql driver.  (Nice work, that!)
-  Although you may already done this performance testing, here
-  are some data I've discovered.
-
-  Randolph Bentson
-  bentson@grieg.seaslug.org
-
-  ---------------------------------------------------------
+------------------------------------------------------------------
 
 
   A pseudo-device driver, EQL, written by Simon Janes, can be used
@@ -363,7 +267,7 @@
   Once a link was established, I timed a binary ftp transfer of
   289284 bytes of data.	If there were no overhead (packet headers,
   inter-character and inter-packet delays, etc.) the transfers
-  would take the following times:
+  would take the following times::
 
       bits/sec	seconds
       345600	8.3
@@ -388,141 +292,82 @@
   that the connection establishment seemed fragile for the higher
   speeds.  Once established, the connection seemed robust enough.)
 
-  #lines  speed	mtu  seconds	theory  actual  %of
-	 kbit/sec      duration	speed	speed	max
-  3	115200  900	_	345600
-  3	115200  400	18.1	345600  159825  46
-  2	115200  900	_	230400
-  2	115200  600	18.1	230400  159825  69
-  2	115200  400	19.3	230400  149888  65
-  4	57600	900	_	234600
-  4	57600	600	_	234600
-  4	57600	400	_	234600
-  3	57600	600	20.9	172800  138413  80
-  3	57600	900	21.2	172800  136455  78
-  3	115200  600	21.7	345600  133311  38
-  3	57600	400	22.5	172800  128571  74
-  4	38400	900	25.2	153600  114795  74
-  4	38400	600	26.4	153600  109577  71
-  4	38400	400	27.3	153600  105965  68
-  2	57600	900	29.1	115200  99410.3 86
-  1	115200  900	30.7	115200  94229.3 81
-  2	57600	600	30.2	115200  95789.4 83
-  3	38400	900	30.3	115200  95473.3 82
-  3	38400	600	31.2	115200  92719.2 80
-  1	115200  600	31.3	115200  92423	80
-  2	57600	400	32.3	115200  89561.6 77
-  1	115200  400	32.8	115200  88196.3 76
-  3	38400	400	33.5	115200  86353.4 74
-  2	38400	900	43.7	76800	66197.7 86
-  2	38400	600	44	76800	65746.4 85
-  2	38400	400	47.2	76800	61289	79
-  4	19200	900	50.8	76800	56945.7 74
-  4	19200	400	53.2	76800	54376.7 70
-  4	19200	600	53.7	76800	53870.4 70
-  1	57600	900	54.6	57600	52982.4 91
-  1	57600	600	56.2	57600	51474	89
-  3	19200	900	60.5	57600	47815.5 83
-  1	57600	400	60.2	57600	48053.8 83
-  3	19200	600	62	57600	46658.7 81
-  3	19200	400	64.7	57600	44711.6 77
-  1	38400	900	79.4	38400	36433.8 94
-  1	38400	600	82.4	38400	35107.3 91
-  2	19200	900	84.4	38400	34275.4 89
-  1	38400	400	86.8	38400	33327.6 86
-  2	19200	600	87.6	38400	33023.3 85
-  2	19200	400	91.2	38400	31719.7 82
-  4	9600	900	94.7	38400	30547.4 79
-  4	9600	400	106	38400	27290.9 71
-  4	9600	600	110	38400	26298.5 68
-  3	9600	900	118	28800	24515.6 85
-  3	9600	600	120	28800	24107	83
-  3	9600	400	131	28800	22082.7 76
-  1	19200	900	155	19200	18663.5 97
-  1	19200	600	161	19200	17968	93
-  1	19200	400	170	19200	17016.7 88
-  2	9600	600	176	19200	16436.6 85
-  2	9600	900	180	19200	16071.3 83
-  2	9600	400	181	19200	15982.5 83
-  1	9600	900	305	9600	9484.72 98
-  1	9600	600	314	9600	9212.87 95
-  1	9600	400	332	9600	8713.37 90
+  ======  ========	===  ========   ======= ======= ===
+  #lines  speed		mtu  seconds	theory  actual  %of
+	  kbit/sec	     duration	speed	speed	max
+  ======  ========	===  ========   ======= ======= ===
+  3	  115200	900	_	345600
+  3	  115200	400	18.1	345600  159825  46
+  2	  115200	900	_	230400
+  2	  115200	600	18.1	230400  159825  69
+  2	  115200	400	19.3	230400  149888  65
+  4	  57600		900	_	234600
+  4	  57600		600	_	234600
+  4	  57600		400	_	234600
+  3	  57600		600	20.9	172800  138413  80
+  3	  57600		900	21.2	172800  136455  78
+  3	  115200	600	21.7	345600  133311  38
+  3	  57600		400	22.5	172800  128571  74
+  4	  38400		900	25.2	153600  114795  74
+  4	  38400		600	26.4	153600  109577  71
+  4	  38400		400	27.3	153600  105965  68
+  2	  57600		900	29.1	115200  99410.3 86
+  1	  115200	900	30.7	115200  94229.3 81
+  2	  57600		600	30.2	115200  95789.4 83
+  3	  38400		900	30.3	115200  95473.3 82
+  3	  38400		600	31.2	115200  92719.2 80
+  1	  115200	600	31.3	115200  92423	80
+  2	  57600		400	32.3	115200  89561.6 77
+  1	  115200	400	32.8	115200  88196.3 76
+  3	  38400		400	33.5	115200  86353.4 74
+  2	  38400		900	43.7	76800	66197.7 86
+  2	  38400		600	44	76800	65746.4 85
+  2	  38400		400	47.2	76800	61289	79
+  4	  19200		900	50.8	76800	56945.7 74
+  4	  19200		400	53.2	76800	54376.7 70
+  4	  19200		600	53.7	76800	53870.4 70
+  1	  57600		900	54.6	57600	52982.4 91
+  1	  57600		600	56.2	57600	51474	89
+  3	  19200		900	60.5	57600	47815.5 83
+  1	  57600		400	60.2	57600	48053.8 83
+  3	  19200		600	62	57600	46658.7 81
+  3	  19200		400	64.7	57600	44711.6 77
+  1	  38400		900	79.4	38400	36433.8 94
+  1	  38400		600	82.4	38400	35107.3 91
+  2	  19200		900	84.4	38400	34275.4 89
+  1	  38400		400	86.8	38400	33327.6 86
+  2	  19200		600	87.6	38400	33023.3 85
+  2	  19200		400	91.2	38400	31719.7 82
+  4	  9600		900	94.7	38400	30547.4 79
+  4	  9600		400	106	38400	27290.9 71
+  4	  9600		600	110	38400	26298.5 68
+  3	  9600		900	118	28800	24515.6 85
+  3	  9600		600	120	28800	24107	83
+  3	  9600		400	131	28800	22082.7 76
+  1	  19200		900	155	19200	18663.5 97
+  1	  19200		600	161	19200	17968	93
+  1	  19200		400	170	19200	17016.7 88
+  2	  9600		600	176	19200	16436.6 85
+  2	  9600		900	180	19200	16071.3 83
+  2	  9600		400	181	19200	15982.5 83
+  1	  9600		900	305	9600	9484.72 98
+  1	  9600		600	314	9600	9212.87 95
+  1	  9600		400	332	9600	8713.37 90
+  ======  ========	===  ========   ======= ======= ===
 
+5.2. Anthony Healy's Report
+---------------------------
 
+  ::
 
+    Date: Mon, 13 Feb 1995 16:17:29 +1100 (EST)
+    From: Antony Healey <ahealey@st.nepean.uws.edu.au>
+    To: Simon Janes <guru@ncm.com>
+    Subject: Re: Load Balancing
 
-
-  5.2.	Anthony Healy's Report
-
-
-
-
-
-
-
-  Date: Mon, 13 Feb 1995 16:17:29 +1100 (EST)
-  From: Antony Healey <ahealey@st.nepean.uws.edu.au>
-  To: Simon Janes <guru@ncm.com>
-  Subject: Re: Load Balancing
-
-  Hi Simon,
+    Hi Simon,
 	  I've installed your patch and it works great. I have trialed
 	  it over twin SL/IP lines, just over null modems, but I was
 	  able to data at over 48Kb/s [ISDN link -Simon]. I managed a
 	  transfer of up to 7.5 Kbyte/s on one go, but averaged around
 	  6.4 Kbyte/s, which I think is pretty cool.  :)
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 313f66900bce..9ef6ef42bdc5 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -54,6 +54,7 @@ Contents:
    defza
    dns_resolver
    driver
+   eql
 
 .. only::  subproject and html
 
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 4ab6d343fd86..c822f4a6d166 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -126,7 +126,7 @@ config EQUALIZER
 	  Linux driver or with a Livingston Portmaster 2e.
 
 	  Say Y if you want this and read
-	  <file:Documentation/networking/eql.txt>.  You may also want to read
+	  <file:Documentation/networking/eql.rst>.  You may also want to read
 	  section 6.2 of the NET-3-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-- 
2.25.4

