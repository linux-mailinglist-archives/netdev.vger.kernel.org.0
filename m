Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB036C83CD
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 18:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232197AbjCXRwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 13:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231805AbjCXRw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 13:52:29 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D60811A4BA;
        Fri, 24 Mar 2023 10:51:50 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id x1so2184734qtr.7;
        Fri, 24 Mar 2023 10:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679680310;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=72anf46FrFqHRmqQ5ODHzlxaMT8Ohp7RrTHcY1Db4ZM=;
        b=aD4Z41ehpWeqUGFPdDErmjO+iJy5K0BHox1wn+flh9uCdXRiZ1ejXiD3o7XY6Sa65G
         nkdlyTOTve5mbCyY0uw2KCEwaDqfCMH0+HuQGkrYtQ1Nlynwt0jRBX3f2i+PLYj+W5P3
         vqGV61tjia2/8pA5rnC3be+O3MRz9Qy8nR3xTyq5W+FKAZJbf08ARB8Q/uqC3PQhIdMm
         Vxm0Wi2rbEV2zklRMFXb7n23GL1YpPehFh2Fq7FVUzV3v6tpHL9cCCGkJr384+fu7tKy
         03e9VCNE/GEi6Foy1AUPT4REJZw7F2MbbLoIMA+fVWBb9fOwANRAXyfwt6jhVNOdNFh4
         mYrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679680310;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=72anf46FrFqHRmqQ5ODHzlxaMT8Ohp7RrTHcY1Db4ZM=;
        b=T8cgGFefeU0AtARn9CKXnPGD70xXuOnYGhhz11nUqxadFdZy8eui1txvDcaBmbVJ8y
         +jU84/b3uRpF0NBOkHKTJRYcH7LR+frWRw1OF+9lhYQD7JmQuxmBANhvOKYaXAfDdUEt
         gBQdjSjMYQHrZ2VrOuib0IkNeB2FyP0cWQR6uzKvjQBc5urN+zNE1AsKqiilSOXTYSM+
         wfw1OGSgVfg4bkVvjDRKqDCaqBBf7SD//6C2D+tXHRS/5dZoH4dki72LHwT9qApGcbfc
         Ug0svhx/ZKej4q9G5XfEtBfwD+N7g/KI1cylmeplDfkteuSY0madEyqI9qWo3FGzVo8z
         5Y/Q==
X-Gm-Message-State: AO0yUKWYFuHYURB3vJ480XXDic/BcUdLU1N3J3r5Ny/82EFMKrrEjNT7
        m9/UQjLSxU7wh1C2XsR377vcSeUBnbNF0g==
X-Google-Smtp-Source: AK7set+UwKknWozIoGS9iR8T1u1IxXLj49ZGqvWsNWCYxcYqjXNMswx4XJ3FwyRUDaUtp1Uy7nBO4g==
X-Received: by 2002:a05:622a:1a87:b0:3e3:824c:f9b7 with SMTP id s7-20020a05622a1a8700b003e3824cf9b7mr7351531qtc.49.1679680309818;
        Fri, 24 Mar 2023 10:51:49 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id r16-20020a05620a299000b0074305413c73sm14542048qkp.95.2023.03.24.10.51.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 10:51:49 -0700 (PDT)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Simon Horman <simon.horman@corigine.com>,
        linux-kernel@vger.kernel.org, Sean Anderson <seanga2@gmail.com>
Subject: [PATCH net-next v4 10/10] net: sunhme: Consolidate common probe tasks
Date:   Fri, 24 Mar 2023 13:51:36 -0400
Message-Id: <20230324175136.321588-11-seanga2@gmail.com>
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

Most of the second half of the PCI/SBUS probe functions are the same.
Consolidate them into a common function.

Signed-off-by: Sean Anderson <seanga2@gmail.com>
---

Changes in v4:
- Use correct SBUS/PCI accessors
- Rework hme_version to set the default in pci/sbus_probe and override it (if
  necessary) in common_probe

 drivers/net/ethernet/sun/sunhme.c | 157 ++++++++++++------------------
 1 file changed, 64 insertions(+), 93 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index bd1925f575c4..ec85aef35bf9 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2430,6 +2430,58 @@ static void happy_meal_addr_init(struct happy_meal *hp,
 	}
 }
 
+static int happy_meal_common_probe(struct happy_meal *hp,
+				   struct device_node *dp)
+{
+	struct net_device *dev = hp->dev;
+	int err;
+
+#ifdef CONFIG_SPARC
+	hp->hm_revision = of_getintprop_default(dp, "hm-rev", hp->hm_revision);
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
@@ -2511,50 +2563,18 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
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
+	hp->hm_revision = 0xa0;
 
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
-		goto err_out_clear_quattro;
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
+#ifdef CONFIG_PCI
 	/* Hook up SBUS register/descriptor accessors. */
 	hp->read_desc32 = sbus_hme_read_desc32;
 	hp->write_txd = sbus_hme_write_txd;
@@ -2563,18 +2583,9 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
 	hp->write32 = sbus_hme_write32;
 #endif
 
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
+	err = happy_meal_common_probe(hp, dp);
+	if (err)
 		goto err_out_clear_quattro;
-	}
 
 	platform_set_drvdata(op, hp);
 
@@ -2689,20 +2700,10 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	hp->bigmacregs = (hpreg_base + 0x6000UL);
 	hp->tcvregs    = (hpreg_base + 0x7000UL);
 
-#ifdef CONFIG_SPARC
-	hp->hm_revision = of_getintprop_default(dp, "hm-rev", 0xff);
-	if (hp->hm_revision == 0xff)
+	if (IS_ENABLED(CONFIG_SPARC))
 		hp->hm_revision = 0xc0 | (pdev->revision & 0x0f);
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
+	else
+		hp->hm_revision = 0x20;
 
 	if (qp != NULL)
 		hp->happy_flags |= HFLAG_QUATTRO;
@@ -2714,30 +2715,9 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
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
+#ifdef CONFIG_SBUS
 	/* Hook up PCI register/descriptor accessors. */
 	hp->read_desc32 = pci_hme_read_desc32;
 	hp->write_txd = pci_hme_write_txd;
@@ -2746,18 +2726,9 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	hp->write32 = pci_hme_write32;
 #endif
 
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
+	err = happy_meal_common_probe(hp, dp);
+	if (err)
 		goto err_out_clear_quattro;
-	}
 
 	pci_set_drvdata(pdev, hp);
 
-- 
2.37.1

