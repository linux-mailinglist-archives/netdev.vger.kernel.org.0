Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE0029E898
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 11:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgJ2KKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 06:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726743AbgJ2KIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 06:08:55 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8539C0613D3;
        Thu, 29 Oct 2020 03:08:53 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id dk16so2407212ejb.12;
        Thu, 29 Oct 2020 03:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4c3y7mYHvBKW0XrZqrRuVJn6e5rCazgTqbTaRv1N11g=;
        b=oMNW+UEmTl13c0tinc2JX5h7iaIQtM6dmq0tjXWQJm9SAKT9+2bkb2hZw3iGiWW9J2
         BBQgf/vIQi5YSu4dC7mTgW6Hv4rVDZhKqyALTgUBreMR0mAd+JBNhrma35xskRmra+sd
         qY3LL2rNbjRe4WHyXkJoKD8JiRwcOL3zEJSK7FIzJBH1cHO8i52YURI8N1c7HMlyGt/6
         YaTYhZ+0dSqLkenxxUIqOarnKvjR9deU73ENlMmcqlhF7jvE2l2g00JvioqhNJtCC+sJ
         1BQG9n4OBZeY9o89WdI6HyrRa/zjNXEoupJuEnMQmM73vfm5yH8wROFaRhaQa04+2cdt
         SHpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4c3y7mYHvBKW0XrZqrRuVJn6e5rCazgTqbTaRv1N11g=;
        b=KQmG2RfoPWJP+LC1CqPVGaTc/qijgGG4nFp8OuV1me69tkZHWmHT2ydfRk4R6jqxb0
         0vBzcSfAE/zNKfTKDBKJrs0H1FB791PhXVs/3mK+ufdXfPPh6KP8B4eIVusPXs/mrxVl
         shIrud/2Ftd+9GjxY+mgZ8ThLbUXJjI9TPhk3xSegqg6d19kcn6fk0isTN7zqgwHn1r6
         BVMe7xHxmy+Hw+HS9n40NuKNNkIH/siLFNjnsoaa1R37L79W5FszV+K26xPshbDgiyC5
         UEA3h5yHxsD/i6rDS3eiSxZHgDDbu9lDsdlGuthON13UutfR8taAFw27I5MuilDqhko5
         eHdg==
X-Gm-Message-State: AOAM531a2qTyJsAYbaH5h+VT7DFmV3oFEY70VTp4B0+yoQD48l27Z/ep
        A+Z6TJWl0qlIF9LbKJi9Sdo=
X-Google-Smtp-Source: ABdhPJw4965KgxwbVDt3uKWMqiAQ1q78RsFXN9I9Jz8pIspsb5dvoIznyOVcBhC6qZB4pIigVKOFmA==
X-Received: by 2002:a17:906:b043:: with SMTP id bj3mr3148729ejb.543.1603966132662;
        Thu, 29 Oct 2020 03:08:52 -0700 (PDT)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id m1sm1198650ejj.117.2020.10.29.03.08.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 03:08:52 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 10/19] net: phy: aquantia: remove the use of .ack_interrupt()
Date:   Thu, 29 Oct 2020 12:07:32 +0200
Message-Id: <20201029100741.462818-11-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201029100741.462818-1-ciorneiioana@gmail.com>
References: <20201029100741.462818-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

In preparation of removing the .ack_interrupt() callback, we must replace
its occurrences (aka phy_clear_interrupt), from the 2 places where it is
called from (phy_enable_interrupts and phy_disable_interrupts), with
equivalent functionality.

This means that clearing interrupts now becomes something that the PHY
driver is responsible of doing, before enabling interrupts and after
clearing them. Make this driver follow the new contract.

Cc: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/aquantia_main.c | 36 +++++++++++++++++----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index e7f315898efb..287178340625 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -246,6 +246,13 @@ static int aqr_config_intr(struct phy_device *phydev)
 	bool en = phydev->interrupts == PHY_INTERRUPT_ENABLED;
 	int err;
 
+	if (en) {
+		/* Clear any pending interrupts before enabling them */
+		err = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_TX_VEND_INT_STATUS2);
+		if (err)
+			return err;
+	}
+
 	err = phy_write_mmd(phydev, MDIO_MMD_AN, MDIO_AN_TX_VEND_INT_MASK2,
 			    en ? MDIO_AN_TX_VEND_INT_MASK2_LINK : 0);
 	if (err < 0)
