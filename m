Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A99E35BC097
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 01:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbiIRX1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 19:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiIRX0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 19:26:52 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5711759E;
        Sun, 18 Sep 2022 16:26:43 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id g12so19251352qts.1;
        Sun, 18 Sep 2022 16:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=OXuwlaky2lqf8vOyWKQ2yiVvpJDM1++vRMr7F9fK1mE=;
        b=PNR+4yOa1XaXCP2yM8/Cw8BDJ8peWQCn3eujA++CKsylDN+zZB6c599SqdIwU5J9UW
         tWmRY294sMcvlb2VAFxUHKYRD171/tKBCQHxmQuHHV+PLTJcftjnbK3yvkcHr/A0CcMG
         thM/6fqm/9NDRNHmuB5EhtmBlCMMUFPCI8Ptc6VyZV5zwSfzehX9egVjV55NOzR26iaz
         N0vS0KWxDRpFHr2Dyx+/7sj/41MlEuLLks5JjsOBhTxPc7MK4s9QlIzVdAdn4B84UEHq
         4bqJ7UGhWq+vZH2cUAFXHVTGaAEb14c3bJY1UIA9qNTzueRudVhmmjUCSxCLc7aIe5GK
         Pyew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=OXuwlaky2lqf8vOyWKQ2yiVvpJDM1++vRMr7F9fK1mE=;
        b=aYsJEq1OM4a1wCNL1BhkpEsi9QVbM6ULmFOhoPiELSlOJoDBscH5zjkVDSakwOoo4s
         pplA6u1/q+i8jPGERrwXOCQKpRGOgUZ92g8yNMhSr0iNThpLbIkf/sLJ587SZIZpeKUy
         9P7lvPH/Z1KRb6dJaOaxnkvdpP4hBzTNNu5LDgKb7b+omy93nHr0E6v4gg/iABSUa4mo
         mG7vrfX+UjDzi4DJZxz7vjAaIATeu63vhK4MR3TDhZQgiCcQr2Ms2g58elsYTJKsqJ6l
         r3TIKUqMLnSDxB9j7wF/RBPAtG4OL0+Pbhks7Yud2qHv28Byz54dgYOE1+pmqrZHGKVb
         zoaA==
X-Gm-Message-State: ACrzQf2zQYu7sIBzWce73k/t2ISW78WwVOlItRZRreUBYpsKgDpQRF+v
        lUiYiFyItuFptQd0vYydogo=
X-Google-Smtp-Source: AMsMyM7Rq31WfxMvROrKXPSCZCN/ktn/TSmUe/KCNQwRvL5mFn1sfjITUDwZOlXB541+uPQzJNMsmA==
X-Received: by 2002:ac8:5e0e:0:b0:35c:ceec:2526 with SMTP id h14-20020ac85e0e000000b0035cceec2526mr11224325qtx.496.1663543601726;
        Sun, 18 Sep 2022 16:26:41 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id n7-20020a372707000000b006b5bf5d45casm10844739qkn.27.2022.09.18.16.26.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Sep 2022 16:26:41 -0700 (PDT)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org (open list),
        Zheyu Ma <zheyuma97@gmail.com>,
        Nick Bowler <nbowler@draconx.ca>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Sean Anderson <seanga2@gmail.com>
Subject: [PATCH net-next 10/13] sunhme: Use (net)dev_foo wherever possible
Date:   Sun, 18 Sep 2022 19:26:23 -0400
Message-Id: <20220918232626.1601885-11-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220918232626.1601885-1-seanga2@gmail.com>
References: <20220918232626.1601885-1-seanga2@gmail.com>
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

Wherever possible, use the associated netdev (or device) when printing
errors or other messages. This makes it immediately clear what device
caused the error, and provides more information than just the device name.

