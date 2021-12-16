Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC61477D26
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 21:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241242AbhLPUOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 15:14:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241228AbhLPUOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 15:14:24 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F0EC061574
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 12:14:24 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id a1so398174qtx.11
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 12:14:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oqB5dKRSSzOMMx2BOvTwFm6Ga/hU28OzX7vlwtNV21Y=;
        b=Fw3l4iIAK08TCYlAmKS5Rgvl+5MG18kw+S+ak3JuNVndkBuPqTNCRne7akgZOt7OYP
         efxf0Ur867jfclrgofb7ZaVLRbo3fRMCa3L2uGFkX0ifsxb/AXt20No3hTZOFHTrXrgC
         /cbiaSLkwAdPs3kVaXB7cD8STSn+2lXLeSMtc8W9BE7EnLvBJOBe4RNwfxl+EiIsdeQE
         DlBxJL/d6lkQ5H8Hvt7NwqOf8PVzhQ/HNRoJWcpAQxT7ShA7fPlgnZMwpcpKx/UjgbN8
         lgyKYlEbQNyqD7La6D3+4w3ZNOci+mQYcqT2PNya6SHxBDDMcgO9tgDpjvbI5QyEJJkD
         8YDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oqB5dKRSSzOMMx2BOvTwFm6Ga/hU28OzX7vlwtNV21Y=;
        b=bWS5E6YvdHhUA/JpvEeAWj4SmLlErLQxNHbkBN/Wnm3RwxQAkyUB8r6qI1A+KyGwTB
         f9tp8aCY2+TPa7S40nwxDrqda20gVe8K5fkmZZG6VzP/ykmWJMLA9Skzu3qMVMkzAjEo
         PFe6YId+AUR/RrDf1Jj4JkwABMv+SnTqjlWhyFajSTzOjKbKx8a+4iJre50dY317j5GJ
         98Xkgyd7IuJa0NU6F7IvIz3w3CC0lMKPrplEsyY14EHdP/+Q6CUMt9kH0qZ2AXJtSciE
         ElYiFWt0N/tqVaTPu/zdqFh0vsDDbSmoT4+i0TsA8veY8MXX97eqtnl0YckEI5EYqNNS
         vV+w==
X-Gm-Message-State: AOAM533r5eYmOydtKlDmJe7tVyml4NxKMUI8Y0nF2N8xkKTlN6mmYmOh
        cfThgwhIYQeYeud3+r+1ue8Lt53Mg+vHtA==
X-Google-Smtp-Source: ABdhPJw00LQW9psZdkL6bpAwUMWci8j43rdCVbOslWBk2ruzKMdCEWfJKBXyZcFJGMUhCdhreOI3PA==
X-Received: by 2002:a05:622a:1a83:: with SMTP id s3mr18791962qtc.497.1639685663020;
        Thu, 16 Dec 2021 12:14:23 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id a15sm5110266qtb.5.2021.12.16.12.14.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 12:14:22 -0800 (PST)
From:   luizluca@gmail.com
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next 04/13] net: dsa: realtek: convert subdrivers into modules
Date:   Thu, 16 Dec 2021 17:13:33 -0300
Message-Id: <20211216201342.25587-5-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211216201342.25587-1-luizluca@gmail.com>
References: <20211216201342.25587-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Angelo Daros de Luca <luizluca@gmail.com>

Preparing for multiple interfaces support, the drivers
must be independent of realtek-smi.

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 drivers/net/dsa/realtek/Kconfig               | 20 +++++++++++++++++--
 drivers/net/dsa/realtek/Makefile              |  4 +++-
 .../{realtek-smi-core.c => realtek-smi.c}     | 15 ++++++++++----
 drivers/net/dsa/realtek/rtl8365mb.c           |  2 ++
 .../dsa/realtek/{rtl8366.c => rtl8366-core.c} |  0
 drivers/net/dsa/realtek/rtl8366rb.c           |  2 ++
 6 files changed, 36 insertions(+), 7 deletions(-)
 rename drivers/net/dsa/realtek/{realtek-smi-core.c => realtek-smi.c} (96%)
 rename drivers/net/dsa/realtek/{rtl8366.c => rtl8366-core.c} (100%)

diff --git a/drivers/net/dsa/realtek/Kconfig b/drivers/net/dsa/realtek/Kconfig
index bbc6e918baa6..c002a84a00f5 100644
--- a/drivers/net/dsa/realtek/Kconfig
+++ b/drivers/net/dsa/realtek/Kconfig
@@ -2,8 +2,6 @@
 menuconfig NET_DSA_REALTEK
 	tristate "Realtek Ethernet switch family support"
 	depends on NET_DSA
-	select NET_DSA_TAG_RTL4_A
-	select NET_DSA_TAG_RTL8_4
 	select FIXED_PHY
 	select IRQ_DOMAIN
 	select REALTEK_PHY
@@ -17,3 +15,21 @@ config NET_DSA_REALTEK_SMI
 	default y
 	help
 	  Select to enable support for registering switches connected through SMI.
