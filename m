Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED904E827D
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 18:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234035AbiCZREP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 13:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233951AbiCZRDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 13:03:43 -0400
Received: from stuerz.xyz (stuerz.xyz [IPv6:2001:19f0:5:15da:5400:3ff:fecc:7379])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3368715AAD6;
        Sat, 26 Mar 2022 10:01:43 -0700 (PDT)
Received: by stuerz.xyz (Postfix, from userid 114)
        id 7AF43FBC10; Sat, 26 Mar 2022 17:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648314102; bh=HDJNUFNaZRuc9mdrjQyM6/8vy0/JkqPoaLqrDaW8yUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MPX8tpVMaFbdSJvOE5XpZe7uyB0j+wZg+z+c0qMaBvnR3Jzeqpgnh6ZGNW8jlWnx+
         6m1HLCCAL/LlSkiFTb/2ai410EvQap1o5JtBdsyjpqSUXrwp6SA2RDRiox/4Z7Ga7y
         IiL6XKdBqT6tyS0T1Vs5heqFUdhN+iCGCSnBnE0sXrPiI1MReVK0pmMRImRpx396pR
         oUwZzCrfkVgUlxGFlsT0HgzoOe6LdBAeRG8RAcSFachsU0QmVLGhUPBiyoik87jzqN
         kWeWUKeB+EUMZ6UoK8ijGqTRGWFCIJJtCR9v9fK906IqAQkF1nUk7xej9UDb+irIrc
         tTCAXX7DRYG7w==
Received: from benni-fedora.. (unknown [IPv6:2a02:8109:a100:1a48:ff0:ef2f:d4da:17d8])
        by stuerz.xyz (Postfix) with ESMTPSA id 2DB82FB7CD;
        Sat, 26 Mar 2022 17:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648314099; bh=HDJNUFNaZRuc9mdrjQyM6/8vy0/JkqPoaLqrDaW8yUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZESfxOfP1ficzDOwydWI8+C/F3ouJMGJC6tf4AKAkdEpregRcXG20PgsKtilPdq13
         W8EQ3Cx6FOQOODyzjZ4lr+IgSLtoZaHTd5NxIpWRWspaT6BIxn1UVuyHgCtPOT4yQM
         bQpR2xEtzDBvOPbq532lUAGfrGyFBs3w68d5bAYuc4MO1PWb0x91MTstmWRpqnA1G7
         Sd0vZvLmGNBHaSZCx5xqn9XMMwtxOCTq4Rl5edD9hsUWeMqoJlv1bfYjRbXz0abjYX
         5DBq5O7rPCyiTxa6LC7JLdHrRuIfiSnkjqC6svuFsQd2U8uQUnuqEPJ19MzTs6mDJD
         18n23nDk5z+1Q==
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
Subject: [PATCH 21/22] rtw89: Replace comments with C99 initializers
Date:   Sat, 26 Mar 2022 17:59:08 +0100
Message-Id: <20220326165909.506926-21-benni@stuerz.xyz>
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
 drivers/net/wireless/realtek/rtw89/coex.c | 40 +++++++++++------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 684583955511..3c83a0bfb120 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -97,26 +97,26 @@ static const struct rtw89_btc_fbtc_slot s_def[] = {
 };
 
 static const u32 cxtbl[] = {
-	0xffffffff, /* 0 */
-	0xaaaaaaaa, /* 1 */
-	0x55555555, /* 2 */
-	0x66555555, /* 3 */
-	0x66556655, /* 4 */
-	0x5a5a5a5a, /* 5 */
-	0x5a5a5aaa, /* 6 */
-	0xaa5a5a5a, /* 7 */
-	0x6a5a5a5a, /* 8 */
-	0x6a5a5aaa, /* 9 */
-	0x6a5a6a5a, /* 10 */
-	0x6a5a6aaa, /* 11 */
-	0x6afa5afa, /* 12 */
-	0xaaaa5aaa, /* 13 */
-	0xaaffffaa, /* 14 */
-	0xaa5555aa, /* 15 */
-	0xfafafafa, /* 16 */
-	0xffffddff, /* 17 */
-	0xdaffdaff, /* 18 */
-	0xfafadafa  /* 19 */
+	[0]  = 0xffffffff,
+	[1]  = 0xaaaaaaaa,
+	[2]  = 0x55555555,
+	[3]  = 0x66555555,
+	[4]  = 0x66556655,
+	[5]  = 0x5a5a5a5a,
+	[6]  = 0x5a5a5aaa,
+	[7]  = 0xaa5a5a5a,
+	[8]  = 0x6a5a5a5a,
+	[9]  = 0x6a5a5aaa,
+	[10] = 0x6a5a6a5a,
+	[11] = 0x6a5a6aaa,
+	[12] = 0x6afa5afa,
+	[13] = 0xaaaa5aaa,
+	[14] = 0xaaffffaa,
+	[15] = 0xaa5555aa,
+	[16] = 0xfafafafa,
+	[17] = 0xffffddff,
+	[18] = 0xdaffdaff,
+	[19] = 0xfafadafa
 };
 
 struct rtw89_btc_btf_tlv {
-- 
2.35.1

