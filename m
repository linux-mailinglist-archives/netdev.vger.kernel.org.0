Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05FBC57F77B
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 00:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232680AbiGXWvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 18:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232311AbiGXWvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 18:51:18 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E226DF70;
        Sun, 24 Jul 2022 15:51:13 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id tk8so17496923ejc.7;
        Sun, 24 Jul 2022 15:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Z5shPpFQpaw0JAErr3t9PC2pRp3TSNJWCLBkEhxNhg0=;
        b=ml20RaSCOolR7j2HpYa37jlzXpVdRkcHmHgetEom1PWUH5DtkK885T5jXaUdfupH6R
         XwZfQT6PKkXat6bbR/wUC9v6eUyhfbnfVTGNY33n+akRutNQm6q2BWkZnwkkBJOlnAc6
         mDdPh/U+VEG5t7mRVB7llOYq2VOfayb0lFLA9+GXBiOtunnzvjjUZjV/jRhXYYVwqmCL
         pfZnc1uxW+GmKUVyiTKizL27Ut0z+M8WJwYL/XwlfNv9Tm6k8WYwGJZVA/gKtKnduER7
         IaANz12cXbiiWRccGp6a9JdqDgz2qwkorcrXVWsvnQ3oU5FtP2zQDVphTpQSFPvmVEgN
         W9QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z5shPpFQpaw0JAErr3t9PC2pRp3TSNJWCLBkEhxNhg0=;
        b=J95Sz9+NVm3PjFj+YugMk/e5d20pZzqWIX/Osx0Ktks1uOPlvpHST1R89qokdHsfAj
         NJF3FcQCR6wRu4P5jE0jh2+Pw+fyHDlclZH27d+hSdBc9AWq3QbGDnAzJxSzivcXCJul
         627/r4bRgkqHm1s0zLo+f7OPG25JwNdNsMmptyKy5t85e4izMVreoMMo06gC3DoXl1jw
         RBXkF6+L1qqh7In6yV5rsE+yw9QmaRRqHBB4I5ghzLy9xNQoHkdvihywsTFqJ4P/9tma
         ca22wmgM2uPaoCsnMdYbCrPkPvG8P2Pw2WcEsOI7T6kILGZdegN4xUuZKEI3JZa7MdLn
         VGvQ==
X-Gm-Message-State: AJIora+0dD23YDf3kL+0bl/FleaxVrwqv3VOdJB25ax7ERMyxSuGREmN
        9bHF7bF7z7PcifFUWjUz8aY=
X-Google-Smtp-Source: AGRyM1tV23ozm4RwR0UKLjwVaTxXXfNF2jQK3neEiT3yQqb/pbXNk6ehJD4CVoKkHhF8Q56BIz+yJA==
X-Received: by 2002:a17:907:1c19:b0:72f:cc9e:3a7 with SMTP id nc25-20020a1709071c1900b0072fcc9e03a7mr4216220ejc.631.1658703071514;
        Sun, 24 Jul 2022 15:51:11 -0700 (PDT)
Received: from localhost.localdomain (93-42-69-122.ip85.fastwebnet.it. [93.42.69.122])
        by smtp.googlemail.com with ESMTPSA id nc19-20020a1709071c1300b00722d5b26ecesm4645238ejc.205.2022.07.24.15.51.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jul 2022 15:51:11 -0700 (PDT)
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
Subject: [net-next PATCH v4 06/14] net: dsa: qca8k: move mib init function to common code
Date:   Sun, 24 Jul 2022 22:19:30 +0200
Message-Id: <20220724201938.17387-7-ansuelsmth@gmail.com>
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

The same mib function is used by drivers based on qca8k family switch.
Move it to common code to make it accessible also by other drivers.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c   | 37 ------------------------------
 drivers/net/dsa/qca/qca8k-common.c | 36 +++++++++++++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h        |  4 ++++
 3 files changed, 40 insertions(+), 37 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 3dd63d64d7ae..b62cedeafaac 100644
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
index a47f876033ba..494dd6a14e9b 100644
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

