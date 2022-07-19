Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8F4578FB9
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 03:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236690AbiGSBP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 21:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236630AbiGSBPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 21:15:19 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EFF3B4AE;
        Mon, 18 Jul 2022 18:15:16 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id j1so14988887wrs.4;
        Mon, 18 Jul 2022 18:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=KudmMtIF0Iopljdpb/EuvtfLfuApsMUVKUxZOnhSPz0=;
        b=F7MD/6wqz6sPW3NVR6UgZ5UPwkXprPI5hfe/lsruD/hGWJ12qtrCpuvqd3B+Nad/Z5
         s/fqbLkLoZ+KKFrNkvplVwT3mgQNMlKlkI1KNJQRvnf31KUzjy/Qs68u9YjkJIRDU30J
         HLEglSRSa9oODlRF5Jk7bBZMNz8LA2vhonNtdyF2xDzxSKmG9BMcdTk2jeeor2xu0dNe
         vmk4W36f9jI6RRGtAcm9b7wGkXl/IdDG8/cATLV6qlxKKPpDlQgZ0huD2boqkU4z0Xjk
         wKTWWlGXysUL1nZk5t8cjI6DDELyyVDmTfnbzXkANyMSxTXkWvzJy6xmdYyNgZluttV3
         9aRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KudmMtIF0Iopljdpb/EuvtfLfuApsMUVKUxZOnhSPz0=;
        b=SxfsErxPF4gdN8FPoZ/C5u8+JaFD0CIJ5Jv+Yj/pkQhJDOxEVS/9bYc74SwKNJjViY
         pD0XZ2UMZ3TuNRC1BIK6S7nhppzHeCPvNHR5LOWdjt7OI06RLcUqZ7WdL/lnnECXn9lw
         POL8EeVcPakllh13E6tVxvEFfs6Rm5Q2Bvt56b04GisX8f74ctz0tg32NWy/z34pqxoc
         Nnoa9b32Pt1c6aNG6IJVr5nH8ra9gopE3TaM//Sr+FAUrLw1L/QL6tA69c8NzptrSgCo
         Kj7BDVslTlXvjmmL+mPforEnNWk5lpMot/IJa8wUns478S41PxnwwIH+17rv37pVfSp1
         VUfg==
X-Gm-Message-State: AJIora+t61SWe2HXD3Ny7CyXmbr9n3uWWQ1T3HZ5HUruO9vZ2w2WZxPn
        NVaFEoXhI+fIj/3ZFuwUBGk=
X-Google-Smtp-Source: AGRyM1ujHTHC8NXOkaLFuZCoYxz6Z6ZzxM0uvA58+fmmTIqcdTGpbKHkN+yTeWXVwp9rkNowxGEZIA==
X-Received: by 2002:a05:6000:1541:b0:21d:b298:96be with SMTP id 1-20020a056000154100b0021db29896bemr24503884wry.206.1658193315471;
        Mon, 18 Jul 2022 18:15:15 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id y11-20020adff14b000000b0021db7b0162esm11840239wro.105.2022.07.18.18.15.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 18:15:15 -0700 (PDT)
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
Subject: [net-next PATCH v2 06/15] net: dsa: qca8k: move port set status/eee/ethtool stats function to common code
Date:   Tue, 19 Jul 2022 02:57:17 +0200
Message-Id: <20220719005726.8739-8-ansuelsmth@gmail.com>
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

The same logic to disable/enable port, set eee and get ethtool stats is
used by drivers based on qca8k family switch.
Move it to common code to make it accessible also by other drivers.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c   | 114 -----------------------------
 drivers/net/dsa/qca/qca8k-common.c | 114 +++++++++++++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h        |  11 +++
 3 files changed, 125 insertions(+), 114 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index e17567a4b99f..23b4cd6b68ff 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -441,21 +441,6 @@ static struct regmap_config qca8k_regmap_config = {
 	.cache_type = REGCACHE_NONE, /* Explicitly disable CACHE */
 };
 
-static void
-qca8k_port_set_status(struct qca8k_priv *priv, int port, int enable)
-{
-	u32 mask = QCA8K_PORT_STATUS_TXMAC | QCA8K_PORT_STATUS_RXMAC;
-
-	/* Port 0 and 6 have no internal PHY */
-	if (port > 0 && port < 6)
-		mask |= QCA8K_PORT_STATUS_LINK_AUTO;
-
-	if (enable)
-		regmap_set_bits(priv->regmap, QCA8K_REG_PORT_STATUS(port), mask);
-	else
-		regmap_clear_bits(priv->regmap, QCA8K_REG_PORT_STATUS(port), mask);
-}
-
 static int
 qca8k_phy_eth_busy_wait(struct qca8k_mgmt_eth_data *mgmt_eth_data,
 			struct sk_buff *read_skb, u32 *val)
