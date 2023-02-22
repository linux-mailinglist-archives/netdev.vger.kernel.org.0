Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A15469FD62
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 22:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbjBVVEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 16:04:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbjBVVEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 16:04:14 -0500
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45C543447;
        Wed, 22 Feb 2023 13:04:05 -0800 (PST)
Received: by mail-qv1-xf2c.google.com with SMTP id ff4so9694693qvb.2;
        Wed, 22 Feb 2023 13:04:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qYbE8DEpqWwPaSKWPs+gr+4VM0HVT0iOWOYKGk4AoNw=;
        b=BmnMg6dqmhu54MVBH79zfGPe7n4L7YwS24vNJBOUj8+u3YFjC320L83YubAxajBdFC
         fC/LH2Tq0erSSJqPMRE66gQ7SRmAKkU8VrkzFoeasJBMPxJYZQl8zUBXz2d4HKxFZ54O
         orbFMFslMDerEx1QiyY8hJFa1UFOBvSACoH/xxFdU9g3OulR7W0FbTcpXuJpGAl6hk3G
         A4eKHMFLpNMAbFPZok6kvBQITEr5k6oVIECD/B2ERpvIRRohVRIoHC376QDtXBTGGwMU
         xECCs0zkf4/e45WKhkyoQFDszsTAovjH90OE7Fczjrme1z7fZO5l+0YIo91l53rXUzjT
         Mlxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qYbE8DEpqWwPaSKWPs+gr+4VM0HVT0iOWOYKGk4AoNw=;
        b=BlcrWko/nlT51yEnw14BSfc2iAaxA6GhtaHNjouvB+PfYd7gvXjNpJL/YlIQH7fccU
         4ENIk08oA8eahNDVCaxoX8VWjAfQb5YOsLq1JpK9eFR4OD6xkfaReJtP4NffCwMi4X6m
         NyNfEgpStWLEj3tRSXA+X04E9F2t9Mz9cEhI6gBejSIzDcJTOfQ7P596rSXJ5drhQlf4
         wXpfg2tKq7uOGLUsZ4u7wt4qjkjGIerhjphZD0dp0nr0+gUoY6xr0QlWGpbLoOk0TkBE
         ZFiQgBar3hhqWsLOgIRXx+YYa2nCmGL2MZt0M+3jC+u1df/7kNyBJUxI1GespLNrHvL8
         qn/w==
X-Gm-Message-State: AO0yUKXkcGEX+1Ot3gwKOUu0k/w+mNAuHbjhAZUlrQFaEDcSC/vjuNea
        +jYqhAbeABtVc/1tnTVFXCBdyVlLc1tc0w==
X-Google-Smtp-Source: AK7set9f9KkrjoM7yBjTzZuAk+TVmZSmsRDOR4Ijw2BlZhoj6jUiFpVGhwcxVpCW7N+33OYrekdWtw==
X-Received: by 2002:a05:6214:b67:b0:56e:9c11:651e with SMTP id ey7-20020a0562140b6700b0056e9c11651emr21440446qvb.27.1677099843343;
        Wed, 22 Feb 2023 13:04:03 -0800 (PST)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id dw16-20020a05620a601000b0073bad2f9380sm1516816qkb.14.2023.02.22.13.04.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Feb 2023 13:04:02 -0800 (PST)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Sean Anderson <seanga2@gmail.com>
Subject: [RFC PATCH net-next 2/7] net: sunhme: Remove residual polling code
Date:   Wed, 22 Feb 2023 16:03:50 -0500
Message-Id: <20230222210355.2741485-3-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230222210355.2741485-1-seanga2@gmail.com>
References: <20230222210355.2741485-1-seanga2@gmail.com>
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

The sunhme driver never used the hardware MII polling feature. Even the
if-def'd out happy_meal_poll_start was removed by 2002 [1]. Remove the
various places in the driver which needlessly guard against MII interrupts
which will never be enabled.

[1] https://lwn.net/2002/0411/a/2.5.8-pre3.php3

