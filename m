Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE7D373250
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 00:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232667AbhEDWa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 18:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbhEDWaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 18:30:25 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0FE0C06174A;
        Tue,  4 May 2021 15:29:28 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id f24so15588164ejc.6;
        Tue, 04 May 2021 15:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IMGJC3f9H4OYqX3wBCM/mk0stFuB1KlCyCQlxa9ipnI=;
        b=fxTeu4rfR9W61PyVdkPOHzoO7dI3a/Dem2V6U/FenG0YiAhDaCHj06z3LK4dluHWwh
         ufgKO4MQLa54G8epTwxKD198GyNhQIoHJp6wqiuNP/qzfQ/OEINaCrgSNesPtjCBQumT
         WqOziWB8dMHtOLwuWlyts79UgnfupHRbzcWs0s26rzFrwtGhu0ODnlKs78J8z8VU6k41
         ySrM5Z3logF5rLnrb7EuO85tcStOLg+oRY71FVNIqsDTIVowqqFw4c61tMLLvQ6FWEW1
         7A0CXR7JARwuEzAk/5Wz++2Sp1oVDmU7Ab/TBGsJMPSeOP8sVBXktLTbVOUXLrmBykjT
         LU3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IMGJC3f9H4OYqX3wBCM/mk0stFuB1KlCyCQlxa9ipnI=;
        b=NDSdSzKqCW2tC1jsTwlh3HtNP8Z8gggLm2bXWwohGuHYB3vWzmDYvPH+y0Q4+I21xI
         sM/9gCSX47L22R4XQ0IF0XtOBPELeF0pBBz5a+sVxUpeI3DI58H/5PAmuE79zavvHCZa
         dC1BQCrsRJ2F+ehGy06wBJI7gHgoFVmUNvTrzEBmCvuNSGhjn02Fnl0PRVmwDj0flEWB
         /d5gDrYRQ9YEVrZRVsS2Fo27kSa9ZvZ4nYdqBv/tIvysql2ptbzfV29iE3UFrVfGU4dt
         JTJGFLVC9IFi9wYXN/LwwkhbcZBfvTs57JKlNkOeK3YEZ9xptR1Hmghgh9P8bZl8gnAO
         6SpA==
X-Gm-Message-State: AOAM531lDamVWTrJTdaGw9SMLnD9cKAfponH6Vkt8Hqd7ge5RbXh52az
        EK9zghI8y5Xc+uns7LRNqF8=
X-Google-Smtp-Source: ABdhPJxCRzcxjUPedVVUZItGkn+u3VrZNRu+oc55GqJlvoLocWxzRygcRFFMlyN+U/HwaNhpyalSag==
X-Received: by 2002:a17:906:82c9:: with SMTP id a9mr25208850ejy.58.1620167367491;
        Tue, 04 May 2021 15:29:27 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q12sm2052946ejy.91.2021.05.04.15.29.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 15:29:27 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v3 02/20] net: mdio: ipq8064: add regmap config to disable REGCACHE
Date:   Wed,  5 May 2021 00:28:56 +0200
Message-Id: <20210504222915.17206-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210504222915.17206-1-ansuelsmth@gmail.com>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mdio drivers should not use REGCHACHE. Also disable locking since it's
handled by the mdio users and regmap is always accessed atomically.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/mdio/mdio-ipq8064.c | 34 +++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/net/mdio/mdio-ipq8064.c b/drivers/net/mdio/mdio-ipq8064.c
index fb1614242e13..9862745d1cee 100644
--- a/drivers/net/mdio/mdio-ipq8064.c
+++ b/drivers/net/mdio/mdio-ipq8064.c
@@ -10,9 +10,8 @@
 #include <linux/module.h>
 #include <linux/regmap.h>
 #include <linux/of_mdio.h>
-#include <linux/phy.h>
+#include <linux/of_address.h>
 #include <linux/platform_device.h>
-#include <linux/mfd/syscon.h>
 
 /* MII address register definitions */
 #define MII_ADDR_REG_ADDR			0x10
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

