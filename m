Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7982379C7D
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 04:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbhEKCJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 22:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbhEKCIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 22:08:36 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8155C06138B;
        Mon, 10 May 2021 19:07:29 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id d4so18469349wru.7;
        Mon, 10 May 2021 19:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VioibLStxsJzsdnzJDRutTHOKHq5QHL/4DD7hb1v5Xs=;
        b=GGCGy1Or5HIdeIWfJZb0bRGFDnyNPHhDG3pp5L48egvcyqrvWeABvLN5x605ygH00p
         9FxG2g2qS6TZabLiNfZd22/nAXcwGscHwIB6x1HQ1L7szXMeN47NuhfgBJIUhph3hAeY
         H49KCvf1FxPrvOxifOGUn5cXZrgTp++gP35kNFKKB9CjtBh2YhQPLQcJlYpIgu0WlJw3
         LUKVtREbOWicVEKADFnQ19fBp8msqBJ12M9PE5Fial9RwChBlyFnwKo6f9OYVAudF2i9
         eIJDj+Bym0v/kRrorlv4/vjVKgD7nnykHbJoMlHWiPcvH7OW0SrMONd9b6OrXFAB4YlX
         dEtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VioibLStxsJzsdnzJDRutTHOKHq5QHL/4DD7hb1v5Xs=;
        b=Sp5ULYJPd0/Y2nwZ1UGGI5KXFCp/74MuFfouwYM0J5ZFR84Np40zjdkQFLAu5et+GZ
         mukHJWcyPkTvR+q10vQH2WsiHMSjnp5TcpkJUZzNknt+xucElA6AgoWuSZQ9uIy12lTi
         mTbWN1ZOwJjx2mpvmRnje5bMVUfH9/AobziSlmjVtipCi0JeT1Xfa+qgIhEi6xampq+X
         HahmDPPnOo3NLz+oCgIWh3J+9zBo7v+LyMZ50LC1SLsK9vjkbZYcLUNT6IHUQf5oJ7in
         SHDwFqoXgVEaRTUjcZOyjIJYTrypUbJNhV1Qws+2QHF3DScdl5Bw6Gd+i2xQBcfVxlO2
         cOfg==
X-Gm-Message-State: AOAM533JaEKvBwZtdoYmmBKypoQm8jS8QDPril26ZnQzgJZdLAU50/jT
        /V+U9N0T59BnndDUyTb45iA=
X-Google-Smtp-Source: ABdhPJySBJBbxv76SN2p9PMuEZDfRYz9esmFjtgTVwo6Nz69uhG1rP7RopE4Y+HXwkCqQZwzP/6pgw==
X-Received: by 2002:a5d:4b42:: with SMTP id w2mr35157915wrs.248.1620698848232;
        Mon, 10 May 2021 19:07:28 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q20sm2607436wmq.2.2021.05.10.19.07.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 19:07:27 -0700 (PDT)
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
Subject: [RFC PATCH net-next v5 06/25] net: dsa: qca8k: handle error with qca8k_write operation
Date:   Tue, 11 May 2021 04:04:41 +0200
Message-Id: <20210511020500.17269-7-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210511020500.17269-1-ansuelsmth@gmail.com>
References: <20210511020500.17269-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qca8k_write can fail. Rework any user to handle error values and
correctly return.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/qca8k.c | 102 ++++++++++++++++++++++++++--------------
 1 file changed, 67 insertions(+), 35 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 5eb4d13fe0ba..2fdd7c2e74d5 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -168,7 +168,7 @@ qca8k_read(struct qca8k_priv *priv, u32 reg)
 	return val;
 }
 
-static void
+static int
 qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val)
 {
 	struct mii_bus *bus = priv->bus;
@@ -187,6 +187,7 @@ qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val)
 
 exit:
 	mutex_unlock(&bus->mdio_lock);
+	return ret;
 }
 
 static u32
@@ -247,9 +248,7 @@ qca8k_regmap_write(void *ctx, uint32_t reg, uint32_t val)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
 
