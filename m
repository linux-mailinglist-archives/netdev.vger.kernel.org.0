Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C471379CAA
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 04:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbhEKCKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 22:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230431AbhEKCJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 22:09:23 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89196C061359;
        Mon, 10 May 2021 19:07:43 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id l24-20020a7bc4580000b029014ac3b80020so329862wmi.1;
        Mon, 10 May 2021 19:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PzGBplMYQDSD708rtnQXPN8ndzXsESLF/p+7Gtkm+M0=;
        b=POIlukTfvGjZ/fmAnMcjmIOw74R7GDa/qTb2IXw6ApghRQx5D7u1ACQ8fI3pfHPIiv
         CzZLy0gMo9aowjbmNVyrleJOphqJKG6WPw+ORlMtb2dVozFS6O3qmnSlGPkk7BNQ/Mrs
         Fc+XYeKGYJMLewEOmDRLHwySq3QtF0wKXK3Mhi4Bj0xjtALSd8cncK8rw1Vu4F4I47Er
         EXkeqT6hQntNfKmDKbdcr+pU2cQsWL+0+3wXDTawMUMMR+b03CL7uyRwVbpJ2NqcvWdy
         LQsoJ/uEHniKC8A3jxtorDOnvZLqnxYBvw0/obdoGLA/TQvXraC1A2LrhzjFrciT9x6O
         NtCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PzGBplMYQDSD708rtnQXPN8ndzXsESLF/p+7Gtkm+M0=;
        b=lq5UxZ6GczN51N10SH5+mXqisRaC2h/JtXCF6FSfgfyQQ8TAwUdnJfdvvkUB3iJyBS
         MllRRMK/NqH/UX82M3j+fgd9JsIM8KYzICmqIQLj/sVjj7C0EfdlWl2ruRXS2f9eeJ0u
         ZpgVYIvG1ipDDb7P8DzxBexG4qSvofxK/Bqpcvkq7K70ASVvTuHI50GKcA7d2D035bKL
         k6ebs4LaxuJyR7X2f4VocJpIOybMUcrRsPEUC5rrLo6ULkWxSgTsrfb346Jwj8MoApCr
         KWSlhnkZ4m7f9zw4ENVE+NW/t38oBfCqLBy9+DOt6UokCwGO9HnTxTTzq+asSEQvHZLW
         yzAA==
X-Gm-Message-State: AOAM532q6BSSIczXC07JhBbfhGG6C9z2fHwcdb/wGPtEDfaDp0sTCPUD
        QjxymS3UDjR1bY/XpOFS1qk=
X-Google-Smtp-Source: ABdhPJyayEOPz0KJQ3IZsSTstYkx+hddsly9EoHsQv8LbGrct9lhuQGiGXBTT6y0GWZQSxXrwQ5uFQ==
X-Received: by 2002:a05:600c:2249:: with SMTP id a9mr2362162wmm.20.1620698862127;
        Mon, 10 May 2021 19:07:42 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q20sm2607436wmq.2.2021.05.10.19.07.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 19:07:41 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list)
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH net-next v5 20/25] net: dsa: qca8k: add support for internal phy and internal mdio
Date:   Tue, 11 May 2021 04:04:55 +0200
Message-Id: <20210511020500.17269-21-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210511020500.17269-1-ansuelsmth@gmail.com>
References: <20210511020500.17269-1-ansuelsmth@gmail.com>
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
index 381c0e340c09..307fe7eb03f3 100644
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

