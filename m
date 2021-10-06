Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80B3A4249C8
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 00:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239865AbhJFWif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 18:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239686AbhJFWi1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 18:38:27 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4773FC061753;
        Wed,  6 Oct 2021 15:36:34 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id v18so15528432edc.11;
        Wed, 06 Oct 2021 15:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=/CIPRmzb6ZyUl4M4QyOCrm9NUv5uQgk5oWps89iR9OQ=;
        b=pBAp5caXt4AsK/X9WuW1cSfkRaPGh0pBBt65aiFHBonTqDZrduanp1t4K2sJzrn+Df
         qhqLiRXdViUy6gnWBPzl13Fi8IaTeNzAFQtRvxbjC5ZFD2xqk0c7XYFfYqUAUxT5s/ts
         +GwqwLLkldYZvidSpNT46cl1jm0rPHFIKa0RFcuhyY3rsivqfWCus0/CJne891Yd6FfY
         lELEnNkfBjXI+fdvJkBaBYfg0FlXm0PJOgt1bkknPQgOeqvow7GBtVEpUh9zE4mUfFzq
         ZihLYHCgrcKOsnEvWYwe2xVGE7Izngc7VhugXTk2a3YFGmrly74JgIRROXnGGvO4MGSi
         nhjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/CIPRmzb6ZyUl4M4QyOCrm9NUv5uQgk5oWps89iR9OQ=;
        b=IVWoGzwJUOK8VPH7fWDF0STTto5xi67NgsMoTXvLdtC/PCSbvp5KolDHtnkRWsvvRn
         9waXHQM+H0w2r5jdpamc2e55r3qjl/bakSXze9ZSmufy0FNCF/EMyvnM2p1wLq7WYpJ3
         cqQnRMXsoCO6JbNxR6NWjPKOvl1Jmb9RkOmfljGFCAB0UrKMq8hnv1+38AB0lfCFiqKn
         Clx+wM/MPjaU0WHRQE+fgGOJ2Ba69tjpKpI7PKVVCRwcO2vbdzqy1DT0kY8TWWhd7+yX
         MxEp3wMcl1DMqLROd5f2H3DSvWs5Isy25QYt+ggu144XcYObj/7YYBz6z2QxZedb2hFP
         RRow==
X-Gm-Message-State: AOAM532ze36cjPxNeE4KJepaDUyTDABgJoUJkNhbLIY0LxfaGtwUoCnR
        dHIud//Htq8M2JO1xP7ib30=
X-Google-Smtp-Source: ABdhPJyaXa8l7MGQdSa2wKvjGkXdp5iSzOPp0HiTMRas5ukG2uqEeGp/EFlJf48DG4gHxEfTUyjCtw==
X-Received: by 2002:a50:fc8e:: with SMTP id f14mr1212078edq.87.1633559792785;
        Wed, 06 Oct 2021 15:36:32 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id z8sm9462678ejd.94.2021.10.06.15.36.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 15:36:32 -0700 (PDT)
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
Subject: [net-next PATCH 04/13] drivers: net: phy: at803x: better describe debug regs
Date:   Thu,  7 Oct 2021 00:35:54 +0200
Message-Id: <20211006223603.18858-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211006223603.18858-1-ansuelsmth@gmail.com>
References: <20211006223603.18858-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Give a name to known debug regs from Documentation instead of using
unknown hex values.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/phy/at803x.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 851d47b8a331..f40f17a632ad 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -86,12 +86,12 @@
 #define AT803X_PSSR				0x11	/*PHY-Specific Status Register*/
 #define AT803X_PSSR_MR_AN_COMPLETE		0x0200
 
-#define AT803X_DEBUG_REG_0			0x00
+#define AT803X_DEBUG_ANALOG_TEST_CTRL		0x00
 #define QCA8327_DEBUG_MANU_CTRL_EN		BIT(2)
 #define QCA8337_DEBUG_MANU_CTRL_EN		GENMASK(3, 2)
 #define AT803X_DEBUG_RX_CLK_DLY_EN		BIT(15)
 
-#define AT803X_DEBUG_REG_5			0x05
+#define AT803X_DEBUG_SYSTEM_CTRL_MODE		0x05
 #define AT803X_DEBUG_TX_CLK_DLY_EN		BIT(8)
 
 #define AT803X_DEBUG_REG_HIB_CTRL		0x0b
