Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3E657EF8A
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 16:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238039AbiGWOVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 10:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237884AbiGWOUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 10:20:40 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 239641DA64;
        Sat, 23 Jul 2022 07:20:02 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id i205-20020a1c3bd6000000b003a2fa488efdso974068wma.4;
        Sat, 23 Jul 2022 07:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=XHuqDfZjUiv/Pct3ADFVGCHcS7jsYg7ypsV6B70Sggs=;
        b=O8FewJkuKZ2kdvnVzqXSca2Gt55IR4nd+y6z2PP/i9LqLqYPDbMzhk1t2XEGrAL/Ge
         W0qEcVVmLaxT3J10uCiyKhdLjBOw3ljyLX97/d/he5YhU/1DycbgcT2+AmZ4mIkJbIbN
         tw19VcF/0nDyYoaHQk+FK8eFiVfXApSy1ZM+rU1ahS3Bg5liG78a36yGEKki7S7BexhK
         Cd9jYNCF190hznEb4S9Kb8GeP/x+uBMIys7t+UhyIpNzVXu5kn8+BhbBgSaIdL9Uf6/P
         OHs8tjXG2hF7MbhHVmvIkbSRzR7Yf/NRLasJTHoeqwQaEX6eI/CTIG//3UnfwVf0Hujn
         /Ydw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XHuqDfZjUiv/Pct3ADFVGCHcS7jsYg7ypsV6B70Sggs=;
        b=bSvpVQCsFj7F9CcyoL/p1J1P/zBfKThnzSfRbiPxjZjvY37P24Yh2ocbFj5VVmtaTc
         ODQz5E9LsXxzX2iSIxPxtXvXBc09M+8gdXDJgVufJJe1uIcF5SrE3HZUdixea4RUd2Lp
         z2zalF6l5nQ0MAksEXl4gaNux7gpso8eXQa7+OR2whXSNeEkadngxEaAvuDDarf3ErE+
         D0KJCcHP9Rk7f2T3nQKr1nv4q2GtxD6K03fkTBdLajNwWZZeu44wbCY85Gwb21c9twm9
         umGh4lPQHsT7TpMAjZoO9IzDF4lC7bUSfs675lhMj28bxefVeynpj+pnhyVLonoYw8wo
         8OIQ==
X-Gm-Message-State: AJIora/WiH1wNIPJDi1pEn2xGVeTzewIJTcFoDUi0e/qclekemnJ60f+
        8kioeeJnhwEndwT3FLFzQrIr17n/XbQ=
X-Google-Smtp-Source: AGRyM1usUqyjK5aljhUErWiVZUqnMcmP+Jq4xpcw3CgEtiaABIG13kLhVSH/Uew9xMmkVNw47hvdqQ==
X-Received: by 2002:a05:600c:2e48:b0:3a3:1ce3:3036 with SMTP id q8-20020a05600c2e4800b003a31ce33036mr15055674wmf.188.1658586002293;
        Sat, 23 Jul 2022 07:20:02 -0700 (PDT)
Received: from localhost.localdomain (host-87-7-207-127.retail.telecomitalia.it. [87.7.207.127])
        by smtp.googlemail.com with ESMTPSA id l18-20020a05600c1d1200b003a04d19dab3sm21011960wms.3.2022.07.23.07.19.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jul 2022 07:20:01 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [net-next PATCH v3 12/14] net: dsa: qca8k: move port VLAN functions to common code
Date:   Sat, 23 Jul 2022 16:18:43 +0200
Message-Id: <20220723141845.10570-13-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220723141845.10570-1-ansuelsmth@gmail.com>
References: <20220723141845.10570-1-ansuelsmth@gmail.com>
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
 drivers/net/dsa/qca/qca8k-8xxx.c   | 181 ----------------------------
 drivers/net/dsa/qca/qca8k-common.c | 182 ++++++++++++++++++++++++++++-
 drivers/net/dsa/qca/qca8k.h        |  10 +-
 3 files changed, 190 insertions(+), 183 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 8beee566b97e..d6494eac8c6d 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -441,122 +441,6 @@ static struct regmap_config qca8k_regmap_config = {
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
@@ -1687,71 +1571,6 @@ qca8k_get_ethtool_stats_eth(struct dsa_switch *ds, int port, u64 *data)
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
index 92f715d8ed94..5d6eeda4c142 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -140,7 +140,7 @@ static int qca8k_bulk_write(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 	return 0;
 }
 
-int
+static int
 qca8k_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
 {
 	u32 val;
@@ -359,6 +359,121 @@ qca8k_fdb_search_and_del(struct qca8k_priv *priv, u8 port_mask,
 	return ret;
 }
 
+static int
+qca8k_vlan_access(struct qca8k_priv *priv, enum qca8k_vlan_cmd cmd, u16 vid)
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
+static int
+qca8k_vlan_add(struct qca8k_priv *priv, u8 port, u16 vid, bool untagged)
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
+static int
+qca8k_vlan_del(struct qca8k_priv *priv, u8 port, u16 vid)
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
@@ -859,3 +974,68 @@ qca8k_port_mirror_del(struct dsa_switch *ds, int port,
 err:
 	dev_err(priv->dev, "Failed to del mirror port from %d", port);
 }
+
+int
+qca8k_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
+			  struct netlink_ext_ack *extack)
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
+int
+qca8k_port_vlan_add(struct dsa_switch *ds, int port,
+		    const struct switchdev_obj_port_vlan *vlan,
+		    struct netlink_ext_ack *extack)
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
+int
+qca8k_port_vlan_del(struct dsa_switch *ds, int port,
+		    const struct switchdev_obj_port_vlan *vlan)
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
index 02eda8f6c48e..d97fbbe12e2f 100644
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

