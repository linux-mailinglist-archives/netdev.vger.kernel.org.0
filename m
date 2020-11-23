Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C82082C0F0E
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 16:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389716AbgKWPjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 10:39:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389649AbgKWPjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 10:39:05 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD9AEC0613CF;
        Mon, 23 Nov 2020 07:39:03 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id oq3so23904747ejb.7;
        Mon, 23 Nov 2020 07:39:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TusUGAwjKLhvqu+tAwG6fITFVtTTw0LT4cF+FlXu+uo=;
        b=lct5lNVp3AsngxY0QQET9C/ZGAopLnIgK2FJ/KrqUkVaBNiDKzBrhDHnLoXRujFHD6
         t9Q1H0Mq9pB5o2B9+cGLVk+7Jx50/8v525SMiO5f3iORddHenHT8YMxvg77LD6VB1Ae+
         u+TMrpzFl/B+CKrHPsoV6oc4E6BJl4b7ze3x+5468MtjTTCHK1SPszxBhxMfeYJ/cVCO
         8HkxASoL27Xh+7LgJyPMyjuTx2aVdkJ9u03qYHUAXmT5JmnobAKhtfUvKGeMWWCf/SSN
         chNys5R2fy3TgVBMNZfWE5C47m+/aYEy0PuGBU4DkQj6/JYu39zsThuBfi4I98gxeq/F
         ih6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TusUGAwjKLhvqu+tAwG6fITFVtTTw0LT4cF+FlXu+uo=;
        b=OSV8WUBaPY6TLyQTNUm/6e0m3856Zwzxy+q81uMqvI6EL2/T9oLVERlzFbDkLKYZPs
         mpytNhWvqi5a99HYOOUoePeltRPynYYLFUkiu9hb5RPuVE4R7O9wN4bacg+YexdPCeJu
         xYzN7WDa9N/H5UCOf6dOSz4Ef4e5aTbnmEA3HKAmYe+sxJvcKeiLi8S/O76ee7wZpLq/
         3bfZ9idalPZ+OxZsQ0ePFSedEvi8t4CPTfMeRksAeDqs60QsZQARzW7uHmYwUKrVqypN
         g9a9Lmi82spCdMGctjbe6d2XlpwKyIBIq3rlT6JTIwQPsZGDtQhGfExdeXgTILtXLOLF
         9++Q==
X-Gm-Message-State: AOAM531r8uIj98HlBkXLqypUeP858v7RAHJ3fTYL6+OD1j8xJVlYwNgK
        yh5QNaxZf03VzGggVOcv7ys=
X-Google-Smtp-Source: ABdhPJzJztZg8FGiG/ke0zahYFV5QlHlMngIEaluSmacSoZX20+HseiFrEW7anIfoUraziEWY4Sl4w==
X-Received: by 2002:a17:906:7b82:: with SMTP id s2mr133342ejo.435.1606145942271;
        Mon, 23 Nov 2020 07:39:02 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id c6sm4800126edy.62.2020.11.23.07.39.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 07:39:01 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 15/15] net: phy: remove the .did_interrupt() and .ack_interrupt() callback
Date:   Mon, 23 Nov 2020 17:38:17 +0200
Message-Id: <20201123153817.1616814-16-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201123153817.1616814-1-ciorneiioana@gmail.com>
References: <20201123153817.1616814-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Now that all the PHY drivers have been migrated to directly implement
the generic .handle_interrupt() callback for a seamless support of
shared IRQs and all the .config_inter() implementations clear any
pending interrupts, we can safely remove the two callbacks.

With this patch, phylib has a proper support for shared IRQs (and not
just for multi-PHY devices. A PHY driver must implement both the
.handle_interrupt() and .config_intr() callbacks for the IRQs to be
actually used.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/phy.c        | 48 ++----------------------------------
 drivers/net/phy/phy_device.c |  2 +-
 include/linux/phy.h          | 19 +++-----------
 3 files changed, 7 insertions(+), 62 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index dce86bad8231..45f75533c47c 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -113,23 +113,6 @@ void phy_print_status(struct phy_device *phydev)
 }
 EXPORT_SYMBOL(phy_print_status);
 
