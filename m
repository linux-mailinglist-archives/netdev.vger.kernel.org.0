Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED1331B0B0
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 15:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhBNORV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 09:17:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbhBNORT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 09:17:19 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F02EC061574;
        Sun, 14 Feb 2021 06:16:38 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id w4so3882341wmi.4;
        Sun, 14 Feb 2021 06:16:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=IN4g7DU0HOPr3LF/TfGbWkPAqMWUrPu9ClD6/llvgIY=;
        b=TnubQFDk3aQP2dX3ngFLHFz+7fCSawcnFGuTA/cCmubCiUq9pqQFqUQSkfYIrpMQNw
         ul+4KPpJEfAcwVns6rzy9b924iDGY1KPSdkj/NVMlbScMGsrMm+h0qbjtp+on06xGV9J
         rgL9jqUwgTuIgH1U8fephUipbBvAvu0X+7tTm6/3yC2G5L64HtJI1E4Hs66f/qbx1yCl
         xJByGLBs+14G6Rz8f8hugOqm/jk8BYiDVnmF4OjMcDAF7nuEHQCQwUmV+LmsFbWYlZlV
         jjoROhxd46gdNgDavxbZN4GptPnmFSyRh9dwdzG/LDTqu/JsIc2EBxJ/v3Yo20axK0Yw
         AMVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=IN4g7DU0HOPr3LF/TfGbWkPAqMWUrPu9ClD6/llvgIY=;
        b=nLjtIOJtqshmRL4pi/lvNvK86Q2RFpkQnzDsBB06N7ATafc6UT67QTlDDDFKBzm/R3
         k+jYA4bwAKkQoL/3Svgq1FWoUmzQbjRGRop0yP4zVXipGdAD8wL5cqWQqETwHprvTH86
         9tArwxS1YG87pzxpHFYMEQSw3orLzlGptmDBzWHd/OOf8127OHNaVFI7lpSrDRCr8lDj
         C9pwAjnHHeH3JOyQbrIBNjFhZTD5q12ver7n3PE6va3Q0p1p6gV6NCUzfGcfQps90S5+
         TdzPKw1BIK9oY/sKlswcmxOV2SnruRjQ3bL9ZUxV7zUQPaPXenRv466rOEwasYCdn3kL
         X+EQ==
X-Gm-Message-State: AOAM5336hioDE2sg2du4nMCzBJiIU1cCOGDMMDqyrV2LhcdOKuQiVOpp
        7OrVukPlTY7g/MD5cXCDSdY=
X-Google-Smtp-Source: ABdhPJwZ7iV2tNViiQ/izYOtkqLj6Y1qeasW1c7L8iUL9XHQN+TK6vg823X2Vt8bqhYp8CfyURKGPw==
X-Received: by 2002:a7b:cd04:: with SMTP id f4mr10431436wmj.76.1613312197097;
        Sun, 14 Feb 2021 06:16:37 -0800 (PST)
Received: from ?IPv6:2003:ea:8f39:5b00:59b:23b9:f1a6:60c? (p200300ea8f395b00059b23b9f1a6060c.dip0.t-ipconnect.de. [2003:ea:8f39:5b00:59b:23b9:f1a6:60c])
        by smtp.googlemail.com with ESMTPSA id d5sm11057548wrp.39.2021.02.14.06.16.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Feb 2021 06:16:36 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Byungho An <bh74.an@samsung.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-doc@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com
Subject: [PATCH net-next] net: phy: rename PHY_IGNORE_INTERRUPT to
 PHY_MAC_INTERRUPT
Message-ID: <243316e1-1fa3-dcbb-f090-0ef504d5dec7@gmail.com>
Date:   Sun, 14 Feb 2021 15:16:23 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some internal PHY's have their events like link change reported by the
MAC interrupt. We have PHY_IGNORE_INTERRUPT to deal with this scenario.
I'm not too happy with this name. We don't ignore interrupts, typically
there is no interrupt exposed at a PHY level. So let's rename it to
PHY_MAC_INTERRUPT. This is in line with phy_mac_interrupt(), which is
called from the MAC interrupt handler to handle PHY events.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 Documentation/networking/phy.rst                |  2 +-
 drivers/net/ethernet/broadcom/genet/bcmmii.c    |  2 +-
 drivers/net/ethernet/realtek/r8169_main.c       |  2 +-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_mdio.c |  4 ++--
 drivers/net/mdio/mdio-moxart.c                  |  4 ++--
 drivers/net/phy/icplus.c                        |  2 +-
 drivers/net/phy/phy.c                           |  2 +-
 drivers/net/phy/phy_device.c                    |  4 ++--
 include/linux/phy.h                             | 10 +++++-----
 9 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/Documentation/networking/phy.rst b/Documentation/networking/phy.rst
index 399f17976..70136cc9e 100644
--- a/Documentation/networking/phy.rst
+++ b/Documentation/networking/phy.rst
@@ -216,7 +216,7 @@ put into an unsupported state.
 Lastly, once the controller is ready to handle network traffic, you call
 phy_start(phydev).  This tells the PAL that you are ready, and configures the
 PHY to connect to the network. If the MAC interrupt of your network driver
-also handles PHY status changes, just set phydev->irq to PHY_IGNORE_INTERRUPT
+also handles PHY status changes, just set phydev->irq to PHY_MAC_INTERRUPT
 before you call phy_start and use phy_mac_interrupt() from the network
 driver. If you don't want to use interrupts, set phydev->irq to PHY_POLL.
 phy_start() enables the PHY interrupts (if applicable) and starts the
diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index 17f997ef9..5335244e4 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -359,7 +359,7 @@ int bcmgenet_mii_probe(struct net_device *dev)
 	 * those versions of GENET.
 	 */
 	if (priv->internal_phy && !GENET_IS_V5(priv))
