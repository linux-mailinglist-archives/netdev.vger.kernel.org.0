Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFFCE57EF82
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 16:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237972AbiGWOVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 10:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237780AbiGWOUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 10:20:30 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC891CFF0;
        Sat, 23 Jul 2022 07:19:56 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id v13so2220558wru.12;
        Sat, 23 Jul 2022 07:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Cow7GhxluUMFja6EVfNFOFOb4NyVQmATN3ZYMO/KkKo=;
        b=kKs17j7XpPPLtgQTwiCRaFRRP/p7jJTij3Ks+V1fdwAIVojawmGNM72dRnYNGIcxK7
         7Z/hulMe7qjokGUZGAcWyDrwgJTbptdqtBrf6X/rl85ioUlpn1+o6Mih+XBIsiPUsHN1
         Bj5l9CM+g/lUpgdbDlJGUweUdUP6rZkbRIGhQLqV+CvJad4bSElCTwV+vVjTorGJ2s5P
         Se0zBKdXq7yPvIHviEyzJhX0KcpJN7jTgxxZraal1BSQny7a6z7KwbMXKrRpQjbt/R69
         LWyH4KPkBOxNqtD/MypFxkcwP7qPjAmpEjJ2s6L30s9zdh4uJIJcNH7jjH4iaEea9zCI
         zyXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cow7GhxluUMFja6EVfNFOFOb4NyVQmATN3ZYMO/KkKo=;
        b=Flru3UhGATKA5HHOm50Yu3bBk8KX5GcEtIQ6mstrN1QtDWWTrWWFrCe0NpgKezGpVL
         I4eZZj+FBox45TO9uHtjBZl9zzfweY2lFc1/wr7yGx2b40fzpp1/VdgqETxGkg75SvXz
         On7vtYYFatBAPjqn3oScrsqIBJRoAa2msHAbY2f9veACppOldJYnthNs4DmPJhcQWJTw
         +EVfvzMDDk9uIcjeqwxdh3/pHB80jlx1KZtGN2YxJ0oPElSfxinTLdeD7yW13nFuxUym
         1eN8+C2957iLtYqCmPDTrrTpcps7TaM4OGaMS62hxZVN/0T4i3VYiT46vPKD1mpWzDMa
         ptOg==
X-Gm-Message-State: AJIora86SZkUMGAs4e7hsIGBm84XDl1dm38EWesOXgKmT8x/V1EbF2Mr
        IE2gJ9no5hTUiGnmkuIabTA=
X-Google-Smtp-Source: AGRyM1vYbJu/mFNyP+dbNLQBONYJi5rWExlcOuLy9hYHMNjlSgjYd0FK0LkNbxNd1TZXigNaWvVtXw==
X-Received: by 2002:a05:6000:250:b0:21d:b3b5:3438 with SMTP id m16-20020a056000025000b0021db3b53438mr2724767wrz.203.1658585995256;
        Sat, 23 Jul 2022 07:19:55 -0700 (PDT)
Received: from localhost.localdomain (host-87-7-207-127.retail.telecomitalia.it. [87.7.207.127])
        by smtp.googlemail.com with ESMTPSA id l18-20020a05600c1d1200b003a04d19dab3sm21011960wms.3.2022.07.23.07.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jul 2022 07:19:54 -0700 (PDT)
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
Subject: [net-next PATCH v3 10/14] net: dsa: qca8k: move port FDB/MDB function to common code
Date:   Sat, 23 Jul 2022 16:18:41 +0200
Message-Id: <20220723141845.10570-11-ansuelsmth@gmail.com>
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

The same port FDB/MDB function are used by drivers based on qca8k family
switch. Move them to common code to make them accessible also by other
drivers.
Also drop bulk read/write functions and make them static

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c   | 306 ----------------------------
 drivers/net/dsa/qca/qca8k-common.c | 309 ++++++++++++++++++++++++++++-
 drivers/net/dsa/qca/qca8k.h        |  25 ++-
 3 files changed, 329 insertions(+), 311 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 41f9198d1f25..52a9e0a2a532 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -441,217 +441,6 @@ static struct regmap_config qca8k_regmap_config = {
 	.cache_type = REGCACHE_NONE, /* Explicitly disable CACHE */
 };
 
