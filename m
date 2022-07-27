Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA2558259E
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 13:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiG0LgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 07:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232144AbiG0Lf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 07:35:56 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9497449B62;
        Wed, 27 Jul 2022 04:35:47 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id l23so31000591ejr.5;
        Wed, 27 Jul 2022 04:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=pVe9frLrd7RG5Xx8qqbmqeob/67Vwm3M9mfbIvryJWY=;
        b=dFDTCUeCW79erKQ7O2eUBoHvpOeXifrxOKl+FgF9ZM9xUbs3L/A0fFTjEJf6sBf9QK
         JwClpOY4tYFR5yllVNOYFqF/Ns80g3xZldideVEiaARFoZ9sR1e8kYoCLIdYZdJ0hI4D
         TlMk7lQ4Bhs2DLVPOlNP/4TCgjTbu804FKtf83N2aBgw8ckVfoa8LeSoTBAiaI9mzFIA
         EwENl+JWmTcK2lPQCmhw+2TwtBJzZKSCKbEcw+9b5X0VTXzFiipbicHwhnvxar9qsF29
         O0awbxUAJwWMoDRRDSpLkEj08bvYi3mXAB6warZmT1iLjaJ8oCnL5Yi5I6bUctZpPVq4
         o+Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pVe9frLrd7RG5Xx8qqbmqeob/67Vwm3M9mfbIvryJWY=;
        b=k2s8Uli2vI+ltXTOs6Le446irWt9snKjhMAC25qS6tjd4HHBFxFS0QBcybM5UpyAPI
         I69wwsCZ2Vlqb7VTBoSPOd8j+V1nHc1R8fAEBWir6byF2nyKp0jjnIgyEuOP4Eb4O6wo
         6jUjvoskuDh+gVpf+0QXHcnIEuFe3BD72qV6sz7NOWaW7SIBk+EIFv9xgxzTeQ7jtliM
         iDV9C37T+3U2F0MQYXMPsD/yMKDEkVlQM93mOQ1ncLbfT7lvnuMNNOxrW2f6Vye/ttkx
         LuMzuU1eoX4wtzbbniGgqpzEPxZNCc3eJtBe8OIl+l/DN1FY2xAoLXQ5+RP6lc6OH8/l
         g3OA==
X-Gm-Message-State: AJIora+4ac83IBktLzw5ghG0IV3F6+LaGCgKzKvaNJNhYkr41KuwWoZf
        5EC74HWiE+tSzr7vegShE5U=
X-Google-Smtp-Source: AGRyM1vZZ59pnQhj9P7gwEdWejiyoMTDU/6Bz7e2cYjXpfrTGhUa7f3T5jBFPEM+2vublGywOC4thA==
X-Received: by 2002:a17:907:272a:b0:72b:8cd9:9ddd with SMTP id d10-20020a170907272a00b0072b8cd99dddmr17898722ejl.299.1658921747059;
        Wed, 27 Jul 2022 04:35:47 -0700 (PDT)
Received: from localhost.localdomain (c105-182.i13-27.melita.com. [94.17.105.182])
        by smtp.googlemail.com with ESMTPSA id p25-20020aa7cc99000000b0043ca6fb7e7dsm1334056edt.68.2022.07.27.04.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 04:35:46 -0700 (PDT)
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
Subject: [net-next PATCH v5 05/14] net: dsa: qca8k: move qca8k bulk read/write helper to common code
Date:   Wed, 27 Jul 2022 13:35:14 +0200
Message-Id: <20220727113523.19742-6-ansuelsmth@gmail.com>
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

The same ATU function are used by drivers based on qca8k family switch.
Move the bulk read/write helper to common code to declare these shared
ATU functions in common code.
These helper will be dropped when regmap correctly support bulk
read/write.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c   | 39 ++----------------------------
 drivers/net/dsa/qca/qca8k-common.c | 39 ++++++++++++++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h        |  8 ++++++
 3 files changed, 49 insertions(+), 37 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 2c31b7925aae..8a5529844c7a 100644
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
@@ -3152,6 +3115,8 @@ static SIMPLE_DEV_PM_OPS(qca8k_pm_ops,
 
 static const struct qca8k_info_ops qca8xxx_ops = {
 	.autocast_mib = qca8k_get_ethtool_stats_eth,
+	.read_eth = qca8k_read_eth,
+	.write_eth = qca8k_write_eth,
 };
 
 static const struct qca8k_match_data qca8327 = {
diff --git a/drivers/net/dsa/qca/qca8k-common.c b/drivers/net/dsa/qca/qca8k-common.c
index 880a49de22b1..a47f876033ba 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -99,3 +99,42 @@ const struct regmap_access_table qca8k_readable_table = {
 	.yes_ranges = qca8k_readable_ranges,
 	.n_yes_ranges = ARRAY_SIZE(qca8k_readable_ranges),
 };
+
+/* TODO: remove these extra ops when we can support regmap bulk read/write */
+int qca8k_bulk_read(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
+{
+	int i, count = len / sizeof(u32), ret;
+
+	if (priv->mgmt_master && priv->info->ops->read_eth &&
+	    !priv->info->ops->read_eth(priv, reg, val, len))
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
+	u32 tmp;
+
+	if (priv->mgmt_master && priv->info->ops->write_eth &&
+	    !priv->info->ops->write_eth(priv, reg, val, len))
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
index c9b753743dfd..df32c1e3a797 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -324,8 +324,13 @@ enum qca8k_mid_cmd {
 	QCA8K_MIB_CAST = 3,
 };
 
+struct qca8k_priv;
+
 struct qca8k_info_ops {
 	int (*autocast_mib)(struct dsa_switch *ds, int port, u64 *data);
+	/* TODO: remove these extra ops when we can support regmap bulk read/write */
+	int (*read_eth)(struct qca8k_priv *priv, u32 reg, u32 *val, int len);
+	int (*write_eth)(struct qca8k_priv *priv, u32 reg, u32 *val, int len);
 };
 
 struct qca8k_match_data {
@@ -431,4 +436,7 @@ int qca8k_read(struct qca8k_priv *priv, u32 reg, u32 *val);
 int qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val);
 int qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val);
 
+int qca8k_bulk_read(struct qca8k_priv *priv, u32 reg, u32 *val, int len);
+int qca8k_bulk_write(struct qca8k_priv *priv, u32 reg, u32 *val, int len);
+
 #endif /* __QCA8K_H */
-- 
2.36.1