-		dev->phydev->irq = PHY_IGNORE_INTERRUPT;
+		dev->phydev->irq = PHY_MAC_INTERRUPT;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 9197da8e6..c69f87645 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5055,7 +5055,7 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
 	new_bus->name = "r8169";
 	new_bus->priv = tp;
 	new_bus->parent = &pdev->dev;
-	new_bus->irq[0] = PHY_IGNORE_INTERRUPT;
+	new_bus->irq[0] = PHY_MAC_INTERRUPT;
 	snprintf(new_bus->id, MII_BUS_ID_SIZE, "r8169-%x", pci_dev_id(pdev));
 
 	new_bus->read = r8169_mdio_read_reg;
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_mdio.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_mdio.c
index b1e7f7ab2..fceb6d637 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_mdio.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_mdio.c
@@ -203,8 +203,8 @@ int sxgbe_mdio_register(struct net_device *ndev)
 			case PHY_POLL:
 				irq_str = "POLL";
 				break;
-			case PHY_IGNORE_INTERRUPT:
-				irq_str = "IGNORE";
+			case PHY_MAC_INTERRUPT:
+				irq_str = "MAC";
 				break;
 			default:
 				sprintf(irq_num, "%d", phy->irq);
diff --git a/drivers/net/mdio/mdio-moxart.c b/drivers/net/mdio/mdio-moxart.c
index b72c6d185..f0cff584e 100644
--- a/drivers/net/mdio/mdio-moxart.c
+++ b/drivers/net/mdio/mdio-moxart.c
@@ -125,7 +125,7 @@ static int moxart_mdio_probe(struct platform_device *pdev)
 	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-%d-mii", pdev->name, pdev->id);
 	bus->parent = &pdev->dev;
 
-	/* Setting PHY_IGNORE_INTERRUPT here even if it has no effect,
+	/* Setting PHY_MAC_INTERRUPT here even if it has no effect,
 	 * of_mdiobus_register() sets these PHY_POLL.
 	 * Ideally, the interrupt from MAC controller could be used to
 	 * detect link state changes, not polling, i.e. if there was
@@ -133,7 +133,7 @@ static int moxart_mdio_probe(struct platform_device *pdev)
 	 * interrupt handled in ethernet drivercode.
 	 */
 	for (i = 0; i < PHY_MAX_ADDR; i++)
-		bus->irq[i] = PHY_IGNORE_INTERRUPT;
+		bus->irq[i] = PHY_MAC_INTERRUPT;
 
 	data = bus->priv;
 	data->base = devm_platform_ioremap_resource(pdev, 0);
diff --git a/drivers/net/phy/icplus.c b/drivers/net/phy/icplus.c
index 4e15d4d02..3e431737c 100644
--- a/drivers/net/phy/icplus.c
+++ b/drivers/net/phy/icplus.c
@@ -188,7 +188,7 @@ static int ip175c_read_status(struct phy_device *phydev)
 		genphy_read_status(phydev);
 	else
 		/* Don't need to read status for switch ports */
-		phydev->irq = PHY_IGNORE_INTERRUPT;
+		phydev->irq = PHY_MAC_INTERRUPT;
 
 	return 0;
 }
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index fdb914b5b..1be07e45d 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -1145,7 +1145,7 @@ void phy_state_machine(struct work_struct *work)
 	}
 
 	/* Only re-schedule a PHY state machine change if we are polling the
-	 * PHY, if PHY_IGNORE_INTERRUPT is set, then we will be moving
+	 * PHY, if PHY_MAC_INTERRUPT is set, then we will be moving
 	 * between states from phy_mac_interrupt().
 	 *
 	 * In state PHY_HALTED the PHY gets suspended, so rescheduling the
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 479e7d117..166853982 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1148,8 +1148,8 @@ char *phy_attached_info_irq(struct phy_device *phydev)
 	case PHY_POLL:
 		irq_str = "POLL";
 		break;
-	case PHY_IGNORE_INTERRUPT:
-		irq_str = "IGNORE";
+	case PHY_MAC_INTERRUPT:
+		irq_str = "MAC";
 		break;
 	default:
 		snprintf(irq_num, sizeof(irq_num), "%d", phydev->irq);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index c13078830..5d7c4084a 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -71,11 +71,11 @@ extern const int phy_10gbit_features_array[1];
 
 /*
  * Set phydev->irq to PHY_POLL if interrupts are not supported,
- * or not desired for this PHY.  Set to PHY_IGNORE_INTERRUPT if
- * the attached driver handles the interrupt
+ * or not desired for this PHY.  Set to PHY_MAC_INTERRUPT if
+ * the attached MAC driver handles the interrupt
  */
 #define PHY_POLL		-1
-#define PHY_IGNORE_INTERRUPT	-2
+#define PHY_MAC_INTERRUPT	-2
 
 #define PHY_IS_INTERNAL		0x00000001
 #define PHY_RST_AFTER_CLK_EN	0x00000002
@@ -1202,11 +1202,11 @@ static inline int phy_clear_bits_mmd(struct phy_device *phydev, int devad,
  * @phydev: the phy_device struct
  *
  * NOTE: must be kept in sync with addition/removal of PHY_POLL and
- * PHY_IGNORE_INTERRUPT
+ * PHY_MAC_INTERRUPT
  */
 static inline bool phy_interrupt_is_valid(struct phy_device *phydev)
 {
-	return phydev->irq != PHY_POLL && phydev->irq != PHY_IGNORE_INTERRUPT;
+	return phydev->irq != PHY_POLL && phydev->irq != PHY_MAC_INTERRUPT;
 }
 
 /**
-- 
2.30.1

