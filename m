Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 564635E8726
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 03:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233230AbiIXBz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 21:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiIXBzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 21:55:04 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D69B11C177;
        Fri, 23 Sep 2022 18:53:58 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id s9so1183340qkg.4;
        Fri, 23 Sep 2022 18:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=43SXffg/t7leRRsvtxKYneBrli3Hdm/u8KXwc6UYSMU=;
        b=nLfcoztZ3a6N0PvUWHzt96Jmss2I72Yc/0yHoxlo9P2da8lYhn4BMBKOL2cup9sTSa
         9OGYChtVMW7LiiF4/Wg0L4hxGBnaj4keN4zSgRis6TWTFp/ZTOJx32kWWDQOL3VCE9ky
         q3SblV7xDJX3inoPz4WF06esH28E9ZPzM5/IYj5S5grX0Bs8TMp1vR/Mxl8jWZP3woV+
         97XphmZSv7wvdIgEji1+cN+9OIICrkplBCBPA85Q1vqB2cV+7hjScMtko59qgAUm9T7E
         cgpurR/2x3h7lmLOhEJZCFaMHlOQ44ttUBo9i57MvyuB1/ct5i5FsQm4YlqQpKMevTLP
         bvuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=43SXffg/t7leRRsvtxKYneBrli3Hdm/u8KXwc6UYSMU=;
        b=xq2p71XZPH9/vXf2NsRRxzRpjO8mVG2jrkcFtHKRQz4g2g4iFbcQZQySubd996D84t
         UAion88manjEYsH8Hh6vzzDT+jAgfP7fJQgpBunn7y0xuuXj+sJ2/i/Ks5dRjG20wIud
         RQbmX1mH49HOmnZGLKfhT+h4T/exAiurUisCFkoGibLUCCSVG+Dc3SJemO2fFOWVb0WY
         fuv2BEQHOb84tgmkB9flq3ycSE83w07xKCMS+KUZ2BuEa5aHZl5uUqkpDzC2eU0va+vi
         k596jsh2QNoicknj54J2y8JvayiQNfeZnPimZvS5mCf53ozhKbaCheJQZiFGNl0Y1X9C
         lqLg==
X-Gm-Message-State: ACrzQf0/1WimgXJv7Z7akX9m88FTELIl1uVqNZftngD4YrSmsqE5WhDl
        QsNel3IroxZ7/Y2b12rYjPc=
X-Google-Smtp-Source: AMsMyM6DLVIRzdiaNY0C4JhCW1387Q737dGQm3ilVzhgmyLNrur/Jo7IJuTO9xPZDBRWtxZ3r7U6zQ==
X-Received: by 2002:a05:620a:750:b0:6ce:3d8e:3a1a with SMTP id i16-20020a05620a075000b006ce3d8e3a1amr7477558qki.590.1663984437409;
        Fri, 23 Sep 2022 18:53:57 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id s4-20020a05620a254400b006cf43968db6sm6955352qko.76.2022.09.23.18.53.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 18:53:57 -0700 (PDT)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Nick Bowler <nbowler@draconx.ca>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Zheyu Ma <zheyuma97@gmail.com>,
        linux-kernel@vger.kernel.org (open list),
        Sean Anderson <seanga2@gmail.com>
Subject: [PATCH net-next v2 11/13] sunhme: Combine continued messages
Date:   Fri, 23 Sep 2022 21:53:37 -0400
Message-Id: <20220924015339.1816744-12-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220924015339.1816744-1-seanga2@gmail.com>
References: <20220924015339.1816744-1-seanga2@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver seems to have been written under the assumption that messages
can be continued arbitrarily. I'm not when this changed (if ever), but such
ad-hoc continuations are liable to be rudely interrupted. Convert all such
instances to single prints. This loses a bit of timing information (such as
when a line was constructed piecemeal as the function executed), but it's
easy to add a few prints if necessary. This also adds newlines to the ends
of any prints without them.

Since (almost every) debug print included the name of the function, include
it automatically.

Signed-off-by: Sean Anderson <seanga2@gmail.com>
---

Changes in v2:
- Remove repeated newline
- Remove another excess debug

 drivers/net/ethernet/sun/sunhme.c | 278 +++++++++++-------------------
 1 file changed, 105 insertions(+), 173 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index fad98e20a63f..51a04353e08e 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -80,32 +80,33 @@ static struct quattro *qfe_sbus_list;
 static struct quattro *qfe_pci_list;
 #endif
 
-#define HMD pr_debug
+#define hme_debug(fmt, ...) pr_debug("%s: " fmt, __func__, ##__VA_ARGS__)
+#define HMD hme_debug
 
 /* "Auto Switch Debug" aka phy debug */
-#if 0
-#define ASD pr_debug
+#if 1
+#define ASD hme_debug
 #else
 #define ASD(...)
 #endif
 
 /* Transmit debug */
-#if 0
-#define TXD pr_debug
+#if 1
+#define TXD hme_debug
 #else
 #define TXD(...)
 #endif
 
 /* Skid buffer debug */
-#if 0
-#define SXD pr_debug
+#if 1
+#define SXD hme_debug
 #else
 #define SXD(...)
 #endif
 
 /* Receive debug */
-#if 0
-#define RXD pr_debug
+#if 1
+#define RXD hme_debug
 #else
 #define RXD(...)
 #endif
