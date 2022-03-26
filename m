Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA774E8207
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 18:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233827AbiCZRCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 13:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233801AbiCZRCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 13:02:15 -0400
X-Greylist: delayed 63 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 26 Mar 2022 10:00:37 PDT
Received: from stuerz.xyz (stuerz.xyz [IPv6:2001:19f0:5:15da:5400:3ff:fecc:7379])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56432B0A55;
        Sat, 26 Mar 2022 10:00:37 -0700 (PDT)
Received: by stuerz.xyz (Postfix, from userid 114)
        id 9D1C6FBBCB; Sat, 26 Mar 2022 17:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648314036; bh=yA14H5kSGXs8c9NCVOmgKRy/cJtHbkLoXQ2K5ISZu/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eY1iX0wlkZRA78TwrFBdZG5S+wos6UWvMNaeR3ebSkGbpl4BzyM69Wnujm+MCNQSH
         XbYHpCtunp+VYPd+8B4Z5YGwrYKyldxYneKwJEtMuoQi4VfjayP4248ZkrvYzPbvb7
         tGC3cCNQMmjqLyVHL80IqUG9N6enWqcQ/eJAksuxRO0+t/nSWobYmI6E3gPDs1NmYL
         ++FZTGyvor1q8BXZzeNj7KNTMHP2+jtmpdc0KeaKsrUDcsC7Efw6IdkQp5pRDFDxi5
         ZHAUmnDb1nehnND3R9P08aARBVYF4iAixYWRlLVzHEAsYgL1pTWrWTNVmmmb1i34gg
         o2AMI/9CsY+SQ==
Received: from benni-fedora.. (unknown [IPv6:2a02:8109:a100:1a48:ff0:ef2f:d4da:17d8])
        by stuerz.xyz (Postfix) with ESMTPSA id E7EF6FB7D3;
        Sat, 26 Mar 2022 17:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648314033; bh=yA14H5kSGXs8c9NCVOmgKRy/cJtHbkLoXQ2K5ISZu/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M6I6oe9jogZM/zVnBnLg0eaNUUV4jcB+jkMO9qefS3HmAz419f42DcLOvKYiY1LvT
         ker3YtWSKtrbYWXcC4P4Q34z4I0kvS8nnURN2zDZp/1ciFgjp8H5+LMGc47dFCGwK3
         ZPM4LcjH7WSaWHLXUgQ1uu7Se/TXMvIZ6a51YDM4XN9HQOfPjY/V51c3xkYKlQc9Ff
         sw/spsdrAwyTcjFyMYk3HffZ0vEu3G6iY0fWhPwKxCUfoge6rziWcIxAyYMFWRia7f
         wJwSd/xnAYJBhYpaStdDoJq2gMpeyL3UlSNNsSRrS5W5qX2Ex1kaIwSG6rdxXYA+KQ
         WQdOdxe313yGg==
From:   =?UTF-8?q?Benjamin=20St=C3=BCrz?= <benni@stuerz.xyz>
To:     andrew@lunn.ch
Cc:     sebastian.hesselbarth@gmail.com, gregory.clement@bootlin.com,
        linux@armlinux.org.uk, linux@simtec.co.uk, krzk@kernel.org,
        alim.akhtar@samsung.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        robert.moore@intel.com, rafael.j.wysocki@intel.com,
        lenb@kernel.org, 3chas3@gmail.com, laforge@gnumonks.org,
        arnd@arndb.de, gregkh@linuxfoundation.org, mchehab@kernel.org,
        tony.luck@intel.com, james.morse@arm.com, rric@kernel.org,
        linus.walleij@linaro.org, brgl@bgdev.pl,
        mike.marciniszyn@cornelisnetworks.com,
        dennis.dalessandro@cornelisnetworks.com, jgg@ziepe.ca,
        pali@kernel.org, dmitry.torokhov@gmail.com, isdn@linux-pingi.de,
        benh@kernel.crashing.org, fbarrat@linux.ibm.com, ajd@linux.ibm.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        nico@fluxnic.net, loic.poulain@linaro.org, kvalo@kernel.org,
        pkshih@realtek.com, bhelgaas@google.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-acpi@vger.kernel.org, devel@acpica.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-input@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-media@vger.kernel.org,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-pci@vger.kernel.org,
        =?UTF-8?q?Benjamin=20St=C3=BCrz?= <benni@stuerz.xyz>
Subject: [PATCH 11/22] rdmavt: Replace comments with C99 initializers
Date:   Sat, 26 Mar 2022 17:58:58 +0100
Message-Id: <20220326165909.506926-11-benni@stuerz.xyz>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220326165909.506926-1-benni@stuerz.xyz>
References: <20220326165909.506926-1-benni@stuerz.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This replaces comments with C99's designated
initializers because the kernel supports them now.

Signed-off-by: Benjamin Stürz <benni@stuerz.xyz>
---
 drivers/infiniband/sw/rdmavt/rc.c | 62 +++++++++++++++----------------
 1 file changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/rc.c b/drivers/infiniband/sw/rdmavt/rc.c
index 4e5d4a27633c..121b8a23ac07 100644
--- a/drivers/infiniband/sw/rdmavt/rc.c
+++ b/drivers/infiniband/sw/rdmavt/rc.c
@@ -10,37 +10,37 @@
  * Convert the AETH credit code into the number of credits.
  */
 static const u16 credit_table[31] = {
-	0,                      /* 0 */
-	1,                      /* 1 */
-	2,                      /* 2 */
-	3,                      /* 3 */
-	4,                      /* 4 */
-	6,                      /* 5 */
-	8,                      /* 6 */
-	12,                     /* 7 */
-	16,                     /* 8 */
-	24,                     /* 9 */
-	32,                     /* A */
-	48,                     /* B */
-	64,                     /* C */
-	96,                     /* D */
-	128,                    /* E */
-	192,                    /* F */
-	256,                    /* 10 */
-	384,                    /* 11 */
-	512,                    /* 12 */
-	768,                    /* 13 */
-	1024,                   /* 14 */
-	1536,                   /* 15 */
-	2048,                   /* 16 */
-	3072,                   /* 17 */
-	4096,                   /* 18 */
-	6144,                   /* 19 */
-	8192,                   /* 1A */
-	12288,                  /* 1B */
-	16384,                  /* 1C */
-	24576,                  /* 1D */
-	32768                   /* 1E */
+	[0x00] = 0,
+	[0x01] = 1,
+	[0x02] = 2,
+	[0x03] = 3,
+	[0x04] = 4,
+	[0x05] = 6,
+	[0x06] = 8,
+	[0x07] = 12,
+	[0x08] = 16,
+	[0x09] = 24,
+	[0x0A] = 32,
+	[0x0B] = 48,
+	[0x0C] = 64,
+	[0x0D] = 96,
+	[0x0E] = 128,
+	[0x0F] = 192,
+	[0x10] = 256,
+	[0x11] = 384,
+	[0x12] = 512,
+	[0x13] = 768,
+	[0x14] = 1024,
+	[0x15] = 1536,
+	[0x16] = 2048,
+	[0x17] = 3072,
+	[0x18] = 4096,
+	[0x19] = 6144,
+	[0x1A] = 8192,
+	[0x1B] = 12288,
+	[0x1C] = 16384,
+	[0x1D] = 24576,
+	[0x1E] = 32768
 };
 
 /**
-- 
2.35.1

