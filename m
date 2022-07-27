Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5772C5825B6
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 13:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbiG0LhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 07:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232390AbiG0Lgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 07:36:39 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 103244AD56;
        Wed, 27 Jul 2022 04:36:01 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id va17so31026803ejb.0;
        Wed, 27 Jul 2022 04:36:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=VQSHx8GgcQmMd+AXBHE02GOQHiSvUP8WAJUnL9ocUio=;
        b=mhk1h2uJZTlyGcOzrIpB2D5oT+iA5R8TkMmRYlcsXA6caVLNYJq7G+ZoJWUJA+C0Jo
         N91TkTPT6I2nm3v7JISL7BsrQS992myNakALbwb53lYzx0emlf7CDtAcBt07ZUUfOyNl
         SxX6Xn5z/CUlaRFb9VMbwtERgUYKT/N5HjzQpaSD7C9MlxcDebZepb4mdkJxVTmMjldz
         ovgWe2/vaCzUHLnnSheoFbF0dHwgcT8ODTWI5TG20gDc2p9xG5royM4RFsIMqC9ckFeh
         zil5vh5Oh/OoU4rFO2jWWuQcdEH4eEwyqGksCnm30iskVz/njWA58Q4bQ7H3U876yz3w
         clYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VQSHx8GgcQmMd+AXBHE02GOQHiSvUP8WAJUnL9ocUio=;
        b=5tZlMiqqWC67aDqYQRno7izNgS2AQMUXpxmLLWnJmJzVpLjYykOqMBPHuJgEcTSrxG
         PJf+S0ax0sH+jmj5NaKJp/Gb/OPFVKSlqJvAAU4PX+nnKEMr8QIDek7MQ2G2aEH/qutK
         GaG2nM/1bYf1Bu/9DRyezlthtNxPYyEBV8CxCM9AukoaGAlCTEsrT750J0F7OQOAzaLa
         Ew+XAxZeu9IAv0UxG3xmNEPA3EfX8Jiwr5hPwTLknZLBEAQQRC5Nqt2BgXWHZ2IU9Z3R
         U95NLCFL+fBoHO8wxqxuQmZEMKbiksB/zs9P1EdWCB+NpqqF4afZhDYnx3E6+I+p9iwo
         P2rw==
X-Gm-Message-State: AJIora9UIhgYA2w0PWao419i9vgUh56cMAlrVziE2Ez3RLI+Mzs3hg9V
        WKnvGnDoTChHluYfpY1W460=
X-Google-Smtp-Source: AGRyM1uUycM1SKpDmZ+nnw7DJYgP8fA+MsFQMpzc+KtJIYKSaIiSvpsXa4+ky7jTZxMRpyaav9a64g==
X-Received: by 2002:a17:907:6295:b0:703:92b8:e113 with SMTP id nd21-20020a170907629500b0070392b8e113mr17629609ejc.594.1658921761353;
        Wed, 27 Jul 2022 04:36:01 -0700 (PDT)
Received: from localhost.localdomain (c105-182.i13-27.melita.com. [94.17.105.182])
        by smtp.googlemail.com with ESMTPSA id p25-20020aa7cc99000000b0043ca6fb7e7dsm1334056edt.68.2022.07.27.04.35.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 04:36:00 -0700 (PDT)
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
Subject: [net-next PATCH v5 14/14] net: dsa: qca8k: move read_switch_id function to common code
Date:   Wed, 27 Jul 2022 13:35:23 +0200
Message-Id: <20220727113523.19742-15-ansuelsmth@gmail.com>
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

The same function to read the switch id is used by drivers based on
qca8k family switch. Move them to common code to make them accessible
also by other drivers.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c   | 29 -----------------------------
 drivers/net/dsa/qca/qca8k-common.c | 29 +++++++++++++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h        |  1 +
 3 files changed, 30 insertions(+), 29 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 4d6ea47a4469..1d3e7782a71f 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -1876,35 +1876,6 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.connect_tag_protocol	= qca8k_connect_tag_protocol,
 };
 
-static int qca8k_read_switch_id(struct qca8k_priv *priv)
-{
-	u32 val;
-	u8 id;
-	int ret;
-
-	if (!priv->info)
-		return -ENODEV;
-
-	ret = qca8k_read(priv, QCA8K_REG_MASK_CTRL, &val);
-	if (ret < 0)
-		return -ENODEV;
-
-	id = QCA8K_MASK_CTRL_DEVICE_ID(val);
-	if (id != priv->info->id) {
-		dev_err(priv->dev,
-			"Switch id detected %x but expected %x",
-			id, priv->info->id);
-		return -ENODEV;
-	}
-
-	priv->switch_id = id;
-
-	/* Save revision to communicate to the internal PHY driver */
-	priv->switch_revision = QCA8K_MASK_CTRL_REV_ID(val);
-
-	return 0;
-}
-
 static int
 qca8k_sw_probe(struct mdio_device *mdiodev)
 {
diff --git a/drivers/net/dsa/qca/qca8k-common.c b/drivers/net/dsa/qca/qca8k-common.c
index c881a95441dd..bba95613e218 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -1179,3 +1179,32 @@ int qca8k_port_lag_leave(struct dsa_switch *ds, int port,
 {
 	return qca8k_lag_refresh_portmap(ds, port, lag, true);
 }
+
+int qca8k_read_switch_id(struct qca8k_priv *priv)
+{
+	u32 val;
+	u8 id;
+	int ret;
+
+	if (!priv->info)
+		return -ENODEV;
+
+	ret = qca8k_read(priv, QCA8K_REG_MASK_CTRL, &val);
+	if (ret < 0)
+		return -ENODEV;
+
+	id = QCA8K_MASK_CTRL_DEVICE_ID(val);
+	if (id != priv->info->id) {
+		dev_err(priv->dev,
+			"Switch id detected %x but expected %x",
+			id, priv->info->id);
+		return -ENODEV;
+	}
+
+	priv->switch_id = id;
+
+	/* Save revision to communicate to the internal PHY driver */
+	priv->switch_revision = QCA8K_MASK_CTRL_REV_ID(val);
+
+	return 0;
+}
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index e87bfee837c1..e36ecc9777f4 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -432,6 +432,7 @@ extern const struct qca8k_mib_desc ar8327_mib[];
 extern const struct regmap_access_table qca8k_readable_table;
 int qca8k_mib_init(struct qca8k_priv *priv);
 void qca8k_port_set_status(struct qca8k_priv *priv, int port, int enable);
+int qca8k_read_switch_id(struct qca8k_priv *priv);
 
 /* Common read/write/rmw function */
 int qca8k_read(struct qca8k_priv *priv, u32 reg, u32 *val);
-- 
2.36.1

