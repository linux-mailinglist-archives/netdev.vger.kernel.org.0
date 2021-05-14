Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC83B381285
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 23:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbhENVGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 17:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbhENVGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 17:06:06 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E42C0C061360;
        Fri, 14 May 2021 14:03:57 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id t15so43325edr.11;
        Fri, 14 May 2021 14:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ctXpRlQ6FlvoV9ONjAkOtzHC3lSCN9dn13hMr8UOEWo=;
        b=VJ5bSaNRe3/CnbcykETAwZShH0YOYVvVvjoYTgLkDg2yty8wVBoC89PBLwhCDjKhfH
         ak8wKr62L51mJDwHb1kIaG0h+PsqB8B+ts8L7NPWHxogPTr9CQwiGOCsti5hz+kM4acQ
         uudkwouayTZ/6wzVBl2FTK9SiMIKZAEkxxkRS6LSninJe8RGKGFmwc+Ob4xLBezx4V/E
         Rfa6JYN2sq2A4CqFCJyiogWbFv3VNlj379i3QlHK1HyQMOb2CyCUCY6DLvV9QSIHzJiw
         /IkkLgQI2+hmjHmtbs4L+cnh26aWpm0fUEFHZzBrWhDOCOtFK8RVc5s42f1HatXxz4eD
         Er+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ctXpRlQ6FlvoV9ONjAkOtzHC3lSCN9dn13hMr8UOEWo=;
        b=ColzYzsVyjGryUGHoeAXvtUpxHO3NvnSEpomCrDjvpBNLWiOfwUD8Dl8koUDn4K93I
         8+MXMLG5anraaFE0G3Xsdt5lO246DcqQhlLAvdJnZ3QfWigh48TGwUR9AjMBbXocOO0J
         Tg0aGfcIQU/SHFP8ur2ut8U9336KMcLgtLD5ryTN+CAySOegdlU+uI9IPjJuqjD0Wt1x
         U8R7T9MiT/Q7DYyKhTbgmWIdb3lyP7W0SMDFYIPNGQXRei9fAwwiUGeWTm75oiMAV08p
         Gl7PTUUFdbnveq0fz1aM36xw11KsXMK9A1IiKKcTDIEIZYz92SO05xzoO5ZahZu/hrYx
         khXw==
X-Gm-Message-State: AOAM5317z3AHfB/9dbfCs2IiZxNxWA6/DQNNCTVWAPhD++Bp4Bk/wlfx
        e/C8lUhZ8nD0cIQ6l5UEgMc=
X-Google-Smtp-Source: ABdhPJwfTVABsoGpj0oU1dZyPYgjzqZiuRaOdgVmnORV9rqSB6f0sfu6w+JC8TjnJsOLpzD1teHyxw==
X-Received: by 2002:a05:6402:1256:: with SMTP id l22mr22950433edw.207.1621026236500;
        Fri, 14 May 2021 14:03:56 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id f7sm5428330edd.5.2021.05.14.14.03.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:03:56 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [net-next 2/3] net: mdio: ipq8064: add regmap config to disable REGCACHE
Date:   Fri, 14 May 2021 23:03:50 +0200
Message-Id: <20210514210351.22240-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210514210351.22240-1-ansuelsmth@gmail.com>
References: <20210514210351.22240-1-ansuelsmth@gmail.com>
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

