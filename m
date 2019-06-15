Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49FA746F71
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 12:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbfFOKJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 06:09:48 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:47074 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbfFOKJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 06:09:47 -0400
Received: by mail-wr1-f68.google.com with SMTP id n4so4942322wrw.13;
        Sat, 15 Jun 2019 03:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bZFU7NFpVfVeHlWdzqsP9W+7pyjV+Qkejc+qbCNG2JI=;
        b=kS071LzwgDU6YqnKn98IPviy/GgCUK0RM+EhTYLxlVneNva93160H8wS+XdNcNfRoR
         rylBQviUW+BOLyLwgO+Y/eD1tFldIBZnj5CSu5t/lMErK7NwsGNaQFYkDMidrz5MeNJD
         l4e1JC0QRccodXh/5TuRuF7Y/zv8ASzHjQBdOEqDvuP0dpYy1yCCYKclsnrM15ibmpR1
         SyEMoSQg/HiT0nD/lErdb0jRfRUTB3xlvwEEPPEeig+HV+a2PZSaSRdRKZ2BmGRDtp+f
         TCeaxMbpUGV8cSq7zugSmcBvgn35AbExvvonMeS6BE11STmktZQv9DKDCjsFYcdIi2KC
         uREg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bZFU7NFpVfVeHlWdzqsP9W+7pyjV+Qkejc+qbCNG2JI=;
        b=qro9zm1fNrLN0ACJAX6KNHxzp+GkHi1p59NcYNViCSGP1TA9dN+3d5ozVzlMsowx3N
         8TX2yX+u6DO6g3Dt9pHVrD+N359TbBaZ0Fhra5UlWQ2/L38GmY21B/dhhnsbMI3i5mLJ
         Y5EM/rXRiyGxWjolN6NacBmqVsJzzI26eGjvGRjDv9GT3m2BdnXSkLm2xCyPOTKShxXQ
         gH9xTCYj8z4doDgd3rwMaccdpjOBa2zKSUtzlR/kaBdAoncRuWhT/IoL+ExVyTNV9J2D
         z+bUSjMgmTwLCXrbhXGPhr6/jqqxpHHaGfhzSxN7wzpqwjWRIj+W94oaodEtC64PEtwW
         nZzg==
X-Gm-Message-State: APjAAAUpvIHijdJml338Womrz6Egw6s6tVpzSUNcK+SScVQJtx1PZA2G
        mHt13xcg4Hm1l43xzzHhAXaCsljs1pw=
X-Google-Smtp-Source: APXvYqx0/fov4P+lnmI2fLd5hg9jAgZR94PgXgj/0RSR6XIrP2w7HMaZ7iddBld9yhXqDa6274scSw==
X-Received: by 2002:a5d:4001:: with SMTP id n1mr51838065wrp.293.1560593384926;
        Sat, 15 Jun 2019 03:09:44 -0700 (PDT)
Received: from blackbox.darklights.net (p200300F133C20E00A9A405DFDBBC0790.dip0.t-ipconnect.de. [2003:f1:33c2:e00:a9a4:5df:dbbc:790])
        by smtp.googlemail.com with ESMTPSA id f2sm9270513wrq.48.2019.06.15.03.09.43
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 15 Jun 2019 03:09:44 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     netdev@vger.kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, davem@davemloft.net
Cc:     linus.walleij@linaro.org, andrew@lunn.ch,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH net-next v1 3/5] net: stmmac: drop the reset GPIO from struct stmmac_mdio_bus_data
Date:   Sat, 15 Jun 2019 12:09:30 +0200
Message-Id: <20190615100932.27101-4-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190615100932.27101-1-martin.blumenstingl@googlemail.com>
References: <20190615100932.27101-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No platform uses the "reset_gpio" field from stmmac_mdio_bus_data
anymore. Drop it so we don't get any new consumers either.

Plain GPIO numbers are being deprecated in favor of GPIO descriptors. If
needed any new non-OF platform can add a GPIO descriptor lookup table.
devm_gpiod_get_optional() will find the GPIO in that case.

Suggested-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c | 29 ++++++-------------
 include/linux/stmmac.h                        |  1 -
 2 files changed, 9 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index 4614f1f2bffb..459ef8afe4fb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -253,21 +253,15 @@ int stmmac_mdio_reset(struct mii_bus *bus)
 	if (priv->device->of_node) {
 		struct gpio_desc *reset_gpio;
 
-		if (data->reset_gpio < 0) {
-			reset_gpio = devm_gpiod_get_optional(priv->device,
-							     "snps,reset",
-							     GPIOD_OUT_LOW);
-			if (IS_ERR(reset_gpio))
-				return PTR_ERR(reset_gpio);
-
-			device_property_read_u32_array(priv->device,
-						       "snps,reset-delays-us",
-						       data->delays, 3);
-		} else {
-			reset_gpio = gpio_to_desc(data->reset_gpio);
-
-			gpiod_direction_output(reset_gpio, 0);
-		}
+		reset_gpio = devm_gpiod_get_optional(priv->device,
+						     "snps,reset",
+						     GPIOD_OUT_LOW);
+		if (IS_ERR(reset_gpio))
+			return PTR_ERR(reset_gpio);
+
+		device_property_read_u32_array(priv->device,
+					       "snps,reset-delays-us",
+					       data->delays, 3);
 
 		if (data->delays[0])
 			msleep(DIV_ROUND_UP(data->delays[0], 1000));
@@ -323,11 +317,6 @@ int stmmac_mdio_register(struct net_device *ndev)
 	if (mdio_bus_data->irqs)
 		memcpy(new_bus->irq, mdio_bus_data->irqs, sizeof(new_bus->irq));
 
-#ifdef CONFIG_OF
-	if (priv->device->of_node)
-		mdio_bus_data->reset_gpio = -1;
-#endif
-
 	new_bus->name = "stmmac";
 
 	if (priv->plat->has_xgmac) {
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index 816edb545592..fe865df82e48 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -97,7 +97,6 @@ struct stmmac_mdio_bus_data {
 	int *irqs;
 	int probed_phy_irq;
 #ifdef CONFIG_OF
-	int reset_gpio;
 	u32 delays[3];
 #endif
 };
-- 
2.22.0

