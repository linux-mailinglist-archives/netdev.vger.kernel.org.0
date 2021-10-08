Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B526742613E
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 02:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243126AbhJHAZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 20:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242809AbhJHAZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 20:25:10 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FCB5C061755;
        Thu,  7 Oct 2021 17:23:15 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id r18so29607788edv.12;
        Thu, 07 Oct 2021 17:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=BO1dGsbKRvbWMl2fcg8UVPlbMozPNRHZOtkiE2o15Cg=;
        b=IqE/HnX+Mo3zxnxxC1plciL/Ly9pYmzDh/15pFIatR4oiBQbsfglaOJkD/oL0klyvW
         BqN5tluUaqM+ayPObM6eZbsADVONAt4Q0WJ1oC43nYM41n87CRzTUtFeOBF19OdDZ218
         ptUyfrL8uQNP/zrDnXOWJ5pd7ChkwPHej+O/mTpolu9xOtXEWib9UAoVYkoBtf5fQvyH
         vEaJVoIDJcW5ZXdunK9SlObP2m9Bm5xXd5naXQfV2GK8cPPfOf2gRPAdM8g8B+ukqb2I
         dcIZeZCw6etSR/QJkOIfaygeWuj/fe5QYkuqUkrFYmg4/8zhy3XiKcq081l7YqmBOT0f
         hyLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BO1dGsbKRvbWMl2fcg8UVPlbMozPNRHZOtkiE2o15Cg=;
        b=hf3bCnKB21eWn2sAeaXBV0rnOCjuCro4uegXdcczAC6cDBMXtViTN+mCi5TEGmhQ16
         XpvZ8vwbn6S+74DOWR3Pzws6sjWXj+drzCDIrHtAXB8NM0dLj9fOGaHOjXWYdsN9DVWs
         d0Ap+oNmDRt4Ko/hTa0oIk65kdFPxVJYyZHqduJ2pBBfCq9HYAnsyVFDjnx9i8zZrH4F
         7INL+7C6PG8aYEmNK2MFvNS8RNhEDBf14JKwNMWXas/8/VErlvH0RzaYOfrhJd0fywaO
         DMZrVROhCxIKAyxJT3jwVlNXDZzpQDEggWOA54ZWD8TkQbiY0Vd348Th8kVkuEPxkV2o
         cVsw==
X-Gm-Message-State: AOAM530+zpuV6g3q1TOSSBU0I+JNexiOVuKuq6MrHg8Z8C7cUVIaIlTG
        2Y1BMFxLamhq55UlZt+10qA=
X-Google-Smtp-Source: ABdhPJzajTO3bpEEhiwi5OQ77tVTnIJxWbRfIRb8x5mvpl6tWGr/FK1WAn7FPf73PfuXhnHH5BtM9g==
X-Received: by 2002:a17:906:31cf:: with SMTP id f15mr163204ejf.272.1633652594024;
        Thu, 07 Oct 2021 17:23:14 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id ke12sm308592ejc.32.2021.10.07.17.23.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 17:23:13 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [net-next PATCH v2 14/15] drivers: net: dsa: qca8k: add support for QCA8328
Date:   Fri,  8 Oct 2021 02:22:24 +0200
Message-Id: <20211008002225.2426-15-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211008002225.2426-1-ansuelsmth@gmail.com>
References: <20211008002225.2426-1-ansuelsmth@gmail.com>
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
index 0dc921cfb8c6..aae0cfcd0ce8 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -943,6 +943,7 @@ static int
 qca8k_setup_of_pws_reg(struct qca8k_priv *priv)
 {
 	struct device_node *node = priv->dev->of_node;
+	const struct qca8k_match_data *data;
 	u32 val = 0;
 	int ret;
 
@@ -951,8 +952,14 @@ qca8k_setup_of_pws_reg(struct qca8k_priv *priv)
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
@@ -1994,7 +2001,12 @@ static int qca8k_resume(struct device *dev)
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
 
@@ -2003,7 +2015,8 @@ static const struct qca8k_match_data qca833x = {
 };
 
 static const struct of_device_id qca8k_of_match[] = {
-	{ .compatible = "qca,qca8327", .data = &qca832x },
+	{ .compatible = "qca,qca8327", .data = &qca8327 },
+	{ .compatible = "qca,qca8328", .data = &qca8328 },
 	{ .compatible = "qca,qca8334", .data = &qca833x },
 	{ .compatible = "qca,qca8337", .data = &qca833x },
 	{ /* sentinel */ },
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 2c98b133ec4f..2d0c41e8cb75 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -262,6 +262,7 @@ struct ar8xxx_port_status {
 
 struct qca8k_match_data {
 	u8 id;
+	bool reduced_package;
 };
 
 struct qca8k_priv {
-- 
2.32.0

