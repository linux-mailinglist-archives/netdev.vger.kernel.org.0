Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1049F5E8722
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 03:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbiIXByO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 21:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233048AbiIXBxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 21:53:52 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30017109130;
        Fri, 23 Sep 2022 18:53:50 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id a20so1109065qtw.10;
        Fri, 23 Sep 2022 18:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=OO0GtcNtQwihzrk2K6fcu3YyCXtG90+hs6GbEQ7Yrns=;
        b=ksrD5vWyumDXyswFvQS4t1GX0pqsh6URmojGHzCdASf/3MzLelYopfyWsnhexfdzN3
         QmtfFSe1zJeAEK4/wix362ZwaQJAQf+kX7xuz2kGzkC9fYR23+RUle+TE8qlUhRYTqrU
         qTcPJ28Wn6h8G+tGBiKoclPRHc6qB4rdcLrY04z7J/80gWvjycgpRX/lFJXF4ALqO1x9
         iUjhvcSkffbDbKjxLzhAcn9JXpUIHkkH+6OTwt3zw9E5toS6X0W7xYcK3u3aDNGgXRcK
         wuCxmZ4LLGTHrEEFfpXDhsCdMiVEQt6M0zu7900RZOJPwQTKtcoJowsl8KalWrlHTrOq
         WTXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=OO0GtcNtQwihzrk2K6fcu3YyCXtG90+hs6GbEQ7Yrns=;
        b=0QI4EwNymaBEifbqIe0co9Cjx1n94uisF4+DUUINrOyMltwWbX13RxLwHrlB7BIxZp
         8XV9ue66w6vbyH9sZ/311SsVjOOVNUuMkJcAxqaVFhZYnL9akXoxzAOjSWyrNnImbYaI
         Qzx75Ghm4yUUxWOKYSrUKKwDOMKD2vqiEoeyiQD3U9Ax3csxUGGdXncaOAzQUNQFSnOz
         lh/tS1KagSxsHbIsdmY0B1yR+hwWUTCtQri+Ngk8dfQLeUJ5GrAErq9piCcWsAi5EqDF
         7+xcYIXZhYEpog6eghiERW+QwAE3cnaqcxDbEPLC7pe2hXdKJkmG1O2tSSoM55rkEAZn
         HAgg==
X-Gm-Message-State: ACrzQf1PjgX+gFuYKMYLpD3vuo6SCKy4OXMF1QxefHzyiEmVkFUwmO0h
        AYlymwfGvbItyhynmAKaZ/E=
X-Google-Smtp-Source: AMsMyM4OatpQr119T45L0Jv3SGf4MvJddJhl+cI+87UkDo5lwwjryrW/as9WbYFxOVwGMinCgtGZTQ==
X-Received: by 2002:ac8:7f54:0:b0:35d:159d:f88e with SMTP id g20-20020ac87f54000000b0035d159df88emr8748288qtk.415.1663984429224;
        Fri, 23 Sep 2022 18:53:49 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id bn29-20020a05620a2add00b006bbf85cad0fsm6945531qkb.20.2022.09.23.18.53.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 18:53:48 -0700 (PDT)
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
Subject: [PATCH net-next v2 05/13] sunhme: Regularize probe errors
Date:   Fri, 23 Sep 2022 21:53:31 -0400
Message-Id: <20220924015339.1816744-6-seanga2@gmail.com>
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

This fixes several error paths to ensure they return an appropriate error
(instead of ENODEV).

Signed-off-by: Sean Anderson <seanga2@gmail.com>
---

Changes in v2:
- Set err inside error branches

 drivers/net/ethernet/sun/sunhme.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index b0843210beb9..26b5e44a6f2e 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2945,7 +2945,6 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	if (err)
 		goto err_out;
 	pci_set_master(pdev);
-	err = -ENODEV;
 
 	if (!strcmp(prom_name, "SUNW,qfe") || !strcmp(prom_name, "qfe")) {
 		qp = quattro_pci_find(pdev);
@@ -2963,9 +2962,10 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	}
 
 	dev = alloc_etherdev(sizeof(struct happy_meal));
-	err = -ENOMEM;
-	if (!dev)
+	if (!dev) {
+		err = -ENOMEM;
 		goto err_out;
+	}
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
 	hp = netdev_priv(dev);
@@ -2982,18 +2982,22 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	}
 
 	hpreg_res = pci_resource_start(pdev, 0);
-	err = -ENODEV;
+	err = -EINVAL;
 	if ((pci_resource_flags(pdev, 0) & IORESOURCE_IO) != 0) {
 		printk(KERN_ERR "happymeal(PCI): Cannot find proper PCI device base address.\n");
 		goto err_out_clear_quattro;
 	}
-	if (pci_request_regions(pdev, DRV_NAME)) {
+
+	err = pci_request_regions(pdev, DRV_NAME);
+	if (err) {
 		printk(KERN_ERR "happymeal(PCI): Cannot obtain PCI resources, "
 		       "aborting.\n");
 		goto err_out_clear_quattro;
 	}
 
-	if ((hpreg_base = ioremap(hpreg_res, 0x8000)) == NULL) {
+	hpreg_base = ioremap(hpreg_res, 0x8000);
+	if (!hpreg_base) {
+		err = -ENOMEM;
 		printk(KERN_ERR "happymeal(PCI): Unable to remap card memory.\n");
 		goto err_out_free_res;
 	}
@@ -3063,9 +3067,10 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 
 	hp->happy_block = dma_alloc_coherent(&pdev->dev, PAGE_SIZE,
 					     &hp->hblock_dvma, GFP_KERNEL);
-	err = -ENODEV;
-	if (!hp->happy_block)
+	if (!hp->happy_block) {
+		err = -ENOMEM;
 		goto err_out_iounmap;
+	}
 
 	hp->linkcheck = 0;
 	hp->timer_state = asleep;
-- 
2.37.1

