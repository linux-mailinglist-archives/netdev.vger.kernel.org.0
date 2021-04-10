Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2529E35AE3D
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 16:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234957AbhDJOYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Apr 2021 10:24:46 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54053 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235147AbhDJOWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Apr 2021 10:22:54 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id D03D55C0106;
        Sat, 10 Apr 2021 10:22:37 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 10 Apr 2021 10:22:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=talbothome.com;
         h=message-id:subject:from:to:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm2; bh=
        El/ii7OBKRu6mchuKcCb7r+MGRNfZJ7cPyuYI+94oOE=; b=HiLFuhmyUZfJS6cQ
        ZJMSKY1X05h1OTYdCG1BK/3OWOPKGcKh16QX7sZuns1ASN3L7Wye9wSQqVue2L3k
        b668WndMQgsiMep/ju4Yfqh/xs+6cEEqnnMDdpGjrPqPwWVVMKrBwg/kC3+xOP5k
        9HRndMo8e9w28lgqtYcJDD63INBbDIjgG8ye4kpQglgBzGdXAd2hBIHchIAMLYlv
        12mxzy+IoAODx9JtkhMFCrWEuqPOV0DMbPnYUSo74zPQLoO/Wi0T3fR9n5F3xmfZ
        l4oAj1VqO+GIxFWri1iQlrNGvv/EhhJgHjl8rvX9FMrVpzkpl4M7obDnodrQ0Q85
        eSddhg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=El/ii7OBKRu6mchuKcCb7r+MGRNfZJ7cPyuYI+94o
        OE=; b=GsbNckkDbb0rJiS9TadCM4ybKrvuTN0B6+QZJmvlogArx4vux+OZRUIhB
        fE8uSltBYgYbE6wINuiMuPLYwbpMgqvOXwQU/5xYgkUpGwgTOWGbc+IEo1HD5b+t
        P19yHOu/JMH5TlWj5w3IhsUlWOo0IkF0h7zK6XeUKhmTEvfXwC+OzP3+SVhU4jvK
        VJ3bkZdUxnVRKGCDueq4BbvHxEtCl2NoHZaEV1wSS6ytgN+xv/Q/nxHwF1g1ylCW
        /XSjFqWpAdayHLVDnPKljEWNKUFUdJOuOlEzFTXu5dCDRrmgp4W5U4dxGLV6O2Ri
        i0oDU8kna5XJ5dgThJgPJj4Rzyvaw==
X-ME-Sender: <xms:rbRxYKMXb9leL9-PV90BF16aUR-bjjTTraN1fBAKR1UA-hNE1V2UUg>
    <xme:rbRxYI-ew8_-ElVpccwLq-tXUuB3tC2_9b3_Yr7zMkvYpvmHNy5xVAJ-vwVjkksSy
    LeKBYWUS3bdkQpTJw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekfedgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefkuffhvfffjghftggfggfgsehtje
    ertddtreejnecuhfhrohhmpeevhhhrihhsucfvrghlsghothcuoegthhhrihhssehtrghl
    sghothhhohhmvgdrtghomheqnecuggftrfgrthhtvghrnhepvdduieduveduvdetgfevue
    eufefhhedukefftedufeehueevfffhteevudefgfehnecuffhomhgrihhnpehpuhhrihdr
    shhmnecukfhppeejvddrleehrddvgeefrdduheeinecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomheptghhrhhishesthgrlhgsohhthhhomhgvrdgt
    ohhm
X-ME-Proxy: <xmx:rbRxYBRV81sfA08fpkJtaqKRGOqgMLmZUL5LlXCz8BHvYv9TnzEhqA>
    <xmx:rbRxYKudXtBc0FRo2Gp7tomzBgzTt56WIJUiiy4fHyJ5-A0IJ5ZjZg>
    <xmx:rbRxYCeI2JnrynSlKV_-DTlVh8IdOiQSlRRE1hVcv77Z6LAYKsSujw>
    <xmx:rbRxYGGTLbo-rG2yYQXaieY93SbPMyaDqUY9bBsNVyDURFWm0Wxd0Q>