@@ -284,25 +284,25 @@ static int at803x_read_page(struct phy_device *phydev)
 
 static int at803x_enable_rx_delay(struct phy_device *phydev)
 {
-	return at803x_debug_reg_mask(phydev, AT803X_DEBUG_REG_0, 0,
+	return at803x_debug_reg_mask(phydev, AT803X_DEBUG_ANALOG_TEST_CTRL, 0,
 				     AT803X_DEBUG_RX_CLK_DLY_EN);
 }
 
 static int at803x_enable_tx_delay(struct phy_device *phydev)
 {
-	return at803x_debug_reg_mask(phydev, AT803X_DEBUG_REG_5, 0,
+	return at803x_debug_reg_mask(phydev, AT803X_DEBUG_SYSTEM_CTRL_MODE, 0,
 				     AT803X_DEBUG_TX_CLK_DLY_EN);
 }
 
 static int at803x_disable_rx_delay(struct phy_device *phydev)
 {
-	return at803x_debug_reg_mask(phydev, AT803X_DEBUG_REG_0,
+	return at803x_debug_reg_mask(phydev, AT803X_DEBUG_ANALOG_TEST_CTRL,
 				     AT803X_DEBUG_RX_CLK_DLY_EN, 0);
 }
 
 static int at803x_disable_tx_delay(struct phy_device *phydev)
 {
-	return at803x_debug_reg_mask(phydev, AT803X_DEBUG_REG_5,
+	return at803x_debug_reg_mask(phydev, AT803X_DEBUG_SYSTEM_CTRL_MODE,
 				     AT803X_DEBUG_TX_CLK_DLY_EN, 0);
 }
 
@@ -1300,7 +1300,7 @@ static int qca83xx_config_init(struct phy_device *phydev)
 	switch (switch_revision) {
 	case 1:
 		/* For 100M waveform */
-		at803x_debug_reg_write(phydev, AT803X_DEBUG_REG_0, 0x02ea);
+		at803x_debug_reg_write(phydev, AT803X_DEBUG_ANALOG_TEST_CTRL, 0x02ea);
 		/* Turn on Gigabit clock */
 		at803x_debug_reg_write(phydev, AT803X_DEBUG_REG_GREEN, 0x68a0);
 		break;
@@ -1311,7 +1311,7 @@ static int qca83xx_config_init(struct phy_device *phydev)
 	case 4:
 		phy_write_mmd(phydev, MDIO_MMD_PCS, MDIO_AZ_DEBUG, 0x803f);
 		at803x_debug_reg_write(phydev, AT803X_DEBUG_REG_GREEN, 0x6860);
-		at803x_debug_reg_write(phydev, AT803X_DEBUG_REG_5, 0x2c46);
+		at803x_debug_reg_write(phydev, AT803X_DEBUG_SYSTEM_CTRL_MODE, 0x2c46);
 		at803x_debug_reg_write(phydev, AT803X_DEBUG_REG_3C, 0x6000);
 		break;
 	}
@@ -1322,7 +1322,7 @@ static int qca83xx_config_init(struct phy_device *phydev)
 	 */
 	if (phydev->drv->phy_id == QCA8327_A_PHY_ID ||
 	    phydev->drv->phy_id == QCA8327_B_PHY_ID)
-		at803x_debug_reg_mask(phydev, AT803X_DEBUG_REG_0,
+		at803x_debug_reg_mask(phydev, AT803X_DEBUG_ANALOG_TEST_CTRL,
 				      QCA8327_DEBUG_MANU_CTRL_EN, 0);
 
 	/* Following original QCA sourcecode set port to prefer master */
@@ -1340,12 +1340,12 @@ static void qca83xx_link_change_notify(struct phy_device *phydev)
 	/* Set DAC Amplitude adjustment to +6% for 100m on link running */
 	if (phydev->state == PHY_RUNNING) {
 		if (phydev->speed == SPEED_100)
-			at803x_debug_reg_mask(phydev, AT803X_DEBUG_REG_0,
+			at803x_debug_reg_mask(phydev, AT803X_DEBUG_ANALOG_TEST_CTRL,
 					      QCA8327_DEBUG_MANU_CTRL_EN,
 					      QCA8327_DEBUG_MANU_CTRL_EN);
 	} else {
 		/* Reset DAC Amplitude adjustment */
-		at803x_debug_reg_mask(phydev, AT803X_DEBUG_REG_0,
+		at803x_debug_reg_mask(phydev, AT803X_DEBUG_ANALOG_TEST_CTRL,
 				      QCA8327_DEBUG_MANU_CTRL_EN, 0);
 	}
 }
-- 
2.32.0

