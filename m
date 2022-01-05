Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F55484CC5
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 04:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235869AbiAEDPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 22:15:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235819AbiAEDPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 22:15:53 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BBB3C061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 19:15:53 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id y17so218258qtx.9
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 19:15:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LYs7nuT9QSLNG4slxKJ3aTbaAnxdwPsTPdy6q7fHCV4=;
        b=jKLTipEtH7P/1k+TOos7sR5c+dWG7KCdV1JKj9lWmQZgPhBrLQ3xbUwus7KBvpy3zU
         BDzga3KXPKCOMhEv1y88HTV8NsnL1i2OVslWAIgWfbI69fnc/jeXKHzLcUU/iNkmCsCa
         kfElIkyOj5IJyfKXAPDXj4hPLk/gqBaVqUqOA4myrQRxDWbtRo/O93hwjpgxCar3PNwW
         BURZNwiYgPutWrWlXLaj9oeebjqWIxQ6yrCUJMIYLQlLX0bRBM1h5gZafx5j2KewVPLW
         rYwuHwPxQ9wgcShCWUwYpadgNMsT99RpJ4bDi5lzeSti2lhwAknO8AQ51bOv6dAIw365
         1s9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LYs7nuT9QSLNG4slxKJ3aTbaAnxdwPsTPdy6q7fHCV4=;
        b=i6RLd+vxgist+B1d5afrkuN/8Zl+80O4Fcy9opnYdQFJQDe1hYpq6QzAWazaPyCEZ+
         G/3xdLEwIBqsn1XhbqylytFPxWUJhXAH22Dxzy/7CWEYipqB7XJ75N5auA7Uc5MEBivc
         LBxeT+zBxoy78briH2HJ4WGqjmRVksKowBYnhWOcZ8ARUp5+u/mmgHciYzAEhdS7H+u3
         Q8pbf8iIQ2xP1yxOxn1dYkiwzPgE4I3u4OXSZniX9OFbAd5TMwlUD0qhgr78cMrydIax
         MhY9FbU9lpd4zXPkmVnCo1xIEU3AhRroXrU7fcE7znbqF37IbAkdK2QElLKfzhPrlB5/
         DICQ==
X-Gm-Message-State: AOAM532GBHInUrEzPv00OhWoVW7IOUHSHbgRtumjHP9FUXmNaMPZgx5b
        K3jnPAtmEQQq7h8aKqDoBOFe13G8IOwX5Cv+
X-Google-Smtp-Source: ABdhPJybuaqJMrtuntb+scfBCx5Ogs9l4Vlz8SNDkAxM4XRU/LxYxiT7oLY3gM4KXg49Yh/sX1bljw==
X-Received: by 2002:ac8:4f07:: with SMTP id b7mr47830331qte.301.1641352552551;
        Tue, 04 Jan 2022 19:15:52 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id t11sm32607629qkp.56.2022.01.04.19.15.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 19:15:52 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com, frank-w@public-files.de,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v4 03/11] net: dsa: realtek: remove direct calls to realtek-smi
Date:   Wed,  5 Jan 2022 00:15:07 -0300
Message-Id: <20220105031515.29276-4-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20220105031515.29276-1-luizluca@gmail.com>
References: <20220105031515.29276-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the only two direct calls from subdrivers to realtek-smi.
Now they are called from realtek_priv. Subdrivers can now be
linked independently from realtek-smi.

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 drivers/net/dsa/realtek/realtek-smi-core.c | 15 +++++++++------
 drivers/net/dsa/realtek/realtek.h          |  7 ++-----
 drivers/net/dsa/realtek/rtl8365mb.c        | 12 +++++++-----
 drivers/net/dsa/realtek/rtl8366rb.c        | 12 +++++++-----
 4 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/drivers/net/dsa/realtek/realtek-smi-core.c b/drivers/net/dsa/realtek/realtek-smi-core.c
