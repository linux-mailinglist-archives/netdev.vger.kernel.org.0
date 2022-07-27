Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA69E5825B4
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 13:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232350AbiG0Lg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 07:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232347AbiG0Lgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 07:36:37 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA6B84AD4F;
        Wed, 27 Jul 2022 04:36:01 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id j22so30998929ejs.2;
        Wed, 27 Jul 2022 04:36:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=NRcW/iBfUa0K3I9qltAUdB5G6TgZYe+99zQOj2z7950=;
        b=iB6AaRIAVIEU5rqaEkIEl70HJtzUxR12wv5A9kG3WZAJ8MpSbWjyUPoPqZarslIeLo
         ujrgXnC0qAeR/RJQvVSaZXUDG5iijpMdNh3fVPkm4wdrztp9yc3AXRWxX5K4cJi8xd+v
         X2wNZPk91tgnwjtcDnX5EM6dr77uHlZxG25cG67g/qo2+qx2SAzzJiEdqPCtJbDCBfnq
         7tvmu5MSyupdFT0b+tEeTAZQMqQUJUywbVGbfhop8DiF9WJ0eFwB5BlkBqSZDgnY6OLd
         rQ2qJ4wEZ51WYwFzW7MjPeFAYUo5jXqvGWVkJtFP8aQdRy8FK4c/7n7ZOEW3zZEQMrcR
         5olQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NRcW/iBfUa0K3I9qltAUdB5G6TgZYe+99zQOj2z7950=;
        b=Lh5rrNGgp9zqQeo1HVBCeFMq6Njbsmj4TQESFnIW2+JKGzMiqVChPplqOCLKskbUg7
         ARTdda1lT3gBtnxj2PbFME2kJb+kOqtWs4Pc0oKZ329Ir5jIG8aFQIgnxWqkSzbN2CLk
         VHlh0eMq0m5rS+WXxbr9mxUrHY748lwZqb/7MPJDzOHdkS8hgUOkh/OgRd29NJQu/CFv
         XFLk2Yusz3u4b27ujF+UFkhIEOBWOpLN//6psskVNGaHTwkK1IfJ3jDfvJgc+AvrU2RM
         gpvDnKSxfOENkPvd/w7YZF2lk43u8U02NluPm3dDRme47um3XNy3sxcVP08nlwuldE4I
         EPwg==
X-Gm-Message-State: AJIora87nXb5VA8T6vkkbhe/u+xPbrODRHJo7e1iimOVltDMCYKK4cse
        R9T2ispoxVPWitGQpTVyWv0=
X-Google-Smtp-Source: AGRyM1v4Cr5Fqr3s0jZqDhMGMnRom9zeyTnqIyvWT//IOrXaaIuy3AMHkUYPoil9eL7s6irsa6FXxw==
X-Received: by 2002:a17:907:72c6:b0:72f:b01:2723 with SMTP id du6-20020a17090772c600b0072f0b012723mr17300294ejc.439.1658921759387;
        Wed, 27 Jul 2022 04:35:59 -0700 (PDT)
Received: from localhost.localdomain (c105-182.i13-27.melita.com. [94.17.105.182])
        by smtp.googlemail.com with ESMTPSA id p25-20020aa7cc99000000b0043ca6fb7e7dsm1334056edt.68.2022.07.27.04.35.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 04:35:58 -0700 (PDT)
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
Subject: [net-next PATCH v5 13/14] net: dsa: qca8k: move port LAG functions to common code
Date:   Wed, 27 Jul 2022 13:35:22 +0200
Message-Id: <20220727113523.19742-14-ansuelsmth@gmail.com>
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

The same port LAG functions are used by drivers based on qca8k family
switch. Move them to common code to make them accessible also by other
drivers.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c   | 168 -----------------------------
 drivers/net/dsa/qca/qca8k-common.c | 165 ++++++++++++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h        |   6 ++
 3 files changed, 171 insertions(+), 168 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 545f86e3c6ed..4d6ea47a4469 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -1593,174 +1593,6 @@ qca8k_get_tag_protocol(struct dsa_switch *ds, int port,
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
index 0e5ce532accd..c881a95441dd 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -1014,3 +1014,168 @@ int qca8k_port_vlan_del(struct dsa_switch *ds, int port,
 
 	return ret;
 }
+
+static bool qca8k_lag_can_offload(struct dsa_switch *ds,
+				  struct dsa_lag lag,
+				  struct netdev_lag_upper_info *info)
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
+static int qca8k_lag_setup_hash(struct dsa_switch *ds,
+				struct dsa_lag lag,
+				struct netdev_lag_upper_info *info)
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
+static int qca8k_lag_refresh_portmap(struct dsa_switch *ds, int port,
+				     struct dsa_lag lag, bool delete)
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
+int qca8k_port_lag_join(struct dsa_switch *ds, int port, struct dsa_lag lag,
+			struct netdev_lag_upper_info *info)
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
+int qca8k_port_lag_leave(struct dsa_switch *ds, int port,
+			 struct dsa_lag lag)
+{
+	return qca8k_lag_refresh_portmap(ds, port, lag, true);
+}
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index 91f7abc5beb1..e87bfee837c1 100644
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

