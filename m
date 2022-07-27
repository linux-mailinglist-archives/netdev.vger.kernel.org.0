Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D147A5825AB
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 13:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbiG0Lgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 07:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232213AbiG0LgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 07:36:21 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2851049B59;
        Wed, 27 Jul 2022 04:35:57 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id l23so31001240ejr.5;
        Wed, 27 Jul 2022 04:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=emj/GT5JmzJUsrf2mYkh+NM1juwE9cvNm3oeIvLkIFs=;
        b=lgQImgCWyDxKWU3Py9LKvFXtuJjs+gr1X8OqVQcQ02SinqqP4Ot1JbbCdr8RnyRrYW
         3q+V6jMCugzj7EvwiLWl/IoIPngmenUcTKa+EBnsJQ8vy/fO3hQ35YhAHhVEYSsZLr9V
         mX/JZIkP9pmQKSwaFL1oUZoSJySzfnADoLB3yDP++AGiUXmkQLwraigWw0jYcXE/hGbp
         cKnMaWkkSaLn7yP3OITLbHV+yTaMITe5dPCnYvcO+3R1kmck6lxFv0S3XcYmwGHTBI9B
         1arolvoslTeqEiW/W7WfQGq218kd9FRZlWmVHMhcEl8NLlGvpzfE7wVNm/x6Ja7jze29
         tsPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=emj/GT5JmzJUsrf2mYkh+NM1juwE9cvNm3oeIvLkIFs=;
        b=FGB6btGWP3ciuJ//44dqAVop//fH33geEFDLVNLVCIU/SeS4iKR4F6qlbND7drnknO
         1M2HdCY546vWVdrtih5InYKXRPHd9xt82yzi+ENCT89R7DMqmQTVDekuGmqO0ESVaIG1
         mxdCq1LRGBKQYiGRXReXopy9ZExmNbLTQUqsZxM020BA+U8C3LhgcbPsw1iE/CMtphQK
         /jtyt9sjQXbhtL5Qbp26sdrE7tcco4S/2vyYSHCpvV3FzUeGiOyDlNq4pUFpXx42KZMG
         khLZAX2hsecHH+gUXXCC8Je4alrZV1fi3Z9fycSQWoymJddJRq6Dx559wA7H7nGuw3rz
         eY3w==
X-Gm-Message-State: AJIora9RIHIJIJekyn+n5NJebozoVwxcQjDyRHYAqIJlntZlaBRqqRjj
        M66Pblut7HdAQdDfBrBO+Wk=
X-Google-Smtp-Source: AGRyM1t1wUXtRZIVAHKFfpeIsusgD8bZLdzEySo627OygCnertmSvHdN2VrPtAhqX3+vXq2zi91jjg==
X-Received: by 2002:a17:907:7394:b0:72b:3e52:6262 with SMTP id er20-20020a170907739400b0072b3e526262mr17880914ejc.756.1658921756343;
        Wed, 27 Jul 2022 04:35:56 -0700 (PDT)
Received: from localhost.localdomain (c105-182.i13-27.melita.com. [94.17.105.182])
        by smtp.googlemail.com with ESMTPSA id p25-20020aa7cc99000000b0043ca6fb7e7dsm1334056edt.68.2022.07.27.04.35.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 04:35:55 -0700 (PDT)
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
Subject: [net-next PATCH v5 11/14] net: dsa: qca8k: move port mirror functions to common code
Date:   Wed, 27 Jul 2022 13:35:20 +0200
Message-Id: <20220727113523.19742-12-ansuelsmth@gmail.com>
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

The same port mirror functions are used by drivers based on qca8k family
switch. Move them to common code to make them accessible also by other
drivers.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c   | 93 ------------------------------
 drivers/net/dsa/qca/qca8k-common.c | 91 +++++++++++++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h        |  7 +++
 3 files changed, 98 insertions(+), 93 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index bf4dd1cd0f9d..f6ea5a82da9e 100644
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
index 8e92837781ee..c0a088418c20 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -746,3 +746,94 @@ int qca8k_port_mdb_del(struct dsa_switch *ds, int port,
 
 	return qca8k_fdb_search_and_del(priv, BIT(port), addr, vid);
 }
+
+int qca8k_port_mirror_add(struct dsa_switch *ds, int port,
+			  struct dsa_mall_mirror_tc_entry *mirror,
+			  bool ingress, struct netlink_ext_ack *extack)
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
+void qca8k_port_mirror_del(struct dsa_switch *ds, int port,
+			   struct dsa_mall_mirror_tc_entry *mirror)
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
index 9da7928de83c..3a2131b7abfa 100644
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

