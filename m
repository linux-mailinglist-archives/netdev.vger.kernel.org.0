Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFBD57F77D
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 00:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232873AbiGXWv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 18:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232007AbiGXWvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 18:51:19 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D60BE16;
        Sun, 24 Jul 2022 15:51:14 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id i13so2777867edj.11;
        Sun, 24 Jul 2022 15:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=QkgUDumPrkaM5NUxqco9H1jI4lwbaIocq1ezSpE4ILg=;
        b=OrwfFCc1rh4pNzogRCk6mJLHGd1lSMQTwporNZwUoCmKUJWSKcW0kTV9oTBDrqvddU
         zrfxWGWWTQ4FBZmkNgpmgDzRqXlBMiCRDyiGWYBKe5yRV6p01M3hVIqttne1m5Vi6PaI
         sDaogBZgfe8pHAbv9/VsrAOlUnK5LQJ8UoN38HeCHN2BP/LPSFm/2Mxc18lluhixNJkN
         dd95ndDRSRS6GRG/08trrSrzL9nee0qsoIBRnMpvAaJl7sB54bFUNDu5yNGjf3HVlRd/
         lsnzyqTUkUeWWaOyxnHcBId7TVOw0Wrdps7PgoSpTWJoelIlv+Kdv3Ho1F2bg6IUwO/f
         0XOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QkgUDumPrkaM5NUxqco9H1jI4lwbaIocq1ezSpE4ILg=;
        b=onOxFdUwEf5gItf/Q75U4sxTB5ZxeUM96PPaFCPLypvLg2J1Uf/Kwyav9vU7u5/FIY
         z97xDF2O7jzFiGyHuLyCGMs8tomoyZl0E+P2pXFGeVOsfcpb+3H9H2kwTDjAImABv658
         awkOJvOrAbDbc64eYaOLHvFxOrQJaY+n0qBL43oLNMlUsKSLsuxaug5NPsCEvM/FCCty
         5qKs34lI9OS67XS3Xfd6lOBinMVtp49w1oKbbeyivaVBG/Rbc7xYPZB0L1GlhUeWO+8/
         u2VD2Fh5iyYwLF1NX7LdMokYHGYzhYpK1fv3ZHcI/8/t9BKxliMoMszfrEUqntG742tK
         swDg==
X-Gm-Message-State: AJIora8ftnweWnRVwxx0KBc63+EZnA5K38ndTfjY1IdvesUSwqo7HUgg
        AQk++f8MoeUOC67q9fYnEIQ=
X-Google-Smtp-Source: AGRyM1vvCaCKdeycCbFVwnI3PNhRvQzIy9N3BuJYOeNV8w526X/N1rrk3dsIUMw8GYlKVodBff/QVA==
X-Received: by 2002:a05:6402:500e:b0:43b:6f0:756b with SMTP id p14-20020a056402500e00b0043b06f0756bmr10727653eda.221.1658703073817;
        Sun, 24 Jul 2022 15:51:13 -0700 (PDT)
Received: from localhost.localdomain (93-42-69-122.ip85.fastwebnet.it. [93.42.69.122])
        by smtp.googlemail.com with ESMTPSA id nc19-20020a1709071c1300b00722d5b26ecesm4645238ejc.205.2022.07.24.15.51.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jul 2022 15:51:13 -0700 (PDT)
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
Subject: [net-next PATCH v4 08/14] net: dsa: qca8k: move bridge functions to common code
Date:   Sun, 24 Jul 2022 22:19:32 +0200
Message-Id: <20220724201938.17387-9-ansuelsmth@gmail.com>
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

The same bridge functions are used by drivers based on qca8k family
switch. Move them to common code to make them accessible also by other
drivers.
While at it also drop unnecessary qca8k_priv cast for void pointers.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c   | 93 -----------------------------
 drivers/net/dsa/qca/qca8k-common.c | 94 ++++++++++++++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h        |  9 +++
 3 files changed, 103 insertions(+), 93 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index f86b70c0cd47..f25aaf8d4ec8 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -1898,99 +1898,6 @@ qca8k_get_ethtool_stats_eth(struct dsa_switch *ds, int port, u64 *data)
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
index c6c5549389df..a50c21c90e81 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -8,6 +8,7 @@
 
 #include <linux/netdevice.h>
 #include <net/dsa.h>
+#include <linux/if_bridge.h>
 
 #include "qca8k.h"
 
@@ -279,3 +280,96 @@ qca8k_get_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *e)
 	/* Nothing to do on the port's MAC */
 	return 0;
 }
+
+void
+qca8k_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
+{
+	struct qca8k_priv *priv = ds->priv;
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
+	struct qca8k_priv *priv = ds->priv;
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
+	struct qca8k_priv *priv = ds->priv;
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
index c73cbdfc6ac6..edb2b23a02b9 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -454,4 +454,13 @@ int qca8k_get_sset_count(struct dsa_switch *ds, int port, int sset);
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

