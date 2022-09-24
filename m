Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6745E8723
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 03:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233150AbiIXBy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 21:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232397AbiIXByg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 21:54:36 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B9010BB0C;
        Fri, 23 Sep 2022 18:53:56 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id g4so1060272qvo.3;
        Fri, 23 Sep 2022 18:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=47DaXlMFK6b2IVewGMobf+JX9qgPMyGuSDxZ3yHbbBw=;
        b=lbdsH0zXdghfNKNGoBPBegi7BrULizAi/NCy+jVp8t+vnqgmcQEwRWTNlIPQPLY0Be
         io1MKu8WgljuMBBhK2FyYN8QRioTLSxLU7kRNCOjIyzA8CWK2FkCbwQl8SZ7Dq0nc9DX
         Cnrbt1JZ0iXLAdRjcxB1lwcIi4XzlWbncKV0IhiydmcId67YpDRjMUDetvZ5do3jHMXH
         D3n6BTlsCzQ605JGRJsfJyNmWci+rgUkgsFmfjGTFmVvhZO8HBc2fI+0mjSA9lbj5kup
         6iIen8Qu0MUp1fZvbiFHs8xpCxy+CkqtcxJhjpdGelE8QR9Jy+DesikJiXVobwXafJAO
         N1+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=47DaXlMFK6b2IVewGMobf+JX9qgPMyGuSDxZ3yHbbBw=;
        b=uzVqWhU6UEE2aOWJ/J4frFMXWUcb9tNLSXjULS+F4sM0Np1hJLinP3eNQ2FsnJGGoE
         F8oSqFnJu5TWz9pF0IMkIWh0SuuRWE/lm0k5t1CK1iXP5Kgwwfx1w4iRv8chg85I8fQr
         FiNLE1jm2G1stvNz4i+RAbnoHqqH2gnGtLoXhwr78Ak3NgH/rOVmrTc9l3AHVqSgsXdW
         AXyiAkvlY1VM6rS5EbESO3z33XACqZibueoRpFYWMmMXRxk5Vsgq7/aMQANvcFDvVXxL
         2mjbMjg303MnZGJV/TujxPFH4txkgmQV63LDqYxNu0L6wfRPB2dqZ4/R2rCXUzCnUvca
         ceLg==
X-Gm-Message-State: ACrzQf0seGg2P4UPMPJpqSn6aj728MYdtCFj6qqBTHigzGS8yYSyVARs
        6kxi0M7M3kUBvr9u3yy7oN0=
X-Google-Smtp-Source: AMsMyM6inxZIzhNnrma9SWrXZWeXXw5mAVXapSpgdmK2bMthHA7KcW088UwixLmS8rUvms2ikbA03g==
X-Received: by 2002:a0c:8c4f:0:b0:4ac:94fa:a587 with SMTP id o15-20020a0c8c4f000000b004ac94faa587mr9369355qvb.40.1663984434704;
        Fri, 23 Sep 2022 18:53:54 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id cp4-20020a05622a420400b0035cdd7a42d0sm6245242qtb.22.2022.09.23.18.53.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 18:53:54 -0700 (PDT)
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
Subject: [PATCH net-next v2 09/13] sunhme: Convert printk(KERN_FOO ...) to pr_foo(...)
Date:   Fri, 23 Sep 2022 21:53:35 -0400
Message-Id: <20220924015339.1816744-10-seanga2@gmail.com>
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

This is a mostly-mechanical translation of the existing printks into
pr_foos. In several places, I have pasted messages which were broken over
several lines to allow for easier grepping.

Signed-off-by: Sean Anderson <seanga2@gmail.com>
---

