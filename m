Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1C1578FAD
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 03:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236779AbiGSBQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 21:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236757AbiGSBP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 21:15:29 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC23E039;
        Mon, 18 Jul 2022 18:15:22 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id p4so8119086wms.0;
        Mon, 18 Jul 2022 18:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=M1jrJPDQYBd3weJPN35rpfjPwJ3d7cMx2myYJBnTZ/w=;
        b=gjN/k9wbMqiMsFmopLw6nNZsgav/q3/mpXbBAcJiO/qfSVygffSvG8hDbOv8CB/ntX
         NnY1p1ztjwqAzhMH2Yw57ehEyLXp6cNGUcUVLCGPugF1/XVcliYpnvmHsGHWgdZjEG4m
         UFr9NxExVT4vJMPDD08xqh5eo6FTjsFnL22r60XDgqXHVsUwV89K2QG8/OX29CdjQUtf
         QU7FDwYt/vxSZY4WHh2jDgpUlE926pJUelf0deed7NydlWPsK5Gi+gOXkW1lPQx0CK+4
         pw8DwicJzrC1h/ylOM7WD5HS4YjKahIQtWsZHtRctgkZG6B6KdoD1oPakvNglx008o7A
         hChw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M1jrJPDQYBd3weJPN35rpfjPwJ3d7cMx2myYJBnTZ/w=;
        b=h2CUvz7axgZbwp7AuiQjm9h9lnAxCLiO3nDIV/OfT+gC46kYPlxxgLRFEXDoHdZrVw
         nMWUEJJEYHyROCSM4Q2KbrKgRlga/i8B+3Q4xWW0NEsf3eN3BLa/ubsKm3GgQKjH+kF7
         YjhVp6i1Unp0JxKD3sLtKmmuAMG1+Nh1ypXSpKUQzWI87YNHeEAxf7Gigo6+jHZ9RRHT
         IH8JhrkNyL/MlDsc+xc/Qs/2GBM058hWIO1K2lWTlQa1N4loHvIMI95r6jeFsFubCSL9
         9yrYFUHuZIj3sqe1AUTNIWkPSw7yQpSSex/BrjIBMJG03HIjfVp9kPWV0iHGLyaa9p3M
         jGjQ==
X-Gm-Message-State: AJIora8S4klvVkmhQH61TbR5lhASUe2/T8OIkHc1ILPXF50y12ZIa6xU
        ehY0akDYkZ58YAgfcWnTF5I=
X-Google-Smtp-Source: AGRyM1suEgInJmB8watYdmfva/l4pSVCN6wZ4GR+JaSPhmC02CiVR+3ddYQqbP1reHAV43wB7xia4A==
X-Received: by 2002:a1c:4444:0:b0:3a2:fe56:e8ca with SMTP id r65-20020a1c4444000000b003a2fe56e8camr24818970wma.21.1658193321235;
        Mon, 18 Jul 2022 18:15:21 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id y11-20020adff14b000000b0021db7b0162esm11840239wro.105.2022.07.18.18.15.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 18:15:20 -0700 (PDT)
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
Subject: [net-next PATCH v2 11/15] net: dsa: qca8k: move port mirror functions to common code
Date:   Tue, 19 Jul 2022 02:57:22 +0200
Message-Id: <20220719005726.8739-13-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220719005726.8739-1-ansuelsmth@gmail.com>
References: <20220719005726.8739-1-ansuelsmth@gmail.com>
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

The same port mirror functions are used by drivers based on qca8k family
switch. Move them to common code to make them accessible also by other
drivers.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c   | 93 ------------------------------
 drivers/net/dsa/qca/qca8k-common.c | 93 ++++++++++++++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h        |  7 +++
 3 files changed, 100 insertions(+), 93 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 776c53aef5c4..d12ba61841b9 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -1575,99 +1575,6 @@ qca8k_get_ethtool_stats_eth(struct dsa_switch *ds, int port, u64 *data)
 	return ret;
 }
 
