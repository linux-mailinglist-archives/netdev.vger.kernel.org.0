Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC7B15BC095
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 01:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbiIRX0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 19:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiIRX0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 19:26:37 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D7EB1706F;
        Sun, 18 Sep 2022 16:26:36 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id w2so16013457qtv.9;
        Sun, 18 Sep 2022 16:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=fE6pbLFuvOBFl/qQDGBZID4Mdah+fQ2KIzxGhkxVu4I=;
        b=RUrkD50oGE2toQWqsl48izVpbUiAuDLIAxZymk9mDlml91BifmOP1SPi52uJPxDaQw
         tE2HMkOx/SGEvvlScvFXaICsGk2f6qTiIIAuTV6Fr/A3jzI2dgKf9Rd13mN2cx4FJ8bH
         7jDPi8rZir2206T/Njv6GMw6+9h6g5co0HG4EB/aeljWw6X52xg3Z0BNX4IJjIczrwcV
         snLLfcJywi0vOmwd0PYhhU5KKCzecwQGHFA0C9V6DmeFSd7GksTU7O5VetAkuaO1stqH
         BJIePJlkY8sLCGf0qqCtowVuIwVXJh2bNWd9wAJlFd3fA+yI5hM7iGklbXbkhMgItMb+
         YgvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=fE6pbLFuvOBFl/qQDGBZID4Mdah+fQ2KIzxGhkxVu4I=;
        b=QEgZY6JJKT6Qxik5/E/0sKfSjLCBNtJhnt2OyrGnYyOQHYf1XPS7HCZTJVCoh/uocM
         h6AL81UYSIVYH27NoUEV/SSQYP8woLT5PoUge8GC/4l2ysG2rg7sYi3punv5u8d9PlQi
         by3yCmgB13K1WJk/RaAAICg5obepOA5lQM7aBHZn1uGj+jO+pwaA71w/CQBKzmJU59mH
         SvjgAorK/3tZh4P42HY/ay/Rrdk8vBIcMRiGt6e4Ub7r3umTtpImeRn7dzt3z0y68wbp
         mmaN7+i4SJUkzDAuAs37wX62UNtcIeRbrMU9NyzLhcqoMmMCQY3MOi+TfgRY4lYzjHB+
         9ssg==
X-Gm-Message-State: ACrzQf0CrREnx8SXERpe7wnQ46LbRdhHEzLV5gKyDzd1mHxdKpxppCU+
        RQ9BT9kMawPj2FagftWZGVw=
X-Google-Smtp-Source: AMsMyM67DyvZKtU6y8aSRS2AK+4kPqIsYQC/Y8AEn27FDx4O5hbUgGyoopGNyuJ7xDi6wEmSvGKPcw==
X-Received: by 2002:a05:622a:1d1:b0:35b:a6be:6d97 with SMTP id t17-20020a05622a01d100b0035ba6be6d97mr13239065qtw.550.1663543595699;
        Sun, 18 Sep 2022 16:26:35 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id j6-20020a05620a410600b006b5cc25535fsm12208517qko.99.2022.09.18.16.26.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Sep 2022 16:26:35 -0700 (PDT)
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
Subject: [PATCH net-next 05/13] sunhme: Regularize probe errors
Date:   Sun, 18 Sep 2022 19:26:18 -0400
Message-Id: <20220918232626.1601885-6-seanga2@gmail.com>
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

This fixes several error paths to ensure they return an appropriate error
(instead of ENODEV).

Signed-off-by: Sean Anderson <seanga2@gmail.com>
---

 drivers/net/ethernet/sun/sunhme.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 52247505d08e..f0b77bdf51dd 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2948,7 +2948,6 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	if (err)
 		goto err_out;
 	pci_set_master(pdev);
-	err = -ENODEV;
 
 	if (!strcmp(prom_name, "SUNW,qfe") || !strcmp(prom_name, "qfe")) {
 		qp = quattro_pci_find(pdev);
@@ -2985,18 +2984,22 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
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
+	err = -ENOMEM;
+	if (!hpreg_base) {
 		printk(KERN_ERR "happymeal(PCI): Unable to remap card memory.\n");
 		goto err_out_free_res;
 	}
@@ -3066,7 +3069,7 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 
 	hp->happy_block = dma_alloc_coherent(&pdev->dev, PAGE_SIZE,
 					     &hp->hblock_dvma, GFP_KERNEL);
-	err = -ENODEV;
+	err = -ENOMEM;
 	if (!hp->happy_block)
 		goto err_out_iounmap;
 
-- 
2.37.1

