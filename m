Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4965825B3
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 13:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbiG0Lgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 07:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbiG0Lgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 07:36:36 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E934B49B6D;
        Wed, 27 Jul 2022 04:35:59 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id z15so9210235edc.7;
        Wed, 27 Jul 2022 04:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=avF5wLxx2Zfmm599FR13rOs75WXYhwlJqUIz5CV3ZW0=;
        b=E15UcQxzWzHb7ZYxdMycHuVFE/h1HNcydww0DnpoizVP51TCA4+CHYQbSk/PzQEHTs
         kPPZwbrcVLUB1I2HkCADyOPkPtnRhpNpQA8T3cRnDma4rn+EV4ZqCbwXkpLoIeSx/G2u
         CpiEVsmur4wwuRB2qnRLWLSmsRt2xrFYBqxkezkBdMILB9EnLWEg9LOEzCvm9xb5B2nG
         w6fbnhkm96kvULM2wbcPd6o/GC9rpiRTx+H1P3fNosOesF0NhsAjUA1qqoKeMic01I1O
         7MoqKKX3eWWVUGrlkjyKhrdy80DnXbrXa6WyMWp4Ec2EYGHQ8nH2+Qz42xYH63qnFkO9
         KQGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=avF5wLxx2Zfmm599FR13rOs75WXYhwlJqUIz5CV3ZW0=;
        b=oexSOiP8bMlL8VqtWNGZAhqkuW+w8asOXn4WGv1sGbaGEkMQdNv3ZID9R8BTvXfGUx
         ZCiETnDEoUOqbeHNwqWgWtYzPepoE0jgvzqNDg6Pv29tG1nvMQCOktQ3cYwCkTU57TdZ
         4wClan6HjG+NK7xGN7/RbFqYPbjB6+ND3sZXj5AVRJIPdfvTCn7vXxPY4R6yzNBMUXDB
         uRZ+jeHJeoR1x8RU92VfUEW+kfri6epOq/krwvmFnVotqe11e7+KJSHLrE7zFy1w1JKH
         MOo1Da9Kxi7gtdCZyuwtefivfo7Uhic+mzSC8sTWjZzPAL4aJKfP42uC+PqLr839132S
         4bPA==
X-Gm-Message-State: AJIora8kLcmbde2JM+KhTYrAu85cgN6Tjg9pTkpEV8iD3re0V+Q0xxBM
        g6IDC7DAVpguPCEB2wDvPik=
X-Google-Smtp-Source: AGRyM1vU0L9BkCNjyY1XoqFNYLySQKkimOvFgUFzSJNvKP2pJpA/C0CyW9BKFhgAslyaOMbHsR+YdQ==
X-Received: by 2002:aa7:d753:0:b0:43b:a7df:60b0 with SMTP id a19-20020aa7d753000000b0043ba7df60b0mr22631913eds.191.1658921757949;
        Wed, 27 Jul 2022 04:35:57 -0700 (PDT)
Received: from localhost.localdomain (c105-182.i13-27.melita.com. [94.17.105.182])
        by smtp.googlemail.com with ESMTPSA id p25-20020aa7cc99000000b0043ca6fb7e7dsm1334056edt.68.2022.07.27.04.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 04:35:57 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [net-next PATCH v5 12/14] net: dsa: qca8k: move port VLAN functions to common code
Date:   Wed, 27 Jul 2022 13:35:21 +0200
Message-Id: <20220727113523.19742-13-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220727113523.19742-1-ansuelsmth@gmail.com>
References: <20220727113523.19742-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The same port VLAN functions are used by drivers based on qca8k family
switch. Move them to common code to make them accessible also by other
drivers.
Also drop exposing busy_wait and make it static.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c   | 182 -----------------------------
 drivers/net/dsa/qca/qca8k-common.c | 179 +++++++++++++++++++++++++++-
 drivers/net/dsa/qca/qca8k.h        |  10 +-
 3 files changed, 187 insertions(+), 184 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index f6ea5a82da9e..545f86e3c6ed 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -15,7 +15,6 @@
 #include <linux/of_net.h>
 #include <linux/of_mdio.h>
 #include <linux/of_platform.h>
