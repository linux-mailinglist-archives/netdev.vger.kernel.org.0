Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 767E55E8714
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 03:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232932AbiIXBxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 21:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233015AbiIXBxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 21:53:49 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43969109510;
        Fri, 23 Sep 2022 18:53:48 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id l14so1038965qvq.8;
        Fri, 23 Sep 2022 18:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=LeIBCym424oVAIElfANjqwZrpZymtgMFimxYd8UvdhU=;
        b=Diola2BHO65ypIhX09MTSMO4KEJZgBhIRR917z3AidVM7m+htt/PyTpl6E+nGGDGUS
         6vKeb8EZQl/+lPfwgnVfovLmMmV5asaLHBHjDYQql2R53WNoOzpH7/wfBQw+ZrKIsu/y
         SY9MVkuLsXo234IpOXvGjJW4doX2uzlpBz7gp+5aokx6D3Exca0TZN97r0PPBNGeavwG
         Qzq+nb6hqVmxD2DRQHq/n36MF0NttkZYImPmFkw2Ewz/7DC1PBNAe5gH5dh4W+3Roes/
         jYelgMdunTLPsRDmgKV9ARi16W97UUFAh65Lqsk/rgicloa+fG6cWwIlnWw8HJHlpx0p
         orsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=LeIBCym424oVAIElfANjqwZrpZymtgMFimxYd8UvdhU=;
        b=Iw0RPcRZ03zOsCUiKR7KWLLI8L2AH1lzCD3h3kd+vIhiyoUzUarptB7VmFASYnAUlT
         GBua6yzdy+SqIl/xEqkh+J1ilFBdn+CzzvB34LucrefFp6OD775C+BOS49K3qlqzxL54
         YC0joU4gYCTI0jHwoonH55R7B0UU2/UZhAy6m09gu8Q+e1vTbB0rBiWBTN+kdOI/D2iS
         9qaKUgEaa7YmytAIxakPj+Oym14UG5AGZGqpK3+GRba/4XBTeeBuUs/ADF1zoL02PVpe
         7kjKtIZR1ebhNub7a4crPwM42NxOGUHHpnVVKrjt6E0Ny2vlQJSdjFCRdFuweRD6h0GM
         dxVA==
X-Gm-Message-State: ACrzQf093ZrIhTJDkntcnrrrHzdAw/OPRdGKFw4vg/ar3s3y5jx/mOso
        kcKjfEK4DdQPLPjj4vW31yA=
X-Google-Smtp-Source: AMsMyM6Vjf9ItGJmdPx5JYFBE5MzPJ5VGy0zRZvBouF4abAmqvE2SKaDpoZa+fEbckOcwdM3kgODhg==
X-Received: by 2002:a05:6214:d05:b0:4ac:daac:f1c4 with SMTP id 5-20020a0562140d0500b004acdaacf1c4mr9267552qvh.84.1663984427996;
        Fri, 23 Sep 2022 18:53:47 -0700 (PDT)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id k16-20020a05620a415000b006cbe3be300esm7713603qko.12.2022.09.23.18.53.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 18:53:47 -0700 (PDT)
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
Subject: [PATCH net-next v2 04/13] sunhme: Return an ERR_PTR from quattro_pci_find
Date:   Fri, 23 Sep 2022 21:53:30 -0400
Message-Id: <20220924015339.1816744-5-seanga2@gmail.com>
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

In order to differentiate between a missing bridge and an OOM condition,
return ERR_PTRs from quattro_pci_find. This also does some general linting
in the area.

Signed-off-by: Sean Anderson <seanga2@gmail.com>
---

Changes in v2:
- Use memset to clear p->happy_meals

 drivers/net/ethernet/sun/sunhme.c | 49 +++++++++++++++++--------------
 1 file changed, 27 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 63a7cacd8286..b0843210beb9 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2498,18 +2498,16 @@ static struct quattro *quattro_sbus_find(struct platform_device *child)
 		return qp;
 
 	qp = kmalloc(sizeof(struct quattro), GFP_KERNEL);
-	if (qp != NULL) {
-		int i;
+	if (!qp)
+		return NULL;
 
-		for (i = 0; i < 4; i++)
-			qp->happy_meals[i] = NULL;
+	memset(qp->happy_meals, 0, sizeof(*qp->happy_meals));
 
-		qp->quattro_dev = child;
-		qp->next = qfe_sbus_list;
-		qfe_sbus_list = qp;
+	qp->quattro_dev = child;
+	qp->next = qfe_sbus_list;
+	qfe_sbus_list = qp;
 
-		platform_set_drvdata(op, qp);
-	}
+	platform_set_drvdata(op, qp);
 	return qp;
 }
 
@@ -2569,30 +2567,33 @@ static void quattro_sbus_free_irqs(void)
 #ifdef CONFIG_PCI
 static struct quattro *quattro_pci_find(struct pci_dev *pdev)
 {
+	int i;
 	struct pci_dev *bdev = pdev->bus->self;
 	struct quattro *qp;
 
-	if (!bdev) return NULL;
+	if (!bdev)
+		return ERR_PTR(-ENODEV);
+
 	for (qp = qfe_pci_list; qp != NULL; qp = qp->next) {
 		struct pci_dev *qpdev = qp->quattro_dev;
 
 		if (qpdev == bdev)
 			return qp;
 	}
+
 	qp = kmalloc(sizeof(struct quattro), GFP_KERNEL);
-	if (qp != NULL) {
-		int i;
+	if (!qp)
+		return ERR_PTR(-ENOMEM);
 
-		for (i = 0; i < 4; i++)
-			qp->happy_meals[i] = NULL;
+	for (i = 0; i < 4; i++)
+		qp->happy_meals[i] = NULL;
 
-		qp->quattro_dev = bdev;
-		qp->next = qfe_pci_list;
-		qfe_pci_list = qp;
+	qp->quattro_dev = bdev;
+	qp->next = qfe_pci_list;
+	qfe_pci_list = qp;
 
-		/* No range tricks necessary on PCI. */
-		qp->nranges = 0;
-	}
+	/* No range tricks necessary on PCI. */
+	qp->nranges = 0;
 	return qp;
 }
 #endif /* CONFIG_PCI */
@@ -2948,11 +2949,15 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 
 	if (!strcmp(prom_name, "SUNW,qfe") || !strcmp(prom_name, "qfe")) {
 		qp = quattro_pci_find(pdev);
-		if (qp == NULL)
+		if (IS_ERR(qp)) {
+			err = PTR_ERR(qp);
 			goto err_out;
+		}
+
 		for (qfe_slot = 0; qfe_slot < 4; qfe_slot++)
-			if (qp->happy_meals[qfe_slot] == NULL)
+			if (!qp->happy_meals[qfe_slot])
 				break;
+
 		if (qfe_slot == 4)
 			goto err_out;
 	}
-- 
2.37.1

