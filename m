Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B64D5BC090
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 01:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiIRX0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 19:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiIRX0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 19:26:39 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A5317078;
        Sun, 18 Sep 2022 16:26:37 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id i3so14800597qkl.3;
        Sun, 18 Sep 2022 16:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=JdFB9H2fXhd3Z1WZzCu6//J9s0r6PlHJ8gGLyEB00zg=;
        b=TXlccmiVEsDGRbQnV7BASGzt4sEUad+DQFPND5M+iTj+2F/I2atXCtHz3682243KzZ
         iTI6IejNV8eY7Rq4TzqzgyCMv7h1A1pbsVGS4f4rG2zvWNJz3+HK31olsIgq+a9emfa1
         RETBorFBtp/HMPbMaRdzfpq0aDgqU3SvFVxOHzv3FMlpmO41NZLKUi3hsVSBy6us7Z25
         kfwj+ZX1KNn71M1Me1HQnNwiGTxhG5nSW4b5uTkwUmSXxRxJ4f15x0ee4P9/XykYefSO
         Ln1pYt5227miLtKmGFMWOl65QnWU2xXJZJ8TFJoZBERoxOJQ2rIxcSY1XfrHiwCgaag6
         cmpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=JdFB9H2fXhd3Z1WZzCu6//J9s0r6PlHJ8gGLyEB00zg=;
        b=CDvroR9S4rxLB8Z9NdIZ4+2j5UcWw1mppwj352J+QIwmIpKcS8PaTZpZqYXFGCKM7T
         rl/aE0ZeuhWQXGluBPsBzD7n7mr56Y5evJsG3LTuGj7Y6mnw314kp5lcR4nfX1MZDgx2
         8tcIIdh2upK+dvziNrKADu+NRoRCB9/VVDD5Gs3Q98bRWaOULt1LUm4VZMDD/VPgiEd3
         5RBl9AONIURsPkwRY0v60v972ZKu2q58kG35UjTBg2ZZrv0flO46xQUKadfGHsZjhfae
         voZu5P4k5XWX9oBEg+eosNVhxOHEfMHkWmxOlGOS5a4B/4JvSMZ2GcXKKIj2uvt0UWy/
         N2AQ==
X-Gm-Message-State: ACrzQf2gcBn7P+a0lskh39noup0kl/eSkXywEgtIq1snF+Pb+K4CG79B
        LftdiFVhk1YOzjvM/WQXJAA=
X-Google-Smtp-Source: AMsMyM696lzlk7eyntCIaHFv3GvSCnrNoEY+T7wf3dv58ghXQV1EOFLiFMbTTt7/Q/W3Y5R+Lc/Qnw==
X-Received: by 2002:a05:620a:575:b0:6ce:4035:1978 with SMTP id p21-20020a05620a057500b006ce40351978mr11249192qkp.451.1663543596893;
        Sun, 18 Sep 2022 16:26:36 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id bs14-20020a05620a470e00b006b58d8f6181sm11188699qkb.72.2022.09.18.16.26.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Sep 2022 16:26:36 -0700 (PDT)
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
Subject: [PATCH net-next 06/13] sunhme: switch to devres
Date:   Sun, 18 Sep 2022 19:26:19 -0400
Message-Id: <20220918232626.1601885-7-seanga2@gmail.com>
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

From: Rolf Eike Beer <eike-kernel@sf-tec.de>

This not only removes a lot of code, it also fixes the memleak of the DMA
memory when register_netdev() fails.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
[ rebased onto net-next/master; fixed error reporting ]
Signed-off-by: Sean Anderson <seanga2@gmail.com>
---

 drivers/net/ethernet/sun/sunhme.c | 60 +++++++++----------------------
 1 file changed, 17 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index f0b77bdf51dd..cde0d8062fd3 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2926,7 +2926,7 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	struct happy_meal *hp;
 	struct net_device *dev;
 	void __iomem *hpreg_base;
-	unsigned long hpreg_res;
+	struct resource *hpreg_res;
 	int i, qfe_slot = -1;
 	char prom_name[64];
 	u8 addr[ETH_ALEN];
@@ -2943,7 +2943,7 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 		strcpy(prom_name, "SUNW,hme");
 #endif
 
-	err = pci_enable_device(pdev);
+	err = pcim_enable_device(pdev);
 
 	if (err)
 		goto err_out;
@@ -2964,10 +2964,11 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 			goto err_out;
 	}
 
