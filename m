Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF30578FAA
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 03:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236545AbiGSBQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 21:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236750AbiGSBP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 21:15:29 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE19DE01F;
        Mon, 18 Jul 2022 18:15:21 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id ay11-20020a05600c1e0b00b003a3013da120so8992482wmb.5;
        Mon, 18 Jul 2022 18:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=D3q2KKCklwzHHZq8ezmLO4MGStZ07kcipnQWUA9eAvc=;
        b=fYxnXw61/gjevY6Nnfb3jDTgoLMZPOiYMoRsnjOQT06Zy7FtIfVITczkMtrP93r7gi
         ELRkuAuHE9mk496PLJCZGsLdh8Z1TSoOip6pzJNrDWUGJKM5dEN64kpbeebswnNJsTrX
         ZLpU6OQqLEtDAKFUfD9cXztllBzSg8YyvsNGfPp7jN4GNIR7tD2v0zcfscH4ILjDmYyF
         HwrVvSExqW/qlDlZuaD4v27s8Af2sG7QjzD3++ZT/oSy8tlM2xqUT1CQqF8weraRNPl2
         i9a8bcNv5MK9XjISRWgwumRh9krt5Quc5ZqWa/Ip27AXPYYwJlYgy6QhRW0+XHQx7VGO
         up8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D3q2KKCklwzHHZq8ezmLO4MGStZ07kcipnQWUA9eAvc=;
        b=1CWeszDE30lmpDw6xrdJ/JC28ujJSvQy7cOObGteNkimMpn6/QXI0gu8fRuwcImy/i
         hdnxpAd/Rp0Ih4dFNLXZnmK8GddPHoJhoVZGCnW1NB/Nq6OPHAY3eUIXckHXv+Toe38o
         B95BuRgv/W4bRCJJVUFcGplZEfthy6ULrvHoBWimlzILRmI4hSua79S5r2UAKX0EbF6o
         upLsoOz7MT/FuAGhEtdPY4b1N/O+LV/NydxiEVbhlwzV1tr6zaWM5mMGYg68qV1FYEcK
         R30AphCp2AeDl0ngh7OVFsZvu4aoEQTn+gttP6m5k6El5EWHfSxcMn4cibwe0OezDDFd
         Cdaw==
X-Gm-Message-State: AJIora/dztn87fNOTp0Ud5esZJOMdeTlyITxfjCvTTxPUydi//EmEuVY
        nxpxnig9fGGft+CY4HPpbHY=
X-Google-Smtp-Source: AGRyM1tdctZurWehiVJag3fe8yVXnAx63WODRxSUnemCtqIhrCG6aG4AlJwLw7spJryP31yvqw0Gsg==
X-Received: by 2002:a05:600c:2854:b0:3a3:1551:d7d with SMTP id r20-20020a05600c285400b003a315510d7dmr11073354wmb.174.1658193320060;
        Mon, 18 Jul 2022 18:15:20 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id y11-20020adff14b000000b0021db7b0162esm11840239wro.105.2022.07.18.18.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 18:15:19 -0700 (PDT)
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
Subject: [net-next PATCH v2 10/15] net: dsa: qca8k: move port MDB functions to common code
Date:   Tue, 19 Jul 2022 02:57:21 +0200
Message-Id: <20220719005726.8739-12-ansuelsmth@gmail.com>
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

The same port MDB functions are used by drivers based on qca8k family
switch. Move them to common code to make them accessible also by other
drivers.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c   | 24 ------------------------
 drivers/net/dsa/qca/qca8k-common.c | 24 ++++++++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h        |  8 ++++++++
 3 files changed, 32 insertions(+), 24 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 4de69a79cc5c..776c53aef5c4 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -1575,30 +1575,6 @@ qca8k_get_ethtool_stats_eth(struct dsa_switch *ds, int port, u64 *data)
 	return ret;
 }
 
-static int
-qca8k_port_mdb_add(struct dsa_switch *ds, int port,
-		   const struct switchdev_obj_port_mdb *mdb,
-		   struct dsa_db db)
-{
-	struct qca8k_priv *priv = ds->priv;
-	const u8 *addr = mdb->addr;
-	u16 vid = mdb->vid;
-
-	return qca8k_fdb_search_and_insert(priv, BIT(port), addr, vid);
-}
-
-static int
-qca8k_port_mdb_del(struct dsa_switch *ds, int port,
-		   const struct switchdev_obj_port_mdb *mdb,
-		   struct dsa_db db)
-{
-	struct qca8k_priv *priv = ds->priv;
-	const u8 *addr = mdb->addr;
-	u16 vid = mdb->vid;
-
-	return qca8k_fdb_search_and_del(priv, BIT(port), addr, vid);
-}
-
 static int
 qca8k_port_mirror_add(struct dsa_switch *ds, int port,
 		      struct dsa_mall_mirror_tc_entry *mirror,
diff --git a/drivers/net/dsa/qca/qca8k-common.c b/drivers/net/dsa/qca/qca8k-common.c
index f35287c9f4bb..796293738b35 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -874,3 +874,27 @@ qca8k_port_fdb_dump(struct dsa_switch *ds, int port,
 
 	return 0;
 }
+
+int
+qca8k_port_mdb_add(struct dsa_switch *ds, int port,
+		   const struct switchdev_obj_port_mdb *mdb,
+		   struct dsa_db db)
+{
+	struct qca8k_priv *priv = ds->priv;
+	const u8 *addr = mdb->addr;
+	u16 vid = mdb->vid;
+
+	return qca8k_fdb_search_and_insert(priv, BIT(port), addr, vid);
+}
+
+int
+qca8k_port_mdb_del(struct dsa_switch *ds, int port,
+		   const struct switchdev_obj_port_mdb *mdb,
+		   struct dsa_db db)
+{
+	struct qca8k_priv *priv = ds->priv;
+	const u8 *addr = mdb->addr;
+	u16 vid = mdb->vid;
+
+	return qca8k_fdb_search_and_del(priv, BIT(port), addr, vid);
+}
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index a5fa9ee31a79..31f6f98960d6 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -494,4 +494,12 @@ int qca8k_port_fdb_del(struct dsa_switch *ds, int port,
 int qca8k_port_fdb_dump(struct dsa_switch *ds, int port,
 			dsa_fdb_dump_cb_t *cb, void *data);
 
+/* Common MDB function */
+int qca8k_port_mdb_add(struct dsa_switch *ds, int port,
+		       const struct switchdev_obj_port_mdb *mdb,
+		       struct dsa_db db);
+int qca8k_port_mdb_del(struct dsa_switch *ds, int port,
+		       const struct switchdev_obj_port_mdb *mdb,
+		       struct dsa_db db);
+
 #endif /* __QCA8K_H */
-- 
2.36.1

