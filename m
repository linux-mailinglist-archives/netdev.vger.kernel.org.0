Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E62FA42B1EC
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 03:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236361AbhJMBSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 21:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235884AbhJMBSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 21:18:30 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB1BBC061570;
        Tue, 12 Oct 2021 18:16:27 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id g10so3289416edj.1;
        Tue, 12 Oct 2021 18:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=3eYPnxjRimB6ZmwgPf9MwKG8QmiCftaEaNzK4aV3nVs=;
        b=D8V9teNM8KUP55ksXoCT1gaKmDDp+6L99g/SVQx+NszQlwJCQXc5kEb/QdE3CqaCfg
         LWsn6XYUfEO38AhLrNy/d/H8vsoXYrk2EuNnRfbHjOn19o87L+vyEOBJWW3ahuGhClWS
         n1QzUZWQp3aWIqkwW1yoMWjKGBjW76yxT/vCYI4MR+xdrk3opsDdSziRrA1vwDFlkRfM
         NOLtE7DS0DWOO2EWLBhsW4y8sStJb3qRVcaDE7zWXn1BwSH4TbV5A4fjs/4bY96ZE7oz
         RJAngPnb4AcnnlcBEfYtj4o382GecrAt9AbwTRptIRcFvK/hpbvdQ1UpNbMeAWw9z0rh
         e4+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3eYPnxjRimB6ZmwgPf9MwKG8QmiCftaEaNzK4aV3nVs=;
        b=2r7IZBhajgsjjs7pTgXrBgQfTj18fZahTjnf7MRrfo/64VF2qEr0R04iAWDalxksU/
         bnSJaAcueNJ+Q/VgtbKe6Lm9Ru9H6ncYHajP53csd7bivgSv8Ka6U55mzpsRuNx1J0Cf
         SjYDTvc9r9Tuu50zCNEDKjeIQo8fRRiZpayEjB4B61smDfeecstxxqIfKpWNRDBtinuP
         WBoLuhLVMWj3VhoS5XQEpy4X0n3QjUIPlKfeez8qVBGwK/BWHpPkzi0aT6P2c/c1B721
         xtK767aZahjak/ysF1tUsmMb30Amcx6NJikYgPU5zvMbLAAUcA1u9LoLHE7JOBk3ZvWR
         /ggg==
X-Gm-Message-State: AOAM533b1htnaWjkbwUlxIgEnzAnxwPQQD4/Y87HmQh/1jPwwrVHbypt
        HOCw+0zmKLTyZD61ka+LL9o=
X-Google-Smtp-Source: ABdhPJwpkM1DeWc3MG+Gnevz2obQaXQ7X/eLT9VGRtY66p+wkUWAZt+eLOBuh8omLH3EZmAN3HckBw==
X-Received: by 2002:a05:6402:16d2:: with SMTP id r18mr5003516edx.363.1634087786228;
        Tue, 12 Oct 2021 18:16:26 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id v13sm6894630ede.79.2021.10.12.18.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 18:16:26 -0700 (PDT)
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
Subject: [net-next PATCH v6 01/16] dsa: qca8k: add mac_power_sel support
Date:   Wed, 13 Oct 2021 03:16:07 +0200
Message-Id: <20211013011622.10537-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013011622.10537-1-ansuelsmth@gmail.com>
References: <20211013011622.10537-1-ansuelsmth@gmail.com>
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

