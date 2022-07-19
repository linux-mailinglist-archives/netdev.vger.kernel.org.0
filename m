Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0072F578FB2
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 03:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236786AbiGSBQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 21:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236762AbiGSBP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 21:15:29 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0634EDEF6;
        Mon, 18 Jul 2022 18:15:24 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id v16so3627693wrr.6;
        Mon, 18 Jul 2022 18:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=kh48UIVPdJubSbMr+jO4y2hNOnd4zR7rS7cK6Xd47eM=;
        b=qbrth6W1466Hvoj4ifoE0o0PxzmYoeaRt3mheJ30GUuEdj8D6I9J/IkGiSV1id3v8U
         qUcl4yTXkUrcCeS1Z7TaM4jAr2c4blmcK2YRd+Kqtn05BulDPc40VOOXGxw+6MbyNTxI
         NuU6dTQC5VweOTjKwM8CxB6UvPCQAq3CpJZPaJwoyH/ANxrCXnA89/5jl7lVA4xce3Hr
         ZwUFABu6LbYJRKrEZOpY2dOG5VQHk45q5zWN0yqFZEzJn6uWqddP4xGdvpE/A9w9lQbI
         jpxEIddcs1uffQZS6zsd7EmF/mcMhF/iJWEouR6b8JqautI7MSgM7S5m8kt0CIT30iN8
         bgDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kh48UIVPdJubSbMr+jO4y2hNOnd4zR7rS7cK6Xd47eM=;
        b=VK0b1fXgrYHxC8iQkn3BAKyyukdR/bgg13OOqtJI/V4W395mo/95aqpHVXJcw9WpF8
         kD6GEBD0gkDc//GAa0C6oNv/GarWyqVWmk4p4VXL3Tz0xtu3GZ6WzzKsJaE5FvYOfAO4
         xEC2T24F0IIOu40G3MVeF150g7/kG2ZYwILBMvembMn0Ss62G7/J+wXZCRxX2BzJTRpA
         QlxICM7d28jjy/wnVQQMp8G3mUP+s1i4aK/zAdCsLczZo8RBeCl4+lF109khIfgaVqTy
         EQKQdESTTKdrmtiAXc1jik0x0Nr346ZiAZAk4aWrhJ8kcxXGmC9T9sUMnT0E201nU5DP
         FJrg==
X-Gm-Message-State: AJIora9AKjJGgsg0/JYS4Jahz6SPGTXjwf6Ri9H+MSHoSv6eXHT0F/Bs
        iOYqgKXTSALL0f6EeYX7Ods=
X-Google-Smtp-Source: AGRyM1tdiOD4YIcyaGoykn/z8HtkFKFr85d48mAcgt7P9HAdTdiBiQBG/bahXFS5oYBbq2nXEf1o4w==
X-Received: by 2002:a05:6000:1847:b0:21d:c149:263 with SMTP id c7-20020a056000184700b0021dc1490263mr20092801wri.449.1658193322423;
        Mon, 18 Jul 2022 18:15:22 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id y11-20020adff14b000000b0021db7b0162esm11840239wro.105.2022.07.18.18.15.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 18:15:22 -0700 (PDT)
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
Subject: [net-next PATCH v2 12/15] net: dsa: qca8k: move port VLAN functions to common code
Date:   Tue, 19 Jul 2022 02:57:23 +0200
Message-Id: <20220719005726.8739-14-ansuelsmth@gmail.com>
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

The same port VLAN functions are used by drivers based on qca8k family
switch. Move them to common code to make them accessible also by other
drivers.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c   | 65 ------------------------------
 drivers/net/dsa/qca/qca8k-common.c | 65 ++++++++++++++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h        |  9 +++++
 3 files changed, 74 insertions(+), 65 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index d12ba61841b9..d6223ee79389 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -1575,71 +1575,6 @@ qca8k_get_ethtool_stats_eth(struct dsa_switch *ds, int port, u64 *data)
 	return ret;
 }
 
