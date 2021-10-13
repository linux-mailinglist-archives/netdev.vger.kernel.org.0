Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0A342B208
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 03:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237334AbhJMBSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 21:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236782AbhJMBSj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 21:18:39 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C44C06176A;
        Tue, 12 Oct 2021 18:16:37 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id g10so3290373edj.1;
        Tue, 12 Oct 2021 18:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=74CbPh5dAlWqGLjMDJ3Lr7q7MvEXGJ2TOtssnloGTn8=;
        b=fHrjijj3bJFeru+UJQ8m0oUNioWwnmjvAxy+sRQDshT/CS2iBX9U6CF+613ZueWSb1
         D++48pkKtbjSPCKvhdDpVLj85Dp2yZF2QaRrOnA3xMh/07++52ch/Guh6G/X2S2YvT6H
         v5aflhUW6xQJUnwqRKIFVz/r3v6q/Ec35hz38pSXVh2qNykRKdyF+gy+WZ0+lFoYbPam
         M16GqfQ8Y8GNN4YeyYBj6oYyTDDYanl+CjtfW6WfLVH4n4rOlbx+84bNzbQ8QPiCQOVA
         pBxo/yyMg9XCYVkqEdWgZygQG5+D8zCrMvNUCHJQgztqfYkM2QQJqIuaSsTon2/re8Uk
         Um9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=74CbPh5dAlWqGLjMDJ3Lr7q7MvEXGJ2TOtssnloGTn8=;
        b=lQAA0/Bchgth8eaHGt79TMHx4J20LZYfuUTNYJlY1DZu9yYUmXZTjgq648mcgdSboF
         1Sq1a173GTB6OUXV+yGv58N9dHUG9zsSlQo1J0KY34cd8wqOVDtfLfguGnZCSuxsqSEa
         eY1NU3sAXksqm7wzW6QgiGpGqx75GNDsiJa4BTvo0upxVQp/aRKRbCjnqGIBqtcmZYKp
         9B7aulhJ/iC+gPYinidcpJ3jKFwgoi7n6Hao8DEibxSfuWdN5U7lgS72Pa5umSJU1juV
         NLiZSHrRE0BfYXAOIunPPlAOvFZmc+A7Kl4YOUCUzWizW3xK/7WW//r1nbTEfdQTEQxK
         V/0A==
X-Gm-Message-State: AOAM531hsh6FmcZaT8948D5V4g9wJIhpReq5r4C+1TQX8ZrwSNYrIiBe
        +g77J8Ffz1JtJucxca+7B0M=
X-Google-Smtp-Source: ABdhPJx/wsTJ6Vl13r6VXf232PfW57k/1QO99xxeY4VSKJppIx4MFkXo283dWklstE57kny72I6xbA==
X-Received: by 2002:a17:906:7f14:: with SMTP id d20mr37079696ejr.330.1634087795581;
        Tue, 12 Oct 2021 18:16:35 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id v13sm6894630ede.79.2021.10.12.18.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 18:16:35 -0700 (PDT)
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
Subject: [net-next PATCH v6 08/16] net: dsa: qca8k: add explicit SGMII PLL enable
Date:   Wed, 13 Oct 2021 03:16:14 +0200
Message-Id: <20211013011622.10537-9-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013011622.10537-1-ansuelsmth@gmail.com>
References: <20211013011622.10537-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support enabling PLL on the SGMII CPU port. Some device require this
special configuration or no traffic is transmitted and the switch
doesn't work at all. A dedicated binding is added to the CPU node
port to apply the correct reg on mac config.
Fail to correctly configure sgmii with qca8327 switch and warn if pll is
used on qca8337 with a revision greater than 1.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/qca8k.c | 19 +++++++++++++++++--
 drivers/net/dsa/qca8k.h |  1 +
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 3b1874bf5d7d..486e8a3d9af5 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1002,6 +1002,18 @@ qca8k_parse_port_config(struct qca8k_priv *priv)
 			if (of_property_read_bool(port_dn, "qca,sgmii-rxclk-falling-edge"))
 				priv->sgmii_rx_clk_falling_edge = true;
 
+			if (of_property_read_bool(port_dn, "qca,sgmii-enable-pll")) {
+				priv->sgmii_enable_pll = true;
+
+				if (priv->switch_id == QCA8K_ID_QCA8327) {
+					dev_err(priv->dev, "SGMII PLL should NOT be enabled for qca8327. Aborting enabling");
+					priv->sgmii_enable_pll = false;
+				}
+
+				if (priv->switch_revision < 2)
+					dev_warn(priv->dev, "SGMII PLL should NOT be enabled for qca8337 with revision 2 or more.");
+			}
+
 			break;
 		default:
 			continue;
@@ -1313,8 +1325,11 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		if (ret)
 			return;
 
-		val |= QCA8K_SGMII_EN_PLL | QCA8K_SGMII_EN_RX |
-			QCA8K_SGMII_EN_TX | QCA8K_SGMII_EN_SD;
+		val |= QCA8K_SGMII_EN_SD;
+
+		if (priv->sgmii_enable_pll)
+			val |= QCA8K_SGMII_EN_PLL | QCA8K_SGMII_EN_RX |
+			       QCA8K_SGMII_EN_TX;
 
 		if (dsa_is_cpu_port(ds, port)) {
 			/* CPU port, we're talking to the CPU MAC, be a PHY */
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 5eb0c890dfe4..77b1677edafa 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -266,6 +266,7 @@ struct qca8k_priv {
 	u8 switch_revision;
 	bool sgmii_rx_clk_falling_edge;
 	bool sgmii_tx_clk_falling_edge;
+	bool sgmii_enable_pll;
 	u8 rgmii_rx_delay[QCA8K_NUM_CPU_PORTS]; /* 0: CPU port0, 1: CPU port6 */
 	u8 rgmii_tx_delay[QCA8K_NUM_CPU_PORTS]; /* 0: CPU port0, 1: CPU port6 */
 	bool legacy_phy_port_mapping;
-- 
2.32.0