@@ -330,8 +331,6 @@ static int happy_meal_bb_read(struct happy_meal *hp,
 	int retval = 0;
 	int i;
 
-	ASD("happy_meal_bb_read: reg=%d ", reg);
-
 	/* Enable the MIF BitBang outputs. */
 	hme_write32(hp, tregs + TCVR_BBOENAB, 1);
 
@@ -365,7 +364,7 @@ static int happy_meal_bb_read(struct happy_meal *hp,
 	(void) BB_GET_BIT2(hp, tregs, (hp->tcvr_type == internal));
 	(void) BB_GET_BIT2(hp, tregs, (hp->tcvr_type == internal));
 	(void) BB_GET_BIT2(hp, tregs, (hp->tcvr_type == internal));
-	ASD("value=%x\n", retval);
+	ASD("reg=%d value=%x\n", reg, retval);
 	return retval;
 }
 
@@ -376,7 +375,7 @@ static void happy_meal_bb_write(struct happy_meal *hp,
 	u32 tmp;
 	int i;
 
-	ASD("happy_meal_bb_write: reg=%d value=%x\n", reg, value);
+	ASD("reg=%d value=%x\n", reg, value);
 
 	/* Enable the MIF BitBang outputs. */
 	hme_write32(hp, tregs + TCVR_BBOENAB, 1);
@@ -420,7 +419,6 @@ static int happy_meal_tcvr_read(struct happy_meal *hp,
 	int tries = TCVR_READ_TRIES;
 	int retval;
 
-	ASD("happy_meal_tcvr_read: reg=0x%02x ", reg);
 	if (hp->tcvr_type == none) {
 		ASD("no transceiver, value=TCVR_FAILURE\n");
 		return TCVR_FAILURE;
@@ -440,7 +438,7 @@ static int happy_meal_tcvr_read(struct happy_meal *hp,
 		return TCVR_FAILURE;
 	}
 	retval = hme_read32(hp, tregs + TCVR_FRAME) & 0xffff;
-	ASD("value=%04x\n", retval);
+	ASD("reg=0x%02x value=%04x\n", reg, retval);
 	return retval;
 }
 
@@ -452,7 +450,7 @@ static void happy_meal_tcvr_write(struct happy_meal *hp,
 {
 	int tries = TCVR_WRITE_TRIES;
 
-	ASD("happy_meal_tcvr_write: reg=0x%02x value=%04x\n", reg, value);
+	ASD("reg=0x%02x value=%04x\n", reg, value);
 
 	/* Welcome to Sun Microsystems, can I take your order please? */
 	if (!(hp->happy_flags & HFLAG_FENABLE)) {
@@ -817,7 +815,7 @@ static void happy_meal_tx_reset(struct happy_meal *hp, void __iomem *bregs)
 {
 	int tries = TX_RESET_TRIES;
 
-	HMD("happy_meal_tx_reset: reset, ");
+	HMD("reset...\n");
 
 	/* Would you like to try our SMCC Delux? */
 	hme_write32(hp, bregs + BMAC_TXSWRESET, 0);
@@ -837,7 +835,7 @@ static void happy_meal_rx_reset(struct happy_meal *hp, void __iomem *bregs)
 {
 	int tries = RX_RESET_TRIES;
 
-	HMD("happy_meal_rx_reset: reset, ");
+	HMD("reset...\n");
 
 	/* We have a special on GNU/Viking hardware bugs today. */
 	hme_write32(hp, bregs + BMAC_RXSWRESET, 0);
@@ -846,7 +844,7 @@ static void happy_meal_rx_reset(struct happy_meal *hp, void __iomem *bregs)
 
 	/* Will that be all? */
 	if (!tries)
-		netdev_err(hp->dev, "Receiver BigMac ATTACK!");
+		netdev_err(hp->dev, "Receiver BigMac ATTACK!\n");
 
 	/* Don't forget your vik_1137125_wa.  Have a nice day. */
 	HMD("done\n");
@@ -859,7 +857,7 @@ static void happy_meal_stop(struct happy_meal *hp, void __iomem *gregs)
 {
 	int tries = STOP_TRIES;
 
-	HMD("happy_meal_stop: reset, ");
+	HMD("reset...\n");
 
 	/* We're consolidating our STB products, it's your lucky day. */
 	hme_write32(hp, gregs + GREG_SWRESET, GREG_RESET_ALL);
@@ -868,7 +866,7 @@ static void happy_meal_stop(struct happy_meal *hp, void __iomem *gregs)
 
 	/* Come back next week when we are "Sun Microelectronics". */
 	if (!tries)
-		netdev_err(hp->dev, "Fry guys.");
+		netdev_err(hp->dev, "Fry guys.\n");
 
 	/* Remember: "Different name, same old buggy as shit hardware." */
 	HMD("done\n");
@@ -900,21 +898,18 @@ static void happy_meal_get_counters(struct happy_meal *hp, void __iomem *bregs)
 /* hp->happy_lock must be held */
 static void happy_meal_poll_stop(struct happy_meal *hp, void __iomem *tregs)
 {
-	ASD("happy_meal_poll_stop: ");
-
 	/* If polling disabled or not polling already, nothing to do. */
 	if ((hp->happy_flags & (HFLAG_POLLENABLE | HFLAG_POLL)) !=
 	   (HFLAG_POLLENABLE | HFLAG_POLL)) {
-		HMD("not polling, return\n");
+		ASD("not polling, return\n");
 		return;
 	}
 
 	/* Shut up the MIF. */
-	ASD("were polling, mif ints off, ");
+	ASD("were polling, mif ints off, polling off\n");
 	hme_write32(hp, tregs + TCVR_IMASK, 0xffff);
 
 	/* Turn off polling. */
-	ASD("polling off, ");
 	hme_write32(hp, tregs + TCVR_CFG,
 		    hme_read32(hp, tregs + TCVR_CFG) & ~(TCV_CFG_PENABLE));
 
@@ -939,29 +934,25 @@ static int happy_meal_tcvr_reset(struct happy_meal *hp, void __iomem *tregs)
 	int result, tries = TCVR_RESET_TRIES;
 
 	tconfig = hme_read32(hp, tregs + TCVR_CFG);
-	ASD("happy_meal_tcvr_reset: tcfg<%08lx> ", tconfig);
+	ASD("tcfg=%08x\n", tconfig);
 	if (hp->tcvr_type == external) {
-		ASD("external<");
 		hme_write32(hp, tregs + TCVR_CFG, tconfig & ~(TCV_CFG_PSELECT));
 		hp->tcvr_type = internal;
 		hp->paddr = TCV_PADDR_ITX;
-		ASD("ISOLATE,");
 		happy_meal_tcvr_write(hp, tregs, MII_BMCR,
 				      (BMCR_LOOPBACK|BMCR_PDOWN|BMCR_ISOLATE));
 		result = happy_meal_tcvr_read(hp, tregs, MII_BMCR);
 		if (result == TCVR_FAILURE) {
-			ASD("phyread_fail>\n");
+			ASD("phyread_fail\n");
 			return -1;
 		}
-		ASD("phyread_ok,PSELECT>");
+		ASD("external: ISOLATE, phyread_ok, PSELECT\n");
 		hme_write32(hp, tregs + TCVR_CFG, tconfig | TCV_CFG_PSELECT);
 		hp->tcvr_type = external;
 		hp->paddr = TCV_PADDR_ETX;
 	} else {
 		if (tconfig & TCV_CFG_MDIO1) {
-			ASD("internal<PSELECT,");
 			hme_write32(hp, tregs + TCVR_CFG, (tconfig | TCV_CFG_PSELECT));
-			ASD("ISOLATE,");
 			happy_meal_tcvr_write(hp, tregs, MII_BMCR,
 					      (BMCR_LOOPBACK|BMCR_PDOWN|BMCR_ISOLATE));
 			result = happy_meal_tcvr_read(hp, tregs, MII_BMCR);
@@ -969,14 +960,14 @@ static int happy_meal_tcvr_reset(struct happy_meal *hp, void __iomem *tregs)
 				ASD("phyread_fail>\n");
 				return -1;
 			}
-			ASD("phyread_ok,~PSELECT>");
+			ASD("internal: PSELECT, ISOLATE, phyread_ok, ~PSELECT\n");
 			hme_write32(hp, tregs + TCVR_CFG, (tconfig & ~(TCV_CFG_PSELECT)));
 			hp->tcvr_type = internal;
 			hp->paddr = TCV_PADDR_ITX;
 		}
 	}
 
-	ASD("BMCR_RESET ");
+	ASD("BMCR_RESET...\n");
 	happy_meal_tcvr_write(hp, tregs, MII_BMCR, BMCR_RESET);
 
 	while (--tries) {
@@ -1000,7 +991,7 @@ static int happy_meal_tcvr_reset(struct happy_meal *hp, void __iomem *tregs)
 	hp->sw_physid2   = happy_meal_tcvr_read(hp, tregs, MII_PHYSID2);
 	hp->sw_advertise = happy_meal_tcvr_read(hp, tregs, MII_ADVERTISE);
 
-	ASD("UNISOLATE");
+	ASD("UNISOLATE...\n");
 	hp->sw_bmcr &= ~(BMCR_ISOLATE);
 	happy_meal_tcvr_write(hp, tregs, MII_BMCR, hp->sw_bmcr);
 
@@ -1014,10 +1005,10 @@ static int happy_meal_tcvr_reset(struct happy_meal *hp, void __iomem *tregs)
 		udelay(20);
 	}
 	if (!tries) {
-		ASD(" FAILED!\n");
+		ASD("UNISOLATE FAILED!\n");
 		return -1;
 	}
-	ASD(" SUCCESS and CSCONFIG_DFBYPASS\n");
+	ASD("SUCCESS and CSCONFIG_DFBYPASS\n");
 	if (!is_lucent_phy(hp)) {
 		result = happy_meal_tcvr_read(hp, tregs,
 					      DP83840_CSCONFIG);
@@ -1035,61 +1026,55 @@ static void happy_meal_transceiver_check(struct happy_meal *hp, void __iomem *tr
 {
 	unsigned long tconfig = hme_read32(hp, tregs + TCVR_CFG);
 
-	ASD("happy_meal_transceiver_check: tcfg=%08lx ", tconfig);
+	ASD("tcfg=%08lx\n", tconfig);
 	if (hp->happy_flags & HFLAG_POLL) {
 		/* If we are polling, we must stop to get the transceiver type. */
-		ASD("<polling> ");
 		if (hp->tcvr_type == internal) {
 			if (tconfig & TCV_CFG_MDIO1) {
-				ASD("<internal> <poll stop> ");
 				happy_meal_poll_stop(hp, tregs);
 				hp->paddr = TCV_PADDR_ETX;
 				hp->tcvr_type = external;
-				ASD("<external>\n");
 				tconfig &= ~(TCV_CFG_PENABLE);
 				tconfig |= TCV_CFG_PSELECT;
 				hme_write32(hp, tregs + TCVR_CFG, tconfig);
+				ASD("poll stop, internal->external\n");
 			}
 		} else {
 			if (hp->tcvr_type == external) {
-				ASD("<external> ");
 				if (!(hme_read32(hp, tregs + TCVR_STATUS) >> 16)) {
-					ASD("<poll stop> ");
 					happy_meal_poll_stop(hp, tregs);
 					hp->paddr = TCV_PADDR_ITX;
 					hp->tcvr_type = internal;
-					ASD("<internal>\n");
 					hme_write32(hp, tregs + TCVR_CFG,
 						    hme_read32(hp, tregs + TCVR_CFG) &
 						    ~(TCV_CFG_PSELECT));
+					ASD("poll stop, external->internal\n");
 				}
-				ASD("\n");
 			} else {
-				ASD("<none>\n");
+				ASD("polling, none\n");
 			}
 		}
 	} else {
 		u32 reread = hme_read32(hp, tregs + TCVR_CFG);
 
 		/* Else we can just work off of the MDIO bits. */
-		ASD("<not polling> ");
 		if (reread & TCV_CFG_MDIO1) {
 			hme_write32(hp, tregs + TCVR_CFG, tconfig | TCV_CFG_PSELECT);
 			hp->paddr = TCV_PADDR_ETX;
 			hp->tcvr_type = external;
-			ASD("<external>\n");
+			ASD("not polling, external\n");
 		} else {
 			if (reread & TCV_CFG_MDIO0) {
 				hme_write32(hp, tregs + TCVR_CFG,
 					    tconfig & ~(TCV_CFG_PSELECT));
 				hp->paddr = TCV_PADDR_ITX;
 				hp->tcvr_type = internal;
-				ASD("<internal>\n");
+				ASD("not polling, internal\n");
 			} else {
 				netdev_err(hp->dev,
 					   "Transceiver and a coke please.");
 				hp->tcvr_type = none; /* Grrr... */
-				ASD("<none>\n");
+				ASD("not polling, none\n");
 			}
 		}
 	}
@@ -1196,15 +1181,14 @@ static void happy_meal_init_rings(struct happy_meal *hp)
 	struct hmeal_init_block *hb = hp->happy_block;
 	int i;
 
-	HMD("happy_meal_init_rings: counters to zero, ");
+	HMD("counters to zero\n");
 	hp->rx_new = hp->rx_old = hp->tx_new = hp->tx_old = 0;
 
 	/* Free any skippy bufs left around in the rings. */
-	HMD("clean, ");
 	happy_meal_clean_rings(hp);
 
 	/* Now get new skippy bufs for the receive ring. */
-	HMD("init rxring, ");
+	HMD("init rxring\n");
 	for (i = 0; i < RX_RING_SIZE; i++) {
 		struct sk_buff *skb;
 		u32 mapping;
@@ -1231,7 +1215,7 @@ static void happy_meal_init_rings(struct happy_meal *hp)
 		skb_reserve(skb, RX_OFFSET);
 	}
 
-	HMD("init txring, ");
+	HMD("init txring\n");
 	for (i = 0; i < TX_RING_SIZE; i++)
 		hme_write_txd(hp, &hb->happy_meal_txd[i], 0, 0);
 
@@ -1282,17 +1266,11 @@ happy_meal_begin_auto_negotiation(struct happy_meal *hp,
 		 * XXX so I completely skip checking for it in the BMSR for now.
 		 */
 
-#ifdef AUTO_SWITCH_DEBUG
-		ASD("%s: Advertising [ ");
-		if (hp->sw_advertise & ADVERTISE_10HALF)
-			ASD("10H ");
-		if (hp->sw_advertise & ADVERTISE_10FULL)
-			ASD("10F ");
-		if (hp->sw_advertise & ADVERTISE_100HALF)
-			ASD("100H ");
-		if (hp->sw_advertise & ADVERTISE_100FULL)
-			ASD("100F ");
-#endif
+		ASD("Advertising [ %s%s%s%s]\n",
+		    hp->sw_advertise & ADVERTISE_10HALF ? "10H " : "",
+		    hp->sw_advertise & ADVERTISE_10FULL ? "10F " : "",
+		    hp->sw_advertise & ADVERTISE_100HALF ? "100H " : "",
+		    hp->sw_advertise & ADVERTISE_100FULL ? "100F " : "");
 
 		/* Enable Auto-Negotiation, this is usually on already... */
 		hp->sw_bmcr |= BMCR_ANENABLE;
@@ -1371,15 +1349,15 @@ static int happy_meal_init(struct happy_meal *hp)
 	void __iomem *erxregs      = hp->erxregs;
 	void __iomem *bregs        = hp->bigmacregs;
 	void __iomem *tregs        = hp->tcvregs;
+	const char *bursts;
 	u32 regtmp, rxcfg;
 
 	/* If auto-negotiation timer is running, kill it. */
 	del_timer(&hp->happy_timer);
 
-	HMD("happy_meal_init: happy_flags[%08x] ",
-	    hp->happy_flags);
+	HMD("happy_flags[%08x]\n", hp->happy_flags);
 	if (!(hp->happy_flags & HFLAG_INIT)) {
-		HMD("set HFLAG_INIT, ");
+		HMD("set HFLAG_INIT\n");
 		hp->happy_flags |= HFLAG_INIT;
 		happy_meal_get_counters(hp, bregs);
 	}
@@ -1389,26 +1367,26 @@ static int happy_meal_init(struct happy_meal *hp)
 	happy_meal_poll_stop(hp, tregs);
 
 	/* Stop transmitter and receiver. */
-	HMD("happy_meal_init: to happy_meal_stop\n");
+	HMD("to happy_meal_stop\n");
 	happy_meal_stop(hp, gregs);
 
 	/* Alloc and reset the tx/rx descriptor chains. */
-	HMD("happy_meal_init: to happy_meal_init_rings\n");
+	HMD("to happy_meal_init_rings\n");
 	happy_meal_init_rings(hp);
 
 	/* Shut up the MIF. */
-	HMD("happy_meal_init: Disable all MIF irqs (old[%08x]), ",
+	HMD("Disable all MIF irqs (old[%08x])\n",
 	    hme_read32(hp, tregs + TCVR_IMASK));
 	hme_write32(hp, tregs + TCVR_IMASK, 0xffff);
 
 	/* See if we can enable the MIF frame on this card to speak to the DP83840. */
 	if (hp->happy_flags & HFLAG_FENABLE) {
-		HMD("use frame old[%08x], ",
+		HMD("use frame old[%08x]\n",
 		    hme_read32(hp, tregs + TCVR_CFG));
 		hme_write32(hp, tregs + TCVR_CFG,
 			    hme_read32(hp, tregs + TCVR_CFG) & ~(TCV_CFG_BENABLE));
 	} else {
-		HMD("use bitbang old[%08x], ",
+		HMD("use bitbang old[%08x]\n",
 		    hme_read32(hp, tregs + TCVR_CFG));
 		hme_write32(hp, tregs + TCVR_CFG,
 			    hme_read32(hp, tregs + TCVR_CFG) | TCV_CFG_BENABLE);
@@ -1419,22 +1397,21 @@ static int happy_meal_init(struct happy_meal *hp)
 	happy_meal_transceiver_check(hp, tregs);
 
 	/* Put the Big Mac into a sane state. */
-	HMD("happy_meal_init: ");
 	switch(hp->tcvr_type) {
 	case none:
 		/* Cannot operate if we don't know the transceiver type! */
-		HMD("AAIEEE no transceiver type, EAGAIN");
+		HMD("AAIEEE no transceiver type, EAGAIN\n");
 		return -EAGAIN;
 
 	case internal:
 		/* Using the MII buffers. */
-		HMD("internal, using MII, ");
+		HMD("internal, using MII\n");
 		hme_write32(hp, bregs + BMAC_XIFCFG, 0);
 		break;
 
 	case external:
 		/* Not using the MII, disable it. */
-		HMD("external, disable MII, ");
+		HMD("external, disable MII\n");
 		hme_write32(hp, bregs + BMAC_XIFCFG, BIGMAC_XCFG_MIIDISAB);
 		break;
 	}
@@ -1443,18 +1420,16 @@ static int happy_meal_init(struct happy_meal *hp)
 		return -EAGAIN;
 
 	/* Reset the Happy Meal Big Mac transceiver and the receiver. */
-	HMD("tx/rx reset, ");
+	HMD("tx/rx reset\n");
 	happy_meal_tx_reset(hp, bregs);
 	happy_meal_rx_reset(hp, bregs);
 
 	/* Set jam size and inter-packet gaps to reasonable defaults. */
-	HMD("jsize/ipg1/ipg2, ");
 	hme_write32(hp, bregs + BMAC_JSIZE, DEFAULT_JAMSIZE);
 	hme_write32(hp, bregs + BMAC_IGAP1, DEFAULT_IPG1);
 	hme_write32(hp, bregs + BMAC_IGAP2, DEFAULT_IPG2);
 
 	/* Load up the MAC address and random seed. */
-	HMD("rseed/macaddr, ");
 
 	/* The docs recommend to use the 10LSB of our MAC here. */
 	hme_write32(hp, bregs + BMAC_RSEED, ((e[5] | e[4]<<8)&0x3ff));
@@ -1463,7 +1438,6 @@ static int happy_meal_init(struct happy_meal *hp)
 	hme_write32(hp, bregs + BMAC_MACADDR1, ((e[2] << 8) | e[3]));
 	hme_write32(hp, bregs + BMAC_MACADDR0, ((e[0] << 8) | e[1]));
 
-	HMD("htable, ");
 	if ((hp->dev->flags & IFF_ALLMULTI) ||
 	    (netdev_mc_count(hp->dev) > 64)) {
 		hme_write32(hp, bregs + BMAC_HTABLE0, 0xffff);
@@ -1513,9 +1487,6 @@ static int happy_meal_init(struct happy_meal *hp)
 			    | 0x4);
 
 	/* Set the supported burst sizes. */
-	HMD("happy_meal_init: old[%08x] bursts<",
-	    hme_read32(hp, gregs + GREG_CFG));
-
 #ifndef CONFIG_SPARC
 	/* It is always PCI and can handle 64byte bursts. */
 	hme_write32(hp, gregs + GREG_CFG, GREG_CFG_BURST64);
@@ -1543,34 +1514,35 @@ static int happy_meal_init(struct happy_meal *hp)
 		}
 #endif
 
-		HMD("64>");
+		bursts = "64";
 		hme_write32(hp, gregs + GREG_CFG, gcfg);
 	} else if (hp->happy_bursts & DMA_BURST32) {
-		HMD("32>");
+		bursts = "32";
 		hme_write32(hp, gregs + GREG_CFG, GREG_CFG_BURST32);
 	} else if (hp->happy_bursts & DMA_BURST16) {
-		HMD("16>");
+		bursts = "16";
 		hme_write32(hp, gregs + GREG_CFG, GREG_CFG_BURST16);
 	} else {
-		HMD("XXX>");
+		bursts = "XXX";
 		hme_write32(hp, gregs + GREG_CFG, 0);
 	}
 #endif /* CONFIG_SPARC */
 
+	HMD("old[%08x] bursts<%s>\n",
+	    hme_read32(hp, gregs + GREG_CFG), bursts);
+
 	/* Turn off interrupts we do not want to hear. */
-	HMD(", enable global interrupts, ");
 	hme_write32(hp, gregs + GREG_IMASK,
 		    (GREG_IMASK_GOTFRAME | GREG_IMASK_RCNTEXP |
 		     GREG_IMASK_SENTFRAME | GREG_IMASK_TXPERR));
 
 	/* Set the transmit ring buffer size. */
-	HMD("tx rsize=%d oreg[%08x], ", (int)TX_RING_SIZE,
+	HMD("tx rsize=%d oreg[%08x]\n", (int)TX_RING_SIZE,
 	    hme_read32(hp, etxregs + ETX_RSIZE));
 	hme_write32(hp, etxregs + ETX_RSIZE, (TX_RING_SIZE >> ETX_RSIZE_SHIFT) - 1);
 
 	/* Enable transmitter DVMA. */
-	HMD("tx dma enable old[%08x], ",
-	    hme_read32(hp, etxregs + ETX_CFG));
+	HMD("tx dma enable old[%08x]\n", hme_read32(hp, etxregs + ETX_CFG));
 	hme_write32(hp, etxregs + ETX_CFG,
 		    hme_read32(hp, etxregs + ETX_CFG) | ETX_CFG_DMAENABLE);
 
@@ -1594,7 +1566,7 @@ static int happy_meal_init(struct happy_meal *hp)
 	}
 
 	/* Enable Big Mac hash table filter. */
-	HMD("happy_meal_init: enable hash rx_cfg_old[%08x], ",
+	HMD("enable hash rx_cfg_old[%08x]\n",
 	    hme_read32(hp, bregs + BMAC_RXCFG));
 	rxcfg = BIGMAC_RXCFG_HENABLE | BIGMAC_RXCFG_REJME;
 	if (hp->dev->flags & IFF_PROMISC)
@@ -1605,7 +1577,7 @@ static int happy_meal_init(struct happy_meal *hp)
 	udelay(10);
 
 	/* Ok, configure the Big Mac transmitter. */
-	HMD("BIGMAC init, ");
+	HMD("BIGMAC init\n");
 	regtmp = 0;
 	if (hp->happy_flags & HFLAG_FULL)
 		regtmp |= BIGMAC_TXCFG_FULLDPLX;
@@ -1629,8 +1601,7 @@ static int happy_meal_init(struct happy_meal *hp)
 	if (hp->tcvr_type == external)
 		regtmp |= BIGMAC_XCFG_MIIDISAB;
 
-	HMD("XIF config old[%08x], ",
-	    hme_read32(hp, bregs + BMAC_XIFCFG));
+	HMD("XIF config old[%08x]\n", hme_read32(hp, bregs + BMAC_XIFCFG));
 	hme_write32(hp, bregs + BMAC_XIFCFG, regtmp);
 
 	/* Start things up. */
@@ -1769,14 +1740,10 @@ static int happy_meal_is_not_so_happy(struct happy_meal *hp, u32 status)
 
 	if (status & (GREG_STAT_RXERR|GREG_STAT_RXPERR|GREG_STAT_RXTERR)) {
 		/* All sorts of DMA receive errors. */
-		netdev_err(hp->dev, "Happy Meal rx DMA errors [ ");
-		if (status & GREG_STAT_RXERR)
-			printk("GenericError ");
-		if (status & GREG_STAT_RXPERR)
-			printk("ParityError ");
-		if (status & GREG_STAT_RXTERR)
-			printk("RxTagBotch ");
-		printk("]\n");
+		netdev_err(hp->dev, "Happy Meal rx DMA errors [ %s%s%s]\n",
+			   status & GREG_STAT_RXERR ? "GenericError " : "",
+			   status & GREG_STAT_RXPERR ? "ParityError " : "",
+			   status & GREG_STAT_RXTERR ? "RxTagBotch " : "");
 		reset = 1;
 	}
 
@@ -1797,16 +1764,11 @@ static int happy_meal_is_not_so_happy(struct happy_meal *hp, u32 status)
 	if (status &
 	    (GREG_STAT_TXEACK|GREG_STAT_TXLERR|GREG_STAT_TXPERR|GREG_STAT_TXTERR)) {
 		/* All sorts of transmit DMA errors. */
-		netdev_err(hp->dev, "Happy Meal tx DMA errors [ ");
-		if (status & GREG_STAT_TXEACK)
-			printk("GenericError ");
-		if (status & GREG_STAT_TXLERR)
-			printk("LateError ");
-		if (status & GREG_STAT_TXPERR)
-			printk("ParityError ");
-		if (status & GREG_STAT_TXTERR)
-			printk("TagBotch ");
-		printk("]\n");
+		netdev_err(hp->dev, "Happy Meal tx DMA errors [ %s%s%s%s]\n",
+			   status & GREG_STAT_TXEACK ? "GenericError " : "",
+			   status & GREG_STAT_TXLERR ? "LateError " : "",
+			   status & GREG_STAT_TXPERR ? "ParityError " : "",
+			   status & GREG_STAT_TXTERR ? "TagBotch " : "");
 		reset = 1;
 	}
 
@@ -1839,16 +1801,16 @@ static void happy_meal_mif_interrupt(struct happy_meal *hp)
 
 	/* Use the fastest transmission protocol possible. */
 	if (hp->sw_lpa & LPA_100FULL) {
-		netdev_info(hp->dev, "Switching to 100Mbps at full duplex.");
+		netdev_info(hp->dev, "Switching to 100Mbps at full duplex.\n");
 		hp->sw_bmcr |= (BMCR_FULLDPLX | BMCR_SPEED100);
 	} else if (hp->sw_lpa & LPA_100HALF) {
-		netdev_info(hp->dev, "Switching to 100MBps at half duplex.");
+		netdev_info(hp->dev, "Switching to 100MBps at half duplex.\n");
 		hp->sw_bmcr |= BMCR_SPEED100;
 	} else if (hp->sw_lpa & LPA_10FULL) {
-		netdev_info(hp->dev, "Switching to 10MBps at full duplex.");
+		netdev_info(hp->dev, "Switching to 10MBps at full duplex.\n");
 		hp->sw_bmcr |= BMCR_FULLDPLX;
 	} else {
-		netdev_info(hp->dev, "Using 10Mbps at half duplex.");
+		netdev_info(hp->dev, "Using 10Mbps at half duplex.\n");
 	}
 	happy_meal_tcvr_write(hp, tregs, MII_BMCR, hp->sw_bmcr);
 
@@ -1865,13 +1827,12 @@ static void happy_meal_tx(struct happy_meal *hp)
 	int elem;
 
 	elem = hp->tx_old;
-	TXD("TX<");
 	while (elem != hp->tx_new) {
 		struct sk_buff *skb;
 		u32 flags, dma_addr, dma_len;
 		int frag;
 
-		TXD("[%d]", elem);
+		TXD("TX[%d]\n", elem);
 		this = &txbase[elem];
 		flags = hme_read_desc32(hp, &this->tx_flags);
 		if (flags & TXFLAG_OWN)
@@ -1907,7 +1868,6 @@ static void happy_meal_tx(struct happy_meal *hp)
 		dev->stats.tx_packets++;
 	}
 	hp->tx_old = elem;
-	TXD(">");
 
 	if (netif_queue_stopped(dev) &&
 	    TX_BUFFS_AVAIL(hp) > (MAX_SKB_FRAGS + 1))
@@ -1930,7 +1890,6 @@ static void happy_meal_rx(struct happy_meal *hp, struct net_device *dev)
 	int elem = hp->rx_new, drops = 0;
 	u32 flags;
 
-	RXD("RX<");
 	this = &rxbase[elem];
 	while (!((flags = hme_read_desc32(hp, &this->rx_flags)) & RXFLAG_OWN)) {
 		struct sk_buff *skb;
@@ -1938,11 +1897,9 @@ static void happy_meal_rx(struct happy_meal *hp, struct net_device *dev)
 		u16 csum = flags & RXFLAG_CSUM;
 		u32 dma_addr = hme_read_desc32(hp, &this->rx_addr);
 
-		RXD("[%d ", elem);
-
 		/* Check for errors. */
 		if ((len < ETH_ZLEN) || (flags & RXFLAG_OVERFLOW)) {
-			RXD("ERR(%08x)]", flags);
+			RXD("RX[%d ERR(%08x)]", elem, flags);
 			dev->stats.rx_errors++;
 			if (len < ETH_ZLEN)
 				dev->stats.rx_length_errors++;
@@ -2014,7 +1971,7 @@ static void happy_meal_rx(struct happy_meal *hp, struct net_device *dev)
 		skb->csum = csum_unfold(~(__force __sum16)htons(csum));
 		skb->ip_summed = CHECKSUM_COMPLETE;
 
-		RXD("len=%d csum=%4x]", len, csum);
+		RXD("RX[%d len=%d csum=%4x]", elem, len, csum);
 		skb->protocol = eth_type_trans(skb, dev);
 		netif_rx(skb);
 
@@ -2027,7 +1984,6 @@ static void happy_meal_rx(struct happy_meal *hp, struct net_device *dev)
 	hp->rx_new = elem;
 	if (drops)
 		netdev_info(hp->dev, "Memory squeeze, deferring packet.\n");
-	RXD(">");
 }
 
 static irqreturn_t happy_meal_interrupt(int irq, void *dev_id)
@@ -2036,30 +1992,23 @@ static irqreturn_t happy_meal_interrupt(int irq, void *dev_id)
 	struct happy_meal *hp  = netdev_priv(dev);
 	u32 happy_status       = hme_read32(hp, hp->gregs + GREG_STAT);
 
-	HMD("happy_meal_interrupt: status=%08x ", happy_status);
+	HMD("status=%08x\n", happy_status);
 
 	spin_lock(&hp->happy_lock);
 
 	if (happy_status & GREG_STAT_ERRORS) {
-		HMD("ERRORS ");
 		if (happy_meal_is_not_so_happy(hp, /* un- */ happy_status))
 			goto out;
 	}
 
-	if (happy_status & GREG_STAT_MIFIRQ) {
-		HMD("MIFIRQ ");
+	if (happy_status & GREG_STAT_MIFIRQ)
 		happy_meal_mif_interrupt(hp);
-	}
 
-	if (happy_status & GREG_STAT_TXALL) {
-		HMD("TXALL ");
+	if (happy_status & GREG_STAT_TXALL)
 		happy_meal_tx(hp);
-	}
 
-	if (happy_status & GREG_STAT_RXTOHOST) {
-		HMD("RXTOHOST ");
+	if (happy_status & GREG_STAT_RXTOHOST)
 		happy_meal_rx(hp, dev);
-	}
 
 	HMD("done\n");
 out:
@@ -2079,7 +2028,7 @@ static irqreturn_t quattro_sbus_interrupt(int irq, void *cookie)
 		struct happy_meal *hp  = netdev_priv(dev);
 		u32 happy_status       = hme_read32(hp, hp->gregs + GREG_STAT);
 
-		HMD("quattro_interrupt: status=%08x ", happy_status);
+		HMD("status=%08x\n", happy_status);
 
 		if (!(happy_status & (GREG_STAT_ERRORS |
 				      GREG_STAT_MIFIRQ |
@@ -2089,26 +2038,18 @@ static irqreturn_t quattro_sbus_interrupt(int irq, void *cookie)
 
 		spin_lock(&hp->happy_lock);
 
-		if (happy_status & GREG_STAT_ERRORS) {
-			HMD("ERRORS ");
+		if (happy_status & GREG_STAT_ERRORS)
 			if (happy_meal_is_not_so_happy(hp, happy_status))
 				goto next;
-		}
 
-		if (happy_status & GREG_STAT_MIFIRQ) {
-			HMD("MIFIRQ ");
+		if (happy_status & GREG_STAT_MIFIRQ)
 			happy_meal_mif_interrupt(hp);
-		}
 
-		if (happy_status & GREG_STAT_TXALL) {
-			HMD("TXALL ");
+		if (happy_status & GREG_STAT_TXALL)
 			happy_meal_tx(hp);
-		}
 
-		if (happy_status & GREG_STAT_RXTOHOST) {
-			HMD("RXTOHOST ");
+		if (happy_status & GREG_STAT_RXTOHOST)
 			happy_meal_rx(hp, dev);
-		}
 
 	next:
 		spin_unlock(&hp->happy_lock);
@@ -2124,8 +2065,6 @@ static int happy_meal_open(struct net_device *dev)
 	struct happy_meal *hp = netdev_priv(dev);
 	int res;
 
-	HMD("happy_meal_open: ");
-
 	/* On SBUS Quattro QFE cards, all hme interrupts are concentrated
 	 * into a single source which we register handling at probe time.
 	 */
@@ -2238,7 +2177,7 @@ static netdev_tx_t happy_meal_start_xmit(struct sk_buff *skb,
 	}
 
 	entry = hp->tx_new;
-	SXD("SX<l[%d]e[%d]>", len, entry);
+	SXD("SX<l[%d]e[%d]>\n", skb->len, entry);
 	hp->tx_skbs[entry] = skb;
 
 	if (skb_shinfo(skb)->nr_frags == 0) {
@@ -2781,12 +2720,12 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
 	platform_set_drvdata(op, hp);
 
 	if (qfe_slot != -1)
-		netdev_info(dev, "Quattro HME slot %d (SBUS) 10/100baseT Ethernet ",
-			    qfe_slot);
+		netdev_info(dev,
+			    "Quattro HME slot %d (SBUS) 10/100baseT Ethernet %pM\n",
+			    qfe_slot, dev->dev_addr);
 	else
-		netdev_info(dev, "HAPPY MEAL (SBUS) 10/100baseT Ethernet ");
-
-	printk("%pM\n", dev->dev_addr);
+		netdev_info(dev, "HAPPY MEAL (SBUS) 10/100baseT Ethernet %pM\n",
+			    dev->dev_addr);
 
 	return 0;
 
@@ -3112,25 +3051,18 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 			sprintf(prom_name, "-%d", i + 3);
 		}
 		netdev_info(dev,
-			    "%s: Quattro HME (PCI/CheerIO) 10/100baseT Ethernet ",
-			    prom_name);
-		if (qpdev->vendor == PCI_VENDOR_ID_DEC &&
-		    qpdev->device == PCI_DEVICE_ID_DEC_21153)
-			printk("DEC 21153 PCI Bridge\n");
-		else
-			printk("unknown bridge %04x.%04x\n",
-				qpdev->vendor, qpdev->device);
+			    "%s: Quattro HME (PCI/CheerIO) 10/100baseT Ethernet bridge %04x.%04x\n",
+			    prom_name, qpdev->vendor, qpdev->device);
 	}
 
 	if (qfe_slot != -1)
 		netdev_info(dev,
-			    "Quattro HME slot %d (PCI/CheerIO) 10/100baseT Ethernet ",
-			    qfe_slot);
+			    "Quattro HME slot %d (PCI/CheerIO) 10/100baseT Ethernet %pM\n",
+			    qfe_slot, dev->dev_addr);
 	else
 		netdev_info(dev,
-			    "HAPPY MEAL (PCI/CheerIO) 10/100BaseT Ethernet ");
-
-	printk("%pM\n", dev->dev_addr);
+			    "HAPPY MEAL (PCI/CheerIO) 10/100BaseT Ethernet %pM\n",
+			    dev->dev_addr);
 
 	return 0;
 
-- 
2.37.1

