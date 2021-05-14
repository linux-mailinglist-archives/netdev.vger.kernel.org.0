Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF8F381272
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 23:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234089AbhENVDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 17:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232745AbhENVB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 17:01:56 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D48E2C061348;
        Fri, 14 May 2021 14:00:37 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id n2so554600ejy.7;
        Fri, 14 May 2021 14:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Hcua741CHS+W+Y9ZYI3LQ40iYcyMd1v9iqD6kGPxRZc=;
        b=fQ71A4vYWP/A1IsXTYQLNL7H5FCZh4ixPbYiJok6NCqRSEn78GVE+gJ6o6K8wTke72
         NrHEX/N6R3WJUvOphoQ4MA9g1sNaS7O1Lsq2LYZvX359p1/t+GqKBJiHXw9QnGgdVcBt
         lsq5DLaE+N2IBtt4L+VtgN6s6N5Yba+1CmXyWezCcv+MWqMG17Ag4ia+/4yv4p4yNWyJ
         kQwOazQXbGoWbRaUoeruwAN9pQpxn4LQtHsNbX5IRVa7zUYFYwx/ymKnfCx485WUquWB
         l4v6TOUI6N5aCqmZSeo7wERBAOmcgBnIbOUhpsdbMgTQzF3z1f9WhWAz4WSvtHICw155
         m9BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hcua741CHS+W+Y9ZYI3LQ40iYcyMd1v9iqD6kGPxRZc=;
        b=PKZ1eKskJaOkTg3diu6hzJfc5/WozoYZjYXhp0B2XrG7BQYvs5BI9nPakQjAo+TOXr
         gi0qGZHaQfEtesYDDiZWy/Y51bAG6AbqK4DNS7d58Dc8CYS2lHSGViLChTcDoPArUAwH
         NVYRMnmkIH4YezuljUDCRnuyPAXFGxeKWjEkbaOGNTl9WATEWL1qYF40Ikivca9NFr8d
         /JJnAHdFRC/phZonena0Txk2X39Lmw5UE3ShkZdwmI0a/GlxcdZQHbXwR49zbpAPpCXn
         SEWiAJfZs2lJ/RKRqPk2iAMc19m43FrP3mHKfaGiNEaBGaTWDS2h1UkrCKeWJuju2nZC
         wq2Q==
X-Gm-Message-State: AOAM5334IPOV/ffV5aMEZiusxUhfgMFTkBYl8qFHVkjQHXzlg/YB0HAb
        ZwTWkYppYurLDcKowbo4/YM=
X-Google-Smtp-Source: ABdhPJzlnNeF4T7JNBNQM7yUCImzE9oxDUZvIAN9ptxNBveAjgHKUFzT8K4x6t25po+Df8S2+LmNcw==
X-Received: by 2002:a17:906:3bca:: with SMTP id v10mr18784612ejf.121.1621026036441;
        Fri, 14 May 2021 14:00:36 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id c3sm5455237edn.16.2021.05.14.14.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:00:36 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [PATCH net-next v6 20/25] net: dsa: qca8k: add support for internal phy and internal mdio
Date:   Fri, 14 May 2021 23:00:10 +0200
Message-Id: <20210514210015.18142-21-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210514210015.18142-1-ansuelsmth@gmail.com>
References: <20210514210015.18142-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to setup_mdio_bus for internal phy declaration. Introduce a
flag to use the legacy port phy mapping by default and use the direct
mapping if a mdio node is detected in the switch node. Register a
dedicated mdio internal mdio bus to address the different mapping
between port and phy if the mdio node is detected.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 112 +++++++++++++++++++++++++++++-----------
 drivers/net/dsa/qca8k.h |   1 +
 2 files changed, 83 insertions(+), 30 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index df4cf6d75074..ba288181fd1a 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -11,6 +11,7 @@
 #include <linux/netdevice.h>
 #include <net/dsa.h>
 #include <linux/of_net.h>
+#include <linux/of_mdio.h>
 #include <linux/of_platform.h>
 #include <linux/if_bridge.h>
 #include <linux/mdio.h>
@@ -629,7 +630,7 @@ qca8k_port_to_phy(int port)
 }
 
 static int
