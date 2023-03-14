Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2726B870E
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 01:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbjCNAha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 20:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbjCNAgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 20:36:52 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E6D82A9B;
        Mon, 13 Mar 2023 17:36:26 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id c1so1246520qtw.1;
        Mon, 13 Mar 2023 17:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678754185;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U8Npc50X5KuAY+Y1yr956zaaESW6+08Bvn+jbPGD8L8=;
        b=R2VT8Y4Hb0BS8ErGj77BH8D/VQnG6puKEFLsUTfoQiOc8RTGrQ6yvUxO4zVixzh4UK
         SGSkLWGKbjK6nfmOFfv8zK2hJEf5iZ9Ahm+MdIgP2yW1W7JamJVBIGrWvKpSJLDOqX5/
         xy0dMhtyuzQ9b8CoqYwEbiBx91l+TsX9mD33+MtcoWdh0E2nyvAovydpHQVn7I/+h6v6
         ojePl6HBZ/YIf/c2OwPH/S1MMETgUFV56xTEkjZCSGB6tIaallsAt2NhRq12dPZHU9rH
         E24l2vOynGHSSVZ8vlpYOjnMiQ3ckTYwB4Ah3kRtawTyOrkDbXn6M0rqeMkruRFCEJHE
         97/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678754185;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U8Npc50X5KuAY+Y1yr956zaaESW6+08Bvn+jbPGD8L8=;
        b=NDAMCKjBfMKn96G/8pjRsdodXWwse8WcTdVD6VcRy+Y8qn3c6d3Q37d+9u15kwJvlZ
         lzvzNfImaRFSIowmpR6ZDzoCiqD9NC8x8X3o7ljZuUh5kipVrf2XVqUda1dewdNzvMaD
         Rs7GFRHT/+BHXnzcw/t5tiJUlY4hluNCWae9pIWEZHG/ZdldzchzSHI2M43SDXf0xHmT
         XdFR2z8LKdYAl1hQ08miLxMDmi1DyTdAkm7LGDQ2pZuzbH1wb5VF5cBhkTWbYCeYoNhG
         r3vAvbM0WxCL64C1QIPg0icUvf7oBVIkFTHjeOZ2Xt6gKpIbBUYVJVZ+2zXLomgz9GRJ
         WuUw==
X-Gm-Message-State: AO0yUKWTMxeCTZS5Vq9m61m6HpcTbizfRW6ohOfvfOOVuqofiZqYYtET
        4CSKLi+BQ2XV0z7Ddm7ZnKI=
X-Google-Smtp-Source: AK7set/J0zBHnPa2g5cVVHqNZyq9yy9TE9AmZ3oRUP6Z9t7XYro/51rWg3GGM5UxUcqtYfcdN9jR9Q==
X-Received: by 2002:ac8:57cd:0:b0:3bf:be20:544c with SMTP id w13-20020ac857cd000000b003bfbe20544cmr60885235qta.39.1678754185365;
        Mon, 13 Mar 2023 17:36:25 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id x9-20020ac87a89000000b003a530a32f67sm772247qtr.65.2023.03.13.17.36.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Mar 2023 17:36:25 -0700 (PDT)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Simon Horman <simon.horman@corigine.com>,
        linux-kernel@vger.kernel.org, Sean Anderson <seanga2@gmail.com>
Subject: [PATCH net-next v3 9/9] net: sunhme: Consolidate common probe tasks
Date:   Mon, 13 Mar 2023 20:36:13 -0400
Message-Id: <20230314003613.3874089-10-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230314003613.3874089-1-seanga2@gmail.com>
References: <20230314003613.3874089-1-seanga2@gmail.com>
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

Most of the second half of the PCI/SBUS probe functions are the same.
Consolidate them into a common function.

Signed-off-by: Sean Anderson <seanga2@gmail.com>
---

(no changes since v1)

 drivers/net/ethernet/sun/sunhme.c | 183 ++++++++++++------------------
 1 file changed, 71 insertions(+), 112 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index a59b998062d9..a384b162c46d 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2430,6 +2430,71 @@ static void happy_meal_addr_init(struct happy_meal *hp,
 	}
 }
 