Signed-off-by: Sean Anderson <seanga2@gmail.com>
---

 drivers/net/ethernet/sun/sunhme.c | 174 +++++++++++++++---------------
 1 file changed, 85 insertions(+), 89 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index fab0c73e27ed..98c38e213bab 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -436,7 +436,7 @@ static int happy_meal_tcvr_read(struct happy_meal *hp,
 	while (!(hme_read32(hp, tregs + TCVR_FRAME) & 0x10000) && --tries)
 		udelay(20);
 	if (!tries) {
-		pr_err("happy meal: Aieee, transceiver MIF read bolixed\n");
+		netdev_err(hp->dev, "Aieee, transceiver MIF read bolixed\n");
 		return TCVR_FAILURE;
 	}
 	retval = hme_read32(hp, tregs + TCVR_FRAME) & 0xffff;
@@ -469,7 +469,7 @@ static void happy_meal_tcvr_write(struct happy_meal *hp,
 
 	/* Anything else? */
 	if (!tries)
-		pr_err("happy meal: Aieee, transceiver MIF write bolixed\n");
+		netdev_err(hp->dev, "Aieee, transceiver MIF write bolixed\n");
 
 	/* Fifty-two cents is your change, have a nice day. */
 }
@@ -647,8 +647,8 @@ static void happy_meal_timer(struct timer_list *t)
 			/* Enter force mode. */
 	do_force_mode:
 			hp->sw_bmcr = happy_meal_tcvr_read(hp, tregs, MII_BMCR);
-			pr_notice("%s: Auto-Negotiation unsuccessful, trying force link mode\n",
-				  hp->dev->name);
+			netdev_notice(hp->dev,
+				      "Auto-Negotiation unsuccessful, trying force link mode\n");
 			hp->sw_bmcr = BMCR_SPEED100;
 			happy_meal_tcvr_write(hp, tregs, MII_BMCR, hp->sw_bmcr);
 
@@ -707,8 +707,8 @@ static void happy_meal_timer(struct timer_list *t)
 			restart_timer = 0;
 		} else {
 			if (hp->timer_ticks >= 10) {
-				pr_notice("%s: Auto negotiation successful, link still not completely up.\n",
-					  hp->dev->name);
+				netdev_notice(hp->dev,
+					      "Auto negotiation successful, link still not completely up.\n");
 				hp->timer_ticks = 0;
 				restart_timer = 1;
 			} else {
@@ -763,14 +763,14 @@ static void happy_meal_timer(struct timer_list *t)
 					 */
 
 					/* Let the user know... */
-					pr_notice("%s: Link down, cable problem?\n",
-						  hp->dev->name);
+					netdev_notice(hp->dev,
+						      "Link down, cable problem?\n");
 
 					ret = happy_meal_init(hp);
 					if (ret) {
 						/* ho hum... */
-						pr_err("%s: Error, cannot re-init the Happy Meal.\n",
-						       hp->dev->name);
+						netdev_err(hp->dev,
+							   "Error, cannot re-init the Happy Meal.\n");
 					}
 					goto out;
 				}
@@ -792,8 +792,8 @@ static void happy_meal_timer(struct timer_list *t)
 	case asleep:
 	default:
 		/* Can't happens.... */
-		pr_err("%s: Aieee, link timer is asleep but we got one anyways!\n",
-		       hp->dev->name);
+		netdev_err(hp->dev,
+			   "Aieee, link timer is asleep but we got one anyways!\n");
 		restart_timer = 0;
 		hp->timer_ticks = 0;
 		hp->timer_state = asleep; /* foo on you */
@@ -826,7 +826,7 @@ static void happy_meal_tx_reset(struct happy_meal *hp, void __iomem *bregs)
 
 	/* Lettuce, tomato, buggy hardware (no extra charge)? */
 	if (!tries)
-		pr_err("happy meal: Transceiver BigMac ATTACK!");
+		netdev_err(hp->dev, "Transceiver BigMac ATTACK!");
 
 	/* Take care. */
 	HMD("done\n");
@@ -846,7 +846,7 @@ static void happy_meal_rx_reset(struct happy_meal *hp, void __iomem *bregs)
 
 	/* Will that be all? */
 	if (!tries)
-		pr_err("happy meal: Receiver BigMac ATTACK!");
+		netdev_err(hp->dev, "Receiver BigMac ATTACK!");
 
 	/* Don't forget your vik_1137125_wa.  Have a nice day. */
 	HMD("done\n");
@@ -868,7 +868,7 @@ static void happy_meal_stop(struct happy_meal *hp, void __iomem *gregs)
 
 	/* Come back next week when we are "Sun Microelectronics". */
 	if (!tries)
-		pr_err("happy meal: Fry guys.");
+		netdev_err(hp->dev, "Fry guys.");
 
 	/* Remember: "Different name, same old buggy as shit hardware." */
 	HMD("done\n");
@@ -1086,7 +1086,8 @@ static void happy_meal_transceiver_check(struct happy_meal *hp, void __iomem *tr
 				hp->tcvr_type = internal;
 				ASD("<internal>\n");
 			} else {
-				pr_err("happy meal: Transceiver and a coke please.");
+				netdev_err(hp->dev,
+					   "Transceiver and a coke please.");
 				hp->tcvr_type = none; /* Grrr... */
 				ASD("<none>\n");
 			}
@@ -1282,7 +1283,7 @@ happy_meal_begin_auto_negotiation(struct happy_meal *hp,
 		 */
 
 #ifdef AUTO_SWITCH_DEBUG
-		ASD("%s: Advertising [ ", hp->dev->name);
+		ASD("%s: Advertising [ ");
 		if (hp->sw_advertise & ADVERTISE_10HALF)
 			ASD("10H ");
 		if (hp->sw_advertise & ADVERTISE_10FULL)
@@ -1311,10 +1312,11 @@ happy_meal_begin_auto_negotiation(struct happy_meal *hp,
 			udelay(10);
 		}
 		if (!timeout) {
-			pr_err("%s: Happy Meal would not start auto negotiation BMCR=0x%04x\n",
-			       hp->dev->name, hp->sw_bmcr);
-			pr_notice("%s: Performing force link detection.\n",
-				  hp->dev->name);
+			netdev_err(hp->dev,
+				   "Happy Meal would not start auto negotiation BMCR=0x%04x\n",
+				   hp->sw_bmcr);
+			netdev_notice(hp->dev,
+				      "Performing force link detection.\n");
 			goto force_link;
 		} else {
 			hp->timer_state = arbwait;
@@ -1583,9 +1585,11 @@ static int happy_meal_init(struct happy_meal *hp)
 	regtmp = hme_read32(hp, erxregs + ERX_CFG);
 	hme_write32(hp, erxregs + ERX_CFG, ERX_CFG_DEFAULT(RX_OFFSET));
 	if (hme_read32(hp, erxregs + ERX_CFG) != ERX_CFG_DEFAULT(RX_OFFSET)) {
-		pr_err("happy meal: Eieee, rx config register gets greasy fries.\n");
-		pr_err("happy meal: Trying to set %08x, reread gives %08x\n",
-		       ERX_CFG_DEFAULT(RX_OFFSET), regtmp);
+		netdev_err(hp->dev,
+			   "Eieee, rx config register gets greasy fries.\n");
+		netdev_err(hp->dev,
+			   "Trying to set %08x, reread gives %08x\n",
+			   ERX_CFG_DEFAULT(RX_OFFSET), regtmp);
 		/* XXX Should return failure here... */
 	}
 
@@ -1722,27 +1726,26 @@ static int happy_meal_is_not_so_happy(struct happy_meal *hp, u32 status)
 		      GREG_STAT_MIFIRQ | GREG_STAT_TXEACK | GREG_STAT_TXLERR |
 		      GREG_STAT_TXPERR | GREG_STAT_TXTERR | GREG_STAT_SLVERR |
 		      GREG_STAT_SLVPERR))
-		pr_err("%s: Error interrupt for happy meal, status = %08x\n",
-		       hp->dev->name, status);
+		netdev_err(hp->dev,
+			   "Error interrupt for happy meal, status = %08x\n",
+			   status);
 
 	if (status & GREG_STAT_RFIFOVF) {
 		/* Receive FIFO overflow is harmless and the hardware will take
 		   care of it, just some packets are lost. Who cares. */
-		pr_debug("%s: Happy Meal receive FIFO overflow.\n",
-			 hp->dev->name);
+		netdev_dbg(hp->dev, "Happy Meal receive FIFO overflow.\n");
 	}
 
 	if (status & GREG_STAT_STSTERR) {
 		/* BigMAC SQE link test failed. */
-		pr_err("%s: Happy Meal BigMAC SQE test failed.\n",
-		       hp->dev->name);
+		netdev_err(hp->dev, "Happy Meal BigMAC SQE test failed.\n");
 		reset = 1;
 	}
 
 	if (status & GREG_STAT_TFIFO_UND) {
 		/* Transmit FIFO underrun, again DMA error likely. */
-		pr_err("%s: Happy Meal transmitter FIFO underrun, DMA error.\n",
-		       hp->dev->name);
+		netdev_err(hp->dev,
+			   "Happy Meal transmitter FIFO underrun, DMA error.\n");
 		reset = 1;
 	}
 
@@ -1750,8 +1753,7 @@ static int happy_meal_is_not_so_happy(struct happy_meal *hp, u32 status)
 		/* Driver error, tried to transmit something larger
 		 * than ethernet max mtu.
 		 */
-		pr_err("%s: Happy Meal MAX Packet size error.\n",
-		       hp->dev->name);
+		netdev_err(hp->dev, "Happy Meal MAX Packet size error.\n");
 		reset = 1;
 	}
 
