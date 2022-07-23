Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30AD757EF89
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 16:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237696AbiGWOUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 10:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237514AbiGWOTs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 10:19:48 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D90B1CB04;
        Sat, 23 Jul 2022 07:19:43 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id id17so4284438wmb.1;
        Sat, 23 Jul 2022 07:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=wSXp92J6F5XOkARNbouFIvz3l6vsc1zwyqVGfhHJvvo=;
        b=kj7a1+khUCZ6UtMswFZP2nuAQve9l6g2lYzYTSUoEQud+8qqcOYO6F8bvnOdirkbyU
         tPCtF/0xXJCMmRrt887bJcKQ8feOfVKwp1qj0Y/Oe6CZ2jsATP0v4dbt2PUEctpnPJ7K
         y3GqWecZqoTjRQtwJj3SWPIehhA90hGsh7RKVduDx1W64zGRHuhU8grtqvwxyEIXfSB/
         r2YbEsNA6h0+ox5GbLqoAX/U0r5yqPubv8zIH1QtO6gZ3923Yy23tu6y76QOB6rv9gmU
         wWgyzqDREc0a+s3RFE293rHn354j2scmfxpAh1F/txZp+EqDGfwhL4/ywkzPRSILnbLv
         UpnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wSXp92J6F5XOkARNbouFIvz3l6vsc1zwyqVGfhHJvvo=;
        b=kAIjIwMgsss0ioolN7LgIHozqeBWcNJzOnDFK643rVw/tXGWADKmDh8tCoXVS6UI+3
         YwqcKEp2rUvF5l340YvwuqDSWL1y4p2Qr2Wk1Dx2GBTWrTpEI6945rapX0SeeNzhGHTV
         1WE0Q1fwfhXsLVTUEvB8sRH2DBZseA/gXgKxFzG6VSttcDuiK0MGQFY1zJC+z+KF+ZLT
         a/UiBOlUZMWyD8T9LIHi3lrs+wHButqYQ+faLJX7BCYffnozTqKvPhCotFvMjKttbFRn
         UdoGBK4IH4GmaoKbBiaR2889EmafUx7CGhwgo/Npq/oYwtlKjTza9z6SoldWVKHQaIUU
         LWtQ==
X-Gm-Message-State: AJIora8X25BgL73IhPHo+T2qe/87c52YdHHaE8fqz6HcKRjpmPn7nVky
        ha8TiFXOroLSjGe0uykHCo0=
X-Google-Smtp-Source: AGRyM1uBTCkkNk2Ajv3nEAeGfNR1Sq28Zb/7Y6ETYvivLA1wYEoNvNn83WiUjn0NE6AIQaYOcQohuQ==
X-Received: by 2002:a05:600c:4110:b0:3a3:33cd:3984 with SMTP id j16-20020a05600c411000b003a333cd3984mr3070475wmi.128.1658585981745;
        Sat, 23 Jul 2022 07:19:41 -0700 (PDT)
Received: from localhost.localdomain (host-87-7-207-127.retail.telecomitalia.it. [87.7.207.127])
        by smtp.googlemail.com with ESMTPSA id l18-20020a05600c1d1200b003a04d19dab3sm21011960wms.3.2022.07.23.07.19.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jul 2022 07:19:41 -0700 (PDT)
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
Subject: [net-next PATCH v3 06/14] net: dsa: qca8k: move mib init function to common code
Date:   Sat, 23 Jul 2022 16:18:37 +0200
Message-Id: <20220723141845.10570-7-ansuelsmth@gmail.com>
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

The same mib function is used by drivers based on qca8k family switch.
Move it to common code to make it accessible also by other drivers.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c   | 37 ------------------------------
 drivers/net/dsa/qca/qca8k-common.c | 36 +++++++++++++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h        |  4 ++++
 3 files changed, 40 insertions(+), 37 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 938cea84b017..3bd0c52f049e 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -441,15 +441,6 @@ static struct regmap_config qca8k_regmap_config = {
 	.cache_type = REGCACHE_NONE, /* Explicitly disable CACHE */
 };
 