-qca8k_mdio_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
+qca8k_mdio_busy_wait(struct mii_bus *bus, u32 reg, u32 mask)
 {
 	u16 r1, r2, page;
 	u32 val;
@@ -639,7 +640,7 @@ qca8k_mdio_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
 
 	ret = read_poll_timeout(qca8k_mii_read32, val, !(val & mask), 0,
 				QCA8K_BUSY_WAIT_TIMEOUT * USEC_PER_MSEC, false,
-				priv->bus, 0x10 | r2, r1);
+				bus, 0x10 | r2, r1);
 
 	/* Check if qca8k_read has failed for a different reason
 	 * before returnting -ETIMEDOUT
@@ -651,19 +652,16 @@ qca8k_mdio_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
 }
 
 static int
-qca8k_mdio_write(struct qca8k_priv *priv, int port, u32 regnum, u16 data)
+qca8k_mdio_write(struct mii_bus *salve_bus, int phy, int regnum, u16 data)
 {
+	struct qca8k_priv *priv = salve_bus->priv;
 	u16 r1, r2, page;
-	u32 phy, val;
+	u32 val;
 	int ret;
 
 	if (regnum >= QCA8K_MDIO_MASTER_MAX_REG)
 		return -EINVAL;
 
-	/* callee is responsible for not passing bad ports,
-	 * but we still would like to make spills impossible.
-	 */
-	phy = qca8k_port_to_phy(port) % PHY_MAX_ADDR;
 	val = QCA8K_MDIO_MASTER_BUSY | QCA8K_MDIO_MASTER_EN |
 	      QCA8K_MDIO_MASTER_WRITE | QCA8K_MDIO_MASTER_PHY_ADDR(phy) |
 	      QCA8K_MDIO_MASTER_REG_ADDR(regnum) |
@@ -679,33 +677,29 @@ qca8k_mdio_write(struct qca8k_priv *priv, int port, u32 regnum, u16 data)
 
 	qca8k_mii_write32(priv->bus, 0x10 | r2, r1, val);
 
-	ret = qca8k_mdio_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
+	ret = qca8k_mdio_busy_wait(priv->bus, QCA8K_MDIO_MASTER_CTRL,
 				   QCA8K_MDIO_MASTER_BUSY);
 
 exit:
-	mutex_unlock(&priv->bus->mdio_lock);
-
 	/* even if the busy_wait timeouts try to clear the MASTER_EN */
-	qca8k_reg_clear(priv, QCA8K_MDIO_MASTER_CTRL,
-			QCA8K_MDIO_MASTER_EN);
+	qca8k_mii_write32(priv->bus, 0x10 | r2, r1, 0);
+
+	mutex_unlock(&priv->bus->mdio_lock);
 
 	return ret;
 }
 
 static int
-qca8k_mdio_read(struct qca8k_priv *priv, int port, u32 regnum)
+qca8k_mdio_read(struct mii_bus *salve_bus, int phy, int regnum)
 {
+	struct qca8k_priv *priv = salve_bus->priv;
 	u16 r1, r2, page;
-	u32 phy, val;
+	u32 val;
 	int ret;
 
 	if (regnum >= QCA8K_MDIO_MASTER_MAX_REG)
 		return -EINVAL;
 
-	/* callee is responsible for not passing bad ports,
-	 * but we still would like to make spills impossible.
-	 */
-	phy = qca8k_port_to_phy(port) % PHY_MAX_ADDR;
 	val = QCA8K_MDIO_MASTER_BUSY | QCA8K_MDIO_MASTER_EN |
 	      QCA8K_MDIO_MASTER_READ | QCA8K_MDIO_MASTER_PHY_ADDR(phy) |
 	      QCA8K_MDIO_MASTER_REG_ADDR(regnum);
@@ -720,24 +714,22 @@ qca8k_mdio_read(struct qca8k_priv *priv, int port, u32 regnum)
 
 	qca8k_mii_write32(priv->bus, 0x10 | r2, r1, val);
 
-	ret = qca8k_mdio_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
+	ret = qca8k_mdio_busy_wait(priv->bus, QCA8K_MDIO_MASTER_CTRL,
 				   QCA8K_MDIO_MASTER_BUSY);
 	if (ret)
 		goto exit;
 
 	val = qca8k_mii_read32(priv->bus, 0x10 | r2, r1);
-	val &= QCA8K_MDIO_MASTER_DATA_MASK;
 
 exit:
+	/* even if the busy_wait timeouts try to clear the MASTER_EN */
+	qca8k_mii_write32(priv->bus, 0x10 | r2, r1, 0);
+
 	mutex_unlock(&priv->bus->mdio_lock);
 
 	if (val >= 0)
 		val &= QCA8K_MDIO_MASTER_DATA_MASK;
 
-	/* even if the busy_wait timeouts try to clear the MASTER_EN */
-	qca8k_reg_clear(priv, QCA8K_MDIO_MASTER_CTRL,
-			QCA8K_MDIO_MASTER_EN);
-
 	return val;
 }
 
@@ -746,7 +738,14 @@ qca8k_phy_write(struct dsa_switch *ds, int port, int regnum, u16 data)
 {
 	struct qca8k_priv *priv = ds->priv;
 
-	return qca8k_mdio_write(priv, port, regnum, data);
+	/* Check if the legacy mapping should be used and the
+	 * port is not correctly mapped to the right PHY in the
+	 * devicetree
+	 */
+	if (priv->legacy_phy_port_mapping)
+		port = qca8k_port_to_phy(port) % PHY_MAX_ADDR;
+
+	return qca8k_mdio_write(priv->bus, port, regnum, data);
 }
 
 static int
