Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01AA6578FBB
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 03:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236725AbiGSBP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 21:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236706AbiGSBP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 21:15:28 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E82DECA;
        Mon, 18 Jul 2022 18:15:19 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id z12so19465881wrq.7;
        Mon, 18 Jul 2022 18:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=2hNMnmkpJKbF7oRYNoz1+oi3cS6XM9zq1GToWzA/3zs=;
        b=j2VI5DoTrJPtdNN86xUtekgcg9+BT4UKyTc763UaQwVdo7ERs6xAlOAUB/wGU2K/k+
         SfyP1JFbRwMkKSmq13LLOd2sfy2YgdfqDOWrx1jj7xTXiAn6rid7HcL85Z9l/+6zZHeL
         m6L/VNeuDBlyrXZNQ4SQ8xULlIoYZcqnbnuW+weEjT+eX6/AfYLo5dxi3+p+sF5YiHAc
         dhAyWI5yDR+pNTfBkQFhpQwBOUqLdPCgphLsLiHe7tTczIEycnp5D6RsqyTErKvX4AFb
         nLCq/AnEVrs0y0V4jXY/XqqSHlOJVz7VEOklsb9SPEtKlBYGzMR4YMh86ADxFPPyGOP3
         Y2Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2hNMnmkpJKbF7oRYNoz1+oi3cS6XM9zq1GToWzA/3zs=;
        b=ZidC9nW49pN4+C1vQt2TDUSqzPlVqq6hpN2rUILCJJE91anOUXDGHfyiIjwRokvNza
         yYE3OMgL0Ogw/j1Q5lgTYKZoCfBPMVQzrXkdoQK8aptVkZd6FmDi97ItBetKC0JT4Czr
         SlAw18WqCPP90E0NiHLLBmY8C3ifhkmx76+waMpUFTbH0oK2IKPuY+d25vnwKC/bckZQ
         lrFvNvJFRXJaXDae/w6WmONxULQaTZvWYga6En5r36vZTcAxhMKy47HcKhw60PF6CDmK
         XK3nK2197ym6lC9TEOx3xJFO7reky9to4fzlThHjTRJCwA5Ph1uGCPmcgeZgb85bTXPW
         l1Cg==
X-Gm-Message-State: AJIora/IomXMw4iZLjUiRMjfr7zdwonR+GMlzJuQXIylU9Rqg2gbe1YG
        rI3gbGA747EJtuLx5c3KZ3I=
X-Google-Smtp-Source: AGRyM1uPZDeLpfQRvWjNAqthu/2WuVfgv2Rsu0IaEy0ByrvsPg8ykF2TsItB6n/BQLOBtYuYhc8eWA==
X-Received: by 2002:a05:6000:186f:b0:21d:969e:c80e with SMTP id d15-20020a056000186f00b0021d969ec80emr24116770wri.129.1658193318841;
        Mon, 18 Jul 2022 18:15:18 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id y11-20020adff14b000000b0021db7b0162esm11840239wro.105.2022.07.18.18.15.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 18:15:18 -0700 (PDT)
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
Subject: [net-next PATCH v2 09/15] net: dsa: qca8k: move port FDB function to common code
Date:   Tue, 19 Jul 2022 02:57:20 +0200
Message-Id: <20220719005726.8739-11-ansuelsmth@gmail.com>
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

The same port FDB function are used by drivers based on qca8k family
switch. Move them to common code to make them accessible also by other
drivers.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c   | 61 ------------------------------
 drivers/net/dsa/qca/qca8k-common.c | 61 ++++++++++++++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h        | 12 ++++++
 3 files changed, 73 insertions(+), 61 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 95bf65121ed6..4de69a79cc5c 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -1575,67 +1575,6 @@ qca8k_get_ethtool_stats_eth(struct dsa_switch *ds, int port, u64 *data)
 	return ret;
 }
 
