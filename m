Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA65427DF8
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 00:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbhJIWsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 18:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbhJIWsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 18:48:30 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC35C061762;
        Sat,  9 Oct 2021 15:46:32 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id g8so50954043edt.7;
        Sat, 09 Oct 2021 15:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PU/BRwwO7gA0CJ8tiOcNIpgU+bIB6NLlMgIvw5Lst8o=;
        b=p/AZeaGwLoeehQlG6y7nficdxyJXYUe/bRQyCGo2vhVd09n3MS0xkOgIoi8Bon7s0V
         KPf4DqmzltPtuctEYhRtjjIP6m91Fri4u/v+zD9RZWQWzemGMfyumJv+vef6V8Ii8tpi
         1vt/aFY2jrh7e2hlFZPgSka6ibOlLkf2wqk+pEnNhnfZPAlEp1eQByT9+VpokMpW7UzE
         kW7/Hr1YzziC4kKAjDcjLnU1yEKCb5SyHIPxrwkRt6Pgd9RqPi0epfarShKMRO7Gveih
         ZsnjCBypa3bg2pln7mdnpvNqzCOZ7EUwOwXgGeMS54o0Jgj1wLsyco9pYe8FeuT1GS6v
         K/Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PU/BRwwO7gA0CJ8tiOcNIpgU+bIB6NLlMgIvw5Lst8o=;
        b=Bo6KT8OJNTdNBOvW8RWHc1MUCZqBryKnl6HOhra5JXmwkKe38W2HRDc7yKdjYk5E9O
         msQyeGnBJHBKrCikHPyI+P+UEyRG9LnpBgxJ06U4PyMY5eNmjdTYSrEEvRh2g8DNV1d9
         p2zPrZfBpuoDeggzZ0xZcIktoWLnwfRKt8hL7mRvM4l7SfaPKl7SdNc5oSmfSXv5xQJV
         Rr+d/xjNTytiBOmybTn+MhpwSJmWbnN4bW7VHpY9Sl//D+gZVUQmfbozm6mSDhmhkRdI
         HxhBFO57JVijTodP80jt96xqXClBFxETdIqKI5xXut4kXARrb6LfdR+z6Gz9O7RpH8HQ
         RJeQ==
X-Gm-Message-State: AOAM533LTHsr/JD5jQtQ/4nricAL7BgfeoWWkOl/wgsbxRyCkW/t7Mop
        ATf38SuxFLWZy8bejwpTn88=
X-Google-Smtp-Source: ABdhPJwph8+m+uUd25VX5KJa4ssD2Tl9fr6zeHWuawo4FcPaj0lsLN2r/sEIEudr9MKf/HgtgLBwIw==
X-Received: by 2002:a50:fc8e:: with SMTP id f14mr27709508edq.87.1633819591210;
        Sat, 09 Oct 2021 15:46:31 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id l13sm1727115eds.92.2021.10.09.15.46.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 15:46:30 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH 4/4] net: phy: at803x: better describe debug regs
Date:   Sun, 10 Oct 2021 00:46:18 +0200
Message-Id: <20211009224618.4988-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211009224618.4988-1-ansuelsmth@gmail.com>
References: <20211009224618.4988-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Give a name to known debug regs from Documentation instead of using
unknown hex values.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
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