-static int
-qca8k_port_mirror_add(struct dsa_switch *ds, int port,
-		      struct dsa_mall_mirror_tc_entry *mirror,
-		      bool ingress, struct netlink_ext_ack *extack)
-{
-	struct qca8k_priv *priv = ds->priv;
-	int monitor_port, ret;
-	u32 reg, val;
-
-	/* Check for existent entry */
-	if ((ingress ? priv->mirror_rx : priv->mirror_tx) & BIT(port))
-		return -EEXIST;
-
-	ret = regmap_read(priv->regmap, QCA8K_REG_GLOBAL_FW_CTRL0, &val);
-	if (ret)
-		return ret;
-
-	/* QCA83xx can have only one port set to mirror mode.
-	 * Check that the correct port is requested and return error otherwise.
-	 * When no mirror port is set, the values is set to 0xF
-	 */
-	monitor_port = FIELD_GET(QCA8K_GLOBAL_FW_CTRL0_MIRROR_PORT_NUM, val);
-	if (monitor_port != 0xF && monitor_port != mirror->to_local_port)
-		return -EEXIST;
-
-	/* Set the monitor port */
-	val = FIELD_PREP(QCA8K_GLOBAL_FW_CTRL0_MIRROR_PORT_NUM,
-			 mirror->to_local_port);
-	ret = regmap_update_bits(priv->regmap, QCA8K_REG_GLOBAL_FW_CTRL0,
-				 QCA8K_GLOBAL_FW_CTRL0_MIRROR_PORT_NUM, val);
-	if (ret)
-		return ret;
-
-	if (ingress) {
-		reg = QCA8K_PORT_LOOKUP_CTRL(port);
-		val = QCA8K_PORT_LOOKUP_ING_MIRROR_EN;
-	} else {
-		reg = QCA8K_REG_PORT_HOL_CTRL1(port);
-		val = QCA8K_PORT_HOL_CTRL1_EG_MIRROR_EN;
-	}
-
-	ret = regmap_update_bits(priv->regmap, reg, val, val);
-	if (ret)
-		return ret;
-
-	/* Track mirror port for tx and rx to decide when the
-	 * mirror port has to be disabled.
-	 */
-	if (ingress)
-		priv->mirror_rx |= BIT(port);
-	else
-		priv->mirror_tx |= BIT(port);
-
-	return 0;
-}
-
-static void
-qca8k_port_mirror_del(struct dsa_switch *ds, int port,
-		      struct dsa_mall_mirror_tc_entry *mirror)
-{
-	struct qca8k_priv *priv = ds->priv;
-	u32 reg, val;
-	int ret;
-
-	if (mirror->ingress) {
-		reg = QCA8K_PORT_LOOKUP_CTRL(port);
-		val = QCA8K_PORT_LOOKUP_ING_MIRROR_EN;
-	} else {
-		reg = QCA8K_REG_PORT_HOL_CTRL1(port);
-		val = QCA8K_PORT_HOL_CTRL1_EG_MIRROR_EN;
-	}
-
-	ret = regmap_clear_bits(priv->regmap, reg, val);
-	if (ret)
-		goto err;
-
-	if (mirror->ingress)
-		priv->mirror_rx &= ~BIT(port);
-	else
-		priv->mirror_tx &= ~BIT(port);
-
-	/* No port set to send packet to mirror port. Disable mirror port */
-	if (!priv->mirror_rx && !priv->mirror_tx) {
-		val = FIELD_PREP(QCA8K_GLOBAL_FW_CTRL0_MIRROR_PORT_NUM, 0xF);
-		ret = regmap_update_bits(priv->regmap, QCA8K_REG_GLOBAL_FW_CTRL0,
-					 QCA8K_GLOBAL_FW_CTRL0_MIRROR_PORT_NUM, val);
-		if (ret)
-			goto err;
-	}
-err:
-	dev_err(priv->dev, "Failed to del mirror port from %d", port);
-}
-
 static int
 qca8k_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
 			  struct netlink_ext_ack *extack)
diff --git a/drivers/net/dsa/qca/qca8k-common.c b/drivers/net/dsa/qca/qca8k-common.c
index 796293738b35..2f3a1343b13c 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -898,3 +898,96 @@ qca8k_port_mdb_del(struct dsa_switch *ds, int port,
 
 	return qca8k_fdb_search_and_del(priv, BIT(port), addr, vid);
 }
