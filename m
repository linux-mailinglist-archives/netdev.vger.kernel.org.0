Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76D02577082
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 19:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbiGPRui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 13:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiGPRue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 13:50:34 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E63CA1D0C6;
        Sat, 16 Jul 2022 10:50:32 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id p26-20020a1c545a000000b003a2fb7c1274so2329338wmi.1;
        Sat, 16 Jul 2022 10:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=3JiWc/5hqj/vkIVmgQzXuREwrFKvIetqrvOYslMnRuI=;
        b=accTHYloOQtzVnbH7VqXpPSEK5zADpmq+RMe1EtOCj+ftfj5Hd42ckOVIULLmM0W4v
         N1yVLcdu6qBYEiIFIJAfvwHlutD5rtxEsFNreZBP0OCeFSdw1Ia1b9ZH++ePjr0aG4bZ
         9iDay5H7c0qitVTipUtMPoF5SmR3SudLS+PBmxUUw4kYvwWDiVuC7HoR/Avrf8xkXDtJ
         D/sVIMMGdrXYsPDdbVPGSEl5H8hcDJJY2sSuJts228aUwgyyi1hQTVv1zRm0hrnS6kL3
         hdPuOX3tB06FujaCkxa01HloIrypPWbqhhcxTh/EPAUyIP7ITMEnbe0UUkNOdwsnM3VW
         vB2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3JiWc/5hqj/vkIVmgQzXuREwrFKvIetqrvOYslMnRuI=;
        b=SDWG4Amy7bS6cD7ktwb2HzGNp+vHgW/TzBeZuXE2AWWTj/jBopweMKG96u4yeHGRHp
         q8Y+I4BFflG7R4vZPculls7KySzEKv5UYMbOgW6EEUT6haytKI2k9vYpfmlTCfVbIAEK
         Y8eF6dJWV4k5SIMMkYbOsOzyo72VYykOcFw51jQyBadQPTaYtgfuzHp0xbfF/zZjB7uh
         YEuKncOfBFwuqLzE9f74BfH4CY2Gp5No/9MXc8dU5Rw2CFoi5pwn9skxEBElBglKYEiX
         ui0Tkem6aU0pGSzVDnIVvrOoulfloYXNz1bSS17GHf4OWCZ6mBq1uhzj1u/Z7jgYNhyL
         Na5A==
X-Gm-Message-State: AJIora83Br9lLWIBSxEj5ug3S3rqXrp4zkD3nnY3lO2IZxdR/7X4V83Z
        m5e2lbKSW24OCmnmZPP3whw=
X-Google-Smtp-Source: AGRyM1vMZAocX6pL7g8VZCC5tT9KwvuKYD/DbtS2onTaWF7GLBYYOPFYGVuGzG4P0jAc80oL2MRZwg==
X-Received: by 2002:a05:600c:a07:b0:39e:da6e:fc49 with SMTP id z7-20020a05600c0a0700b0039eda6efc49mr24450020wmp.143.1657993830805;
        Sat, 16 Jul 2022 10:50:30 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id s6-20020adfecc6000000b0021d74906683sm6836108wro.28.2022.07.16.10.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jul 2022 10:50:30 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [net-next RFC PATCH 2/4] net: dsa: qca8k: convert to regmap read/write API
Date:   Sat, 16 Jul 2022 19:49:56 +0200
Message-Id: <20220716174958.22542-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220716174958.22542-1-ansuelsmth@gmail.com>
References: <20220716174958.22542-1-ansuelsmth@gmail.com>
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
to 16 bytes of data at times. Currently we use a custom function to do
it but regmap now supports declaration of read/write bulk even without a
bus.

Drop the custom function and rework the regmap function to this new
implementation.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca/qca8k.c | 133 ++++++++++++++++++++----------------
 drivers/net/dsa/qca/qca8k.h |   2 +
 2 files changed, 76 insertions(+), 59 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k.c b/drivers/net/dsa/qca/qca8k.c
index 2d34e15c2e6f..fd738d718cd6 100644
--- a/drivers/net/dsa/qca/qca8k.c
+++ b/drivers/net/dsa/qca/qca8k.c
@@ -394,53 +394,12 @@ qca8k_regmap_update_bits_eth(struct qca8k_priv *priv, u32 reg, u32 mask, u32 wri
 }
 
 static int
