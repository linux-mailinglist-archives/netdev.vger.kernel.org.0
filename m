Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA3E0578FBA
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 03:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236684AbiGSBQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 21:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236780AbiGSBPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 21:15:30 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6295011C03;
        Mon, 18 Jul 2022 18:15:27 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id f24-20020a1cc918000000b003a30178c022so8931973wmb.3;
        Mon, 18 Jul 2022 18:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=w3v6aZ+NSaZPkut8FbieQWcMCtLgS2i3kmCno6mm5fM=;
        b=ADhQhlyVAuHE3ISCyQqMzdQ9B6FlVe9SaCKCrdass+R/9hHKadK8+aOdglXLjlN5rh
         LIkMg/X9YkvH71kRCXQZpPnTDCN2W9ThtET7psZpq+6vKOxFfiN/qUzRuT7RAHAdakYq
         6Jne/7xef0ryL33sn9zptewH0ZxEfh+Gps7GTnF4HK1yhalwNaIkAMFmtDBoIF87Rwnf
         ijcCbDd9WdwBoq40WvIUTiACHZZlOdBvRLiZyM9YKE9hi2kj5opXm4YnqvCwsDCrQsIG
         HPqEBcLUIbVEXSAkRsAvd5H2qC5CJVPjlQAtTrr1y9rAZsCg/kDEzMo9GNh/nFkHXVlq
         WIPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w3v6aZ+NSaZPkut8FbieQWcMCtLgS2i3kmCno6mm5fM=;
        b=JXoD9Q0c7gHwEBpjcPrfFXjfFH4vzOmIb3/8/6jKDJ2RW8TRquI0diuXf/OwPeO5m0
         G6/i1qzDknfffELYMQSDm68B+/c0FLapJFUQCjmtLE385nZZJ+xCfzB+3nce3b7PNvIR
         9OqOcWkfK9pVBR3HA31uEglKghJQASJK8l0F5fQsxj1pEmCFn1XXfkPdHUIS7kgYrXjm
         BR0Np7qp6h/MVUNg+YKJFCSmrSTctuB6xUHuu4deROElisuxoIGm87I9WdR1gXnEaGXk
         wW8q3NTk/bciDkHuQgYFMikV+fWzSWqY9+9TBnJe0ebia1JG7XU5wYoM3kcDRROXgPJJ
         vFLQ==
X-Gm-Message-State: AJIora9ybe8Lr/VABRvPhigMtMrtssl63dXgF9LsyU31A6FdoUtGGV+q
        fXwVZ+WFWRLRprDrRTSDh8Q=
X-Google-Smtp-Source: AGRyM1tpHS7j/et9JxQGQOUm9Zl4YBaQqPL61Bed5ASqlYRTSeST5iJMX8O6VY8VNwySngXBfs9Z1w==
X-Received: by 2002:a1c:740d:0:b0:3a3:e1:179f with SMTP id p13-20020a1c740d000000b003a300e1179fmr22884866wmc.17.1658193325754;
        Mon, 18 Jul 2022 18:15:25 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id y11-20020adff14b000000b0021db7b0162esm11840239wro.105.2022.07.18.18.15.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 18:15:25 -0700 (PDT)
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
Subject: [net-next PATCH v2 15/15] net: dsa: qca8k: drop unnecessary exposed function and make them static
Date:   Tue, 19 Jul 2022 02:57:26 +0200
Message-Id: <20220719005726.8739-17-ansuelsmth@gmail.com>
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

Some function were exposed to permit migration to common code. Drop them
and make them static now that the user are in the same common code.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca/qca8k-common.c | 22 +++++++++++-----------
 drivers/net/dsa/qca/qca8k.h        | 14 --------------
 2 files changed, 11 insertions(+), 25 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-common.c b/drivers/net/dsa/qca/qca8k-common.c
index 6e6cdb173556..5369f7b10482 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -104,7 +104,7 @@ const struct regmap_access_table qca8k_readable_table = {
 };
 
 /* TODO: remove these extra ops when we can support regmap bulk read/write */