Received: from SpaceballstheLaptop.talbothome.com (unknown [72.95.243.156])
        by mail.messagingengine.com (Postfix) with ESMTPA id 89D5724005B;
        Sat, 10 Apr 2021 10:22:37 -0400 (EDT)
Message-ID: <85928d2def5893cd90f823b563369e313e993084.camel@talbothome.com>
Subject: [PATCH 6/9] Update README
From:   Chris Talbot <chris@talbothome.com>
To:     ofono@ofono.org, netdev@vger.kernel.org,
        debian-on-mobile-maintainers@alioth-lists.debian.net,
        librem-5-dev@lists.community.puri.sm
Date:   Sat, 10 Apr 2021 10:22:37 -0400
In-Reply-To: <9c67f5690bd4d5625b799f40e68fa54373617341.camel@talbothome.com>
References: <051ae8ae27f5288d64ec6ef2bd9f77c06b829b52.camel@talbothome.com>
         <b23ba0656ea0d58fdbd8c83072e017f63629f934.camel@talbothome.com>
         <df512b811ee2df6b8f55dd2a9fb0178e6e5c490f.camel@talbothome.com>
         <178dd29027e6abb4a205e25c02f06769848cbb76.camel@talbothome.com>
         <eee886683aa0cbf57ec3f0c8637ba02bc01600d6.camel@talbothome.com>
         <9c67f5690bd4d5625b799f40e68fa54373617341.camel@talbothome.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This updates the README for mmsd
---
 README | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 61 insertions(+), 5 deletions(-)

diff --git a/README b/README
index e33be69..cecc99f 100644
--- a/README
+++ b/README
@@ -2,20 +2,76 @@ Multimedia Messaging Service
 ****************************
 
 Copyright (C) 2010-2011  Intel Corporation. All rights reserved.
+Updated 2021 by: Mohammad Sadiq, kent, kop316, 
+                 fuzzy7k, craftyguy, anteater
+Parts adapted from: https://source.puri.sm/Librem5/purple-mm-sms
+                    Copyright (C) 2018 Purism SPC
+                    
+About
+===========================
+mmsd is a lower level daemon that transmits and recieves MMSes. It
works with
+both the ofono stack and the Modem Manager stack.
 
+Please note that mmsd alone will not get MMS working! It is designed
to work 
+with a higher level chat application to facilitate fetching and 
+sending MMS. It interfaces with other applications via the dbus.
 
-Compilation and installation
+Compiling mmsd
 ============================
-
 In order to compile proxy daemon you need following software packages:
 	- GCC compiler
 	- D-Bus library
 	- GLib library
 
+Installing mmsd
+============================
+
 To configure run:
-	./configure --prefix=/usr
+    ./bootstrap-configure --prefix=/usr/
 
 Configure automatically searches for all required components and
packages.
 
-To compile and install run:
-	make && make install
+To compile, run:
+    make
+	
+And to Install:
+    make install
+
+mmsd will be installed in /${prefix}/libexec (if you are following
this guide,
+it is /usr/libexec )
+
+To uninstall, simply remove the "mmsd" binary from /${prefix}/libexec
or run:
+    sudo make uninstall
+
+Note that you must manually configure your favorite service manager to
run 
+the daemon, as this installer does not configure it to autorun.
+
+Testing out mmsd
+===========================
+To configure, run:
+    ./bootstrap-configure --enable-debug --enable-maintainer-mode
+
+Make it:
+    make 
+
+Run daemon in foreground with debugging:
+    ./src/mmsd -n -d 'src/*'
+
+General Configuration
+===========================
+On first run, mmsd will write a settings file at
+"$HOME/.mms/$PLUGIN/mms"
+
+IMPORTANT NOTE: If you change settings in this file, mmsd MUST BE
RESTARTED 
+                for the changes to take effect!
+
+This settings file use sane defaults, but you can change them:
+
+UseDeliveryReports
+        Whether you want delivery reports for MMSes you send
+
+TotalMaxAttachmentSize
+        The maximum size all of your attachments can be before mmsd
rejects it.
+        NOTE: This value is carrier specific! Changing this value to a
higher
+              number may cause your carrier to silently reject MMSes
you send.
+              CHANGE AT YOUR OWN RISK!
\ No newline at end of file
-- 
2.30.2

