Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97202427E5D
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 03:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbhJJB67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 21:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbhJJB6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 21:58:22 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E813C06176D;
        Sat,  9 Oct 2021 18:56:22 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id d3so24498511edp.3;
        Sat, 09 Oct 2021 18:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eZKKTWkNvu/0F33tX/g7gmdT/XzT4msMSsmAHd15+ag=;
        b=evrfuX50MFm+n4AMfXOT4lAzI6KQ7WUKnotf6MSaoQtXWZTKMK+arpo5+xwgtjeArO
         BvtPWq+F5b/P6Kbksef6UmmNKNWNHvpeV+eJ976I6FbFVkGqFd9Wkvu51JTjSxEVizk6
         uIVhEXQ+XAVu25Nc8Kj3Q1XabAFOR73attndwNGbCof0H0Ow4lXLyAnw+YDiqYOV/Pmq
         ALLwt8dVDyepsr4UmLohYQK96uyvpCMxTlVWFcDgWuv7eC7aybAGf1YH9k9ocDy1qV5z
         XLwvtEO+GjJL9vvaYaNnkFeXzwX2uKPnVT8MVxs3oZZ4RcIQi68TAa5UPxNuAAUhYeKF
         Hb/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eZKKTWkNvu/0F33tX/g7gmdT/XzT4msMSsmAHd15+ag=;
        b=Vgled5GGRp4PmnuGgFt3xoXOoFlYD2B8c+OjFp30ArPnMR+awgUtoWOMIfZ39vvAdi
         y37kEARAcvtoDbfPQnKNDTwV6JgocrTG/VI8OoQCs1mq6RkCNrw9PgzByY3+rdMiVVn8
         hvVTlItBuEoMGFy2sPdmXbBQN1mdmGIe8VgAhP6yLzloHoXWZRkZVZNkrB6k6Yzos1HK
         rNPTd6wfr8tNV/ufJUb3GV74Xl7iBDrojOnt5lA2BT5ORMSuK3BSnNlojIkteUOryUm8
         TxczgFd7D7A+NG9eW/mGLMpbAE+HBDWxI/wjkPszOAR5TtGoiGalvZ28ATRbYpumRxgn
         fGrQ==
X-Gm-Message-State: AOAM532CC+X1SL/nM9d+6WFTOmRyX6yuAeqo06YHKm2q0HALPjte/eei
        BVo4OJgLpodcY+pfTnmP4RY=
X-Google-Smtp-Source: ABdhPJwjJk3C5hz2Kck1y7WQ4E/uA5brDN1qBQ12C6fTyc99BFQxReg6DTWLWv1PV/5H2qIzkJ4GXA==
X-Received: by 2002:a17:906:c0d7:: with SMTP id bn23mr16050987ejb.426.1633830981095;
        Sat, 09 Oct 2021 18:56:21 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id x11sm1877253edj.62.2021.10.09.18.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 18:56:20 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v3 11/13] drivers: net: dsa: qca8k: add support for QCA8328
Date:   Sun, 10 Oct 2021 03:56:01 +0200
Message-Id: <20211010015603.24483-12-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211010015603.24483-1-ansuelsmth@gmail.com>
References: <20211010015603.24483-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QCA8328 switch is the bigger brother of the qca8327. Same regs different
chip. Change the function to set the correct pin layout and introduce a
new match_data to differentiate the 2 switch as they have the same ID
and their internal PHY have the same ID.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 19 ++++++++++++++++---
 drivers/net/dsa/qca8k.h |  1 +
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 3e2274cb82cd..7c68c272ce3a 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -935,6 +935,7 @@ static int
 qca8k_setup_of_pws_reg(struct qca8k_priv *priv)
 {
 	struct device_node *node = priv->dev->of_node;
+	const struct qca8k_match_data *data;
 	u32 val = 0;
 	int ret;
 
@@ -943,8 +944,14 @@ qca8k_setup_of_pws_reg(struct qca8k_priv *priv)
 	 * Should be applied by default but we set this just to make sure.
 	 */
 	if (priv->switch_id == QCA8K_ID_QCA8327) {
+		data = of_device_get_match_data(priv->dev);
+
+		/* Set the correct package of 148 pin for QCA8327 */
+		if (data->reduced_package)
+			val |= QCA8327_PWS_PACKAGE148_EN;
+
 		ret = qca8k_rmw(priv, QCA8K_REG_PWS, QCA8327_PWS_PACKAGE148_EN,
-				QCA8327_PWS_PACKAGE148_EN);
+				val);
 		if (ret)
 			return ret;
 	}
@@ -2018,7 +2025,12 @@ static int qca8k_resume(struct device *dev)
 static SIMPLE_DEV_PM_OPS(qca8k_pm_ops,
 			 qca8k_suspend, qca8k_resume);
 
-static const struct qca8k_match_data qca832x = {
+static const struct qca8k_match_data qca8327 = {
+	.id = QCA8K_ID_QCA8327,
+	.reduced_package = true,
+};
+
+static const struct qca8k_match_data qca8328 = {
 	.id = QCA8K_ID_QCA8327,
 };
 
@@ -2027,7 +2039,8 @@ static const struct qca8k_match_data qca833x = {
 };
 
 static const struct of_device_id qca8k_of_match[] = {
-	{ .compatible = "qca,qca8327", .data = &qca832x },
+	{ .compatible = "qca,qca8327", .data = &qca8327 },
+	{ .compatible = "qca,qca8328", .data = &qca8328 },
 	{ .compatible = "qca,qca8334", .data = &qca833x },
 	{ .compatible = "qca,qca8337", .data = &qca833x },
 	{ /* sentinel */ },
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 535a4515e7b9..c032db5e0d41 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -260,6 +260,7 @@ struct ar8xxx_port_status {
 
 struct qca8k_match_data {
 	u8 id;
+	bool reduced_package;
 };
 
 struct qca8k_priv {
-- 
2.32.0