+
+int
+qca8k_port_mirror_add(struct dsa_switch *ds, int port,
+		      struct dsa_mall_mirror_tc_entry *mirror,
+		      bool ingress, struct netlink_ext_ack *extack)
+{
+	struct qca8k_priv *priv = ds->priv;
+	int monitor_port, ret;
+	u32 reg, val;
+
+	/* Check for existent entry */
+	if ((ingress ? priv->mirror_rx : priv->mirror_tx) & BIT(port))
+		return -EEXIST;
+
+	ret = regmap_read(priv->regmap, QCA8K_REG_GLOBAL_FW_CTRL0, &val);
+	if (ret)
+		return ret;
+
+	/* QCA83xx can have only one port set to mirror mode.
+	 * Check that the correct port is requested and return error otherwise.
+	 * When no mirror port is set, the values is set to 0xF
+	 */
+	monitor_port = FIELD_GET(QCA8K_GLOBAL_FW_CTRL0_MIRROR_PORT_NUM, val);
+	if (monitor_port != 0xF && monitor_port != mirror->to_local_port)
+		return -EEXIST;
+
+	/* Set the monitor port */
+	val = FIELD_PREP(QCA8K_GLOBAL_FW_CTRL0_MIRROR_PORT_NUM,
+			 mirror->to_local_port);
+	ret = regmap_update_bits(priv->regmap, QCA8K_REG_GLOBAL_FW_CTRL0,
+				 QCA8K_GLOBAL_FW_CTRL0_MIRROR_PORT_NUM, val);
+	if (ret)
+		return ret;
+
+	if (ingress) {
+		reg = QCA8K_PORT_LOOKUP_CTRL(port);
+		val = QCA8K_PORT_LOOKUP_ING_MIRROR_EN;
+	} else {
+		reg = QCA8K_REG_PORT_HOL_CTRL1(port);
+		val = QCA8K_PORT_HOL_CTRL1_EG_MIRROR_EN;
+	}
+
+	ret = regmap_update_bits(priv->regmap, reg, val, val);
+	if (ret)
+		return ret;
+
+	/* Track mirror port for tx and rx to decide when the
+	 * mirror port has to be disabled.
+	 */
+	if (ingress)
+		priv->mirror_rx |= BIT(port);
+	else
+		priv->mirror_tx |= BIT(port);
+
+	return 0;
+}
+
+void
+qca8k_port_mirror_del(struct dsa_switch *ds, int port,
+		      struct dsa_mall_mirror_tc_entry *mirror)
+{
+	struct qca8k_priv *priv = ds->priv;
+	u32 reg, val;
+	int ret;
+
+	if (mirror->ingress) {
+		reg = QCA8K_PORT_LOOKUP_CTRL(port);
+		val = QCA8K_PORT_LOOKUP_ING_MIRROR_EN;
+	} else {
+		reg = QCA8K_REG_PORT_HOL_CTRL1(port);
+		val = QCA8K_PORT_HOL_CTRL1_EG_MIRROR_EN;
+	}
+
+	ret = regmap_clear_bits(priv->regmap, reg, val);
+	if (ret)
+		goto err;
+
+	if (mirror->ingress)
+		priv->mirror_rx &= ~BIT(port);
+	else
+		priv->mirror_tx &= ~BIT(port);
+
+	/* No port set to send packet to mirror port. Disable mirror port */
+	if (!priv->mirror_rx && !priv->mirror_tx) {
+		val = FIELD_PREP(QCA8K_GLOBAL_FW_CTRL0_MIRROR_PORT_NUM, 0xF);
+		ret = regmap_update_bits(priv->regmap, QCA8K_REG_GLOBAL_FW_CTRL0,
+					 QCA8K_GLOBAL_FW_CTRL0_MIRROR_PORT_NUM, val);
+		if (ret)
+			goto err;
+	}
+err:
+	dev_err(priv->dev, "Failed to del mirror port from %d", port);
+}
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index 31f6f98960d6..c9c8ec7abdc2 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -502,4 +502,11 @@ int qca8k_port_mdb_del(struct dsa_switch *ds, int port,
 		       const struct switchdev_obj_port_mdb *mdb,
 		       struct dsa_db db);
 
+/* Common port mirror function */
+int qca8k_port_mirror_add(struct dsa_switch *ds, int port,
+			  struct dsa_mall_mirror_tc_entry *mirror,
+			  bool ingress, struct netlink_ext_ack *extack);
+void qca8k_port_mirror_del(struct dsa_switch *ds, int port,
+			   struct dsa_mall_mirror_tc_entry *mirror);
+
 #endif /* __QCA8K_H */
-- 
2.36.1