-int qca8k_bulk_read(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
+static int qca8k_bulk_read(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 {
 	int i, count = len / sizeof(u32), ret;
 	const struct qca8k_match_data *data;
@@ -125,7 +125,7 @@ int qca8k_bulk_read(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 }
 
 /* TODO: remove these extra ops when we can support regmap bulk read/write */
-int qca8k_bulk_write(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
+static int qca8k_bulk_write(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 {
 	int i, count = len / sizeof(u32), ret;
 	const struct qca8k_match_data *data;
@@ -184,7 +184,7 @@ qca8k_fdb_read(struct qca8k_priv *priv, struct qca8k_fdb *fdb)
 	return 0;
 }
 
-void
+static void
 qca8k_fdb_write(struct qca8k_priv *priv, u16 vid, u8 port_mask, const u8 *mac,
 		u8 aging)
 {
@@ -208,7 +208,7 @@ qca8k_fdb_write(struct qca8k_priv *priv, u16 vid, u8 port_mask, const u8 *mac,
 	qca8k_bulk_write(priv, QCA8K_REG_ATU_DATA0, reg, sizeof(reg));
 }
 
-int
+static int
 qca8k_fdb_access(struct qca8k_priv *priv, enum qca8k_fdb_cmd cmd, int port)
 {
 	u32 reg;
@@ -244,7 +244,7 @@ qca8k_fdb_access(struct qca8k_priv *priv, enum qca8k_fdb_cmd cmd, int port)
 	return 0;
 }
 
-int
+static int
 qca8k_fdb_next(struct qca8k_priv *priv, struct qca8k_fdb *fdb, int port)
 {
 	int ret;
@@ -257,7 +257,7 @@ qca8k_fdb_next(struct qca8k_priv *priv, struct qca8k_fdb *fdb, int port)
 	return qca8k_fdb_read(priv, fdb);
 }
 
-int
+static int
 qca8k_fdb_add(struct qca8k_priv *priv, const u8 *mac, u16 port_mask,
 	      u16 vid, u8 aging)
 {
@@ -271,7 +271,7 @@ qca8k_fdb_add(struct qca8k_priv *priv, const u8 *mac, u16 port_mask,
 	return ret;
 }
 
-int
+static int
 qca8k_fdb_del(struct qca8k_priv *priv, const u8 *mac, u16 port_mask, u16 vid)
 {
 	int ret;
@@ -292,7 +292,7 @@ qca8k_fdb_flush(struct qca8k_priv *priv)
 	mutex_unlock(&priv->reg_mutex);
 }
 
-int
+static int
 qca8k_fdb_search_and_insert(struct qca8k_priv *priv, u8 port_mask,
 			    const u8 *mac, u16 vid)
 {
@@ -328,7 +328,7 @@ qca8k_fdb_search_and_insert(struct qca8k_priv *priv, u8 port_mask,
 	return ret;
 }
 
-int
+static int
 qca8k_fdb_search_and_del(struct qca8k_priv *priv, u8 port_mask,
 			 const u8 *mac, u16 vid)
 {
@@ -400,7 +400,7 @@ qca8k_vlan_access(struct qca8k_priv *priv, enum qca8k_vlan_cmd cmd, u16 vid)
 	return 0;
 }
 
-int
+static int
 qca8k_vlan_add(struct qca8k_priv *priv, u8 port, u16 vid, bool untagged)
 {
 	u32 reg;
@@ -438,7 +438,7 @@ qca8k_vlan_add(struct qca8k_priv *priv, u8 port, u16 vid, bool untagged)
 	return ret;
 }
 
-int
+static int
 qca8k_vlan_del(struct qca8k_priv *priv, u8 port, u16 vid)
 {
 	u32 reg, mask;
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index b74b9012462b..12d0b5b2fd5d 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -434,22 +434,8 @@ int qca8k_read(struct qca8k_priv *priv, u32 reg, u32 *val);
 int qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val);
 int qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val);
 
-int qca8k_bulk_read(struct qca8k_priv *priv, u32 reg, u32 *val, int len);
-int qca8k_bulk_write(struct qca8k_priv *priv, u32 reg, u32 *val, int len);
-
 /* Common ops function */
-int qca8k_fdb_access(struct qca8k_priv *priv, enum qca8k_fdb_cmd cmd, int port);
-int qca8k_fdb_next(struct qca8k_priv *priv, struct qca8k_fdb *fdb, int port);
-int qca8k_fdb_add(struct qca8k_priv *priv, const u8 *mac, u16 port_mask,
-		  u16 vid, u8 aging);
-int qca8k_fdb_del(struct qca8k_priv *priv, const u8 *mac, u16 port_mask, u16 vid);
 void qca8k_fdb_flush(struct qca8k_priv *priv);
-int qca8k_fdb_search_and_insert(struct qca8k_priv *priv, u8 port_mask,
-				const u8 *mac, u16 vid);
-int qca8k_fdb_search_and_del(struct qca8k_priv *priv, u8 port_mask,
-			     const u8 *mac, u16 vid);
-int qca8k_vlan_add(struct qca8k_priv *priv, u8 port, u16 vid, bool untagged);
-int qca8k_vlan_del(struct qca8k_priv *priv, u8 port, u16 vid);
 
 /* Common ethtool stats function */
 void qca8k_get_strings(struct dsa_switch *ds, int port, u32 stringset, uint8_t *data);
-- 
2.36.1

