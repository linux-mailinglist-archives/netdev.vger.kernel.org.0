Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9225578FA3
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 03:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236763AbiGSBP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 21:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236701AbiGSBP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 21:15:28 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4AC3BF69;
        Mon, 18 Jul 2022 18:15:18 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id h14-20020a1ccc0e000000b0039eff745c53so8294820wmb.5;
        Mon, 18 Jul 2022 18:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=JrY8Flz5fWn6CXvBsItaOqepqlxqzDGaWzl8I4pTahc=;
        b=PKy5J/Utw62yK47+ItiIbGz8JHYyDv5ZGhevo4ta/RBQPerlghSwUx/tMZjiDig0hu
         LrnuDdhX81HP5kZ3rNvXgk1at0/YZMNpWTJtNh9VzmphvtYWTna4XpTk/N/8SIXKLKVl
         mbzkcB7Iuy7J9Cne7/cC9RHow+3JohBpg/wMvNucAVAZW+zzaZqy8y/mX9QU5gK1opKt
         wQ6s1r77X7Du83RhKn/eAUn6ewjdTdWqNtfVtTxJp7gIhl1h0x0le8mnpDlbaUzr6FNQ
         lIL2GU3TEJxgrNNgzy4j5tV5kI/Ne49avWw7v+PqFqxsF17U7LRLQKTnzwDIF7P1/LRp
         Yn1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JrY8Flz5fWn6CXvBsItaOqepqlxqzDGaWzl8I4pTahc=;
        b=hb+gxdEs1+ugOVqO5ODtpYhuV3QPFpQRVIOAaf7iv+tOCkbfCW6K4R206kDi3ttwRy
         sBYHXYpNk3Sr1m2+cZPJIynF1B+dTEbXisbh8wTHO9xeUe5inma0nHs3XOUfnyX632vB
         K6HUQlCfb/0bjTi9P3AwUNZU8RjAL3fcQD/BhYLWq4zXJs1RdPPL7q9nRdL6Q2EB1cEx
         /clc5w/x+ZStScRKkIEwvzsoGFB/gFPBimMx0SuZQOopxkmvLgVcSEIkKdmXDC6nhyg3
         PhjNvCN2j5BEQ8ItBTaEROSIbEKuYHmF+QeNR/GyVC9+LAHPBoDzq3SSiavBV/DjSoDI
         Rzww==
X-Gm-Message-State: AJIora9DJZyCr2ino7XesQO2ctR4vGtDMGJHafqJI7X3QXHDfKfB4GLw
        o/R4JubeF3RtMEwYymZpHk4yQtGJPqY=
X-Google-Smtp-Source: AGRyM1uEO71W2pzxOKxA8C2+77xwZshEEHaQxp1V2EQzg9a+xQ72bCfXCqteOnzchb2nyUJToRni6g==
X-Received: by 2002:a05:600c:4eca:b0:3a1:9c39:ac20 with SMTP id g10-20020a05600c4eca00b003a19c39ac20mr34830674wmq.61.1658193316595;
        Mon, 18 Jul 2022 18:15:16 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id y11-20020adff14b000000b0021db7b0162esm11840239wro.105.2022.07.18.18.15.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 18:15:16 -0700 (PDT)
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
Subject: [net-next PATCH v2 07/15] net: dsa: qca8k: move bridge functions to common code
Date:   Tue, 19 Jul 2022 02:57:18 +0200
Message-Id: <20220719005726.8739-9-ansuelsmth@gmail.com>
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

The same bridge functions are used by drivers based on qca8k family
switch. Move them to common code to make them accessible also by other
drivers.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c   | 93 -----------------------------
 drivers/net/dsa/qca/qca8k-common.c | 94 ++++++++++++++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h        |  9 +++
 3 files changed, 103 insertions(+), 93 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 23b4cd6b68ff..729f63a865d1 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -1575,99 +1575,6 @@ qca8k_get_ethtool_stats_eth(struct dsa_switch *ds, int port, u64 *data)
 	return ret;
 }
 
