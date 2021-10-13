Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 354D842CE8E
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 00:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbhJMWle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 18:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbhJMWlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 18:41:32 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF24C061570;
        Wed, 13 Oct 2021 15:39:28 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id w19so16617377edd.2;
        Wed, 13 Oct 2021 15:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=3eYPnxjRimB6ZmwgPf9MwKG8QmiCftaEaNzK4aV3nVs=;
        b=OsTnwKUjCmSnTE1leoERfchVW7w5eebxDBeN9erFOc6gtGYhwI7SuNebi/HcKkUaJG
         ma2RVymjM6M9aJL2T/e9IGSYc0DyxJHi5pUZn3hI46a9RI7jlKTMQfVt2qeYyRxBAUAy
         HbZJyR+UWMfhowKgLL2lUnh8U2kpXq5Ssde13GvpLaD7gg7nZVdVaUI4nFHoylBGELXp
         vofy68yvQpJQrsvujGfLMnDdtUExeAVtvUFiJ5k70/E9CbVDXoTtzbCMYvPACFV/34BP
         nqUY3QI+9KIv/aJJ0Ls7HXiQFdkEJ/R7Iu/U5ZKekBnbdCqv65X4U1LH3Ezcfxz17WVG
         WOPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3eYPnxjRimB6ZmwgPf9MwKG8QmiCftaEaNzK4aV3nVs=;
        b=Gzlh2rLtxEETN/2TRj45Gq/Ccd492b+4chbIi+e3WEHYskrBCH3ilpY/EeogCFidns
         KV1hSDLRmLdYHLp7K6UMQP7noF77q7B7q0hcYtRJ1dKWgXQI6SBPQEXHw/CwgQ9vqCiK
         5brscX+uCdE8fyWQHRp3I0aPTOdoF+/C4P5ZvjhI7lDMQxNGu7AKkRBBuCUC6Aqt9dm4
         A4lp8LDA6G8HPHCaFl8b163R/yPRaZyM4cqAr05uURTIUYOzjnBID7FlVZhJrLY1uR6t
         PaYWHwdSzOibGwEinA+W9ftNYsOWxYtCHYe3NTLPxNkLumkcLJJMb4dSBdYmGNlL5cM0
         q0hw==
X-Gm-Message-State: AOAM533FYsTvUz8qjx1GuSInzaXh/LQCwtK5Ids1SeeE4fdpCZ+I/Jw0
        t9xjQmAFUvm/7XvvDzqlUPY=
X-Google-Smtp-Source: ABdhPJzupkHxCMXbe8XZPkm47xWpsdbpYrSKmXrM1HP8m0bfLEHhZr1XdMRAtxn7v3NbQrUr2RATPw==
X-Received: by 2002:a17:907:205c:: with SMTP id pg28mr2325694ejb.407.1634164766682;
        Wed, 13 Oct 2021 15:39:26 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id o3sm524735eju.123.2021.10.13.15.39.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 15:39:26 -0700 (PDT)
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
Subject: [net-next PATCH v7 01/16] dsa: qca8k: add mac_power_sel support
Date:   Thu, 14 Oct 2021 00:39:06 +0200
Message-Id: <20211013223921.4380-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013223921.4380-1-ansuelsmth@gmail.com>
References: <20211013223921.4380-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing mac power sel support needed for ipq8064/5 SoC that require
1.8v for the internal regulator port instead of the default 1.5v.
If other device needs this, consider adding a dedicated binding to
support this.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/qca8k.c | 31 +++++++++++++++++++++++++++++++
 drivers/net/dsa/qca8k.h |  5 +++++
 2 files changed, 36 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index bda5a9bf4f52..a892b897cd0d 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -950,6 +950,33 @@ qca8k_setup_of_rgmii_delay(struct qca8k_priv *priv)
 	return 0;
 }
 
+static int
+qca8k_setup_mac_pwr_sel(struct qca8k_priv *priv)
+{
+	u32 mask = 0;
+	int ret = 0;
+
+	/* SoC specific settings for ipq8064.
+	 * If more device require this consider adding
+	 * a dedicated binding.
+	 */
+	if (of_machine_is_compatible("qcom,ipq8064"))
+		mask |= QCA8K_MAC_PWR_RGMII0_1_8V;
+
+	/* SoC specific settings for ipq8065 */
+	if (of_machine_is_compatible("qcom,ipq8065"))
+		mask |= QCA8K_MAC_PWR_RGMII1_1_8V;
+
+	if (mask) {
+		ret = qca8k_rmw(priv, QCA8K_REG_MAC_PWR_SEL,
+				QCA8K_MAC_PWR_RGMII0_1_8V |
+				QCA8K_MAC_PWR_RGMII1_1_8V,
+				mask);
+	}
+
+	return ret;
+}
+
 static int
 qca8k_setup(struct dsa_switch *ds)
 {
@@ -979,6 +1006,10 @@ qca8k_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
+	ret = qca8k_setup_mac_pwr_sel(priv);
+	if (ret)
+		return ret;
+
 	/* Enable CPU Port */
 	ret = qca8k_reg_set(priv, QCA8K_REG_GLOBAL_FW_CTRL0,
 			    QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index ed3b05ad6745..fc7db94cc0c9 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -100,6 +100,11 @@
 #define   QCA8K_SGMII_MODE_CTRL_PHY			(1 << 22)
 #define   QCA8K_SGMII_MODE_CTRL_MAC			(2 << 22)
 
+/* MAC_PWR_SEL registers */
+#define QCA8K_REG_MAC_PWR_SEL				0x0e4
+#define   QCA8K_MAC_PWR_RGMII1_1_8V			BIT(18)
+#define   QCA8K_MAC_PWR_RGMII0_1_8V			BIT(19)
+
 /* EEE control registers */
 #define QCA8K_REG_EEE_CTRL				0x100
 #define  QCA8K_REG_EEE_CTRL_LPI_EN(_i)			((_i + 1) * 2)
-- 
2.32.0