-static int
-qca8k_fdb_read(struct qca8k_priv *priv, struct qca8k_fdb *fdb)
-{
-	u32 reg[3];
-	int ret;
-
-	/* load the ARL table into an array */
-	ret = qca8k_bulk_read(priv, QCA8K_REG_ATU_DATA0, reg, sizeof(reg));
-	if (ret)
-		return ret;
-
-	/* vid - 83:72 */
-	fdb->vid = FIELD_GET(QCA8K_ATU_VID_MASK, reg[2]);
-	/* aging - 67:64 */
-	fdb->aging = FIELD_GET(QCA8K_ATU_STATUS_MASK, reg[2]);
-	/* portmask - 54:48 */
-	fdb->port_mask = FIELD_GET(QCA8K_ATU_PORT_MASK, reg[1]);
-	/* mac - 47:0 */
-	fdb->mac[0] = FIELD_GET(QCA8K_ATU_ADDR0_MASK, reg[1]);
-	fdb->mac[1] = FIELD_GET(QCA8K_ATU_ADDR1_MASK, reg[1]);
-	fdb->mac[2] = FIELD_GET(QCA8K_ATU_ADDR2_MASK, reg[0]);
-	fdb->mac[3] = FIELD_GET(QCA8K_ATU_ADDR3_MASK, reg[0]);
-	fdb->mac[4] = FIELD_GET(QCA8K_ATU_ADDR4_MASK, reg[0]);
-	fdb->mac[5] = FIELD_GET(QCA8K_ATU_ADDR5_MASK, reg[0]);
-
-	return 0;
-}
-
-static void
-qca8k_fdb_write(struct qca8k_priv *priv, u16 vid, u8 port_mask, const u8 *mac,
-		u8 aging)
-{
-	u32 reg[3] = { 0 };
-
-	/* vid - 83:72 */
-	reg[2] = FIELD_PREP(QCA8K_ATU_VID_MASK, vid);
-	/* aging - 67:64 */
-	reg[2] |= FIELD_PREP(QCA8K_ATU_STATUS_MASK, aging);
-	/* portmask - 54:48 */
-	reg[1] = FIELD_PREP(QCA8K_ATU_PORT_MASK, port_mask);
-	/* mac - 47:0 */
-	reg[1] |= FIELD_PREP(QCA8K_ATU_ADDR0_MASK, mac[0]);
-	reg[1] |= FIELD_PREP(QCA8K_ATU_ADDR1_MASK, mac[1]);
-	reg[0] |= FIELD_PREP(QCA8K_ATU_ADDR2_MASK, mac[2]);
-	reg[0] |= FIELD_PREP(QCA8K_ATU_ADDR3_MASK, mac[3]);
-	reg[0] |= FIELD_PREP(QCA8K_ATU_ADDR4_MASK, mac[4]);
-	reg[0] |= FIELD_PREP(QCA8K_ATU_ADDR5_MASK, mac[5]);
-
-	/* load the array into the ARL table */
-	qca8k_bulk_write(priv, QCA8K_REG_ATU_DATA0, reg, sizeof(reg));
-}
-
-static int
-qca8k_fdb_access(struct qca8k_priv *priv, enum qca8k_fdb_cmd cmd, int port)
-{
-	u32 reg;
-	int ret;
-
-	/* Set the command and FDB index */
-	reg = QCA8K_ATU_FUNC_BUSY;
-	reg |= cmd;
-	if (port >= 0) {
-		reg |= QCA8K_ATU_FUNC_PORT_EN;
-		reg |= FIELD_PREP(QCA8K_ATU_FUNC_PORT_MASK, port);
-	}
-
-	/* Write the function register triggering the table access */
-	ret = qca8k_write(priv, QCA8K_REG_ATU_FUNC, reg);
-	if (ret)
-		return ret;
-
-	/* wait for completion */
-	ret = qca8k_busy_wait(priv, QCA8K_REG_ATU_FUNC, QCA8K_ATU_FUNC_BUSY);
-	if (ret)
-		return ret;
-
-	/* Check for table full violation when adding an entry */
-	if (cmd == QCA8K_FDB_LOAD) {
-		ret = qca8k_read(priv, QCA8K_REG_ATU_FUNC, &reg);
-		if (ret < 0)
-			return ret;
-		if (reg & QCA8K_ATU_FUNC_FULL)
-			return -1;
-	}
-
-	return 0;
-}
-
-static int
-qca8k_fdb_next(struct qca8k_priv *priv, struct qca8k_fdb *fdb, int port)
-{
-	int ret;
-
-	qca8k_fdb_write(priv, fdb->vid, fdb->port_mask, fdb->mac, fdb->aging);
-	ret = qca8k_fdb_access(priv, QCA8K_FDB_NEXT, port);
-	if (ret < 0)
-		return ret;
-
-	return qca8k_fdb_read(priv, fdb);
-}
-
-static int
-qca8k_fdb_add(struct qca8k_priv *priv, const u8 *mac, u16 port_mask,
-	      u16 vid, u8 aging)
-{
-	int ret;
-
-	mutex_lock(&priv->reg_mutex);
-	qca8k_fdb_write(priv, vid, port_mask, mac, aging);
-	ret = qca8k_fdb_access(priv, QCA8K_FDB_LOAD, -1);
-	mutex_unlock(&priv->reg_mutex);
-
-	return ret;
-}
-
-static int
-qca8k_fdb_del(struct qca8k_priv *priv, const u8 *mac, u16 port_mask, u16 vid)
-{
-	int ret;
-
-	mutex_lock(&priv->reg_mutex);
-	qca8k_fdb_write(priv, vid, port_mask, mac, 0);
-	ret = qca8k_fdb_access(priv, QCA8K_FDB_PURGE, -1);
-	mutex_unlock(&priv->reg_mutex);
-
-	return ret;
-}
-
-static void
-qca8k_fdb_flush(struct qca8k_priv *priv)
-{
-	mutex_lock(&priv->reg_mutex);
-	qca8k_fdb_access(priv, QCA8K_FDB_FLUSH, -1);
-	mutex_unlock(&priv->reg_mutex);
-}
-
-static int
-qca8k_fdb_search_and_insert(struct qca8k_priv *priv, u8 port_mask,
-			    const u8 *mac, u16 vid)
-{
-	struct qca8k_fdb fdb = { 0 };
-	int ret;
-
-	mutex_lock(&priv->reg_mutex);
-
-	qca8k_fdb_write(priv, vid, 0, mac, 0);
-	ret = qca8k_fdb_access(priv, QCA8K_FDB_SEARCH, -1);
-	if (ret < 0)
-		goto exit;
-
-	ret = qca8k_fdb_read(priv, &fdb);
-	if (ret < 0)
-		goto exit;
-
-	/* Rule exist. Delete first */
-	if (!fdb.aging) {
-		ret = qca8k_fdb_access(priv, QCA8K_FDB_PURGE, -1);
-		if (ret)
-			goto exit;
-	}
-
-	/* Add port to fdb portmask */
-	fdb.port_mask |= port_mask;
-
-	qca8k_fdb_write(priv, vid, fdb.port_mask, mac, fdb.aging);
-	ret = qca8k_fdb_access(priv, QCA8K_FDB_LOAD, -1);
-
-exit:
-	mutex_unlock(&priv->reg_mutex);
-	return ret;
-}
-
-static int
-qca8k_fdb_search_and_del(struct qca8k_priv *priv, u8 port_mask,
-			 const u8 *mac, u16 vid)
-{
-	struct qca8k_fdb fdb = { 0 };
-	int ret;
-
-	mutex_lock(&priv->reg_mutex);
-
-	qca8k_fdb_write(priv, vid, 0, mac, 0);
-	ret = qca8k_fdb_access(priv, QCA8K_FDB_SEARCH, -1);
-	if (ret < 0)
-		goto exit;
-
-	/* Rule doesn't exist. Why delete? */
-	if (!fdb.aging) {
-		ret = -EINVAL;
-		goto exit;
-	}
-
-	ret = qca8k_fdb_access(priv, QCA8K_FDB_PURGE, -1);
-	if (ret)
-		goto exit;
-
-	/* Only port in the rule is this port. Don't re insert */
-	if (fdb.port_mask == port_mask)
-		goto exit;
-
-	/* Remove port from port mask */
-	fdb.port_mask &= ~port_mask;
-
-	qca8k_fdb_write(priv, vid, fdb.port_mask, mac, fdb.aging);
-	ret = qca8k_fdb_access(priv, QCA8K_FDB_LOAD, -1);
-
-exit:
-	mutex_unlock(&priv->reg_mutex);
-	return ret;
-}
-
 static int
 qca8k_vlan_access(struct qca8k_priv *priv, enum qca8k_vlan_cmd cmd, u16 vid)
 {
@@ -1898,101 +1687,6 @@ qca8k_get_ethtool_stats_eth(struct dsa_switch *ds, int port, u64 *data)
 	return ret;
 }
 
