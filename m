Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 981A657F789
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 00:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233557AbiGXWwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 18:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232964AbiGXWv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 18:51:57 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A63DECD;
        Sun, 24 Jul 2022 15:51:18 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id c72so9015341edf.8;
        Sun, 24 Jul 2022 15:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=uBc6l9wUgDDf22Xx6q8PZWf/Hd4h/iBtQuuiFTeFacU=;
        b=Yh1KeAafVdc6nIVRiEug35mh+i5JdJDTXcugcvinYcBEMnW3f/XE4+cb7qHfQoujIk
         204nZyTlgCHHkhdjOHj8ZtdC73xKmX4/3qv9VKu17Xcg1BG9PFK7Cmt+yq6o5yQTXamp
         wiAWwmyrpJhGnE32cN1drsZjhhFwqrQboBiX48L7iE5lXV/Ldl4mSGEGfe1opR9PzUAK
         bDIQOP0HnVigJVsSnJw4Plf+N/BMOBDrfiXMKh6lUWtR04jEzMWjiM9iX95cKEL3wLXv
         QDKkrUBR7FXf8XgmZuELKx+pqM3TauXuR3uPCZZjeSiyukjYW6sYyRvrqSKR8kLwBc3S
         jkNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uBc6l9wUgDDf22Xx6q8PZWf/Hd4h/iBtQuuiFTeFacU=;
        b=8Icf9iu/zTPTBpw00ixQveRupnBkyHgp+roWd+UrbuZxtEgHlHqi78Na4jgIZ/ZZzP
         f2Be2BSGp7AESd3KBBv8uAIDxhsIqyzPbna7w260xot4VqhiQnToK9iYLV62Bh9pCDFU
         YfMVPj3/8IyROY5bPe/HDXG+uZh3yR0Rb4uCuUAOhSBctLM42jkBLawvHrb7tZVrkjvl
         6/3SfJFVrFp9aoX3JheiT9Ly/AoMtM8qObiRVOgGce4GoAgPe/w1VIO3jZ7dWxTm0d3f
         2fxtJGLuFx9CBjqWbMeFlX3GVeahfo4P95r9Zcz8aseuj7EB26qbia3zPaSurLQd67CP
         9ZaQ==
X-Gm-Message-State: AJIora/ld9UujvyxYqSBYuw/T11QjG4mhdNG/tpkw4ub02sIQeRi+Gg1
        hPiWH5ipjv8qqxTn7kTvUIE=
X-Google-Smtp-Source: AGRyM1tfW1AUNrUwm37RGqPWrxA5Ardil84hYphJV8ocVCRo1x2i8gGkMCpsJM+VaNNP1DK3NWYBTQ==
X-Received: by 2002:a05:6402:5418:b0:435:5a48:daa9 with SMTP id ev24-20020a056402541800b004355a48daa9mr10491730edb.304.1658703076216;
        Sun, 24 Jul 2022 15:51:16 -0700 (PDT)
Received: from localhost.localdomain (93-42-69-122.ip85.fastwebnet.it. [93.42.69.122])
        by smtp.googlemail.com with ESMTPSA id nc19-20020a1709071c1300b00722d5b26ecesm4645238ejc.205.2022.07.24.15.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jul 2022 15:51:15 -0700 (PDT)
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
Subject: [net-next PATCH v4 10/14] net: dsa: qca8k: move port FDB/MDB function to common code
Date:   Sun, 24 Jul 2022 22:19:34 +0200
Message-Id: <20220724201938.17387-11-ansuelsmth@gmail.com>
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
index 75efba7a4fa0..a322444e3ddf 100644
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
index 7e573827dac6..1b13bf1b5de7 100644
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
index e7d4df253b8c..9da7928de83c 100644
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

