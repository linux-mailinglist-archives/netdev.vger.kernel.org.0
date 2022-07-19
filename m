Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C456F578FB4
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 03:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236801AbiGSBQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 21:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236773AbiGSBP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 21:15:29 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 391D410FEC;
        Mon, 18 Jul 2022 18:15:25 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id c187-20020a1c35c4000000b003a30d88fe8eso6842078wma.2;
        Mon, 18 Jul 2022 18:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=JIHmCXzv4Do1FcqRfUPQnUbn5UqD6aeA+2IeCoKD1Do=;
        b=AIaTnuMxF5GPdGSSW08xFxtLVFqrdZFxs7Ysz0wU+Iv9vAQmtvZmHlwx6XF/QAlEeL
         kNuMFLVy4HFInrGr98B4J1qVSeTxiYBE055yg8bjTWkvcSNnD7OnqD+37U6SYFDdkGvP
         5m+ln6VzuHgyXPNRR9KKlmL7aN1PrGNfDhdhvHLyMEKIuDOePR/WkVlEuRvuSpKzoh1Z
         S3iKxWv/4bv026bavKDqkrxfJpy62Mfa8nitYNF4wuNR78+eEnJjPtGv0R3whzpnRZP1
         sX+glpNf6MH5vK9mTb6t39hxIIAfCThkdznfUT9T8ktunEdYuVL/kqDXU7URMuoOCU2i
         QaMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JIHmCXzv4Do1FcqRfUPQnUbn5UqD6aeA+2IeCoKD1Do=;
        b=hXmM5KptIzF54bZXdbem81fbA/zOoAqx/mahQlmX+s0rV4cAG4O8x7iEcLkfMZnjO4
         tWx/AE8k9joW4maVcMLdgWVhh3zJPp3/bW4Fbi4GXu2aHQLpFDo+WhOc7eH++e9Q3FjI
         D8QOvZs77hNU8XIG4hwuStHUWefMW3a+pN9lX4Q4w9dhVhifr8sjvu+uOzMMJPk16cAh
         7LEMzbBljuDUQWsn8tdw1qRH8s82h5JZjcBjo6oLhd4PWCg/KGbn9bILrMJSrow0evAT
         cQ0lJW/wKYPyZvlImYxLN/RV8O4RsCdfHjNzJZd8j9i6fM7ftCvPpJUbU0odIMyvAmMq
         4p1g==
X-Gm-Message-State: AJIora8N5r1GPxrGW31ICgIGHEtl157MonfKqDlpAOAgcX+3BeKejvLA
        ODLTLE/vLtVJjRTZYOUE97A=
X-Google-Smtp-Source: AGRyM1sdLRFoYBgqYJaCNiR6nZ+nIoAu9+IuVoLRtTvRjfi66T4eJHzgM+E7mdENV+11ROKt6r0c1g==
X-Received: by 2002:a1c:7714:0:b0:3a3:c:81b8 with SMTP id t20-20020a1c7714000000b003a3000c81b8mr23483128wmi.148.1658193323561;
        Mon, 18 Jul 2022 18:15:23 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id y11-20020adff14b000000b0021db7b0162esm11840239wro.105.2022.07.18.18.15.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 18:15:23 -0700 (PDT)
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
Subject: [net-next PATCH v2 13/15] net: dsa: qca8k: move port LAG functions to common code
Date:   Tue, 19 Jul 2022 02:57:24 +0200
Message-Id: <20220719005726.8739-15-ansuelsmth@gmail.com>
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

The same port LAG functions are used by drivers based on qca8k family
switch. Move them to common code to make them accessible also by other
drivers.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c   | 168 -----------------------------
 drivers/net/dsa/qca/qca8k-common.c | 168 +++++++++++++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h        |   6 ++
 3 files changed, 174 insertions(+), 168 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index d6223ee79389..dfd5cd0817f9 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -1598,174 +1598,6 @@ qca8k_get_tag_protocol(struct dsa_switch *ds, int port,
 	return DSA_TAG_PROTO_QCA;
 }
 
