Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC254E827A
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 18:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233967AbiCZRDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 13:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233923AbiCZRDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 13:03:18 -0400
Received: from stuerz.xyz (stuerz.xyz [IPv6:2001:19f0:5:15da:5400:3ff:fecc:7379])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305A716F07B;
        Sat, 26 Mar 2022 10:01:24 -0700 (PDT)
Received: by stuerz.xyz (Postfix, from userid 114)
        id 7761FFBC19; Sat, 26 Mar 2022 17:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648314083; bh=Atyp98CUeE2ls+rskgXqrYpiNVHIwFrsLn7qDkbs1Uk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=emwG8nalb+cKRb9rbSSMQUWpXih8LgYIA+oLYyPxg44CRUiEfKtmNngfXMyv7UPQO
         ruUDGJ4RMfUnJ5R2cUfUoKVElH7YDMeVF8V+vienoYH8AjJhvBfm6OmqCxGxbP38Iq
         vFCrvCxPz+mG5euXDJwYDf0etqWfnfKqwqKrTIMO4gCM3Mm6MTU6epmZUHgD80e0qp
         PV4vsElXkb/6jUHVpzh9+Z+gdhROvdd09FYVd71UGN/8Wl+P3a9ocdNAf1Y3qQ2WbC
         ycBnyl1uQxHF107aaHJcc2LASnsDdojAGotqxPBvlvmK3IKHevKi60FuawcSkIfK6W
         EQ+ebWKwBO17g==
Received: from benni-fedora.. (unknown [IPv6:2a02:8109:a100:1a48:ff0:ef2f:d4da:17d8])
        by stuerz.xyz (Postfix) with ESMTPSA id 4CC2BFBB90;
        Sat, 26 Mar 2022 17:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648314079; bh=Atyp98CUeE2ls+rskgXqrYpiNVHIwFrsLn7qDkbs1Uk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qP7TgvW3oJ/sA3Yix4CPfWDhnnvNFSatDRinq+EiKUXUQ0FdQI4CUN9Ml1XU1whAq
         vjdvv9SLrRySrhuWfF7F3KT2Q0Q/afP2v/4p8uBka44hkcxbWaTdYLE/dfa6u+aVZs
         Hu5FjvNMk5YoWc87f4DSc4bGRxf3NY8w37161qCITHdWuasXmmoH++J1nnLZ8uMitr
         F2UHAiWPQaYkH9C51bVT6N2PKeePCyXwAGryWdjCX70SGZRwLFc7L5r/epKTjpJVF3
         Zxaxa7nN8V9aWqLDpaEQ1RakPYyfGoCHqw6V3gcaaKjBWRIkdx8c/QesH3NlUg1hGk
         gD7/Pz6t0ggBg==
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
Subject: [PATCH 18/22] smsc: Replace comments with C99 initializers
Date:   Sat, 26 Mar 2022 17:59:05 +0100
Message-Id: <20220326165909.506926-18-benni@stuerz.xyz>
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
 drivers/net/ethernet/smsc/smc9194.h | 15 ++++++---------
 drivers/net/ethernet/smsc/smc91x.h  | 18 ++++++++----------
 2 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smc9194.h b/drivers/net/ethernet/smsc/smc9194.h
index cf69d0a5a1cb..e1c780afb9bb 100644
--- a/drivers/net/ethernet/smsc/smc9194.h
+++ b/drivers/net/ethernet/smsc/smc9194.h
@@ -163,15 +163,12 @@ typedef unsigned long int 		dword;
 #define CHIP_91100	7
 
 static const char * chip_ids[ 15 ] =  {
-	NULL, NULL, NULL,
-	/* 3 */ "SMC91C90/91C92",
-	/* 4 */ "SMC91C94",
-	/* 5 */ "SMC91C95",
-	NULL,
-	/* 7 */ "SMC91C100",
-	/* 8 */ "SMC91C100FD",
-	NULL, NULL, NULL,
-	NULL, NULL, NULL};
+	[3] = "SMC91C90/91C92",
+	[4] = "SMC91C94",
+	[5] = "SMC91C95",
+	[7] = "SMC91C100",
+	[8] = "SMC91C100FD",
+};
 
 /*
  . Transmit status bits
diff --git a/drivers/net/ethernet/smsc/smc91x.h b/drivers/net/ethernet/smsc/smc91x.h
index 387539a8094b..122cdc849507 100644
--- a/drivers/net/ethernet/smsc/smc91x.h
+++ b/drivers/net/ethernet/smsc/smc91x.h
@@ -731,16 +731,14 @@ smc_pxa_dma_insw(void __iomem *ioaddr, struct smc_local *lp, int reg, int dma,
 #define CHIP_91111FD	9
 
 static const char * chip_ids[ 16 ] =  {
-	NULL, NULL, NULL,
-	/* 3 */ "SMC91C90/91C92",
-	/* 4 */ "SMC91C94",
-	/* 5 */ "SMC91C95",
-	/* 6 */ "SMC91C96",
-	/* 7 */ "SMC91C100",
-	/* 8 */ "SMC91C100FD",
-	/* 9 */ "SMC91C11xFD",
-	NULL, NULL, NULL,
-	NULL, NULL, NULL};
+	[3] = "SMC91C90/91C92",
+	[4] = "SMC91C94",
+	[5] = "SMC91C95",
+	[6] = "SMC91C96",
+	[7] = "SMC91C100",
+	[8] = "SMC91C100FD",
+	[9] = "SMC91C11xFD",
+};
 
 
 /*
-- 
2.35.1

