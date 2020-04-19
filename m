Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82D611AF9C6
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 14:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgDSMF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 08:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725841AbgDSMF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 08:05:56 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7169C061A0C;
        Sun, 19 Apr 2020 05:05:54 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id a22so3174856pjk.5;
        Sun, 19 Apr 2020 05:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GwrJxs1zh7z1DaG/GHIwSQc+vhTOtEIokowtpmXYUsw=;
        b=rOcLj8bJ7LNhOyMMXGfbbbtjdCIT09l5+IpxUU3tC/hrKVUDUMT9v1FqvuoVGnHQ/w
         r386xZeJXtrqAXkwVDk51oesx7Y6+mtOs4W9Fj4nbi2gOCO6cpD9IpWVB3f5KcCdJfLC
         JLPfTBY0LoAFcbOpJcjkPucBV6xxcifXCNU+XrEsmu4qPwb9M6OO1HcqxhN8epepAMvx
         Wpc/BP/nYIhfg/GWtDtibnHDRj0KrrRGIL02c67YKY2uQ/XGKWGdfZYzpMYww/Txmyrl
         LoRxTSALWgNrfLDl/DiAtf7qo3l8VPv6CTsrWVwXMU5VyAN+ssIJVnu1YyFwL9hEzCiW
         c0vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GwrJxs1zh7z1DaG/GHIwSQc+vhTOtEIokowtpmXYUsw=;
        b=q9hJJSevaIguZhRJtFCP3jz775H3BCKicr4EIg405+OqR8W61Gnlw59y1TveKAC4HL
         HdxxqXtJjzDnpr5eRiy9MXmsF4SYat9/Kf+Ib1CLYc06LHW8whe/lfhYbN+ZWvAGFzsU
         jK1Qrt4E6tPI+Af0/3B5R0UoEWoPrdPn1cDxonO+mR/EplhibQ6bLo6p7uYsNO8Ww8KE
         t3YBNzchT9VF7m6QESZkPZG73XH85LpEVwtsRRmQfIuIHgla8K4V1FaDrkgymNuxUZmG
         7+geaqmIHvQnp+zhdG2k0pBiXBiwIAnVnFok8yuip+2sUJ/9cA2dCMLq1EJkIsnWFV6D
         R10g==
X-Gm-Message-State: AGi0PuZnACwVKkkKkYv7SPpYJ3DC+2cvaA9gKOzRwKdzk9crgsuc5saA
        88OSsLfRy18hf9Mv798nuQI0gzJv
X-Google-Smtp-Source: APiQypJLy7lglmwwH2E6csyb0a/1gqpOmdQNFGnD5A5Y7E4hXWFCTBJ3zhRvciyc7zt0/4jJ4THHcA==
X-Received: by 2002:a17:902:760c:: with SMTP id k12mr2662762pll.98.1587297954349;
        Sun, 19 Apr 2020 05:05:54 -0700 (PDT)
Received: from localhost ([89.208.244.140])
        by smtp.gmail.com with ESMTPSA id x16sm10825038pfc.61.2020.04.19.05.05.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 19 Apr 2020 05:05:54 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v1] can: ti_hecc: convert to devm_platform_ioremap_resource_byname()
Date:   Sun, 19 Apr 2020 20:05:47 +0800
Message-Id: <20200419120547.25836-1-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use devm_platform_ioremap_resource_byname() to simplify code,
it contains platform_get_resource_byname() and
devm_ioremap_resource(), and also remove some duplicate error
message.

Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
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

