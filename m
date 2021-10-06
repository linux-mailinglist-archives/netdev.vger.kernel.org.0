Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 833CA4249E2
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 00:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240081AbhJFWjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 18:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239692AbhJFWi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 18:38:28 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD6FC061746;
        Wed,  6 Oct 2021 15:36:35 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id z20so15408467edc.13;
        Wed, 06 Oct 2021 15:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=fzPHyN/VWRKoUdLgfNVGZ2p3wDYQHk1zqnPMozbonEk=;
        b=L8mWL3KGfnUJ+yJBap3bXa5mvUl6uj3XBej0Zf3/1KcqXKJwg8cTi1gIYmzlZnJmGn
         YSdwgexVbOPpo54sgbtN4aIXvB0z28iBlvJ13Tb+y6hNDFRYtiJSMd/i/zy4Ib0oSimO
         EUoLDItOd1eC/PK9ZoF9ZoYTVAFcPRfLa8VUejwxk2KFj3X6kvtW/JHteUEeDzpX5UJt
         rucbsBr6fz6ehQ1TW2VfY1ftZpqFqMVM5dl4qm6i/NgSrZghV72anqxbHXNc8E/CV0fd
         zJF23CgrkWRYO56fKqS6gy1Brf+vSOFvrGGjt8NVl9SDAmTNAjrVl8mKJGoG6apuQ2wF
         dSsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fzPHyN/VWRKoUdLgfNVGZ2p3wDYQHk1zqnPMozbonEk=;
        b=OEosEpAhtz1XiRikkzEZoK22rd48kG4GEedaouTwMlanRYi+TPNEETfqBc/e7OzD9V
         W/cG6XM1Oajhd3fUuX7rt9LErVV/xEAsDsYNS05r9AofkRSFGp/NwEFrakb6iig2JlCE
         eJIcBtBkW6kIY8KhAjnrTGepp+tKRDn71ws8Vge7V7e0QQlMmKXdXZZXYCeXHMv+zOg9
         C2vu9bD/taqAkWEmNi/h3x42WfOo4ge1J9JquZ9SHFNrfE7AKRV3RcXD1j7jfg4iRuO7
         fg2g2rsN0bfjp88O5JGCAWLN2pYTr1xVPpPJMidEiSzCqIDUwRnAGKHPZzWtDKcj+orj
         4rXw==
X-Gm-Message-State: AOAM5311cCdN+kTkLt4ifhvzadVWngLOo3AoJULFqmzrbBnLpO4R+6RP
        iPxZ5WT/gDU40KOry9J+yiE=
X-Google-Smtp-Source: ABdhPJw1PWomhZfrvnfINaV7KjT3rS4cauVpFOzMVaBJ86Bx2e2puHFM2iJeLxeoKcrMMfZ9CFGJBg==
X-Received: by 2002:a17:906:2cd6:: with SMTP id r22mr1110467ejr.398.1633559793781;
        Wed, 06 Oct 2021 15:36:33 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id z8sm9462678ejd.94.2021.10.06.15.36.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 15:36:33 -0700 (PDT)
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
Subject: [net-next PATCH 05/13] net: dsa: qca8k: add mac_power_sel support
Date:   Thu,  7 Oct 2021 00:35:55 +0200
Message-Id: <20211006223603.18858-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211006223603.18858-1-ansuelsmth@gmail.com>
References: <20211006223603.18858-1-ansuelsmth@gmail.com>
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