-static void
-qca8k_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
-{
-	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
-	u32 stp_state;
-
-	switch (state) {
-	case BR_STATE_DISABLED:
-		stp_state = QCA8K_PORT_LOOKUP_STATE_DISABLED;
-		break;
-	case BR_STATE_BLOCKING:
-		stp_state = QCA8K_PORT_LOOKUP_STATE_BLOCKING;
-		break;
-	case BR_STATE_LISTENING:
-		stp_state = QCA8K_PORT_LOOKUP_STATE_LISTENING;
-		break;
-	case BR_STATE_LEARNING:
-		stp_state = QCA8K_PORT_LOOKUP_STATE_LEARNING;
-		break;
-	case BR_STATE_FORWARDING:
-	default:
-		stp_state = QCA8K_PORT_LOOKUP_STATE_FORWARD;
-		break;
-	}
-
-	qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
-		  QCA8K_PORT_LOOKUP_STATE_MASK, stp_state);
-}
-
-static int qca8k_port_bridge_join(struct dsa_switch *ds, int port,
-				  struct dsa_bridge bridge,
-				  bool *tx_fwd_offload,
-				  struct netlink_ext_ack *extack)
-{
-	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
-	int port_mask, cpu_port;
-	int i, ret;
-
-	cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
-	port_mask = BIT(cpu_port);
-
-	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
-		if (dsa_is_cpu_port(ds, i))
-			continue;
-		if (!dsa_port_offloads_bridge(dsa_to_port(ds, i), &bridge))
-			continue;
-		/* Add this port to the portvlan mask of the other ports
-		 * in the bridge
-		 */
-		ret = regmap_set_bits(priv->regmap,
-				      QCA8K_PORT_LOOKUP_CTRL(i),
-				      BIT(port));
-		if (ret)
-			return ret;
-		if (i != port)
-			port_mask |= BIT(i);
-	}
-
-	/* Add all other ports to this ports portvlan mask */
-	ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
-			QCA8K_PORT_LOOKUP_MEMBER, port_mask);
-
-	return ret;
-}
-
-static void qca8k_port_bridge_leave(struct dsa_switch *ds, int port,
-				    struct dsa_bridge bridge)
-{
-	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
-	int cpu_port, i;
-
-	cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
-
-	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
-		if (dsa_is_cpu_port(ds, i))
-			continue;
-		if (!dsa_port_offloads_bridge(dsa_to_port(ds, i), &bridge))
-			continue;
-		/* Remove this port to the portvlan mask of the other ports
-		 * in the bridge
-		 */
-		regmap_clear_bits(priv->regmap,
-				  QCA8K_PORT_LOOKUP_CTRL(i),
-				  BIT(port));
-	}
-
-	/* Set the cpu port to be the only one in the portvlan mask of
-	 * this port
-	 */
-	qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
-		  QCA8K_PORT_LOOKUP_MEMBER, BIT(cpu_port));
-}
-
 static void
 qca8k_port_fast_age(struct dsa_switch *ds, int port)
 {
diff --git a/drivers/net/dsa/qca/qca8k-common.c b/drivers/net/dsa/qca/qca8k-common.c
index 466ea9f9470b..129a82172945 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -9,6 +9,7 @@
 #include <linux/netdevice.h>
 #include <net/dsa.h>
 #include <linux/of_platform.h>
+#include <linux/if_bridge.h>
 
 #include "qca8k.h"
 
@@ -621,3 +622,96 @@ qca8k_get_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *e)
 	/* Nothing to do on the port's MAC */
 	return 0;
 }
+
+void
+qca8k_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
+{
+	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
+	u32 stp_state;
+
+	switch (state) {
+	case BR_STATE_DISABLED:
+		stp_state = QCA8K_PORT_LOOKUP_STATE_DISABLED;
+		break;
+	case BR_STATE_BLOCKING:
+		stp_state = QCA8K_PORT_LOOKUP_STATE_BLOCKING;
+		break;
+	case BR_STATE_LISTENING:
+		stp_state = QCA8K_PORT_LOOKUP_STATE_LISTENING;
+		break;
+	case BR_STATE_LEARNING:
+		stp_state = QCA8K_PORT_LOOKUP_STATE_LEARNING;
+		break;
+	case BR_STATE_FORWARDING:
+	default:
+		stp_state = QCA8K_PORT_LOOKUP_STATE_FORWARD;
+		break;
+	}
+
+	qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
+		  QCA8K_PORT_LOOKUP_STATE_MASK, stp_state);
+}
+
+int qca8k_port_bridge_join(struct dsa_switch *ds, int port,
+			   struct dsa_bridge bridge,
+			   bool *tx_fwd_offload,
+			   struct netlink_ext_ack *extack)
+{
+	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
+	int port_mask, cpu_port;
+	int i, ret;
+
+	cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
+	port_mask = BIT(cpu_port);
+
+	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
+		if (dsa_is_cpu_port(ds, i))
+			continue;
+		if (!dsa_port_offloads_bridge(dsa_to_port(ds, i), &bridge))
+			continue;
+		/* Add this port to the portvlan mask of the other ports
+		 * in the bridge
+		 */
+		ret = regmap_set_bits(priv->regmap,
+				      QCA8K_PORT_LOOKUP_CTRL(i),
+				      BIT(port));
+		if (ret)
+			return ret;
+		if (i != port)
+			port_mask |= BIT(i);
+	}
+
+	/* Add all other ports to this ports portvlan mask */
+	ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
+			QCA8K_PORT_LOOKUP_MEMBER, port_mask);
+
+	return ret;
+}
+
+void qca8k_port_bridge_leave(struct dsa_switch *ds, int port,
+			     struct dsa_bridge bridge)
+{
+	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
+	int cpu_port, i;
+
+	cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
+
+	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
+		if (dsa_is_cpu_port(ds, i))
+			continue;
+		if (!dsa_port_offloads_bridge(dsa_to_port(ds, i), &bridge))
+			continue;
+		/* Remove this port to the portvlan mask of the other ports
+		 * in the bridge
+		 */
+		regmap_clear_bits(priv->regmap,
+				  QCA8K_PORT_LOOKUP_CTRL(i),
+				  BIT(port));
+	}
+
+	/* Set the cpu port to be the only one in the portvlan mask of
+	 * this port
+	 */
+	qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
+		  QCA8K_PORT_LOOKUP_MEMBER, BIT(cpu_port));
+}
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index c842564eb61b..dd3072e2f23c 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -460,4 +460,13 @@ int qca8k_get_sset_count(struct dsa_switch *ds, int port, int sset);
 int qca8k_set_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *eee);
 int qca8k_get_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *e);
 
+/* Common bridge function */
+void qca8k_port_stp_state_set(struct dsa_switch *ds, int port, u8 state);
+int qca8k_port_bridge_join(struct dsa_switch *ds, int port,
+			   struct dsa_bridge bridge,
+			   bool *tx_fwd_offload,
+			   struct netlink_ext_ack *extack);
+void qca8k_port_bridge_leave(struct dsa_switch *ds, int port,
+			     struct dsa_bridge bridge);
+
 #endif /* __QCA8K_H */
-- 
2.36.1