-#include <linux/if_bridge.h>
 #include <linux/mdio.h>
 #include <linux/phylink.h>
 #include <linux/gpio/consumer.h>
@@ -441,122 +440,6 @@ static struct regmap_config qca8k_regmap_config = {
 	.cache_type = REGCACHE_NONE, /* Explicitly disable CACHE */
 };
 
-static int
-qca8k_vlan_access(struct qca8k_priv *priv, enum qca8k_vlan_cmd cmd, u16 vid)
-{
-	u32 reg;
-	int ret;
-
-	/* Set the command and VLAN index */
-	reg = QCA8K_VTU_FUNC1_BUSY;
-	reg |= cmd;
-	reg |= FIELD_PREP(QCA8K_VTU_FUNC1_VID_MASK, vid);
-
-	/* Write the function register triggering the table access */
-	ret = qca8k_write(priv, QCA8K_REG_VTU_FUNC1, reg);
-	if (ret)
-		return ret;
-
-	/* wait for completion */
-	ret = qca8k_busy_wait(priv, QCA8K_REG_VTU_FUNC1, QCA8K_VTU_FUNC1_BUSY);
-	if (ret)
-		return ret;
-
-	/* Check for table full violation when adding an entry */
-	if (cmd == QCA8K_VLAN_LOAD) {
-		ret = qca8k_read(priv, QCA8K_REG_VTU_FUNC1, &reg);
-		if (ret < 0)
-			return ret;
-		if (reg & QCA8K_VTU_FUNC1_FULL)
-			return -ENOMEM;
-	}
-
-	return 0;
-}
-
-static int
-qca8k_vlan_add(struct qca8k_priv *priv, u8 port, u16 vid, bool untagged)
-{
-	u32 reg;
-	int ret;
-
-	/*
-	   We do the right thing with VLAN 0 and treat it as untagged while
-	   preserving the tag on egress.
-	 */
-	if (vid == 0)
-		return 0;
-
-	mutex_lock(&priv->reg_mutex);
-	ret = qca8k_vlan_access(priv, QCA8K_VLAN_READ, vid);
-	if (ret < 0)
-		goto out;
-
-	ret = qca8k_read(priv, QCA8K_REG_VTU_FUNC0, &reg);
-	if (ret < 0)
-		goto out;
-	reg |= QCA8K_VTU_FUNC0_VALID | QCA8K_VTU_FUNC0_IVL_EN;
-	reg &= ~QCA8K_VTU_FUNC0_EG_MODE_PORT_MASK(port);
-	if (untagged)
-		reg |= QCA8K_VTU_FUNC0_EG_MODE_PORT_UNTAG(port);
-	else
-		reg |= QCA8K_VTU_FUNC0_EG_MODE_PORT_TAG(port);
-
-	ret = qca8k_write(priv, QCA8K_REG_VTU_FUNC0, reg);
-	if (ret)
-		goto out;
-	ret = qca8k_vlan_access(priv, QCA8K_VLAN_LOAD, vid);
-
-out:
-	mutex_unlock(&priv->reg_mutex);
-
-	return ret;
-}
-
-static int
-qca8k_vlan_del(struct qca8k_priv *priv, u8 port, u16 vid)
-{
-	u32 reg, mask;
-	int ret, i;
-	bool del;
-
-	mutex_lock(&priv->reg_mutex);
-	ret = qca8k_vlan_access(priv, QCA8K_VLAN_READ, vid);
-	if (ret < 0)
-		goto out;
-
-	ret = qca8k_read(priv, QCA8K_REG_VTU_FUNC0, &reg);
-	if (ret < 0)
-		goto out;
-	reg &= ~QCA8K_VTU_FUNC0_EG_MODE_PORT_MASK(port);
-	reg |= QCA8K_VTU_FUNC0_EG_MODE_PORT_NOT(port);
-
-	/* Check if we're the last member to be removed */
-	del = true;
-	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
-		mask = QCA8K_VTU_FUNC0_EG_MODE_PORT_NOT(i);
-
-		if ((reg & mask) != mask) {
-			del = false;
-			break;
-		}
-	}
-
-	if (del) {
-		ret = qca8k_vlan_access(priv, QCA8K_VLAN_PURGE, vid);
-	} else {
-		ret = qca8k_write(priv, QCA8K_REG_VTU_FUNC0, reg);
-		if (ret)
-			goto out;
-		ret = qca8k_vlan_access(priv, QCA8K_VLAN_LOAD, vid);
-	}
-
-out:
-	mutex_unlock(&priv->reg_mutex);
-
-	return ret;
-}
-
 static int
 qca8k_phy_eth_busy_wait(struct qca8k_mgmt_eth_data *mgmt_eth_data,
 			struct sk_buff *read_skb, u32 *val)
