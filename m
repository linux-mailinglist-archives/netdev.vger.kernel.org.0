Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF1315A3780
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 13:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbiH0LvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 07:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbiH0Ltk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 07:49:40 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E79D865811;
        Sat, 27 Aug 2022 04:49:38 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id w10so4951066edc.3;
        Sat, 27 Aug 2022 04:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=BNJgC72AfpKIQnb1cHvCbNdeeyBRjYBsxilXEw1s+b4=;
        b=JBVTrcuHo3vu2cIL12cUK3btsvVf3xkxKhycstbYi6JGAWzzoFBrcsSoSknIuqmiv5
         k4ct2GOLJC2FUM6sDQe3grNJlbhQ/E5Ze7YVFAehplhHvjoREkBN9LVTB6EWgR+GbQTw
         qYReHiewnYkT7+5DZYzvw74rCURHdtp7jl5Hn6g3OZRPIeiMD2mASmjYlvDv6wXqNmhO
         iWuoWJJnnfJliuCKMs6S7Bj//7FjDIk3oVCXwjoMlRjroCZsZuSLXVaIZTi1RPY/giF/
         x6kdRwTBHT7fVtfMplvaSOfbwIgvs/6dAcDx7fFYitLTaTWMKCqb6gUSCo40Gac9t3Vx
         k1Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=BNJgC72AfpKIQnb1cHvCbNdeeyBRjYBsxilXEw1s+b4=;
        b=FPGtZ/v7wTSjpXY2KVObpvEfc40bsnzFTI54Og9T0NrthF3C+fCQcIT2t4dE3vNR2C
         LIvMLnIRdl1YkQYM8iI15iKI8ewkH2vX+pcXwo72vgnNf0MSDBuEsGAXXRptnM2lDF+p
         2VZsHWMBKYczKAcvaWWDescby6PBGrw5+dMo6W0jw0PZx7gsY0RJQRckZMXSWx/rJB3I
         W2rXjyCLoxTeypg0eApvoddlb/4ORtap6rnfsz+/WL83EGAgDTrZWOSweR0CJQbNgGvl
         A5hSEoy73Gjs9PmeEK6ZD6na8fdRE1dMVCfnCGKwl9ZMMCYGc2Wm/0X3OWxI16y+fETb
         orYA==
X-Gm-Message-State: ACgBeo3KZMdyaaaNYRArzzgHUwCYYrpUGhmz82VshnjOJtBlI5GZE8ac
        QUSn1ldkmdEmtFbgk/zmg0w=
X-Google-Smtp-Source: AA6agR46kwmpaNii76+kHULnGaX0OY3DgTjx0MB8aeXmnfihjX24Zz0Ony4sXUo6LtDahfYMGGAQNQ==
X-Received: by 2002:a05:6402:25c6:b0:43b:7797:d953 with SMTP id x6-20020a05640225c600b0043b7797d953mr9930577edb.254.1661600977315;
        Sat, 27 Aug 2022 04:49:37 -0700 (PDT)
Received: from localhost.localdomain (host-95-247-89-207.retail.telecomitalia.it. [95.247.89.207])
        by smtp.googlemail.com with ESMTPSA id f20-20020a17090631d400b006fee7b5dff2sm2021683ejf.143.2022.08.27.04.49.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Aug 2022 04:49:36 -0700 (PDT)
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
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>
Subject: [net-next PATCH v2] net: dsa: qca8k: convert to regmap read/write API
Date:   Sat, 27 Aug 2022 13:49:18 +0200
Message-Id: <20220827114918.8863-1-ansuelsmth@gmail.com>
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

v2:
- Move out of RFC.
- CC Mark Brown for first implementation of this kind of regmap stuff.

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

