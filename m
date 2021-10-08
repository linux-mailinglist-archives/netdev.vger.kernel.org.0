Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69A2D42612B
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 02:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242928AbhJHAZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 20:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242261AbhJHAZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 20:25:00 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78C6C061764;
        Thu,  7 Oct 2021 17:23:05 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id i20so13530907edj.10;
        Thu, 07 Oct 2021 17:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=jWWBtH+wZrkZ2ctq6tn3ifU4WdTRaNlmHKqlJkhkyug=;
        b=WnWxY3WAqda0137VyHHOdDYGwrrjA7jjZHTBbu3Ai4xZhC9NZVLRJhTZlpAvBpN7n8
         raQp1K8RzWWevmVzlCMhDRyAmTA31pWZ/5j9UrBw6hRxsG10SmpEfGQVcEuGD2x7nXd1
         CQOeyU2P8Ta2/slpOfHZCz+CdEuFiho7gmuBLfnEtreLrXYMg/XgijkIh2I6UcwbeOa7
         4N8Y1Z4beaF+SLfa++7+HH0NXJN3WZmkS7oouTomsMHxKxjsp++aYmKtQ1dreS063ZUj
         ZWWY9yZyQOJAjUuott3TVYmpj4qvuX0nZJFjvzdUxvbLchtv3atruignSOHgKbvke/ai
         Ufvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jWWBtH+wZrkZ2ctq6tn3ifU4WdTRaNlmHKqlJkhkyug=;
        b=SugdCzfa0SblBUVBioeOkkhVjw/c62LJLxTrkY3pWc02sVL4tGhfn5rEO3A+pGRQKm
         C7XE7Tqx3mEK2uiVSqG3jP5k/8EaQLRDsDmOczYMQ/s6b8fmAi2xDRDGC/xM7joGf0Hf
         kpRw6T778nvCmoFAsTfO+BszP1X2IpSZUtreP3xGnldEESSkekWh0ngjnhun4dpKOVF5
         TJGQBnzTk8V/7eHOsNRfyQjMMc4F0LL2leaK7STf8OBEtwYvOuyaWiKVk2E1H+EUg98G
         Ke/Ko97GJXhoGrGSgtQnA0eJdJsqU9qX0wScnm0Xp098FC9FCl3HsMDDRSQIY0P3Gz9S
         kt2Q==
X-Gm-Message-State: AOAM531WcsqWSjuoopO+mWCLtlkmXRuN3h/3ErM7fHJLAxdR4+nLPp8Q
        DaACWFUBxMMS3C+QH9wkVvc=
X-Google-Smtp-Source: ABdhPJzAi96wM/NDyS/dDFWNlE40h4jz2ETsN6R3NZ9Rw2xfZgMN0tBDA95pr96QqbL2JBBttSJtCA==
X-Received: by 2002:a17:906:24c6:: with SMTP id f6mr151180ejb.366.1633652584111;
        Thu, 07 Oct 2021 17:23:04 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id ke12sm308592ejc.32.2021.10.07.17.23.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 17:23:03 -0700 (PDT)
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
Subject: [net-next PATCH v2 04/15] drivers: net: phy: at803x: better describe debug regs
Date:   Fri,  8 Oct 2021 02:22:14 +0200
Message-Id: <20211008002225.2426-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211008002225.2426-1-ansuelsmth@gmail.com>
References: <20211008002225.2426-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Give a name to known debug regs from Documentation instead of using
unknown hex values.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/phy/at803x.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 402b2096f209..f40f17a632ad 100644
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
@@ -100,7 +100,7 @@
 
 #define AT803X_DEBUG_REG_3C			0x3C
 
-#define AT803X_DEBUG_REG_3D			0x3D
+#define AT803X_DEBUG_REG_GREEN			0x3D
 #define   AT803X_DEBUG_GATE_CLK_IN1000		BIT(6)
 
 #define AT803X_DEBUG_REG_1F			0x1F
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
 
@@ -1300,9 +1300,9 @@ static int qca83xx_config_init(struct phy_device *phydev)
 	switch (switch_revision) {
 	case 1:
 		/* For 100M waveform */
-		at803x_debug_reg_write(phydev, AT803X_DEBUG_REG_0, 0x02ea);
+		at803x_debug_reg_write(phydev, AT803X_DEBUG_ANALOG_TEST_CTRL, 0x02ea);
 		/* Turn on Gigabit clock */
-		at803x_debug_reg_write(phydev, AT803X_DEBUG_REG_3D, 0x68a0);
+		at803x_debug_reg_write(phydev, AT803X_DEBUG_REG_GREEN, 0x68a0);
 		break;
 
 	case 2:
@@ -1310,8 +1310,8 @@ static int qca83xx_config_init(struct phy_device *phydev)
 		fallthrough;
 	case 4:
 		phy_write_mmd(phydev, MDIO_MMD_PCS, MDIO_AZ_DEBUG, 0x803f);
-		at803x_debug_reg_write(phydev, AT803X_DEBUG_REG_3D, 0x6860);
-		at803x_debug_reg_write(phydev, AT803X_DEBUG_REG_5, 0x2c46);
+		at803x_debug_reg_write(phydev, AT803X_DEBUG_REG_GREEN, 0x6860);
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
@@ -1392,7 +1392,7 @@ static int qca83xx_suspend(struct phy_device *phydev)
 		phy_modify(phydev, MII_BMCR, mask, 0);
 	}
 
-	at803x_debug_reg_mask(phydev, AT803X_DEBUG_REG_3D,
+	at803x_debug_reg_mask(phydev, AT803X_DEBUG_REG_GREEN,
 			      AT803X_DEBUG_GATE_CLK_IN1000, 0);
 
 	at803x_debug_reg_mask(phydev, AT803X_DEBUG_REG_HIB_CTRL,
-- 
2.32.0

