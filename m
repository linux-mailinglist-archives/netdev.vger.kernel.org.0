Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBE255825A7
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 13:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbiG0LgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 07:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbiG0Lf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 07:35:59 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0B3249B77;
        Wed, 27 Jul 2022 04:35:50 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id i13so11895893edj.11;
        Wed, 27 Jul 2022 04:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=BrcRJrRL1mdEcQ9vrbLqXfCvzLdFsi0MkSYpD5fiXqc=;
        b=l3NYnw+VyWRUi963Sm3wT3q3K8s5dmp0aeqpsE6xaIcu33lc7b4nc9IBDNzUV8Q5Ga
         oajkhcpgghgT23OoSRqv4JUWF3Xx6eqsbkxUtDYwudekd9LIybgRt9yxSR6kAEdy9v4H
         GgzMropU9u6XqA55Dl5cPitr+84F0LVDNiJ0MSRwBvyJE3ZDJYqdF+DkrhRKI+MVAXVU
         iAudxmtjWJZa8HJtIMX2R+zKSeHZ17NI3ibawde2yJ2PSEsywODwcKyVgtCpThLdlnt6
         fLJ607pJwtGFbZQ8lkFU0R0i5ooFWTLjP+roIRLH41AtV/+cZ+ybe1vX5D+CjO68X8/f
         XGSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BrcRJrRL1mdEcQ9vrbLqXfCvzLdFsi0MkSYpD5fiXqc=;
        b=T3/oIYR1+99p3EFb0BtcSlBuxAZNWLrconMaCUBU91r1+fm8GIJ35u7uIPXSBX9xMO
         rrXKUW2mNVPEv6E+XATri4tRRjF7g0IVdGPTWp/buipgeNHOtpX0ySoBfetfFN3bIiIy
         hzI+T3YE4X6kqfcCb/+U52yXDo6B/l9aGy21JH2bXN3KVu+h2WvMiufhY838Hj3HMuwe
         A6dfklY3D8SfgQM6p3lSg4XjrDx6xwQNwbeLdGJS34/IjW/THLlx0UaKbUa2ouHh+9br
         7Phaz3fb+J3pJSyUNRZYSklK3lEcfxnpcuScAr/rGuIByfXW8j/WqclVkje0PoSmasxD
         pDSw==
X-Gm-Message-State: AJIora/f+eBJkL6nI++01ezF9Dig2LD/CzB4DniG1sn+vzP11xK7BklX
        SRZ72o3jBTLJagTNEzuhum4=
X-Google-Smtp-Source: AGRyM1v6osgV/lh80RdKMZ/SDAUD9aQSX0f58yGjbGOLwhD9MbaoyoD9FTC4x+kfW9+ORyj6icAu5g==
X-Received: by 2002:a05:6402:3685:b0:43b:dfd3:9487 with SMTP id ej5-20020a056402368500b0043bdfd39487mr21088108edb.32.1658921750168;
        Wed, 27 Jul 2022 04:35:50 -0700 (PDT)
Received: from localhost.localdomain (c105-182.i13-27.melita.com. [94.17.105.182])
        by smtp.googlemail.com with ESMTPSA id p25-20020aa7cc99000000b0043ca6fb7e7dsm1334056edt.68.2022.07.27.04.35.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 04:35:49 -0700 (PDT)
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
Subject: [net-next PATCH v5 07/14] net: dsa: qca8k: move port set status/eee/ethtool stats function to common code
Date:   Wed, 27 Jul 2022 13:35:16 +0200
Message-Id: <20220727113523.19742-8-ansuelsmth@gmail.com>
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

The same logic to disable/enable port, set eee and get ethtool stats is
used by drivers based on qca8k family switch.
Move it to common code to make it accessible also by other drivers.
While at it also drop unnecessary qca8k_priv cast for void pointers.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c   | 105 -----------------------------
 drivers/net/dsa/qca/qca8k-common.c | 102 ++++++++++++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h        |  11 +++
 3 files changed, 113 insertions(+), 105 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index b4daa097a7fc..9729aabbd83d 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -768,21 +768,6 @@ qca8k_vlan_del(struct qca8k_priv *priv, u8 port, u16 vid)
 	return ret;
 }
 
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
@@ -1824,20 +1809,6 @@ static void qca8k_setup_pcs(struct qca8k_priv *priv, struct qca8k_pcs *qpcs,
 	qpcs->port = port;
 }
 
