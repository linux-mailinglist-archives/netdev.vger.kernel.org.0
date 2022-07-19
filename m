Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C496578FA2
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 03:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236574AbiGSBPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 21:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236564AbiGSBPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 21:15:15 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8153EA186;
        Mon, 18 Jul 2022 18:15:13 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id b26so19470905wrc.2;
        Mon, 18 Jul 2022 18:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ROcGcn87eR0KXtQ1Ip4sx/vhEMiAFqBw6IjmN7wdci8=;
        b=pQBff0aXHEfqN4Lxk8yqM+xh+dOO1AVzEy5SidG3HgsoR8D8yVZxM7EEw7YW+wbZko
         2axJRPLIO/c8jhQt+QU6Zu4nuhdFYIq7gAmxAlDY2ag0/916EPUsJYEYKFXlY5ajKQ9E
         8XeckAkm5y0rkswrFhf6ylXyV5k7Gm3IVNjOBmsVhIDUEK9n8PNcc0mqZOA5QZdN9lQ9
         3umMoueo9J6gElY9eQRMBeKQNt+vETS8ywqbdVMZswGqyHcNjFZJbr8ljtHrM3VQ7ARP
         vjJ3VlXC2Ep6ciQ4K+QFjnlpTAEkQrFs8dF2LANDVVRgbi0xBP9g4yVp5BdyX0oqh9p/
         ZzRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ROcGcn87eR0KXtQ1Ip4sx/vhEMiAFqBw6IjmN7wdci8=;
        b=G9R7cNhwh0deTrpb76EC2Y9RalybJ6EazNoASvHNhdA9W1fwKex9YgflMz4bkPQKxv
         oC6QzRKstD/tmVyKB9LPL/alHMBITDgl6nyZtgDuNaRDQJfvHrIQVCpc38y1Qzy+w5m3
         NSGeufz/NrvE/u6w8CCEWOO4DVG4du+BfU6CNOHktfOl1Xgf3K5BW5Ru0hhyD6F4HZPd
         4OZtJOu0Nh8uLSUMESMF98XwsdmecTD+htMsUIIdJ/tVObad7EkrckUaVG1qzRS6sR2+
         8EOjmAz55Ei1glogzoC5fwQQ5iPPqoMaVlIvt7rDHzIoc7Whf2l8kvkmNYLFrIXmBZH+
         B0ug==
X-Gm-Message-State: AJIora8NTwzc552bcWwiY/uAhCQA+dkTvgsp7924yoF4G/m/WiCGE4Ml
        +kTr8kfkkvFZOEaHQghqzUg=
X-Google-Smtp-Source: AGRyM1siKQJq2+Nc5Nhs04l9TsmYvS1E2kJ7meWqKsnFeLJ3uIrCo+Lf8Je5qmZqpMO2K+djPl293w==
X-Received: by 2002:adf:d1e2:0:b0:21d:d40b:d816 with SMTP id g2-20020adfd1e2000000b0021dd40bd816mr14562951wrd.682.1658193311834;
        Mon, 18 Jul 2022 18:15:11 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id y11-20020adff14b000000b0021db7b0162esm11840239wro.105.2022.07.18.18.15.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 18:15:11 -0700 (PDT)
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
Subject: [net-next PATCH v2 03/15] net: dsa: qca8k: move qca8kread/write/rmw and reg table to common code
Date:   Tue, 19 Jul 2022 02:57:14 +0200
Message-Id: <20220719005726.8739-5-ansuelsmth@gmail.com>
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

The same reg table and function are used by drivers based on qca8k family
switch. Move them to common code to make it accessible also by other
drivers.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c   | 42 ------------------------------
 drivers/net/dsa/qca/qca8k-common.c | 39 +++++++++++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h        |  6 +++++
 3 files changed, 45 insertions(+), 42 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 3f6c1427734d..46c371f5decc 100644
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
index 7a63e96c8c08..1c2169e98f10 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -61,3 +61,42 @@ const struct qca8k_mib_desc ar8327_mib[] = {
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
+
+};
+
+const struct regmap_access_table qca8k_readable_table = {
+	.yes_ranges = qca8k_readable_ranges,
+	.n_yes_ranges = ARRAY_SIZE(qca8k_readable_ranges),
+};
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index 0c9b60555670..20cceac494eb 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -419,5 +419,11 @@ struct qca8k_fdb {
 
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