+static int happy_meal_common_probe(struct happy_meal *hp,
+				   struct device_node *dp, int minor_rev)
+{
+	struct net_device *dev = hp->dev;
+	int err;
+
+#ifdef CONFIG_SPARC
+	hp->hm_revision = of_getintprop_default(dp, "hm-rev", 0xff);
+	if (hp->hm_revision == 0xff)
+		hp->hm_revision = 0xc0 | minor_rev;
+#else
+	/* works with this on non-sparc hosts */
+	hp->hm_revision = 0x20;
+#endif
+
+	/* Now enable the feature flags we can. */
+	if (hp->hm_revision == 0x20 || hp->hm_revision == 0x21)
+		hp->happy_flags |= HFLAG_20_21;
+	else if (hp->hm_revision != 0xa0)
+		hp->happy_flags |= HFLAG_NOT_A0;
+
+	hp->happy_block = dmam_alloc_coherent(hp->dma_dev, PAGE_SIZE,
+					      &hp->hblock_dvma, GFP_KERNEL);
+	if (!hp->happy_block)
+		return -ENOMEM;
+
+	/* Force check of the link first time we are brought up. */
+	hp->linkcheck = 0;
+
+	/* Force timer state to 'asleep' with count of zero. */
+	hp->timer_state = asleep;
+	hp->timer_ticks = 0;
+
+	timer_setup(&hp->happy_timer, happy_meal_timer, 0);
+
+	dev->netdev_ops = &hme_netdev_ops;
+	dev->watchdog_timeo = 5 * HZ;
+	dev->ethtool_ops = &hme_ethtool_ops;
+
+	/* Happy Meal can do it all... */
+	dev->hw_features = NETIF_F_SG | NETIF_F_HW_CSUM;
+	dev->features |= dev->hw_features | NETIF_F_RXCSUM;
+
+#if defined(CONFIG_SBUS) && defined(CONFIG_PCI)
+	/* Hook up SBUS register/descriptor accessors. */
+	hp->read_desc32 = sbus_hme_read_desc32;
+	hp->write_txd = sbus_hme_write_txd;
+	hp->write_rxd = sbus_hme_write_rxd;
+	hp->read32 = sbus_hme_read32;
+	hp->write32 = sbus_hme_write32;
+#endif
+
+	/* Grrr, Happy Meal comes up by default not advertising
+	 * full duplex 100baseT capabilities, fix this.
+	 */
+	spin_lock_irq(&hp->happy_lock);
+	happy_meal_set_initial_advertisement(hp);
+	spin_unlock_irq(&hp->happy_lock);
+
+	err = devm_register_netdev(hp->dma_dev, dev);
+	if (err)
+		dev_err(hp->dma_dev, "Cannot register net device, aborting.\n");
+	return err;
+}
+
 #ifdef CONFIG_SBUS
 static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
 {
@@ -2511,70 +2576,18 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
 		goto err_out_clear_quattro;
 	}
 
-	hp->hm_revision = of_getintprop_default(dp, "hm-rev", 0xff);
-	if (hp->hm_revision == 0xff)
-		hp->hm_revision = 0xa0;
-
-	/* Now enable the feature flags we can. */
-	if (hp->hm_revision == 0x20 || hp->hm_revision == 0x21)
-		hp->happy_flags = HFLAG_20_21;
-	else if (hp->hm_revision != 0xa0)
-		hp->happy_flags = HFLAG_NOT_A0;
-
 	if (qp != NULL)
 		hp->happy_flags |= HFLAG_QUATTRO;
 
+	hp->irq = op->archdata.irqs[0];
+
 	/* Get the supported DVMA burst sizes from our Happy SBUS. */
 	hp->happy_bursts = of_getintprop_default(sbus_dp,
 						 "burst-sizes", 0x00);
 
