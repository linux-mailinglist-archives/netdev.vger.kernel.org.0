Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 076AC4E82D7
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 18:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234379AbiCZRLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 13:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234045AbiCZRKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 13:10:39 -0400
Received: from stuerz.xyz (unknown [45.77.206.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F2D635865;
        Sat, 26 Mar 2022 10:08:58 -0700 (PDT)
Received: by stuerz.xyz (Postfix, from userid 114)
        id 321B8FBBA1; Sat, 26 Mar 2022 17:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648314016; bh=HOFmAYiVvnT7rSVfobZmsnPlgQ5nBBe17TNp3HtbNU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OE6w7EbGz4UZqMrSmnQO9S4DWG3C+A+XGWmHj1gGNyXwzuCg2tgyFaWJe3ge1xrGo
         ZklfkmLdhXZh1w7uCDZZYSk9u3CuqbZNayJumKTNAXg/GONO7RxnGJHUR037ruIdBS
         Fp2smpwss0tQxWIm5ODbwoyQx3wuUvnfU2SPBSOKVx496KvRNHoYqttGuF2H1XAiNF
         QgJ3pcxWWxo4xcwTRijChip3hD3SvUJ9xLQzFvcn1z9+nVDGjwLoeTSUfSgEOjjdMw
         I7qtII+gHEQFTrCQkdsK2RDYSiDDNbqp3GyqVLl6XkR0RjliCTrClhr7sk0bdeE9G+
         pKtdwiXsaftmw==
Received: from benni-fedora.. (unknown [IPv6:2a02:8109:a100:1a48:ff0:ef2f:d4da:17d8])
        by stuerz.xyz (Postfix) with ESMTPSA id 20D94FB7EA;
        Sat, 26 Mar 2022 17:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648314013; bh=HOFmAYiVvnT7rSVfobZmsnPlgQ5nBBe17TNp3HtbNU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hf7mJJcWBmIj3C+XCxyzFO7S9C0oUaIl8hxKEGBu6X8vw2n1pWSpj6iB15/DP+6Lp
         3QX2TjmaymPMgIhJcqwVkwY6dEsEyphIorKi1wt0xa4x6MJ6oAZB59LvQ3nuveeFu0
         348YW/tdR5UvOfRwGWcPa9XVwbxu+xibpp/4thWzzXOlH3zZnJHzTtHyLYycZzhdQ3
         Slg6rVaVkmUpHlV6SbMwW2oDlerJ1InqL387Q5Q/hQQJH1awaV4a52wpm8TuxMZYnL
         WGg8OJF9bO4XtyqoNzz5xIgxnsqwooQQF0Nsc2pHaLUBhYt9zf8O+zC8ZiS2I6nTZh
         bsWtkEHhv2HFw==
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
Subject: [PATCH 08/22] i5100: Replace comments with C99 initializers
Date:   Sat, 26 Mar 2022 17:58:55 +0100
Message-Id: <20220326165909.506926-8-benni@stuerz.xyz>
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
 drivers/edac/i5100_edac.c | 44 +++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/edac/i5100_edac.c b/drivers/edac/i5100_edac.c
index 324a46b8479b..5992f0ee5f28 100644
--- a/drivers/edac/i5100_edac.c
+++ b/drivers/edac/i5100_edac.c
@@ -379,28 +379,28 @@ static int i5100_rank_to_slot(const struct mem_ctl_info *mci,
 static const char *i5100_err_msg(unsigned err)
 {
 	static const char *merrs[] = {
-		"unknown", /* 0 */
-		"uncorrectable data ECC on replay", /* 1 */
-		"unknown", /* 2 */
-		"unknown", /* 3 */
-		"aliased uncorrectable demand data ECC", /* 4 */
-		"aliased uncorrectable spare-copy data ECC", /* 5 */
-		"aliased uncorrectable patrol data ECC", /* 6 */
-		"unknown", /* 7 */
-		"unknown", /* 8 */
-		"unknown", /* 9 */
-		"non-aliased uncorrectable demand data ECC", /* 10 */
-		"non-aliased uncorrectable spare-copy data ECC", /* 11 */
-		"non-aliased uncorrectable patrol data ECC", /* 12 */
-		"unknown", /* 13 */
-		"correctable demand data ECC", /* 14 */
-		"correctable spare-copy data ECC", /* 15 */
-		"correctable patrol data ECC", /* 16 */
-		"unknown", /* 17 */
-		"SPD protocol error", /* 18 */
-		"unknown", /* 19 */
-		"spare copy initiated", /* 20 */
-		"spare copy completed", /* 21 */
+		[0]  = "unknown",
+		[1]  = "uncorrectable data ECC on replay",
+		[2]  = "unknown",
+		[3]  = "unknown",
+		[4]  = "aliased uncorrectable demand data ECC",
+		[5]  = "aliased uncorrectable spare-copy data ECC",
+		[6]  = "aliased uncorrectable patrol data ECC",
+		[7]  = "unknown",
+		[8]  = "unknown",
+		[9]  = "unknown",
+		[10] = "non-aliased uncorrectable demand data ECC",
+		[11] = "non-aliased uncorrectable spare-copy data ECC",
+		[12] = "non-aliased uncorrectable patrol data ECC",
+		[13] = "unknown",
+		[14] = "correctable demand data ECC",
+		[15] = "correctable spare-copy data ECC",
+		[16] = "correctable patrol data ECC",
+		[17] = "unknown",
+		[18] = "SPD protocol error",
+		[19] = "unknown",
+		[20] = "spare copy initiated",
+		[21] = "spare copy completed",
 	};
 	unsigned i;
 
-- 
2.35.1