@@ -1687,71 +1570,6 @@ qca8k_get_ethtool_stats_eth(struct dsa_switch *ds, int port, u64 *data)
 	return ret;
 }
 
-static int
-qca8k_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
-			  struct netlink_ext_ack *extack)
-{
-	struct qca8k_priv *priv = ds->priv;
-	int ret;
-
-	if (vlan_filtering) {
-		ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
-				QCA8K_PORT_LOOKUP_VLAN_MODE_MASK,
-				QCA8K_PORT_LOOKUP_VLAN_MODE_SECURE);
-	} else {
-		ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
-				QCA8K_PORT_LOOKUP_VLAN_MODE_MASK,
-				QCA8K_PORT_LOOKUP_VLAN_MODE_NONE);
-	}
-
-	return ret;
-}
-
-static int
-qca8k_port_vlan_add(struct dsa_switch *ds, int port,
-		    const struct switchdev_obj_port_vlan *vlan,
-		    struct netlink_ext_ack *extack)
-{
-	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
-	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
-	struct qca8k_priv *priv = ds->priv;
-	int ret;
-
-	ret = qca8k_vlan_add(priv, port, vlan->vid, untagged);
-	if (ret) {
-		dev_err(priv->dev, "Failed to add VLAN to port %d (%d)", port, ret);
-		return ret;
-	}
-
-	if (pvid) {
-		ret = qca8k_rmw(priv, QCA8K_EGRESS_VLAN(port),
-				QCA8K_EGREES_VLAN_PORT_MASK(port),
-				QCA8K_EGREES_VLAN_PORT(port, vlan->vid));
-		if (ret)
-			return ret;
-
-		ret = qca8k_write(priv, QCA8K_REG_PORT_VLAN_CTRL0(port),
-				  QCA8K_PORT_VLAN_CVID(vlan->vid) |
-				  QCA8K_PORT_VLAN_SVID(vlan->vid));
-	}
-
-	return ret;
-}
-
-static int
-qca8k_port_vlan_del(struct dsa_switch *ds, int port,
-		    const struct switchdev_obj_port_vlan *vlan)
-{
-	struct qca8k_priv *priv = ds->priv;
-	int ret;
-
-	ret = qca8k_vlan_del(priv, port, vlan->vid);
-	if (ret)
-		dev_err(priv->dev, "Failed to delete VLAN from port %d (%d)", port, ret);
-
-	return ret;
-}
-
 static u32 qca8k_get_phy_flags(struct dsa_switch *ds, int port)
 {
 	struct qca8k_priv *priv = ds->priv;
diff --git a/drivers/net/dsa/qca/qca8k-common.c b/drivers/net/dsa/qca/qca8k-common.c
index c0a088418c20..0e5ce532accd 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -140,7 +140,7 @@ static int qca8k_bulk_write(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 	return 0;
 }
 
-int qca8k_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
+static int qca8k_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
 {
 	u32 val;
 
@@ -353,6 +353,120 @@ static int qca8k_fdb_search_and_del(struct qca8k_priv *priv, u8 port_mask,
 	return ret;
 }
 
+static int qca8k_vlan_access(struct qca8k_priv *priv,
+			     enum qca8k_vlan_cmd cmd, u16 vid)
+{
+	u32 reg;
+	int ret;
+
+	/* Set the command and VLAN index */
+	reg = QCA8K_VTU_FUNC1_BUSY;
+	reg |= cmd;
+	reg |= FIELD_PREP(QCA8K_VTU_FUNC1_VID_MASK, vid);
+
+	/* Write the function register triggering the table access */
+	ret = qca8k_write(priv, QCA8K_REG_VTU_FUNC1, reg);
+	if (ret)
+		return ret;
+
+	/* wait for completion */
+	ret = qca8k_busy_wait(priv, QCA8K_REG_VTU_FUNC1, QCA8K_VTU_FUNC1_BUSY);
+	if (ret)
+		return ret;
+
+	/* Check for table full violation when adding an entry */
+	if (cmd == QCA8K_VLAN_LOAD) {
+		ret = qca8k_read(priv, QCA8K_REG_VTU_FUNC1, &reg);
+		if (ret < 0)
+			return ret;
+		if (reg & QCA8K_VTU_FUNC1_FULL)
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int qca8k_vlan_add(struct qca8k_priv *priv, u8 port, u16 vid,
+			  bool untagged)
+{
+	u32 reg;
+	int ret;
+
+	/* We do the right thing with VLAN 0 and treat it as untagged while
+	 * preserving the tag on egress.
+	 */
+	if (vid == 0)
+		return 0;
+
+	mutex_lock(&priv->reg_mutex);
+	ret = qca8k_vlan_access(priv, QCA8K_VLAN_READ, vid);
+	if (ret < 0)
+		goto out;
+
+	ret = qca8k_read(priv, QCA8K_REG_VTU_FUNC0, &reg);
+	if (ret < 0)
+		goto out;
+	reg |= QCA8K_VTU_FUNC0_VALID | QCA8K_VTU_FUNC0_IVL_EN;
+	reg &= ~QCA8K_VTU_FUNC0_EG_MODE_PORT_MASK(port);
+	if (untagged)
+		reg |= QCA8K_VTU_FUNC0_EG_MODE_PORT_UNTAG(port);
+	else
+		reg |= QCA8K_VTU_FUNC0_EG_MODE_PORT_TAG(port);
+
+	ret = qca8k_write(priv, QCA8K_REG_VTU_FUNC0, reg);
+	if (ret)
+		goto out;
+	ret = qca8k_vlan_access(priv, QCA8K_VLAN_LOAD, vid);
+
+out:
+	mutex_unlock(&priv->reg_mutex);
+
+	return ret;
+}
+
+static int qca8k_vlan_del(struct qca8k_priv *priv, u8 port, u16 vid)
+{
+	u32 reg, mask;
+	int ret, i;
+	bool del;
+
+	mutex_lock(&priv->reg_mutex);
+	ret = qca8k_vlan_access(priv, QCA8K_VLAN_READ, vid);
+	if (ret < 0)
+		goto out;
+
+	ret = qca8k_read(priv, QCA8K_REG_VTU_FUNC0, &reg);
+	if (ret < 0)
+		goto out;
+	reg &= ~QCA8K_VTU_FUNC0_EG_MODE_PORT_MASK(port);
+	reg |= QCA8K_VTU_FUNC0_EG_MODE_PORT_NOT(port);
+
+	/* Check if we're the last member to be removed */
+	del = true;
+	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
+		mask = QCA8K_VTU_FUNC0_EG_MODE_PORT_NOT(i);
+
+		if ((reg & mask) != mask) {
+			del = false;
+			break;
+		}
+	}
+
+	if (del) {
+		ret = qca8k_vlan_access(priv, QCA8K_VLAN_PURGE, vid);
+	} else {
+		ret = qca8k_write(priv, QCA8K_REG_VTU_FUNC0, reg);
+		if (ret)
+			goto out;
+		ret = qca8k_vlan_access(priv, QCA8K_VLAN_LOAD, vid);
+	}
+
+out:
+	mutex_unlock(&priv->reg_mutex);
+
+	return ret;
+}
+
 int qca8k_mib_init(struct qca8k_priv *priv)
 {
 	int ret;
@@ -837,3 +951,66 @@ void qca8k_port_mirror_del(struct dsa_switch *ds, int port,
 err:
 	dev_err(priv->dev, "Failed to del mirror port from %d", port);
 }
+
+int qca8k_port_vlan_filtering(struct dsa_switch *ds, int port,
+			      bool vlan_filtering,
+			      struct netlink_ext_ack *extack)
+{
+	struct qca8k_priv *priv = ds->priv;
+	int ret;
+
+	if (vlan_filtering) {
+		ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
+				QCA8K_PORT_LOOKUP_VLAN_MODE_MASK,
+				QCA8K_PORT_LOOKUP_VLAN_MODE_SECURE);
+	} else {
+		ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
+				QCA8K_PORT_LOOKUP_VLAN_MODE_MASK,
+				QCA8K_PORT_LOOKUP_VLAN_MODE_NONE);
+	}
+
+	return ret;
+}
+
+int qca8k_port_vlan_add(struct dsa_switch *ds, int port,
+			const struct switchdev_obj_port_vlan *vlan,
+			struct netlink_ext_ack *extack)
+{
+	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
+	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
+	struct qca8k_priv *priv = ds->priv;
+	int ret;
+
+	ret = qca8k_vlan_add(priv, port, vlan->vid, untagged);
+	if (ret) {
+		dev_err(priv->dev, "Failed to add VLAN to port %d (%d)", port, ret);
+		return ret;
+	}
+
+	if (pvid) {
+		ret = qca8k_rmw(priv, QCA8K_EGRESS_VLAN(port),
+				QCA8K_EGREES_VLAN_PORT_MASK(port),
+				QCA8K_EGREES_VLAN_PORT(port, vlan->vid));
+		if (ret)
+			return ret;
+
+		ret = qca8k_write(priv, QCA8K_REG_PORT_VLAN_CTRL0(port),
+				  QCA8K_PORT_VLAN_CVID(vlan->vid) |
+				  QCA8K_PORT_VLAN_SVID(vlan->vid));
+	}
+
+	return ret;
+}
+
+int qca8k_port_vlan_del(struct dsa_switch *ds, int port,
+			const struct switchdev_obj_port_vlan *vlan)
+{
+	struct qca8k_priv *priv = ds->priv;
+	int ret;
+
+	ret = qca8k_vlan_del(priv, port, vlan->vid);
+	if (ret)
+		dev_err(priv->dev, "Failed to delete VLAN from port %d (%d)", port, ret);
+
+	return ret;
+}
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index 3a2131b7abfa..91f7abc5beb1 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -439,7 +439,6 @@ int qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val);
 int qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val);
 
 /* Common ops function */
-int qca8k_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask);
 void qca8k_fdb_flush(struct qca8k_priv *priv);
 
 /* Common ethtool stats function */
@@ -501,4 +500,13 @@ int qca8k_port_mirror_add(struct dsa_switch *ds, int port,
 void qca8k_port_mirror_del(struct dsa_switch *ds, int port,
 			   struct dsa_mall_mirror_tc_entry *mirror);
 
+/* Common port VLAN function */
+int qca8k_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
+			      struct netlink_ext_ack *extack);
+int qca8k_port_vlan_add(struct dsa_switch *ds, int port,
+			const struct switchdev_obj_port_vlan *vlan,
+			struct netlink_ext_ack *extack);
+int qca8k_port_vlan_del(struct dsa_switch *ds, int port,
+			const struct switchdev_obj_port_vlan *vlan);
+
 #endif /* __QCA8K_H */
-- 
2.36.1

