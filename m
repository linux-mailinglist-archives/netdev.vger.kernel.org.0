Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F15E56B5FA4
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 19:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbjCKST3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 13:19:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbjCKSTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 13:19:14 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 266F456166;
        Sat, 11 Mar 2023 10:19:12 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id r16so9271852qtx.9;
        Sat, 11 Mar 2023 10:19:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678558751;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qBS4YQTCBlLtFo3hOvq6pEbUYT0HI5CpCo0cMMsulC0=;
        b=AwqOQs5AwzwrE2WM9AYHERUNWqN2bL2NaYY6QbLcp65qbClIA6tXcQI3+fjecH7L9K
         5Hj4t5hNa4sHiGd2e0gCTY18COiMhktHaWyQQeT0PQ1nR4N+32lvcwbKtBNbmLHq9+uh
         CxMoMKZgMoC5XBdfSx0pA30fS6drDT6fEx0x3kaxQsSppu4sN29omJa0eAXFoblJZcar
         k+x8QtrON4bDEseUQn55712WsO4OZDqEg9vmmXTMu2NpxV8o9ocE06VsbWdQnwzRDqrl
         AIBe8NaEFgJnMl9xG5qVtByPBVAM7gjIVzuWWrIw8Pp7Ljy0lt23YBn04Fylo7ABsqRL
         GPjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678558751;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qBS4YQTCBlLtFo3hOvq6pEbUYT0HI5CpCo0cMMsulC0=;
        b=HUaemzGW4jU5C5G1RxRuZqng05Eemgoxl5LYGVDyTCr3M4nXcwDjYYQYDmn5/NBbjq
         ksCL/gE8bJoiv48pOuKqPv5vxRrTNzzJuXZin+ytHewdGG5MUmjN3ZZiOacBE4cTIyNm
         gBFtctz53oxe7Idz2ZYmOqJDDns4ytUEAF0DG4jdWwWAD1qbNdP+cusdIAWpAQQGfh5n
         BBgYq+/JW/txYJyGGCHhFOQyBgoWknpDmi2lXM0ligqMYK30i+Epu+sIo/dIG4Ohe+EE
         IRosKB6PK1KLXygKktSLANYDbGSZwDbk7upN0F1sgk5E8qf6k8GQkJf8z8Ig42JROzJb
         +zzQ==
X-Gm-Message-State: AO0yUKU2RErrhtXrOb0IhGfd23X1C+VItbRIak3+oIQjysAK6ufVQVBO
        FpuPSpL2sRo0AwLVdOHDfmg=
X-Google-Smtp-Source: AK7set8ZBJ+9RruMPa20EXWloETfIStnngpl8cGTmqmkNwpV3Jt8GR/v3S9dxFmofrVphTbILphz/Q==
X-Received: by 2002:a05:622a:8:b0:3b6:36e1:ed42 with SMTP id x8-20020a05622a000800b003b636e1ed42mr47428438qtw.9.1678558751204;
        Sat, 11 Mar 2023 10:19:11 -0800 (PST)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id s10-20020ac8758a000000b003bfeb30c24dsm2212274qtq.39.2023.03.11.10.19.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Mar 2023 10:19:10 -0800 (PST)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>,
        Sean Anderson <seanga2@gmail.com>
Subject: [PATCH net-next v2 3/9] net: sunhme: Unify IRQ requesting
Date:   Sat, 11 Mar 2023 13:18:59 -0500
Message-Id: <20230311181905.3593904-4-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230311181905.3593904-1-seanga2@gmail.com>
References: <20230311181905.3593904-1-seanga2@gmail.com>
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

Instead of registering one interrupt handler for all four SBUS Quattro
HMEs, let each HME register its own handler. To make this work, we don't
handle the IRQ if none of the status bits are set. This reduces the
complexity of the driver, and makes it easier to ensure things happen
before/after enabling IRQs.

I'm not really sure why we request IRQs in two different places (and leave
them running after removing the driver!). A lot of things in this driver
seem to just be crusty, and not necessarily intentional. I'm assuming
that's the case here as well.

This really needs to be tested by someone with an SBUS Quattro card.

Signed-off-by: Sean Anderson <seanga2@gmail.com>
---

(no changes since v1)

 drivers/net/ethernet/sun/sunhme.c | 131 +++---------------------------
 1 file changed, 10 insertions(+), 121 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index bb93fd69f4a9..cf13123b6ff6 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -1870,6 +1870,8 @@ static irqreturn_t happy_meal_interrupt(int irq, void *dev_id)
 	u32 happy_status       = hme_read32(hp, hp->gregs + GREG_STAT);
 
 	HMD("status=%08x\n", happy_status);
+	if (!happy_status)
+		return IRQ_NONE;
 
 	spin_lock(&hp->happy_lock);
 