-static void
-qca8k_port_fast_age(struct dsa_switch *ds, int port)
-{
-	struct qca8k_priv *priv = ds->priv;
-
-	mutex_lock(&priv->reg_mutex);
-	qca8k_fdb_access(priv, QCA8K_FDB_FLUSH_PORT, port);
-	mutex_unlock(&priv->reg_mutex);
-}
-
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
index 1f9249c7657b..557f73db7530 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -102,7 +102,7 @@ const struct regmap_access_table qca8k_readable_table = {
 };
 
 /* TODO: remove these extra ops when we can support regmap bulk read/write */
-int qca8k_bulk_read(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
+static int qca8k_bulk_read(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 {
 	int i, count = len / sizeof(u32), ret;
 
@@ -120,7 +120,7 @@ int qca8k_bulk_read(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 }
 
 /* TODO: remove these extra ops when we can support regmap bulk read/write */
-int qca8k_bulk_write(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
+static int qca8k_bulk_write(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 {
 	int i, count = len / sizeof(u32), ret;
 	u32 tmp;
@@ -149,6 +149,216 @@ qca8k_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
 				       QCA8K_BUSY_WAIT_TIMEOUT * USEC_PER_MSEC);
 }
 
+static int
+qca8k_fdb_read(struct qca8k_priv *priv, struct qca8k_fdb *fdb)
+{
+	u32 reg[3];
+	int ret;
+
+	/* load the ARL table into an array */
+	ret = qca8k_bulk_read(priv, QCA8K_REG_ATU_DATA0, reg, sizeof(reg));
+	if (ret)
+		return ret;
+
+	/* vid - 83:72 */
+	fdb->vid = FIELD_GET(QCA8K_ATU_VID_MASK, reg[2]);
+	/* aging - 67:64 */
+	fdb->aging = FIELD_GET(QCA8K_ATU_STATUS_MASK, reg[2]);
+	/* portmask - 54:48 */
+	fdb->port_mask = FIELD_GET(QCA8K_ATU_PORT_MASK, reg[1]);
+	/* mac - 47:0 */
+	fdb->mac[0] = FIELD_GET(QCA8K_ATU_ADDR0_MASK, reg[1]);
+	fdb->mac[1] = FIELD_GET(QCA8K_ATU_ADDR1_MASK, reg[1]);
+	fdb->mac[2] = FIELD_GET(QCA8K_ATU_ADDR2_MASK, reg[0]);
+	fdb->mac[3] = FIELD_GET(QCA8K_ATU_ADDR3_MASK, reg[0]);
+	fdb->mac[4] = FIELD_GET(QCA8K_ATU_ADDR4_MASK, reg[0]);
+	fdb->mac[5] = FIELD_GET(QCA8K_ATU_ADDR5_MASK, reg[0]);
+
+	return 0;
+}
+
+static void
+qca8k_fdb_write(struct qca8k_priv *priv, u16 vid, u8 port_mask, const u8 *mac,
+		u8 aging)
+{
+	u32 reg[3] = { 0 };
+
+	/* vid - 83:72 */
+	reg[2] = FIELD_PREP(QCA8K_ATU_VID_MASK, vid);
+	/* aging - 67:64 */
+	reg[2] |= FIELD_PREP(QCA8K_ATU_STATUS_MASK, aging);
+	/* portmask - 54:48 */
+	reg[1] = FIELD_PREP(QCA8K_ATU_PORT_MASK, port_mask);
+	/* mac - 47:0 */
+	reg[1] |= FIELD_PREP(QCA8K_ATU_ADDR0_MASK, mac[0]);
+	reg[1] |= FIELD_PREP(QCA8K_ATU_ADDR1_MASK, mac[1]);
+	reg[0] |= FIELD_PREP(QCA8K_ATU_ADDR2_MASK, mac[2]);
+	reg[0] |= FIELD_PREP(QCA8K_ATU_ADDR3_MASK, mac[3]);
+	reg[0] |= FIELD_PREP(QCA8K_ATU_ADDR4_MASK, mac[4]);
+	reg[0] |= FIELD_PREP(QCA8K_ATU_ADDR5_MASK, mac[5]);
+
+	/* load the array into the ARL table */
+	qca8k_bulk_write(priv, QCA8K_REG_ATU_DATA0, reg, sizeof(reg));
+}
+
+static int
+qca8k_fdb_access(struct qca8k_priv *priv, enum qca8k_fdb_cmd cmd, int port)
+{
+	u32 reg;
+	int ret;
+
+	/* Set the command and FDB index */
+	reg = QCA8K_ATU_FUNC_BUSY;
+	reg |= cmd;
+	if (port >= 0) {
+		reg |= QCA8K_ATU_FUNC_PORT_EN;
+		reg |= FIELD_PREP(QCA8K_ATU_FUNC_PORT_MASK, port);
+	}
+
+	/* Write the function register triggering the table access */
+	ret = qca8k_write(priv, QCA8K_REG_ATU_FUNC, reg);
+	if (ret)
+		return ret;
+
+	/* wait for completion */
+	ret = qca8k_busy_wait(priv, QCA8K_REG_ATU_FUNC, QCA8K_ATU_FUNC_BUSY);
+	if (ret)
+		return ret;
+
+	/* Check for table full violation when adding an entry */
+	if (cmd == QCA8K_FDB_LOAD) {
+		ret = qca8k_read(priv, QCA8K_REG_ATU_FUNC, &reg);
+		if (ret < 0)
+			return ret;
+		if (reg & QCA8K_ATU_FUNC_FULL)
+			return -1;
+	}
+
+	return 0;
+}
+
+static int
+qca8k_fdb_next(struct qca8k_priv *priv, struct qca8k_fdb *fdb, int port)
+{
+	int ret;
+
+	qca8k_fdb_write(priv, fdb->vid, fdb->port_mask, fdb->mac, fdb->aging);
+	ret = qca8k_fdb_access(priv, QCA8K_FDB_NEXT, port);
+	if (ret < 0)
+		return ret;
+
+	return qca8k_fdb_read(priv, fdb);
+}
+
+static int
+qca8k_fdb_add(struct qca8k_priv *priv, const u8 *mac, u16 port_mask,
+	      u16 vid, u8 aging)
+{
+	int ret;
+
+	mutex_lock(&priv->reg_mutex);
+	qca8k_fdb_write(priv, vid, port_mask, mac, aging);
+	ret = qca8k_fdb_access(priv, QCA8K_FDB_LOAD, -1);
+	mutex_unlock(&priv->reg_mutex);
+
+	return ret;
+}
+
+static int
+qca8k_fdb_del(struct qca8k_priv *priv, const u8 *mac, u16 port_mask, u16 vid)
+{
+	int ret;
+
+	mutex_lock(&priv->reg_mutex);
+	qca8k_fdb_write(priv, vid, port_mask, mac, 0);
+	ret = qca8k_fdb_access(priv, QCA8K_FDB_PURGE, -1);
+	mutex_unlock(&priv->reg_mutex);
+
+	return ret;
+}
+
+void qca8k_fdb_flush(struct qca8k_priv *priv)
+{
+	mutex_lock(&priv->reg_mutex);
+	qca8k_fdb_access(priv, QCA8K_FDB_FLUSH, -1);
+	mutex_unlock(&priv->reg_mutex);
+}
+
+static int
+qca8k_fdb_search_and_insert(struct qca8k_priv *priv, u8 port_mask,
+			    const u8 *mac, u16 vid)
+{
+	struct qca8k_fdb fdb = { 0 };
+	int ret;
+
+	mutex_lock(&priv->reg_mutex);
+
+	qca8k_fdb_write(priv, vid, 0, mac, 0);
+	ret = qca8k_fdb_access(priv, QCA8K_FDB_SEARCH, -1);
+	if (ret < 0)
+		goto exit;
+
+	ret = qca8k_fdb_read(priv, &fdb);
+	if (ret < 0)
+		goto exit;
+
+	/* Rule exist. Delete first */
+	if (!fdb.aging) {
+		ret = qca8k_fdb_access(priv, QCA8K_FDB_PURGE, -1);
+		if (ret)
+			goto exit;
+	}
+
+	/* Add port to fdb portmask */
+	fdb.port_mask |= port_mask;
+
+	qca8k_fdb_write(priv, vid, fdb.port_mask, mac, fdb.aging);
+	ret = qca8k_fdb_access(priv, QCA8K_FDB_LOAD, -1);
+
+exit:
+	mutex_unlock(&priv->reg_mutex);
+	return ret;
+}
+
+static int
+qca8k_fdb_search_and_del(struct qca8k_priv *priv, u8 port_mask,
+			 const u8 *mac, u16 vid)
+{
+	struct qca8k_fdb fdb = { 0 };
+	int ret;
+
+	mutex_lock(&priv->reg_mutex);
+
+	qca8k_fdb_write(priv, vid, 0, mac, 0);
+	ret = qca8k_fdb_access(priv, QCA8K_FDB_SEARCH, -1);
+	if (ret < 0)
+		goto exit;
+
+	/* Rule doesn't exist. Why delete? */
+	if (!fdb.aging) {
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	ret = qca8k_fdb_access(priv, QCA8K_FDB_PURGE, -1);
+	if (ret)
+		goto exit;
+
+	/* Only port in the rule is this port. Don't re insert */
+	if (fdb.port_mask == port_mask)
+		goto exit;
+
+	/* Remove port from port mask */
+	fdb.port_mask &= ~port_mask;
+
+	qca8k_fdb_write(priv, vid, fdb.port_mask, mac, fdb.aging);
+	ret = qca8k_fdb_access(priv, QCA8K_FDB_LOAD, -1);
+
+exit:
+	mutex_unlock(&priv->reg_mutex);
+	return ret;
+}
+
 int qca8k_mib_init(struct qca8k_priv *priv)
 {
 	int ret;
@@ -374,6 +584,16 @@ void qca8k_port_bridge_leave(struct dsa_switch *ds, int port,
 		  QCA8K_PORT_LOOKUP_MEMBER, BIT(cpu_port));
 }
 
+void
+qca8k_port_fast_age(struct dsa_switch *ds, int port)
+{
+	struct qca8k_priv *priv = ds->priv;
+
+	mutex_lock(&priv->reg_mutex);
+	qca8k_fdb_access(priv, QCA8K_FDB_FLUSH_PORT, port);
+	mutex_unlock(&priv->reg_mutex);
+}
+
 int
 qca8k_set_ageing_time(struct dsa_switch *ds, unsigned int msecs)
 {
@@ -461,3 +681,88 @@ qca8k_port_max_mtu(struct dsa_switch *ds, int port)
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
index 40592b1c69a2..f336aa929afc 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -438,11 +438,9 @@ int qca8k_read(struct qca8k_priv *priv, u32 reg, u32 *val);
 int qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val);
 int qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val);
 
-int qca8k_bulk_read(struct qca8k_priv *priv, u32 reg, u32 *val, int len);
-int qca8k_bulk_write(struct qca8k_priv *priv, u32 reg, u32 *val, int len);
-
 /* Common ops function */
 int qca8k_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask);
+void qca8k_fdb_flush(struct qca8k_priv *priv);
 
 /* Common ethtool stats function */
 void qca8k_get_strings(struct dsa_switch *ds, int port, u32 stringset, uint8_t *data);
@@ -473,6 +471,27 @@ int qca8k_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu);
 int qca8k_port_max_mtu(struct dsa_switch *ds, int port);
 
 /* Common fast age function */
+void qca8k_port_fast_age(struct dsa_switch *ds, int port);
 int qca8k_set_ageing_time(struct dsa_switch *ds, unsigned int msecs);
 
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

