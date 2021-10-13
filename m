Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBFA042CEA1
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 00:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbhJMWlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 18:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231741AbhJMWlk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 18:41:40 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE6DCC061570;
        Wed, 13 Oct 2021 15:39:36 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id r18so16218007edv.12;
        Wed, 13 Oct 2021 15:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=9LnrAkocmQLk3/asb8CX9S+Wuzi97AtlcxiuNHbEEro=;
        b=gMcwb1/d52eOvmh67O4QgbAp4fBJM6ubuIIwsSckas8uEaaOxBve2DndTg0W5IZJfN
         UWpOgAnOXRCbPsdIiRTto0fXZ5caEtHBCzQrH6/+wBjdWhMUDvoEGv3XkHM3mvNn9Fjx
         Mxhm4/JBnCexwbaGGVhT/d6fI5gZeI1DY1cwZLCAc3lGAzNHwQZle6frQP6Jj2SmxcYJ
         yUs/9fw/Y+DITzBUnsPbu1/XpL7DFXWVY3IURyV1+DGWJ06O9dCg4F1ZCQMXEor/pg6l
         aAsDyC3XSbxp/MquIR0HIYPvGUPnUjmy2bxAPodGw3trwQWlatMzkgF97q0yqpAaq1Kn
         2TIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9LnrAkocmQLk3/asb8CX9S+Wuzi97AtlcxiuNHbEEro=;
        b=TS/XbyerLdlN9s5G1OcX2nqN7VIt8jTSKKg88ppJoaQ8Vb5KaciU654bN7wG8Uhs+b
         jclrw5105jjqSJMaZyNkbD+++WTzRGSQ3I5GcObDkhSHLClrpJgrvRrjTObKJLX8nGHS
         VWgetLbWiP+MXlZqmqva9xJnctKVvsfuBStyc8j0//L/ypU6It9fIQx5bbUdeZQKPJrr
         T/XVReiAEOx9taOPJw/IdoC81E/bQ4NNfvrO20MoiIE4ryRwXUlig5tXEjmtrUGI/i+2
         2Ik1YZqA5WPJbYfuQJ1P8rR2fZWdW8NT+BW6duBtlgsnDF0wa9qXTdn0vpS4bHCvTBWe
         btEQ==
X-Gm-Message-State: AOAM531Sok0l/UukrJhjfZI0zgB5bN0vEHnii0qJE8YbuYwaZTGet3mr
        mOHIzn+7bHqXNvkWYTLQl7g=
X-Google-Smtp-Source: ABdhPJwE2UJ3Ma4YjFurbO5nJCVPdyt/bJpVQtgiDsOBuEoNLyVHbhVE/WkvuRFTwnZuwg+F9teKRQ==
X-Received: by 2002:a17:906:c009:: with SMTP id e9mr2303214ejz.509.1634164775170;
        Wed, 13 Oct 2021 15:39:35 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id o3sm524735eju.123.2021.10.13.15.39.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 15:39:34 -0700 (PDT)
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
Subject: [net-next PATCH v7 08/16] net: dsa: qca8k: add explicit SGMII PLL enable
Date:   Thu, 14 Oct 2021 00:39:13 +0200
Message-Id: <20211013223921.4380-9-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013223921.4380-1-ansuelsmth@gmail.com>
References: <20211013223921.4380-1-ansuelsmth@gmail.com>
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
index dad8cc5fd1af..23a05b857975 100644
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
@@ -1312,8 +1324,11 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
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