-static int
-qca8k_port_fdb_insert(struct qca8k_priv *priv, const u8 *addr,
-		      u16 port_mask, u16 vid)
-{
-	/* Set the vid to the port vlan id if no vid is set */
-	if (!vid)
-		vid = QCA8K_PORT_VID_DEF;
-
-	return qca8k_fdb_add(priv, addr, port_mask, vid,
-			     QCA8K_ATU_STATUS_STATIC);
-}
-
-static int
-qca8k_port_fdb_add(struct dsa_switch *ds, int port,
-		   const unsigned char *addr, u16 vid,
-		   struct dsa_db db)
-{
-	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
-	u16 port_mask = BIT(port);
-
-	return qca8k_port_fdb_insert(priv, addr, port_mask, vid);
-}
-
-static int
-qca8k_port_fdb_del(struct dsa_switch *ds, int port,
-		   const unsigned char *addr, u16 vid,
-		   struct dsa_db db)
-{
-	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
-	u16 port_mask = BIT(port);
-
-	if (!vid)
-		vid = QCA8K_PORT_VID_DEF;
-
-	return qca8k_fdb_del(priv, addr, port_mask, vid);
-}
-
-static int
-qca8k_port_fdb_dump(struct dsa_switch *ds, int port,
-		    dsa_fdb_dump_cb_t *cb, void *data)
-{
-	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
-	struct qca8k_fdb _fdb = { 0 };
-	int cnt = QCA8K_NUM_FDB_RECORDS;
-	bool is_static;
-	int ret = 0;
-
-	mutex_lock(&priv->reg_mutex);
-	while (cnt-- && !qca8k_fdb_next(priv, &_fdb, port)) {
-		if (!_fdb.aging)
-			break;
-		is_static = (_fdb.aging == QCA8K_ATU_STATUS_STATIC);
-		ret = cb(_fdb.mac, _fdb.vid, is_static, data);
-		if (ret)
-			break;
-	}
-	mutex_unlock(&priv->reg_mutex);
-
-	return 0;
-}
-
 static int
 qca8k_port_mdb_add(struct dsa_switch *ds, int port,
 		   const struct switchdev_obj_port_mdb *mdb,
diff --git a/drivers/net/dsa/qca/qca8k-common.c b/drivers/net/dsa/qca/qca8k-common.c
index 598d6577835a..f35287c9f4bb 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -813,3 +813,64 @@ qca8k_port_max_mtu(struct dsa_switch *ds, int port)
 {
 	return QCA8K_MAX_MTU;
 }
+
+int
+qca8k_port_fdb_insert(struct qca8k_priv *priv, const u8 *addr,
+		      u16 port_mask, u16 vid)
+{
+	/* Set the vid to the port vlan id if no vid is set */
+	if (!vid)
+		vid = QCA8K_PORT_VID_DEF;
+
+	return qca8k_fdb_add(priv, addr, port_mask, vid,
+			     QCA8K_ATU_STATUS_STATIC);
+}
+
+int
+qca8k_port_fdb_add(struct dsa_switch *ds, int port,
+		   const unsigned char *addr, u16 vid,
+		   struct dsa_db db)
+{
+	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
+	u16 port_mask = BIT(port);
+
+	return qca8k_port_fdb_insert(priv, addr, port_mask, vid);
+}
+
+int
+qca8k_port_fdb_del(struct dsa_switch *ds, int port,
+		   const unsigned char *addr, u16 vid,
+		   struct dsa_db db)
+{
+	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
+	u16 port_mask = BIT(port);
+
+	if (!vid)
+		vid = QCA8K_PORT_VID_DEF;
+
+	return qca8k_fdb_del(priv, addr, port_mask, vid);
+}
+
+int
+qca8k_port_fdb_dump(struct dsa_switch *ds, int port,
+		    dsa_fdb_dump_cb_t *cb, void *data)
+{
+	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
+	struct qca8k_fdb _fdb = { 0 };
+	int cnt = QCA8K_NUM_FDB_RECORDS;
+	bool is_static;
+	int ret = 0;
+
+	mutex_lock(&priv->reg_mutex);
+	while (cnt-- && !qca8k_fdb_next(priv, &_fdb, port)) {
+		if (!_fdb.aging)
+			break;
+		is_static = (_fdb.aging == QCA8K_ATU_STATUS_STATIC);
+		ret = cb(_fdb.mac, _fdb.vid, is_static, data);
+		if (ret)
+			break;
+	}
+	mutex_unlock(&priv->reg_mutex);
+
+	return 0;
+}
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index bc9078ae2b70..a5fa9ee31a79 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -482,4 +482,16 @@ void qca8k_port_disable(struct dsa_switch *ds, int port);
 int qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu);
 int qca8k_port_max_mtu(struct dsa_switch *ds, int port);
 
+/* Common FDB function */
+int qca8k_port_fdb_insert(struct qca8k_priv *priv, const u8 *addr,
+			  u16 port_mask, u16 vid);
+int qca8k_port_fdb_add(struct dsa_switch *ds, int port,
+		       const unsigned char *addr, u16 vid,
+		       struct dsa_db db);
+int qca8k_port_fdb_del(struct dsa_switch *ds, int port,
+		       const unsigned char *addr, u16 vid,
+		       struct dsa_db db);
+int qca8k_port_fdb_dump(struct dsa_switch *ds, int port,
+			dsa_fdb_dump_cb_t *cb, void *data);
+
 #endif /* __QCA8K_H */
-- 
2.36.1