@@ -1761,13 +1763,13 @@ static int happy_meal_is_not_so_happy(struct happy_meal *hp, u32 status)
 		 * faster than the interrupt handler could keep up
 		 * with.
 		 */
-		pr_info("%s: Happy Meal out of receive descriptors, packet dropped.\n",
-			hp->dev->name);
+		netdev_info(hp->dev,
+			    "Happy Meal out of receive descriptors, packet dropped.\n");
 	}
 
 	if (status & (GREG_STAT_RXERR|GREG_STAT_RXPERR|GREG_STAT_RXTERR)) {
 		/* All sorts of DMA receive errors. */
-		pr_err("%s: Happy Meal rx DMA errors [ ", hp->dev->name);
+		netdev_err(hp->dev, "Happy Meal rx DMA errors [ ");
 		if (status & GREG_STAT_RXERR)
 			printk("GenericError ");
 		if (status & GREG_STAT_RXPERR)
@@ -1782,20 +1784,20 @@ static int happy_meal_is_not_so_happy(struct happy_meal *hp, u32 status)
 		/* Driver bug, didn't set EOP bit in tx descriptor given
 		 * to the happy meal.
 		 */
-		pr_err("%s: EOP not set in happy meal transmit descriptor!\n",
-		       hp->dev->name);
+		netdev_err(hp->dev,
+			   "EOP not set in happy meal transmit descriptor!\n");
 		reset = 1;
 	}
 
 	if (status & GREG_STAT_MIFIRQ) {
 		/* MIF signalled an interrupt, were we polling it? */
-		pr_err("%s: Happy Meal MIF interrupt.\n", hp->dev->name);
+		netdev_err(hp->dev, "Happy Meal MIF interrupt.\n");
 	}
 
 	if (status &
 	    (GREG_STAT_TXEACK|GREG_STAT_TXLERR|GREG_STAT_TXPERR|GREG_STAT_TXTERR)) {
 		/* All sorts of transmit DMA errors. */
-		pr_err("%s: Happy Meal tx DMA errors [ ", hp->dev->name);
+		netdev_err(hp->dev, "Happy Meal tx DMA errors [ ");
 		if (status & GREG_STAT_TXEACK)
 			printk("GenericError ");
 		if (status & GREG_STAT_TXLERR)
@@ -1812,14 +1814,14 @@ static int happy_meal_is_not_so_happy(struct happy_meal *hp, u32 status)
 		/* Bus or parity error when cpu accessed happy meal registers
 		 * or it's internal FIFO's.  Should never see this.
 		 */
-		pr_err("%s: Happy Meal register access SBUS slave (%s) error.\n",
-		       hp->dev->name,
-		       (status & GREG_STAT_SLVPERR) ? "parity" : "generic");
+		netdev_err(hp->dev,
+			   "Happy Meal register access SBUS slave (%s) error.\n",
+			   (status & GREG_STAT_SLVPERR) ? "parity" : "generic");
 		reset = 1;
 	}
 
 	if (reset) {
-		pr_notice("%s: Resetting...\n", hp->dev->name);
+		netdev_notice(hp->dev, "Resetting...\n");
 		happy_meal_init(hp);
 		return 1;
 	}