(no changes since v1)

 drivers/net/ethernet/sun/sunhme.c | 152 +++++++++++++++---------------
 1 file changed, 78 insertions(+), 74 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index cea99ddc4ce5..df8e38c117f3 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -145,7 +145,7 @@ static __inline__ void tx_dump_log(void)
 
 	this = txlog_cur_entry;
 	for (i = 0; i < TX_LOG_LEN; i++) {
-		printk("TXLOG[%d]: j[%08x] tx[N(%d)O(%d)] action[%08x] stat[%08x]\n", i,
+		pr_err("TXLOG[%d]: j[%08x] tx[N(%d)O(%d)] action[%08x] stat[%08x]\n", i,
 		       tx_log[this].tstamp,
 		       tx_log[this].tx_new, tx_log[this].tx_old,
 		       tx_log[this].action, tx_log[this].status);
@@ -436,7 +436,7 @@ static int happy_meal_tcvr_read(struct happy_meal *hp,
 	while (!(hme_read32(hp, tregs + TCVR_FRAME) & 0x10000) && --tries)
 		udelay(20);
 	if (!tries) {
-		printk(KERN_ERR "happy meal: Aieee, transceiver MIF read bolixed\n");
+		pr_err("happy meal: Aieee, transceiver MIF read bolixed\n");
 		return TCVR_FAILURE;
 	}
 	retval = hme_read32(hp, tregs + TCVR_FRAME) & 0xffff;
@@ -469,7 +469,7 @@ static void happy_meal_tcvr_write(struct happy_meal *hp,
 
 	/* Anything else? */
 	if (!tries)
-		printk(KERN_ERR "happy meal: Aieee, transceiver MIF write bolixed\n");
+		pr_err("happy meal: Aieee, transceiver MIF write bolixed\n");
 
 	/* Fifty-two cents is your change, have a nice day. */
 }
@@ -647,8 +647,8 @@ static void happy_meal_timer(struct timer_list *t)
 			/* Enter force mode. */
 	do_force_mode:
 			hp->sw_bmcr = happy_meal_tcvr_read(hp, tregs, MII_BMCR);
-			printk(KERN_NOTICE "%s: Auto-Negotiation unsuccessful, trying force link mode\n",
-			       hp->dev->name);
+			pr_notice("%s: Auto-Negotiation unsuccessful, trying force link mode\n",
+				  hp->dev->name);
 			hp->sw_bmcr = BMCR_SPEED100;
 			happy_meal_tcvr_write(hp, tregs, MII_BMCR, hp->sw_bmcr);
 
@@ -707,8 +707,8 @@ static void happy_meal_timer(struct timer_list *t)
 			restart_timer = 0;
 		} else {
 			if (hp->timer_ticks >= 10) {
-				printk(KERN_NOTICE "%s: Auto negotiation successful, link still "
-				       "not completely up.\n", hp->dev->name);
+				pr_notice("%s: Auto negotiation successful, link still not completely up.\n",
+					  hp->dev->name);
 				hp->timer_ticks = 0;
 				restart_timer = 1;
 			} else {
@@ -763,14 +763,14 @@ static void happy_meal_timer(struct timer_list *t)
 					 */
 
 					/* Let the user know... */
-					printk(KERN_NOTICE "%s: Link down, cable problem?\n",
-					       hp->dev->name);
+					pr_notice("%s: Link down, cable problem?\n",
+						  hp->dev->name);
 
 					ret = happy_meal_init(hp);
 					if (ret) {
 						/* ho hum... */
-						printk(KERN_ERR "%s: Error, cannot re-init the "
-						       "Happy Meal.\n", hp->dev->name);
+						pr_err("%s: Error, cannot re-init the Happy Meal.\n",
+						       hp->dev->name);
 					}
 					goto out;
 				}
@@ -792,7 +792,7 @@ static void happy_meal_timer(struct timer_list *t)
 	case asleep:
 	default:
 		/* Can't happens.... */
-		printk(KERN_ERR "%s: Aieee, link timer is asleep but we got one anyways!\n",
+		pr_err("%s: Aieee, link timer is asleep but we got one anyways!\n",
 		       hp->dev->name);
 		restart_timer = 0;
 		hp->timer_ticks = 0;
@@ -826,7 +826,7 @@ static void happy_meal_tx_reset(struct happy_meal *hp, void __iomem *bregs)
 
 	/* Lettuce, tomato, buggy hardware (no extra charge)? */
 	if (!tries)
-		printk(KERN_ERR "happy meal: Transceiver BigMac ATTACK!");
+		pr_err("happy meal: Transceiver BigMac ATTACK!");
 
 	/* Take care. */
 	HMD("done\n");
@@ -846,7 +846,7 @@ static void happy_meal_rx_reset(struct happy_meal *hp, void __iomem *bregs)
 
 	/* Will that be all? */
 	if (!tries)
-		printk(KERN_ERR "happy meal: Receiver BigMac ATTACK!");
+		pr_err("happy meal: Receiver BigMac ATTACK!");
 
 	/* Don't forget your vik_1137125_wa.  Have a nice day. */
 	HMD("done\n");
@@ -868,7 +868,7 @@ static void happy_meal_stop(struct happy_meal *hp, void __iomem *gregs)
 
 	/* Come back next week when we are "Sun Microelectronics". */
 	if (!tries)
-		printk(KERN_ERR "happy meal: Fry guys.");
+		pr_err("happy meal: Fry guys.");
 
 	/* Remember: "Different name, same old buggy as shit hardware." */
 	HMD("done\n");
@@ -1086,7 +1086,7 @@ static void happy_meal_transceiver_check(struct happy_meal *hp, void __iomem *tr
 				hp->tcvr_type = internal;
 				ASD("<internal>\n");
 			} else {
-				printk(KERN_ERR "happy meal: Transceiver and a coke please.");
+				pr_err("happy meal: Transceiver and a coke please.");
 				hp->tcvr_type = none; /* Grrr... */
 				ASD("<none>\n");
 			}
@@ -1311,10 +1311,10 @@ happy_meal_begin_auto_negotiation(struct happy_meal *hp,
 			udelay(10);
 		}
 		if (!timeout) {
-			printk(KERN_ERR "%s: Happy Meal would not start auto negotiation "
-			       "BMCR=0x%04x\n", hp->dev->name, hp->sw_bmcr);
-			printk(KERN_NOTICE "%s: Performing force link detection.\n",
-			       hp->dev->name);
+			pr_err("%s: Happy Meal would not start auto negotiation BMCR=0x%04x\n",
+			       hp->dev->name, hp->sw_bmcr);
+			pr_notice("%s: Performing force link detection.\n",
+				  hp->dev->name);
 			goto force_link;
 		} else {
 			hp->timer_state = arbwait;
@@ -1583,8 +1583,8 @@ static int happy_meal_init(struct happy_meal *hp)
 	regtmp = hme_read32(hp, erxregs + ERX_CFG);
 	hme_write32(hp, erxregs + ERX_CFG, ERX_CFG_DEFAULT(RX_OFFSET));
 	if (hme_read32(hp, erxregs + ERX_CFG) != ERX_CFG_DEFAULT(RX_OFFSET)) {
-		printk(KERN_ERR "happy meal: Eieee, rx config register gets greasy fries.\n");
-		printk(KERN_ERR "happy meal: Trying to set %08x, reread gives %08x\n",
+		pr_err("happy meal: Eieee, rx config register gets greasy fries.\n");
+		pr_err("happy meal: Trying to set %08x, reread gives %08x\n",
 		       ERX_CFG_DEFAULT(RX_OFFSET), regtmp);
 		/* XXX Should return failure here... */
 	}
@@ -1722,24 +1722,26 @@ static int happy_meal_is_not_so_happy(struct happy_meal *hp, u32 status)
 		      GREG_STAT_MIFIRQ | GREG_STAT_TXEACK | GREG_STAT_TXLERR |
 		      GREG_STAT_TXPERR | GREG_STAT_TXTERR | GREG_STAT_SLVERR |
 		      GREG_STAT_SLVPERR))
-		printk(KERN_ERR "%s: Error interrupt for happy meal, status = %08x\n",
+		pr_err("%s: Error interrupt for happy meal, status = %08x\n",
 		       hp->dev->name, status);
 
 	if (status & GREG_STAT_RFIFOVF) {
 		/* Receive FIFO overflow is harmless and the hardware will take
 		   care of it, just some packets are lost. Who cares. */
-		printk(KERN_DEBUG "%s: Happy Meal receive FIFO overflow.\n", hp->dev->name);
+		pr_debug("%s: Happy Meal receive FIFO overflow.\n",
+			 hp->dev->name);
 	}
 
 	if (status & GREG_STAT_STSTERR) {
 		/* BigMAC SQE link test failed. */
-		printk(KERN_ERR "%s: Happy Meal BigMAC SQE test failed.\n", hp->dev->name);
+		pr_err("%s: Happy Meal BigMAC SQE test failed.\n",
+		       hp->dev->name);
 		reset = 1;
 	}
 
 	if (status & GREG_STAT_TFIFO_UND) {
 		/* Transmit FIFO underrun, again DMA error likely. */
-		printk(KERN_ERR "%s: Happy Meal transmitter FIFO underrun, DMA error.\n",
+		pr_err("%s: Happy Meal transmitter FIFO underrun, DMA error.\n",
 		       hp->dev->name);
 		reset = 1;
 	}
@@ -1748,7 +1750,8 @@ static int happy_meal_is_not_so_happy(struct happy_meal *hp, u32 status)
 		/* Driver error, tried to transmit something larger
 		 * than ethernet max mtu.
 		 */
-		printk(KERN_ERR "%s: Happy Meal MAX Packet size error.\n", hp->dev->name);
+		pr_err("%s: Happy Meal MAX Packet size error.\n",
+		       hp->dev->name);
 		reset = 1;
 	}
 
@@ -1758,14 +1761,13 @@ static int happy_meal_is_not_so_happy(struct happy_meal *hp, u32 status)
 		 * faster than the interrupt handler could keep up
 		 * with.
 		 */
-		printk(KERN_INFO "%s: Happy Meal out of receive "
-		       "descriptors, packet dropped.\n",
-		       hp->dev->name);
+		pr_info("%s: Happy Meal out of receive descriptors, packet dropped.\n",
+			hp->dev->name);
 	}
 
 	if (status & (GREG_STAT_RXERR|GREG_STAT_RXPERR|GREG_STAT_RXTERR)) {
 		/* All sorts of DMA receive errors. */
-		printk(KERN_ERR "%s: Happy Meal rx DMA errors [ ", hp->dev->name);
+		pr_err("%s: Happy Meal rx DMA errors [ ", hp->dev->name);
 		if (status & GREG_STAT_RXERR)
 			printk("GenericError ");
 		if (status & GREG_STAT_RXPERR)
@@ -1780,20 +1782,20 @@ static int happy_meal_is_not_so_happy(struct happy_meal *hp, u32 status)
 		/* Driver bug, didn't set EOP bit in tx descriptor given
 		 * to the happy meal.
 		 */
-		printk(KERN_ERR "%s: EOP not set in happy meal transmit descriptor!\n",
+		pr_err("%s: EOP not set in happy meal transmit descriptor!\n",
 		       hp->dev->name);
 		reset = 1;
 	}
 
 	if (status & GREG_STAT_MIFIRQ) {
 		/* MIF signalled an interrupt, were we polling it? */
-		printk(KERN_ERR "%s: Happy Meal MIF interrupt.\n", hp->dev->name);
+		pr_err("%s: Happy Meal MIF interrupt.\n", hp->dev->name);
 	}
 
 	if (status &
 	    (GREG_STAT_TXEACK|GREG_STAT_TXLERR|GREG_STAT_TXPERR|GREG_STAT_TXTERR)) {
 		/* All sorts of transmit DMA errors. */
-		printk(KERN_ERR "%s: Happy Meal tx DMA errors [ ", hp->dev->name);
+		pr_err("%s: Happy Meal tx DMA errors [ ", hp->dev->name);
 		if (status & GREG_STAT_TXEACK)
 			printk("GenericError ");
 		if (status & GREG_STAT_TXLERR)
@@ -1810,14 +1812,14 @@ static int happy_meal_is_not_so_happy(struct happy_meal *hp, u32 status)
 		/* Bus or parity error when cpu accessed happy meal registers
 		 * or it's internal FIFO's.  Should never see this.
 		 */
-		printk(KERN_ERR "%s: Happy Meal register access SBUS slave (%s) error.\n",
+		pr_err("%s: Happy Meal register access SBUS slave (%s) error.\n",
 		       hp->dev->name,
 		       (status & GREG_STAT_SLVPERR) ? "parity" : "generic");
 		reset = 1;
 	}
 
 	if (reset) {
-		printk(KERN_NOTICE "%s: Resetting...\n", hp->dev->name);
+		pr_notice("%s: Resetting...\n", hp->dev->name);
 		happy_meal_init(hp);
 		return 1;
 	}
@@ -1829,22 +1831,25 @@ static void happy_meal_mif_interrupt(struct happy_meal *hp)
 {
 	void __iomem *tregs = hp->tcvregs;
 
-	printk(KERN_INFO "%s: Link status change.\n", hp->dev->name);
+	pr_info("%s: Link status change.\n", hp->dev->name);
 	hp->sw_bmcr = happy_meal_tcvr_read(hp, tregs, MII_BMCR);
 	hp->sw_lpa = happy_meal_tcvr_read(hp, tregs, MII_LPA);
 
 	/* Use the fastest transmission protocol possible. */
 	if (hp->sw_lpa & LPA_100FULL) {
-		printk(KERN_INFO "%s: Switching to 100Mbps at full duplex.", hp->dev->name);
+		pr_info("%s: Switching to 100Mbps at full duplex.",
+			hp->dev->name);
 		hp->sw_bmcr |= (BMCR_FULLDPLX | BMCR_SPEED100);
 	} else if (hp->sw_lpa & LPA_100HALF) {
-		printk(KERN_INFO "%s: Switching to 100MBps at half duplex.", hp->dev->name);
+		pr_info("%s: Switching to 100MBps at half duplex.",
+			hp->dev->name);
 		hp->sw_bmcr |= BMCR_SPEED100;
 	} else if (hp->sw_lpa & LPA_10FULL) {
-		printk(KERN_INFO "%s: Switching to 10MBps at full duplex.", hp->dev->name);
+		pr_info("%s: Switching to 10MBps at full duplex.",
+			hp->dev->name);
 		hp->sw_bmcr |= BMCR_FULLDPLX;
 	} else {
-		printk(KERN_INFO "%s: Using 10Mbps at half duplex.", hp->dev->name);
+		pr_info("%s: Using 10Mbps at half duplex.", hp->dev->name);
 	}
 	happy_meal_tcvr_write(hp, tregs, MII_BMCR, hp->sw_bmcr);
 
@@ -2022,7 +2027,8 @@ static void happy_meal_rx(struct happy_meal *hp, struct net_device *dev)
 	}
 	hp->rx_new = elem;
 	if (drops)
-		printk(KERN_INFO "%s: Memory squeeze, deferring packet.\n", hp->dev->name);
+		pr_info("%s: Memory squeeze, deferring packet.\n",
+			hp->dev->name);
 	RXD(">");
 }
 
@@ -2130,7 +2136,7 @@ static int happy_meal_open(struct net_device *dev)
 				  dev->name, dev);
 		if (res) {
 			HMD("EAGAIN\n");
-			printk(KERN_ERR "happy_meal(SBUS): Can't order irq %d to go.\n",
+			pr_err("happy_meal(SBUS): Can't order irq %d to go.\n",
 			       hp->irq);
 
 			return -EAGAIN;
@@ -2175,12 +2181,12 @@ static void happy_meal_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 	struct happy_meal *hp = netdev_priv(dev);
 
-	printk (KERN_ERR "%s: transmit timed out, resetting\n", dev->name);
+	pr_err("%s: transmit timed out, resetting\n", dev->name);
 	tx_dump_log();
-	printk (KERN_ERR "%s: Happy Status %08x TX[%08x:%08x]\n", dev->name,
-		hme_read32(hp, hp->gregs + GREG_STAT),
-		hme_read32(hp, hp->etxregs + ETX_CFG),
-		hme_read32(hp, hp->bigmacregs + BMAC_TXCFG));
+	pr_err("%s: Happy Status %08x TX[%08x:%08x]\n", dev->name,
+	       hme_read32(hp, hp->gregs + GREG_STAT),
+	       hme_read32(hp, hp->etxregs + ETX_CFG),
+	       hme_read32(hp, hp->bigmacregs + BMAC_TXCFG));
 
 	spin_lock_irq(&hp->happy_lock);
 	happy_meal_init(hp);
@@ -2230,7 +2236,7 @@ static netdev_tx_t happy_meal_start_xmit(struct sk_buff *skb,
 	if (TX_BUFFS_AVAIL(hp) <= (skb_shinfo(skb)->nr_frags + 1)) {
 		netif_stop_queue(dev);
 		spin_unlock_irq(&hp->happy_lock);
-		printk(KERN_ERR "%s: BUG! Tx Ring full when queue awake!\n",
+		pr_err("%s: BUG! Tx Ring full when queue awake!\n",
 		       dev->name);
 		return NETDEV_TX_BUSY;
 	}
@@ -2527,8 +2533,8 @@ static int __init quattro_sbus_register_irqs(void)
 				  IRQF_SHARED, "Quattro",
 				  qp);
 		if (err != 0) {
-			printk(KERN_ERR "Quattro HME: IRQ registration "
-			       "error %d.\n", err);
+			pr_err("Quattro HME: IRQ registration error %d.\n",
+			       err);
 			return err;
 		}
 	}
@@ -2636,7 +2642,7 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
 	SET_NETDEV_DEV(dev, &op->dev);
 
 	if (hme_version_printed++ == 0)
-		printk(KERN_INFO "%s", version);
+		pr_info("%s", version);
 
 	/* If user did not specify a MAC address specifically, use
 	 * the Quattro local-mac-address property...
@@ -2679,35 +2685,35 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
 	hp->gregs = of_ioremap(&op->resource[0], 0,
 			       GREG_REG_SIZE, "HME Global Regs");
 	if (!hp->gregs) {
-		printk(KERN_ERR "happymeal: Cannot map global registers.\n");
+		pr_err("happymeal: Cannot map global registers.\n");
 		goto err_out_free_netdev;
 	}
 
 	hp->etxregs = of_ioremap(&op->resource[1], 0,
 				 ETX_REG_SIZE, "HME TX Regs");
 	if (!hp->etxregs) {
-		printk(KERN_ERR "happymeal: Cannot map MAC TX registers.\n");
+		pr_err("happymeal: Cannot map MAC TX registers.\n");
 		goto err_out_iounmap;
 	}
 
 	hp->erxregs = of_ioremap(&op->resource[2], 0,
 				 ERX_REG_SIZE, "HME RX Regs");
 	if (!hp->erxregs) {
-		printk(KERN_ERR "happymeal: Cannot map MAC RX registers.\n");
+		pr_err("happymeal: Cannot map MAC RX registers.\n");
 		goto err_out_iounmap;
 	}
 
 	hp->bigmacregs = of_ioremap(&op->resource[3], 0,
 				    BMAC_REG_SIZE, "HME BIGMAC Regs");
 	if (!hp->bigmacregs) {
-		printk(KERN_ERR "happymeal: Cannot map BIGMAC registers.\n");
+		pr_err("happymeal: Cannot map BIGMAC registers.\n");
 		goto err_out_iounmap;
 	}
 
 	hp->tcvregs = of_ioremap(&op->resource[4], 0,
 				 TCVR_REG_SIZE, "HME Tranceiver Regs");
 	if (!hp->tcvregs) {
-		printk(KERN_ERR "happymeal: Cannot map TCVR registers.\n");
+		pr_err("happymeal: Cannot map TCVR registers.\n");
 		goto err_out_iounmap;
 	}
 
@@ -2774,19 +2780,18 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
 
 	err = register_netdev(hp->dev);
 	if (err) {
-		printk(KERN_ERR "happymeal: Cannot register net device, "
-		       "aborting.\n");
+		pr_err("happymeal: Cannot register net device, aborting.\n");
 		goto err_out_free_coherent;
 	}
 
 	platform_set_drvdata(op, hp);
 
 	if (qfe_slot != -1)
-		printk(KERN_INFO "%s: Quattro HME slot %d (SBUS) 10/100baseT Ethernet ",
-		       dev->name, qfe_slot);
+		pr_info("%s: Quattro HME slot %d (SBUS) 10/100baseT Ethernet ",
+			dev->name, qfe_slot);
 	else
-		printk(KERN_INFO "%s: HAPPY MEAL (SBUS) 10/100baseT Ethernet ",
-		       dev->name);
+		pr_info("%s: HAPPY MEAL (SBUS) 10/100baseT Ethernet ",
+			dev->name);
 
 	printk("%pM\n", dev->dev_addr);
 
@@ -2975,7 +2980,7 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 
 	err = -EINVAL;
 	if ((pci_resource_flags(pdev, 0) & IORESOURCE_IO) != 0) {
-		printk(KERN_ERR "happymeal(PCI): Cannot find proper PCI device base address.\n");
+		pr_err("happymeal(PCI): Cannot find proper PCI device base address.\n");
 		goto err_out_clear_quattro;
 	}
 
@@ -2983,15 +2988,14 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 					pci_resource_len(pdev, 0), DRV_NAME);
 	if (IS_ERR(hpreg_res)) {
 		err = PTR_ERR(hpreg_res);
-		printk(KERN_ERR "happymeal(PCI): Cannot obtain PCI resources, "
-		       "aborting.\n");
+		pr_err("happymeal(PCI): Cannot obtain PCI resources, aborting.\n");
 		goto err_out_clear_quattro;
 	}
 
 	hpreg_base = pcim_iomap(pdev, 0, 0x8000);
 	if (!hpreg_base) {
 		err = -ENOMEM;
-		printk(KERN_ERR "happymeal(PCI): Unable to remap card memory.\n");
+		pr_err("happymeal(PCI): Unable to remap card memory.\n");
 		goto err_out_clear_quattro;
 	}
 
@@ -3099,8 +3103,7 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 
 	err = devm_register_netdev(&pdev->dev, dev);
 	if (err) {
-		printk(KERN_ERR "happymeal(PCI): Cannot register net device, "
-		       "aborting.\n");
+		pr_err("happymeal(PCI): Cannot register net device, aborting.\n");
 		goto err_out_clear_quattro;
 	}
 
@@ -3114,7 +3117,8 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 			int i = simple_strtoul(dev->name + 3, NULL, 10);
 			sprintf(prom_name, "-%d", i + 3);
 		}
-		printk(KERN_INFO "%s%s: Quattro HME (PCI/CheerIO) 10/100baseT Ethernet ", dev->name, prom_name);
+		pr_info("%s%s: Quattro HME (PCI/CheerIO) 10/100baseT Ethernet ",
+			dev->name, prom_name);
 		if (qpdev->vendor == PCI_VENDOR_ID_DEC &&
 		    qpdev->device == PCI_DEVICE_ID_DEC_21153)
 			printk("DEC 21153 PCI Bridge\n");
@@ -3124,11 +3128,11 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	}
 
 	if (qfe_slot != -1)
-		printk(KERN_INFO "%s: Quattro HME slot %d (PCI/CheerIO) 10/100baseT Ethernet ",
-		       dev->name, qfe_slot);
+		pr_info("%s: Quattro HME slot %d (PCI/CheerIO) 10/100baseT Ethernet ",
+			dev->name, qfe_slot);
 	else
-		printk(KERN_INFO "%s: HAPPY MEAL (PCI/CheerIO) 10/100BaseT Ethernet ",
-		       dev->name);
+		pr_info("%s: HAPPY MEAL (PCI/CheerIO) 10/100BaseT Ethernet ",
+			dev->name);
 
 	printk("%pM\n", dev->dev_addr);
 
-- 
2.37.1

