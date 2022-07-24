Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9407557F780
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 00:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232621AbiGXWvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 18:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232250AbiGXWvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 18:51:18 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D995DDEE8;
        Sun, 24 Jul 2022 15:51:11 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id mf4so17570772ejc.3;
        Sun, 24 Jul 2022 15:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=gnyNvEtHjjxIBgqLo0nybyWglPigyDh/LC8Trnw7VUg=;
        b=b9rdVYOc87rqsRhY6jsdTJPGqEIWoM0Yp4wxxcTqrZzi6sCulwMVN3WvMe2EQHG/l+
         KyS6PXmYDvesGglJnumJVDhvm35SXYN52sKBsRoXwqQbI9H3AiuElHk2ubVV6iZe9RNV
         VljMJKkGXtANkIru7F/s1wk9/73RbsIsvKKYJLoJm2mvjT7LWt8oXDMuVroZOgQOJEIN
         LfOMtVRRCA8gRMKvcZH5ipdU123yyp/AMvhnKYV2XhbTkxLfkbBRCgsk2MrxukzI1VbA
         8b+n4CLi+1y7pr01x/5K5QMPXogRTMzYl9zmNUSZ7G8cPhZqb/Dz1V3sUN5tTUazZ0Av
         dG/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gnyNvEtHjjxIBgqLo0nybyWglPigyDh/LC8Trnw7VUg=;
        b=NsD21WfRK+3sUNtHAosvDIRlGyd4ci7qbLdHy5vmNgtSuwmdijfLtLkretMG9JZqVW
         dz6WuDEwYvuhDGsDUKK2Mb6lfUOaNZF/ZE3rs3xHkgIU+fmafX2QJi7tdUmzWx5sCHw7
         lQhI9eSQGIImrs4efNJpeWdB0+RbJUpheu70nssN8Fn1s0gLJw3/6oOHvTnc3W9+5qad
         70CnJhhd4YBbfjg/u5jdWbZltwLZkgNHRuB1CTx0nDr0wNrLuOWfJkOzPtJwKYyEbjR1
         oGhhC7A6r0Sfh3gRoAXm4EokGVLZrLzb6mjy9un0bwjPKhysT12pQue/XAm/72qxfGKU
         sLdw==
X-Gm-Message-State: AJIora8VFnP6sQMrHtWBWzxWsek8fCPa45t5XrdTlz+a7boBYhgQyPQa
        JshetW2iYoEbMTaSftyAWhg=
X-Google-Smtp-Source: AGRyM1uRjlt4pKrn6f2qWSLTXC8pVpznwkSuo1T/qZ8ZnKoCZmieOohzk3u40AzTLBIpuJn674GZdA==
X-Received: by 2002:a17:907:6089:b0:72f:56db:ccb6 with SMTP id ht9-20020a170907608900b0072f56dbccb6mr7731860ejc.318.1658703070316;
        Sun, 24 Jul 2022 15:51:10 -0700 (PDT)
Received: from localhost.localdomain (93-42-69-122.ip85.fastwebnet.it. [93.42.69.122])
        by smtp.googlemail.com with ESMTPSA id nc19-20020a1709071c1300b00722d5b26ecesm4645238ejc.205.2022.07.24.15.51.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jul 2022 15:51:09 -0700 (PDT)
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
Subject: [net-next PATCH v4 05/14] net: dsa: qca8k: move qca8k bulk read/write helper to common code
Date:   Sun, 24 Jul 2022 22:19:29 +0200
Message-Id: <20220724201938.17387-6-ansuelsmth@gmail.com>
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
index bc9b490f8073..3dd63d64d7ae 100644
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