@@ -256,18 +263,20 @@ static int aqr_config_intr(struct phy_device *phydev)
 	if (err < 0)
 		return err;
 
-	return phy_write_mmd(phydev, MDIO_MMD_VEND1, VEND1_GLOBAL_INT_VEND_MASK,
-			     en ? VEND1_GLOBAL_INT_VEND_MASK_GLOBAL3 |
-			     VEND1_GLOBAL_INT_VEND_MASK_AN : 0);
-}
+	err = phy_write_mmd(phydev, MDIO_MMD_VEND1, VEND1_GLOBAL_INT_VEND_MASK,
+			    en ? VEND1_GLOBAL_INT_VEND_MASK_GLOBAL3 |
+			    VEND1_GLOBAL_INT_VEND_MASK_AN : 0);
+	if (err < 0)
+		return err;
 
-static int aqr_ack_interrupt(struct phy_device *phydev)
-{
-	int reg;
+	if (!en) {
+		/* Clear any pending interrupts after we have disabled them */
+		err = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_TX_VEND_INT_STATUS2);
+		if (err)
+			return err;
+	}
 
-	reg = phy_read_mmd(phydev, MDIO_MMD_AN,
-			   MDIO_AN_TX_VEND_INT_STATUS2);
-	return (reg < 0) ? reg : 0;
+	return 0;
 }
 
 static irqreturn_t aqr_handle_interrupt(struct phy_device *phydev)
@@ -602,7 +611,6 @@ static struct phy_driver aqr_driver[] = {
 	.name		= "Aquantia AQ1202",
 	.config_aneg    = aqr_config_aneg,
 	.config_intr	= aqr_config_intr,
-	.ack_interrupt	= aqr_ack_interrupt,
 	.handle_interrupt = aqr_handle_interrupt,
 	.read_status	= aqr_read_status,
 },
@@ -611,7 +619,6 @@ static struct phy_driver aqr_driver[] = {
 	.name		= "Aquantia AQ2104",
 	.config_aneg    = aqr_config_aneg,
 	.config_intr	= aqr_config_intr,
-	.ack_interrupt	= aqr_ack_interrupt,
 	.handle_interrupt = aqr_handle_interrupt,
 	.read_status	= aqr_read_status,
 },
@@ -620,7 +627,6 @@ static struct phy_driver aqr_driver[] = {
 	.name		= "Aquantia AQR105",
 	.config_aneg    = aqr_config_aneg,
 	.config_intr	= aqr_config_intr,
-	.ack_interrupt	= aqr_ack_interrupt,
 	.handle_interrupt = aqr_handle_interrupt,
 	.read_status	= aqr_read_status,
 	.suspend	= aqr107_suspend,
@@ -631,7 +637,6 @@ static struct phy_driver aqr_driver[] = {
 	.name		= "Aquantia AQR106",
 	.config_aneg    = aqr_config_aneg,
 	.config_intr	= aqr_config_intr,
-	.ack_interrupt	= aqr_ack_interrupt,
 	.handle_interrupt = aqr_handle_interrupt,
 	.read_status	= aqr_read_status,
 },
@@ -642,7 +647,6 @@ static struct phy_driver aqr_driver[] = {
 	.config_init	= aqr107_config_init,
 	.config_aneg    = aqr_config_aneg,
 	.config_intr	= aqr_config_intr,
-	.ack_interrupt	= aqr_ack_interrupt,
 	.handle_interrupt = aqr_handle_interrupt,
 	.read_status	= aqr107_read_status,
 	.get_tunable    = aqr107_get_tunable,
@@ -661,7 +665,6 @@ static struct phy_driver aqr_driver[] = {
 	.config_init	= aqcs109_config_init,
 	.config_aneg    = aqr_config_aneg,
 	.config_intr	= aqr_config_intr,
-	.ack_interrupt	= aqr_ack_interrupt,
 	.handle_interrupt = aqr_handle_interrupt,
 	.read_status	= aqr107_read_status,
 	.get_tunable    = aqr107_get_tunable,
@@ -678,7 +681,6 @@ static struct phy_driver aqr_driver[] = {
 	.name		= "Aquantia AQR405",
 	.config_aneg    = aqr_config_aneg,
 	.config_intr	= aqr_config_intr,
-	.ack_interrupt	= aqr_ack_interrupt,
 	.handle_interrupt = aqr_handle_interrupt,
 	.read_status	= aqr_read_status,
 },
-- 
2.28.0