Signed-off-by: Sean Anderson <seanga2@gmail.com>
---

 drivers/net/ethernet/sun/sunhme.c | 134 ++++--------------------------
 drivers/net/ethernet/sun/sunhme.h |   6 +-
 2 files changed, 18 insertions(+), 122 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 3eeda8f3fa80..8f6a937a23d5 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -872,32 +872,6 @@ static void happy_meal_get_counters(struct happy_meal *hp, void __iomem *bregs)
 	hme_write32(hp, bregs + BMAC_LTCTR, 0);
 }
 
-/* hp->happy_lock must be held */
-static void happy_meal_poll_stop(struct happy_meal *hp, void __iomem *tregs)
-{
-	/* If polling disabled or not polling already, nothing to do. */
-	if ((hp->happy_flags & (HFLAG_POLLENABLE | HFLAG_POLL)) !=
-	   (HFLAG_POLLENABLE | HFLAG_POLL)) {
-		ASD("not polling, return\n");
-		return;
-	}
-
-	/* Shut up the MIF. */
-	ASD("were polling, mif ints off, polling off\n");
-	hme_write32(hp, tregs + TCVR_IMASK, 0xffff);
-
-	/* Turn off polling. */
-	hme_write32(hp, tregs + TCVR_CFG,
-		    hme_read32(hp, tregs + TCVR_CFG) & ~(TCV_CFG_PENABLE));
-
-	/* We are no longer polling. */
-	hp->happy_flags &= ~(HFLAG_POLL);
-
-	/* Let the bits set. */
-	udelay(200);
-	ASD("done\n");
-}
-
 /* Only Sun can take such nice parts and fuck up the programming interface
  * like this.  Good job guys...
  */