-static int
-qca8k_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
-			  struct netlink_ext_ack *extack)
-{
-	struct qca8k_priv *priv = ds->priv;
-	int ret;
-
-	if (vlan_filtering) {
-		ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
-				QCA8K_PORT_LOOKUP_VLAN_MODE_MASK,
-				QCA8K_PORT_LOOKUP_VLAN_MODE_SECURE);
-	} else {
-		ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
-				QCA8K_PORT_LOOKUP_VLAN_MODE_MASK,
-				QCA8K_PORT_LOOKUP_VLAN_MODE_NONE);
-	}
-
-	return ret;
-}
-
-static int
-qca8k_port_vlan_add(struct dsa_switch *ds, int port,
-		    const struct switchdev_obj_port_vlan *vlan,
-		    struct netlink_ext_ack *extack)
-{
-	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
-	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
-	struct qca8k_priv *priv = ds->priv;
-	int ret;
-
-	ret = qca8k_vlan_add(priv, port, vlan->vid, untagged);
-	if (ret) {
-		dev_err(priv->dev, "Failed to add VLAN to port %d (%d)", port, ret);
-		return ret;
-	}
-
-	if (pvid) {
-		ret = qca8k_rmw(priv, QCA8K_EGRESS_VLAN(port),
-				QCA8K_EGREES_VLAN_PORT_MASK(port),
-				QCA8K_EGREES_VLAN_PORT(port, vlan->vid));
-		if (ret)
-			return ret;
-
-		ret = qca8k_write(priv, QCA8K_REG_PORT_VLAN_CTRL0(port),
-				  QCA8K_PORT_VLAN_CVID(vlan->vid) |
-				  QCA8K_PORT_VLAN_SVID(vlan->vid));
-	}
-
-	return ret;
-}
-
-static int
-qca8k_port_vlan_del(struct dsa_switch *ds, int port,
-		    const struct switchdev_obj_port_vlan *vlan)
-{
-	struct qca8k_priv *priv = ds->priv;
-	int ret;
-
-	ret = qca8k_vlan_del(priv, port, vlan->vid);
-	if (ret)
-		dev_err(priv->dev, "Failed to delete VLAN from port %d (%d)", port, ret);
-
-	return ret;
-}
-
 static u32 qca8k_get_phy_flags(struct dsa_switch *ds, int port)
 {
 	struct qca8k_priv *priv = ds->priv;
diff --git a/drivers/net/dsa/qca/qca8k-common.c b/drivers/net/dsa/qca/qca8k-common.c
index 2f3a1343b13c..11af3b09ae81 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -991,3 +991,68 @@ qca8k_port_mirror_del(struct dsa_switch *ds, int port,
 err:
 	dev_err(priv->dev, "Failed to del mirror port from %d", port);
 }
+
+int
+qca8k_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
+			  struct netlink_ext_ack *extack)
+{
+	struct qca8k_priv *priv = ds->priv;
+	int ret;
+
+	if (vlan_filtering) {
+		ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
+				QCA8K_PORT_LOOKUP_VLAN_MODE_MASK,
+				QCA8K_PORT_LOOKUP_VLAN_MODE_SECURE);
+	} else {
+		ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
+				QCA8K_PORT_LOOKUP_VLAN_MODE_MASK,
+				QCA8K_PORT_LOOKUP_VLAN_MODE_NONE);
+	}
+
+	return ret;
+}
+
+int
+qca8k_port_vlan_add(struct dsa_switch *ds, int port,
+		    const struct switchdev_obj_port_vlan *vlan,
+		    struct netlink_ext_ack *extack)
+{
+	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
+	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
+	struct qca8k_priv *priv = ds->priv;
+	int ret;
+
+	ret = qca8k_vlan_add(priv, port, vlan->vid, untagged);
+	if (ret) {
+		dev_err(priv->dev, "Failed to add VLAN to port %d (%d)", port, ret);
+		return ret;
+	}
+
+	if (pvid) {
+		ret = qca8k_rmw(priv, QCA8K_EGRESS_VLAN(port),
+				QCA8K_EGREES_VLAN_PORT_MASK(port),
+				QCA8K_EGREES_VLAN_PORT(port, vlan->vid));
+		if (ret)
+			return ret;
+
+		ret = qca8k_write(priv, QCA8K_REG_PORT_VLAN_CTRL0(port),
+				  QCA8K_PORT_VLAN_CVID(vlan->vid) |
+				  QCA8K_PORT_VLAN_SVID(vlan->vid));
+	}
+
+	return ret;
+}
+
+int
+qca8k_port_vlan_del(struct dsa_switch *ds, int port,
+		    const struct switchdev_obj_port_vlan *vlan)
+{
+	struct qca8k_priv *priv = ds->priv;
+	int ret;
+
+	ret = qca8k_vlan_del(priv, port, vlan->vid);
+	if (ret)
+		dev_err(priv->dev, "Failed to delete VLAN from port %d (%d)", port, ret);
+
+	return ret;
+}
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index c9c8ec7abdc2..aa4fe02a2155 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -509,4 +509,13 @@ int qca8k_port_mirror_add(struct dsa_switch *ds, int port,
 void qca8k_port_mirror_del(struct dsa_switch *ds, int port,
 			   struct dsa_mall_mirror_tc_entry *mirror);
 
+/* Common port VLAN function */
+int qca8k_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
+			      struct netlink_ext_ack *extack);
+int qca8k_port_vlan_add(struct dsa_switch *ds, int port,
+			const struct switchdev_obj_port_vlan *vlan,
+			struct netlink_ext_ack *extack);
+int qca8k_port_vlan_del(struct dsa_switch *ds, int port,
+			const struct switchdev_obj_port_vlan *vlan);
+
 #endif /* __QCA8K_H */
-- 
2.36.1

