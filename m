Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0A857EF87
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 16:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237662AbiGWOTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 10:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237565AbiGWOTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 10:19:47 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12501C92D;
        Sat, 23 Jul 2022 07:19:39 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id g2so1952496wru.3;
        Sat, 23 Jul 2022 07:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=aqZfkvVLvMIA3dqtnUAW9Usx7gBB+ctiZLTPg+eY5hM=;
        b=lKQxlpqy9vhyyBHI9Sb5hp11yQocsqYfJKl/q5Ldi+lY9GtNMRYlUw8ICKIxlj6J/y
         DJR7dN3PzbpD7oobk/xC0/OmeBFR0I1Cv0OVI5uLTNihXzjr5nJblS5/ucURlyjIFy4V
         pnGnARjIrC+Aalq/qUgzhK+N5L7REdxz/+84pa0Ij10W1CbAqeK36vqdFZZUxXM+50fT
         o8dG5STD8Az46LFFG1jdoLPLsZMFMRJHbsGsV1LQpiLkjBLUM4Tov9RYmi0cQ/K0Z7Ss
         WMTZIVehVdBr/ouxGliUGbYMlYjN5Tje4q16sMYtQqWrOxvzmtoXphCBZDvGHdsWxVBv
         QmBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aqZfkvVLvMIA3dqtnUAW9Usx7gBB+ctiZLTPg+eY5hM=;
        b=MytFLtP+sWI/Vb7o/ck3h1c+LzaXxpURl5u/bWA3UqtpM30SZaHC6Vdcy+5M/NYeeW
         mpK0N3Og+NAl4wBEruHua4mA5S0h+e0M7lEpLxfpFPgVjMI39h77Pgk2x2RfICxcr4nR
         1unmgJ5/iBQ0cLJWugoJtgpMaULH5Y/jYJHesxuMK/s9l+pIUVt0M0CFCdVRVwxQt+Bc
         6KRikKXos7xo+Ap0bUf/3Vh67f9FpFytAanAoXsS3PhWi2PisWf0sCA8V7alXL34gk55
         nHFx8G+Cc3xmkSWtJpUoRRFrF524zUwJ50vKvKXdkJTOEVcoHb9GRTlJ2K2oMrWFoJUF
         tzfA==
X-Gm-Message-State: AJIora/kngWB5nHdL8bdck7pnjeNFjIvG8ErxduUIsM+6wqysIrfaA7u
        3eOmlc9SqfNoDvdihrK9xzY=
X-Google-Smtp-Source: AGRyM1tDXgxw6jmA7/Co2gLw1LTmSV5mFluJgyrNEExDEcVPsQudnuEcgQLFfhz92JB/I1i+6J/Vnw==
X-Received: by 2002:a5d:4811:0:b0:21e:3d86:a2df with SMTP id l17-20020a5d4811000000b0021e3d86a2dfmr3012332wrq.633.1658585978118;
        Sat, 23 Jul 2022 07:19:38 -0700 (PDT)
Received: from localhost.localdomain (host-87-7-207-127.retail.telecomitalia.it. [87.7.207.127])
        by smtp.googlemail.com with ESMTPSA id l18-20020a05600c1d1200b003a04d19dab3sm21011960wms.3.2022.07.23.07.19.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jul 2022 07:19:37 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [net-next PATCH v3 05/14] net: dsa: qca8k: move qca8k bulk read/write helper to common code
Date:   Sat, 23 Jul 2022 16:18:36 +0200
Message-Id: <20220723141845.10570-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220723141845.10570-1-ansuelsmth@gmail.com>
References: <20220723141845.10570-1-ansuelsmth@gmail.com>
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
 drivers/net/dsa/qca/qca8k-8xxx.c   | 39 ++----------------------------
 drivers/net/dsa/qca/qca8k-common.c | 39 ++++++++++++++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h        |  8 ++++++
 3 files changed, 49 insertions(+), 37 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index dbeea807de2f..938cea84b017 100644
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
@@ -3157,6 +3120,8 @@ static SIMPLE_DEV_PM_OPS(qca8k_pm_ops,
 
 static const struct qca8k_info_ops qca8xxx_ops = {
 	.autocast_mib = qca8k_get_ethtool_stats_eth,
+	.read_eth = qca8k_read_eth,
+	.write_eth = qca8k_write_eth,
 };
 
 static const struct qca8k_match_data qca8327 = {
diff --git a/drivers/net/dsa/qca/qca8k-common.c b/drivers/net/dsa/qca/qca8k-common.c
index 880a49de22b1..2f96f1d4b921 100644
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
+	if (priv->mgmt_master && priv->info->ops.read_eth &&
+	    !priv->info->ops.read_eth(priv, reg, val, len))
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
+	if (priv->mgmt_master && priv->info->ops.write_eth &&
+	    !priv->info->ops.write_eth(priv, reg, val, len))
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
index 73ffef9f3cc2..b9728daab5c7 100644
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