-static bool
-qca8k_lag_can_offload(struct dsa_switch *ds, struct dsa_lag lag,
-		      struct netdev_lag_upper_info *info)
-{
-	struct dsa_port *dp;
-	int members = 0;
-
-	if (!lag.id)
-		return false;
-
-	dsa_lag_foreach_port(dp, ds->dst, &lag)
-		/* Includes the port joining the LAG */
-		members++;
-
-	if (members > QCA8K_NUM_PORTS_FOR_LAG)
-		return false;
-
-	if (info->tx_type != NETDEV_LAG_TX_TYPE_HASH)
-		return false;
-
-	if (info->hash_type != NETDEV_LAG_HASH_L2 &&
-	    info->hash_type != NETDEV_LAG_HASH_L23)
-		return false;
-
-	return true;
-}
-
-static int
-qca8k_lag_setup_hash(struct dsa_switch *ds, struct dsa_lag lag,
-		     struct netdev_lag_upper_info *info)
-{
-	struct net_device *lag_dev = lag.dev;
-	struct qca8k_priv *priv = ds->priv;
-	bool unique_lag = true;
-	unsigned int i;
-	u32 hash = 0;
-
-	switch (info->hash_type) {
-	case NETDEV_LAG_HASH_L23:
-		hash |= QCA8K_TRUNK_HASH_SIP_EN;
-		hash |= QCA8K_TRUNK_HASH_DIP_EN;
-		fallthrough;
-	case NETDEV_LAG_HASH_L2:
-		hash |= QCA8K_TRUNK_HASH_SA_EN;
-		hash |= QCA8K_TRUNK_HASH_DA_EN;
-		break;
-	default: /* We should NEVER reach this */
-		return -EOPNOTSUPP;
-	}
-
-	/* Check if we are the unique configured LAG */
-	dsa_lags_foreach_id(i, ds->dst)
-		if (i != lag.id && dsa_lag_by_id(ds->dst, i)) {
-			unique_lag = false;
-			break;
-		}
-
-	/* Hash Mode is global. Make sure the same Hash Mode
-	 * is set to all the 4 possible lag.
-	 * If we are the unique LAG we can set whatever hash
-	 * mode we want.
-	 * To change hash mode it's needed to remove all LAG
-	 * and change the mode with the latest.
-	 */
-	if (unique_lag) {
-		priv->lag_hash_mode = hash;
-	} else if (priv->lag_hash_mode != hash) {
-		netdev_err(lag_dev, "Error: Mismatched Hash Mode across different lag is not supported\n");
-		return -EOPNOTSUPP;
-	}
-
-	return regmap_update_bits(priv->regmap, QCA8K_TRUNK_HASH_EN_CTRL,
-				  QCA8K_TRUNK_HASH_MASK, hash);
-}
-
-static int
-qca8k_lag_refresh_portmap(struct dsa_switch *ds, int port,
-			  struct dsa_lag lag, bool delete)
-{
-	struct qca8k_priv *priv = ds->priv;
-	int ret, id, i;
-	u32 val;
-
-	/* DSA LAG IDs are one-based, hardware is zero-based */
-	id = lag.id - 1;
-
-	/* Read current port member */
-	ret = regmap_read(priv->regmap, QCA8K_REG_GOL_TRUNK_CTRL0, &val);
-	if (ret)
-		return ret;
-
-	/* Shift val to the correct trunk */
-	val >>= QCA8K_REG_GOL_TRUNK_SHIFT(id);
-	val &= QCA8K_REG_GOL_TRUNK_MEMBER_MASK;
-	if (delete)
-		val &= ~BIT(port);
-	else
-		val |= BIT(port);
-
-	/* Update port member. With empty portmap disable trunk */
-	ret = regmap_update_bits(priv->regmap, QCA8K_REG_GOL_TRUNK_CTRL0,
-				 QCA8K_REG_GOL_TRUNK_MEMBER(id) |
-				 QCA8K_REG_GOL_TRUNK_EN(id),
-				 !val << QCA8K_REG_GOL_TRUNK_SHIFT(id) |
-				 val << QCA8K_REG_GOL_TRUNK_SHIFT(id));
-
-	/* Search empty member if adding or port on deleting */
-	for (i = 0; i < QCA8K_NUM_PORTS_FOR_LAG; i++) {
-		ret = regmap_read(priv->regmap, QCA8K_REG_GOL_TRUNK_CTRL(id), &val);
-		if (ret)
-			return ret;
-
-		val >>= QCA8K_REG_GOL_TRUNK_ID_MEM_ID_SHIFT(id, i);
-		val &= QCA8K_REG_GOL_TRUNK_ID_MEM_ID_MASK;
-
-		if (delete) {
-			/* If port flagged to be disabled assume this member is
-			 * empty
-			 */
-			if (val != QCA8K_REG_GOL_TRUNK_ID_MEM_ID_EN_MASK)
-				continue;
-
-			val &= QCA8K_REG_GOL_TRUNK_ID_MEM_ID_PORT_MASK;
-			if (val != port)
-				continue;
-		} else {
-			/* If port flagged to be enabled assume this member is
-			 * already set
-			 */
-			if (val == QCA8K_REG_GOL_TRUNK_ID_MEM_ID_EN_MASK)
-				continue;
-		}
-
-		/* We have found the member to add/remove */
-		break;
-	}
-
-	/* Set port in the correct port mask or disable port if in delete mode */
-	return regmap_update_bits(priv->regmap, QCA8K_REG_GOL_TRUNK_CTRL(id),
-				  QCA8K_REG_GOL_TRUNK_ID_MEM_ID_EN(id, i) |
-				  QCA8K_REG_GOL_TRUNK_ID_MEM_ID_PORT(id, i),
-				  !delete << QCA8K_REG_GOL_TRUNK_ID_MEM_ID_SHIFT(id, i) |
-				  port << QCA8K_REG_GOL_TRUNK_ID_MEM_ID_SHIFT(id, i));
-}
-
-static int
-qca8k_port_lag_join(struct dsa_switch *ds, int port, struct dsa_lag lag,
-		    struct netdev_lag_upper_info *info)
-{
-	int ret;
-
-	if (!qca8k_lag_can_offload(ds, lag, info))
-		return -EOPNOTSUPP;
-
-	ret = qca8k_lag_setup_hash(ds, lag, info);
-	if (ret)
-		return ret;
-
-	return qca8k_lag_refresh_portmap(ds, port, lag, false);
-}
-
-static int
-qca8k_port_lag_leave(struct dsa_switch *ds, int port,
-		     struct dsa_lag lag)
-{
-	return qca8k_lag_refresh_portmap(ds, port, lag, true);
-}
-
 static void
 qca8k_master_change(struct dsa_switch *ds, const struct net_device *master,
 		    bool operational)
