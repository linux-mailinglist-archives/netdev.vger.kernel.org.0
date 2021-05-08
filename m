Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1985A376DBA
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 02:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbhEHAao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 20:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbhEHAae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 20:30:34 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C71CC06138C;
        Fri,  7 May 2021 17:29:32 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id d11so10860746wrw.8;
        Fri, 07 May 2021 17:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=00Pu0epvTDq6aKqmx0t8XhDKxiRQECjav0p2CQIy/GA=;
        b=iIQrBmM1/iHiq8mGh0SqCxAAd8OH7aYCoIp9QlSH1YGbXsmlMPaA4nzq9uERZGoNwv
         jOdTRYf7Miyj+4ic4Lsf1ihaMEEov4dIUC+m8577NUY6oHrap3m8YBrwK3IecbzsJyDV
         84oL+6atB3szyEhlxtLvNs3EQ/ckWJ2gL7TanxgUIkIwPh5NOe4RKoOv0It1vnkLvikv
         dtQX3vUjxyRIVct/ZjOy/Kn7uNJ9kz6gFv7wvg/HO+Osw5giEEUchPMFh59VgHaHgcep
         zI6xElPfXn21ZRD5gz14boTauzH2BgnwIuS6ykv8Cwdisd4TrBcqsFcGo5wIKYL5sSQW
         UXHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=00Pu0epvTDq6aKqmx0t8XhDKxiRQECjav0p2CQIy/GA=;
        b=tTT+M3IZSqZNAl2nAVmID6x3EZ8LybWmMFIDlGNmpWmX2ex7JRVPSj1T640pjiXCm5
         FbSdoDClq2M0V+AuDEWroUglqqADEnbjhsTh1Ra2ACJOb8CB/tQBK+iX7UWpRNGsKGyY
         UprA2fe9ZvNrNTHynYvdyBtMsjw+gpI03NY+Or+mSSS6T3+q3AdKVXiljrOGtmWgezxG
         JFWmFAQO/5m7WP4Xs1d7pQBWF0EGmQqPgS8x97v1hOYA6Y+don95Df7L9USFbBeRNKFR
         Hr+k61bgwRdCKp6u+pJh0Fe6Nm+IkgcQumz9YaDCjWxGr+Xml9vbdcx6rQiVa/4maMQ9
         Jz1A==
X-Gm-Message-State: AOAM533SSmCDfiLvQzt4k8y+zXJ7ZA04rIzxn+28TW0MbZFvkIWCD3Rt
        wR1pvgkVTfTbVS8dBBEeSWHss2WUyf2VVg==
X-Google-Smtp-Source: ABdhPJzXxF49KrnOJGye3mSXXc6pRLFzOcWLoqNDojTuI7k1VsftXvWQwoaZyIbERyQ+CbGO6qE/Rg==
X-Received: by 2002:a5d:6e0d:: with SMTP id h13mr16056309wrz.118.1620433771292;
        Fri, 07 May 2021 17:29:31 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id f4sm10967597wrz.33.2021.05.07.17.29.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 17:29:30 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v4 12/28] net: dsa: qca8k: add support for qca8327 switch
Date:   Sat,  8 May 2021 02:29:02 +0200
Message-Id: <20210508002920.19945-12-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210508002920.19945-1-ansuelsmth@gmail.com>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qca8327 switch is a low tier version of the more recent qca8337.
It does share the same regs used by the qca8k driver and can be
supported with minimal change.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/qca8k.c | 23 ++++++++++++++++++++---
 drivers/net/dsa/qca8k.h |  6 ++++++
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 6c65c6013c5f..9c2f09e84364 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1536,6 +1536,7 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 static int
 qca8k_sw_probe(struct mdio_device *mdiodev)
 {
+	const struct qca8k_match_data *data;
 	struct qca8k_priv *priv;
 	u32 id;
 
@@ -1563,6 +1564,11 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 		gpiod_set_value_cansleep(priv->reset_gpio, 0);
 	}
 
+	/* get the switches ID from the compatible */
+	data = of_device_get_match_data(&mdiodev->dev);
+	if (!data)
+		return -ENODEV;
+
 	/* read the switches ID register */
 	id = qca8k_read(priv, QCA8K_REG_MASK_CTRL);
 	if (id < 0)
@@ -1570,8 +1576,10 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 
 	id >>= QCA8K_MASK_CTRL_ID_S;
 	id &= QCA8K_MASK_CTRL_ID_M;
-	if (id != QCA8K_ID_QCA8337)
+	if (id != data->id) {
+		dev_err(&mdiodev->dev, "Switch id detected %x but expected %x", id, data->id);
 		return -ENODEV;
+	}
 
 	priv->ds = devm_kzalloc(&mdiodev->dev, sizeof(*priv->ds), GFP_KERNEL);
 	if (!priv->ds)
@@ -1636,9 +1644,18 @@ static int qca8k_resume(struct device *dev)
 static SIMPLE_DEV_PM_OPS(qca8k_pm_ops,
 			 qca8k_suspend, qca8k_resume);
 
+static const struct qca8k_match_data qca832x = {
+	.id = QCA8K_ID_QCA8327,
+};
+
+static const struct qca8k_match_data qca833x = {
+	.id = QCA8K_ID_QCA8337,
+};
+
 static const struct of_device_id qca8k_of_match[] = {
-	{ .compatible = "qca,qca8334" },
-	{ .compatible = "qca,qca8337" },
+	{ .compatible = "qca,qca8327", .data = &qca832x },
+	{ .compatible = "qca,qca8334", .data = &qca833x },
+	{ .compatible = "qca,qca8337", .data = &qca833x },
 	{ /* sentinel */ },
 };
 
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 86c585b7ec4a..87a8b10459c6 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -15,6 +15,8 @@
 #define QCA8K_NUM_PORTS					7
 #define QCA8K_MAX_MTU					9000
 
+#define PHY_ID_QCA8327					0x004dd034
+#define QCA8K_ID_QCA8327				0x12
 #define PHY_ID_QCA8337					0x004dd036
 #define QCA8K_ID_QCA8337				0x13
 
@@ -213,6 +215,10 @@ struct ar8xxx_port_status {
 	int enabled;
 };
 
+struct qca8k_match_data {
+	u8 id;
+};
+
 struct qca8k_priv {
 	struct regmap *regmap;
 	struct mii_bus *bus;
-- 
2.30.2

