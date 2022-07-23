Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC44657EF7F
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 16:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237718AbiGWOV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 10:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237938AbiGWOUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 10:20:52 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A710321;
        Sat, 23 Jul 2022 07:20:07 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id j29-20020a05600c1c1d00b003a2fdafdefbso3918528wms.2;
        Sat, 23 Jul 2022 07:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=d7hgZybAS27exT8so9ST/Rz80Lbt6wEkvSW7nOWHD1Y=;
        b=ZpNXPhs8hkgb92Yr8M5Rrsge0NGucdOnQLK1Omr4MxHtPKV0WcEt3PDze5OQkkxbMr
         RDn/6oS4TK7NHwH2HVXxyZEIF2mCqWIBp6rljHbPiPoFtqOzoo7k3cYYVZcqIQvcs+H8
         UKSAQ1zTgzCel1OLp4pg8FVma1cOM5sebFwh89YMedqQjiFvl0aTlgX+l+eaTtvMnHwx
         YkCSY6/bsPY7BcFgUCMp0irQ3gN+GIHquF59qbUjK9FDoMiiZCkO0XeBfJc7PGIUg7zB
         0wAWmyElLcqOXUSSCt9x0gVqLirbdssWHtJfkzdkOvC/YL3QwDlI3qJ93npbqm6wbv4E
         HIqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d7hgZybAS27exT8so9ST/Rz80Lbt6wEkvSW7nOWHD1Y=;
        b=66ALdGv1/JOsSDkM4gLKlfIrMeXPmh9TgQyQ067t2o8Qx3gGg6IRxM6xSdgN/noKs5
         PjYreMv2/mnHTRuEi4WpNO6e7vzVFs/uAUBpnfmY2XxNoFxfW5+N33YNgG/rhKI+rYwm
         0RzsWajuMAIL6Nrmuhul7Ck+Lsa1MJgGkMBpG9rMVPcirqpIJr3eGocdnKzNEJkoH+gA
         FxgpFxBxEUaGgMxpnQ+RRoT2bBa2Er5fbHoVDYNDF7OIGTgEcAKTmN+8mUUKFFQIgxef
         e7+7XEbvvIb+iiCpWAVgsmpUtuF+fUgPhyLjkPv0HrMq0nYTGnP6f+wcX1CjEw1BE8Hl
         HtzA==
X-Gm-Message-State: AJIora9InhAfx8h4NAUd4apVubZa9gLjmbEF58F6DPkXdl5XqM9Frj7M
        NXxfetpoK8TlqDMWLPQd1EUEDt+JrYE=
X-Google-Smtp-Source: AGRyM1sjc7H3xq210i2L4McYwRftRx/0YkLgIC13cFy8S1i9U38cC3sKyV7caFsRaghj6Qi4PhHjyg==
X-Received: by 2002:a05:600c:3ba3:b0:3a3:227b:f754 with SMTP id n35-20020a05600c3ba300b003a3227bf754mr15356030wms.64.1658586006001;
        Sat, 23 Jul 2022 07:20:06 -0700 (PDT)
Received: from localhost.localdomain (host-87-7-207-127.retail.telecomitalia.it. [87.7.207.127])
        by smtp.googlemail.com with ESMTPSA id l18-20020a05600c1d1200b003a04d19dab3sm21011960wms.3.2022.07.23.07.20.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jul 2022 07:20:05 -0700 (PDT)
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
Subject: [net-next PATCH v3 13/14] net: dsa: qca8k: move port LAG functions to common code
Date:   Sat, 23 Jul 2022 16:18:44 +0200
Message-Id: <20220723141845.10570-14-ansuelsmth@gmail.com>
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

The same port LAG functions are used by drivers based on qca8k family
switch. Move them to common code to make them accessible also by other
drivers.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c   | 168 -----------------------------
 drivers/net/dsa/qca/qca8k-common.c | 168 +++++++++++++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h        |   6 ++
 3 files changed, 174 insertions(+), 168 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index d6494eac8c6d..34d0c4cea68d 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -1594,174 +1594,6 @@ qca8k_get_tag_protocol(struct dsa_switch *ds, int port,
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
index 5d6eeda4c142..02559990a097 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -1039,3 +1039,171 @@ qca8k_port_vlan_del(struct dsa_switch *ds, int port,
 
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
index d97fbbe12e2f..e6cf1ad68a9f 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -509,4 +509,10 @@ int qca8k_port_vlan_add(struct dsa_switch *ds, int port,
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

