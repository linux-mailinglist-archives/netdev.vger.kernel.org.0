Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0D45825A3
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 13:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232169AbiG0LgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 07:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232181AbiG0Lf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 07:35:57 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 728AB49B46;
        Wed, 27 Jul 2022 04:35:50 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id f15so12570552edc.4;
        Wed, 27 Jul 2022 04:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Nhy47t+Ixf4FIDV3Sewzv7cfv3cNDhiJs+SXUpAzHu4=;
        b=LFYpEaxqQRpDtYxpxD5V8uYIEXK/uve4mrM0+/30jQ8vmsOpW3SnkP+EBV6gGT9Lpk
         6SRX6/EuTEkk5dHl8+6aoUHDbCO2DX2EEbJrFj4Exmd0AXF8PKx0hrh2RjY3iD1K7KaS
         Yk1HTWJ9ZSkAbT8zyIKZgdGpgC8T/PLRfHSwewLhssSOLsoG8YnNZM6l8P+keA4QGdej
         ACXzHpBa62nXyErJ3AHMoq193r473tD2nPBRYBzUbE8ST+/hllPzLBybM6Dky6M44alk
         gQo/TQTWA/lRJ6Vm92QjW+y49JDxRT0ZZqdxWrU17tURwUXmQsKdUHSb9Qh01/xAuAVO
         VlVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Nhy47t+Ixf4FIDV3Sewzv7cfv3cNDhiJs+SXUpAzHu4=;
        b=aQtDcirrtMYpRHklEnFtt8Pro087PcC3TpgH8/u1qCHtLcy2Ti0PExrRfQC5IEVJiW
         ZEyJnIBldZFjf5h5hxC7Z8zAfsgjhBbYVcnFCkYmOdp0iswz8uxznsFdL5KawVqqvzKn
         XsRpOePHMm/Yh6Zic1xIpamsjfqfu0AcXsxInYXSGOz4O/AT0h/82kVxc8JNVqjT/j7W
         7i1RG6BTrutIUeb8vQ5nn30hWqaLBLazIGBLUa2x9zckkkAICFYtHJl5+cTZhcr+0NdT
         1LWnaShf6L9gBu2gtPLOtzKLoEtopCatZxzHzp9vNbZb4FwH0Pyi/Y9JxswuMcrm9+6D
         Wjfw==
X-Gm-Message-State: AJIora/+RhxOSx1iXhtk18D+H9K+nTG1HbWIQfPailPgw5qLQo78dUw+
        bvdyW6D8ILSAzpomqrxOafo=
X-Google-Smtp-Source: AGRyM1upLKbdSD1ue41SvjBYd/5ByPfXJEiDrwBTBqv5VMCWpBT3XWcmJR71MU/dTk6tydbWqUamYw==
X-Received: by 2002:a05:6402:3228:b0:43b:de2e:2fc0 with SMTP id g40-20020a056402322800b0043bde2e2fc0mr22019271eda.299.1658921748719;
        Wed, 27 Jul 2022 04:35:48 -0700 (PDT)
Received: from localhost.localdomain (c105-182.i13-27.melita.com. [94.17.105.182])
        by smtp.googlemail.com with ESMTPSA id p25-20020aa7cc99000000b0043ca6fb7e7dsm1334056edt.68.2022.07.27.04.35.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 04:35:48 -0700 (PDT)
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
Subject: [net-next PATCH v5 06/14] net: dsa: qca8k: move mib init function to common code
Date:   Wed, 27 Jul 2022 13:35:15 +0200
Message-Id: <20220727113523.19742-7-ansuelsmth@gmail.com>
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

The same mib function is used by drivers based on qca8k family switch.
Move it to common code to make it accessible also by other drivers.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c   | 37 ------------------------------
 drivers/net/dsa/qca/qca8k-common.c | 35 ++++++++++++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h        |  4 ++++
 3 files changed, 39 insertions(+), 37 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 8a5529844c7a..b4daa097a7fc 100644
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
index a47f876033ba..7da3547f9d97 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -138,3 +138,38 @@ int qca8k_bulk_write(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 
 	return 0;
 }
+
+int qca8k_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
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
index df32c1e3a797..f55ef97f826f 100644
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

