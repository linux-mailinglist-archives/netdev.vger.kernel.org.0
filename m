Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D80755E871C
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 03:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233101AbiIXByT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 21:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233053AbiIXBxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 21:53:54 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B345810953B;
        Fri, 23 Sep 2022 18:53:51 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id c6so1037432qvn.6;
        Fri, 23 Sep 2022 18:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=6w3YkN0UHp7fqEFzoZUCtmaO0hnkOPKKUS5sVUpFAGg=;
        b=So4zIkSAw2gyB7bXCfeOV0xEgH/+L8qTcnWc6C9EhS2YW0P9xM0O7XOl4I0dZ7lYTB
         dI94J8T/BKned6BsV6iXAMfVV9EnLoHriyUyhdPQaMLh4+vtZmAI7dtQG8nO5K80R3AC
         9KWHEfsadLsSRRPZRb4we6HKvHzohDRIxhxU9xXhvLUZWymSWJU4rsXUjxkidePZmS6P
         el9O2OjjcOTguG+hFYo+70EIeuc2wYhT2/z14ycVu7q3zYdSSvzh6gzF3Lz18yFmXhGX
         ENOK/DIArl1fY0wC03fNSGrvR4Lwes5ikqdPXE23W3djj8MYRQ4pNwPBtEmIMAgEq9cx
         0L1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=6w3YkN0UHp7fqEFzoZUCtmaO0hnkOPKKUS5sVUpFAGg=;
        b=8ATpAWvhdJamrZWENsE0qyykX8McLWKYLDXGwWHGWxAK+4tNN4P2KCa0Zjj6NbXyWH
         CA+/IPk0362W0Kl+yDyKVZtg8fybQnPCs9ICa66mj0ZGkXxTPX2wymAU54LCP202Y5Fn
         UWp3cQKPHTl0JER+DhaU1dvHSsJ6RauYOgHlezo8lGW/4yekKsJEAh/ZUsZyWDloEkEu
         xTtAXBVZUuJlqogrHiMWVwJ67GsBzE0tkxE65Te7m++C23nEhBO7dzEgFe6jpQWjtPsz
         dOfRw3X+Y1DLlsnJAjJ7gIbZJkgZjlPrZ0zX6KFjpXDnjzKSCxFo0nvCJ0x+ywZuPWc6
         ko3Q==
X-Gm-Message-State: ACrzQf3Hw9su/16oljWnyP7goi0Tp3+J73D/GgVUGi4LxG6pqY2hM0ge
        A4QYPNEBgMUmyD5AM26FGb8=
X-Google-Smtp-Source: AMsMyM4pqSi7fgOPqM5AlyX9e9Cn/OnWKNA/AIxTCuwEHCXocfwM9tp9dSXR9Do87Js8n6RjWbs4TQ==
X-Received: by 2002:a05:6214:2aaa:b0:4ac:acbd:7ef8 with SMTP id js10-20020a0562142aaa00b004acacbd7ef8mr9221607qvb.126.1663984430427;
        Fri, 23 Sep 2022 18:53:50 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id o26-20020ac8555a000000b0035ce8965045sm6448804qtr.42.2022.09.23.18.53.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 18:53:50 -0700 (PDT)
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
Subject: [PATCH net-next v2 06/13] sunhme: switch to devres
Date:   Fri, 23 Sep 2022 21:53:32 -0400
Message-Id: <20220924015339.1816744-7-seanga2@gmail.com>
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

From: Rolf Eike Beer <eike-kernel@sf-tec.de>

This not only removes a lot of code, it also fixes the memleak of the DMA
memory when register_netdev() fails.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
[ rebased onto net-next/master; fixed error reporting ]
Signed-off-by: Sean Anderson <seanga2@gmail.com>
---

(no changes since v1)

 drivers/net/ethernet/sun/sunhme.c | 55 ++++++++-----------------------
 1 file changed, 14 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 26b5e44a6f2e..7d6825c573a2 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2924,7 +2924,7 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	struct happy_meal *hp;
 	struct net_device *dev;
 	void __iomem *hpreg_base;
-	unsigned long hpreg_res;
+	struct resource *hpreg_res;
 	int i, qfe_slot = -1;
 	char prom_name[64];
 	u8 addr[ETH_ALEN];
@@ -2941,7 +2941,7 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 		strcpy(prom_name, "SUNW,hme");
 #endif
 
-	err = pci_enable_device(pdev);
+	err = pcim_enable_device(pdev);
 	if (err)
 		goto err_out;
 	pci_set_master(pdev);
@@ -2961,7 +2961,7 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 			goto err_out;
 	}
 
-	dev = alloc_etherdev(sizeof(struct happy_meal));
+	dev = devm_alloc_etherdev(&pdev->dev, sizeof(struct happy_meal));
 	if (!dev) {
 		err = -ENOMEM;
 		goto err_out;
@@ -2981,25 +2981,26 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
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
 	if (!hpreg_base) {
 		err = -ENOMEM;
 		printk(KERN_ERR "happymeal(PCI): Unable to remap card memory.\n");
-		goto err_out_free_res;
+		goto err_out_clear_quattro;
 	}
 
 	for (i = 0; i < 6; i++) {
@@ -3065,11 +3066,11 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	hp->happy_bursts = DMA_BURSTBITS;
 #endif
 
-	hp->happy_block = dma_alloc_coherent(&pdev->dev, PAGE_SIZE,
-					     &hp->hblock_dvma, GFP_KERNEL);
+	hp->happy_block = dmam_alloc_coherent(&pdev->dev, PAGE_SIZE,
+					      &hp->hblock_dvma, GFP_KERNEL);
 	if (!hp->happy_block) {
 		err = -ENOMEM;
-		goto err_out_iounmap;
+		goto err_out_clear_quattro;
 	}
 
 	hp->linkcheck = 0;
@@ -3104,11 +3105,11 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
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
@@ -3141,41 +3142,14 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 
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
@@ -3187,7 +3161,6 @@ static struct pci_driver hme_pci_driver = {
 	.name		= "hme",
 	.id_table	= happymeal_pci_ids,
 	.probe		= happy_meal_pci_probe,
-	.remove		= happy_meal_pci_remove,
 };
 
 static int __init happy_meal_pci_init(void)
-- 
2.37.1