@@ -1831,25 +1833,22 @@ static void happy_meal_mif_interrupt(struct happy_meal *hp)
 {
 	void __iomem *tregs = hp->tcvregs;
 
-	pr_info("%s: Link status change.\n", hp->dev->name);
+	netdev_info(hp->dev, "Link status change.\n");
 	hp->sw_bmcr = happy_meal_tcvr_read(hp, tregs, MII_BMCR);
 	hp->sw_lpa = happy_meal_tcvr_read(hp, tregs, MII_LPA);
 
 	/* Use the fastest transmission protocol possible. */
 	if (hp->sw_lpa & LPA_100FULL) {
-		pr_info("%s: Switching to 100Mbps at full duplex.",
-			hp->dev->name);
+		netdev_info(hp->dev, "Switching to 100Mbps at full duplex.");
 		hp->sw_bmcr |= (BMCR_FULLDPLX | BMCR_SPEED100);
 	} else if (hp->sw_lpa & LPA_100HALF) {
-		pr_info("%s: Switching to 100MBps at half duplex.",
-			hp->dev->name);
+		netdev_info(hp->dev, "Switching to 100MBps at half duplex.");
 		hp->sw_bmcr |= BMCR_SPEED100;
 	} else if (hp->sw_lpa & LPA_10FULL) {
-		pr_info("%s: Switching to 10MBps at full duplex.",
-			hp->dev->name);
+		netdev_info(hp->dev, "Switching to 10MBps at full duplex.");
 		hp->sw_bmcr |= BMCR_FULLDPLX;
 	} else {
-		pr_info("%s: Using 10Mbps at half duplex.", hp->dev->name);
+		netdev_info(hp->dev, "Using 10Mbps at half duplex.");
 	}
 	happy_meal_tcvr_write(hp, tregs, MII_BMCR, hp->sw_bmcr);
 
@@ -2027,8 +2026,7 @@ static void happy_meal_rx(struct happy_meal *hp, struct net_device *dev)
 	}
 	hp->rx_new = elem;
 	if (drops)
