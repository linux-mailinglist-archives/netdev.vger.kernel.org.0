Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80C5357EF7E
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 16:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237577AbiGWOVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 10:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237544AbiGWOUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 10:20:30 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7714D1D0FD;
        Sat, 23 Jul 2022 07:19:59 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id z13so9990252wro.13;
        Sat, 23 Jul 2022 07:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=f02mJb46qKiM/a+Ar90zPCZVqzmm7XinmDYc73lLAuk=;
        b=Peux2phdu7A5Qzy+Lniv3hNgv0zNMjsrX3dkveSv3L4LV3WU+g327zl3EqCNsGGNOk
         uuJq8jfjVu3rVISIsLqWBVeRGDzrDiAxyui6v1UyrBi5pvZgcWpZRVXkE70o6l6L8/v8
         jL7yzSGvSW7phJiOaKf+LKJ8eGLwmT3movkyXDF49O3SV65NDTzDCMCLNDRrgeEuc6yu
         PPn1uWdjRUKe9zpG9uuM3Jqja5JpkbHVDBSOPaxDmmvqFtbcRjupC5yhDR8Jnf5RCrEO
         hnanoWdq7TEUZvvnTEhYBJ+c87r6SGBLZGEEGEVfSQDjZZXaJ6J2aFq0ZvbLYke1vqlD
         0iXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f02mJb46qKiM/a+Ar90zPCZVqzmm7XinmDYc73lLAuk=;
        b=uUrKkat8Xr6I9A1PK7/XyAasd/SQoMonpvqCRf1zDLGnigilsVLEEcTckvCFvlKPSQ
         ASaY8fTE7FRkpledDrSr0FWLCnFyq8ZquoFKeWzczgSQ5znXo/nB6bUfwQS410tOLbHi
         ylf6L5a/4ojYWpqBipxrRP0Mmzt/T86r/fQ9m3RgJBH1eiUBma2/9o++XEKB5/7ykqHG
         jZKydOPRXcUHTOnNoA+iUvqDejb2f/dgdUM+0AvUvhxVn37uvwrK2Aw71dRPv3Q9KVDI
         Dt4YYKPQlN43NCLiuaRFsqaPeVhWBMucKy8rsoUqVgjhY9ua6nd0bgJmgDp+i0v3veeF
         pUeA==
X-Gm-Message-State: AJIora92GZVWWY2V7ayfMfADQJKepgBdO2XVnEzFnPgQ5Sx1eOUiZPzy
        iZuvPrYJlXTju5Rovgo5cz8=
X-Google-Smtp-Source: AGRyM1sS5yXR3fXyX2E2oGqCLrQfI6kVCrlLEBrACBDO+Sv8QQ9mCe4LTSccQi3fZqw189o1tE26vQ==
X-Received: by 2002:adf:f905:0:b0:21d:f460:1acf with SMTP id b5-20020adff905000000b0021df4601acfmr2773748wrr.108.1658585998693;
        Sat, 23 Jul 2022 07:19:58 -0700 (PDT)
Received: from localhost.localdomain (host-87-7-207-127.retail.telecomitalia.it. [87.7.207.127])
        by smtp.googlemail.com with ESMTPSA id l18-20020a05600c1d1200b003a04d19dab3sm21011960wms.3.2022.07.23.07.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jul 2022 07:19:58 -0700 (PDT)
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
Subject: [net-next PATCH v3 11/14] net: dsa: qca8k: move port mirror functions to common code
Date:   Sat, 23 Jul 2022 16:18:42 +0200
Message-Id: <20220723141845.10570-12-ansuelsmth@gmail.com>
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

The same port mirror functions are used by drivers based on qca8k family
switch. Move them to common code to make them accessible also by other
drivers.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c   | 93 ------------------------------
 drivers/net/dsa/qca/qca8k-common.c | 93 ++++++++++++++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h        |  7 +++
 3 files changed, 100 insertions(+), 93 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 52a9e0a2a532..8beee566b97e 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -1687,99 +1687,6 @@ qca8k_get_ethtool_stats_eth(struct dsa_switch *ds, int port, u64 *data)
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
index 557f73db7530..92f715d8ed94 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -766,3 +766,96 @@ qca8k_port_mdb_del(struct dsa_switch *ds, int port,
 
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
index f336aa929afc..02eda8f6c48e 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -494,4 +494,11 @@ int qca8k_port_mdb_del(struct dsa_switch *ds, int port,
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