diff --git a/drivers/net/dsa/qca/qca8k-common.c b/drivers/net/dsa/qca/qca8k-common.c
index 11af3b09ae81..f8a3b08a6257 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -1056,3 +1056,171 @@ qca8k_port_vlan_del(struct dsa_switch *ds, int port,
 
 	return ret;
 }
+
+static bool
+qca8k_lag_can_offload(struct dsa_switch *ds, struct dsa_lag lag,
+		      struct netdev_lag_upper_info *info)
+{
+	struct dsa_port *dp;
+	int members = 0;
+
+	if (!lag.id)
+		return false;
+
+	dsa_lag_foreach_port(dp, ds->dst, &lag)
+		/* Includes the port joining the LAG */
+		members++;
+
+	if (members > QCA8K_NUM_PORTS_FOR_LAG)
+		return false;
+
+	if (info->tx_type != NETDEV_LAG_TX_TYPE_HASH)
+		return false;
+
+	if (info->hash_type != NETDEV_LAG_HASH_L2 &&
+	    info->hash_type != NETDEV_LAG_HASH_L23)
+		return false;
+
+	return true;
+}
+
+static int
+qca8k_lag_setup_hash(struct dsa_switch *ds, struct dsa_lag lag,
+		     struct netdev_lag_upper_info *info)
+{
+	struct net_device *lag_dev = lag.dev;
+	struct qca8k_priv *priv = ds->priv;
+	bool unique_lag = true;
+	unsigned int i;
+	u32 hash = 0;
+
+	switch (info->hash_type) {
+	case NETDEV_LAG_HASH_L23:
+		hash |= QCA8K_TRUNK_HASH_SIP_EN;
+		hash |= QCA8K_TRUNK_HASH_DIP_EN;
+		fallthrough;
+	case NETDEV_LAG_HASH_L2:
+		hash |= QCA8K_TRUNK_HASH_SA_EN;
+		hash |= QCA8K_TRUNK_HASH_DA_EN;
+		break;
+	default: /* We should NEVER reach this */
+		return -EOPNOTSUPP;
+	}
+
+	/* Check if we are the unique configured LAG */
+	dsa_lags_foreach_id(i, ds->dst)
+		if (i != lag.id && dsa_lag_by_id(ds->dst, i)) {
+			unique_lag = false;
+			break;
+		}
+
+	/* Hash Mode is global. Make sure the same Hash Mode
+	 * is set to all the 4 possible lag.
+	 * If we are the unique LAG we can set whatever hash
+	 * mode we want.
+	 * To change hash mode it's needed to remove all LAG
+	 * and change the mode with the latest.
+	 */
+	if (unique_lag) {
+		priv->lag_hash_mode = hash;
+	} else if (priv->lag_hash_mode != hash) {
+		netdev_err(lag_dev, "Error: Mismatched Hash Mode across different lag is not supported\n");
+		return -EOPNOTSUPP;
+	}
+
+	return regmap_update_bits(priv->regmap, QCA8K_TRUNK_HASH_EN_CTRL,
+				  QCA8K_TRUNK_HASH_MASK, hash);
+}
+
+static int
+qca8k_lag_refresh_portmap(struct dsa_switch *ds, int port,
+			  struct dsa_lag lag, bool delete)
+{
+	struct qca8k_priv *priv = ds->priv;
+	int ret, id, i;
+	u32 val;
+
+	/* DSA LAG IDs are one-based, hardware is zero-based */
+	id = lag.id - 1;
+
+	/* Read current port member */
+	ret = regmap_read(priv->regmap, QCA8K_REG_GOL_TRUNK_CTRL0, &val);
+	if (ret)
+		return ret;
+
+	/* Shift val to the correct trunk */
+	val >>= QCA8K_REG_GOL_TRUNK_SHIFT(id);
+	val &= QCA8K_REG_GOL_TRUNK_MEMBER_MASK;
+	if (delete)
+		val &= ~BIT(port);
+	else
+		val |= BIT(port);
+
+	/* Update port member. With empty portmap disable trunk */
+	ret = regmap_update_bits(priv->regmap, QCA8K_REG_GOL_TRUNK_CTRL0,
+				 QCA8K_REG_GOL_TRUNK_MEMBER(id) |
+				 QCA8K_REG_GOL_TRUNK_EN(id),
+				 !val << QCA8K_REG_GOL_TRUNK_SHIFT(id) |
+				 val << QCA8K_REG_GOL_TRUNK_SHIFT(id));
+
+	/* Search empty member if adding or port on deleting */
+	for (i = 0; i < QCA8K_NUM_PORTS_FOR_LAG; i++) {
+		ret = regmap_read(priv->regmap, QCA8K_REG_GOL_TRUNK_CTRL(id), &val);
+		if (ret)
+			return ret;
+
+		val >>= QCA8K_REG_GOL_TRUNK_ID_MEM_ID_SHIFT(id, i);
+		val &= QCA8K_REG_GOL_TRUNK_ID_MEM_ID_MASK;
+
+		if (delete) {
+			/* If port flagged to be disabled assume this member is
+			 * empty
+			 */
+			if (val != QCA8K_REG_GOL_TRUNK_ID_MEM_ID_EN_MASK)
+				continue;
+
+			val &= QCA8K_REG_GOL_TRUNK_ID_MEM_ID_PORT_MASK;
+			if (val != port)
+				continue;
+		} else {
+			/* If port flagged to be enabled assume this member is
+			 * already set
+			 */
+			if (val == QCA8K_REG_GOL_TRUNK_ID_MEM_ID_EN_MASK)
+				continue;
+		}
+
+		/* We have found the member to add/remove */
+		break;
+	}
+
+	/* Set port in the correct port mask or disable port if in delete mode */
+	return regmap_update_bits(priv->regmap, QCA8K_REG_GOL_TRUNK_CTRL(id),
+				  QCA8K_REG_GOL_TRUNK_ID_MEM_ID_EN(id, i) |
+				  QCA8K_REG_GOL_TRUNK_ID_MEM_ID_PORT(id, i),
+				  !delete << QCA8K_REG_GOL_TRUNK_ID_MEM_ID_SHIFT(id, i) |
+				  port << QCA8K_REG_GOL_TRUNK_ID_MEM_ID_SHIFT(id, i));
+}
+
+int
+qca8k_port_lag_join(struct dsa_switch *ds, int port, struct dsa_lag lag,
+		    struct netdev_lag_upper_info *info)
+{
+	int ret;
+
+	if (!qca8k_lag_can_offload(ds, lag, info))
+		return -EOPNOTSUPP;
+
+	ret = qca8k_lag_setup_hash(ds, lag, info);
+	if (ret)
+		return ret;
+
+	return qca8k_lag_refresh_portmap(ds, port, lag, false);
+}
+
+int
+qca8k_port_lag_leave(struct dsa_switch *ds, int port,
+		     struct dsa_lag lag)
+{
+	return qca8k_lag_refresh_portmap(ds, port, lag, true);
+}
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index aa4fe02a2155..3ee069cb4fd2 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -518,4 +518,10 @@ int qca8k_port_vlan_add(struct dsa_switch *ds, int port,
 int qca8k_port_vlan_del(struct dsa_switch *ds, int port,
 			const struct switchdev_obj_port_vlan *vlan);
 
+/* Common port LAG function */
+int qca8k_port_lag_join(struct dsa_switch *ds, int port, struct dsa_lag lag,
+			struct netdev_lag_upper_info *info);
+int qca8k_port_lag_leave(struct dsa_switch *ds, int port,
+			 struct dsa_lag lag);
+
 #endif /* __QCA8K_H */
-- 
2.36.1

