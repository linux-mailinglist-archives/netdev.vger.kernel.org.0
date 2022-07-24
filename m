Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B100657F777
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 00:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbiGXWvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 18:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232165AbiGXWvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 18:51:11 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0B9BC8B;
        Sun, 24 Jul 2022 15:51:10 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id fy29so17428375ejc.12;
        Sun, 24 Jul 2022 15:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=PWIi7bXAk34pE2/mfR+d/FhcmGvbKOsyRBUSNCP07AE=;
        b=MN2F2Y7A/bcmM2Ihc9FqVbmH4bw86I3GiI8M1FJTxZ5j3Ncxi8PBtTBTvp0ZI8HUMt
         dlGu/ZVrTkV7hMWkaN0ZuMWUHVA5ZLJ09Q8ldPM7P3NC3xh2fAGyxWjDZ0tEWva7qbjC
         iFTLqcM+CxIqWbPHlcHqnT9cC0YgROa96/53XXVuG0Jh5K4ZyjfJdEq1RN8lF5mTsUlv
         pbTs532tHclXaYTcQd+Um0OthARryq9fVW/EXtdSApf5Hotx8szPBUQ/RsL8KNYNInW3
         h2pokRhG3nJyJYkEheT8XTfMDLQ+0agwphOytHdhZe/0N8upgGaW7lR5ovXkKt5MViTq
         6U6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PWIi7bXAk34pE2/mfR+d/FhcmGvbKOsyRBUSNCP07AE=;
        b=jy4qlDytV1X7SKrGPai3/q0jHABqtg3zjabGxrmuZzeM9feStyqJdFSfk/JMJRGbOy
         Vza42RU+COBe7rdJbVJ7yrSUDa0qZIOiwznfdvK5Pbc1UsdSzw7pbyi+SI/vUofJHFTy
         aRdB8c4EPrQCb4MmeKMca5I3hsBEmZXMPCIqgI1jHLl7VtZ6zkXVg3oazJB7l8Wk6O+3
         17XTVxWmvaHeb6fKJ3qEG/IqqLfN4CWB72+dLjaK2j6h2O7Z9kiLC3Hz6pGZp8DAKL1o
         7iX21O+KH9P8wc+MfE5xVEjquL9/WspOFFPpcOM6jb8h5koHZlZuclHEk/obCDBx95mO
         7AWA==
X-Gm-Message-State: AJIora9H6B8wtZhpWJtzZIzoy83Ne9O7qFjqvw6OSNBjY2oyjXWhgpz1
        euZj5o4mfl3gAyDEwoZpNX8=
X-Google-Smtp-Source: AGRyM1uK91X9vYEbZS6CMRXLkA2iTUIS8APfZYEbGflgPxLuy8Ya3rw3Y9qHBABbKnpWuOjVUAnGEA==
X-Received: by 2002:a17:906:7950:b0:72f:d4a4:564d with SMTP id l16-20020a170906795000b0072fd4a4564dmr2292893ejo.479.1658703069159;
        Sun, 24 Jul 2022 15:51:09 -0700 (PDT)
Received: from localhost.localdomain (93-42-69-122.ip85.fastwebnet.it. [93.42.69.122])
        by smtp.googlemail.com with ESMTPSA id nc19-20020a1709071c1300b00722d5b26ecesm4645238ejc.205.2022.07.24.15.51.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jul 2022 15:51:08 -0700 (PDT)
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
Subject: [net-next PATCH v4 04/14] net: dsa: qca8k: move qca8k read/write/rmw and reg table to common code
Date:   Sun, 24 Jul 2022 22:19:28 +0200
Message-Id: <20220724201938.17387-5-ansuelsmth@gmail.com>
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

The same reg table and read/write/rmw function are used by drivers
based on qca8k family switch.
Move them to common code to make it accessible also by other drivers.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c   | 42 ------------------------------
 drivers/net/dsa/qca/qca8k-common.c | 38 +++++++++++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h        |  6 +++++
 3 files changed, 44 insertions(+), 42 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index bf2e2345cf57..bc9b490f8073 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -133,24 +133,6 @@ qca8k_set_page(struct qca8k_priv *priv, u16 page)
 	return 0;
 }
 