-		pr_info("%s: Memory squeeze, deferring packet.\n",
-			hp->dev->name);
+		netdev_info(hp->dev, "Memory squeeze, deferring packet.\n");
 	RXD(">");
 }
 
@@ -2136,8 +2134,7 @@ static int happy_meal_open(struct net_device *dev)
 				  dev->name, dev);
 		if (res) {
 			HMD("EAGAIN\n");
-			pr_err("happy_meal(SBUS): Can't order irq %d to go.\n",
-			       hp->irq);
+			netdev_err(dev, "Can't order irq %d to go.\n", hp->irq);
 
 			return -EAGAIN;
 		}
@@ -2181,12 +2178,12 @@ static void happy_meal_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 	struct happy_meal *hp = netdev_priv(dev);
 
-	pr_err("%s: transmit timed out, resetting\n", dev->name);
+	netdev_err(dev, "transmit timed out, resetting\n");
 	tx_dump_log();
-	pr_err("%s: Happy Status %08x TX[%08x:%08x]\n", dev->name,
-	       hme_read32(hp, hp->gregs + GREG_STAT),
-	       hme_read32(hp, hp->etxregs + ETX_CFG),
-	       hme_read32(hp, hp->bigmacregs + BMAC_TXCFG));
+	netdev_err(dev, "Happy Status %08x TX[%08x:%08x]\n",
+		   hme_read32(hp, hp->gregs + GREG_STAT),
+		   hme_read32(hp, hp->etxregs + ETX_CFG),
+		   hme_read32(hp, hp->bigmacregs + BMAC_TXCFG));
 
 	spin_lock_irq(&hp->happy_lock);
 	happy_meal_init(hp);
