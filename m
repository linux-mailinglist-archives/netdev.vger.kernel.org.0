Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62BD21B0C80
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 15:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgDTNWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 09:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726049AbgDTNWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 09:22:20 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91154C061A0C;
        Mon, 20 Apr 2020 06:22:19 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x77so2312431pfc.0;
        Mon, 20 Apr 2020 06:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sXWP0V37TZyu+uhl337MTjVaVszi6Eu5V9Mz4bT0frM=;
        b=Moyu0ACFApVv8FApkUDEFeG1u4cJ7jXFW0aZZd6Rmee+KpBwWAwqjxKR4esKwSHaDy
         wPywMV7kV3L88SJyePvuMXAKDbq4EJBuMr57e5k7M1DClwOxXKj5IyXxl8SJZceJSpbd
         hAEdrooo8oP2juI6XRq5aTG3FaQGppeA1OiTy3XRUxSqJfJI4ByaQA4oeq8CwWk3qp0f
         m2IOVwx2XBSgZsGNj72za+ZyWvAwa0+zqIFXYgkoSlMgMDlBKuKjEEjCXWhI6jsfjSI6
         0qdeaf51uSfpRkBObC02Fdzy4nY8OznxCbbTxc4OHIf1101YFfc+f52cyCewSi09ZkdF
         jA3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sXWP0V37TZyu+uhl337MTjVaVszi6Eu5V9Mz4bT0frM=;
        b=msxG8w2rFt90UO0gR2bqWaLeNWZgsREHPsm+37+rprCHC/R8wZ2naPidy14CswHQmR
         3UCIQ3b42tAVihmH7eiZ/oZ2VGjMpUWCR5NBKYE/f5wmHsAm7bK8MDUQXBuxeGqHhw3X
         3FXdoolvliwF6YfQr1JmRtjMculDxAGALFDIKOFxh7M/XoznfTyPGdiWkEuLsNtVucm4
         9R7mHQo6jZR0Lknl/AxVLeTndH2+lR7rx+2+9QdWBTDozMc2IDF4+Jr7qOmm+mqK9yCV
         kVZp7eir/ILrmvHWgFohuoL3HyOjX9wT5OGg68IbYSWk6u6Ha8NTiI+RUSvbwbIwN+YC
         4GCQ==
X-Gm-Message-State: AGi0PuZRB5Y6Ve5TAO8Ic3B6mnfUXKyIB8nK6yTdSprHwKeuifIgAJZF
        dz4NZmVOGGfSJHcO/gDfsU8=
X-Google-Smtp-Source: APiQypLgQslbSVMtooxJiVUrfnopEZti5dVvCeA4qJGVDwjnBi+1RQ1knoSx7TQBWnBmMcvbGpl86A==
X-Received: by 2002:a63:4d4f:: with SMTP id n15mr15889066pgl.399.1587388939108;
        Mon, 20 Apr 2020 06:22:19 -0700 (PDT)
Received: from localhost (89.208.244.140.16clouds.com. [89.208.244.140])
        by smtp.gmail.com with ESMTPSA id k63sm1230614pjb.6.2020.04.20.06.22.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 20 Apr 2020 06:22:18 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        Markus.Elfring@web.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v2] can: ti_hecc: convert to devm_platform_ioremap_resource_byname()
Date:   Mon, 20 Apr 2020 21:22:07 +0800
Message-Id: <20200420132207.8536-1-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the function devm_platform_ioremap_resource_byname() to simplify
source code which calls the functions platform_get_resource_byname()
and devm_ioremap_resource(). Remove also a few error messages which
became unnecessary with this software refactoring.

Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
v1 -> v2:
	- modify the commit comments by Markus's suggestion.

 drivers/net/can/ti_hecc.c | 27 +++++----------------------
 1 file changed, 5 insertions(+), 22 deletions(-)

diff --git a/drivers/net/can/ti_hecc.c b/drivers/net/can/ti_hecc.c
index 94b1491b569f..5f39a4c668b5 100644
--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -857,7 +857,7 @@ static int ti_hecc_probe(struct platform_device *pdev)
 	struct net_device *ndev = (struct net_device *)0;
 	struct ti_hecc_priv *priv;
 	struct device_node *np = pdev->dev.of_node;
-	struct resource *res, *irq;
+	struct resource *irq;
 	struct regulator *reg_xceiver;
 	int err = -ENODEV;
 
@@ -878,39 +878,22 @@ static int ti_hecc_probe(struct platform_device *pdev)
 	priv = netdev_priv(ndev);
 
 	/* handle hecc memory */
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "hecc");
-	if (!res) {
-		dev_err(&pdev->dev, "can't get IORESOURCE_MEM hecc\n");
-		return -EINVAL;
-	}
-
-	priv->base = devm_ioremap_resource(&pdev->dev, res);
+	priv->base = devm_platform_ioremap_resource_byname(pdev, "hecc");
 	if (IS_ERR(priv->base)) {
 		dev_err(&pdev->dev, "hecc ioremap failed\n");
 		return PTR_ERR(priv->base);
 	}
 
 	/* handle hecc-ram memory */
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "hecc-ram");
-	if (!res) {
-		dev_err(&pdev->dev, "can't get IORESOURCE_MEM hecc-ram\n");
-		return -EINVAL;
-	}
-
-	priv->hecc_ram = devm_ioremap_resource(&pdev->dev, res);
+	priv->hecc_ram = devm_platform_ioremap_resource_byname(pdev,
+							       "hecc-ram");
 	if (IS_ERR(priv->hecc_ram)) {
 		dev_err(&pdev->dev, "hecc-ram ioremap failed\n");
 		return PTR_ERR(priv->hecc_ram);
 	}
 
 	/* handle mbx memory */
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "mbx");
-	if (!res) {
-		dev_err(&pdev->dev, "can't get IORESOURCE_MEM mbx\n");
-		return -EINVAL;
-	}
-
-	priv->mbx = devm_ioremap_resource(&pdev->dev, res);
+	priv->mbx = devm_platform_ioremap_resource_byname(pdev, "mbx");
 	if (IS_ERR(priv->mbx)) {
 		dev_err(&pdev->dev, "mbx ioremap failed\n");
 		return PTR_ERR(priv->mbx);
-- 
2.25.0

