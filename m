Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBB104081F3
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 23:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236546AbhILV7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 17:59:08 -0400
Received: from tartarus.angband.pl ([51.83.246.204]:39848 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236320AbhILV7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 17:59:07 -0400
X-Greylist: delayed 1915 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Sep 2021 17:59:06 EDT
Received: from 89-73-149-240.dynamic.chello.pl ([89.73.149.240] helo=barad-dur.angband.pl)
        by tartarus.angband.pl with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <kilobyte@angband.pl>)
        id 1mPWwj-00C2Z0-NR; Sun, 12 Sep 2021 23:23:31 +0200
Received: from [2a02:a31c:8245:f980::4] (helo=valinor.angband.pl)
        by barad-dur.angband.pl with esmtp (Exim 4.94.2)
        (envelope-from <kilobyte@angband.pl>)
        id 1mPWwi-0003Cv-Jr; Sun, 12 Sep 2021 23:23:28 +0200
Received: from kilobyte by valinor.angband.pl with local (Exim 4.95-RC2)
        (envelope-from <kilobyte@valinor.angband.pl>)
        id 1mPWwd-000343-D8;
        Sun, 12 Sep 2021 23:23:23 +0200
From:   Adam Borowski <kilobyte@angband.pl>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        David Howells <dhowells@redhat.com>, netdev@vger.kernel.org
Cc:     Adam Borowski <kilobyte@angband.pl>
Date:   Sun, 12 Sep 2021 23:23:21 +0200
Message-Id: <20210912212321.10982-1-kilobyte@angband.pl>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 89.73.149.240
X-SA-Exim-Mail-From: kilobyte@angband.pl
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on tartarus.angband.pl
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00=-1.9,RDNS_NONE=0.793,
        SPF_HELO_NONE=0.001,SPF_PASS=-0.001,TVD_RCVD_IP=0.001,
        URIBL_BLOCKED=0.001 autolearn=no autolearn_force=no languages=en
Subject: [PATCH] net: wan: wanxl: define CROSS_COMPILE_M68K
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on tartarus.angband.pl)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It was used but never set.  The hardcoded value from before the dawn of
time was non-standard; the usual name for cross-tools is $TRIPLET-$TOOL

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
 This is neither the host nor target arch, thus it's very unlikely to be
 set by the user.  With this patch, it works out of the box on Debian
 and Fedora.

 drivers/net/wan/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wan/Makefile b/drivers/net/wan/Makefile
index f6b92efffc94..480bcd1f6c1c 100644
--- a/drivers/net/wan/Makefile
+++ b/drivers/net/wan/Makefile
@@ -34,6 +34,8 @@ obj-$(CONFIG_SLIC_DS26522)	+= slic_ds26522.o
 clean-files := wanxlfw.inc
 $(obj)/wanxl.o:	$(obj)/wanxlfw.inc
 
+CROSS_COMPILE_M68K = m68k-linux-gnu-
+
 ifeq ($(CONFIG_WANXL_BUILD_FIRMWARE),y)
 ifeq ($(ARCH),m68k)
   M68KCC = $(CC)
-- 
2.33.0

