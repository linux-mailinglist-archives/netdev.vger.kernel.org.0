Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62E4242B213
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 03:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237599AbhJMBTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 21:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237036AbhJMBSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 21:18:44 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C82F1C061764;
        Tue, 12 Oct 2021 18:16:41 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id w14so3082238edv.11;
        Tue, 12 Oct 2021 18:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=nU7nTJ3a3Wzmt/IFX9yznPRli0ExVrPcEoqu+LTZ6Bc=;
        b=PPaHJBg7x9y+p/nnt60mjFJXbpbzA07CMTdifYkWXULHRWYimOO5voXeLamWHAObbM
         5VWvFOpAlcb3UhnnS2bLc3K0m9+5zUzYwgBlbLSyS4xhJvaIPDhatsRy3cZ/ZqF8K0WU
         i5b2FyRpD4CCmR33ObXdSRfkeY5U6BWDp6qzQEUgq7drX+Yd9oAbga4umNYOox81Hy4A
         fMkjF3VKlKyj4nweyjerqc4UoIcIMSKIBK4tWaPHt5mkHD2p4o7r2+7Xud03QL/EyUZQ
         /+E2EqQzYeDq4LHMEEeyXFaP90WZOQA+aRO1gNODwEwFOzwP+p77bAZNEDYGgMJ/JFd6
         dIGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nU7nTJ3a3Wzmt/IFX9yznPRli0ExVrPcEoqu+LTZ6Bc=;
        b=c6xO/QFUFMJT8+I86BZyMJzRZpRT4NbUAES81TJrmqUVVL/1XwtIzb2yX/Lfx1MNgs
         Ky+wmgQItrQF2xmcgg2ON0L57qTntAnX+ZONMZJnCOwhH71cav1zuElNCVNZRdXoHgcf
         RmsMuM0Dq83POuZomHh8fbDu/28B7b2t2sPmZevPu0yEVvH3shAbixkAsDV/ve+Ijh3d
         j874zQ59Kr4qNLjy749B2oGMNfzpxfwFIbwanMLf9xb+m7pdwT76uF1z96BjGpqmoVVG
         +Uwr2TV+4ZaoXA7CwV21h3c6yGZuZQ4p/TzFwk5U/iQx/TlnPZDWVcI/hr8d10vMXQR6
         ZC6Q==
X-Gm-Message-State: AOAM533A5bD/DbCH/SV5yFRl1tRcq5TGe03R0cBDdNom6XbEZU9RDnVQ
        zcgbsFN7E7y4gGm0RX957cc=
X-Google-Smtp-Source: ABdhPJycYtWIUcCX2AIJ6x2PpqOC3VP2fGDY1QxYzb6lY7IfJcRvLEMsnLNaHWaDTcE2CI8t4Ey4KQ==
X-Received: by 2002:a05:6402:4244:: with SMTP id g4mr4923508edb.158.1634087800327;
        Tue, 12 Oct 2021 18:16:40 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id v13sm6894630ede.79.2021.10.12.18.16.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 18:16:40 -0700 (PDT)
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
Subject: [net-next PATCH v6 12/16] net: dsa: qca8k: add support for QCA8328
Date:   Wed, 13 Oct 2021 03:16:18 +0200
Message-Id: <20211013011622.10537-13-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013011622.10537-1-ansuelsmth@gmail.com>
References: <20211013011622.10537-1-ansuelsmth@gmail.com>
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
index e63ca79f3452..fc42f86ca898 100644
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
@@ -2089,7 +2096,12 @@ static int qca8k_resume(struct device *dev)
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
 
@@ -2098,7 +2110,8 @@ static const struct qca8k_match_data qca833x = {
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