-qca8k_bulk_read(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
+qca8k_read_mii(struct qca8k_priv *priv, u32 reg, u32 *val)
 {
-	int i, count = len / sizeof(u32), ret;
-
-	if (priv->mgmt_master && !qca8k_read_eth(priv, reg, val, len))
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
-static int
-qca8k_bulk_write(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
-{
-	int i, count = len / sizeof(u32), ret;
-	u32 tmp;
-
-	if (priv->mgmt_master && !qca8k_write_eth(priv, reg, val, len))
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
-static int
-qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
-{
-	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
 	struct mii_bus *bus = priv->bus;
 	u16 r1, r2, page;
 	int ret;
 
-	if (!qca8k_read_eth(priv, reg, val, sizeof(*val)))
-		return 0;
-
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
 	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
@@ -457,16 +416,12 @@ qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
 }
 
 static int
-qca8k_regmap_write(void *ctx, uint32_t reg, uint32_t val)
+qca8k_write_mii(struct qca8k_priv *priv, u32 reg, u32 val)
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
@@ -483,17 +438,14 @@ qca8k_regmap_write(void *ctx, uint32_t reg, uint32_t val)
 }
 
 static int
-qca8k_regmap_update_bits(void *ctx, uint32_t reg, uint32_t mask, uint32_t write_val)
+qca8k_regmap_update_bits_mii(struct qca8k_priv *priv, u32 reg,
+			     u32 mask, u32 write_val)
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
@@ -516,6 +468,66 @@ qca8k_regmap_update_bits(void *ctx, uint32_t reg, uint32_t mask, uint32_t write_
 	return ret;
 }
 
+static int
+qca8k_bulk_read(void *ctx, const void *reg_buf, size_t reg_len,
+		void *val_buf, size_t val_len)
+{
+	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
+	int i, count = val_len / sizeof(u32), ret;
+
+	if (priv->mgmt_master && !qca8k_read_eth(priv, *(u32 *)reg_buf, val_buf, val_len))
+		return 0;
+
+	for (i = 0; i < count; i++) {
+		ret = qca8k_read_mii(priv, *(u32 *)reg_buf + (i * sizeof(u32)), val_buf + i);
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
+	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
+	int i, count = val_len / sizeof(u32), ret;
+	u32 tmp;
+
+	if (priv->mgmt_master &&
+	    !qca8k_write_eth(priv, *(u32 *)reg_buf, (u32 *)val_buf, val_len))
+		return 0;
+
+	for (i = 0; i < count; i++) {
+		tmp = *((u32 *)val_buf + i);
+
+		ret = qca8k_write_mii(priv, *(u32 *)reg_buf + (i * sizeof(u32)), tmp);
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
 static const struct regmap_range qca8k_readable_ranges[] = {
 	regmap_reg_range(0x0000, 0x00e4), /* Global control */
 	regmap_reg_range(0x0100, 0x0168), /* EEE control */
@@ -541,16 +553,18 @@ static const struct regmap_access_table qca8k_readable_table = {
 };
 
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
@@ -565,11 +579,12 @@ qca8k_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
 static int
 qca8k_fdb_read(struct qca8k_priv *priv, struct qca8k_fdb *fdb)
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
 
@@ -594,7 +609,7 @@ static void
 qca8k_fdb_write(struct qca8k_priv *priv, u16 vid, u8 port_mask, const u8 *mac,
 		u8 aging)
 {
-	u32 reg[3] = { 0 };
+	u32 reg[QCA8K_ATU_TABLE_SIZE] = { 0 };
 
 	/* vid - 83:72 */
 	reg[2] = FIELD_PREP(QCA8K_ATU_VID_MASK, vid);
@@ -611,7 +626,7 @@ qca8k_fdb_write(struct qca8k_priv *priv, u16 vid, u8 port_mask, const u8 *mac,
 	reg[0] |= FIELD_PREP(QCA8K_ATU_ADDR5_MASK, mac[5]);
 
 	/* load the array into the ARL table */
-	qca8k_bulk_write(priv, QCA8K_REG_ATU_DATA0, reg, sizeof(reg));
+	regmap_bulk_write(priv->regmap, QCA8K_REG_ATU_DATA0, reg, QCA8K_ATU_TABLE_SIZE);
 }
 
 static int
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index ec58d0e80a70..22ece14e06dc 100644
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
-- 
2.36.1