@@ -755,7 +754,14 @@ qca8k_phy_read(struct dsa_switch *ds, int port, int regnum)
 	struct qca8k_priv *priv = ds->priv;
 	int ret;
 
-	ret = qca8k_mdio_read(priv, port, regnum);
+	/* Check if the legacy mapping should be used and the
+	 * port is not correctly mapped to the right PHY in the
+	 * devicetree
+	 */
+	if (priv->legacy_phy_port_mapping)
+		port = qca8k_port_to_phy(port) % PHY_MAX_ADDR;
+
+	ret = qca8k_mdio_read(priv->bus, port, regnum);
 
 	if (ret < 0)
 		return 0xffff;
@@ -763,11 +769,38 @@ qca8k_phy_read(struct dsa_switch *ds, int port, int regnum)
 	return ret;
 }
 
+static int
+qca8k_mdio_register(struct qca8k_priv *priv, struct device_node *mdio)
+{
+	struct dsa_switch *ds = priv->ds;
+	struct mii_bus *bus;
+
+	bus = devm_mdiobus_alloc(ds->dev);
+
+	if (!bus)
+		return -ENOMEM;
+
+	bus->priv = (void *)priv;
+	bus->name = "qca8k slave mii";
+	bus->read = qca8k_mdio_read;
+	bus->write = qca8k_mdio_write;
+	snprintf(bus->id, MII_BUS_ID_SIZE, "qca8k-%d",
+		 ds->index);
+
+	bus->parent = ds->dev;
+	bus->phy_mask = ~ds->phys_mii_mask;
+
+	ds->slave_mii_bus = bus;
+
+	return devm_of_mdiobus_register(priv->dev, bus, mdio);
+}
+
 static int
 qca8k_setup_mdio_bus(struct qca8k_priv *priv)
 {
 	u32 internal_mdio_mask = 0, external_mdio_mask = 0, reg;
-	struct device_node *ports, *port;
+	struct device_node *ports, *port, *mdio;
+	phy_interface_t mode;
 	int err;
 
 	ports = of_get_child_by_name(priv->dev->of_node, "ports");
@@ -788,7 +821,10 @@ qca8k_setup_mdio_bus(struct qca8k_priv *priv)
 		if (!dsa_is_user_port(priv->ds, reg))
 			continue;
 
-		if (of_property_read_bool(port, "phy-handle"))
+		of_get_phy_mode(port, &mode);
+
+		if (of_property_read_bool(port, "phy-handle") &&
+		    mode != PHY_INTERFACE_MODE_INTERNAL)
 			external_mdio_mask |= BIT(reg);
 		else
 			internal_mdio_mask |= BIT(reg);
@@ -825,8 +861,23 @@ qca8k_setup_mdio_bus(struct qca8k_priv *priv)
 				       QCA8K_MDIO_MASTER_EN);
 	}
 
+	/* Check if the devicetree declare the port:phy mapping */
+	mdio = of_get_child_by_name(priv->dev->of_node, "mdio");
+	if (of_device_is_available(mdio)) {
+		err = qca8k_mdio_register(priv, mdio);
+		if (err)
+			of_node_put(mdio);
+
+		return err;
+	}
+
+	/* If a mapping can't be found the legacy mapping is used,
+	 * using the qca8k_port_to_phy function
+	 */
+	priv->legacy_phy_port_mapping = true;
 	priv->ops.phy_read = qca8k_phy_read;
 	priv->ops.phy_write = qca8k_phy_write;
+
 	return 0;
 }
 
@@ -1212,7 +1263,8 @@ qca8k_phylink_validate(struct dsa_switch *ds, int port,
 	case 5:
 		/* Internal PHY */
 		if (state->interface != PHY_INTERFACE_MODE_NA &&
-		    state->interface != PHY_INTERFACE_MODE_GMII)
+		    state->interface != PHY_INTERFACE_MODE_GMII &&
+		    state->interface != PHY_INTERFACE_MODE_INTERNAL)
 			goto unsupported;
 		break;
 	case 6: /* 2nd CPU port / external PHY */
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index d365f85ab34f..ed3b05ad6745 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -255,6 +255,7 @@ struct qca8k_priv {
 	u8 switch_revision;
 	u8 rgmii_tx_delay;
 	u8 rgmii_rx_delay;
+	bool legacy_phy_port_mapping;
 	struct regmap *regmap;
 	struct mii_bus *bus;
 	struct ar8xxx_port_status port_sts[QCA8K_NUM_PORTS];
-- 
2.30.2