-static int
-qca8k_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
-{
-	u32 val;
-
-	return regmap_read_poll_timeout(priv->regmap, reg, val, !(val & mask), 0,
-				       QCA8K_BUSY_WAIT_TIMEOUT * USEC_PER_MSEC);
-}
-
 static int
 qca8k_fdb_read(struct qca8k_priv *priv, struct qca8k_fdb *fdb)
 {
@@ -777,34 +768,6 @@ qca8k_vlan_del(struct qca8k_priv *priv, u8 port, u16 vid)
 	return ret;
 }
 
-static int
-qca8k_mib_init(struct qca8k_priv *priv)
-{
-	int ret;
-
-	mutex_lock(&priv->reg_mutex);
-	ret = regmap_update_bits(priv->regmap, QCA8K_REG_MIB,
-				 QCA8K_MIB_FUNC | QCA8K_MIB_BUSY,
-				 FIELD_PREP(QCA8K_MIB_FUNC, QCA8K_MIB_FLUSH) |
-				 QCA8K_MIB_BUSY);
-	if (ret)
-		goto exit;
-
-	ret = qca8k_busy_wait(priv, QCA8K_REG_MIB, QCA8K_MIB_BUSY);
-	if (ret)
-		goto exit;
-
-	ret = regmap_set_bits(priv->regmap, QCA8K_REG_MIB, QCA8K_MIB_CPU_KEEP);
-	if (ret)
-		goto exit;
-
-	ret = qca8k_write(priv, QCA8K_REG_MODULE_EN, QCA8K_MODULE_EN_MIB);
-
-exit:
-	mutex_unlock(&priv->reg_mutex);
-	return ret;
-}
-
 static void
 qca8k_port_set_status(struct qca8k_priv *priv, int port, int enable)
 {
diff --git a/drivers/net/dsa/qca/qca8k-common.c b/drivers/net/dsa/qca/qca8k-common.c
index 2f96f1d4b921..9e9e3f0b7179 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -138,3 +138,39 @@ int qca8k_bulk_write(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 
 	return 0;
 }
+
+int
+qca8k_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
+{
+	u32 val;
+
+	return regmap_read_poll_timeout(priv->regmap, reg, val, !(val & mask), 0,
+				       QCA8K_BUSY_WAIT_TIMEOUT * USEC_PER_MSEC);
+}
+
+int qca8k_mib_init(struct qca8k_priv *priv)
+{
+	int ret;
+
+	mutex_lock(&priv->reg_mutex);
+	ret = regmap_update_bits(priv->regmap, QCA8K_REG_MIB,
+				 QCA8K_MIB_FUNC | QCA8K_MIB_BUSY,
+				 FIELD_PREP(QCA8K_MIB_FUNC, QCA8K_MIB_FLUSH) |
+				 QCA8K_MIB_BUSY);
+	if (ret)
+		goto exit;
+
+	ret = qca8k_busy_wait(priv, QCA8K_REG_MIB, QCA8K_MIB_BUSY);
+	if (ret)
+		goto exit;
+
+	ret = regmap_set_bits(priv->regmap, QCA8K_REG_MIB, QCA8K_MIB_CPU_KEEP);
+	if (ret)
+		goto exit;
+
+	ret = qca8k_write(priv, QCA8K_REG_MODULE_EN, QCA8K_MODULE_EN_MIB);
+
+exit:
+	mutex_unlock(&priv->reg_mutex);
+	return ret;
+}
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index b9728daab5c7..606a4c76c4b3 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -430,6 +430,7 @@ struct qca8k_fdb {
 /* Common setup function */
 extern const struct qca8k_mib_desc ar8327_mib[];
 extern const struct regmap_access_table qca8k_readable_table;
+int qca8k_mib_init(struct qca8k_priv *priv);
 
 /* Common read/write/rmw function */
 int qca8k_read(struct qca8k_priv *priv, u32 reg, u32 *val);
@@ -439,4 +440,7 @@ int qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val);
 int qca8k_bulk_read(struct qca8k_priv *priv, u32 reg, u32 *val, int len);
 int qca8k_bulk_write(struct qca8k_priv *priv, u32 reg, u32 *val, int len);
 
+/* Common ops function */
+int qca8k_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask);
+
 #endif /* __QCA8K_H */
-- 
2.36.1

