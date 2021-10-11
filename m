Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD34A4284C0
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 03:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233293AbhJKBdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 21:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233598AbhJKBdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 21:33:07 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E41C0613EC;
        Sun, 10 Oct 2021 18:30:58 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id g8so61223963edt.7;
        Sun, 10 Oct 2021 18:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v7YBxgHCPu7CxdQ12nihQKVw9ZRD8FoTkdRnjNnqZrA=;
        b=eAqh6Wfwhgqoe+Y9XfY7fSkj4V+rUVuEtiMbwv0tYKpct6soIBD9Xc3W0s7LksX7Gg
         fup5bncoOnRBUgfi5gWu4pFz9LsVIO9CcITOTHBoj/Wvn9Jd7hzMN8JuSqhAk4oqj9lx
         KJNWPHxELx3NPPs8r2/P6dmdlGcAiG4rQkA40uVMQC64Ipv/CTyLbiAOnmMxoUoYme/j
         ++LwH7/HANZ4oo1bleROEiw845ZWaqyTMQfsMa3bngbdrE9DXSGpk3O962Cdr6Z/RpnR
         nsPPsl4WtS9Y0MXFPZ9RjSWYhhc9vK3baqXWbq0ueDXA7zjcmZs1RaWgW0Az+CXW+6X+
         UQnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v7YBxgHCPu7CxdQ12nihQKVw9ZRD8FoTkdRnjNnqZrA=;
        b=4xgh9Ab0MUcJTYMEl+amrVXsisgqGVxKnyT79a4UyCbc6dlWIB9agVt4O8KNiFCJ+z
         cs/d3MyhWzQfqMplie4bIdughKm/CODTSjBl7le/Dp3pNrHddugOytzsHlx2rhpWzCl/
         2H4lTIjClXypbMOYrmWC5LJ+k14D+qt4R5jcBCChe+bUNPYfI/Rrg55jDdpM0W58MEyT
         aeMsINacSEVOrdL0MUujxGI+w7DqDV3+4kBO+qfRauubZTeKWv2Hom6QpB6+NWgmvK/x
         OpXHF+PA/R4+SpmmRhYL0S3Iff/T8L6vy+1TLVaQMf9QzqJiKapIH6UczfH/rtwkKBCB
         oDrA==
X-Gm-Message-State: AOAM530jSIyH7f8lerJKcqHyS8pKHiPj0iQwNlkWID+KYjCMMMaG5cuR
        Ni3B6PWKVWy0Qukk6D+wYEOI+RuUULY=
X-Google-Smtp-Source: ABdhPJzrkPUgk5oKdhT2UY1fobObPqvy0M0YxVxn0uAFQF1t1pou6Gr0aqQkTbg/ysm2m1h45A60+A==
X-Received: by 2002:a17:906:b19:: with SMTP id u25mr20917348ejg.36.1633915856963;
        Sun, 10 Oct 2021 18:30:56 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id m15sm21314edd.5.2021.10.10.18.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 18:30:56 -0700 (PDT)
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
Subject: [net-next PATCH v5 12/14] drivers: net: dsa: qca8k: add support for QCA8328
Date:   Mon, 11 Oct 2021 03:30:22 +0200
Message-Id: <20211011013024.569-13-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211011013024.569-1-ansuelsmth@gmail.com>
References: <20211011013024.569-1-ansuelsmth@gmail.com>
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
index e9c16f82a373..cb66bdccc233 100644
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
@@ -2082,7 +2089,12 @@ static int qca8k_resume(struct device *dev)
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
 
@@ -2091,7 +2103,8 @@ static const struct qca8k_match_data qca833x = {
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