@@ -1499,23 +1484,6 @@ static void qca8k_setup_pcs(struct qca8k_priv *priv, struct qca8k_pcs *qpcs,
 	qpcs->port = port;
 }
 
-static void
-qca8k_get_strings(struct dsa_switch *ds, int port, u32 stringset, uint8_t *data)
-{
-	const struct qca8k_match_data *match_data;
-	struct qca8k_priv *priv = ds->priv;
-	int i;
-
-	if (stringset != ETH_SS_STATS)
-		return;
-
-	match_data = of_device_get_match_data(priv->dev);
-
-	for (i = 0; i < match_data->mib_count; i++)
-		strncpy(data + i * ETH_GSTRING_LEN, ar8327_mib[i].name,
-			ETH_GSTRING_LEN);
-}
-
 static void qca8k_mib_autocast_handler(struct dsa_switch *ds, struct sk_buff *skb)
 {
 	const struct qca8k_match_data *match_data;
@@ -1607,88 +1575,6 @@ qca8k_get_ethtool_stats_eth(struct dsa_switch *ds, int port, u64 *data)
 	return ret;
 }
 
-static void
-qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
-			uint64_t *data)
-{
-	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
-	const struct qca8k_match_data *match_data;
-	const struct qca8k_mib_desc *mib;
-	u32 reg, i, val;
-	u32 hi = 0;
-	int ret;
-
-	match_data = of_device_get_match_data(priv->dev);
-
-	if (priv->mgmt_master && match_data->autocast_mib &&
-	    match_data->autocast_mib(ds, port, data) > 0)
-		return;
-
-	for (i = 0; i < match_data->mib_count; i++) {
-		mib = &ar8327_mib[i];
-		reg = QCA8K_PORT_MIB_COUNTER(port) + mib->offset;
-
-		ret = qca8k_read(priv, reg, &val);
-		if (ret < 0)
-			continue;
-
-		if (mib->size == 2) {
-			ret = qca8k_read(priv, reg + 4, &hi);
-			if (ret < 0)
-				continue;
-		}
-
-		data[i] = val;
-		if (mib->size == 2)
-			data[i] |= (u64)hi << 32;
-	}
-}
-
-static int
-qca8k_get_sset_count(struct dsa_switch *ds, int port, int sset)
-{
-	const struct qca8k_match_data *match_data;
-	struct qca8k_priv *priv = ds->priv;
-
-	if (sset != ETH_SS_STATS)
-		return 0;
-
-	match_data = of_device_get_match_data(priv->dev);
-
-	return match_data->mib_count;
-}
-
-static int
-qca8k_set_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *eee)
-{
-	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
-	u32 lpi_en = QCA8K_REG_EEE_CTRL_LPI_EN(port);
-	u32 reg;
-	int ret;
-
-	mutex_lock(&priv->reg_mutex);
-	ret = qca8k_read(priv, QCA8K_REG_EEE_CTRL, &reg);
-	if (ret < 0)
-		goto exit;
-
-	if (eee->eee_enabled)
-		reg |= lpi_en;
-	else
-		reg &= ~lpi_en;
-	ret = qca8k_write(priv, QCA8K_REG_EEE_CTRL, reg);
-
-exit:
-	mutex_unlock(&priv->reg_mutex);
-	return ret;
-}
-
-static int
-qca8k_get_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *e)
-{
-	/* Nothing to do on the port's MAC */
-	return 0;
-}
-
 static void
 qca8k_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 {
diff --git a/drivers/net/dsa/qca/qca8k-common.c b/drivers/net/dsa/qca/qca8k-common.c
index 926a66363cf8..466ea9f9470b 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -507,3 +507,117 @@ int qca8k_mib_init(struct qca8k_priv *priv)
 	mutex_unlock(&priv->reg_mutex);
 	return ret;
 }
