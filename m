Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBB35578FAB
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 03:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235293AbiGSBPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 21:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236541AbiGSBPQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 21:15:16 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5DCA47B;
        Mon, 18 Jul 2022 18:15:14 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id l22-20020a05600c4f1600b003a2e10c8cdeso117206wmq.1;
        Mon, 18 Jul 2022 18:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=9jhuGUIYMFvXoHBbcobxLSdL1Lr9bmeAFfwRUfGvyzA=;
        b=XeIdr0B68uXsdu3IK961FZ+as9uspJon2vHeTQB40zTdyUKYJ0iZWS4MVRmQJdvum4
         BWPc0cq0Qh2P216z6KlAtSmjtwo7AKv3uVepqsEb+g5/SEpnMyvqzC8pwCTLG4YgMUaU
         y5r8I1Abm04w0kMEXsY38zcfkjrv1QGaU7yvPyAr0iuMZVwWH+9jM+fbMkLkK4z+aVR5
         4eX5DRqL0KUCjLD7hGMxNXLs2EdGBhnZPktIltiXUv481y3Z6cYR8qVA5kt33q9ljmXr
         IywmtryM31MPu0Dlta08okTFEQ+FVp3696JDxva+I6jAhd9vroLoKd6GZn+h8dBRBOs+
         Yihw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9jhuGUIYMFvXoHBbcobxLSdL1Lr9bmeAFfwRUfGvyzA=;
        b=xRXgqXFxiT899WxPv4tz9EItwgIh+krl48GxSKttSe+bAg/Dzh3Ewx+W/4GaYWwb4E
         IZ63dSH7ViS2rGnIcphv8ik0n0dwXQ0zXUPStkCNU/8kF+za5aQjrMKXJpvqv3rsyjZH
         jYqeI/HAXRqKNR3LRpm7SQCvdaCDxMohvCVWusZPfOrpS7v5P6vE99ZEVeTaEBq/Az0l
         qWs0Lb1evKehB7dLPmFsCYH0k12QsIy/yaitix4FCJXI0+FfknDAwglIvZbHKeQqjdAz
         8Sb8K08OY2E07AQKoyjFgvLOZc8MX+5zq/QFTPg9TPkSGVHQDyqX3XgXGWkJm4QFknw8
         exAg==
X-Gm-Message-State: AJIora9jIVxSZHlGtzQWJuvz3JXtLR3r2vgOABqPlG2vT16owaCxjOo7
        eXiVBalhCEcpbyjfCp7PLW8=
X-Google-Smtp-Source: AGRyM1tY75YBheJofk2UZ8gqYXQb1DbRKqA948VuHFOfxUnsg5jLTUUVMr5mWOQJfa0PflSyJCXhxg==
X-Received: by 2002:a05:600c:4f81:b0:3a3:1f5a:2b6a with SMTP id n1-20020a05600c4f8100b003a31f5a2b6amr4134834wmq.53.1658193312971;
        Mon, 18 Jul 2022 18:15:12 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id y11-20020adff14b000000b0021db7b0162esm11840239wro.105.2022.07.18.18.15.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 18:15:12 -0700 (PDT)
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
Subject: [net-next PATCH v2 04/15] net: dsa: qca8k: move qca8k bulk read/write helper to common code
Date:   Tue, 19 Jul 2022 02:57:15 +0200
Message-Id: <20220719005726.8739-6-ansuelsmth@gmail.com>
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

The same ATU function are used by drivers based on qca8k family switch.
Move the bulk read/write helper to common code to declare these shared
ATU functions in common code.
These helper will be dropped when regmap correctly support bulk
read/write.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c   | 43 ++++------------------------
 drivers/net/dsa/qca/qca8k-common.c | 46 ++++++++++++++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h        |  8 ++++++
 3 files changed, 60 insertions(+), 37 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 46c371f5decc..3178ae023d2a 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -342,43 +342,6 @@ qca8k_regmap_update_bits_eth(struct qca8k_priv *priv, u32 reg, u32 mask, u32 wri
 	return qca8k_write_eth(priv, reg, &val, sizeof(val));
 }
 
