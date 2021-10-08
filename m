Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1A9426125
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 02:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242835AbhJHAZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 20:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242353AbhJHAZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 20:25:01 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2342C061762;
        Thu,  7 Oct 2021 17:23:06 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id d9so5694796edh.5;
        Thu, 07 Oct 2021 17:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=fzPHyN/VWRKoUdLgfNVGZ2p3wDYQHk1zqnPMozbonEk=;
        b=Hw9flh8KhGnMf+6cDBv6VWg5rvLpMmv4kZ9wxy+tD/i+eIcZuIdIGdXOx4rOZH78pC
         nxYrQ2c+zCCO048FGayF4Qd2i4nXDt7TrUuj7N2v6O4jBd7MAJ9dPL7Ew6f57e+hGy6D
         yR9He8IHNkzHliF+aVF8Zx9IdnFKxawtaqPZySF3zyEH5ohuVzC4hXBoWrzGKIybocVs
         S53ocxPwYz5x9ozTen7sfftwM6kavIM12TSyTJqMORkpybYm6ZL+KeDAenP3kBm7PBnq
         MJuLmgXYFXwlO6V2TUGW0zULKSofc9nlQy3VJ1QAFxqfzyd1QlrxmfYvBWgqMQCIonNQ
         S76A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fzPHyN/VWRKoUdLgfNVGZ2p3wDYQHk1zqnPMozbonEk=;
        b=hoDYBjM4bDk9yFYJlB/GsAb0pfiVYGsumRYcRoy1oPN4T17lFKhduXwqtPl3bZUzrU
         g7gIAAmx+7NAGQ+4n7RK/om83NbMn1Mob7+2yICu6oVp86y9OXooulCNUH5E2QdlAdOH
         0BNKzuT8/ASfnN1TX+iiiabCyhPwkG7bF32YDkcNC6IjYUBPv50vjGFELfDYqnGnaGbu
         3FOKEHJlCLHjREG0k73j6ZUtjmH8dk0ukRcnK2OLEKVqArFaNC57o0xEvYR5CqWRIutP
         gSf+6UTsaFyFQEZcC7+oQd8sxVw3wDic6dT59D0DLRG6hK64ZKp/BG/imAXgH+aOUPBl
         Yd9g==
X-Gm-Message-State: AOAM531Nw67w/LDWt4uUFiaBBaZOIlNhBDHluL9eATUv4zMLLjMS3AXj
        7feIKf65Kb+v6f7FuWMw4vA=
X-Google-Smtp-Source: ABdhPJwdYUo0IRrXAgZnVFWJWAx9aSGMwEFB4DcJBI2bHSzS5j62pIOkIJinsaGQPepy2UlnKkpJVQ==
X-Received: by 2002:a17:906:3148:: with SMTP id e8mr160643eje.240.1633652585115;
        Thu, 07 Oct 2021 17:23:05 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id ke12sm308592ejc.32.2021.10.07.17.23.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 17:23:04 -0700 (PDT)
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
Subject: [net-next PATCH v2 05/15] net: dsa: qca8k: add mac_power_sel support
Date:   Fri,  8 Oct 2021 02:22:15 +0200
Message-Id: <20211008002225.2426-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211008002225.2426-1-ansuelsmth@gmail.com>
References: <20211008002225.2426-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing mac power sel support needed for some switch that requires
additional setup. ar8327 have a different setup than 8337.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 27 +++++++++++++++++++++++++++
 drivers/net/dsa/qca8k.h |  5 +++++
 2 files changed, 32 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index bda5a9bf4f52..5bce7ac4dea7 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -950,6 +950,29 @@ qca8k_setup_of_rgmii_delay(struct qca8k_priv *priv)
 	return 0;
 }
 
+static int
+qca8k_setup_mac_pwr_sel(struct qca8k_priv *priv)
+{
+	struct device_node *node = priv->dev->of_node;
+	u32 mask = 0;
+	int ret = 0;
+
+	if (of_property_read_bool(node, "qca,rgmii0-1-8v"))
+		mask |= QCA8K_MAC_PWR_RGMII0_1_8V;
+
+	if (of_property_read_bool(node, "qca,rgmii56-1-8v"))
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
@@ -979,6 +1002,10 @@ qca8k_setup(struct dsa_switch *ds)
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