+
+void
+qca8k_port_set_status(struct qca8k_priv *priv, int port, int enable)
+{
+	u32 mask = QCA8K_PORT_STATUS_TXMAC | QCA8K_PORT_STATUS_RXMAC;
+
+	/* Port 0 and 6 have no internal PHY */
+	if (port > 0 && port < 6)
+		mask |= QCA8K_PORT_STATUS_LINK_AUTO;
+
+	if (enable)
+		regmap_set_bits(priv->regmap, QCA8K_REG_PORT_STATUS(port), mask);
+	else
+		regmap_clear_bits(priv->regmap, QCA8K_REG_PORT_STATUS(port), mask);
+}
+
+void
+qca8k_get_strings(struct dsa_switch *ds, int port, u32 stringset, uint8_t *data)
+{
+	const struct qca8k_match_data *match_data;
+	struct qca8k_priv *priv = ds->priv;
+	int i;
+
+	if (stringset != ETH_SS_STATS)
+		return;
+
+	match_data = of_device_get_match_data(priv->dev);
+
+	for (i = 0; i < match_data->mib_count; i++)
+		strncpy(data + i * ETH_GSTRING_LEN, ar8327_mib[i].name,
+			ETH_GSTRING_LEN);
+}
+
+void
+qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
+			uint64_t *data)
+{
+	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
+	const struct qca8k_match_data *match_data;
+	const struct qca8k_mib_desc *mib;
+	u32 reg, i, val;
+	u32 hi = 0;
+	int ret;
+
+	match_data = of_device_get_match_data(priv->dev);
+
+	if (priv->mgmt_master && match_data->autocast_mib &&
+	    match_data->autocast_mib(ds, port, data) > 0)
+		return;
+
+	for (i = 0; i < match_data->mib_count; i++) {
+		mib = &ar8327_mib[i];
+		reg = QCA8K_PORT_MIB_COUNTER(port) + mib->offset;
+
+		ret = qca8k_read(priv, reg, &val);
+		if (ret < 0)
+			continue;
+
+		if (mib->size == 2) {
+			ret = qca8k_read(priv, reg + 4, &hi);
+			if (ret < 0)
+				continue;
+		}
+
+		data[i] = val;
+		if (mib->size == 2)
+			data[i] |= (u64)hi << 32;
+	}
+}
+
+int
+qca8k_get_sset_count(struct dsa_switch *ds, int port, int sset)
+{
+	const struct qca8k_match_data *match_data;
+	struct qca8k_priv *priv = ds->priv;
+
+	if (sset != ETH_SS_STATS)
+		return 0;
+
+	match_data = of_device_get_match_data(priv->dev);
+
+	return match_data->mib_count;
+}
+
+int
+qca8k_set_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *eee)
+{
+	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
+	u32 lpi_en = QCA8K_REG_EEE_CTRL_LPI_EN(port);
+	u32 reg;
+	int ret;
+
+	mutex_lock(&priv->reg_mutex);
+	ret = qca8k_read(priv, QCA8K_REG_EEE_CTRL, &reg);
+	if (ret < 0)
+		goto exit;
+
+	if (eee->eee_enabled)
+		reg |= lpi_en;
+	else
+		reg &= ~lpi_en;
+	ret = qca8k_write(priv, QCA8K_REG_EEE_CTRL, reg);
+
+exit:
+	mutex_unlock(&priv->reg_mutex);
+	return ret;
+}
+
+int
+qca8k_get_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *e)
+{
+	/* Nothing to do on the port's MAC */
+	return 0;
+}
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index f9493354d74f..c842564eb61b 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -426,6 +426,7 @@ struct qca8k_fdb {
 extern const struct qca8k_mib_desc ar8327_mib[];
 extern const struct regmap_access_table qca8k_readable_table;
 int qca8k_mib_init(struct qca8k_priv *priv);
+void qca8k_port_set_status(struct qca8k_priv *priv, int port, int enable);
 
 /* Common read/write/rmw function */
 int qca8k_read(struct qca8k_priv *priv, u32 reg, u32 *val);
@@ -449,4 +450,14 @@ int qca8k_fdb_search_and_del(struct qca8k_priv *priv, u8 port_mask,
 int qca8k_vlan_add(struct qca8k_priv *priv, u8 port, u16 vid, bool untagged);
 int qca8k_vlan_del(struct qca8k_priv *priv, u8 port, u16 vid);
 
+/* Common ethtool stats function */
+void qca8k_get_strings(struct dsa_switch *ds, int port, u32 stringset, uint8_t *data);
+void qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
+			     uint64_t *data);
+int qca8k_get_sset_count(struct dsa_switch *ds, int port, int sset);
+
+/* Common eee function */
+int qca8k_set_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *eee);
+int qca8k_get_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *e);
+
 #endif /* __QCA8K_H */
-- 
2.36.1

