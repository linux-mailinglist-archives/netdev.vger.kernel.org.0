Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 808D12B0956
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 17:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbgKLP6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:58:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728808AbgKLP6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 10:58:22 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6CAC0613D4;
        Thu, 12 Nov 2020 07:58:22 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id 7so8580124ejm.0;
        Thu, 12 Nov 2020 07:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f7DDtazpnBZl5OQRGoKgmgElvXFLhF6bESa6gSu809g=;
        b=c6e1q4vwaP/iCk5qABhkNv63Qz/kcEXz2xSawVV2SnVd+90QIodzRet1//Qf3gVPow
         S4b/g0cpAS5++oGcJOZyAJq71ksgcth48BSlPDcC+XTVKqcABQNWCic8m4Px1lW7Uz5L
         ixAVwaClbKKSwPHFM2pieCun0Jy+/VZkPVKJT+HVBb/sibh/Y4lppecYM+Tm8UcdgvQk
         JPP5R3Ebz8L6e1XK09dCS/kI+bonzC8VzsVeL7DdR8Cz4fc2p6nKaNRtvTMufnkyZ7QE
         +H5LH/kSbR9dsll5ZHZVOGv7CDS/1FzjTVRGzReF/OWg5xCJK24nI0Myzd6XWU5Ruu8N
         +h8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f7DDtazpnBZl5OQRGoKgmgElvXFLhF6bESa6gSu809g=;
        b=iyJm3uIGNNRIG9dR6b2fENgCaxwADSQVK2CmmOvtIDiUXbXxN0AMFTjnfS7ONQL0fe
         ltouzVIs1NyNLJ2Yoap7/1B/uU+BDYkYbIoXrz8TuZwn61gkdSGIYNJelAWz+CAG4GN4
         4RR2RQTt6n2qZFkKnfZlKyo3Fibm96kFQsU5LO4JbGl/rNSeou4WFzhISg6vP8iGWwUh
         HGMOiy4HnCuSYo+AefEqkd6xK4iXSTF+Gux2BSEOZq+R+YexvQT/DEyAOdjy3PPATyPE
         WjByhjAKDanRfMgY7I+3pbuSmFcqQTr1KDrpS0VWAoyybYsUrrNH2+nBOrz0cvW5kruf
         xpbw==
X-Gm-Message-State: AOAM530FHGW50O1KZIxJEAnvx7QkPe7RGPLKCALoPbSjCPyGI5zPkxoU
        aWCkhKJHE0cyU++D3sialxk=
X-Google-Smtp-Source: ABdhPJxrbcSL2qdQ20esbKW1hIcXYsKWdzUZ5Z2eDv7AqvF1j5TE5idwh6dNNkatWu3CIN7cFaQjnw==
X-Received: by 2002:a17:906:7c4a:: with SMTP id g10mr30501253ejp.545.1605196701088;
        Thu, 12 Nov 2020 07:58:21 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id q15sm2546540edt.95.2020.11.12.07.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 07:58:20 -0800 (PST)
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
Subject: [PATCH net-next 04/18] net: phy: microchip: remove the use of .ack_interrupt()
Date:   Thu, 12 Nov 2020 17:54:59 +0200
Message-Id: <20201112155513.411604-5-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201112155513.411604-1-ciorneiioana@gmail.com>
References: <20201112155513.411604-1-ciorneiioana@gmail.com>
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

