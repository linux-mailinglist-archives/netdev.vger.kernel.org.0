Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 643FC58B7E9
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 21:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232705AbiHFTXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Aug 2022 15:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbiHFTXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Aug 2022 15:23:33 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A10E10565;
        Sat,  6 Aug 2022 12:23:32 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id j8so10155726ejx.9;
        Sat, 06 Aug 2022 12:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c8BwCS7yBbAXA7KpZicmRh9of5x1+sSmYJv9NZIsyIY=;
        b=Z3y0IIh8TPF6HZxipO0Ex36brRKn2RajYPRqPe/G8owfgZ7oqgmSxeQzGvBFkK5qNS
         2M1W6eVvlQ0J253YXpqxt0N6RWotimSpR4c2VNtRkX0wn64uqJU377bN3Q5Okrf0YqJO
         AcVP56taCqbI42Uusq0ksRwo7xcPwbPXQnRwZqNwdo5XeKQoiR6c3yWc804p+AsuwSxT
         NhCjtRrj6XP3wlJDnHrnDELpKs21ITBsaHCWLcnCfLYV9L/KUNc1OFwUrggcONG9KjFo
         V2QyjglBuf2dQt1j+577oWXxyhZU3pIuJGmODGCXGCfPZHzNaY4oPXLC6r4HVtzcoQm2
         PD0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c8BwCS7yBbAXA7KpZicmRh9of5x1+sSmYJv9NZIsyIY=;
        b=ueCl9Cg7khTsFLTqCMw6taeqyTGvLk21mi7AFGObZRQuqCP6a0JOY+ejCYNOqBMNlu
         aZX1yQEZ6HIPnZnn2+4g40bozb259J7XjByoQTwa5sxq1vGSnVRb/dsyIWYYznQvwK4I
         wN6NQ7lpF+i/0rc3tUTSjBxvA8fWxneegKJhBGHOlkhrtBmgFrZ4diuP/YhgefgbV2gJ
         8sjkVTdOdosndBbvzoWElElfbd/MF/9BOrvXkmIO8haCIpSg/rZyO1WvqTCFhh1Q+0FM
         Qr8k0NUbsYTgngzVGHU1f/YSOXa6Nw6bQqXWpEJ6pQWDG8xIDA4b5hQYx6Cc/BvCHSzt
         7xOg==
X-Gm-Message-State: ACgBeo3JR346j5msI7jNRyFGD9ZKSeLcWJm09UP4h019e/PmDJXVkxj3
        YWQW79MKatlzYqOv21DT+R4=
X-Google-Smtp-Source: AA6agR7NQ73JidXMzA1ENWyFyBowqKXgf3sbAhabJVyb4wTExTJLetzneHzAO57HES1k+smL3O0qtQ==
X-Received: by 2002:a17:907:2cf6:b0:730:6068:2ebb with SMTP id hz22-20020a1709072cf600b0073060682ebbmr9206377ejc.82.1659813810460;
        Sat, 06 Aug 2022 12:23:30 -0700 (PDT)
Received: from localhost.localdomain (host-87-20-249-30.retail.telecomitalia.it. [87.20.249.30])
        by smtp.googlemail.com with ESMTPSA id a4-20020a1709065f8400b0073085243f3fsm2969925eju.64.2022.08.06.12.23.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Aug 2022 12:23:29 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next] net: dsa: qca8k: convert to regmap read/write API
Date:   Sat,  6 Aug 2022 21:22:53 +0200
Message-Id: <20220806192253.7567-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert qca8k to regmap read/write bulk API. The mgmt eth can write up
to 16 bytes of data at times. Currently we use a custom function to do
it but regmap now supports declaration of read/write bulk even without a
bus.

Drop the custom function and rework the regmap function to this new
implementation.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c   | 94 +++++++++++++++++++++++-------
 drivers/net/dsa/qca/qca8k-common.c | 49 ++--------------
 drivers/net/dsa/qca/qca8k.h        |  5 +-
 3 files changed, 82 insertions(+), 66 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 1d3e7782a71f..c9ddc4848f58 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -342,16 +342,12 @@ qca8k_regmap_update_bits_eth(struct qca8k_priv *priv, u32 reg, u32 mask, u32 wri
 }
 
 static int
-qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
+qca8k_read_mii(struct qca8k_priv *priv, uint32_t reg, uint32_t *val)
 {
-	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
 	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
 	int ret;
 
-	if (!qca8k_read_eth(priv, reg, val, sizeof(*val)))
-		return 0;
-
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
@@ -368,16 +364,12 @@ qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
 }
 
 static int
