Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 919904E8248
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 18:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233946AbiCZRD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 13:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234096AbiCZRDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 13:03:41 -0400
Received: from stuerz.xyz (unknown [45.77.206.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A1E17289E;
        Sat, 26 Mar 2022 10:01:36 -0700 (PDT)
Received: by stuerz.xyz (Postfix, from userid 114)
        id 89F01FBB90; Sat, 26 Mar 2022 17:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648314095; bh=OIgqNWNKM4FUx2aMq66C59LbU1toNuGdnuhts8rWjzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NGGF9R0nGgvoNNFVbJq7YUOhpFoUvd+UDHPvUqEnMYzLPg6wG2+tJNo4wtSym83rv
         3e8aQn+XKbF4ttvz+4/KC3GeQGYXzEoJtc4y0BaafRf5EeDEg4ovOyVXZPS4FyKcRw
         42c5RuqTLZhMmlfOxY2yReWU3IX8rYIr5t1BuqHffgiBNdXmZ+Q61YcTqgbkXLqV3L
         H3bt49ICqE4L7YN0S0TZFVtOO1hluDvo1e7tniOsD047S/6Mh4K5ujrrtQTh5JZM4X
         MHcbHwfrRCu8oq7ZWcxEz7lDMAtFI8pfUKvg9henVTNaE1F2VXlf1qeW4DJ16fL0+s
         K2d8xFT7UTT5A==
Received: from benni-fedora.. (unknown [IPv6:2a02:8109:a100:1a48:ff0:ef2f:d4da:17d8])
        by stuerz.xyz (Postfix) with ESMTPSA id 88BC8FBB90;
        Sat, 26 Mar 2022 17:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648314092; bh=OIgqNWNKM4FUx2aMq66C59LbU1toNuGdnuhts8rWjzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q5q75UwSTKYtxZSPnmZk34FK8PeXDHcTNRBj5CzYGeK0w2pwNaZU+fi90Oz/WKkid
         4WEqyQWecLkpaeHn3vE+T8T9IhcPNKppIdLidXwWPOkvmIRMdMQbgLWo7vumkiu7Ys
         yL3ZKk/BMn4WTB83Nz4BUSd7BvbvSh4mfApi64G8Ns4vDjEHHeCqwRPzckTwSkHXvN
         1U+V2EqlTgJP/JpZgtNYZ8hAXXSUwrkojdQjapu3jM+5NwQBSrq5YhphrzOyacM/cb
         qKXKHKGluyZwgMCRmQwUm/8nWGTHWd6eeIhFKVdr6V3ZsPI8N++ZPoBFNYgkN7OQEI
         2haFTg5IDR/XQ==
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
Subject: [PATCH 20/22] wireless: Replace comments with C99 initializers
Date:   Sat, 26 Mar 2022 17:59:07 +0100
Message-Id: <20220326165909.506926-20-benni@stuerz.xyz>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220326165909.506926-1-benni@stuerz.xyz>
References: <20220326165909.506926-1-benni@stuerz.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,RDNS_DYNAMIC,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This replaces comments with C99's designated
initializers because the kernel supports them now.

Signed-off-by: Benjamin Stürz <benni@stuerz.xyz>
---
 drivers/net/wireless/ray_cs.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 87e98ab068ed..dd11018b956c 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -2529,20 +2529,23 @@ static void clear_interrupt(ray_dev_t *local)
 #define MAXDATA (PAGE_SIZE - 80)
 
 static const char *card_status[] = {
-	"Card inserted - uninitialized",	/* 0 */
-	"Card not downloaded",			/* 1 */
-	"Waiting for download parameters",	/* 2 */
-	"Card doing acquisition",		/* 3 */
-	"Acquisition complete",			/* 4 */
-	"Authentication complete",		/* 5 */
-	"Association complete",			/* 6 */
-	"???", "???", "???", "???",		/* 7 8 9 10 undefined */
-	"Card init error",			/* 11 */
-	"Download parameters error",		/* 12 */
-	"???",					/* 13 */
-	"Acquisition failed",			/* 14 */
-	"Authentication refused",		/* 15 */
-	"Association failed"			/* 16 */
+	[0]  = "Card inserted - uninitialized",
+	[1]  = "Card not downloaded",
+	[2]  = "Waiting for download parameters",
+	[3]  = "Card doing acquisition",
+	[4]  = "Acquisition complete",
+	[5]  = "Authentication complete",
+	[6]  = "Association complete",
+	[7]  = "???",
+	[8]  = "???",
+	[9]  = "???",
+	[10] = "???",
+	[11] = "Card init error",
+	[12] = "Download parameters error",
+	[13] = "???",
+	[14] = "Acquisition failed",
+	[15] = "Authentication refused",
+	[16] = "Association failed"
 };
 
 static const char *nettype[] = { "Adhoc", "Infra " };
-- 
2.35.1

