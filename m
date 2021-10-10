Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE044280BD
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 13:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbhJJLSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 07:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232105AbhJJLSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 07:18:21 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C065BC061777;
        Sun, 10 Oct 2021 04:16:18 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id z20so55209983edc.13;
        Sun, 10 Oct 2021 04:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sRH5UhT3GSFn9NHD4n38xeYZUeiG6gIzM5V7zY5J2Q4=;
        b=OTQP8AVBRvfpvF/XApSAn/kMzGjIcZJIWdJyRVI9dpcEOHcWFEbXjaZiIDJelKqSI0
         oIGtS7g/S3pHHNppzl6k/dp+6Kv5l51zWqd6UVpY0mpvkglpuN/kxtXKThW39lqN0Dcd
         yYdcKwm7Cbj0eeKtQajUME9bJ7tkxODCfPEmOa8UCYTJPxK4R47SSlUTyUh+BLoqpI0X
         E7FuA2qCFufRKjq0C3ScoRJXHcV+Q45OGzqCUPh0yrr6+QWvcDnREGjEs6gcP6ScwYcx
         eX2RnZ4ZbdfH424v3GKRPrf3vDQoT2RnK3VQk+KSIEHPUG0RZLKHIivQomq9/ZBagHI+
         9Brw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sRH5UhT3GSFn9NHD4n38xeYZUeiG6gIzM5V7zY5J2Q4=;
        b=viIk0jQT+AO/iVPs2AOn/Op9ud7Yqt5cDjjLtjeI17pjJ8DoMqOgxI7/k7q7WFe4bO
         Yr4x/Y5DC+baSGzgcXSWAxVn2yKLdj6Gyspsm0ZJz0j0Uusiyuc0vaml875gDQPDPZWs
         aYHoCPNe17d7uDmsbdxXovkCq/Fxk2LXFpECH47yVo7SQ9oZ86Hta4nKYUu6sAza0yKu
         tc5fM6mzbIsFhLfCSEq21O2bAWZ6ANOavFPtX6fB73jZFfG8Nq0YYLYZsj2sn+KfFR5+
         jWpCy1zjG21A+Gv6Y9Ru66AR5hFQ0hkxjNnggtL7iMyX5zoM1tF6NEamxgr86nPCmtUx
         1ccA==
X-Gm-Message-State: AOAM532ROaGIXa180Jze76MVVp0lKjL32qDqgwRCagSxoSHfqDWGD5Ql
        Kvr74TaU0rnkcIEmIRNXbcU=
X-Google-Smtp-Source: ABdhPJz+AsNpQ5tgvQCwFTdKtr2QhrVHgdlzfKJTsakCjcSRBWBzLUbEcEIaCSiTdqltgKhb+UGREQ==
X-Received: by 2002:a05:6402:4402:: with SMTP id y2mr23261644eda.222.1633864577269;
        Sun, 10 Oct 2021 04:16:17 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id z5sm2414438edm.82.2021.10.10.04.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 04:16:16 -0700 (PDT)
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
Subject: [net-next PATCH v4 11/13] drivers: net: dsa: qca8k: add support for QCA8328
Date:   Sun, 10 Oct 2021 13:15:54 +0200
Message-Id: <20211010111556.30447-12-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211010111556.30447-1-ansuelsmth@gmail.com>
References: <20211010111556.30447-1-ansuelsmth@gmail.com>
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
index 5091837cb969..947346511514 100644
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