@@ -1891,62 +1893,16 @@ static irqreturn_t happy_meal_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-#ifdef CONFIG_SBUS
-static irqreturn_t quattro_sbus_interrupt(int irq, void *cookie)
-{
-	struct quattro *qp = (struct quattro *) cookie;
-	int i;
-
-	for (i = 0; i < 4; i++) {
-		struct net_device *dev = qp->happy_meals[i];
-		struct happy_meal *hp  = netdev_priv(dev);
-		u32 happy_status       = hme_read32(hp, hp->gregs + GREG_STAT);
-
-		HMD("status=%08x\n", happy_status);
-
-		if (!(happy_status & (GREG_STAT_ERRORS |
-				      GREG_STAT_TXALL |
-				      GREG_STAT_RXTOHOST)))
-			continue;
-
-		spin_lock(&hp->happy_lock);
-
-		if (happy_status & GREG_STAT_ERRORS)
-			if (happy_meal_is_not_so_happy(hp, happy_status))
-				goto next;
-
-		if (happy_status & GREG_STAT_TXALL)
-			happy_meal_tx(hp);
-
-		if (happy_status & GREG_STAT_RXTOHOST)
-			happy_meal_rx(hp, dev);
-
-	next:
-		spin_unlock(&hp->happy_lock);
-	}
-	HMD("done\n");
-
-	return IRQ_HANDLED;
-}
-#endif
-
 static int happy_meal_open(struct net_device *dev)
 {
 	struct happy_meal *hp = netdev_priv(dev);
 	int res;
 
-	/* On SBUS Quattro QFE cards, all hme interrupts are concentrated
-	 * into a single source which we register handling at probe time.
-	 */
-	if ((hp->happy_flags & (HFLAG_QUATTRO|HFLAG_PCI)) != HFLAG_QUATTRO) {
-		res = request_irq(hp->irq, happy_meal_interrupt, IRQF_SHARED,
-				  dev->name, dev);
-		if (res) {
-			HMD("EAGAIN\n");
-			netdev_err(dev, "Can't order irq %d to go.\n", hp->irq);
-
-			return -EAGAIN;
-		}
+	res = request_irq(hp->irq, happy_meal_interrupt, IRQF_SHARED,
+			  dev->name, dev);
+	if (res) {
+		netdev_err(dev, "Can't order irq %d to go.\n", hp->irq);
+		return res;
 	}
 
 	HMD("to happy_meal_init\n");
@@ -1955,7 +1911,7 @@ static int happy_meal_open(struct net_device *dev)
 	res = happy_meal_init(hp);
 	spin_unlock_irq(&hp->happy_lock);
 
-	if (res && ((hp->happy_flags & (HFLAG_QUATTRO|HFLAG_PCI)) != HFLAG_QUATTRO))
+	if (res)
 		free_irq(hp->irq, dev);
 	return res;
 }
@@ -1973,12 +1929,7 @@ static int happy_meal_close(struct net_device *dev)
 
 	spin_unlock_irq(&hp->happy_lock);
 
-	/* On Quattro QFE cards, all hme interrupts are concentrated
-	 * into a single source which we register handling at probe
-	 * time and never unregister.
-	 */
-	if ((hp->happy_flags & (HFLAG_QUATTRO|HFLAG_PCI)) != HFLAG_QUATTRO)
-		free_irq(hp->irq, dev);
+	free_irq(hp->irq, dev);
 
 	return 0;
 }
@@ -2311,59 +2262,6 @@ static struct quattro *quattro_sbus_find(struct platform_device *child)
 	platform_set_drvdata(op, qp);
 	return qp;
 }
-
-/* After all quattro cards have been probed, we call these functions
- * to register the IRQ handlers for the cards that have been
- * successfully probed and skip the cards that failed to initialize
- */
-static int __init quattro_sbus_register_irqs(void)
-{
-	struct quattro *qp;
-
-	for (qp = qfe_sbus_list; qp != NULL; qp = qp->next) {
-		struct platform_device *op = qp->quattro_dev;
-		int err, qfe_slot, skip = 0;
-
-		for (qfe_slot = 0; qfe_slot < 4; qfe_slot++) {
-			if (!qp->happy_meals[qfe_slot])
-				skip = 1;
-		}
-		if (skip)
-			continue;
-
-		err = request_irq(op->archdata.irqs[0],
-				  quattro_sbus_interrupt,
-				  IRQF_SHARED, "Quattro",
-				  qp);
-		if (err != 0) {
-			dev_err(&op->dev,
-				"Quattro HME: IRQ registration error %d.\n",
-				err);
-			return err;
-		}
-	}
-
-	return 0;
-}
-
-static void quattro_sbus_free_irqs(void)
-{
-	struct quattro *qp;
-
-	for (qp = qfe_sbus_list; qp != NULL; qp = qp->next) {
-		struct platform_device *op = qp->quattro_dev;
-		int qfe_slot, skip = 0;
-
-		for (qfe_slot = 0; qfe_slot < 4; qfe_slot++) {
-			if (!qp->happy_meals[qfe_slot])
-				skip = 1;
-		}
-		if (skip)
-			continue;
-
-		free_irq(op->archdata.irqs[0], qp);
-	}
-}
 #endif /* CONFIG_SBUS */
 
 #ifdef CONFIG_PCI
@@ -3006,8 +2904,6 @@ static int hme_sbus_remove(struct platform_device *op)
 
 	unregister_netdev(net_dev);
 
-	/* XXX qfe parent interrupt... */
-
 	of_iounmap(&op->resource[0], hp->gregs, GREG_REG_SIZE);
 	of_iounmap(&op->resource[1], hp->etxregs, ETX_REG_SIZE);
 	of_iounmap(&op->resource[2], hp->erxregs, ERX_REG_SIZE);
@@ -3051,19 +2947,12 @@ static struct platform_driver hme_sbus_driver = {
 
 static int __init happy_meal_sbus_init(void)
 {
-	int err;
-
-	err = platform_driver_register(&hme_sbus_driver);
-	if (!err)
-		err = quattro_sbus_register_irqs();
-
-	return err;
+	return platform_driver_register(&hme_sbus_driver);
 }
 
 static void happy_meal_sbus_exit(void)
 {
 	platform_driver_unregister(&hme_sbus_driver);
-	quattro_sbus_free_irqs();
 
 	while (qfe_sbus_list) {
 		struct quattro *qfe = qfe_sbus_list;
-- 
2.37.1