-qca8k_regmap_write(void *ctx, uint32_t reg, uint32_t val)
+qca8k_write_mii(struct qca8k_priv *priv, uint32_t reg, uint32_t val)
 {
-	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
 	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
 	int ret;
 
-	if (!qca8k_write_eth(priv, reg, &val, sizeof(val)))
-		return 0;
-
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
@@ -394,17 +386,14 @@ qca8k_regmap_write(void *ctx, uint32_t reg, uint32_t val)
 }
 
 static int
-qca8k_regmap_update_bits(void *ctx, uint32_t reg, uint32_t mask, uint32_t write_val)
+qca8k_regmap_update_bits_mii(struct qca8k_priv *priv, uint32_t reg,
+			     uint32_t mask, uint32_t write_val)
 {
-	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
 	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
 	u32 val;
 	int ret;
 
-	if (!qca8k_regmap_update_bits_eth(priv, reg, mask, write_val))
-		return 0;
-
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
@@ -427,17 +416,84 @@ qca8k_regmap_update_bits(void *ctx, uint32_t reg, uint32_t mask, uint32_t write_
 	return ret;
 }
 
+static int
+qca8k_bulk_read(void *ctx, const void *reg_buf, size_t reg_len,
+		void *val_buf, size_t val_len)
+{
+	int i, count = val_len / sizeof(u32), ret;
+	struct qca8k_priv *priv = ctx;
+	u32 reg = *(u32 *)reg_buf;
+
+	if (priv->mgmt_master &&
+	    !qca8k_read_eth(priv, reg, val_buf, val_len))
+		return 0;
+
+	/* loop count times and increment reg of 4 */
+	for (i = 0; i < count; i++, reg += sizeof(u32)) {
+		ret = qca8k_read_mii(priv, reg, val_buf + i);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int
+qca8k_bulk_gather_write(void *ctx, const void *reg_buf, size_t reg_len,
+			const void *val_buf, size_t val_len)
+{
+	int i, count = val_len / sizeof(u32), ret;
+	struct qca8k_priv *priv = ctx;
+	u32 *val = (u32 *)val_buf;
+	u32 reg = *(u32 *)reg_buf;
+
+	if (priv->mgmt_master &&
+	    !qca8k_write_eth(priv, reg, val, val_len))
+		return 0;
+
+	/* loop count times, increment reg of 4 and increment val ptr to
+	 * the next value
+	 */
+	for (i = 0; i < count; i++, reg += sizeof(u32), val++) {
+		ret = qca8k_write_mii(priv, reg, *val);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int
+qca8k_bulk_write(void *ctx, const void *data, size_t bytes)
+{
+	return qca8k_bulk_gather_write(ctx, data, sizeof(u32), data + sizeof(u32),
+				       bytes - sizeof(u32));
+}
+
+static int
+qca8k_regmap_update_bits(void *ctx, uint32_t reg, uint32_t mask, uint32_t write_val)
+{
+	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
+
+	if (!qca8k_regmap_update_bits_eth(priv, reg, mask, write_val))
+		return 0;
+
+	return qca8k_regmap_update_bits_mii(priv, reg, mask, write_val);
+}
+
 static struct regmap_config qca8k_regmap_config = {
-	.reg_bits = 16,
+	.reg_bits = 32,
 	.val_bits = 32,
 	.reg_stride = 4,
 	.max_register = 0x16ac, /* end MIB - Port6 range */
-	.reg_read = qca8k_regmap_read,
-	.reg_write = qca8k_regmap_write,
+	.read = qca8k_bulk_read,
+	.write = qca8k_bulk_write,
 	.reg_update_bits = qca8k_regmap_update_bits,
 	.rd_table = &qca8k_readable_table,
 	.disable_locking = true, /* Locking is handled by qca8k read/write */
 	.cache_type = REGCACHE_NONE, /* Explicitly disable CACHE */
+	.max_raw_read = 16, /* mgmt eth can read/write up to 4 bytes at times */
+	.max_raw_write = 16,
 };
 
 static int
@@ -2014,8 +2070,6 @@ static SIMPLE_DEV_PM_OPS(qca8k_pm_ops,
 
 static const struct qca8k_info_ops qca8xxx_ops = {
 	.autocast_mib = qca8k_get_ethtool_stats_eth,
-	.read_eth = qca8k_read_eth,
-	.write_eth = qca8k_write_eth,
 };
 
 static const struct qca8k_match_data qca8327 = {
diff --git a/drivers/net/dsa/qca/qca8k-common.c b/drivers/net/dsa/qca/qca8k-common.c
index bba95613e218..a3bcff4bac29 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -101,45 +101,6 @@ const struct regmap_access_table qca8k_readable_table = {
 	.n_yes_ranges = ARRAY_SIZE(qca8k_readable_ranges),
 };
 
-/* TODO: remove these extra ops when we can support regmap bulk read/write */
-static int qca8k_bulk_read(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
-{
-	int i, count = len / sizeof(u32), ret;
-
-	if (priv->mgmt_master && priv->info->ops->read_eth &&
-	    !priv->info->ops->read_eth(priv, reg, val, len))
-		return 0;
-
-	for (i = 0; i < count; i++) {
-		ret = regmap_read(priv->regmap, reg + (i * 4), val + i);
-		if (ret < 0)
-			return ret;
-	}
-
-	return 0;
-}
-
-/* TODO: remove these extra ops when we can support regmap bulk read/write */
-static int qca8k_bulk_write(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
-{
-	int i, count = len / sizeof(u32), ret;
-	u32 tmp;
-
-	if (priv->mgmt_master && priv->info->ops->write_eth &&
-	    !priv->info->ops->write_eth(priv, reg, val, len))
-		return 0;
-
-	for (i = 0; i < count; i++) {
-		tmp = val[i];
-
-		ret = regmap_write(priv->regmap, reg + (i * 4), tmp);
-		if (ret < 0)
-			return ret;
-	}
-
-	return 0;
-}
-
 static int qca8k_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
 {
 	u32 val;
@@ -150,11 +111,12 @@ static int qca8k_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
 
 static int qca8k_fdb_read(struct qca8k_priv *priv, struct qca8k_fdb *fdb)
 {
-	u32 reg[3];
+	u32 reg[QCA8K_ATU_TABLE_SIZE];
 	int ret;
 
 	/* load the ARL table into an array */
-	ret = qca8k_bulk_read(priv, QCA8K_REG_ATU_DATA0, reg, sizeof(reg));
+	ret = regmap_bulk_read(priv->regmap, QCA8K_REG_ATU_DATA0, reg,
+			       QCA8K_ATU_TABLE_SIZE);
 	if (ret)
 		return ret;
 
@@ -178,7 +140,7 @@ static int qca8k_fdb_read(struct qca8k_priv *priv, struct qca8k_fdb *fdb)
 static void qca8k_fdb_write(struct qca8k_priv *priv, u16 vid, u8 port_mask,
 			    const u8 *mac, u8 aging)
 {
-	u32 reg[3] = { 0 };
+	u32 reg[QCA8K_ATU_TABLE_SIZE] = { 0 };
 
 	/* vid - 83:72 */
 	reg[2] = FIELD_PREP(QCA8K_ATU_VID_MASK, vid);
@@ -195,7 +157,8 @@ static void qca8k_fdb_write(struct qca8k_priv *priv, u16 vid, u8 port_mask,
 	reg[0] |= FIELD_PREP(QCA8K_ATU_ADDR5_MASK, mac[5]);
 
 	/* load the array into the ARL table */
-	qca8k_bulk_write(priv, QCA8K_REG_ATU_DATA0, reg, sizeof(reg));
+	regmap_bulk_write(priv->regmap, QCA8K_REG_ATU_DATA0, reg,
+			  QCA8K_ATU_TABLE_SIZE);
 }
 
 static int qca8k_fdb_access(struct qca8k_priv *priv, enum qca8k_fdb_cmd cmd,
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index e36ecc9777f4..fc5766a40b8a 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -148,6 +148,8 @@
 #define QCA8K_REG_IPV4_PRI_ADDR_MASK			0x474
 
 /* Lookup registers */
+#define QCA8K_ATU_TABLE_SIZE				3 /* 12 bytes wide table / sizeof(u32) */
+
 #define QCA8K_REG_ATU_DATA0				0x600
 #define   QCA8K_ATU_ADDR2_MASK				GENMASK(31, 24)
 #define   QCA8K_ATU_ADDR3_MASK				GENMASK(23, 16)
@@ -328,9 +330,6 @@ struct qca8k_priv;
 
 struct qca8k_info_ops {
 	int (*autocast_mib)(struct dsa_switch *ds, int port, u64 *data);
-	/* TODO: remove these extra ops when we can support regmap bulk read/write */
-	int (*read_eth)(struct qca8k_priv *priv, u32 reg, u32 *val, int len);
-	int (*write_eth)(struct qca8k_priv *priv, u32 reg, u32 *val, int len);
 };
 
 struct qca8k_match_data {
-- 
2.36.1

