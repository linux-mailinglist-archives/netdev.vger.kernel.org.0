Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9199767BCAB
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 21:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236457AbjAYUfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 15:35:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236451AbjAYUfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 15:35:33 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A575A819;
        Wed, 25 Jan 2023 12:35:29 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id b7so18286767wrt.3;
        Wed, 25 Jan 2023 12:35:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MRFsv4nQxNgkgdHwR3P2ScZKGU3kpYuxuAJsvzBdwLQ=;
        b=elSfTNc5h1YPqCQO73a2KE7S6cXUcJhaNVXQxcm+Yoxjfv4Icmj0HN13c9XvuJB0bK
         2dQLXYbBh1TUfJV32Moq9DbIltvMQpG9aOvAa+HY9+Gc4ThXjlC8le9aWmPzgWW8g81s
         RhWREES3bKlx7oYxeVe0Cqvc2iJXLnOxlGPVWP7mtaWcL35SoBIytuAgMfEr0oSRA4MZ
         2MIKzVtg6moyhznl1ypjyjVDrdbxJPuJiaJVJiQV1UIcnADdwz9Pqr9ePAn7m+lURTyF
         g2Ufng7OWG2euT5QUJQ/LdWV7mIGs55igFeBRlFSmXGcDcjfDjoWrfsel5OwP8JJvtW8
         Fp+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MRFsv4nQxNgkgdHwR3P2ScZKGU3kpYuxuAJsvzBdwLQ=;
        b=b1CQOWPU8ndaZxkBk7QSLYxLZnvnzz5U+f4Di+duBNHSDbRkZNUcKvI8PnY5PUfv6L
         HqlIxOe92Ryi+s/Y95Vz4+Op1hn9zdRyQez4Z8FtUf/rzffrgQMuLU/lvNCzvfz/tcwr
         CUivHEEDMgmycfcbNI5EV0snkV3nCJu2VVwYBO77svm9lD5cl/uqHJtuIAoKpY3NpFwX
         3/UXVBGOQjoNeoYikfpmuGc/AL9HwpQIrDCSZtzCm5191XL7+351CKFPfit36Lfv39nj
         N3u+nuzGdgFEo8I5PKzZU4phDkKOhKoa4MS6UKUDzvMDzMzRw4PiF6Nuf/F5soLCNnUa
         ZG4g==
X-Gm-Message-State: AFqh2krMUH1yYLlobTar8Y0HxYljRgfI/4ITzAw1gW5Cj4XsLFJ4dWAT
        fOKDLvFS/ZpOWJD6N2SllsQ=
X-Google-Smtp-Source: AMrXdXtokg8sd0WhgAuEYZA+vI0BhySCviU2KtgyvfBlg3af7E0JGILxqzvd+HPk6BBQNXHhH6Z8xQ==
X-Received: by 2002:adf:ce01:0:b0:2bd:e208:1e4c with SMTP id p1-20020adfce01000000b002bde2081e4cmr32760800wrn.11.1674678928243;
        Wed, 25 Jan 2023 12:35:28 -0800 (PST)
Received: from localhost.localdomain (93-34-89-61.ip49.fastwebnet.it. [93.34.89.61])
        by smtp.googlemail.com with ESMTPSA id x26-20020a1c7c1a000000b003db01178b62sm2733566wmc.40.2023.01.25.12.35.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 12:35:27 -0800 (PST)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>
Subject: [net-next PATCH v3 2/2] net: dsa: qca8k: convert to regmap read/write API
Date:   Wed, 25 Jan 2023 21:35:17 +0100
Message-Id: <20230125203517.947-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230125203517.947-1-ansuelsmth@gmail.com>
References: <20230125203517.947-1-ansuelsmth@gmail.com>
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

Convert qca8k to regmap read/write bulk API. The mgmt eth can write up
to 32 bytes of data at times. Currently we use a custom function to do
it but regmap now supports declaration of read/write bulk even without a
bus.

Drop the custom function and rework the regmap function to this new
implementation.

Rework the qca8k_fdb_read/write function to use the new
regmap_bulk_read/write as the old qca8k_bulk_read/write are now dropped.

Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---

