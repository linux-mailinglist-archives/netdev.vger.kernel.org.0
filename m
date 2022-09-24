Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9825E871B
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 03:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233109AbiIXByh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 21:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233015AbiIXByM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 21:54:12 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E32B10D64B;
        Fri, 23 Sep 2022 18:53:53 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id d15so1168793qka.9;
        Fri, 23 Sep 2022 18:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=YwzcTSHue/aTP/bYbUu3/ubH6aMaGvNmLvEjU7mjOAk=;
        b=aNajAbEZmkYzW6vUxA3ESZhgrcD4YBS/N/qZPljmDYhjvNE15vaLigGEj1DxbeHA9c
         D/zhuumVMwRW5Qj36HmNmUXv6RQpsGzknVxkdsEKXH10BeJ80XNryNOo5eaSynVUJwPB
         HIMedsDiTydtdU+P8DrnZuzGxNo7vgyoM7yIZDhNO8ltpQAFYWAZUG+TvvNpQ4SsuBLp
         a727i5OkiQPnrd5gk4VLHDO07EiQajRflFPfztgi5dtQDigNO34Z0rGCzr4C+FVV7mCX
         2rj13+VwxJw5tpWQiL/qj3XuxsmF0vQD8D850iCmVHCiMkUJoHhPrFIO0TCtsUCat+QF
         XVpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=YwzcTSHue/aTP/bYbUu3/ubH6aMaGvNmLvEjU7mjOAk=;
        b=JAs/Twxksob3g4A+D9BmqlXAq4we3AKAHVan0qXGQWbz3+p81ak7ttafqbr5nnNr9s
         STdT9PEMLV6axR2aUfkeVdjKq3q+bWcRtbCDDBr83qBlozdOBngs2Hfz0x3poZuoz8kt
         XGLEI/Gv6YoIm6+as1bBBqnEHUXNoD4iYqSEFVLim+1q1g/6LdWhuKKYHROSUKzetNwg
         1h39GAqTq7gESrCPyuZ0ogigxXZrHop495tkPgpi/LEZO96D5q010no/YVXYJkQlhLcn
         nacJmYNQiqBJITWyhfyZOgtpCfmUX6Jvhxo2fFiHYy4bqgLcMpQ+y7Z3DSCLNMVQK9fa
         WiYw==
X-Gm-Message-State: ACrzQf3PMEcguSSuZOgsK/Qwn6qiuuV2ATjf6s4HVSSCuKBls7GoIErl
        vn+A84LywkiVELGlrnM49Do=
X-Google-Smtp-Source: AMsMyM4J6rQvGwQa8ZFg7VFGI6NLFE5P5yDTKHbeY3pI66PtsGAi842E6FcNSdXI/KTuFP8DGxX3Vg==
X-Received: by 2002:a05:620a:290c:b0:6ce:6686:109e with SMTP id m12-20020a05620a290c00b006ce6686109emr7465135qkp.741.1663984431984;
        Fri, 23 Sep 2022 18:53:51 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id 22-20020a05620a06d600b006cc190f627bsm6704827qky.63.2022.09.23.18.53.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 18:53:51 -0700 (PDT)
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
Subject: [PATCH net-next v2 07/13] sunhme: Convert FOO((...)) to FOO(...)
Date:   Fri, 23 Sep 2022 21:53:33 -0400
Message-Id: <20220924015339.1816744-8-seanga2@gmail.com>
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

With the power of variadic macros, double parentheses are unnecessary.

Signed-off-by: Sean Anderson <seanga2@gmail.com>
---

Changes in v2:
- sumhme -> sunhme

 drivers/net/ethernet/sun/sunhme.c | 272 +++++++++++++++---------------
 1 file changed, 136 insertions(+), 136 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 7d6825c573a2..77a2a192f2ce 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -134,17 +134,17 @@ static __inline__ void tx_dump_log(void)
 #endif
 
 #ifdef HMEDEBUG
-#define HMD(x)  printk x
+#define HMD printk
 #else
-#define HMD(x)
+#define HMD(...)
 #endif
 
 /* #define AUTO_SWITCH_DEBUG */
 
 #ifdef AUTO_SWITCH_DEBUG
-#define ASD(x)  printk x
+#define ASD printk
 #else
-#define ASD(x)
+#define ASD(...)
 #endif
 
 #define DEFAULT_IPG0      16 /* For lance-mode only */