-	hp->happy_block = dmam_alloc_coherent(&op->dev, PAGE_SIZE,
-					      &hp->hblock_dvma, GFP_KERNEL);
-	if (!hp->happy_block) {
-		err = -ENOMEM;
+	err = happy_meal_common_probe(hp, dp, 0);
+	if (err)
 		goto err_out_clear_quattro;
-	}
-
-	/* Force check of the link first time we are brought up. */
-	hp->linkcheck = 0;
-
-	/* Force timer state to 'asleep' with count of zero. */
-	hp->timer_state = asleep;
-	hp->timer_ticks = 0;
-
-	timer_setup(&hp->happy_timer, happy_meal_timer, 0);
-
-	dev->netdev_ops = &hme_netdev_ops;
-	dev->watchdog_timeo = 5*HZ;
-	dev->ethtool_ops = &hme_ethtool_ops;
-
-	/* Happy Meal can do it all... */
-	dev->hw_features = NETIF_F_SG | NETIF_F_HW_CSUM;
-	dev->features |= dev->hw_features | NETIF_F_RXCSUM;
-
-	hp->irq = op->archdata.irqs[0];
-
-#if defined(CONFIG_SBUS) && defined(CONFIG_PCI)
-	/* Hook up SBUS register/descriptor accessors. */
-	hp->read_desc32 = sbus_hme_read_desc32;
-	hp->write_txd = sbus_hme_write_txd;
-	hp->write_rxd = sbus_hme_write_rxd;
-	hp->read32 = sbus_hme_read32;
-	hp->write32 = sbus_hme_write32;
-#endif
-
-	/* Grrr, Happy Meal comes up by default not advertising
-	 * full duplex 100baseT capabilities, fix this.
-	 */
-	spin_lock_irq(&hp->happy_lock);
-	happy_meal_set_initial_advertisement(hp);
-	spin_unlock_irq(&hp->happy_lock);
-
-	err = devm_register_netdev(&op->dev, dev);
-	if (err) {
-		dev_err(&op->dev, "Cannot register net device, aborting.\n");
-		goto err_out_clear_quattro;
-	}
 
 	platform_set_drvdata(op, hp);
 
@@ -2689,21 +2702,6 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	hp->bigmacregs = (hpreg_base + 0x6000UL);
 	hp->tcvregs    = (hpreg_base + 0x7000UL);
 
-#ifdef CONFIG_SPARC
-	hp->hm_revision = of_getintprop_default(dp, "hm-rev", 0xff);
-	if (hp->hm_revision == 0xff)
-		hp->hm_revision = 0xc0 | (pdev->revision & 0x0f);
-#else
-	/* works with this on non-sparc hosts */
-	hp->hm_revision = 0x20;
-#endif
-
-	/* Now enable the feature flags we can. */
-	if (hp->hm_revision == 0x20 || hp->hm_revision == 0x21)
-		hp->happy_flags = HFLAG_20_21;
-	else if (hp->hm_revision != 0xa0 && hp->hm_revision != 0xc0)
-		hp->happy_flags = HFLAG_NOT_A0;
-
 	if (qp != NULL)
 		hp->happy_flags |= HFLAG_QUATTRO;
 
@@ -2714,50 +2712,11 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	/* Assume PCI happy meals can handle all burst sizes. */
 	hp->happy_bursts = DMA_BURSTBITS;
 #endif
-
-	hp->happy_block = dmam_alloc_coherent(&pdev->dev, PAGE_SIZE,
-					      &hp->hblock_dvma, GFP_KERNEL);
-	if (!hp->happy_block) {
-		err = -ENOMEM;
-		goto err_out_clear_quattro;
-	}
-
-	hp->linkcheck = 0;
-	hp->timer_state = asleep;
-	hp->timer_ticks = 0;
-
-	timer_setup(&hp->happy_timer, happy_meal_timer, 0);
-
 	hp->irq = pdev->irq;
-	dev->netdev_ops = &hme_netdev_ops;
-	dev->watchdog_timeo = 5*HZ;
-	dev->ethtool_ops = &hme_ethtool_ops;
 
-	/* Happy Meal can do it all... */
-	dev->hw_features = NETIF_F_SG | NETIF_F_HW_CSUM;
-	dev->features |= dev->hw_features | NETIF_F_RXCSUM;
-
-#if defined(CONFIG_SBUS) && defined(CONFIG_PCI)
-	/* Hook up PCI register/descriptor accessors. */
-	hp->read_desc32 = pci_hme_read_desc32;
-	hp->write_txd = pci_hme_write_txd;
-	hp->write_rxd = pci_hme_write_rxd;
-	hp->read32 = pci_hme_read32;
-	hp->write32 = pci_hme_write32;
-#endif
-
-	/* Grrr, Happy Meal comes up by default not advertising
-	 * full duplex 100baseT capabilities, fix this.
-	 */
-	spin_lock_irq(&hp->happy_lock);
-	happy_meal_set_initial_advertisement(hp);
-	spin_unlock_irq(&hp->happy_lock);
-
-	err = devm_register_netdev(&pdev->dev, dev);
-	if (err) {
-		dev_err(&pdev->dev, "Cannot register net device, aborting.\n");
+	err = happy_meal_common_probe(hp, dp, pdev->revision & 0x0f);
+	if (err)
 		goto err_out_clear_quattro;
-	}
 
 	pci_set_drvdata(pdev, hp);
 
-- 
2.37.1

