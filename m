Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4272757EF86
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 16:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237545AbiGWOUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 10:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237634AbiGWOTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 10:19:49 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB61F1C132;
        Sat, 23 Jul 2022 07:19:46 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id i205-20020a1c3bd6000000b003a2fa488efdso973809wma.4;
        Sat, 23 Jul 2022 07:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=wnlpuJ7EYVbyGEcFFMHn7qZekJ8IuSU8CM3ZnTqEzNs=;
        b=EtjvCJ67QGIPFhUTmCqI6tVloBnErnigdvgbp1dK+OSTJ5zqjg1kMOiRuMaghZUlny
         JJlY33l0IaV4cn/nOT4agCE7VC1rY9+zafTCmlfJaQU2CpmINILwufVcHefwL5JOgXxQ
         iQUMDiVKNiSR1MCnyPLAspM/CWXXwhxvWaehlpPQdjeH2brMA+2H2IQONMn6MXrikY1G
         4wWNX6tKDNGBMMZGjCXNbSnk369vHen5RIo9yphh2l+zfbErtzdRRUQhRIwoMgUzYKq9
         DoAVSukPxUTjjQouSzpyIzmSX+u3YBA9F4mlHZMWY8Iidhue8N3PaRnWWhGuNGMXEJpP
         Uo6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wnlpuJ7EYVbyGEcFFMHn7qZekJ8IuSU8CM3ZnTqEzNs=;
        b=G2RNCBUk4f5nmH6cxdma7pCyDkod1YzjjFCSZIBR4lW2F71ZwamBRAShMTvP6+Iyb4
         F3a0LVePerVQo2nC170+Z1PL4WZdXD9QOCx9xQ/Jqm3WB9DcCxBvTUuhIYmEWi2IFBhF
         H+PKyRj4LLAcCd6uoUoMnS94JiCIff6EdKaDZty4Rk/jLxx3M7HEMEaBz+XXfty4+Tl1
         BB7D6C8SoTHvXHQPhTWZXkTCmz/le9F2EA32gkZIjWPkm0X29bWZEFHkYWVgjR4s9D3e
         fP4BrkzzWe8UmOZXAxCm4rXUyllO//rCqt2VN5LyftkToGFOsfQu8IwbY6DrC0xXs49A
         fWLQ==
X-Gm-Message-State: AJIora+llJ/soG/qxdnVHTkr4KBRLiforWMmD7F/UsdiIgTROj1PC7wN
        d2PS6NOTqtf3HB0Abdg9PUI=
X-Google-Smtp-Source: AGRyM1swDbGBC/4NZuoqz+l8+McCWy/CBUkU4Wk++KRMCs9RYwUrnRN9saMuV3m8dazsol7U34ZEMw==
X-Received: by 2002:a05:600c:1083:b0:3a3:1964:fb14 with SMTP id e3-20020a05600c108300b003a31964fb14mr3053788wmd.203.1658585985215;
        Sat, 23 Jul 2022 07:19:45 -0700 (PDT)
Received: from localhost.localdomain (host-87-7-207-127.retail.telecomitalia.it. [87.7.207.127])
        by smtp.googlemail.com with ESMTPSA id l18-20020a05600c1d1200b003a04d19dab3sm21011960wms.3.2022.07.23.07.19.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jul 2022 07:19:44 -0700 (PDT)
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
Subject: [net-next PATCH v3 07/14] net: dsa: qca8k: move port set status/eee/ethtool stats function to common code
Date:   Sat, 23 Jul 2022 16:18:38 +0200
Message-Id: <20220723141845.10570-8-ansuelsmth@gmail.com>
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

The same logic to disable/enable port, set eee and get ethtool stats is
used by drivers based on qca8k family switch.
Move it to common code to make it accessible also by other drivers.
While at it also drop unnecessary qca8k_priv cast for void pointers.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c   | 105 -----------------------------
 drivers/net/dsa/qca/qca8k-common.c | 105 +++++++++++++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h        |  11 +++
 3 files changed, 116 insertions(+), 105 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 3bd0c52f049e..7042bf8d94c8 100644
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
-	if (priv->mgmt_master && priv->info->ops.autocast_mib &&
-	    priv->info->ops.autocast_mib(ds, port, data) > 0)
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
index 9e9e3f0b7179..369c763fbb5d 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -174,3 +174,108 @@ int qca8k_mib_init(struct qca8k_priv *priv)
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
+void
+qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
+			uint64_t *data)
+{
+	struct qca8k_priv *priv = ds->priv;
+	const struct qca8k_mib_desc *mib;
+	u32 reg, i, val;
+	u32 hi = 0;
+	int ret;
+
+	if (priv->mgmt_master && priv->info->ops.autocast_mib &&
+	    priv->info->ops.autocast_mib(ds, port, data) > 0)
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
+int
+qca8k_get_sset_count(struct dsa_switch *ds, int port, int sset)
+{
+	struct qca8k_priv *priv = ds->priv;
+
+	if (sset != ETH_SS_STATS)
+		return 0;
+
+	return priv->info->mib_count;
+}
+
+int
+qca8k_set_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *eee)
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
+int
+qca8k_get_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *e)
+{
+	/* Nothing to do on the port's MAC */
+	return 0;
+}
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index 606a4c76c4b3..9657c0a07bdd 100644
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