index 7dfd86a99c24..a917801385c9 100644
--- a/drivers/net/dsa/realtek/realtek-smi-core.c
+++ b/drivers/net/dsa/realtek/realtek-smi-core.c
@@ -292,12 +292,11 @@ static int realtek_smi_write_reg(struct realtek_priv *priv,
  * is when issueing soft reset. Since the device reset as soon as we write
  * that bit, no ACK will come back for natural reasons.
  */
-int realtek_smi_write_reg_noack(struct realtek_priv *priv, u32 addr,
-				u32 data)
+static int realtek_smi_write_reg_noack(struct realtek_priv *priv, u32 addr,
+				       u32 data)
 {
 	return realtek_smi_write_reg(priv, addr, data, false);
 }
-EXPORT_SYMBOL_GPL(realtek_smi_write_reg_noack);
 
 /* Regmap accessors */
 
@@ -342,8 +341,9 @@ static int realtek_smi_mdio_write(struct mii_bus *bus, int addr, int regnum,
 	return priv->ops->phy_write(priv, addr, regnum, val);
 }
 
-int realtek_smi_setup_mdio(struct realtek_priv *priv)
+static int realtek_smi_setup_mdio(struct dsa_switch *ds)
 {
+	struct realtek_priv *priv =  ds->priv;
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
 
+	priv->setup_interface = realtek_smi_setup_mdio;
+	priv->write_reg_noack = realtek_smi_write_reg_noack;
+
 	dev_set_drvdata(dev, priv);
 	spin_lock_init(&priv->lock);
 
diff --git a/drivers/net/dsa/realtek/realtek.h b/drivers/net/dsa/realtek/realtek.h
index 177fff90b8a6..58814de563a2 100644
--- a/drivers/net/dsa/realtek/realtek.h
+++ b/drivers/net/dsa/realtek/realtek.h
@@ -66,6 +66,8 @@ struct realtek_priv {
 	struct rtl8366_mib_counter *mib_counters;
 
 	const struct realtek_ops *ops;
+	int			(*setup_interface)(struct dsa_switch *ds);
+	int			(*write_reg_noack)(struct realtek_priv *priv, u32 addr, u32 data);
 
 	int			vlan_enabled;
 	int			vlan4k_enabled;
@@ -115,11 +117,6 @@ struct realtek_variant {
 	size_t chip_data_sz;
 };
 
-/* SMI core calls */
-int realtek_smi_write_reg_noack(struct realtek_priv *priv, u32 addr,
-				u32 data);
-int realtek_smi_setup_mdio(struct realtek_priv *priv);
-
 /* RTL8366 library helpers */
 int rtl8366_mc_is_used(struct realtek_priv *priv, int mc_index, int *used);
 int rtl8366_set_vlan(struct realtek_priv *priv, int vid, u32 member,
diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index 6b8797ba80c6..5fb453b5f650 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -1767,7 +1767,7 @@ static int rtl8365mb_reset_chip(struct realtek_priv *priv)
 {
 	u32 val;
 
-	realtek_smi_write_reg_noack(priv, RTL8365MB_CHIP_RESET_REG,
+	priv->write_reg_noack(priv, RTL8365MB_CHIP_RESET_REG,
 				    FIELD_PREP(RTL8365MB_CHIP_RESET_HW_MASK,
 					       1));
 
@@ -1849,10 +1849,12 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
 	if (ret)
 		goto out_teardown_irq;
 
-	ret = realtek_smi_setup_mdio(priv);
-	if (ret) {
-		dev_err(priv->dev, "could not set up MDIO bus\n");
-		goto out_teardown_irq;
+	if (priv->setup_interface) {
+		ret = priv->setup_interface(ds);
+		if (ret) {
+			dev_err(priv->dev, "could not set up MDIO bus\n");
+			goto out_teardown_irq;
+		}
 	}
 
 	/* Start statistics counter polling */
diff --git a/drivers/net/dsa/realtek/rtl8366rb.c b/drivers/net/dsa/realtek/rtl8366rb.c
index 241e6b6ebea5..34e371084d6d 100644
--- a/drivers/net/dsa/realtek/rtl8366rb.c
+++ b/drivers/net/dsa/realtek/rtl8366rb.c
@@ -1030,10 +1030,12 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 	if (ret)
 		dev_info(priv->dev, "no interrupt support\n");
 
-	ret = realtek_smi_setup_mdio(priv);
-	if (ret) {
-		dev_info(priv->dev, "could not set up MDIO bus\n");
-		return -ENODEV;
+	if (priv->setup_interface) {
+		ret = priv->setup_interface(ds);
+		if (ret) {
+			dev_err(priv->dev, "could not set up MDIO bus\n");
+			return -ENODEV;
+		}
 	}
 
 	return 0;
@@ -1705,7 +1707,7 @@ static int rtl8366rb_reset_chip(struct realtek_priv *priv)
 	u32 val;
 	int ret;
 
-	realtek_smi_write_reg_noack(priv, RTL8366RB_RESET_CTRL_REG,
+	priv->write_reg_noack(priv, RTL8366RB_RESET_CTRL_REG,
 				    RTL8366RB_CHIP_CTRL_RESET_HW);
 	do {
 		usleep_range(20000, 25000);
-- 
2.34.0