v3:
- Split ATU define to diffetent patch
- Refresh with new finding for the mgmt fixes
v2:
- Move out of RFC.
- CC Mark Brown for first implementation of this kind of regmap stuff.

 drivers/net/dsa/qca/qca8k-8xxx.c   | 92 ++++++++++++++++++++++++------
 drivers/net/dsa/qca/qca8k-common.c | 47 ++-------------
 drivers/net/dsa/qca/qca8k.h        |  3 -
 3 files changed, 77 insertions(+), 65 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 2f224b166bbb..55df4479ea30 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -425,16 +425,12 @@ qca8k_regmap_update_bits_eth(struct qca8k_priv *priv, u32 reg, u32 mask, u32 wri
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
@@ -451,16 +447,12 @@ qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
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
@@ -477,17 +469,14 @@ qca8k_regmap_write(void *ctx, uint32_t reg, uint32_t val)
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
@@ -510,17 +499,84 @@ qca8k_regmap_update_bits(void *ctx, uint32_t reg, uint32_t mask, uint32_t write_
 	return ret;
 }
 
+static int
+qca8k_bulk_read(void *ctx, const void *reg_buf, size_t reg_len,
+		void *val_buf, size_t val_len)
+{
+	int i, count = val_len / sizeof(u32), ret;
+	u32 reg = *(u32 *)reg_buf & U16_MAX;
+	struct qca8k_priv *priv = ctx;
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
+	u32 reg = *(u32 *)reg_buf & U16_MAX;
+	struct qca8k_priv *priv = ctx;
+	u32 *val = (u32 *)val_buf;
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
+	return qca8k_bulk_gather_write(ctx, data, sizeof(u16), data + sizeof(u16),
+				       bytes - sizeof(u16));
+}
+
+static int
+qca8k_regmap_update_bits(void *ctx, uint32_t reg, uint32_t mask, uint32_t write_val)
+{
+	struct qca8k_priv *priv = ctx;
+
+	if (!qca8k_regmap_update_bits_eth(priv, reg, mask, write_val))
+		return 0;
+
+	return qca8k_regmap_update_bits_mii(priv, reg, mask, write_val);
+}
+
 static struct regmap_config qca8k_regmap_config = {
 	.reg_bits = 16,
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
+	.max_raw_read = 32, /* mgmt eth can read/write up to 8 registers at time */
+	.max_raw_write = 32,
 };
 
 static int
@@ -2089,8 +2145,6 @@ static SIMPLE_DEV_PM_OPS(qca8k_pm_ops,
 
 static const struct qca8k_info_ops qca8xxx_ops = {
 	.autocast_mib = qca8k_get_ethtool_stats_eth,
-	.read_eth = qca8k_read_eth,
-	.write_eth = qca8k_write_eth,
 };
 
 static const struct qca8k_match_data qca8327 = {
diff --git a/drivers/net/dsa/qca/qca8k-common.c b/drivers/net/dsa/qca/qca8k-common.c
index 2f82a8dae9ff..96773e432558 100644
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
@@ -154,8 +115,8 @@ static int qca8k_fdb_read(struct qca8k_priv *priv, struct qca8k_fdb *fdb)
 	int ret;
 
 	/* load the ARL table into an array */
-	ret = qca8k_bulk_read(priv, QCA8K_REG_ATU_DATA0, reg,
-			      QCA8K_ATU_TABLE_SIZE * sizeof(u32));
+	ret = regmap_bulk_read(priv->regmap, QCA8K_REG_ATU_DATA0, reg,
+			       QCA8K_ATU_TABLE_SIZE);
 	if (ret)
 		return ret;
 
@@ -196,8 +157,8 @@ static void qca8k_fdb_write(struct qca8k_priv *priv, u16 vid, u8 port_mask,
 	reg[0] |= FIELD_PREP(QCA8K_ATU_ADDR5_MASK, mac[5]);
 
 	/* load the array into the ARL table */
-	qca8k_bulk_write(priv, QCA8K_REG_ATU_DATA0, reg,
-			 QCA8K_ATU_TABLE_SIZE * sizeof(u32));
+	regmap_bulk_write(priv->regmap, QCA8K_REG_ATU_DATA0, reg,
+			  QCA8K_ATU_TABLE_SIZE);
 }
 
 static int qca8k_fdb_access(struct qca8k_priv *priv, enum qca8k_fdb_cmd cmd,
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index 593a882ec43c..7996975d29d3 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -330,9 +330,6 @@ struct qca8k_priv;
 
 struct qca8k_info_ops {
 	int (*autocast_mib)(struct dsa_switch *ds, int port, u64 *data);
-	/* TODO: remove these extra ops when we can support regmap bulk read/write */
-	int (*read_eth)(struct qca8k_priv *priv, u32 reg, u32 *val, int len);
-	int (*write_eth)(struct qca8k_priv *priv, u32 reg, u32 *val, int len);
 };
 
 struct qca8k_match_data {
-- 
2.38.1