@@ -1002,57 +976,26 @@ static int happy_meal_tcvr_reset(struct happy_meal *hp, void __iomem *tregs)
 static void happy_meal_transceiver_check(struct happy_meal *hp, void __iomem *tregs)
 {
 	unsigned long tconfig = hme_read32(hp, tregs + TCVR_CFG);
+	u32 reread = hme_read32(hp, tregs + TCVR_CFG);
 
 	ASD("tcfg=%08lx\n", tconfig);
-	if (hp->happy_flags & HFLAG_POLL) {
-		/* If we are polling, we must stop to get the transceiver type. */
-		if (hp->tcvr_type == internal) {
-			if (tconfig & TCV_CFG_MDIO1) {
-				happy_meal_poll_stop(hp, tregs);
-				hp->paddr = TCV_PADDR_ETX;
-				hp->tcvr_type = external;
-				tconfig &= ~(TCV_CFG_PENABLE);
-				tconfig |= TCV_CFG_PSELECT;
-				hme_write32(hp, tregs + TCVR_CFG, tconfig);
-				ASD("poll stop, internal->external\n");
-			}
-		} else {
-			if (hp->tcvr_type == external) {
-				if (!(hme_read32(hp, tregs + TCVR_STATUS) >> 16)) {
-					happy_meal_poll_stop(hp, tregs);
-					hp->paddr = TCV_PADDR_ITX;
-					hp->tcvr_type = internal;
-					hme_write32(hp, tregs + TCVR_CFG,
-						    hme_read32(hp, tregs + TCVR_CFG) &
-						    ~(TCV_CFG_PSELECT));
-					ASD("poll stop, external->internal\n");
-				}
-			} else {
-				ASD("polling, none\n");
-			}
-		}
+	if (reread & TCV_CFG_MDIO1) {
+		hme_write32(hp, tregs + TCVR_CFG, tconfig | TCV_CFG_PSELECT);
+		hp->paddr = TCV_PADDR_ETX;
+		hp->tcvr_type = external;
+		ASD("not polling, external\n");
 	} else {
-		u32 reread = hme_read32(hp, tregs + TCVR_CFG);
-
-		/* Else we can just work off of the MDIO bits. */
-		if (reread & TCV_CFG_MDIO1) {
-			hme_write32(hp, tregs + TCVR_CFG, tconfig | TCV_CFG_PSELECT);
-			hp->paddr = TCV_PADDR_ETX;
-			hp->tcvr_type = external;
-			ASD("not polling, external\n");
+		if (reread & TCV_CFG_MDIO0) {
+			hme_write32(hp, tregs + TCVR_CFG,
+				    tconfig & ~(TCV_CFG_PSELECT));
+			hp->paddr = TCV_PADDR_ITX;
+			hp->tcvr_type = internal;
+			ASD("not polling, internal\n");
 		} else {
-			if (reread & TCV_CFG_MDIO0) {
-				hme_write32(hp, tregs + TCVR_CFG,
-					    tconfig & ~(TCV_CFG_PSELECT));
-				hp->paddr = TCV_PADDR_ITX;
-				hp->tcvr_type = internal;
-				ASD("not polling, internal\n");
-			} else {
-				netdev_err(hp->dev,
-					   "Transceiver and a coke please.");
-				hp->tcvr_type = none; /* Grrr... */
-				ASD("not polling, none\n");
-			}
+			netdev_err(hp->dev,
+				   "Transceiver and a coke please.");
+			hp->tcvr_type = none; /* Grrr... */
+			ASD("not polling, none\n");
 		}
 	}
 }
@@ -1339,10 +1282,6 @@ static int happy_meal_init(struct happy_meal *hp)
 		happy_meal_get_counters(hp, bregs);
 	}
 
-	/* Stop polling. */
-	HMD("to happy_meal_poll_stop\n");
-	happy_meal_poll_stop(hp, tregs);
-
 	/* Stop transmitter and receiver. */
 	HMD("to happy_meal_stop\n");
 	happy_meal_stop(hp, gregs);
@@ -1351,11 +1290,6 @@ static int happy_meal_init(struct happy_meal *hp)
 	HMD("to happy_meal_init_rings\n");
 	happy_meal_init_rings(hp);
 
-	/* Shut up the MIF. */
-	HMD("Disable all MIF irqs (old[%08x])\n",
-	    hme_read32(hp, tregs + TCVR_IMASK));
-	hme_write32(hp, tregs + TCVR_IMASK, 0xffff);
-
 	/* See if we can enable the MIF frame on this card to speak to the DP83840. */
 	if (hp->happy_flags & HFLAG_FENABLE) {
 		HMD("use frame old[%08x]\n",
@@ -1610,7 +1544,6 @@ static void happy_meal_set_initial_advertisement(struct happy_meal *hp)
 	void __iomem *gregs	= hp->gregs;
 
 	happy_meal_stop(hp, gregs);
-	hme_write32(hp, tregs + TCVR_IMASK, 0xffff);
 	if (hp->happy_flags & HFLAG_FENABLE)
 		hme_write32(hp, tregs + TCVR_CFG,
 			    hme_read32(hp, tregs + TCVR_CFG) & ~(TCV_CFG_BENABLE));
@@ -1767,34 +1700,6 @@ static int happy_meal_is_not_so_happy(struct happy_meal *hp, u32 status)
 	return 0;
 }
 
-/* hp->happy_lock must be held */
-static void happy_meal_mif_interrupt(struct happy_meal *hp)
-{
-	void __iomem *tregs = hp->tcvregs;
-
-	netdev_info(hp->dev, "Link status change.\n");
-	hp->sw_bmcr = happy_meal_tcvr_read(hp, tregs, MII_BMCR);
-	hp->sw_lpa = happy_meal_tcvr_read(hp, tregs, MII_LPA);
-
-	/* Use the fastest transmission protocol possible. */
-	if (hp->sw_lpa & LPA_100FULL) {
-		netdev_info(hp->dev, "Switching to 100Mbps at full duplex.\n");
-		hp->sw_bmcr |= (BMCR_FULLDPLX | BMCR_SPEED100);
-	} else if (hp->sw_lpa & LPA_100HALF) {
-		netdev_info(hp->dev, "Switching to 100MBps at half duplex.\n");
-		hp->sw_bmcr |= BMCR_SPEED100;
-	} else if (hp->sw_lpa & LPA_10FULL) {
-		netdev_info(hp->dev, "Switching to 10MBps at full duplex.\n");
-		hp->sw_bmcr |= BMCR_FULLDPLX;
-	} else {
-		netdev_info(hp->dev, "Using 10Mbps at half duplex.\n");
-	}
-	happy_meal_tcvr_write(hp, tregs, MII_BMCR, hp->sw_bmcr);
-
-	/* Finally stop polling and shut up the MIF. */
-	happy_meal_poll_stop(hp, tregs);
-}
-
 /* hp->happy_lock must be held */
 static void happy_meal_tx(struct happy_meal *hp)
 {
@@ -1978,9 +1883,6 @@ static irqreturn_t happy_meal_interrupt(int irq, void *dev_id)
 			goto out;
 	}
 
-	if (happy_status & GREG_STAT_MIFIRQ)
-		happy_meal_mif_interrupt(hp);
-
 	if (happy_status & GREG_STAT_TXALL)
 		happy_meal_tx(hp);
 
@@ -2008,7 +1910,6 @@ static irqreturn_t quattro_sbus_interrupt(int irq, void *cookie)
 		HMD("status=%08x\n", happy_status);
 
 		if (!(happy_status & (GREG_STAT_ERRORS |
-				      GREG_STAT_MIFIRQ |
 				      GREG_STAT_TXALL |
 				      GREG_STAT_RXTOHOST)))
 			continue;
@@ -2019,9 +1920,6 @@ static irqreturn_t quattro_sbus_interrupt(int irq, void *cookie)
 			if (happy_meal_is_not_so_happy(hp, happy_status))
 				goto next;
 
-		if (happy_status & GREG_STAT_MIFIRQ)
-			happy_meal_mif_interrupt(hp);
-
 		if (happy_status & GREG_STAT_TXALL)
 			happy_meal_tx(hp);
 
diff --git a/drivers/net/ethernet/sun/sunhme.h b/drivers/net/ethernet/sun/sunhme.h
index 9118c60c9426..258b4c7fe962 100644
--- a/drivers/net/ethernet/sun/sunhme.h
+++ b/drivers/net/ethernet/sun/sunhme.h
@@ -462,22 +462,20 @@ struct happy_meal {
 };
 
 /* Here are the happy flags. */
-#define HFLAG_POLL                0x00000001      /* We are doing MIF polling          */
 #define HFLAG_FENABLE             0x00000002      /* The MII frame is enabled          */
 #define HFLAG_LANCE               0x00000004      /* We are using lance-mode           */
 #define HFLAG_RXENABLE            0x00000008      /* Receiver is enabled               */
 #define HFLAG_AUTO                0x00000010      /* Using auto-negotiation, 0 = force */
 #define HFLAG_FULL                0x00000020      /* Full duplex enable                */
 #define HFLAG_MACFULL             0x00000040      /* Using full duplex in the MAC      */
-#define HFLAG_POLLENABLE          0x00000080      /* Actually try MIF polling          */
 #define HFLAG_RXCV                0x00000100      /* XXX RXCV ENABLE                   */
 #define HFLAG_INIT                0x00000200      /* Init called at least once         */
 #define HFLAG_LINKUP              0x00000400      /* 1 = Link is up                    */
 #define HFLAG_PCI                 0x00000800      /* PCI based Happy Meal              */
 #define HFLAG_QUATTRO		  0x00001000      /* On QFE/Quattro card	       */
 
-#define HFLAG_20_21  (HFLAG_POLLENABLE | HFLAG_FENABLE)
-#define HFLAG_NOT_A0 (HFLAG_POLLENABLE | HFLAG_FENABLE | HFLAG_LANCE | HFLAG_RXCV)
+#define HFLAG_20_21  HFLAG_FENABLE
+#define HFLAG_NOT_A0 (HFLAG_FENABLE | HFLAG_LANCE | HFLAG_RXCV)
 
 /* Support for QFE/Quattro cards. */
 struct quattro {
-- 
2.37.1