-	qca8k_write(priv, reg, val);
-
-	return 0;
+	return qca8k_write(priv, reg, val);
 }
 
 static const struct regmap_range qca8k_readable_ranges[] = {
@@ -367,6 +366,7 @@ static int
 qca8k_fdb_access(struct qca8k_priv *priv, enum qca8k_fdb_cmd cmd, int port)
 {
 	u32 reg;
+	int ret;
 
 	/* Set the command and FDB index */
 	reg = QCA8K_ATU_FUNC_BUSY;
@@ -377,7 +377,9 @@ qca8k_fdb_access(struct qca8k_priv *priv, enum qca8k_fdb_cmd cmd, int port)
 	}
 
 	/* Write the function register triggering the table access */
-	qca8k_write(priv, QCA8K_REG_ATU_FUNC, reg);
+	ret = qca8k_write(priv, QCA8K_REG_ATU_FUNC, reg);
+	if (ret)
+		return ret;
 
 	/* wait for completion */
 	if (qca8k_busy_wait(priv, QCA8K_REG_ATU_FUNC, QCA8K_ATU_FUNC_BUSY))
@@ -447,6 +449,7 @@ static int
 qca8k_vlan_access(struct qca8k_priv *priv, enum qca8k_vlan_cmd cmd, u16 vid)
 {
 	u32 reg;
+	int ret;
 
 	/* Set the command and VLAN index */
 	reg = QCA8K_VTU_FUNC1_BUSY;
@@ -454,7 +457,9 @@ qca8k_vlan_access(struct qca8k_priv *priv, enum qca8k_vlan_cmd cmd, u16 vid)
 	reg |= vid << QCA8K_VTU_FUNC1_VID_S;
 
 	/* Write the function register triggering the table access */
-	qca8k_write(priv, QCA8K_REG_VTU_FUNC1, reg);
+	ret = qca8k_write(priv, QCA8K_REG_VTU_FUNC1, reg);
+	if (ret)
+		return ret;
 
 	/* wait for completion */
 	if (qca8k_busy_wait(priv, QCA8K_REG_VTU_FUNC1, QCA8K_VTU_FUNC1_BUSY))
@@ -502,7 +507,9 @@ qca8k_vlan_add(struct qca8k_priv *priv, u8 port, u16 vid, bool untagged)
 		reg |= QCA8K_VTU_FUNC0_EG_MODE_TAG <<
 				QCA8K_VTU_FUNC0_EG_MODE_S(port);
 
-	qca8k_write(priv, QCA8K_REG_VTU_FUNC0, reg);
+	ret = qca8k_write(priv, QCA8K_REG_VTU_FUNC0, reg);
+	if (ret)
+		return ret;
 	ret = qca8k_vlan_access(priv, QCA8K_VLAN_LOAD, vid);
 
 out:
@@ -545,7 +552,9 @@ qca8k_vlan_del(struct qca8k_priv *priv, u8 port, u16 vid)
 	if (del) {
 		ret = qca8k_vlan_access(priv, QCA8K_VLAN_PURGE, vid);
 	} else {
-		qca8k_write(priv, QCA8K_REG_VTU_FUNC0, reg);
+		ret = qca8k_write(priv, QCA8K_REG_VTU_FUNC0, reg);
+		if (ret)
+			return ret;
 		ret = qca8k_vlan_access(priv, QCA8K_VLAN_LOAD, vid);
 	}
 
@@ -555,15 +564,20 @@ qca8k_vlan_del(struct qca8k_priv *priv, u8 port, u16 vid)
 	return ret;
 }
 
-static void
+static int
 qca8k_mib_init(struct qca8k_priv *priv)
 {
+	int ret;
+
 	mutex_lock(&priv->reg_mutex);
 	qca8k_reg_set(priv, QCA8K_REG_MIB, QCA8K_MIB_FLUSH | QCA8K_MIB_BUSY);
 	qca8k_busy_wait(priv, QCA8K_REG_MIB, QCA8K_MIB_BUSY);
 	qca8k_reg_set(priv, QCA8K_REG_MIB, QCA8K_MIB_CPU_KEEP);
-	qca8k_write(priv, QCA8K_REG_MODULE_EN, QCA8K_MODULE_EN_MIB);
+
+	ret = qca8k_write(priv, QCA8K_REG_MODULE_EN, QCA8K_MODULE_EN_MIB);
+
 	mutex_unlock(&priv->reg_mutex);
+	return ret;
 }
 
 static void
@@ -600,6 +614,7 @@ static int
 qca8k_mdio_write(struct qca8k_priv *priv, int port, u32 regnum, u16 data)
 {
 	u32 phy, val;
+	int ret;
 
 	if (regnum >= QCA8K_MDIO_MASTER_MAX_REG)
 		return -EINVAL;
@@ -613,7 +628,9 @@ qca8k_mdio_write(struct qca8k_priv *priv, int port, u32 regnum, u16 data)
 	      QCA8K_MDIO_MASTER_REG_ADDR(regnum) |
 	      QCA8K_MDIO_MASTER_DATA(data);
 
-	qca8k_write(priv, QCA8K_MDIO_MASTER_CTRL, val);
+	ret = qca8k_write(priv, QCA8K_MDIO_MASTER_CTRL, val);
+	if (ret)
+		return ret;
 
 	return qca8k_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
 		QCA8K_MDIO_MASTER_BUSY);
@@ -623,6 +640,7 @@ static int
 qca8k_mdio_read(struct qca8k_priv *priv, int port, u32 regnum)
 {
 	u32 phy, val;
+	int ret;
 
 	if (regnum >= QCA8K_MDIO_MASTER_MAX_REG)
 		return -EINVAL;
@@ -635,7 +653,9 @@ qca8k_mdio_read(struct qca8k_priv *priv, int port, u32 regnum)
 	      QCA8K_MDIO_MASTER_READ | QCA8K_MDIO_MASTER_PHY_ADDR(phy) |
 	      QCA8K_MDIO_MASTER_REG_ADDR(regnum);
 
-	qca8k_write(priv, QCA8K_MDIO_MASTER_CTRL, val);
+	ret = qca8k_write(priv, QCA8K_MDIO_MASTER_CTRL, val);
+	if (ret)
+		return ret;
 
 	if (qca8k_busy_wait(priv, QCA8K_MDIO_MASTER_CTRL,
 			    QCA8K_MDIO_MASTER_BUSY))
@@ -766,12 +786,18 @@ qca8k_setup(struct dsa_switch *ds)
 		      QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
 
 	/* Enable MIB counters */
-	qca8k_mib_init(priv);
+	ret = qca8k_mib_init(priv);
+	if (ret)
+		dev_warn(priv->dev, "mib init failed");
 
 	/* Enable QCA header mode on the cpu port */
-	qca8k_write(priv, QCA8K_REG_PORT_HDR_CTRL(QCA8K_CPU_PORT),
-		    QCA8K_PORT_HDR_CTRL_ALL << QCA8K_PORT_HDR_CTRL_TX_S |
-		    QCA8K_PORT_HDR_CTRL_ALL << QCA8K_PORT_HDR_CTRL_RX_S);
+	ret = qca8k_write(priv, QCA8K_REG_PORT_HDR_CTRL(QCA8K_CPU_PORT),
+			  QCA8K_PORT_HDR_CTRL_ALL << QCA8K_PORT_HDR_CTRL_TX_S |
+			  QCA8K_PORT_HDR_CTRL_ALL << QCA8K_PORT_HDR_CTRL_RX_S);
+	if (ret) {
+		dev_err(priv->dev, "failed enabling QCA header mode");
+		return ret;
+	}
 
 	/* Disable forwarding by default on all ports */
 	for (i = 0; i < QCA8K_NUM_PORTS; i++)
@@ -783,11 +809,13 @@ qca8k_setup(struct dsa_switch *ds)
 		qca8k_port_set_status(priv, i, 0);
 
 	/* Forward all unknown frames to CPU port for Linux processing */
-	qca8k_write(priv, QCA8K_REG_GLOBAL_FW_CTRL1,
-		    BIT(0) << QCA8K_GLOBAL_FW_CTRL1_IGMP_DP_S |
-		    BIT(0) << QCA8K_GLOBAL_FW_CTRL1_BC_DP_S |
-		    BIT(0) << QCA8K_GLOBAL_FW_CTRL1_MC_DP_S |
-		    BIT(0) << QCA8K_GLOBAL_FW_CTRL1_UC_DP_S);
+	ret = qca8k_write(priv, QCA8K_REG_GLOBAL_FW_CTRL1,
+			  BIT(0) << QCA8K_GLOBAL_FW_CTRL1_IGMP_DP_S |
+			  BIT(0) << QCA8K_GLOBAL_FW_CTRL1_BC_DP_S |
+			  BIT(0) << QCA8K_GLOBAL_FW_CTRL1_MC_DP_S |
+			  BIT(0) << QCA8K_GLOBAL_FW_CTRL1_UC_DP_S);
+	if (ret)
+		return ret;
 
 	/* Setup connection between CPU port & user ports */
 	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
@@ -815,16 +843,20 @@ qca8k_setup(struct dsa_switch *ds)
 			qca8k_rmw(priv, QCA8K_EGRESS_VLAN(i),
 				  0xfff << shift,
 				  QCA8K_PORT_VID_DEF << shift);
-			qca8k_write(priv, QCA8K_REG_PORT_VLAN_CTRL0(i),
-				    QCA8K_PORT_VLAN_CVID(QCA8K_PORT_VID_DEF) |
-				    QCA8K_PORT_VLAN_SVID(QCA8K_PORT_VID_DEF));
+			ret = qca8k_write(priv, QCA8K_REG_PORT_VLAN_CTRL0(i),
+					  QCA8K_PORT_VLAN_CVID(QCA8K_PORT_VID_DEF) |
+					  QCA8K_PORT_VLAN_SVID(QCA8K_PORT_VID_DEF));
+			if (ret)
+				return ret;
 		}
 	}
 
 	/* Setup our port MTUs to match power on defaults */
 	for (i = 0; i < QCA8K_NUM_PORTS; i++)
 		priv->port_mtu[i] = ETH_FRAME_LEN + ETH_FCS_LEN;