@@ -2236,8 +2233,7 @@ static netdev_tx_t happy_meal_start_xmit(struct sk_buff *skb,
 	if (TX_BUFFS_AVAIL(hp) <= (skb_shinfo(skb)->nr_frags + 1)) {
 		netif_stop_queue(dev);
 		spin_unlock_irq(&hp->happy_lock);
-		pr_err("%s: BUG! Tx Ring full when queue awake!\n",
-		       dev->name);
+		netdev_err(dev, "BUG! Tx Ring full when queue awake!\n");
 		return NETDEV_TX_BUSY;
 	}
 
@@ -2535,8 +2531,9 @@ static int __init quattro_sbus_register_irqs(void)
 				  IRQF_SHARED, "Quattro",
 				  qp);
 		if (err != 0) {
-			pr_err("Quattro HME: IRQ registration error %d.\n",
-			       err);
+			dev_err(&op->dev,
+				"Quattro HME: IRQ registration error %d.\n",
+				err);
 			return err;
 		}
 	}
@@ -2643,9 +2640,6 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
 		goto err_out;
 	SET_NETDEV_DEV(dev, &op->dev);
 
-	if (hme_version_printed++ == 0)
-		pr_info("%s", version);
-
 	/* If user did not specify a MAC address specifically, use
 	 * the Quattro local-mac-address property...
 	 */
@@ -2687,35 +2681,35 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
 	hp->gregs = of_ioremap(&op->resource[0], 0,
 			       GREG_REG_SIZE, "HME Global Regs");
 	if (!hp->gregs) {
-		pr_err("happymeal: Cannot map global registers.\n");
+		dev_err(&op->dev, "Cannot map global registers.\n");
 		goto err_out_free_netdev;
 	}
 
 	hp->etxregs = of_ioremap(&op->resource[1], 0,
 				 ETX_REG_SIZE, "HME TX Regs");
 	if (!hp->etxregs) {
-		pr_err("happymeal: Cannot map MAC TX registers.\n");
+		dev_err(&op->dev, "Cannot map MAC TX registers.\n");
 		goto err_out_iounmap;
 	}
 
 	hp->erxregs = of_ioremap(&op->resource[2], 0,
 				 ERX_REG_SIZE, "HME RX Regs");
 	if (!hp->erxregs) {
-		pr_err("happymeal: Cannot map MAC RX registers.\n");
+		dev_err(&op->dev, "Cannot map MAC RX registers.\n");
 		goto err_out_iounmap;
 	}
 
 	hp->bigmacregs = of_ioremap(&op->resource[3], 0,
 				    BMAC_REG_SIZE, "HME BIGMAC Regs");
 	if (!hp->bigmacregs) {
-		pr_err("happymeal: Cannot map BIGMAC registers.\n");
+		dev_err(&op->dev, "Cannot map BIGMAC registers.\n");
 		goto err_out_iounmap;
 	}
 
 	hp->tcvregs = of_ioremap(&op->resource[4], 0,
 				 TCVR_REG_SIZE, "HME Tranceiver Regs");
 	if (!hp->tcvregs) {
-		pr_err("happymeal: Cannot map TCVR registers.\n");
+		dev_err(&op->dev, "Cannot map TCVR registers.\n");
 		goto err_out_iounmap;
 	}
 
