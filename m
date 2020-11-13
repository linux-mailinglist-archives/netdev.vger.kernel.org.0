Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E412B2110
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgKMQyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:54:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbgKMQwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 11:52:54 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F12C0617A6;
        Fri, 13 Nov 2020 08:52:53 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id cw8so14397084ejb.8;
        Fri, 13 Nov 2020 08:52:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f7DDtazpnBZl5OQRGoKgmgElvXFLhF6bESa6gSu809g=;
        b=job3IM+AT1K2OzAvgg2qNUnnIvnNIbZX5fDvymu3WHOIMyFsvf76+JUSoeP0Saewje
         yi6nkUB6rQz70+W3vPOtiuSF2+n0IScHIGJyoxnG9e0smh6w9ca+1XBl0PLd0Z5lFljj
         ZFfV/tH9GwSkQPz6o/xmu/V4ZGJBlURPm3oVGfrWSF5FNCrlhQPwf4LX3cMXdt5HWgSH
         DZ4a1i22dSJnICpj6ZmSduZt89IxAot9f6ecC5mripUDY++vLVCCMgivUaBoOXNFeDVO
         YEWObrU0wPPtxM5tDVdMX1mjfXQmqwHXBJK5m8qpT1xyQlMQeShHuFn6N/xqSEQJ+5oo
         oF+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f7DDtazpnBZl5OQRGoKgmgElvXFLhF6bESa6gSu809g=;
        b=bRdvC8KULcRXLSjQiWc54J3I/Ic2gG8NLHqs1cdaa5DX2QPlGUv8zDy2dvtaMdMVrA
         0PzLIdvFbQtfzU7Yp3eUgE2vPpRFeUXBXI2dWD4l+PBpkTYXLVFxeVWbBe9qtkKUII8a
         w5wCMkXOKRTUcn3FQvgVO5II5rxXI2JyraPktCOAsU5J6E+DeOEcmT7t2YJ1LQf6q5et
         OmajhEFHeUr42B7lEhIAxIvyS2aZMpBzW8dC8EeUAqbnNt9Cl2+HU3PwH3GVwHzoYrzV
         PhdFhLlZjBPS7XnekfFqKkZ869S/i24VKsEeATbEV/vD5JfB+dpO/6HZwky9yNFsZOwB
         Xkaw==
X-Gm-Message-State: AOAM531g4VNvaVB4c79jl5YM0+rpQk5HJLgUQZdI0d46mwfffHAF7JYJ
        ewpA+WI96PQqZ7OnfNlW7ABBZq+UL3kE0A==
X-Google-Smtp-Source: ABdhPJzHc1qHN9n6vBEIyDY0zy2WI109Wd4K9SjxePhRSOfa1bTsDnMVTGXrCG6sNXxTZsQn4UgPOg==
X-Received: by 2002:a17:906:26c7:: with SMTP id u7mr2849817ejc.96.1605286371956;
        Fri, 13 Nov 2020 08:52:51 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id rp28sm4076570ejb.77.2020.11.13.08.52.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 08:52:51 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Nisar Sayed <Nisar.Sayed@microchip.com>,
        Yuiko Oshino <yuiko.oshino@microchip.com>
Subject: [PATCH RESEND net-next 04/18] net: phy: microchip: remove the use of .ack_interrupt()
Date:   Fri, 13 Nov 2020 18:52:12 +0200
Message-Id: <20201113165226.561153-5-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201113165226.561153-1-ciorneiioana@gmail.com>
References: <20201113165226.561153-1-ciorneiioana@gmail.com>
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

Cc: Nisar Sayed <Nisar.Sayed@microchip.com>
Cc: Yuiko Oshino <yuiko.oshino@microchip.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/microchip.c    | 13 +++++--------
 drivers/net/phy/microchip_t1.c | 17 +++++++----------
 2 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/net/phy/microchip.c b/drivers/net/phy/microchip.c
index b472a2149f08..9f1f2b6c97d4 100644
--- a/drivers/net/phy/microchip.c
+++ b/drivers/net/phy/microchip.c
@@ -44,14 +44,12 @@ static int lan88xx_phy_config_intr(struct phy_device *phydev)
 			       LAN88XX_INT_MASK_LINK_CHANGE_);
 	} else {
 		rc = phy_write(phydev, LAN88XX_INT_MASK, 0);
-	}
-
-	return rc < 0 ? rc : 0;
-}
+		if (rc)
+			return rc;
 
-static int lan88xx_phy_ack_interrupt(struct phy_device *phydev)
-{
-	int rc = phy_read(phydev, LAN88XX_INT_STS);
+		/* Ack interrupts after they have been disabled */
+		rc = phy_read(phydev, LAN88XX_INT_STS);
+	}
 
 	return rc < 0 ? rc : 0;
 }
@@ -358,7 +356,6 @@ static struct phy_driver microchip_phy_driver[] = {
 	.config_init	= lan88xx_config_init,
 	.config_aneg	= lan88xx_config_aneg,
 
-	.ack_interrupt	= lan88xx_phy_ack_interrupt,
 	.config_intr	= lan88xx_phy_config_intr,
 	.handle_interrupt = lan88xx_handle_interrupt,
 
diff --git a/drivers/net/phy/microchip_t1.c b/drivers/net/phy/microchip_t1.c
index 04cda8865deb..4dc00bd5a8d2 100644
--- a/drivers/net/phy/microchip_t1.c
+++ b/drivers/net/phy/microchip_t1.c
@@ -189,16 +189,14 @@ static int lan87xx_phy_config_intr(struct phy_device *phydev)
 		rc = phy_write(phydev, LAN87XX_INTERRUPT_MASK, 0x7FFF);
 		rc = phy_read(phydev, LAN87XX_INTERRUPT_SOURCE);
 		val = LAN87XX_MASK_LINK_UP | LAN87XX_MASK_LINK_DOWN;
-	}
-
-	rc = phy_write(phydev, LAN87XX_INTERRUPT_MASK, val);
-
-	return rc < 0 ? rc : 0;
-}
+		rc = phy_write(phydev, LAN87XX_INTERRUPT_MASK, val);
+	} else {
+		rc = phy_write(phydev, LAN87XX_INTERRUPT_MASK, val);
+		if (rc)
+			return rc;
 
-static int lan87xx_phy_ack_interrupt(struct phy_device *phydev)
-{
-	int rc = phy_read(phydev, LAN87XX_INTERRUPT_SOURCE);
+		rc = phy_read(phydev, LAN87XX_INTERRUPT_SOURCE);
+	}
 
 	return rc < 0 ? rc : 0;
 }
@@ -238,7 +236,6 @@ static struct phy_driver microchip_t1_phy_driver[] = {
 
 		.config_init	= lan87xx_config_init,
 
-		.ack_interrupt  = lan87xx_phy_ack_interrupt,
 		.config_intr    = lan87xx_phy_config_intr,
 		.handle_interrupt = lan87xx_handle_interrupt,
 
-- 
2.28.0