-static int
-qca8k_read(struct qca8k_priv *priv, u32 reg, u32 *val)
-{
-	return regmap_read(priv->regmap, reg, val);
-}
-
-static int
-qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val)
-{
-	return regmap_write(priv->regmap, reg, val);
-}
-
-static int
-qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val)
-{
-	return regmap_update_bits(priv->regmap, reg, mask, write_val);
-}
-
 static void qca8k_rw_reg_ack_handler(struct dsa_switch *ds, struct sk_buff *skb)
 {
 	struct qca8k_mgmt_eth_data *mgmt_eth_data;
@@ -483,30 +465,6 @@ qca8k_regmap_update_bits(void *ctx, uint32_t reg, uint32_t mask, uint32_t write_
 	return ret;
 }
 
-static const struct regmap_range qca8k_readable_ranges[] = {
-	regmap_reg_range(0x0000, 0x00e4), /* Global control */
-	regmap_reg_range(0x0100, 0x0168), /* EEE control */
-	regmap_reg_range(0x0200, 0x0270), /* Parser control */
-	regmap_reg_range(0x0400, 0x0454), /* ACL */
-	regmap_reg_range(0x0600, 0x0718), /* Lookup */
-	regmap_reg_range(0x0800, 0x0b70), /* QM */
-	regmap_reg_range(0x0c00, 0x0c80), /* PKT */
-	regmap_reg_range(0x0e00, 0x0e98), /* L3 */
-	regmap_reg_range(0x1000, 0x10ac), /* MIB - Port0 */
-	regmap_reg_range(0x1100, 0x11ac), /* MIB - Port1 */
-	regmap_reg_range(0x1200, 0x12ac), /* MIB - Port2 */
-	regmap_reg_range(0x1300, 0x13ac), /* MIB - Port3 */
-	regmap_reg_range(0x1400, 0x14ac), /* MIB - Port4 */
-	regmap_reg_range(0x1500, 0x15ac), /* MIB - Port5 */
-	regmap_reg_range(0x1600, 0x16ac), /* MIB - Port6 */
-
-};
-
-static const struct regmap_access_table qca8k_readable_table = {
-	.yes_ranges = qca8k_readable_ranges,
-	.n_yes_ranges = ARRAY_SIZE(qca8k_readable_ranges),
-};
-
 static struct regmap_config qca8k_regmap_config = {
 	.reg_bits = 16,
 	.val_bits = 32,
diff --git a/drivers/net/dsa/qca/qca8k-common.c b/drivers/net/dsa/qca/qca8k-common.c
index 7a63e96c8c08..880a49de22b1 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -61,3 +61,41 @@ const struct qca8k_mib_desc ar8327_mib[] = {
 	MIB_DESC(1, 0xa8, "RXUnicast"),
 	MIB_DESC(1, 0xac, "TXUnicast"),
 };
+
+int qca8k_read(struct qca8k_priv *priv, u32 reg, u32 *val)
+{
+	return regmap_read(priv->regmap, reg, val);
+}
+
+int qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val)
+{
+	return regmap_write(priv->regmap, reg, val);
+}
+
+int qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val)
+{
+	return regmap_update_bits(priv->regmap, reg, mask, write_val);
+}
+
+static const struct regmap_range qca8k_readable_ranges[] = {
+	regmap_reg_range(0x0000, 0x00e4), /* Global control */
+	regmap_reg_range(0x0100, 0x0168), /* EEE control */
+	regmap_reg_range(0x0200, 0x0270), /* Parser control */
+	regmap_reg_range(0x0400, 0x0454), /* ACL */
+	regmap_reg_range(0x0600, 0x0718), /* Lookup */
+	regmap_reg_range(0x0800, 0x0b70), /* QM */
+	regmap_reg_range(0x0c00, 0x0c80), /* PKT */
+	regmap_reg_range(0x0e00, 0x0e98), /* L3 */
+	regmap_reg_range(0x1000, 0x10ac), /* MIB - Port0 */
+	regmap_reg_range(0x1100, 0x11ac), /* MIB - Port1 */
+	regmap_reg_range(0x1200, 0x12ac), /* MIB - Port2 */
+	regmap_reg_range(0x1300, 0x13ac), /* MIB - Port3 */
+	regmap_reg_range(0x1400, 0x14ac), /* MIB - Port4 */
+	regmap_reg_range(0x1500, 0x15ac), /* MIB - Port5 */
+	regmap_reg_range(0x1600, 0x16ac), /* MIB - Port6 */
+};
+
+const struct regmap_access_table qca8k_readable_table = {
+	.yes_ranges = qca8k_readable_ranges,
+	.n_yes_ranges = ARRAY_SIZE(qca8k_readable_ranges),
+};
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index 0f274bb350f8..c9b753743dfd 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -424,5 +424,11 @@ struct qca8k_fdb {
 
 /* Common setup function */
 extern const struct qca8k_mib_desc ar8327_mib[];
+extern const struct regmap_access_table qca8k_readable_table;
+
+/* Common read/write/rmw function */
+int qca8k_read(struct qca8k_priv *priv, u32 reg, u32 *val);
+int qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val);
+int qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val);
 
 #endif /* __QCA8K_H */
-- 
2.36.1

