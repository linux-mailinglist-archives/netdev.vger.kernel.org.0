Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2206D6C83BD
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 18:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbjCXRwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 13:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231687AbjCXRwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 13:52:02 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B771A942;
        Fri, 24 Mar 2023 10:51:43 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id g19so2177938qts.9;
        Fri, 24 Mar 2023 10:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679680302;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RUPIpsZjxKo1VufU8w58+RDz1sXH3grk0wMm+nJeAoE=;
        b=VZi/GPJvrFgaOaLTTnyuz85TjM+RyDUnaZ90AV3cZarYgxTfe9E+TO17Kk6BGzDGtQ
         BoI7fWpxUxFKsSAHzNMlnA76iJBLPwYgYS9h2U5xNZdw9a2ZMl5nzp9B/b/cq++iA04x
         mmkBpHLDDN7f+B33GjG9Btyh1/sUYlXuEPR/cxMTDiJ+72jIvuOgAPiWw+cIZvRC2I60
         KjSqdW32by7oflh1B2klQHDjfIuHMmQZMoWtvq9FW1YQgsyZwGRlQgiYjlXojFEUpjbK
         t76R8uiqAxj03ohVc3z/oENRrQvPkyETJlioPGFhlXjtNMoAS9h3HUNnPdy3aVcm189d
         GsEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679680302;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RUPIpsZjxKo1VufU8w58+RDz1sXH3grk0wMm+nJeAoE=;
        b=QfKMcXnBHIpQcEY6QPzt4aGogEjWW2nRc5lOgueCGTdRekX5diSGBYjyf501lZiBtc
         Mku48Dfva74v9RgcXHMTI5YZy+c1B8x+WBZVncudFtleku9JmhBjxL6/K7c+AOQ7Z+gp
         y0JNxJ10Q7qsNc6pOxxwS7HuYguytunJh6BgsBfNo+jjUL8YBE97OQuRp0+Xw1oZufNL
         XhKwOUMCDpADkv4WIiUDiVc5S3gZ0lfk4AiylJOgZKUiUcz5UlpRPj3Cc18Dy3I1+DpI
         bey+Ch4KNyMfJOEWi3WR+PgaYvDM8PJ+cYyP1zYxW63NRrp2pfd5RPjaSAgU9V5rV5a0
         r3cw==
X-Gm-Message-State: AO0yUKWqmAeF9qbwqq3wfa7MJZ8zBmVHSA8Ojlx/LQFdEErsmAJddI/U
        rWAzfjf3nTuD6KZ9YPj0d2w=
X-Google-Smtp-Source: AK7set8pi//swGrHRCdgO207gkQQCdQqTi4zkOvAKI2LfqN6BBcN9Cq0NPpjVL6F2NSLxtveFc9UCw==
X-Received: by 2002:a05:622a:1a01:b0:3d8:8d4b:c7cc with SMTP id f1-20020a05622a1a0100b003d88d4bc7ccmr6563074qtb.46.1679680301846;
        Fri, 24 Mar 2023 10:51:41 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id t21-20020ac87615000000b003e0945575dasm8875232qtq.1.2023.03.24.10.51.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 10:51:41 -0700 (PDT)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Simon Horman <simon.horman@corigine.com>,
        linux-kernel@vger.kernel.org, Sean Anderson <seanga2@gmail.com>
Subject: [PATCH net-next v4 03/10] net: sunhme: Remove residual polling code
Date:   Fri, 24 Mar 2023 13:51:29 -0400
Message-Id: <20230324175136.321588-4-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230324175136.321588-1-seanga2@gmail.com>
References: <20230324175136.321588-1-seanga2@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
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
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---

(no changes since v1)

 drivers/net/ethernet/sun/sunhme.c | 134 ++++--------------------------
 drivers/net/ethernet/sun/sunhme.h |   6 +-
 2 files changed, 18 insertions(+), 122 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index e52f2d9305bc..b02cb0b493ae 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -985,32 +985,6 @@ static void happy_meal_get_counters(struct happy_meal *hp, void __iomem *bregs)
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
@@ -1115,57 +1089,26 @@ static int happy_meal_tcvr_reset(struct happy_meal *hp, void __iomem *tregs)
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
@@ -1334,10 +1277,6 @@ static int happy_meal_init(struct happy_meal *hp)
 		happy_meal_get_counters(hp, bregs);
 	}
 
-	/* Stop polling. */
-	HMD("to happy_meal_poll_stop\n");
-	happy_meal_poll_stop(hp, tregs);
-
 	/* Stop transmitter and receiver. */
 	HMD("to happy_meal_stop\n");
 	happy_meal_stop(hp, gregs);
@@ -1346,11 +1285,6 @@ static int happy_meal_init(struct happy_meal *hp)
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
@@ -1605,7 +1539,6 @@ static void happy_meal_set_initial_advertisement(struct happy_meal *hp)
 	void __iomem *gregs	= hp->gregs;
 
 	happy_meal_stop(hp, gregs);
-	hme_write32(hp, tregs + TCVR_IMASK, 0xffff);
 	if (hp->happy_flags & HFLAG_FENABLE)
 		hme_write32(hp, tregs + TCVR_CFG,
 			    hme_read32(hp, tregs + TCVR_CFG) & ~(TCV_CFG_BENABLE));
@@ -1762,34 +1695,6 @@ static int happy_meal_is_not_so_happy(struct happy_meal *hp, u32 status)
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
@@ -1973,9 +1878,6 @@ static irqreturn_t happy_meal_interrupt(int irq, void *dev_id)
 			goto out;
 	}
 
-	if (happy_status & GREG_STAT_MIFIRQ)
-		happy_meal_mif_interrupt(hp);
-
 	if (happy_status & GREG_STAT_TXALL)
 		happy_meal_tx(hp);
 
@@ -2003,7 +1905,6 @@ static irqreturn_t quattro_sbus_interrupt(int irq, void *cookie)
 		HMD("status=%08x\n", happy_status);
 
 		if (!(happy_status & (GREG_STAT_ERRORS |
-				      GREG_STAT_MIFIRQ |
 				      GREG_STAT_TXALL |
 				      GREG_STAT_RXTOHOST)))
 			continue;
@@ -2014,9 +1915,6 @@ static irqreturn_t quattro_sbus_interrupt(int irq, void *cookie)
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

