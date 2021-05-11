Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F9E379C82
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 04:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbhEKCJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 22:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbhEKCIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 22:08:38 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B334DC061760;
        Mon, 10 May 2021 19:07:30 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 4-20020a05600c26c4b0290146e1feccd8so356642wmv.1;
        Mon, 10 May 2021 19:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FmM3uTK+zLhu5uULbhYiIUUtViQrXlyn3yILswQA25I=;
        b=tqYuoueAGvswsG0KZxUJPGX09xDrWxN03vEsW5hwOqtUr5PI/dsHHOm4v2zMQ1+0SO
         lWSRXslEHmqIYV4BIiO6wQ8OFbUpDlkESQDfn7drSIfF3D4DbRQV4SzMu7XQoOdQcX+G
         m+sTokXt+ZgSSztQD2k4fXrHurVFF5XMAvMZokYMS+I8Ge1Ji5LXx1Mmfuut4ulj90Gx
         xwQCObFwQBS/hcOFDBx7mSq5VNXWva574BGFlHu0p/108a/ms1j53K6cW7KvyFChevQZ
         un3XCW+vk7zlrTi8wzCl8wfa/U3ivSYmk7OHA4kxKgVWsn703mcIn91yYEOZdMDC8sNf
         D2jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FmM3uTK+zLhu5uULbhYiIUUtViQrXlyn3yILswQA25I=;
        b=fcAmgiLCWaPjtMqqb4xWuktkmCjZqLuDBvxqYPFYW3DMZbRL5ocbaa2aEo/KtSqDla
         OKgb5x65eG/2ceu9upn4bILWFVVGUIvBGnmKDF5H9ODzKxm/pcPGv8S5aCGBsuVJjmnK
         mn4Sv2VdoxZaZnjFZyuD+NhvhX0M5BI6ZiIMhz5ayG41WRoK8wR3xUySNXiBBW2jVXt/
         FX4n/D05Dl4eaZ/3nSHrQCbEf8KWxIJaIaVeHI0WEPGip+BpBUNv3CCo6tHmgAhqmbZ/
         ImJvgaOpcj4pTzfYwKsEZM2H4qbRLlRbF38FdWsUyowIq/bcv8p3yTRyvYIvamcfoESO
         MBJQ==
X-Gm-Message-State: AOAM532xVaQTVTMiecp3yQSHF4utfNw4ju70SoWGI3olM01riYjimH1S
        WZGJarjuLOunualiraOGxkJKE3ux+OjLVA==
X-Google-Smtp-Source: ABdhPJz1VGVo25OiSKI4m3dYeSl9jUIW8CsEGd3eno/75/vKApZlxgortfL2EAM1NDBs8XcPVixW1g==
X-Received: by 2002:a1c:b60b:: with SMTP id g11mr2396112wmf.68.1620698849245;
        Mon, 10 May 2021 19:07:29 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q20sm2607436wmq.2.2021.05.10.19.07.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 19:07:28 -0700 (PDT)
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
Subject: [RFC PATCH net-next v5 07/25] net: dsa: qca8k: handle error with qca8k_rmw operation
Date:   Tue, 11 May 2021 04:04:42 +0200
Message-Id: <20210511020500.17269-8-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210511020500.17269-1-ansuelsmth@gmail.com>
References: <20210511020500.17269-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qca8k_rmw can fail. Rework any user to handle error values and
correctly return. Change qca8k_rmw to return the error code or 0 instead
of the reg value. The reg returned by qca8k_rmw wasn't used anywhere,
so this doesn't cause any functional change.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 133 +++++++++++++++++++++++++---------------
 1 file changed, 83 insertions(+), 50 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 2fdd7c2e74d5..409f6592048a 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -190,12 +190,13 @@ qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val)
 	return ret;
 }
 
-static u32
-qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 val)
+static int
+qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val)
 {
 	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
-	u32 ret;
+	u32 val;
+	int ret;
 
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
@@ -205,10 +206,15 @@ qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 val)
 	if (ret < 0)
 		goto exit;
 
-	ret = qca8k_mii_read32(bus, 0x10 | r2, r1);
-	ret &= ~mask;
-	ret |= val;
-	qca8k_mii_write32(bus, 0x10 | r2, r1, ret);
+	val = qca8k_mii_read32(bus, 0x10 | r2, r1);
+	if (val < 0) {
+		ret = val;
+		goto exit;
+	}
+
+	val &= ~mask;
+	val |= write_val;
+	qca8k_mii_write32(bus, 0x10 | r2, r1, val);
 
 exit:
 	mutex_unlock(&bus->mdio_lock);
