Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C05957F78B
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 00:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233194AbiGXWws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 18:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233162AbiGXWwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 18:52:22 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 031CA11806;
        Sun, 24 Jul 2022 15:51:21 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id os14so17552026ejb.4;
        Sun, 24 Jul 2022 15:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=UQHxi3oGRO7hVpkjhFVQlFGQWIrQ1nlGKdUuOxUGhyI=;
        b=aoIhM9gTWBS5akBI1eV6Fx4/LcfCgklGgX7wSn3udRtrhRhV3aNdky+a3tS+3lFzyO
         JJXgTJ3CiPMJQIyOYgXkYSSMAYcWqnN2UbOgt9a/MwOSxFqs+ToFFbr9f6iwyNK1q1s9
         a0cEKEQby7wfSUS1UVjtAy3B7Y+aw99Sd2V2wnPb0uJxwq2Tj8bZAZ3R4OxUA63be/gu
         UR6xpkJbD+mCSAC4LHzqwptfk0ix892JWilsYoVDuF9L5f/DHCznVDuiIa1mmikH41B1
         CPp//PinXG0Hl9MK5fdBcXqrGsNFr8hxr7pUQOi/R5LJdFba/WxNYTJpHjXWRiFLFvW2
         ts/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UQHxi3oGRO7hVpkjhFVQlFGQWIrQ1nlGKdUuOxUGhyI=;
        b=YKJUhbO4kzacFqvkcSTOhOyycMi/sb+KhuwpFXXQedkRww5piBEKxpuJGPeOWRjXAD
         Jw+Hd8wpEMEJZS2z/b/wVK4J1ZbpZTHzNukfGRh68XCP0CMemG3sBVqL2A2+Hnn6gEVH
         k4+Kgsku95HXmLQ921Uw7G0lYnDMd4rR9L4btlO+QOt+SuZZ3QXet9Wwlx5EVular45V
         JFGVM5NsXBzeKyvZIM1lKNAk2hkm7RL95iWtf9zMVYX7ODcEyZPl0LZ2LoYxdgWeBYZT
         3BZSctCFgTPWWzUDi4k8FRG3ma8B6+JVZx7QTRFTfzv8U0bR2ts6c2Xzb0L+JBNOYMW8
         h/0Q==
X-Gm-Message-State: AJIora8wxOM++9JeNBqAT1PDIaQjbfRmTyfr5mg7JZoXpGvFlK4Z9gvt
        k96TcoMgwSZDZGdDzowfrpwfdKSG5Fk=
X-Google-Smtp-Source: AGRyM1tI1fk4XJzTOToufFFSUM5RD+LXAw6MM2snFmGJ5a+2L2v+PRr7E8VPlRQol9Isoe5lTup98A==
X-Received: by 2002:a17:907:3f84:b0:724:2ec:b474 with SMTP id hr4-20020a1709073f8400b0072402ecb474mr7686247ejc.644.1658703079820;
        Sun, 24 Jul 2022 15:51:19 -0700 (PDT)
Received: from localhost.localdomain (93-42-69-122.ip85.fastwebnet.it. [93.42.69.122])
        by smtp.googlemail.com with ESMTPSA id nc19-20020a1709071c1300b00722d5b26ecesm4645238ejc.205.2022.07.24.15.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jul 2022 15:51:19 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        llvm@lists.linux.dev
Subject: [net-next PATCH v4 13/14] net: dsa: qca8k: move port LAG functions to common code
Date:   Sun, 24 Jul 2022 22:19:37 +0200
Message-Id: <20220724201938.17387-14-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220724201938.17387-1-ansuelsmth@gmail.com>
References: <20220724201938.17387-1-ansuelsmth@gmail.com>
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
index 7e0e82d6f7cd..82c02491c946 100644
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
index ed94f08014de..b982efb721fc 100644
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