-/**
- * phy_clear_interrupt - Ack the phy device's interrupt
- * @phydev: the phy_device struct
- *
- * If the @phydev driver has an ack_interrupt function, call it to
- * ack and clear the phy device's interrupt.
- *
- * Returns 0 on success or < 0 on error.
- */
-static int phy_clear_interrupt(struct phy_device *phydev)
-{
-	if (phydev->drv->ack_interrupt)
-		return phydev->drv->ack_interrupt(phydev);
-
-	return 0;
-}
-
 /**
  * phy_config_interrupt - configure the PHY device for the requested interrupts
  * @phydev: the phy_device struct
@@ -943,15 +926,8 @@ EXPORT_SYMBOL(phy_error);
  */
 int phy_disable_interrupts(struct phy_device *phydev)
 {
-	int err;
-
 	/* Disable PHY interrupts */
-	err = phy_config_interrupt(phydev, PHY_INTERRUPT_DISABLED);
-	if (err)
-		return err;
-
-	/* Clear the interrupt */
-	return phy_clear_interrupt(phydev);
+	return phy_config_interrupt(phydev, PHY_INTERRUPT_DISABLED);
 }
 
 /**
@@ -966,22 +942,7 @@ static irqreturn_t phy_interrupt(int irq, void *phy_dat)
 	struct phy_device *phydev = phy_dat;
 	struct phy_driver *drv = phydev->drv;
 
-	if (drv->handle_interrupt)
-		return drv->handle_interrupt(phydev);
-
-	if (drv->did_interrupt && !drv->did_interrupt(phydev))
-		return IRQ_NONE;
-
-	/* reschedule state queue work to run as soon as possible */
-	phy_trigger_machine(phydev);
-
-	/* did_interrupt() may have cleared the interrupt already */
-	if (!drv->did_interrupt && phy_clear_interrupt(phydev)) {
-		phy_error(phydev);
-		return IRQ_NONE;
-	}
-
-	return IRQ_HANDLED;
+	return drv->handle_interrupt(phydev);
 }
 
 /**
@@ -990,11 +951,6 @@ static irqreturn_t phy_interrupt(int irq, void *phy_dat)
  */
 static int phy_enable_interrupts(struct phy_device *phydev)
 {
-	int err = phy_clear_interrupt(phydev);
-
-	if (err < 0)
-		return err;
-
 	return phy_config_interrupt(phydev, PHY_INTERRUPT_ENABLED);
 }
 
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 81f672911305..80c2e646c093 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2826,7 +2826,7 @@ EXPORT_SYMBOL(phy_get_internal_delay);
 
 static bool phy_drv_supports_irq(struct phy_driver *phydrv)
 {
-	return phydrv->config_intr && (phydrv->ack_interrupt || phydrv->handle_interrupt);
+	return phydrv->config_intr && phydrv->handle_interrupt;
 }
 
 /**
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 8849a00a093f..381a95732b6a 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -743,18 +743,11 @@ struct phy_driver {
 	/** @read_status: Determines the negotiated speed and duplex */
 	int (*read_status)(struct phy_device *phydev);
 
-	/** @ack_interrupt: Clears any pending interrupts */
-	int (*ack_interrupt)(struct phy_device *phydev);
-
-	/** @config_intr: Enables or disables interrupts */
-	int (*config_intr)(struct phy_device *phydev);
-
-	/**
-	 * @did_interrupt: Checks if the PHY generated an interrupt.
-	 * For multi-PHY devices with shared PHY interrupt pin
-	 * Set interrupt bits have to be cleared.
+	/** @config_intr: Enables or disables interrupts.
+	 * It should also clear any pending interrupts prior to enabling the
+	 * IRQs and after disabling them.
 	 */
-	int (*did_interrupt)(struct phy_device *phydev);
+	int (*config_intr)(struct phy_device *phydev);
 
 	/** @handle_interrupt: Override default interrupt handling */
 	irqreturn_t (*handle_interrupt)(struct phy_device *phydev);
@@ -1487,10 +1480,6 @@ static inline int genphy_config_aneg(struct phy_device *phydev)
 	return __genphy_config_aneg(phydev, false);
 }
 
-static inline int genphy_no_ack_interrupt(struct phy_device *phydev)
-{
-	return 0;
-}
 static inline int genphy_no_config_intr(struct phy_device *phydev)
 {
 	return 0;
-- 
2.28.0