@@ -216,16 +222,16 @@ qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 val)
 	return ret;
 }
 
-static void
+static int
 qca8k_reg_set(struct qca8k_priv *priv, u32 reg, u32 val)
 {
-	qca8k_rmw(priv, reg, 0, val);
+	return qca8k_rmw(priv, reg, 0, val);
 }
 
-static void
+static int
 qca8k_reg_clear(struct qca8k_priv *priv, u32 reg, u32 val)
 {
-	qca8k_rmw(priv, reg, val, 0);
+	return qca8k_rmw(priv, reg, val, 0);
 }
 
 static int
@@ -570,12 +576,19 @@ qca8k_mib_init(struct qca8k_priv *priv)
 	int ret;
 
 	mutex_lock(&priv->reg_mutex);
-	qca8k_reg_set(priv, QCA8K_REG_MIB, QCA8K_MIB_FLUSH | QCA8K_MIB_BUSY);
+	ret = qca8k_reg_set(priv, QCA8K_REG_MIB, QCA8K_MIB_FLUSH | QCA8K_MIB_BUSY);
+	if (ret)
+		goto exit;
+
 	qca8k_busy_wait(priv, QCA8K_REG_MIB, QCA8K_MIB_BUSY);
-	qca8k_reg_set(priv, QCA8K_REG_MIB, QCA8K_MIB_CPU_KEEP);
+
+	ret = qca8k_reg_set(priv, QCA8K_REG_MIB, QCA8K_MIB_CPU_KEEP);
+	if (ret)
+		goto exit;
 
 	ret = qca8k_write(priv, QCA8K_REG_MODULE_EN, QCA8K_MODULE_EN_MIB);
 
+exit:
 	mutex_unlock(&priv->reg_mutex);
 	return ret;
 }
@@ -747,9 +760,8 @@ qca8k_setup_mdio_bus(struct qca8k_priv *priv)
 		 * a dt-overlay and driver reload changed the configuration
 		 */
 
-		qca8k_reg_clear(priv, QCA8K_MDIO_MASTER_CTRL,
-				QCA8K_MDIO_MASTER_EN);
-		return 0;
+		return qca8k_reg_clear(priv, QCA8K_MDIO_MASTER_CTRL,
+				       QCA8K_MDIO_MASTER_EN);
 	}
 
 	priv->ops.phy_read = qca8k_phy_read;
@@ -782,8 +794,12 @@ qca8k_setup(struct dsa_switch *ds)
 		return ret;
 
 	/* Enable CPU Port */
-	qca8k_reg_set(priv, QCA8K_REG_GLOBAL_FW_CTRL0,
-		      QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
+	ret = qca8k_reg_set(priv, QCA8K_REG_GLOBAL_FW_CTRL0,
+			    QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
+	if (ret) {
+		dev_err(priv->dev, "failed enabling CPU port");
+		return ret;
+	}
 
 	/* Enable MIB counters */
 	ret = qca8k_mib_init(priv);
@@ -800,9 +816,12 @@ qca8k_setup(struct dsa_switch *ds)
 	}
 
 	/* Disable forwarding by default on all ports */
-	for (i = 0; i < QCA8K_NUM_PORTS; i++)
-		qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
-			  QCA8K_PORT_LOOKUP_MEMBER, 0);
+	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
+		ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
+				QCA8K_PORT_LOOKUP_MEMBER, 0);
+		if (ret)
+			return ret;
+	}
 
 	/* Disable MAC by default on all ports */
 	for (i = 1; i < QCA8K_NUM_PORTS; i++)
@@ -821,28 +840,37 @@ qca8k_setup(struct dsa_switch *ds)
 	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
 		/* CPU port gets connected to all user ports of the switch */
 		if (dsa_is_cpu_port(ds, i)) {
-			qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(QCA8K_CPU_PORT),
-				  QCA8K_PORT_LOOKUP_MEMBER, dsa_user_ports(ds));
+			ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(QCA8K_CPU_PORT),
+					QCA8K_PORT_LOOKUP_MEMBER, dsa_user_ports(ds));
+			if (ret)
+				return ret;
 		}
 
 		/* Individual user ports get connected to CPU port only */
 		if (dsa_is_user_port(ds, i)) {
 			int shift = 16 * (i % 2);
 
-			qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
-				  QCA8K_PORT_LOOKUP_MEMBER,
-				  BIT(QCA8K_CPU_PORT));
+			ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
+					QCA8K_PORT_LOOKUP_MEMBER,
+					BIT(QCA8K_CPU_PORT));
+			if (ret)
+				return ret;
 
 			/* Enable ARP Auto-learning by default */