@@ -320,7 +320,7 @@ static int happy_meal_bb_read(struct happy_meal *hp,
 	int retval = 0;
 	int i;
 
-	ASD(("happy_meal_bb_read: reg=%d ", reg));
+	ASD("happy_meal_bb_read: reg=%d ", reg);
 
 	/* Enable the MIF BitBang outputs. */
 	hme_write32(hp, tregs + TCVR_BBOENAB, 1);
@@ -355,7 +355,7 @@ static int happy_meal_bb_read(struct happy_meal *hp,
 	(void) BB_GET_BIT2(hp, tregs, (hp->tcvr_type == internal));
 	(void) BB_GET_BIT2(hp, tregs, (hp->tcvr_type == internal));
 	(void) BB_GET_BIT2(hp, tregs, (hp->tcvr_type == internal));
-	ASD(("value=%x\n", retval));
+	ASD("value=%x\n", retval);
 	return retval;
 }
 
@@ -366,7 +366,7 @@ static void happy_meal_bb_write(struct happy_meal *hp,
 	u32 tmp;
 	int i;
 
-	ASD(("happy_meal_bb_write: reg=%d value=%x\n", reg, value));
+	ASD("happy_meal_bb_write: reg=%d value=%x\n", reg, value);
 
 	/* Enable the MIF BitBang outputs. */
 	hme_write32(hp, tregs + TCVR_BBOENAB, 1);
@@ -410,14 +410,14 @@ static int happy_meal_tcvr_read(struct happy_meal *hp,
 	int tries = TCVR_READ_TRIES;
 	int retval;
 
-	ASD(("happy_meal_tcvr_read: reg=0x%02x ", reg));
+	ASD("happy_meal_tcvr_read: reg=0x%02x ", reg);
 	if (hp->tcvr_type == none) {
-		ASD(("no transceiver, value=TCVR_FAILURE\n"));
+		ASD("no transceiver, value=TCVR_FAILURE\n");
 		return TCVR_FAILURE;
 	}
 
 	if (!(hp->happy_flags & HFLAG_FENABLE)) {
-		ASD(("doing bit bang\n"));
+		ASD("doing bit bang\n");
 		return happy_meal_bb_read(hp, tregs, reg);
 	}
 
@@ -430,7 +430,7 @@ static int happy_meal_tcvr_read(struct happy_meal *hp,
 		return TCVR_FAILURE;
 	}
 	retval = hme_read32(hp, tregs + TCVR_FRAME) & 0xffff;
-	ASD(("value=%04x\n", retval));
+	ASD("value=%04x\n", retval);
 	return retval;
 }
 
@@ -442,7 +442,7 @@ static void happy_meal_tcvr_write(struct happy_meal *hp,
 {
 	int tries = TCVR_WRITE_TRIES;
 
-	ASD(("happy_meal_tcvr_write: reg=0x%02x value=%04x\n", reg, value));
+	ASD("happy_meal_tcvr_write: reg=0x%02x value=%04x\n", reg, value);
 
 	/* Welcome to Sun Microsystems, can I take your order please? */
 	if (!(hp->happy_flags & HFLAG_FENABLE)) {
@@ -807,7 +807,7 @@ static void happy_meal_tx_reset(struct happy_meal *hp, void __iomem *bregs)
 {
 	int tries = TX_RESET_TRIES;
 
-	HMD(("happy_meal_tx_reset: reset, "));
+	HMD("happy_meal_tx_reset: reset, ");
 
 	/* Would you like to try our SMCC Delux? */
 	hme_write32(hp, bregs + BMAC_TXSWRESET, 0);
@@ -819,7 +819,7 @@ static void happy_meal_tx_reset(struct happy_meal *hp, void __iomem *bregs)
 		printk(KERN_ERR "happy meal: Transceiver BigMac ATTACK!");
 
 	/* Take care. */
-	HMD(("done\n"));
+	HMD("done\n");
 }
 
 /* hp->happy_lock must be held */
@@ -827,7 +827,7 @@ static void happy_meal_rx_reset(struct happy_meal *hp, void __iomem *bregs)
 {
 	int tries = RX_RESET_TRIES;
 
-	HMD(("happy_meal_rx_reset: reset, "));
+	HMD("happy_meal_rx_reset: reset, ");
 
 	/* We have a special on GNU/Viking hardware bugs today. */
 	hme_write32(hp, bregs + BMAC_RXSWRESET, 0);
@@ -839,7 +839,7 @@ static void happy_meal_rx_reset(struct happy_meal *hp, void __iomem *bregs)
 		printk(KERN_ERR "happy meal: Receiver BigMac ATTACK!");
 
 	/* Don't forget your vik_1137125_wa.  Have a nice day. */
-	HMD(("done\n"));
+	HMD("done\n");
 }
 
 #define STOP_TRIES         16
@@ -849,7 +849,7 @@ static void happy_meal_stop(struct happy_meal *hp, void __iomem *gregs)
 {
 	int tries = STOP_TRIES;
 
-	HMD(("happy_meal_stop: reset, "));
+	HMD("happy_meal_stop: reset, ");
 
 	/* We're consolidating our STB products, it's your lucky day. */
 	hme_write32(hp, gregs + GREG_SWRESET, GREG_RESET_ALL);
@@ -861,7 +861,7 @@ static void happy_meal_stop(struct happy_meal *hp, void __iomem *gregs)
 		printk(KERN_ERR "happy meal: Fry guys.");
 
 	/* Remember: "Different name, same old buggy as shit hardware." */
-	HMD(("done\n"));
+	HMD("done\n");
 }
 
 /* hp->happy_lock must be held */
@@ -890,21 +890,21 @@ static void happy_meal_get_counters(struct happy_meal *hp, void __iomem *bregs)
 /* hp->happy_lock must be held */
 static void happy_meal_poll_stop(struct happy_meal *hp, void __iomem *tregs)
 {
-	ASD(("happy_meal_poll_stop: "));
+	ASD("happy_meal_poll_stop: ");
 
 	/* If polling disabled or not polling already, nothing to do. */
 	if ((hp->happy_flags & (HFLAG_POLLENABLE | HFLAG_POLL)) !=
 	   (HFLAG_POLLENABLE | HFLAG_POLL)) {
-		HMD(("not polling, return\n"));
+		HMD("not polling, return\n");
 		return;
 	}
 
 	/* Shut up the MIF. */
-	ASD(("were polling, mif ints off, "));
+	ASD("were polling, mif ints off, ");
 	hme_write32(hp, tregs + TCVR_IMASK, 0xffff);
 
 	/* Turn off polling. */
-	ASD(("polling off, "));
+	ASD("polling off, ");
 	hme_write32(hp, tregs + TCVR_CFG,
 		    hme_read32(hp, tregs + TCVR_CFG) & ~(TCV_CFG_PENABLE));
 
@@ -913,7 +913,7 @@ static void happy_meal_poll_stop(struct happy_meal *hp, void __iomem *tregs)
 
 	/* Let the bits set. */
 	udelay(200);
-	ASD(("done\n"));
+	ASD("done\n");
 }
 
 /* Only Sun can take such nice parts and fuck up the programming interface
@@ -929,44 +929,44 @@ static int happy_meal_tcvr_reset(struct happy_meal *hp, void __iomem *tregs)
 	int result, tries = TCVR_RESET_TRIES;
 
 	tconfig = hme_read32(hp, tregs + TCVR_CFG);
-	ASD(("happy_meal_tcvr_reset: tcfg<%08lx> ", tconfig));
+	ASD("happy_meal_tcvr_reset: tcfg<%08lx> ", tconfig);
 	if (hp->tcvr_type == external) {
-		ASD(("external<"));
+		ASD("external<");
 		hme_write32(hp, tregs + TCVR_CFG, tconfig & ~(TCV_CFG_PSELECT));
 		hp->tcvr_type = internal;
 		hp->paddr = TCV_PADDR_ITX;
-		ASD(("ISOLATE,"));
+		ASD("ISOLATE,");
 		happy_meal_tcvr_write(hp, tregs, MII_BMCR,
 				      (BMCR_LOOPBACK|BMCR_PDOWN|BMCR_ISOLATE));
 		result = happy_meal_tcvr_read(hp, tregs, MII_BMCR);
 		if (result == TCVR_FAILURE) {
-			ASD(("phyread_fail>\n"));
+			ASD("phyread_fail>\n");
 			return -1;
 		}
-		ASD(("phyread_ok,PSELECT>"));
+		ASD("phyread_ok,PSELECT>");
 		hme_write32(hp, tregs + TCVR_CFG, tconfig | TCV_CFG_PSELECT);
 		hp->tcvr_type = external;
 		hp->paddr = TCV_PADDR_ETX;
 	} else {
 		if (tconfig & TCV_CFG_MDIO1) {
-			ASD(("internal<PSELECT,"));
+			ASD("internal<PSELECT,");
 			hme_write32(hp, tregs + TCVR_CFG, (tconfig | TCV_CFG_PSELECT));
-			ASD(("ISOLATE,"));
+			ASD("ISOLATE,");
 			happy_meal_tcvr_write(hp, tregs, MII_BMCR,
 					      (BMCR_LOOPBACK|BMCR_PDOWN|BMCR_ISOLATE));
 			result = happy_meal_tcvr_read(hp, tregs, MII_BMCR);
 			if (result == TCVR_FAILURE) {
-				ASD(("phyread_fail>\n"));
+				ASD("phyread_fail>\n");
 				return -1;
 			}
-			ASD(("phyread_ok,~PSELECT>"));
+			ASD("phyread_ok,~PSELECT>");
 			hme_write32(hp, tregs + TCVR_CFG, (tconfig & ~(TCV_CFG_PSELECT)));
 			hp->tcvr_type = internal;
 			hp->paddr = TCV_PADDR_ITX;
 		}
 	}
 
-	ASD(("BMCR_RESET "));
+	ASD("BMCR_RESET ");
 	happy_meal_tcvr_write(hp, tregs, MII_BMCR, BMCR_RESET);
 
 	while (--tries) {
@@ -979,10 +979,10 @@ static int happy_meal_tcvr_reset(struct happy_meal *hp, void __iomem *tregs)
 		udelay(20);
 	}
 	if (!tries) {
-		ASD(("BMCR RESET FAILED!\n"));
+		ASD("BMCR RESET FAILED!\n");
 		return -1;
 	}
-	ASD(("RESET_OK\n"));
+	ASD("RESET_OK\n");
 
 	/* Get fresh copies of the PHY registers. */
 	hp->sw_bmsr      = happy_meal_tcvr_read(hp, tregs, MII_BMSR);
@@ -990,7 +990,7 @@ static int happy_meal_tcvr_reset(struct happy_meal *hp, void __iomem *tregs)
 	hp->sw_physid2   = happy_meal_tcvr_read(hp, tregs, MII_PHYSID2);
 	hp->sw_advertise = happy_meal_tcvr_read(hp, tregs, MII_ADVERTISE);
 
-	ASD(("UNISOLATE"));
+	ASD("UNISOLATE");
 	hp->sw_bmcr &= ~(BMCR_ISOLATE);
 	happy_meal_tcvr_write(hp, tregs, MII_BMCR, hp->sw_bmcr);
 
@@ -1004,10 +1004,10 @@ static int happy_meal_tcvr_reset(struct happy_meal *hp, void __iomem *tregs)
 		udelay(20);
 	}
 	if (!tries) {
-		ASD((" FAILED!\n"));
+		ASD(" FAILED!\n");
 		return -1;
 	}
-	ASD((" SUCCESS and CSCONFIG_DFBYPASS\n"));
+	ASD(" SUCCESS and CSCONFIG_DFBYPASS\n");
 	if (!is_lucent_phy(hp)) {
 		result = happy_meal_tcvr_read(hp, tregs,
 					      DP83840_CSCONFIG);
@@ -1025,60 +1025,60 @@ static void happy_meal_transceiver_check(struct happy_meal *hp, void __iomem *tr
 {
 	unsigned long tconfig = hme_read32(hp, tregs + TCVR_CFG);
 
-	ASD(("happy_meal_transceiver_check: tcfg=%08lx ", tconfig));
+	ASD("happy_meal_transceiver_check: tcfg=%08lx ", tconfig);
 	if (hp->happy_flags & HFLAG_POLL) {
 		/* If we are polling, we must stop to get the transceiver type. */
-		ASD(("<polling> "));
+		ASD("<polling> ");
 		if (hp->tcvr_type == internal) {
 			if (tconfig & TCV_CFG_MDIO1) {
-				ASD(("<internal> <poll stop> "));
+				ASD("<internal> <poll stop> ");
 				happy_meal_poll_stop(hp, tregs);
 				hp->paddr = TCV_PADDR_ETX;
 				hp->tcvr_type = external;
-				ASD(("<external>\n"));
+				ASD("<external>\n");
 				tconfig &= ~(TCV_CFG_PENABLE);
 				tconfig |= TCV_CFG_PSELECT;
 				hme_write32(hp, tregs + TCVR_CFG, tconfig);
 			}
 		} else {
 			if (hp->tcvr_type == external) {
-				ASD(("<external> "));
+				ASD("<external> ");
 				if (!(hme_read32(hp, tregs + TCVR_STATUS) >> 16)) {
-					ASD(("<poll stop> "));
+					ASD("<poll stop> ");
 					happy_meal_poll_stop(hp, tregs);
 					hp->paddr = TCV_PADDR_ITX;
 					hp->tcvr_type = internal;
-					ASD(("<internal>\n"));
+					ASD("<internal>\n");
 					hme_write32(hp, tregs + TCVR_CFG,
 						    hme_read32(hp, tregs + TCVR_CFG) &
 						    ~(TCV_CFG_PSELECT));
 				}
-				ASD(("\n"));
+				ASD("\n");
 			} else {
-				ASD(("<none>\n"));
+				ASD("<none>\n");
 			}
 		}
 	} else {
 		u32 reread = hme_read32(hp, tregs + TCVR_CFG);
 
 		/* Else we can just work off of the MDIO bits. */
-		ASD(("<not polling> "));
+		ASD("<not polling> ");
 		if (reread & TCV_CFG_MDIO1) {
 			hme_write32(hp, tregs + TCVR_CFG, tconfig | TCV_CFG_PSELECT);
 			hp->paddr = TCV_PADDR_ETX;
 			hp->tcvr_type = external;
-			ASD(("<external>\n"));
+			ASD("<external>\n");
 		} else {
 			if (reread & TCV_CFG_MDIO0) {
 				hme_write32(hp, tregs + TCVR_CFG,
 					    tconfig & ~(TCV_CFG_PSELECT));
 				hp->paddr = TCV_PADDR_ITX;
 				hp->tcvr_type = internal;
-				ASD(("<internal>\n"));
+				ASD("<internal>\n");
 			} else {
 				printk(KERN_ERR "happy meal: Transceiver and a coke please.");
 				hp->tcvr_type = none; /* Grrr... */
-				ASD(("<none>\n"));
+				ASD("<none>\n");
 			}
 		}
 	}
@@ -1185,15 +1185,15 @@ static void happy_meal_init_rings(struct happy_meal *hp)
 	struct hmeal_init_block *hb = hp->happy_block;
 	int i;
 
-	HMD(("happy_meal_init_rings: counters to zero, "));
+	HMD("happy_meal_init_rings: counters to zero, ");
 	hp->rx_new = hp->rx_old = hp->tx_new = hp->tx_old = 0;
 
 	/* Free any skippy bufs left around in the rings. */
-	HMD(("clean, "));
+	HMD("clean, ");
 	happy_meal_clean_rings(hp);
 
 	/* Now get new skippy bufs for the receive ring. */
-	HMD(("init rxring, "));
+	HMD("init rxring, ");
 	for (i = 0; i < RX_RING_SIZE; i++) {
 		struct sk_buff *skb;
 		u32 mapping;
@@ -1220,11 +1220,11 @@ static void happy_meal_init_rings(struct happy_meal *hp)
 		skb_reserve(skb, RX_OFFSET);
 	}
 
-	HMD(("init txring, "));
+	HMD("init txring, ");
 	for (i = 0; i < TX_RING_SIZE; i++)
 		hme_write_txd(hp, &hb->happy_meal_txd[i], 0, 0);
 
-	HMD(("done\n"));
+	HMD("done\n");
 }
 
 /* hp->happy_lock must be held */
@@ -1272,15 +1272,15 @@ happy_meal_begin_auto_negotiation(struct happy_meal *hp,
 		 */
 
 #ifdef AUTO_SWITCH_DEBUG
-		ASD(("%s: Advertising [ ", hp->dev->name));
+		ASD("%s: Advertising [ ", hp->dev->name);
 		if (hp->sw_advertise & ADVERTISE_10HALF)
-			ASD(("10H "));
+			ASD("10H ");
 		if (hp->sw_advertise & ADVERTISE_10FULL)
-			ASD(("10F "));
+			ASD("10F ");
 		if (hp->sw_advertise & ADVERTISE_100HALF)
-			ASD(("100H "));
+			ASD("100H ");
 		if (hp->sw_advertise & ADVERTISE_100FULL)
-			ASD(("100F "));
+			ASD("100F ");
 #endif
 
 		/* Enable Auto-Negotiation, this is usually on already... */
@@ -1364,65 +1364,65 @@ static int happy_meal_init(struct happy_meal *hp)
 	/* If auto-negotiation timer is running, kill it. */
 	del_timer(&hp->happy_timer);
 
-	HMD(("happy_meal_init: happy_flags[%08x] ",
-	     hp->happy_flags));
+	HMD("happy_meal_init: happy_flags[%08x] ",
+	    hp->happy_flags);
 	if (!(hp->happy_flags & HFLAG_INIT)) {
-		HMD(("set HFLAG_INIT, "));
+		HMD("set HFLAG_INIT, ");
 		hp->happy_flags |= HFLAG_INIT;
 		happy_meal_get_counters(hp, bregs);
 	}
 
 	/* Stop polling. */
-	HMD(("to happy_meal_poll_stop\n"));
+	HMD("to happy_meal_poll_stop\n");
 	happy_meal_poll_stop(hp, tregs);
 
 	/* Stop transmitter and receiver. */
-	HMD(("happy_meal_init: to happy_meal_stop\n"));
+	HMD("happy_meal_init: to happy_meal_stop\n");
 	happy_meal_stop(hp, gregs);
 
 	/* Alloc and reset the tx/rx descriptor chains. */
-	HMD(("happy_meal_init: to happy_meal_init_rings\n"));
+	HMD("happy_meal_init: to happy_meal_init_rings\n");
 	happy_meal_init_rings(hp);
 
 	/* Shut up the MIF. */
-	HMD(("happy_meal_init: Disable all MIF irqs (old[%08x]), ",
-	     hme_read32(hp, tregs + TCVR_IMASK)));
+	HMD("happy_meal_init: Disable all MIF irqs (old[%08x]), ",
+	    hme_read32(hp, tregs + TCVR_IMASK));
 	hme_write32(hp, tregs + TCVR_IMASK, 0xffff);
 
 	/* See if we can enable the MIF frame on this card to speak to the DP83840. */
 	if (hp->happy_flags & HFLAG_FENABLE) {
-		HMD(("use frame old[%08x], ",
-		     hme_read32(hp, tregs + TCVR_CFG)));
+		HMD("use frame old[%08x], ",
+		    hme_read32(hp, tregs + TCVR_CFG));
 		hme_write32(hp, tregs + TCVR_CFG,
 			    hme_read32(hp, tregs + TCVR_CFG) & ~(TCV_CFG_BENABLE));
 	} else {
-		HMD(("use bitbang old[%08x], ",
-		     hme_read32(hp, tregs + TCVR_CFG)));
+		HMD("use bitbang old[%08x], ",
+		    hme_read32(hp, tregs + TCVR_CFG));
 		hme_write32(hp, tregs + TCVR_CFG,
 			    hme_read32(hp, tregs + TCVR_CFG) | TCV_CFG_BENABLE);
 	}
 
 	/* Check the state of the transceiver. */
-	HMD(("to happy_meal_transceiver_check\n"));
+	HMD("to happy_meal_transceiver_check\n");
 	happy_meal_transceiver_check(hp, tregs);
 
 	/* Put the Big Mac into a sane state. */
-	HMD(("happy_meal_init: "));
+	HMD("happy_meal_init: ");
 	switch(hp->tcvr_type) {
 	case none:
 		/* Cannot operate if we don't know the transceiver type! */
-		HMD(("AAIEEE no transceiver type, EAGAIN"));
+		HMD("AAIEEE no transceiver type, EAGAIN");
 		return -EAGAIN;
 
 	case internal:
 		/* Using the MII buffers. */
-		HMD(("internal, using MII, "));
+		HMD("internal, using MII, ");
 		hme_write32(hp, bregs + BMAC_XIFCFG, 0);
 		break;
 
 	case external:
 		/* Not using the MII, disable it. */
-		HMD(("external, disable MII, "));
+		HMD("external, disable MII, ");
 		hme_write32(hp, bregs + BMAC_XIFCFG, BIGMAC_XCFG_MIIDISAB);
 		break;
 	}
@@ -1431,18 +1431,18 @@ static int happy_meal_init(struct happy_meal *hp)
 		return -EAGAIN;
 
 	/* Reset the Happy Meal Big Mac transceiver and the receiver. */
-	HMD(("tx/rx reset, "));
+	HMD("tx/rx reset, ");
 	happy_meal_tx_reset(hp, bregs);
 	happy_meal_rx_reset(hp, bregs);
 
 	/* Set jam size and inter-packet gaps to reasonable defaults. */
-	HMD(("jsize/ipg1/ipg2, "));
+	HMD("jsize/ipg1/ipg2, ");
 	hme_write32(hp, bregs + BMAC_JSIZE, DEFAULT_JAMSIZE);
 	hme_write32(hp, bregs + BMAC_IGAP1, DEFAULT_IPG1);
 	hme_write32(hp, bregs + BMAC_IGAP2, DEFAULT_IPG2);
 
 	/* Load up the MAC address and random seed. */
-	HMD(("rseed/macaddr, "));
+	HMD("rseed/macaddr, ");
 
 	/* The docs recommend to use the 10LSB of our MAC here. */
 	hme_write32(hp, bregs + BMAC_RSEED, ((e[5] | e[4]<<8)&0x3ff));
@@ -1451,7 +1451,7 @@ static int happy_meal_init(struct happy_meal *hp)
 	hme_write32(hp, bregs + BMAC_MACADDR1, ((e[2] << 8) | e[3]));
 	hme_write32(hp, bregs + BMAC_MACADDR0, ((e[0] << 8) | e[1]));
 
-	HMD(("htable, "));
+	HMD("htable, ");
 	if ((hp->dev->flags & IFF_ALLMULTI) ||
 	    (netdev_mc_count(hp->dev) > 64)) {
 		hme_write32(hp, bregs + BMAC_HTABLE0, 0xffff);
@@ -1481,9 +1481,9 @@ static int happy_meal_init(struct happy_meal *hp)
 	}
 
 	/* Set the RX and TX ring ptrs. */
-	HMD(("ring ptrs rxr[%08x] txr[%08x]\n",
-	     ((__u32)hp->hblock_dvma + hblock_offset(happy_meal_rxd, 0)),
-	     ((__u32)hp->hblock_dvma + hblock_offset(happy_meal_txd, 0))));
+	HMD("ring ptrs rxr[%08x] txr[%08x]\n",
+	    ((__u32)hp->hblock_dvma + hblock_offset(happy_meal_rxd, 0)),
+	    ((__u32)hp->hblock_dvma + hblock_offset(happy_meal_txd, 0)));
 	hme_write32(hp, erxregs + ERX_RING,
 		    ((__u32)hp->hblock_dvma + hblock_offset(happy_meal_rxd, 0)));
 	hme_write32(hp, etxregs + ETX_RING,
@@ -1501,8 +1501,8 @@ static int happy_meal_init(struct happy_meal *hp)
 			    | 0x4);
 
 	/* Set the supported burst sizes. */
-	HMD(("happy_meal_init: old[%08x] bursts<",
-	     hme_read32(hp, gregs + GREG_CFG)));
+	HMD("happy_meal_init: old[%08x] bursts<",
+	    hme_read32(hp, gregs + GREG_CFG));
 
 #ifndef CONFIG_SPARC
 	/* It is always PCI and can handle 64byte bursts. */
@@ -1531,34 +1531,34 @@ static int happy_meal_init(struct happy_meal *hp)
 		}
 #endif
 
-		HMD(("64>"));
+		HMD("64>");
 		hme_write32(hp, gregs + GREG_CFG, gcfg);
 	} else if (hp->happy_bursts & DMA_BURST32) {
-		HMD(("32>"));
+		HMD("32>");
 		hme_write32(hp, gregs + GREG_CFG, GREG_CFG_BURST32);
 	} else if (hp->happy_bursts & DMA_BURST16) {
-		HMD(("16>"));
+		HMD("16>");
 		hme_write32(hp, gregs + GREG_CFG, GREG_CFG_BURST16);
 	} else {
-		HMD(("XXX>"));
+		HMD("XXX>");
 		hme_write32(hp, gregs + GREG_CFG, 0);
 	}
 #endif /* CONFIG_SPARC */
 
 	/* Turn off interrupts we do not want to hear. */
-	HMD((", enable global interrupts, "));
+	HMD(", enable global interrupts, ");
 	hme_write32(hp, gregs + GREG_IMASK,
 		    (GREG_IMASK_GOTFRAME | GREG_IMASK_RCNTEXP |
 		     GREG_IMASK_SENTFRAME | GREG_IMASK_TXPERR));
 
 	/* Set the transmit ring buffer size. */
-	HMD(("tx rsize=%d oreg[%08x], ", (int)TX_RING_SIZE,
-	     hme_read32(hp, etxregs + ETX_RSIZE)));
+	HMD("tx rsize=%d oreg[%08x], ", (int)TX_RING_SIZE,
+	    hme_read32(hp, etxregs + ETX_RSIZE));
 	hme_write32(hp, etxregs + ETX_RSIZE, (TX_RING_SIZE >> ETX_RSIZE_SHIFT) - 1);
 
 	/* Enable transmitter DVMA. */
-	HMD(("tx dma enable old[%08x], ",
-	     hme_read32(hp, etxregs + ETX_CFG)));
+	HMD("tx dma enable old[%08x], ",
+	    hme_read32(hp, etxregs + ETX_CFG));
 	hme_write32(hp, etxregs + ETX_CFG,
 		    hme_read32(hp, etxregs + ETX_CFG) | ETX_CFG_DMAENABLE);
 
@@ -1567,8 +1567,8 @@ static int happy_meal_init(struct happy_meal *hp)
 	 * properly.  I cannot think of a sane way to provide complete
 	 * coverage for this hardware bug yet.
 	 */
-	HMD(("erx regs bug old[%08x]\n",
-	     hme_read32(hp, erxregs + ERX_CFG)));
+	HMD("erx regs bug old[%08x]\n",
+	    hme_read32(hp, erxregs + ERX_CFG));
 	hme_write32(hp, erxregs + ERX_CFG, ERX_CFG_DEFAULT(RX_OFFSET));
 	regtmp = hme_read32(hp, erxregs + ERX_CFG);
 	hme_write32(hp, erxregs + ERX_CFG, ERX_CFG_DEFAULT(RX_OFFSET));
@@ -1580,8 +1580,8 @@ static int happy_meal_init(struct happy_meal *hp)
 	}
 
 	/* Enable Big Mac hash table filter. */
-	HMD(("happy_meal_init: enable hash rx_cfg_old[%08x], ",
-	     hme_read32(hp, bregs + BMAC_RXCFG)));
+	HMD("happy_meal_init: enable hash rx_cfg_old[%08x], ",
+	    hme_read32(hp, bregs + BMAC_RXCFG));
 	rxcfg = BIGMAC_RXCFG_HENABLE | BIGMAC_RXCFG_REJME;
 	if (hp->dev->flags & IFF_PROMISC)
 		rxcfg |= BIGMAC_RXCFG_PMISC;
@@ -1591,7 +1591,7 @@ static int happy_meal_init(struct happy_meal *hp)
 	udelay(10);
 
 	/* Ok, configure the Big Mac transmitter. */
-	HMD(("BIGMAC init, "));
+	HMD("BIGMAC init, ");
 	regtmp = 0;
 	if (hp->happy_flags & HFLAG_FULL)
 		regtmp |= BIGMAC_TXCFG_FULLDPLX;
@@ -1615,14 +1615,14 @@ static int happy_meal_init(struct happy_meal *hp)
 	if (hp->tcvr_type == external)
 		regtmp |= BIGMAC_XCFG_MIIDISAB;
 
-	HMD(("XIF config old[%08x], ",
-	     hme_read32(hp, bregs + BMAC_XIFCFG)));
+	HMD("XIF config old[%08x], ",
+	    hme_read32(hp, bregs + BMAC_XIFCFG));
 	hme_write32(hp, bregs + BMAC_XIFCFG, regtmp);
 
 	/* Start things up. */
-	HMD(("tx old[%08x] and rx [%08x] ON!\n",
-	     hme_read32(hp, bregs + BMAC_TXCFG),
-	     hme_read32(hp, bregs + BMAC_RXCFG)));
+	HMD("tx old[%08x] and rx [%08x] ON!\n",
+	    hme_read32(hp, bregs + BMAC_TXCFG),
+	    hme_read32(hp, bregs + BMAC_RXCFG));
 
 	/* Set larger TX/RX size to allow for 802.1q */
 	hme_write32(hp, bregs + BMAC_TXMAX, ETH_FRAME_LEN + 8);
@@ -1843,9 +1843,9 @@ static void happy_meal_mif_interrupt(struct happy_meal *hp)
 }
 
 #ifdef TXDEBUG
-#define TXD(x) printk x
+#define TXD printk
 #else
-#define TXD(x)
+#define TXD(...)
 #endif
 
 /* hp->happy_lock must be held */
@@ -1857,13 +1857,13 @@ static void happy_meal_tx(struct happy_meal *hp)
 	int elem;
 
 	elem = hp->tx_old;
-	TXD(("TX<"));
+	TXD("TX<");
 	while (elem != hp->tx_new) {
 		struct sk_buff *skb;
 		u32 flags, dma_addr, dma_len;
 		int frag;
 
-		TXD(("[%d]", elem));
+		TXD("[%d]", elem);
 		this = &txbase[elem];
 		flags = hme_read_desc32(hp, &this->tx_flags);
 		if (flags & TXFLAG_OWN)
@@ -1899,7 +1899,7 @@ static void happy_meal_tx(struct happy_meal *hp)
 		dev->stats.tx_packets++;
 	}
 	hp->tx_old = elem;
-	TXD((">"));
+	TXD(">");
 
 	if (netif_queue_stopped(dev) &&
 	    TX_BUFFS_AVAIL(hp) > (MAX_SKB_FRAGS + 1))
@@ -1907,9 +1907,9 @@ static void happy_meal_tx(struct happy_meal *hp)
 }
 
 #ifdef RXDEBUG
-#define RXD(x) printk x
+#define RXD printk
 #else
-#define RXD(x)
+#define RXD(...)
 #endif
 
 /* Originally I used to handle the allocation failure by just giving back just
@@ -1928,7 +1928,7 @@ static void happy_meal_rx(struct happy_meal *hp, struct net_device *dev)
 	int elem = hp->rx_new, drops = 0;
 	u32 flags;
 
-	RXD(("RX<"));
+	RXD("RX<");
 	this = &rxbase[elem];
 	while (!((flags = hme_read_desc32(hp, &this->rx_flags)) & RXFLAG_OWN)) {
 		struct sk_buff *skb;
@@ -1936,11 +1936,11 @@ static void happy_meal_rx(struct happy_meal *hp, struct net_device *dev)
 		u16 csum = flags & RXFLAG_CSUM;
 		u32 dma_addr = hme_read_desc32(hp, &this->rx_addr);
 
-		RXD(("[%d ", elem));
+		RXD("[%d ", elem);
 
 		/* Check for errors. */
 		if ((len < ETH_ZLEN) || (flags & RXFLAG_OVERFLOW)) {
-			RXD(("ERR(%08x)]", flags));
+			RXD("ERR(%08x)]", flags);
 			dev->stats.rx_errors++;
 			if (len < ETH_ZLEN)
 				dev->stats.rx_length_errors++;
@@ -2012,7 +2012,7 @@ static void happy_meal_rx(struct happy_meal *hp, struct net_device *dev)
 		skb->csum = csum_unfold(~(__force __sum16)htons(csum));
 		skb->ip_summed = CHECKSUM_COMPLETE;
 
-		RXD(("len=%d csum=%4x]", len, csum));
+		RXD("len=%d csum=%4x]", len, csum);
 		skb->protocol = eth_type_trans(skb, dev);
 		netif_rx(skb);
 
@@ -2025,7 +2025,7 @@ static void happy_meal_rx(struct happy_meal *hp, struct net_device *dev)
 	hp->rx_new = elem;
 	if (drops)
 		printk(KERN_INFO "%s: Memory squeeze, deferring packet.\n", hp->dev->name);
-	RXD((">"));
+	RXD(">");
 }
 
 static irqreturn_t happy_meal_interrupt(int irq, void *dev_id)
@@ -2034,32 +2034,32 @@ static irqreturn_t happy_meal_interrupt(int irq, void *dev_id)
 	struct happy_meal *hp  = netdev_priv(dev);
 	u32 happy_status       = hme_read32(hp, hp->gregs + GREG_STAT);
 
-	HMD(("happy_meal_interrupt: status=%08x ", happy_status));
+	HMD("happy_meal_interrupt: status=%08x ", happy_status);
 
 	spin_lock(&hp->happy_lock);
 
 	if (happy_status & GREG_STAT_ERRORS) {
-		HMD(("ERRORS "));
+		HMD("ERRORS ");
 		if (happy_meal_is_not_so_happy(hp, /* un- */ happy_status))
 			goto out;
 	}
 
 	if (happy_status & GREG_STAT_MIFIRQ) {
-		HMD(("MIFIRQ "));
+		HMD("MIFIRQ ");
 		happy_meal_mif_interrupt(hp);
 	}
 
 	if (happy_status & GREG_STAT_TXALL) {
-		HMD(("TXALL "));
+		HMD("TXALL ");
 		happy_meal_tx(hp);
 	}
 
 	if (happy_status & GREG_STAT_RXTOHOST) {
-		HMD(("RXTOHOST "));
+		HMD("RXTOHOST ");
 		happy_meal_rx(hp, dev);
 	}
 
-	HMD(("done\n"));
+	HMD("done\n");
 out:
 	spin_unlock(&hp->happy_lock);
 
@@ -2077,7 +2077,7 @@ static irqreturn_t quattro_sbus_interrupt(int irq, void *cookie)
 		struct happy_meal *hp  = netdev_priv(dev);
 		u32 happy_status       = hme_read32(hp, hp->gregs + GREG_STAT);
 
-		HMD(("quattro_interrupt: status=%08x ", happy_status));
+		HMD("quattro_interrupt: status=%08x ", happy_status);
 
 		if (!(happy_status & (GREG_STAT_ERRORS |
 				      GREG_STAT_MIFIRQ |
@@ -2088,30 +2088,30 @@ static irqreturn_t quattro_sbus_interrupt(int irq, void *cookie)
 		spin_lock(&hp->happy_lock);
 
 		if (happy_status & GREG_STAT_ERRORS) {
-			HMD(("ERRORS "));
+			HMD("ERRORS ");
 			if (happy_meal_is_not_so_happy(hp, happy_status))
 				goto next;
 		}
 
 		if (happy_status & GREG_STAT_MIFIRQ) {
-			HMD(("MIFIRQ "));
+			HMD("MIFIRQ ");
 			happy_meal_mif_interrupt(hp);
 		}
 
 		if (happy_status & GREG_STAT_TXALL) {
-			HMD(("TXALL "));
+			HMD("TXALL ");
 			happy_meal_tx(hp);
 		}
 
 		if (happy_status & GREG_STAT_RXTOHOST) {
-			HMD(("RXTOHOST "));
+			HMD("RXTOHOST ");
 			happy_meal_rx(hp, dev);
 		}
 
 	next:
 		spin_unlock(&hp->happy_lock);
 	}
-	HMD(("done\n"));
+	HMD("done\n");
 
 	return IRQ_HANDLED;
 }
@@ -2122,7 +2122,7 @@ static int happy_meal_open(struct net_device *dev)
 	struct happy_meal *hp = netdev_priv(dev);
 	int res;
 
-	HMD(("happy_meal_open: "));
+	HMD("happy_meal_open: ");
 
 	/* On SBUS Quattro QFE cards, all hme interrupts are concentrated
 	 * into a single source which we register handling at probe time.
@@ -2131,7 +2131,7 @@ static int happy_meal_open(struct net_device *dev)
 		res = request_irq(hp->irq, happy_meal_interrupt, IRQF_SHARED,
 				  dev->name, dev);
 		if (res) {
-			HMD(("EAGAIN\n"));
+			HMD("EAGAIN\n");
 			printk(KERN_ERR "happy_meal(SBUS): Can't order irq %d to go.\n",
 			       hp->irq);
 
@@ -2139,7 +2139,7 @@ static int happy_meal_open(struct net_device *dev)
 		}
 	}
 
-	HMD(("to happy_meal_init\n"));
+	HMD("to happy_meal_init\n");
 
 	spin_lock_irq(&hp->happy_lock);
 	res = happy_meal_init(hp);
@@ -2174,9 +2174,9 @@ static int happy_meal_close(struct net_device *dev)
 }
 
 #ifdef SXDEBUG
-#define SXD(x) printk x
+#define SXD printk
 #else
-#define SXD(x)
+#define SXD(...)
 #endif
 
 static void happy_meal_tx_timeout(struct net_device *dev, unsigned int txqueue)
@@ -2244,7 +2244,7 @@ static netdev_tx_t happy_meal_start_xmit(struct sk_buff *skb,
 	}
 
 	entry = hp->tx_new;
-	SXD(("SX<l[%d]e[%d]>", len, entry));
+	SXD("SX<l[%d]e[%d]>", len, entry);
 	hp->tx_skbs[entry] = skb;
 
 	if (skb_shinfo(skb)->nr_frags == 0) {
-- 
2.37.1

