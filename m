Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C2E34A5DC
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 11:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbhCZKv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 06:51:56 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:57885 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230180AbhCZKvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 06:51:52 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id A158A5C0C73
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 06:51:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Fri, 26 Mar 2021 06:51:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=talbothome.com;
         h=message-id:subject:from:to:date:content-type:mime-version
        :content-transfer-encoding; s=fm2; bh=IE5vgu08X3YiLpLNSVCSXrj96/
        S4zgMPWk8c3r3u50s=; b=1x3ZQgv/ry9334d6/Sz7MvyaqiFLMtcSaN+sM84QDv
        wy/X0tDcIdVX5Y4NyQp7qkN1mRck9KUDZ+m9XSQ389PJrjOlUOVAvZW46bwhn+Jd
        tLcLRudyeHP9B4Xvpih8LcywVG9dd4K5fc2NLopMiOOBpeyjwX3iKu1MPq+fEgSK
        i2MYT4hOpmGpZSQcbc8OEnpPWybbVibE5JR4SUd2tizevQ4uS7iu/9Ov8YRk6Ouc
        ZqekqA+IqnznnVc4vA17LXXjQYoX1AmM65nb9Dlv3QBQ07hIAuNcE/9/1fs5dn/u
        7g5C+VLpZu7any8/JJsC6UeM8oxu0WzQ0nkhqPr7qkIA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=IE5vgu
        08X3YiLpLNSVCSXrj96/S4zgMPWk8c3r3u50s=; b=R61EinIroOY8qiKxHhmwjW
        2Xu+bXB/G0H7/pxq685mrfgsgxV6AMp1izd5K/OU+bYl0RZRUZwkAsDlww0UqFdq
        JyqhtHxqRKqnoNfsoDCg1LrT5EzjpLrVUU1tqPnAl3/uv9ynMIJ4J7rTQbYscRx9
        67plqh+Du7LhUOz3Hr/sLTlvinGxpR57iib4X9xHmpkl183VHIlSapndqm0y/oet
        R9/AXfiaBRTFcmC82tLEjZZbmSAzjlxCu5+n8ENd6ThF8iNcHll6Tu8EHBdVs2OR
        g2leeGINMb5jQvZPtA/jZuy/zdqpT9mGgQ/9d+fsU1gLhf9q81jZzmAcN2aTAgSA
        ==
X-ME-Sender: <xms:x7xdYPdQFiyPCS4rWbp-Q1bmYpZNFaXUbsZdj9vQSiHkcNss1vX6HQ>
    <xme:x7xdYAFtxRVQe_jC2La-P_ouIimc4Dg5-pAVbNKZR9yQhEysXEegi-vHLDx8xRd4b
    cXlodEBUyYOfZEdPA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehvddgvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgovfgvgihtqfhnlhihqddqteefjeefqddtgeculd
    ehtddmnecujfgurhepkffuhffvffgtfggggfesthejredttderjeenucfhrhhomhepvehh
    rhhishhtohhphhgvrhcuvfgrlhgsohhtuceotghhrhhishesthgrlhgsohhthhhomhgvrd
    gtohhmqeenucggtffrrghtthgvrhhnpeejgeeuudetteeujeehjeeuheeigeeugffhueei
    gedthfekiedthffhueejgfduudenucffohhmrghinhepphhurhhirdhsmhenucfkphepje
    dvrdelhedrvdegfedrudehieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpegthhhrihhssehtrghlsghothhhohhmvgdrtghomh
X-ME-Proxy: <xmx:x7xdYAUQGWN87Ff8u9G2PJ-Or7MIHy_7ufkIUAaMOGPaEv27dD-eAg>
    <xmx:x7xdYPJdlj46cV2gKQYPbV1he8Bm0ZuL2yx61hQb6sN6xZhEYGdMQQ>
    <xmx:x7xdYA96pQ7CU47d6JovG0p8NL_di80Ft31ZKjZmWkIaN2TdgVEIrQ>
    <xmx:x7xdYL3102GHxHYjJlvgcUSTKtztjv5yBf5w-jluEb_GYkUKNFFPUQ>
Received: from SpaceballstheLaptop.talbothome.com (unknown [72.95.243.156])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5B60124005D
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 06:51:51 -0400 (EDT)
Message-ID: <7b29e54909eae3a74f6c906339ab6561f2d5c768.camel@talbothome.com>
Subject: [PATCH 6/9] Update README
From:   Christopher Talbot <chris@talbothome.com>
To:     netdev@vger.kernel.org
Date:   Fri, 26 Mar 2021 06:51:51 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
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
-       ./configure --prefix=/usr
+    ./bootstrap-configure --prefix=/usr/
 
 Configure automatically searches for all required components and
packages.
 
-To compile and install run:
-       make && make install
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
2.30.0