-	qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, ETH_FRAME_LEN + ETH_FCS_LEN);
+	ret = qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, ETH_FRAME_LEN + ETH_FCS_LEN);
+	if (ret)
+		dev_warn(priv->dev, "failed setting MTU settings");
 
 	/* Flush the FDB table */
 	qca8k_fdb_flush(priv);
@@ -1140,8 +1172,8 @@ qca8k_set_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *eee)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 	u32 lpi_en = QCA8K_REG_EEE_CTRL_LPI_EN(port);
-	int ret = 0;
 	u32 reg;
+	int ret;
 
 	mutex_lock(&priv->reg_mutex);
 	reg = qca8k_read(priv, QCA8K_REG_EEE_CTRL);
@@ -1154,7 +1186,7 @@ qca8k_set_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *eee)
 		reg |= lpi_en;
 	else
 		reg &= ~lpi_en;
-	qca8k_write(priv, QCA8K_REG_EEE_CTRL, reg);
+	ret = qca8k_write(priv, QCA8K_REG_EEE_CTRL, reg);
 
 exit:
 	mutex_unlock(&priv->reg_mutex);
@@ -1284,9 +1316,7 @@ qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 			mtu = priv->port_mtu[i];
 
 	/* Include L2 header / FCS length */
-	qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, mtu + ETH_HLEN + ETH_FCS_LEN);
-
-	return 0;
+	return qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, mtu + ETH_HLEN + ETH_FCS_LEN);
 }
 
 static int
