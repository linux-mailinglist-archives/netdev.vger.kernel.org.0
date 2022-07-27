Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB5C5825A6
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 13:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbiG0Lf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 07:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232103AbiG0Lfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 07:35:48 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B19C49B5F;
        Wed, 27 Jul 2022 04:35:47 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id i13so11895665edj.11;
        Wed, 27 Jul 2022 04:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=u/CWUdj4wodMemeG+T6sKoKJ2OETDAnhTSH8WgMVAKg=;
        b=F96vQaH8SPWleJGyLGMRks4P2Jiv9ib7SmGdUkYQn+F4dAIKR8nCWK1VavDdorq4dv
         +DVmlZWP8o4UGBMLK8ihUVltGNYllmVMBLk9z7j/emsAEz9rbbOiU2VQwZr7sXzb7gz9
         IthJAWzmz/yiRwXcRuTEPrc6dUb4DRqWrPbYHVBzcfu+hMtNoH/1N9ft69OyPfurSH3f
         KVANbAA0ohGTMG66OtcCGmCljUDK5qv2EDdVEoMC35gUFRArBEDyTBc0v3m/2Q6wi1oA
         3MMgX9zkpaYGMdCW40Z92sI5PesTWuOi+5SV1uhdfwq2eO3Ye95cv/YGOOk1OAgvFS7m
         X41g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u/CWUdj4wodMemeG+T6sKoKJ2OETDAnhTSH8WgMVAKg=;
        b=7qyV+z9v7SazxQrt4DhaMxwb7w6ZL+8zuybswosRZknW2zRG+yr1xnphmmHT79KKHJ
         W7Dad8+c2WM8XeVgcDPvAWf4dcOwB6+3AflGybzuNK2cKTP5ovPl0V2MHmwUiStnCCpB
         ilrTDBssEdTCNjCqIl2JWzBOu8IoO7pm8b1mXi2cddK2KCGOwrjvs26HghycUbjDfEIK
         FUrOdI3KAaIDu2V2o7EutyVDLiREXFRLJ6DrQvf8A2cu5lQaDWdwWYuRG5ZmW2zEcLbQ
         r6M+rpgoABMlNAxdstO/a2YCMU1wWcJO5XcDlfCf+Z97Jn1yhX5kzKVBPRymqaCWSFs2
         qc+A==
X-Gm-Message-State: AJIora83TDuEdlF7fAuH0psTWY69PsxjxDEZ1FHhYuuJct4igQLxJ2jH
        djWsr38UmrdvArctEw4BBHY=
X-Google-Smtp-Source: AGRyM1vV1mvzp29XzQCyJ4hk0kfpsNNOxWDMIK2RlKrFXH29GTGbFOSpnwmzDP1XrNeQpMTAMZ6urA==
X-Received: by 2002:aa7:c3d1:0:b0:43c:c713:fac8 with SMTP id l17-20020aa7c3d1000000b0043cc713fac8mr1058277edr.371.1658921745633;
        Wed, 27 Jul 2022 04:35:45 -0700 (PDT)
Received: from localhost.localdomain (c105-182.i13-27.melita.com. [94.17.105.182])
        by smtp.googlemail.com with ESMTPSA id p25-20020aa7cc99000000b0043ca6fb7e7dsm1334056edt.68.2022.07.27.04.35.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 04:35:45 -0700 (PDT)
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
Subject: [net-next PATCH v5 04/14] net: dsa: qca8k: move qca8k read/write/rmw and reg table to common code
Date:   Wed, 27 Jul 2022 13:35:13 +0200
Message-Id: <20220727113523.19742-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220727113523.19742-1-ansuelsmth@gmail.com>
References: <20220727113523.19742-1-ansuelsmth@gmail.com>
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
index e9c4a54bc97a..2c31b7925aae 100644
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

