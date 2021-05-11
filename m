Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55897379CC2
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 04:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbhEKCN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 22:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbhEKCNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 22:13:19 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1DEC06137A;
        Mon, 10 May 2021 19:11:19 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id o6-20020a05600c4fc6b029015ec06d5269so374267wmq.0;
        Mon, 10 May 2021 19:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ctXpRlQ6FlvoV9ONjAkOtzHC3lSCN9dn13hMr8UOEWo=;
        b=KzaTKEdI6Aox7ycGE/Af3TtSRNEdhWz2NtuXgv43vhAtIkryMT1IwFL0VjFUCVo6Un
         TPcaYHXmN3JmXKehP1dcERGP08hhfLH5yXc3YeBcVK9pddP3NBGnNiAum6QreNTvLnA/
         U2oJGFnqXYRATwoqVcZrBcYQbwrPqnCFldFyljcu+46Imy4pntKYdEjrb7qn/d8SFc/x
         wgxFgTfC+0My1yrni+G23V4adgoPq7pbYY+utnF/KHsZnvE1zxt4NeUsFMWkeJROKgB+
         /MUKjYYfYGXpLCgnoSGT0Qfz3X07o1OD+uOZrWzyVcfa7AsQbVSlrNq+RcZYuiE+okRV
         zG2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ctXpRlQ6FlvoV9ONjAkOtzHC3lSCN9dn13hMr8UOEWo=;
        b=EMh+fAss/BI8LIW6kdjv4RX16nEoxufiAMRAgymne8mg0ZmzqM11QUv96ugwjRBiyN
         Ordwkek+tfCr975U8bt8iO82vHEb2Q+WgcE9f050Cu0f2krVZ2Yyl0taZUJFOFAxG1D3
         IIiqBtYzi/BDpiVcCsAN4yqco2GLBjfAybBOr/5MBGNso8ysSQ1/d0eUqXGDOxWCnN/n
         6+vZOrXqOoogOELpy6VBcXzAxdorPO7fscPjIbadj4A4yN/rsEhItzKqspGPjtuWN6lx
         DZJBQwMoJKM3OvM+uFRGSOnrCK1Ovdbv2Y6wE0iO+iqG87a3qIVGoUeZOg0oFph/Z2u1
         Ybog==
X-Gm-Message-State: AOAM530v5Q8cIpN07Qovy12Kngvt1xpz49pBbB/+66TH6ld6Pggr3Xwg
        8dzMC6zUytyFJ3o+eejH0nY=
X-Google-Smtp-Source: ABdhPJzVpSUwj9DXmAUtyjif61/9jE8TQgobtjX4WDHUtVKw2eGY0iCPEGT4jfOc6j8QP5GnsXbkuQ==
X-Received: by 2002:a7b:c248:: with SMTP id b8mr2436190wmj.150.1620699078040;
        Mon, 10 May 2021 19:11:18 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id l18sm25697583wrt.97.2021.05.10.19.11.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 19:11:17 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org (open list:ETHERNET PHY LIBRARY),
        linux-kernel@vger.kernel.org (open list)
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [RFC PATCH net-next 2/3] net: mdio: ipq8064: add regmap config to disable REGCACHE
Date:   Tue, 11 May 2021 04:11:09 +0200
Message-Id: <20210511021110.17522-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210511021110.17522-1-ansuelsmth@gmail.com>
References: <20210511021110.17522-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mdio drivers should not use REGCHACHE. Also disable locking since it's
handled by the mdio users and regmap is always accessed atomically.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/mdio/mdio-ipq8064.c | 34 +++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/net/mdio/mdio-ipq8064.c b/drivers/net/mdio/mdio-ipq8064.c
index f776a843a63b..14b3c310af73 100644
--- a/drivers/net/mdio/mdio-ipq8064.c
+++ b/drivers/net/mdio/mdio-ipq8064.c
@@ -7,10 +7,9 @@
 
 #include <linux/delay.h>
 #include <linux/kernel.h>
-#include <linux/mfd/syscon.h>
 #include <linux/module.h>
 #include <linux/of_mdio.h>
-#include <linux/phy.h>
+#include <linux/of_address.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
 
@@ -97,14 +96,34 @@ ipq8064_mdio_write(struct mii_bus *bus, int phy_addr, int reg_offset, u16 data)
 	return ipq8064_mdio_wait_busy(priv);
 }
 
+static const struct regmap_config ipq8064_mdio_regmap_config = {
+	.reg_bits = 32,
+	.reg_stride = 4,
+	.val_bits = 32,
+	.can_multi_write = false,
+	/* the mdio lock is used by any user of this mdio driver */
+	.disable_locking = true,
+
+	.cache_type = REGCACHE_NONE,
+};
+
 static int
 ipq8064_mdio_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
 	struct ipq8064_mdio *priv;
+	struct resource res;
 	struct mii_bus *bus;
+	void __iomem *base;
 	int ret;
 
+	if (of_address_to_resource(np, 0, &res))
+		return -ENOMEM;
+
+	base = ioremap(res.start, resource_size(&res));
+	if (!base)
+		return -ENOMEM;
+
 	bus = devm_mdiobus_alloc_size(&pdev->dev, sizeof(*priv));
 	if (!bus)
 		return -ENOMEM;
@@ -116,15 +135,10 @@ ipq8064_mdio_probe(struct platform_device *pdev)
 	bus->parent = &pdev->dev;
 
 	priv = bus->priv;
-	priv->base = device_node_to_regmap(np);
-	if (IS_ERR(priv->base)) {
-		if (priv->base == ERR_PTR(-EPROBE_DEFER))
-			return -EPROBE_DEFER;
-
-		dev_err(&pdev->dev, "error getting device regmap, error=%pe\n",
-			priv->base);
+	priv->base = devm_regmap_init_mmio(&pdev->dev, base,
+					   &ipq8064_mdio_regmap_config);
+	if (IS_ERR(priv->base))
 		return PTR_ERR(priv->base);
-	}
 
 	ret = of_mdiobus_register(bus, np);
 	if (ret)
-- 
2.30.2