-static int
-qca8k_bulk_read(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
-{
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
 static int
 qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
 {
@@ -3168,18 +3131,24 @@ static const struct qca8k_match_data qca8327 = {
 	.reduced_package = true,
 	.mib_count = QCA8K_QCA832X_MIB_COUNT,
 	.autocast_mib = qca8k_get_ethtool_stats_eth,
+	.read_eth = qca8k_read_eth,
+	.write_eth = qca8k_write_eth,
 };
 
 static const struct qca8k_match_data qca8328 = {
 	.id = QCA8K_ID_QCA8327,
 	.mib_count = QCA8K_QCA832X_MIB_COUNT,
 	.autocast_mib = qca8k_get_ethtool_stats_eth,
+	.read_eth = qca8k_read_eth,
+	.write_eth = qca8k_write_eth,
 };
 
 static const struct qca8k_match_data qca833x = {
 	.id = QCA8K_ID_QCA8337,
 	.mib_count = QCA8K_QCA833X_MIB_COUNT,
 	.autocast_mib = qca8k_get_ethtool_stats_eth,
+	.read_eth = qca8k_read_eth,
+	.write_eth = qca8k_write_eth,
 };
 
 static const struct of_device_id qca8k_of_match[] = {
diff --git a/drivers/net/dsa/qca/qca8k-common.c b/drivers/net/dsa/qca/qca8k-common.c
index 1c2169e98f10..91b3ad048392 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -8,6 +8,7 @@
 
 #include <linux/netdevice.h>
 #include <net/dsa.h>
+#include <linux/of_platform.h>
 
 #include "qca8k.h"
 
@@ -100,3 +101,48 @@ const struct regmap_access_table qca8k_readable_table = {
 	.yes_ranges = qca8k_readable_ranges,
 	.n_yes_ranges = ARRAY_SIZE(qca8k_readable_ranges),
 };
+
+/* TODO: remove these extra ops when we can support regmap bulk read/write */
+int qca8k_bulk_read(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
+{
+	int i, count = len / sizeof(u32), ret;
+	const struct qca8k_match_data *data;
+
+	data = of_device_get_match_data(priv->dev);
+
+	if (priv->mgmt_master && data->read_eth &&
+	    !data->read_eth(priv, reg, val, len))
+		return 0;
+
+	for (i = 0; i < count; i++) {
+		ret = regmap_read(priv->regmap, reg + (i * 4), val + i);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+/* TODO: remove these extra ops when we can support regmap bulk read/write */
+int qca8k_bulk_write(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
+{
+	int i, count = len / sizeof(u32), ret;
+	const struct qca8k_match_data *data;
+	u32 tmp;
+
+	data = of_device_get_match_data(priv->dev);
+
+	if (priv->mgmt_master && data->write_eth &&
+	    !data->write_eth(priv, reg, val, len))
+		return 0;
+
+	for (i = 0; i < count; i++) {
+		tmp = val[i];
+
+		ret = regmap_write(priv->regmap, reg + (i * 4), tmp);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index 20cceac494eb..78dbecc41a3d 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -324,11 +324,16 @@ enum qca8k_mid_cmd {
 	QCA8K_MIB_CAST = 3,
 };
 
+struct qca8k_priv;
+
 struct qca8k_match_data {
 	u8 id;
 	bool reduced_package;
 	u8 mib_count;
 	int (*autocast_mib)(struct dsa_switch *ds, int port, u64 *data);
+	/* TODO: remove these extra ops when we can support regmap bulk read/write */
+	int (*read_eth)(struct qca8k_priv *priv, u32 reg, u32 *val, int len);
+	int (*write_eth)(struct qca8k_priv *priv, u32 reg, u32 *val, int len);
 };
 
 enum {
@@ -426,4 +431,7 @@ int qca8k_read(struct qca8k_priv *priv, u32 reg, u32 *val);
 int qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val);
 int qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val);
 
+int qca8k_bulk_read(struct qca8k_priv *priv, u32 reg, u32 *val, int len);
+int qca8k_bulk_write(struct qca8k_priv *priv, u32 reg, u32 *val, int len);
+
 #endif /* __QCA8K_H */
-- 
2.36.1