-	dev = alloc_etherdev(sizeof(struct happy_meal));
-	err = -ENOMEM;
-	if (!dev)
+	dev = devm_alloc_etherdev(&pdev->dev, sizeof(struct happy_meal));
+	if (!dev) {
+		err = -ENOMEM;
 		goto err_out;
+	}
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
 	hp = netdev_priv(dev);
@@ -2983,25 +2984,26 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 		qp->happy_meals[qfe_slot] = dev;
 	}
 
-	hpreg_res = pci_resource_start(pdev, 0);
 	err = -EINVAL;
 	if ((pci_resource_flags(pdev, 0) & IORESOURCE_IO) != 0) {
 		printk(KERN_ERR "happymeal(PCI): Cannot find proper PCI device base address.\n");
 		goto err_out_clear_quattro;
 	}
 
-	err = pci_request_regions(pdev, DRV_NAME);
-	if (err) {
+	hpreg_res = devm_request_region(&pdev->dev, pci_resource_start(pdev, 0),
+					pci_resource_len(pdev, 0), DRV_NAME);
+	if (IS_ERR(hpreg_res)) {
+		err = PTR_ERR(hpreg_res);
 		printk(KERN_ERR "happymeal(PCI): Cannot obtain PCI resources, "
 		       "aborting.\n");
 		goto err_out_clear_quattro;
 	}
 
-	hpreg_base = ioremap(hpreg_res, 0x8000);
+	hpreg_base = pcim_iomap(pdev, 0, 0x8000);
 	err = -ENOMEM;
 	if (!hpreg_base) {
 		printk(KERN_ERR "happymeal(PCI): Unable to remap card memory.\n");
-		goto err_out_free_res;
+		goto err_out_clear_quattro;
 	}
 
 	for (i = 0; i < 6; i++) {
@@ -3067,11 +3069,11 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	hp->happy_bursts = DMA_BURSTBITS;
 #endif
 
-	hp->happy_block = dma_alloc_coherent(&pdev->dev, PAGE_SIZE,
-					     &hp->hblock_dvma, GFP_KERNEL);
+	hp->happy_block = dmam_alloc_coherent(&pdev->dev, PAGE_SIZE,
+					      &hp->hblock_dvma, GFP_KERNEL);
 	err = -ENOMEM;
 	if (!hp->happy_block)
-		goto err_out_iounmap;
+		goto err_out_clear_quattro;
 
 	hp->linkcheck = 0;
 	hp->timer_state = asleep;
@@ -3105,11 +3107,11 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	happy_meal_set_initial_advertisement(hp);
 	spin_unlock_irq(&hp->happy_lock);
 
-	err = register_netdev(hp->dev);
+	err = devm_register_netdev(&pdev->dev, dev);
 	if (err) {
 		printk(KERN_ERR "happymeal(PCI): Cannot register net device, "
 		       "aborting.\n");
-		goto err_out_free_coherent;
+		goto err_out_clear_quattro;
 	}
 
 	pci_set_drvdata(pdev, hp);
@@ -3142,41 +3144,14 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 
 	return 0;
 
-err_out_free_coherent:
-	dma_free_coherent(hp->dma_dev, PAGE_SIZE,
-			  hp->happy_block, hp->hblock_dvma);
-
-err_out_iounmap:
-	iounmap(hp->gregs);
-
-err_out_free_res:
-	pci_release_regions(pdev);
-
 err_out_clear_quattro:
 	if (qp != NULL)
 		qp->happy_meals[qfe_slot] = NULL;
 
-	free_netdev(dev);
-
 err_out:
 	return err;
 }
 
-static void happy_meal_pci_remove(struct pci_dev *pdev)
-{
-	struct happy_meal *hp = pci_get_drvdata(pdev);
-	struct net_device *net_dev = hp->dev;
-
-	unregister_netdev(net_dev);
-
-	dma_free_coherent(hp->dma_dev, PAGE_SIZE,
-			  hp->happy_block, hp->hblock_dvma);
-	iounmap(hp->gregs);
-	pci_release_regions(hp->happy_dev);
-
-	free_netdev(net_dev);
-}
-
 static const struct pci_device_id happymeal_pci_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_SUN, PCI_DEVICE_ID_SUN_HAPPYMEAL) },
 	{ }			/* Terminating entry */
@@ -3188,7 +3163,6 @@ static struct pci_driver hme_pci_driver = {
 	.name		= "hme",
 	.id_table	= happymeal_pci_ids,
 	.probe		= happy_meal_pci_probe,
-	.remove		= happy_meal_pci_remove,
 };
 
 static int __init happy_meal_pci_init(void)
-- 
2.37.1