-			qca8k_reg_set(priv, QCA8K_PORT_LOOKUP_CTRL(i),
-				      QCA8K_PORT_LOOKUP_LEARN);
+			ret = qca8k_reg_set(priv, QCA8K_PORT_LOOKUP_CTRL(i),
+					    QCA8K_PORT_LOOKUP_LEARN);
+			if (ret)
+				return ret;
 
 			/* For port based vlans to work we need to set the
 			 * default egress vid
 			 */
-			qca8k_rmw(priv, QCA8K_EGRESS_VLAN(i),
-				  0xfff << shift,
-				  QCA8K_PORT_VID_DEF << shift);
+			ret = qca8k_rmw(priv, QCA8K_EGRESS_VLAN(i),
+					0xfff << shift,
+					QCA8K_PORT_VID_DEF << shift);
+			if (ret)
+				return ret;
+
 			ret = qca8k_write(priv, QCA8K_REG_PORT_VLAN_CTRL0(i),
 					  QCA8K_PORT_VLAN_CVID(QCA8K_PORT_VID_DEF) |
 					  QCA8K_PORT_VLAN_SVID(QCA8K_PORT_VID_DEF));
@@ -1234,7 +1262,7 @@ qca8k_port_bridge_join(struct dsa_switch *ds, int port, struct net_device *br)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 	int port_mask = BIT(QCA8K_CPU_PORT);
-	int i;
+	int i, ret;
 
 	for (i = 1; i < QCA8K_NUM_PORTS; i++) {
 		if (dsa_to_port(ds, i)->bridge_dev != br)
@@ -1242,17 +1270,20 @@ qca8k_port_bridge_join(struct dsa_switch *ds, int port, struct net_device *br)
 		/* Add this port to the portvlan mask of the other ports
 		 * in the bridge
 		 */
-		qca8k_reg_set(priv,
-			      QCA8K_PORT_LOOKUP_CTRL(i),
-			      BIT(port));
+		ret = qca8k_reg_set(priv,
+				    QCA8K_PORT_LOOKUP_CTRL(i),
+				    BIT(port));
+		if (ret)
+			return ret;
 		if (i != port)
 			port_mask |= BIT(i);
 	}
+
 	/* Add all other ports to this ports portvlan mask */
-	qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
-		  QCA8K_PORT_LOOKUP_MEMBER, port_mask);
+	ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
+			QCA8K_PORT_LOOKUP_MEMBER, port_mask);
 
-	return 0;
+	return ret;
 }
 
 static void
@@ -1389,18 +1420,19 @@ qca8k_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
 			  struct netlink_ext_ack *extack)
 {
 	struct qca8k_priv *priv = ds->priv;
+	int ret;
 
 	if (vlan_filtering) {
-		qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
-			  QCA8K_PORT_LOOKUP_VLAN_MODE,
-			  QCA8K_PORT_LOOKUP_VLAN_MODE_SECURE);
+		ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
+				QCA8K_PORT_LOOKUP_VLAN_MODE,
+				QCA8K_PORT_LOOKUP_VLAN_MODE_SECURE);
 	} else {
-		qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
-			  QCA8K_PORT_LOOKUP_VLAN_MODE,
-			  QCA8K_PORT_LOOKUP_VLAN_MODE_NONE);
+		ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
+				QCA8K_PORT_LOOKUP_VLAN_MODE,
+				QCA8K_PORT_LOOKUP_VLAN_MODE_NONE);
 	}
 
-	return 0;
+	return ret;
 }
 
 static int
@@ -1422,16 +1454,17 @@ qca8k_port_vlan_add(struct dsa_switch *ds, int port,
 	if (pvid) {
 		int shift = 16 * (port % 2);
 
-		qca8k_rmw(priv, QCA8K_EGRESS_VLAN(port),
-			  0xfff << shift, vlan->vid << shift);
+		ret = qca8k_rmw(priv, QCA8K_EGRESS_VLAN(port),
+				0xfff << shift, vlan->vid << shift);
+		if (ret)
+			return ret;
+
 		ret = qca8k_write(priv, QCA8K_REG_PORT_VLAN_CTRL0(port),
 				  QCA8K_PORT_VLAN_CVID(vlan->vid) |
 				  QCA8K_PORT_VLAN_SVID(vlan->vid));
-		if (ret)
-			return ret;
 	}
 
-	return 0;
+	return ret;
 }
 
 static int
-- 
2.30.2

