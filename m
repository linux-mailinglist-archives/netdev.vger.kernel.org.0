Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 107B0426122
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 02:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242710AbhJHAZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 20:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242497AbhJHAZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 20:25:03 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88CEEC06176A;
        Thu,  7 Oct 2021 17:23:08 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id y12so16318831eda.4;
        Thu, 07 Oct 2021 17:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=USBq3mBDytFzvMpNFzB7I53AgldzT9pGMAwrnP8ri/M=;
        b=VWZTTbiJNeU8R7qBvRowwRBG44FXdSoEQg0dNuhrDhW9F8JuZskLCKc7l91cOY/a5a
         /PwG8WErO/sHpB31cPbpT8QU+t7h5KasK++qtAQI9cI6hupXmnybX3z6eTn7dtd68bp+
         pxPDuOsMupqoNrZ9MC3fwjs9agttzhRfZTwyzSFO6x7B/Uka2XuX3PXk/Cb/6fX39Vkc
         9Jt8lXkgDKEdH0gbztcNpnMSHQa+U9qm/oZC5tXwoUX0lc5eybjI/VZsBKNQFyKxRvv8
         UmywySH2IvBSVOR8IHn+6bJDsVTX7BKDU2b1VddeOn6g12cTRyLTP8nHZO6n5U9vxtNu
         KlmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=USBq3mBDytFzvMpNFzB7I53AgldzT9pGMAwrnP8ri/M=;
        b=lk5JKWzizEnI00+YVIA30ujHt2vyTXU+UiWiXmycuT116xX8xz1N3T9xMI7l8FsZc8
         mZ3AL4p6s2UulUCvMsy/Oqs+rJ9+8G6BmuGYFR+GbhEEoveZ846+GyGk200D/1+6wKlN
         XuB07yIGdzZqv7iGa5aJnu7CdHXVcmCKQhKmlHZqH1ECGg+ci4sUrnRsyS7/1XNJk2mS
         qMwTgEBi+U3fM8YSsbXTsdObP2G7lLx2xI11KxVpda9hOH84C6idXKn79/GXYtnomtFx
         gZHbj6efcZjlODyVIs1fk1caOuA6luob1I4dBl9ubltcTrmJL+B984tEHzLuzPa3UlmS
         krdQ==
X-Gm-Message-State: AOAM532pDrhaEal09YLraV+NOhOtZrU5S9JeplWjyyZHZYwhXsaTjnIE
        ggpdmEJijMwOakcBmLYsmw4=
X-Google-Smtp-Source: ABdhPJyH2M+r5qpQKz2JGLX1qgvghOiFWJmyfSmwmk9BHy2BARE1cUGhFUXIPIlrXT+WKlsSBNv2lA==
X-Received: by 2002:a05:6402:2793:: with SMTP id b19mr10462345ede.80.1633652587071;
        Thu, 07 Oct 2021 17:23:07 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id ke12sm308592ejc.32.2021.10.07.17.23.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 17:23:06 -0700 (PDT)
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
Cc:     Matthew Hagan <mnhagan88@gmail.com>
Subject: [net-next PATCH v2 07/15] net: dsa: qca8k: add support for mac6_exchange, sgmii falling edge
Date:   Fri,  8 Oct 2021 02:22:17 +0200
Message-Id: <20211008002225.2426-8-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211008002225.2426-1-ansuelsmth@gmail.com>
References: <20211008002225.2426-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some device set the switch to exchange the mac0 port with mac6 port. Add
support for this in the qca8k driver. Also add support for SGMII rx/tx
clock falling edge. This is only present for pad0, pad5 and pad6 have
these bit reserved from Documentation.

Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 33 +++++++++++++++++++++++++++++++++
 drivers/net/dsa/qca8k.h |  3 +++
 2 files changed, 36 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 5bce7ac4dea7..3a040a3ed58e 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -973,6 +973,34 @@ qca8k_setup_mac_pwr_sel(struct qca8k_priv *priv)
 	return ret;
 }
 
+static int
+qca8k_setup_port0_pad_ctrl_reg(struct qca8k_priv *priv)
+{
+	struct device_node *node = priv->dev->of_node;
+	u32 mask = 0;
+	int ret = 0;
+
+	/* Swap MAC0-MAC6 */
+	if (of_property_read_bool(node, "qca,mac6-exchange"))
+		mask |= QCA8K_PORT0_PAD_CTRL_MAC06_EXCHG;
+
+	/* SGMII Clock phase configuration */
+	if (of_property_read_bool(node, "qca,sgmii-rxclk-falling-edge"))
+		mask |= QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE;
+
+	if (of_property_read_bool(node, "qca,sgmii-txclk-falling-edge"))
+		mask |= QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE;
+
+	if (mask)
+		ret = qca8k_rmw(priv, QCA8K_REG_PORT0_PAD_CTRL,
+				QCA8K_PORT0_PAD_CTRL_MAC06_EXCHG |
+				QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE |
+				QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE,
+				mask);
+
+	return ret;
+}
+
 static int
 qca8k_setup(struct dsa_switch *ds)
 {
@@ -1006,6 +1034,11 @@ qca8k_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
+	/* Configure additional PORT0_PAD_CTRL properties */
+	ret = qca8k_setup_port0_pad_ctrl_reg(priv);
+	if (ret)
+		return ret;
+
 	/* Enable CPU Port */
 	ret = qca8k_reg_set(priv, QCA8K_REG_GLOBAL_FW_CTRL0,
 			    QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN);
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index fc7db94cc0c9..3fded69a6839 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -35,6 +35,9 @@
 #define   QCA8K_MASK_CTRL_DEVICE_ID_MASK		GENMASK(15, 8)
 #define   QCA8K_MASK_CTRL_DEVICE_ID(x)			((x) >> 8)
 #define QCA8K_REG_PORT0_PAD_CTRL			0x004
+#define   QCA8K_PORT0_PAD_CTRL_MAC06_EXCHG		BIT(31)
+#define   QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE	BIT(19)
+#define   QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE	BIT(18)
 #define QCA8K_REG_PORT5_PAD_CTRL			0x008
 #define QCA8K_REG_PORT6_PAD_CTRL			0x00c
 #define   QCA8K_PORT_PAD_RGMII_EN			BIT(26)
-- 
2.32.0

