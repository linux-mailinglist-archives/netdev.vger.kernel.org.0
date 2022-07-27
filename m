Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E468F581E5D
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 05:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240197AbiG0Dtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 23:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiG0Dte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 23:49:34 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BECA72CC96
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 20:49:31 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id e16so12483805qka.5
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 20:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=0ngWrJkcqbwhugIsNABYtjLKsanc+Epc+yJY6K+Jj4s=;
        b=TDoGw4j6FzAOO2lA4yDfg7kmGd4RrRkwCde+2KNxyRYX/JGiEkk1oB5eSqVjDFmcEK
         JQxTwvtGHCS+P/dbKaDUzqA4/bEc//VLdBFn6KM7n/20cOztFp4wcoqtiapKPqU5+kU+
         cUBTaZV8IOgZ/Tv/c8Hcs5UIaBMwwZiktKdJCPz2Frj0xgY2aPXE7j1Mbkev8zYAoIeg
         RMWtn9MrqVsGZTmWZKgkFm3y8nxMX6H/j6jlcSxqcNJFjQao1zU0FbWds2Z5EYjnTqtY
         ZdG9Pnm218iECWtAiYNfqIMypWlw+ZXj0OHqijHBZfODl0Vmo0duV5/98MXryu4JPBnH
         tzFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0ngWrJkcqbwhugIsNABYtjLKsanc+Epc+yJY6K+Jj4s=;
        b=FPDQXXuFl11h7jB9HA9FkrX0BwpSKD4DsCO0iClhh3xT0tQM7zOnf6KLIRx/gA6GaW
         WBxRfQs9HcbUWSUxUrxoNsIZD2Co7HFkFwkA/GZ8ZiwB9RzLcyC35+86GiJD2APoAjKI
         W1aqF71iIkMrh71r8WXEvbevuOY/+ULF53/fOV7O93u60m3p2yv01hDPRe7Sh77+NmRG
         GSbl15nnXaKGHE7FKlfnNr0TM/iyuVqsbks1A6RJPhO0L4WpUKJVd1z/dD5bfD400G+N
         9iCVJ2oActCm8tVTTI4op+TRDu/ytkQ9R/HkdUGr1Wh1tKbf2koMvvwkiACLutrGjKB6
         ySGw==
X-Gm-Message-State: AJIora+g1i2qG/Rb8Y/FVa2nGUxmtRbaubPYf8LwDluRTm1ZKIR96Qlr
        pxaKow05bi0lWTmlvO6AddsV2Xvzd9Y=
X-Google-Smtp-Source: AGRyM1vqPaoIZxeFlH6hvkBKLT+4fcIrGRPNsZAVAagxuYst4GVsgHI3AxBb0VVlU3f49YP6UCSlAw==
X-Received: by 2002:a05:620a:28cf:b0:6b5:e32f:febb with SMTP id l15-20020a05620a28cf00b006b5e32ffebbmr14606769qkp.258.1658893770602;
        Tue, 26 Jul 2022 20:49:30 -0700 (PDT)
