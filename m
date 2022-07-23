Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03E9257EF74
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 16:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237794AbiGWOUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 10:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237644AbiGWOTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 10:19:50 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E7DE1C906;
        Sat, 23 Jul 2022 07:19:49 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id r9-20020a1c4409000000b003a34ac64bdfso799741wma.1;
        Sat, 23 Jul 2022 07:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=BMx/T/Bqvpk3Wg3r2qZX0Ig/agh5YbILbcBE69RugMc=;
        b=IctTYi0jCivnF4kLdqjhgKOuHmMciKxrhmf5p1smYV1dbzlBeQkrIVaiw9PzJe/Nnv
         JwuU+jlC1eVW7+sZcLUtt3TLo4EUwKRWT7oXduA6oIyiNzfh4A7llZWoTFWpfuZkESDc
         MSlxy+uis3Jl4VM6fOIZCw2oBAvvSwqmMBIsJQqgukvCR2PWrUucg/fojVHzoUSVRh2G
         EV6pEcVzQRmQr1MK1LQl6n3EJ4tPAizWq7NtOBHavXzGujENqQ/65SNh1aVtxpwNC6Cs
         4KO8sy2LZk9c0bsZH5ckkfWKBwaqWZ/CUe9aFDu6M65oHYZsZOXundlFl+HW1QSP6WR5
         W7PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BMx/T/Bqvpk3Wg3r2qZX0Ig/agh5YbILbcBE69RugMc=;
        b=PnYrGhCjxYFZpXYDYZpgU+SIKmGxaX3xkKloDtKcjYKxNe0t+TKbGrvvXfhrv2HCSN
         ZMK3Nr/bSibaTHMKgi3q+RxHcDXVQRpjHF/u6HPfE//DBI9jt/6cI44WME/wKqVbxq4X
         cewlpx/oDS1iSD2KdLVWtWN3wMIU19+tt0/rSqagm8q9KwgAZjU6vdBYkcoH7E40m0bO
         Ey2mOTTOsp8vxd47Ky0Ri5gI83T+gAGc+2NPZFKaMBhH3wpvvm4tcUEWbK5RP9waImJv
         VZOkvlFSMmPMnx3YTPHI5FSou/6kduFZVhrpxsZXWQ3bCayBqvUKHpu2dWfA4nChqQE8
         Vqkw==
X-Gm-Message-State: AJIora+1lZBuWO3xRRVBuFr5Fl884+ljy+tqCs1Xr9U7uGAG/eUX1TYg
        DXXNaOMVFq6w5FfcoJLOU9yURBnygvc=
X-Google-Smtp-Source: AGRyM1vytuk7iPD0VG0r8IuzxrkVGeKoceylWaXMA9W4yFZ3fDR+ITM4MqolePfR7ox/vAy5T9CeNA==
X-Received: by 2002:a1c:4c0f:0:b0:3a3:1401:7660 with SMTP id z15-20020a1c4c0f000000b003a314017660mr15914869wmf.8.1658585988862;
        Sat, 23 Jul 2022 07:19:48 -0700 (PDT)
Received: from localhost.localdomain (host-87-7-207-127.retail.telecomitalia.it. [87.7.207.127])
        by smtp.googlemail.com with ESMTPSA id l18-20020a05600c1d1200b003a04d19dab3sm21011960wms.3.2022.07.23.07.19.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jul 2022 07:19:48 -0700 (PDT)
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
Subject: [net-next PATCH v3 08/14] net: dsa: qca8k: move bridge functions to common code
Date:   Sat, 23 Jul 2022 16:18:39 +0200
Message-Id: <20220723141845.10570-9-ansuelsmth@gmail.com>
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
index 7042bf8d94c8..c4fce50a91f7 100644
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
index 369c763fbb5d..754d3bee20cb 100644
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
index 9657c0a07bdd..e16263fec91f 100644
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

