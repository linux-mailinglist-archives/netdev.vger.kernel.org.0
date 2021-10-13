Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A2F42CEBB
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 00:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbhJMWmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 18:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231927AbhJMWlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 18:41:55 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54454C06176E;
        Wed, 13 Oct 2021 15:39:41 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id w14so16258832edv.11;
        Wed, 13 Oct 2021 15:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ra5UFjspLZycsL7dcenAPnY4GY6p9Bf7XDyytIIICY8=;
        b=DpYCX+71tZWOdl5VZDAM4WBiu/V+OvZTY3yRvrMha5rUu0337J5NXUKYsFVht4MbU4
         V4JqKPtf3dtbBccCSaPJUX8q/iTJvVQ8zelyWQWHRpusZyaJTMpKHMinGpO50+I7ko0W
         hE8izeOHYoL3eUK2IU6S0WjyQJYPlgrLPPRTbn+mLjghIZVJ8uAO59XQqELXIJ9KptfF
         N8hlMsbJgglmiWqMPYC5DBLsFqfHl/ALGe4M1eN1eemXBy9rWQdVbxotsqkph6Fw2+te
         f0NIcVmw/tHUAU+k+n6O2rUwf8BV8uC7Y8PC2GqkNbgtZ81PZbD8H8km/UI5ww/0d7dv
         n10Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ra5UFjspLZycsL7dcenAPnY4GY6p9Bf7XDyytIIICY8=;
        b=6R5mhAsIZvdSYeXajxz9awuFnIE5bfSzVmUmtBTnoNL40ak98keq1v3chTB+1qY7Qt
         C0RUSauvPk5rOn7KP3MnFQTTEOKWTqz1UMAto840Gs77LJHaR1Zup2ldLS8YGCAvGa1q
         TDmJ0u39o9hcyU6sSxPa1R3/JCd1+RKGcWY82YNMWyh+qSYzTrK/Gmhmx2izDtVWNdZ8
         gJKkpA698NZ7iIuURtka0WrkfO41g/isqcneGGsu5uzAYnMALQESlZ/eZiMs0O6cM5P3
         yuOj7YnbP2yL17JURRDHunwFGGXbxQmjexcT201loh3A5NjTNsP+cLKADSjm2SGKb49X
         /50A==
X-Gm-Message-State: AOAM53113/gyB637T9RJNfA9a2YIZnyZeEGOIoa2ZcqOWkEx8Nl3XTxu
        FrzX40yHDuFO4u/1n7Assk0=
X-Google-Smtp-Source: ABdhPJyrkzJ62V4+dw4XY7+z9op0NymGE+pjfWBtZ3l9tQm8J/twjJ/GSCLPNvNzXRp4jrTjDu6CjA==
X-Received: by 2002:a05:6402:3488:: with SMTP id v8mr3159622edc.106.1634164779876;
        Wed, 13 Oct 2021 15:39:39 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id o3sm524735eju.123.2021.10.13.15.39.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 15:39:39 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        John Crispin <john@phrozen.org>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [net-next PATCH v7 12/16] net: dsa: qca8k: add support for QCA8328
Date:   Thu, 14 Oct 2021 00:39:17 +0200
Message-Id: <20211013223921.4380-13-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013223921.4380-1-ansuelsmth@gmail.com>
References: <20211013223921.4380-1-ansuelsmth@gmail.com>
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/qca8k.c | 19 ++++++++++++++++---
 drivers/net/dsa/qca8k.h |  1 +
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index fad32ed75f45..6dcb2546388a 100644
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
@@ -2088,7 +2095,12 @@ static int qca8k_resume(struct device *dev)
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
 
@@ -2097,7 +2109,8 @@ static const struct qca8k_match_data qca833x = {
 };
 
 static const struct of_device_id qca8k_of_match[] = {
-	{ .compatible = "qca,qca8327", .data = &qca832x },
+	{ .compatible = "qca,qca8327", .data = &qca8327 },
+	{ .compatible = "qca,qca8328", .data = &qca8328 },
 	{ .compatible = "qca,qca8334", .data = &qca833x },
 	{ .compatible = "qca,qca8337", .data = &qca833x },
 	{ /* sentinel */ },
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 35a471bfd27f..9c115cfe613b 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -260,6 +260,7 @@ struct ar8xxx_port_status {
 
 struct qca8k_match_data {
 	u8 id;
+	bool reduced_package;
 };
 
 enum {
-- 
2.32.0