Received: from [192.168.1.201] (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with ESMTPSA id k21-20020a05620a415500b006b5ed1eccc5sm13203833qko.44.2022.07.26.20.49.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jul 2022 20:49:30 -0700 (PDT)
Subject: Re: [PATCH 4/x] sunhme: switch to devres
To:     Rolf Eike Beer <eike-kernel@sf-tec.de>, netdev@vger.kernel.org
References: <4686583.GXAFRqVoOG@eto.sf-tec.de>
 <11922663.O9o76ZdvQC@eto.sf-tec.de>
From:   Sean Anderson <seanga2@gmail.com>
Message-ID: <00f00bdf-1a76-693f-5c8f-9b4ceaf76b91@gmail.com>
Date:   Tue, 26 Jul 2022 23:49:29 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <11922663.O9o76ZdvQC@eto.sf-tec.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/14/22 1:31 PM, Rolf Eike Beer wrote:
> This not only removes a lot of code, it also fixes the memleak of the DMA
> memory when register_netdev() fails.
> 
> Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
> ---
>   drivers/net/ethernet/sun/sunhme.c | 55 +++++++++----------------------
>   1 file changed, 16 insertions(+), 39 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
> index 980a936ce8d1..ec78f43f75c9 100644
> --- a/drivers/net/ethernet/sun/sunhme.c
> +++ b/drivers/net/ethernet/sun/sunhme.c
> @@ -2952,7 +2952,6 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
>   	struct happy_meal *hp;
>   	struct net_device *dev;
>   	void __iomem *hpreg_base;
> -	unsigned long hpreg_res;
>   	int i, qfe_slot = -1;
>   	char prom_name[64];
>   	u8 addr[ETH_ALEN];
> @@ -2969,7 +2968,7 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
>   		strcpy(prom_name, "SUNW,hme");
>   #endif
>   
> -	err = pci_enable_device(pdev);
> +	err = pcim_enable_device(pdev);
>   
>   	if (err)
>   		goto err_out;
> @@ -2987,10 +2986,11 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
>   			goto err_out;
>   	}
>   
> -	dev = alloc_etherdev(sizeof(struct happy_meal));
> -	err = -ENOMEM;
> -	if (!dev)
> +	dev = devm_alloc_etherdev(&pdev->dev, sizeof(struct happy_meal));
> +	if (!dev) {
> +		err = -ENOMEM;
>   		goto err_out;
> +	}
>   	SET_NETDEV_DEV(dev, &pdev->dev);
>   
>   	if (hme_version_printed++ == 0)
> @@ -3009,21 +3009,23 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
>   		qp->happy_meals[qfe_slot] = dev;
>   	}
>   
> -	hpreg_res = pci_resource_start(pdev, 0);
> -	err = -ENODEV;
>   	if ((pci_resource_flags(pdev, 0) & IORESOURCE_IO) != 0) {
>   		printk(KERN_ERR "happymeal(PCI): Cannot find proper PCI device base address.\n");
>   		goto err_out_clear_quattro;
>   	}
> -	if (pci_request_regions(pdev, DRV_NAME)) {
> +
> +	if (!devm_request_region(&pdev->dev, pci_resource_start(pdev, 0),
> +				  pci_resource_len(pdev, 0),
> +				  DRV_NAME)) {
>   		printk(KERN_ERR "happymeal(PCI): Cannot obtain PCI resources, "
>   		       "aborting.\n");
>   		goto err_out_clear_quattro;
>   	}
>   
> -	if ((hpreg_base = ioremap(hpreg_res, 0x8000)) == NULL) {
> +	hpreg_base = pcim_iomap(pdev, 0, 0x8000);
> +	if (!hpreg_base) {
>   		printk(KERN_ERR "happymeal(PCI): Unable to remap card memory.\n");
> -		goto err_out_free_res;
> +		goto err_out_clear_quattro;
>   	}
>   
>   	for (i = 0; i < 6; i++) {
> @@ -3089,11 +3091,10 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
>   	hp->happy_bursts = DMA_BURSTBITS;
>   #endif
>   
> -	hp->happy_block = dma_alloc_coherent(&pdev->dev, PAGE_SIZE,
> +	hp->happy_block = dmam_alloc_coherent(&pdev->dev, PAGE_SIZE,
>   					     &hp->hblock_dvma, GFP_KERNEL);
> -	err = -ENODEV;
>   	if (!hp->happy_block)
> -		goto err_out_iounmap;
> +		goto err_out_clear_quattro;
>   
>   	hp->linkcheck = 0;
>   	hp->timer_state = asleep;
> @@ -3127,11 +3128,11 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
>   	happy_meal_set_initial_advertisement(hp);
>   	spin_unlock_irq(&hp->happy_lock);
>   
> -	err = register_netdev(hp->dev);
> +	err = devm_register_netdev(&pdev->dev, dev);
>   	if (err) {
>   		printk(KERN_ERR "happymeal(PCI): Cannot register net device, "
>   		       "aborting.\n");
> -		goto err_out_iounmap;
> +		goto err_out_clear_quattro;
>   	}
>   
>   	pci_set_drvdata(pdev, hp);
> @@ -3164,37 +3165,14 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
>   
>   	return 0;
>   
> -err_out_iounmap:
> -	iounmap(hp->gregs);
> -
> -err_out_free_res:
> -	pci_release_regions(pdev);
> -
>   err_out_clear_quattro:
>   	if (qp != NULL)
>   		qp->happy_meals[qfe_slot] = NULL;
>   
> -	free_netdev(dev);
> -
>   err_out:
>   	return err;
>   }
>   
> -static void happy_meal_pci_remove(struct pci_dev *pdev)
> -{
> -	struct happy_meal *hp = pci_get_drvdata(pdev);
> -	struct net_device *net_dev = hp->dev;
> -
> -	unregister_netdev(net_dev);
> -
> -	dma_free_coherent(hp->dma_dev, PAGE_SIZE,
> -			  hp->happy_block, hp->hblock_dvma);
> -	iounmap(hp->gregs);
> -	pci_release_regions(hp->happy_dev);
> -
> -	free_netdev(net_dev);
> -}
> -
>   static const struct pci_device_id happymeal_pci_ids[] = {
>   	{ PCI_DEVICE(PCI_VENDOR_ID_SUN, PCI_DEVICE_ID_SUN_HAPPYMEAL) },
>   	{ }			/* Terminating entry */
> @@ -3206,7 +3184,6 @@ static struct pci_driver hme_pci_driver = {
>   	.name		= "hme",
>   	.id_table	= happymeal_pci_ids,
>   	.probe		= happy_meal_pci_probe,
> -	.remove		= happy_meal_pci_remove,
>   };
>   
>   static int __init happy_meal_pci_init(void)
> 

This looks good, but doesn't apply cleanly. I rebased it as follows:

 From 5acfa13935277e312361c5630b49aea02399b8b8 Mon Sep 17 00:00:00 2001
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Date: Mon, 14 Feb 2022 19:31:09 +0100
Subject: [PATCH] sunhme: switch to devres

This not only removes a lot of code, it also fixes the memleak of the DMA
memory when register_netdev() fails.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
[ rebased onto net-next/master ]
Signed-off-by: Sean Anderson <seanga2@gmail.com>
Reviewed-by: Sean Anderson <seanga2@gmail.com>
---
  drivers/net/ethernet/sun/sunhme.c | 59 +++++++++----------------------
  1 file changed, 16 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index eebe8c5f480c..e83774ffaa7a 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2933,7 +2933,6 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
  	struct happy_meal *hp;
  	struct net_device *dev;
  	void __iomem *hpreg_base;
-	unsigned long hpreg_res;
  	int i, qfe_slot = -1;
  	char prom_name[64];
  	u8 addr[ETH_ALEN];
@@ -2950,7 +2949,7 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
  		strcpy(prom_name, "SUNW,hme");
  #endif
  
-	err = pci_enable_device(pdev);
+	err = pcim_enable_device(pdev);
  
  	if (err)
  		goto err_out;
@@ -2968,10 +2967,11 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
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
  
  	if (hme_version_printed++ == 0)
@@ -2990,21 +2990,23 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
  		qp->happy_meals[qfe_slot] = dev;
  	}
  
-	hpreg_res = pci_resource_start(pdev, 0);
-	err = -ENODEV;
  	if ((pci_resource_flags(pdev, 0) & IORESOURCE_IO) != 0) {
  		printk(KERN_ERR "happymeal(PCI): Cannot find proper PCI device base address.\n");
  		goto err_out_clear_quattro;
  	}
-	if (pci_request_regions(pdev, DRV_NAME)) {
+
+	if (!devm_request_region(&pdev->dev, pci_resource_start(pdev, 0),
+				  pci_resource_len(pdev, 0),
+				  DRV_NAME)) {
  		printk(KERN_ERR "happymeal(PCI): Cannot obtain PCI resources, "
  		       "aborting.\n");
  		goto err_out_clear_quattro;
  	}
  
-	if ((hpreg_base = ioremap(hpreg_res, 0x8000)) == NULL) {
+	hpreg_base = pcim_iomap(pdev, 0, 0x8000);
+	if (!hpreg_base) {
  		printk(KERN_ERR "happymeal(PCI): Unable to remap card memory.\n");
-		goto err_out_free_res;
+		goto err_out_clear_quattro;
  	}
  
  	for (i = 0; i < 6; i++) {
@@ -3070,11 +3072,10 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
  	hp->happy_bursts = DMA_BURSTBITS;
  #endif
  
-	hp->happy_block = dma_alloc_coherent(&pdev->dev, PAGE_SIZE,
+	hp->happy_block = dmam_alloc_coherent(&pdev->dev, PAGE_SIZE,
  					     &hp->hblock_dvma, GFP_KERNEL);
-	err = -ENODEV;
  	if (!hp->happy_block)
-		goto err_out_iounmap;
+		goto err_out_clear_quattro;
  
  	hp->linkcheck = 0;
  	hp->timer_state = asleep;
@@ -3108,11 +3109,11 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
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
@@ -3145,41 +3146,14 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
  
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
@@ -3191,7 +3165,6 @@ static struct pci_driver hme_pci_driver = {
  	.name		= "hme",
  	.id_table	= happymeal_pci_ids,
  	.probe		= happy_meal_pci_probe,
-	.remove		= happy_meal_pci_remove,
  };
  
  static int __init happy_meal_pci_init(void)
-- 
2.35.1