@@ -1381,7 +1411,7 @@ qca8k_port_vlan_add(struct dsa_switch *ds, int port,
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
 	struct qca8k_priv *priv = ds->priv;
-	int ret = 0;
+	int ret;
 
 	ret = qca8k_vlan_add(priv, port, vlan->vid, untagged);
 	if (ret) {
@@ -1394,9 +1424,11 @@ qca8k_port_vlan_add(struct dsa_switch *ds, int port,
 
 		qca8k_rmw(priv, QCA8K_EGRESS_VLAN(port),
 			  0xfff << shift, vlan->vid << shift);
-		qca8k_write(priv, QCA8K_REG_PORT_VLAN_CTRL0(port),
-			    QCA8K_PORT_VLAN_CVID(vlan->vid) |
-			    QCA8K_PORT_VLAN_SVID(vlan->vid));
+		ret = qca8k_write(priv, QCA8K_REG_PORT_VLAN_CTRL0(port),
+				  QCA8K_PORT_VLAN_CVID(vlan->vid) |
+				  QCA8K_PORT_VLAN_SVID(vlan->vid));
+		if (ret)
+			return ret;
 	}
 
 	return 0;
@@ -1407,7 +1439,7 @@ qca8k_port_vlan_del(struct dsa_switch *ds, int port,
 		    const struct switchdev_obj_port_vlan *vlan)
 {
 	struct qca8k_priv *priv = ds->priv;
-	int ret = 0;
+	int ret;
 
 	ret = qca8k_vlan_del(priv, port, vlan->vid);
 	if (ret)
-- 
2.30.2

