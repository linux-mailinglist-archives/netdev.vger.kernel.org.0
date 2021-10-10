Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B12C9427E43
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 03:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbhJJB6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 21:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbhJJB6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 21:58:10 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F693C061570;
        Sat,  9 Oct 2021 18:56:12 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id p13so52569489edw.0;
        Sat, 09 Oct 2021 18:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bT3uYmIpBBUPuoKRyduVCWixAeUcB9/KN+Kcgh/0JR4=;
        b=NznikFRChK3c6e+7v4mvFi6IORdYDHrzq7ZQ6PlAP0DhVgsKY/dkS1fdmTUYtTeVDR
         CvbWx3v85PA32leNfOAVfaJxfZdA4vbgkLdLFmKERC1vOMBN7hzxozgzj+w3GpNvYxzZ
         Z03nkvD5H0jgsrVJyNx9Wn3y+5YU26UL3wHuLnF56vQ1s4L3xd9w+Y1yzG8JFUhA9QYW
         slv9cjCrpx+8c9VwomTkPF7Ygav+A4pjaTcIXyTU9NDYoYj9aCGPjKs8mB8qYHcEeFvn
         DX7+uxfic7Qz+LWWBJLTxB5C8SZ79N4ktiQcBV5BimODVYKL7pu2uIQDKRnsM8fUcQUR
         5sTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bT3uYmIpBBUPuoKRyduVCWixAeUcB9/KN+Kcgh/0JR4=;
        b=lREZ8P3lbTfJHiHzmO5Ucl72rmXzQmUvmUTabAo5s4yMcLwF4+qAlQ6MQ5S/QaYnp0
         9rO3hkOhdfL1zyRB8ptamwLAUBu3bqKQm7/EQ8pwOInyeXe1E+/6DuTcJHTAdSHnRL8r
         JmaLMTTroflNmABY4gOb6PXsDX0ChrgFc6kKdst75FeGMXiMRMvzIAJd+xnOKRkd/IDp
         73LJhxbuwi1IL84ahZcUnw4zdIttEvquboxIZIWW4fK3mBOeg8rVaEtAncfCNtn3gZxq
         as6TjeIY0E8kRk5inDisK63J/AI/DGN/0GmuphY3Ke+29m6xrB3CNHGFbxD1VNiuLf93
         e/vQ==
X-Gm-Message-State: AOAM532sYY/et/kpPU1N7kUQmYpcLTtQUGXejUAj2KCduZ+DiSf7DOzF
        sXjj1RwSZRSb9VOxIo2WwPS2rVBTNE4=
X-Google-Smtp-Source: ABdhPJzKcE2rDLmEnrSaFg9SO8xIkvYh2fIQ94q0AtYtYMTETCODLUGI56kxiZcBTcud4UkmdbUCqA==
X-Received: by 2002:a17:906:bc43:: with SMTP id s3mr15383221ejv.46.1633830970572;
        Sat, 09 Oct 2021 18:56:10 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id x11sm1877253edj.62.2021.10.09.18.56.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 18:56:09 -0700 (PDT)
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
Subject: [net-next PATCH v3 01/13] net: dsa: qca8k: add mac_power_sel support
Date:   Sun, 10 Oct 2021 03:55:51 +0200
Message-Id: <20211010015603.24483-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211010015603.24483-1-ansuelsmth@gmail.com>
References: <20211010015603.24483-1-ansuelsmth@gmail.com>
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

