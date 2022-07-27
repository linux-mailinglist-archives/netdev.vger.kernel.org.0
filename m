Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADEB15825AA
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 13:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbiG0Lgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 07:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232249AbiG0LgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 07:36:05 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26CB4A80B;
        Wed, 27 Jul 2022 04:35:53 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id oy13so30979846ejb.1;
        Wed, 27 Jul 2022 04:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=n3uP0n8WEVP/ZpEVjoeqf0ElYkVUtFFVT2Yra7D28lI=;
        b=kqcJLz/9hF1qtx2ihYL5eO6o9LHFvGgT0acTr+bXc+uZGdhFG2guI60/3CJ8i1Womk
         OmIz/05W67SCxNjxPF/vAS79GBfQ1/9Is8qeJooxcQj7jrbTcmxwblgh6aoiPdXGM7gt
         FS4DVk/SIdfFXqKiPcu51Ffv6ncM97uU3LDwq9neR01+Uy8QpHb6P+59bZL4Q0DZ1o6H
         VfKoqxq/f9JdH7+e5ZHMZIkCoP49P9n2e0MKWcQFd1lw/kcFEs0X9gpJ7SgQ9MYKP1wf
         5rKXbc/gQUMNM+EWue7eIP6aR9wngXmlPHjFth8IPn4oCrLg532FAkoiOP7oGdCIfmAf
         cwEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n3uP0n8WEVP/ZpEVjoeqf0ElYkVUtFFVT2Yra7D28lI=;
        b=f/vax0LiVPqzq4nrEBjgmGMnXkI0gviGpyBZJ7Cvw/ZBQ/csdvteSbVcXxX/lnRPiZ
         XCY/NIbMb5+84BGn+6xCIuii+Lon4wh9w5Q4OTgMDZl0EwVabmbWKPfHtEN940+SW+y6
         yh7IT886oSTqxVtvG3aEvdseJBWW2KF6Q9IjVpAVzxL/DkfKKYp3XghklW83nUqZUssO
         evGavSLs1bZX+g1lJ83WcUBd04CnfvfLIAKQcJahGc4vafI0x+Qz6wqH9RaoEuxJf+6I
         PZlfvFusm7NSmvlCja1KIghQaTL4G2L5jRfUvzGSdNZCD30YPzO6oJyviDfr774FzjPr
         Th3Q==
X-Gm-Message-State: AJIora8ZCAkeHaAPxSAdCeFF3fIRt6CE/Adw2SRj63nBr7j1HRUAFoVG
        9P7Bsb/WoyTMRNLrGblPx1k=
X-Google-Smtp-Source: AGRyM1vuVo2xh2ZLfeu7unwdr9ab0YNqyl8RO9XMXCBu0B604K18Ir4b53V5jKkd9bBlB2fGUWT2Qg==
X-Received: by 2002:a17:907:7394:b0:72b:44ff:5cec with SMTP id er20-20020a170907739400b0072b44ff5cecmr17721686ejc.670.1658921751950;
        Wed, 27 Jul 2022 04:35:51 -0700 (PDT)
Received: from localhost.localdomain (c105-182.i13-27.melita.com. [94.17.105.182])
        by smtp.googlemail.com with ESMTPSA id p25-20020aa7cc99000000b0043ca6fb7e7dsm1334056edt.68.2022.07.27.04.35.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 04:35:51 -0700 (PDT)
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
Subject: [net-next PATCH v5 08/14] net: dsa: qca8k: move bridge functions to common code
Date:   Wed, 27 Jul 2022 13:35:17 +0200
Message-Id: <20220727113523.19742-9-ansuelsmth@gmail.com>
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

The same bridge functions are used by drivers based on qca8k family
switch. Move them to common code to make them accessible also by other
drivers.
While at it also drop unnecessary qca8k_priv cast for void pointers.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c   | 93 ------------------------------
 drivers/net/dsa/qca/qca8k-common.c | 93 ++++++++++++++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h        |  9 +++
 3 files changed, 102 insertions(+), 93 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 9729aabbd83d..11d3116733af 100644
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
index c662fdbae51f..13069c9ba3e6 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -8,6 +8,7 @@
 
 #include <linux/netdevice.h>
 #include <net/dsa.h>
+#include <linux/if_bridge.h>
 
 #include "qca8k.h"
 
@@ -275,3 +276,95 @@ int qca8k_get_mac_eee(struct dsa_switch *ds, int port,
 	/* Nothing to do on the port's MAC */
 	return 0;
 }
+
+void qca8k_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
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

