Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCDE6C83C2
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 18:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbjCXRwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 13:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231770AbjCXRwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 13:52:03 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56581FFC;
        Fri, 24 Mar 2023 10:51:43 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id qh28so2119507qvb.7;
        Fri, 24 Mar 2023 10:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679680303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NgJKHg78MHdqRNvWKyauhjjkOs7bo5j6sd6MIgpdJbg=;
        b=j93zMY7JyTwpNTMa/ssPwVL8D6fBYRUkGOQ5G+AAgswXjTKSp6r5XetzePkwX++TVV
         XUtplS3u9N72GXet6fdc9u0cTAWahrN535wq15nyYZl0l9pnnL05gHpLzi2D+/RTiikc
         aTeeS4H5Lv1AmY+rBSHZzBIz8zvfIyXHeMGd83bFgUR/c5uUtYi0ixv6HD2gxF142rFR
         fF3e/4v2Wx4La4/+kP9wzpu9IDvqIVGKsbknE5wQ66/4NixIyHWAeby9MKRhuHj9MYBb
         jprGEkUmM35VoicYguOigKr/SzLLqw72DOdZUiRRLwcYoUw7irY+qZYMInlj1h04aVMg
         Urxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679680303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NgJKHg78MHdqRNvWKyauhjjkOs7bo5j6sd6MIgpdJbg=;
        b=t1K1MrXRvuDZQ4U0AnCjWui4QstLAGYKvWDt1MBLDqYhdtY5MD5XmggTSaISyXerY5
         ZTtYrqcSXzLN0waZFzmg5CMkZ/tkajSLX94k4fhNkbs8aD/1jK6g2ORq8ALJQ2lRwTeF
         Cfy/O/6VKs5fS5KtujVRmrJmzn1EfGX60stJn/UmdA3YKksm34VazIW/YySW+LVOb4LM
         grgJhHHAyTHF9aS3XZ59R5TIWjgmT7Bbjr7/5mGqzTFvoQMsiqu3ztfkwJ8Ln51x3lK8
         NsVtPkMwSt30/0ZvLNbwi36t+QbKyJqbAxodXQpLojqaWDhjQUylG2vX21fblLLzV13y
         Sjdg==
X-Gm-Message-State: AO0yUKVKnwgJ58rTlpGTzeIkg3G3oUoYT8nD56BVp8ipZNHJ8WS+uzcc
        bzzgs0UD2/Cdi0O1HDboH+Y=
X-Google-Smtp-Source: AK7set8xCr+JdZMaQQkXRZSUFJySH0nslnEhbMJOEbO83qNlX8yYuIPbqN9KFB7eeozGy5ouLN3WcQ==
X-Received: by 2002:a05:6214:501e:b0:584:8c13:3041 with SMTP id jo30-20020a056214501e00b005848c133041mr17371040qvb.24.1679680302874;
        Fri, 24 Mar 2023 10:51:42 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id mu10-20020a056214328a00b005dd8b93459esm844243qvb.54.2023.03.24.10.51.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 10:51:42 -0700 (PDT)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Simon Horman <simon.horman@corigine.com>,
        linux-kernel@vger.kernel.org, Sean Anderson <seanga2@gmail.com>
Subject: [PATCH net-next v4 04/10] net: sunhme: Unify IRQ requesting
Date:   Fri, 24 Mar 2023 13:51:30 -0400
Message-Id: <20230324175136.321588-5-seanga2@gmail.com>
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
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---

(no changes since v1)

 drivers/net/ethernet/sun/sunhme.c | 131 +++---------------------------
 1 file changed, 10 insertions(+), 121 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index b02cb0b493ae..4efcf60644aa 100644
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
@@ -3005,8 +2903,6 @@ static int hme_sbus_remove(struct platform_device *op)
 
 	unregister_netdev(net_dev);
 
-	/* XXX qfe parent interrupt... */
-
 	of_iounmap(&op->resource[0], hp->gregs, GREG_REG_SIZE);
 	of_iounmap(&op->resource[1], hp->etxregs, ETX_REG_SIZE);
 	of_iounmap(&op->resource[2], hp->erxregs, ERX_REG_SIZE);
@@ -3050,19 +2946,12 @@ static struct platform_driver hme_sbus_driver = {
 
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

