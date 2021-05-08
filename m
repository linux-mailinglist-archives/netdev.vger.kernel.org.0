Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2709376DA9
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 02:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhEHAaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 20:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbhEHAaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 20:30:21 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4157C061761;
        Fri,  7 May 2021 17:29:20 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id l14so10864011wrx.5;
        Fri, 07 May 2021 17:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IMGJC3f9H4OYqX3wBCM/mk0stFuB1KlCyCQlxa9ipnI=;
        b=rU36FNZN3Zp5VlSKeF9MX+GnfOslaMi7mHa9PKHXup7J+yzH+7rB6wMBT1BKKwusdb
         LBfeBwAEE9dwdHM2/gDVDN8+fpIEA3aRRxKP0AKMX7HmRKAhBDFZB3slXPu8CRVtdfFK
         GBW4nF0smoMKtyqSiymNPKJKpbuobBF5Ck//+IXshVbRQwYuD7Eg5HUBJBCdNNhaIbKD
         ozMTpP7TFC+X3wSQCrtiwYb36jvhwBcQcS4CUHiRwWKEK2cAcBqHilzNqhjfpPsDLT2n
         EVst/2CKvgBFJrJtr0AkfTqPmu80Ok2w0hOhA4Jp/Rewfta6+dGGZg0Ord9cq6r6BTfe
         N9+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IMGJC3f9H4OYqX3wBCM/mk0stFuB1KlCyCQlxa9ipnI=;
        b=lwrf8BPjM+XTK2ou5MzA2+N6Mqcfa1iI00eK2v2Ay7F2SS01y094zRQa8Z3vCeuW1t
         BQyOvi5vl5Oi3kjsN3/E/KSf9Q13HI7mxhqON5Q9S9yH0gqjVp6DRNgy4Otg5mMYrxeV
         2O69In5qRoI6mCp38H+pv94BfNw73xvGkvZSSdcorbDFl/Gh1JS9OmYX3UcFHa86/Xm6
         OaTP6t4nF+De7QjGIabs092jprF8etWKFCCpEtqPVKzAUc4CU4YyHxVTB5D/8Dbmnktg
         63+5F7RteyobI1+NgU32qP/88HuYfyuRn/AwxFGVs4xxk30LRTXcZa4baSJSnzF7yU2I
         u7Gw==
X-Gm-Message-State: AOAM5307mq/SAuUYU6/mhs6pVWpdlqPcL4z1yDowqbuQRtnv1+RqRW08
        +KR5XgSBoUrPSdgOA6yMZbA=
X-Google-Smtp-Source: ABdhPJwpGV9HWrc3IDQcUMUrJ8jFL5VcJzCj/ChKs6AR8W4iw6RM1KBIKh4jNI1jqK9xjtZt8dcbYw==
X-Received: by 2002:adf:e9c2:: with SMTP id l2mr15340147wrn.323.1620433759454;
        Fri, 07 May 2021 17:29:19 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id f4sm10967597wrz.33.2021.05.07.17.29.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 17:29:19 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v4 02/28] net: mdio: ipq8064: add regmap config to disable REGCACHE
Date:   Sat,  8 May 2021 02:28:52 +0200
Message-Id: <20210508002920.19945-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210508002920.19945-1-ansuelsmth@gmail.com>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
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

