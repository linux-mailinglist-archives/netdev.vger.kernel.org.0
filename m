Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23760578FAC
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 03:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236820AbiGSBQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 21:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236777AbiGSBPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 21:15:30 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43BFE11477;
        Mon, 18 Jul 2022 18:15:26 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 8-20020a05600c024800b003a2fe343db1so8306807wmj.1;
        Mon, 18 Jul 2022 18:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=8G1gV/gzxaHMDRK7aJlJucvvTI2PI04WcYqOqBHF4nI=;
        b=XgY5kUmqo+xGaSGDdiI6QrqjrzdpSkH7BcX4EEGFBzzvG9Iyyo/DNMg6bXhwX7L50U
         gx8Kc0judsDS/PuGpQFkkFcBsQ0SrXP7hPJSSnp2EPnPcRrq+HBNGhOT0G+snz2YJ0c0
         VKSfOEDgvyCRo+j7S+iJJTGKBXdB2PcMY+1I2IOT5PJBlbACO+u2id6p5CNxnVeWpj8e
         Mm05Af7HHyQ4wUZoQPeU1ongVxNxMJgol75Qqx5qZH4jGyOG55GD88h2a1bXTelHe/Gp
         W1dnxk7rw96erKTeIkGJrIfAlW7D572rW1mKELcJxYLccNpcNlYS4bJDLWFcBnIyYimN
         3EzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8G1gV/gzxaHMDRK7aJlJucvvTI2PI04WcYqOqBHF4nI=;
        b=7XzYopW6iD2H8tf3ltvhpOp8OM9J0JV272YC8iLKZnt2vnByCBADHp8/3uwU23xWay
         /k6m4ipu9z+Z98yAxk5pJhYa3ZrBcuOPxaj7YcR1hVjH3bSSQ7QKQ2gDwZgFJxU9U+cu
         3KRnEG4t45rrUsJpi0eQEE/u2R2zuybzenN+mRICVVNibrb7YIlhsK3xnSqDgJ/bfBVY
         w9qCiPNH/cNZxIrhfBZacqhsscbmrb0d1P5X/1CUjST2XZCrGzQbJ6dyRjFB1sbbqQ44
         pA1oiNFYRGja+1j36g0PCveb5b8olcCdxSFI0JGCrICHRYrRV6QGVtHRmVFSYbs0AGL+
         4gUA==
X-Gm-Message-State: AJIora+/Knd29MtRleSIOFGXwvLBaVSGo+CLdTXmwC595UYiuCa1Qcu+
        aMF1Ts4WD6ShtdvqESpAh98=
X-Google-Smtp-Source: AGRyM1sPmbrtWEmfexCGNibhTIUq+zIG0+5ee/DPtHOB7q/KEbrStuMNWC7GjQml3Ct0bJ8JrWCpYw==
X-Received: by 2002:a7b:c450:0:b0:3a3:2121:c690 with SMTP id l16-20020a7bc450000000b003a32121c690mr2546937wmi.99.1658193324669;
        Mon, 18 Jul 2022 18:15:24 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id y11-20020adff14b000000b0021db7b0162esm11840239wro.105.2022.07.18.18.15.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 18:15:24 -0700 (PDT)
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
Subject: [net-next PATCH v2 14/15] net: dsa: qca8k: move read_switch_id function to common code
Date:   Tue, 19 Jul 2022 02:57:25 +0200
Message-Id: <20220719005726.8739-16-ansuelsmth@gmail.com>
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

The same function to read the switch id is used by drivers based on
qca8k family switch. Move them to common code to make them accessible
also by other drivers.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca/qca8k-8xxx.c   | 30 ------------------------------
 drivers/net/dsa/qca/qca8k-common.c | 30 ++++++++++++++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h        |  1 +
 3 files changed, 31 insertions(+), 30 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index dfd5cd0817f9..e8b9482cef8a 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -1881,36 +1881,6 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.connect_tag_protocol	= qca8k_connect_tag_protocol,
 };
 
-static int qca8k_read_switch_id(struct qca8k_priv *priv)
-{
-	const struct qca8k_match_data *data;
-	u32 val;
-	u8 id;
-	int ret;
-
-	/* get the switches ID from the compatible */
-	data = of_device_get_match_data(priv->dev);
-	if (!data)
-		return -ENODEV;
-
-	ret = qca8k_read(priv, QCA8K_REG_MASK_CTRL, &val);
-	if (ret < 0)
-		return -ENODEV;
-
-	id = QCA8K_MASK_CTRL_DEVICE_ID(val);
-	if (id != data->id) {
-		dev_err(priv->dev, "Switch id detected %x but expected %x", id, data->id);
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
index f8a3b08a6257..6e6cdb173556 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -1224,3 +1224,33 @@ qca8k_port_lag_leave(struct dsa_switch *ds, int port,
 {
 	return qca8k_lag_refresh_portmap(ds, port, lag, true);
 }
+
+int qca8k_read_switch_id(struct qca8k_priv *priv)
+{
+	const struct qca8k_match_data *data;
+	u32 val;
+	u8 id;
+	int ret;
+
+	/* get the switches ID from the compatible */
+	data = of_device_get_match_data(priv->dev);
+	if (!data)
+		return -ENODEV;
+
+	ret = qca8k_read(priv, QCA8K_REG_MASK_CTRL, &val);
+	if (ret < 0)
+		return -ENODEV;
+
+	id = QCA8K_MASK_CTRL_DEVICE_ID(val);
+	if (id != data->id) {
+		dev_err(priv->dev, "Switch id detected %x but expected %x", id, data->id);
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
index 3ee069cb4fd2..b74b9012462b 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -427,6 +427,7 @@ extern const struct qca8k_mib_desc ar8327_mib[];
 extern const struct regmap_access_table qca8k_readable_table;
 int qca8k_mib_init(struct qca8k_priv *priv);
 void qca8k_port_set_status(struct qca8k_priv *priv, int port, int enable);
+int qca8k_read_switch_id(struct qca8k_priv *priv);
 
 /* Common read/write/rmw function */
 int qca8k_read(struct qca8k_priv *priv, u32 reg, u32 *val);
-- 
2.36.1