+
+config NET_DSA_REALTEK_RTL8365MB
+	tristate "Realtek RTL8365MB switch subdriver"
+	default y
+	depends on NET_DSA_REALTEK
+	depends on NET_DSA_REALTEK_SMI
+	select NET_DSA_TAG_RTL8_4
+	help
+	  Select to enable support for Realtek RTL8365MB
+
+config NET_DSA_REALTEK_RTL8366RB
+	tristate "Realtek RTL8366RB switch subdriver"
+	default y
+	depends on NET_DSA_REALTEK
+	depends on NET_DSA_REALTEK_SMI
+	select NET_DSA_TAG_RTL4_A
+	help
+	  Select to enable support for Realtek RTL8366RB
diff --git a/drivers/net/dsa/realtek/Makefile b/drivers/net/dsa/realtek/Makefile
index 323b921bfce0..8b5a4abcedd3 100644
--- a/drivers/net/dsa/realtek/Makefile
+++ b/drivers/net/dsa/realtek/Makefile
@@ -1,3 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_NET_DSA_REALTEK_SMI) 	+= realtek-smi.o
-realtek-smi-objs			:= realtek-smi-core.o rtl8366.o rtl8366rb.o rtl8365mb.o
+obj-$(CONFIG_NET_DSA_REALTEK_RTL8366RB) += rtl8366.o
+rtl8366-objs 				:= rtl8366-core.o rtl8366rb.o
+obj-$(CONFIG_NET_DSA_REALTEK_RTL8365MB) += rtl8365mb.o
diff --git a/drivers/net/dsa/realtek/realtek-smi-core.c b/drivers/net/dsa/realtek/realtek-smi.c
similarity index 96%
rename from drivers/net/dsa/realtek/realtek-smi-core.c
rename to drivers/net/dsa/realtek/realtek-smi.c
index 2c78eb5c0bdc..11447096c8dc 100644
--- a/drivers/net/dsa/realtek/realtek-smi-core.c
+++ b/drivers/net/dsa/realtek/realtek-smi.c
@@ -297,7 +297,6 @@ int realtek_smi_write_reg_noack(struct realtek_priv *priv, u32 addr,
 {
 	return realtek_smi_write_reg(priv, addr, data, false);
 }
-EXPORT_SYMBOL_GPL(realtek_smi_write_reg_noack);
 
 /* Regmap accessors */
 
@@ -342,8 +341,9 @@ static int realtek_smi_mdio_write(struct mii_bus *bus, int addr, int regnum,
 	return priv->ops->phy_write(priv, addr, regnum, val);
 }
 
-int realtek_smi_setup_mdio(struct realtek_priv *priv)
+int realtek_smi_setup_mdio(struct dsa_switch *ds)
 {
+	struct realtek_priv *priv =  (struct realtek_priv *)ds->priv;
 	struct device_node *mdio_np;
 	int ret;
 
@@ -363,10 +363,10 @@ int realtek_smi_setup_mdio(struct realtek_priv *priv)
 	priv->slave_mii_bus->read = realtek_smi_mdio_read;
 	priv->slave_mii_bus->write = realtek_smi_mdio_write;
 	snprintf(priv->slave_mii_bus->id, MII_BUS_ID_SIZE, "SMI-%d",
-		 priv->ds->index);
+		 ds->index);
 	priv->slave_mii_bus->dev.of_node = mdio_np;
 	priv->slave_mii_bus->parent = priv->dev;
-	priv->ds->slave_mii_bus = priv->slave_mii_bus;
+	ds->slave_mii_bus = priv->slave_mii_bus;
 
 	ret = devm_of_mdiobus_register(priv->dev, priv->slave_mii_bus, mdio_np);
 	if (ret) {
@@ -413,6 +413,9 @@ static int realtek_smi_probe(struct platform_device *pdev)
 	priv->cmd_write = var->cmd_write;
 	priv->ops = var->ops;
 
+	priv->setup_interface=realtek_smi_setup_mdio;
+	priv->write_reg_noack=realtek_smi_write_reg_noack;
+
 	dev_set_drvdata(dev, priv);
 	spin_lock_init(&priv->lock);
 
@@ -492,19 +495,23 @@ static void realtek_smi_shutdown(struct platform_device *pdev)
 }
 
 static const struct of_device_id realtek_smi_of_match[] = {
+#if IS_ENABLED(CONFIG_NET_DSA_REALTEK_RTL8366RB)
 	{
 		.compatible = "realtek,rtl8366rb",
 		.data = &rtl8366rb_variant,
 	},
+#endif
 	{
 		/* FIXME: add support for RTL8366S and more */
 		.compatible = "realtek,rtl8366s",
 		.data = NULL,
 	},
+#if IS_ENABLED(CONFIG_NET_DSA_REALTEK_RTL8365MB)
 	{
 		.compatible = "realtek,rtl8365mb",
 		.data = &rtl8365mb_variant,
 	},
+#endif
 	{ /* sentinel */ },
 };
 MODULE_DEVICE_TABLE(of, realtek_smi_of_match);
diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index f562a6efb574..d6054f63f204 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -1987,3 +1987,5 @@ const struct realtek_variant rtl8365mb_variant = {
 	.chip_data_sz = sizeof(struct rtl8365mb),
 };
 EXPORT_SYMBOL_GPL(rtl8365mb_variant);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/dsa/realtek/rtl8366.c b/drivers/net/dsa/realtek/rtl8366-core.c
similarity index 100%
rename from drivers/net/dsa/realtek/rtl8366.c
rename to drivers/net/dsa/realtek/rtl8366-core.c
diff --git a/drivers/net/dsa/realtek/rtl8366rb.c b/drivers/net/dsa/realtek/rtl8366rb.c
index b1635c20276b..31f1a949c8e7 100644
--- a/drivers/net/dsa/realtek/rtl8366rb.c
+++ b/drivers/net/dsa/realtek/rtl8366rb.c
@@ -1812,3 +1812,5 @@ const struct realtek_variant rtl8366rb_variant = {
 	.chip_data_sz = sizeof(struct rtl8366rb),
 };
 EXPORT_SYMBOL_GPL(rtl8366rb_variant);
+
+MODULE_LICENSE("GPL");
-- 
2.34.0