-static void
-qca8k_get_strings(struct dsa_switch *ds, int port, u32 stringset, uint8_t *data)
-{
-	struct qca8k_priv *priv = ds->priv;
-	int i;
-
-	if (stringset != ETH_SS_STATS)
-		return;
-
-	for (i = 0; i < priv->info->mib_count; i++)
-		strncpy(data + i * ETH_GSTRING_LEN, ar8327_mib[i].name,
-			ETH_GSTRING_LEN);
-}
-
 static void qca8k_mib_autocast_handler(struct dsa_switch *ds, struct sk_buff *skb)
 {
 	struct qca8k_mib_eth_data *mib_eth_data;
@@ -1927,82 +1898,6 @@ qca8k_get_ethtool_stats_eth(struct dsa_switch *ds, int port, u64 *data)
 	return ret;
 }
 
-static void
-qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
-			uint64_t *data)
-{
-	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
-	const struct qca8k_mib_desc *mib;
-	u32 reg, i, val;
-	u32 hi = 0;
-	int ret;
-
-	if (priv->mgmt_master && priv->info->ops->autocast_mib &&
-	    priv->info->ops->autocast_mib(ds, port, data) > 0)
-		return;
-
-	for (i = 0; i < priv->info->mib_count; i++) {
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
-	struct qca8k_priv *priv = ds->priv;
-
-	if (sset != ETH_SS_STATS)
-		return 0;
-
-	return priv->info->mib_count;
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
index 7da3547f9d97..c662fdbae51f 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -173,3 +173,105 @@ int qca8k_mib_init(struct qca8k_priv *priv)
 	mutex_unlock(&priv->reg_mutex);
 	return ret;
 }
+
+void qca8k_port_set_status(struct qca8k_priv *priv, int port, int enable)
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
+void qca8k_get_strings(struct dsa_switch *ds, int port, u32 stringset,
+		       uint8_t *data)
+{
+	struct qca8k_priv *priv = ds->priv;
+	int i;
+
+	if (stringset != ETH_SS_STATS)
+		return;
+
+	for (i = 0; i < priv->info->mib_count; i++)
+		strncpy(data + i * ETH_GSTRING_LEN, ar8327_mib[i].name,
+			ETH_GSTRING_LEN);
+}
+
+void qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
+			     uint64_t *data)
+{
+	struct qca8k_priv *priv = ds->priv;
+	const struct qca8k_mib_desc *mib;
+	u32 reg, i, val;
+	u32 hi = 0;
+	int ret;
+
+	if (priv->mgmt_master && priv->info->ops->autocast_mib &&
+	    priv->info->ops->autocast_mib(ds, port, data) > 0)
+		return;
+
+	for (i = 0; i < priv->info->mib_count; i++) {
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
+int qca8k_get_sset_count(struct dsa_switch *ds, int port, int sset)
+{
+	struct qca8k_priv *priv = ds->priv;
+
+	if (sset != ETH_SS_STATS)
+		return 0;
+
+	return priv->info->mib_count;
+}
+
+int qca8k_set_mac_eee(struct dsa_switch *ds, int port,
+		      struct ethtool_eee *eee)
+{
+	u32 lpi_en = QCA8K_REG_EEE_CTRL_LPI_EN(port);
+	struct qca8k_priv *priv = ds->priv;
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
+int qca8k_get_mac_eee(struct dsa_switch *ds, int port,
+		      struct ethtool_eee *e)
+{
+	/* Nothing to do on the port's MAC */
+	return 0;
+}
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index f55ef97f826f..c73cbdfc6ac6 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -431,6 +431,7 @@ struct qca8k_fdb {
 extern const struct qca8k_mib_desc ar8327_mib[];
 extern const struct regmap_access_table qca8k_readable_table;
 int qca8k_mib_init(struct qca8k_priv *priv);
+void qca8k_port_set_status(struct qca8k_priv *priv, int port, int enable);
 
 /* Common read/write/rmw function */
 int qca8k_read(struct qca8k_priv *priv, u32 reg, u32 *val);
@@ -443,4 +444,14 @@ int qca8k_bulk_write(struct qca8k_priv *priv, u32 reg, u32 *val, int len);
 /* Common ops function */
 int qca8k_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask);
 
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