@@ -2782,18 +2776,17 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
 
 	err = register_netdev(hp->dev);
 	if (err) {
-		pr_err("happymeal: Cannot register net device, aborting.\n");
+		dev_err(&op->dev, "Cannot register net device, aborting.\n");
 		goto err_out_free_coherent;
 	}
 
 	platform_set_drvdata(op, hp);
 
 	if (qfe_slot != -1)
-		pr_info("%s: Quattro HME slot %d (SBUS) 10/100baseT Ethernet ",
-			dev->name, qfe_slot);
+		netdev_info(dev, "Quattro HME slot %d (SBUS) 10/100baseT Ethernet ",
+			    qfe_slot);
 	else
-		pr_info("%s: HAPPY MEAL (SBUS) 10/100baseT Ethernet ",
-			dev->name);
+		netdev_info(dev, "HAPPY MEAL (SBUS) 10/100baseT Ethernet ");
 
 	printk("%pM\n", dev->dev_addr);
 
@@ -2983,7 +2976,8 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 
 	err = -EINVAL;
 	if ((pci_resource_flags(pdev, 0) & IORESOURCE_IO) != 0) {
-		pr_err("happymeal(PCI): Cannot find proper PCI device base address.\n");
+		dev_err(&pdev->dev,
+			"Cannot find proper PCI device base address.\n");
 		goto err_out_clear_quattro;
 	}
 
@@ -2991,14 +2985,14 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 					pci_resource_len(pdev, 0), DRV_NAME);
 	if (IS_ERR(hpreg_res)) {
 		err = PTR_ERR(hpreg_res);
-		pr_err("happymeal(PCI): Cannot obtain PCI resources, aborting.\n");
+		dev_err(&pdev->dev, "Cannot obtain PCI resources, aborting.\n");
 		goto err_out_clear_quattro;
 	}
 
 	hpreg_base = pcim_iomap(pdev, 0, 0x8000);
 	err = -ENOMEM;
 	if (!hpreg_base) {
-		pr_err("happymeal(PCI): Unable to remap card memory.\n");
+		dev_err(&pdev->dev, "Unable to remap card memory.\n");
 		goto err_out_clear_quattro;
 	}
 
@@ -3105,7 +3099,7 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 
 	err = devm_register_netdev(&pdev->dev, dev);
 	if (err) {
-		pr_err("happymeal(PCI): Cannot register net device, aborting.\n");
+		dev_err(&pdev->dev, "Cannot register net device, aborting.\n");
 		goto err_out_clear_quattro;
 	}
 
@@ -3119,8 +3113,9 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 			int i = simple_strtoul(dev->name + 3, NULL, 10);
 			sprintf(prom_name, "-%d", i + 3);
 		}
-		pr_info("%s%s: Quattro HME (PCI/CheerIO) 10/100baseT Ethernet ",
-			dev->name, prom_name);
+		netdev_info(dev,
+			    "%s: Quattro HME (PCI/CheerIO) 10/100baseT Ethernet ",
+			    prom_name);
 		if (qpdev->vendor == PCI_VENDOR_ID_DEC &&
 		    qpdev->device == PCI_DEVICE_ID_DEC_21153)
 			printk("DEC 21153 PCI Bridge\n");
@@ -3130,11 +3125,12 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	}
 
 	if (qfe_slot != -1)
-		pr_info("%s: Quattro HME slot %d (PCI/CheerIO) 10/100baseT Ethernet ",
-			dev->name, qfe_slot);
+		netdev_info(dev,
+			    "Quattro HME slot %d (PCI/CheerIO) 10/100baseT Ethernet ",
+			    qfe_slot);
 	else
-		pr_info("%s: HAPPY MEAL (PCI/CheerIO) 10/100BaseT Ethernet ",
-			dev->name);
+		netdev_info(dev,
+			    "HAPPY MEAL (PCI/CheerIO) 10/100BaseT Ethernet ");
 
 	printk("%pM\n", dev->dev_addr);
 
-- 
2.37.1

