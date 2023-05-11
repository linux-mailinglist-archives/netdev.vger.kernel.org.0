Return-Path: <netdev+bounces-1917-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D01AC6FF851
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 19:22:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9EF6B1C20FF9
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 17:22:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B3759446;
	Thu, 11 May 2023 17:21:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0E88F68
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 17:21:24 +0000 (UTC)
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C5D5FE5;
	Thu, 11 May 2023 10:21:21 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id af79cd13be357-757720be6abso300156785a.2;
        Thu, 11 May 2023 10:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683825680; x=1686417680;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oY4dKakhihYQHJPTXk9RiaKVGks73RFPcugcArQGyrg=;
        b=F56ES429PX9bnizeIq4UqmGCbvEKpUyuSyBEv80i5kT1+vZAWxU3L9SUr5s6lc3jje
         rPZa9QL7v+CZkwrcTQcyq23iakEFLOzYVXHfze70b7CmO2JAn+XY4mclYVc94UYp2nyu
         7qwDExp8WRrnZvZZrcmjG+hF1XtvaoXzwYKIakiw6eU4dnHlXFK/qzzbRfvje5b8ogt2
         FH7it7GGMPSTaik2pboOs0klomPn3JiEcAO9rsGe2g0gYlVsAc8IXttsZh3jvoqRIEeI
         o/c2scrHqAUBgGTKZ6+rHEcxLx3U7s14ukrBsGaUA2xq70ErssKFLlMxjD/iV4aYNKf9
         etIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683825680; x=1686417680;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oY4dKakhihYQHJPTXk9RiaKVGks73RFPcugcArQGyrg=;
        b=jrN24R9h6EKsH4SdtfkcEsZgnhz6mWQsCTLQf0ZsK9fdzBPpmt3U3kjhsJcFtNPv8y
         K3vPIR37u3kVwDvthYVEGcUsN6gtO/77MXFjixjmWK8DvY9BrWXgVqqpjFIIT/Oh3KCt
         BsWEHlLSMxdL29uB3unbKh3Nzt0BuyR0/tNUXXwq5VEVE7kkGa8L0riTHFDwAQziiwtS
         T2p70HKG96zyxH8CXov8ecH4Kz2LA02xdi6pEgPg7S74YUpm30vSWfx/sZ/HJYxDVX7w
         7OuZOeZpBVKZTYe/MAWAuEWo1eLYji7YDftaBWXHmy2M70aUW7RthOkD+Yyak7pjnt4G
         wyhQ==
X-Gm-Message-State: AC+VfDx7a294wbJRBQqhQXwt0dUbzMZHUGbxNgmZqJ7eyP+FnA8r4v+O
	eVLXz51L4dblXSigc5rIxElfaV9q6J4=
X-Google-Smtp-Source: ACHHUZ5uga7a++h537fARhuT1ul4TAamXlXqOGbgOXjrZD58GP08wxTlIQC2Up6e8SIdY0OnOfrpwg==
X-Received: by 2002:a05:6214:2301:b0:616:7a62:a7d0 with SMTP id gc1-20020a056214230100b006167a62a7d0mr34230257qvb.16.1683825680004;
        Thu, 11 May 2023 10:21:20 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j7-20020a0ce007000000b0062168714c8fsm462822qvk.120.2023.05.11.10.21.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 10:21:19 -0700 (PDT)
From: Florian Fainelli <f.fainelli@gmail.com>
To: netdev@vger.kernel.org
Cc: Florian Fainelli <f.fainelli@gmail.com>,
	Simon Horman <simon.horman@corigine.com>,
	Doug Berger <opendmb@gmail.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Peter Geis <pgwipeout@gmail.com>,
	Frank <Frank.Sae@motor-comm.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next v3 2/3] net: phy: broadcom: Add support for Wake-on-LAN
Date: Thu, 11 May 2023 10:21:09 -0700
Message-Id: <20230511172110.2243275-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230511172110.2243275-1-f.fainelli@gmail.com>
References: <20230511172110.2243275-1-f.fainelli@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add support for WAKE_UCAST, WAKE_MCAST, WAKE_BCAST, WAKE_MAGIC and
WAKE_MAGICSECURE. This is only supported with the BCM54210E and
compatible Ethernet PHYs. Using the in-band interrupt or an out of band
GPIO interrupts are supported.

Broadcom PHYs will generate a Wake-on-LAN level low interrupt on LED4 as
soon as one of the supported patterns is being matched. That includes
generating such an interrupt even if the PHY is operated during normal
modes. If WAKE_UCAST is selected, this could lead to the LED4 interrupt
firing up for every packet being received which is absolutely
undesirable from a performance point of view.

Because the Wake-on-LAN configuration can be set long before the system
is actually put to sleep, we cannot have an interrupt service routine to
clear on read the interrupt status register and ensure that new packet
matches will be detected.

It is desirable to enable the Wake-on-LAN interrupt as late as possible
during the system suspend process such that we limit the number of
interrupts to be handled by the system, but also conversely feed into
the Linux's system suspend way of dealing with interrupts in and around
the points of no return.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/bcm-phy-lib.c | 212 ++++++++++++++++++++++++++++++++++
 drivers/net/phy/bcm-phy-lib.h |   5 +
 drivers/net/phy/broadcom.c    | 126 +++++++++++++++++++-
 include/linux/brcmphy.h       |  55 +++++++++
 4 files changed, 395 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/bcm-phy-lib.c b/drivers/net/phy/bcm-phy-lib.c
index b2c0baa51f39..27c57f6ab211 100644
--- a/drivers/net/phy/bcm-phy-lib.c
+++ b/drivers/net/phy/bcm-phy-lib.c
@@ -6,12 +6,14 @@
 #include "bcm-phy-lib.h"
 #include <linux/bitfield.h>
 #include <linux/brcmphy.h>
+#include <linux/etherdevice.h>
 #include <linux/export.h>
 #include <linux/mdio.h>
 #include <linux/module.h>
 #include <linux/phy.h>
 #include <linux/ethtool.h>
 #include <linux/ethtool_netlink.h>
+#include <linux/netdevice.h>
 
 #define MII_BCM_CHANNEL_WIDTH     0x2000
 #define BCM_CL45VEN_EEE_ADV       0x3c
@@ -816,6 +818,216 @@ int bcm_phy_cable_test_get_status_rdb(struct phy_device *phydev,
 }
 EXPORT_SYMBOL_GPL(bcm_phy_cable_test_get_status_rdb);
 
+#define BCM54XX_WOL_SUPPORTED_MASK	(WAKE_UCAST | \
+					 WAKE_MCAST | \
+					 WAKE_BCAST | \
+					 WAKE_MAGIC | \
+					 WAKE_MAGICSECURE)
+
+int bcm_phy_set_wol(struct phy_device *phydev, struct ethtool_wolinfo *wol)
+{
+	struct net_device *ndev = phydev->attached_dev;
+	u8 da[ETH_ALEN], mask[ETH_ALEN];
+	unsigned int i;
+	u16 ctl;
+	int ret;
+
+	/* Allow a MAC driver to play through its own Wake-on-LAN
+	 * implementation
+	 */
+	if (wol->wolopts & ~BCM54XX_WOL_SUPPORTED_MASK)
+		return -EOPNOTSUPP;
+
+	/* The PHY supports passwords of 4, 6 and 8 bytes in size, but Linux's
+	 * ethtool only supports 6, for now.
+	 */
+	BUILD_BUG_ON(sizeof(wol->sopass) != ETH_ALEN);
+
+	/* Clear previous interrupts */
+	ret = bcm_phy_read_exp(phydev, BCM54XX_WOL_INT_STATUS);
+	if (ret < 0)
+		return ret;
+
+	ret = bcm_phy_read_exp(phydev, BCM54XX_WOL_MAIN_CTL);
+	if (ret < 0)
+		return ret;
+
+	ctl = ret;
+
+	if (!wol->wolopts) {
+		if (phy_interrupt_is_valid(phydev))
+			disable_irq_wake(phydev->irq);
+
+		/* Leave all interrupts disabled */
+		ret = bcm_phy_write_exp(phydev, BCM54XX_WOL_INT_MASK,
+					BCM54XX_WOL_ALL_INTRS);
+		if (ret < 0)
+			return ret;
+
+		/* Disable the global Wake-on-LAN enable bit */
+		ctl &= ~BCM54XX_WOL_EN;
+
+		return bcm_phy_write_exp(phydev, BCM54XX_WOL_MAIN_CTL, ctl);
+	}
+
+	/* Clear the previously configured mode and mask mode for Wake-on-LAN */
+	ctl &= ~(BCM54XX_WOL_MODE_MASK << BCM54XX_WOL_MODE_SHIFT);
+	ctl &= ~(BCM54XX_WOL_MASK_MODE_MASK << BCM54XX_WOL_MASK_MODE_SHIFT);
+	ctl &= ~BCM54XX_WOL_DIR_PKT_EN;
+	ctl &= ~(BCM54XX_WOL_SECKEY_OPT_MASK << BCM54XX_WOL_SECKEY_OPT_SHIFT);
+
+	/* When using WAKE_MAGIC, we program the magic pattern filter to match
+	 * the device's MAC address and we accept any MAC DA in the Ethernet
+	 * frame.
+	 *
+	 * When using WAKE_UCAST, WAKE_BCAST or WAKE_MCAST, we program the
+	 * following:
+	 * - WAKE_UCAST -> MAC DA is the device's MAC with a perfect match
+	 * - WAKE_MCAST -> MAC DA is X1:XX:XX:XX:XX:XX where XX is don't care
+	 * - WAKE_BCAST -> MAC DA is FF:FF:FF:FF:FF:FF with a perfect match
+	 *
+	 * Note that the Broadcast MAC DA is inherently going to match the
+	 * multicast pattern being matched.
+	 */
+	memset(mask, 0, sizeof(mask));
+
+	if (wol->wolopts & WAKE_MCAST) {
+		memset(da, 0, sizeof(da));
+		memset(mask, 0xff, sizeof(mask));
+		da[0] = 0x01;
+		mask[0] = ~da[0];
+	} else {
+		if (wol->wolopts & WAKE_UCAST) {
+			ether_addr_copy(da, ndev->dev_addr);
+		} else if (wol->wolopts & WAKE_BCAST) {
+			eth_broadcast_addr(da);
+		} else if (wol->wolopts & WAKE_MAGICSECURE) {
+			ether_addr_copy(da, wol->sopass);
+		} else if (wol->wolopts & WAKE_MAGIC) {
+			memset(da, 0, sizeof(da));
+			memset(mask, 0xff, sizeof(mask));
+		}
+	}
+
+	for (i = 0; i < ETH_ALEN / 2; i++) {
+		if (wol->wolopts & (WAKE_MAGIC | WAKE_MAGICSECURE)) {
+			ret = bcm_phy_write_exp(phydev,
+						BCM54XX_WOL_MPD_DATA1(2 - i),
+						ndev->dev_addr[i * 2] << 8 |
+						ndev->dev_addr[i * 2 + 1]);
+			if (ret < 0)
+				return ret;
+		}
+
+		ret = bcm_phy_write_exp(phydev, BCM54XX_WOL_MPD_DATA2(2 - i),
+					da[i * 2] << 8 | da[i * 2 + 1]);
+		if (ret < 0)
+			return ret;
+
+		ret = bcm_phy_write_exp(phydev, BCM54XX_WOL_MASK(2 - i),
+					mask[i * 2] << 8 | mask[i * 2 + 1]);
+		if (ret)
+			return ret;
+	}
+
+	if (wol->wolopts & WAKE_MAGICSECURE) {
+		ctl |= BCM54XX_WOL_SECKEY_OPT_6B <<
+		       BCM54XX_WOL_SECKEY_OPT_SHIFT;
+		ctl |= BCM54XX_WOL_MODE_SINGLE_MPDSEC << BCM54XX_WOL_MODE_SHIFT;
+		ctl |= BCM54XX_WOL_MASK_MODE_DA_FF <<
+		       BCM54XX_WOL_MASK_MODE_SHIFT;
+	} else {
+		if (wol->wolopts & WAKE_MAGIC)
+			ctl |= BCM54XX_WOL_MODE_SINGLE_MPD;
+		else
+			ctl |= BCM54XX_WOL_DIR_PKT_EN;
+		ctl |= BCM54XX_WOL_MASK_MODE_DA_ONLY <<
+		       BCM54XX_WOL_MASK_MODE_SHIFT;
+	}
+
+	/* Globally enable Wake-on-LAN */
+	ctl |= BCM54XX_WOL_EN | BCM54XX_WOL_CRC_CHK;
+
+	ret = bcm_phy_write_exp(phydev, BCM54XX_WOL_MAIN_CTL, ctl);
+	if (ret < 0)
+		return ret;
+
+	/* Enable WOL interrupt on LED4 */
+	ret = bcm_phy_read_exp(phydev, BCM54XX_TOP_MISC_LED_CTL);
+	if (ret < 0)
+		return ret;
+
+	ret |= BCM54XX_LED4_SEL_INTR;
+	ret = bcm_phy_write_exp(phydev, BCM54XX_TOP_MISC_LED_CTL, ret);
+	if (ret < 0)
+		return ret;
+
+	/* Enable all Wake-on-LAN interrupt sources */
+	ret = bcm_phy_write_exp(phydev, BCM54XX_WOL_INT_MASK, 0);
+	if (ret < 0)
+		return ret;
+
+	if (phy_interrupt_is_valid(phydev))
+		enable_irq_wake(phydev->irq);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(bcm_phy_set_wol);
+
+void bcm_phy_get_wol(struct phy_device *phydev, struct ethtool_wolinfo *wol)
+{
+	struct net_device *ndev = phydev->attached_dev;
+	u8 da[ETH_ALEN];
+	unsigned int i;
+	int ret;
+	u16 ctl;
+
+	wol->supported = BCM54XX_WOL_SUPPORTED_MASK;
+	wol->wolopts = 0;
+
+	ret = bcm_phy_read_exp(phydev, BCM54XX_WOL_MAIN_CTL);
+	if (ret < 0)
+		return;
+
+	ctl = ret;
+
+	if (!(ctl & BCM54XX_WOL_EN))
+		return;
+
+	for (i = 0; i < sizeof(da) / 2; i++) {
+		ret = bcm_phy_read_exp(phydev,
+				       BCM54XX_WOL_MPD_DATA2(2 - i));
+		if (ret < 0)
+			return;
+
+		da[i * 2] = ret >> 8;
+		da[i * 2 + 1] = ret & 0xff;
+	}
+
+	if (ctl & BCM54XX_WOL_DIR_PKT_EN) {
+		if (is_broadcast_ether_addr(da))
+			wol->wolopts |= WAKE_BCAST;
+		else if (is_multicast_ether_addr(da))
+			wol->wolopts |= WAKE_MCAST;
+		else if (ether_addr_equal(da, ndev->dev_addr))
+			wol->wolopts |= WAKE_UCAST;
+	} else {
+		ctl = (ctl >> BCM54XX_WOL_MODE_SHIFT) & BCM54XX_WOL_MODE_MASK;
+		switch (ctl) {
+		case BCM54XX_WOL_MODE_SINGLE_MPD:
+			wol->wolopts |= WAKE_MAGIC;
+			break;
+		case BCM54XX_WOL_MODE_SINGLE_MPDSEC:
+			wol->wolopts |= WAKE_MAGICSECURE;
+			memcpy(wol->sopass, da, sizeof(da));
+			break;
+		default:
+			break;
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(bcm_phy_get_wol);
+
 MODULE_DESCRIPTION("Broadcom PHY Library");
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Broadcom Corporation");
diff --git a/drivers/net/phy/bcm-phy-lib.h b/drivers/net/phy/bcm-phy-lib.h
index 9902fb182099..4337e4a5cade 100644
--- a/drivers/net/phy/bcm-phy-lib.h
+++ b/drivers/net/phy/bcm-phy-lib.h
@@ -9,6 +9,8 @@
 #include <linux/brcmphy.h>
 #include <linux/phy.h>
 
+struct ethtool_wolinfo;
+
 /* 28nm only register definitions */
 #define MISC_ADDR(base, channel)	base, channel
 
@@ -106,4 +108,7 @@ static inline void bcm_ptp_stop(struct bcm_ptp_private *priv)
 }
 #endif
 
+int bcm_phy_set_wol(struct phy_device *phydev, struct ethtool_wolinfo *wol);
+void bcm_phy_get_wol(struct phy_device *phydev, struct ethtool_wolinfo *wol);
+
 #endif /* _LINUX_BCM_PHY_LIB_H */
diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index ad71c88c87e7..418e6bc0e998 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -14,8 +14,12 @@
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/phy.h>
+#include <linux/pm_wakeup.h>
 #include <linux/brcmphy.h>
 #include <linux/of.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/gpio/consumer.h>
 
 #define BRCM_PHY_MODEL(phydev) \
 	((phydev)->drv->phy_id & (phydev)->drv->phy_id_mask)
@@ -30,8 +34,17 @@ MODULE_LICENSE("GPL");
 struct bcm54xx_phy_priv {
 	u64	*stats;
 	struct bcm_ptp_private *ptp;
+	int	wake_irq;
+	bool	wake_irq_enabled;
 };
 
+static bool bcm54xx_phy_can_wakeup(struct phy_device *phydev)
+{
+	struct bcm54xx_phy_priv *priv = phydev->priv;
+
+	return phy_interrupt_is_valid(phydev) || priv->wake_irq >= 0;
+}
+
 static int bcm54xx_config_clock_delay(struct phy_device *phydev)
 {
 	int rc, val;
@@ -413,6 +426,16 @@ static int bcm54xx_config_init(struct phy_device *phydev)
 
 	bcm54xx_ptp_config_init(phydev);
 
+	/* Acknowledge any left over interrupt and charge the device for
+	 * wake-up.
+	 */
+	err = bcm_phy_read_exp(phydev, BCM54XX_WOL_INT_STATUS);
+	if (err < 0)
+		return err;
+
+	if (err)
+		pm_wakeup_event(&phydev->mdio.dev, 0);
+
 	return 0;
 }
 
@@ -437,12 +460,39 @@ static int bcm54xx_iddq_set(struct phy_device *phydev, bool enable)
 	return ret;
 }
 
+static int bcm54xx_set_wakeup_irq(struct phy_device *phydev, bool state)
+{
+	struct bcm54xx_phy_priv *priv = phydev->priv;
+	int ret = 0;
+
+	if (!bcm54xx_phy_can_wakeup(phydev))
+		return ret;
+
+	if (priv->wake_irq_enabled != state) {
+		if (state)
+			ret = enable_irq_wake(priv->wake_irq);
+		else
+			ret = disable_irq_wake(priv->wake_irq);
+		priv->wake_irq_enabled = state;
+	}
+
+	return ret;
+}
+
 static int bcm54xx_suspend(struct phy_device *phydev)
 {
-	int ret;
+	int ret = 0;
 
 	bcm54xx_ptp_stop(phydev);
 
+	/* Acknowledge any Wake-on-LAN interrupt prior to suspend */
+	ret = bcm_phy_read_exp(phydev, BCM54XX_WOL_INT_STATUS);
+	if (ret < 0)
+		return ret;
+
+	if (phydev->wol_enabled)
+		return bcm54xx_set_wakeup_irq(phydev, true);
+
 	/* We cannot use a read/modify/write here otherwise the PHY gets into
 	 * a bad state where its LEDs keep flashing, thus defeating the purpose
 	 * of low power mode.
@@ -456,7 +506,13 @@ static int bcm54xx_suspend(struct phy_device *phydev)
 
 static int bcm54xx_resume(struct phy_device *phydev)
 {
-	int ret;
+	int ret = 0;
+
+	if (phydev->wol_enabled) {
+		ret = bcm54xx_set_wakeup_irq(phydev, false);
+		if (ret)
+			return ret;
+	}
 
 	ret = bcm54xx_iddq_set(phydev, false);
 	if (ret < 0)
@@ -801,14 +857,54 @@ static int brcm_fet_suspend(struct phy_device *phydev)
 	return err;
 }
 
+static void bcm54xx_phy_get_wol(struct phy_device *phydev,
+				struct ethtool_wolinfo *wol)
+{
+	/* We cannot wake-up if we do not have a dedicated PHY interrupt line
+	 * or an out of band GPIO descriptor for wake-up. Zeroing
+	 * wol->supported allows the caller (MAC driver) to play through and
+	 * offer its own Wake-on-LAN scheme if available.
+	 */
+	if (!bcm54xx_phy_can_wakeup(phydev)) {
+		wol->supported = 0;
+		return;
+	}
+
+	bcm_phy_get_wol(phydev, wol);
+}
+
+static int bcm54xx_phy_set_wol(struct phy_device *phydev,
+			       struct ethtool_wolinfo *wol)
+{
+	int ret;
+
+	/* We cannot wake-up if we do not have a dedicated PHY interrupt line
+	 * or an out of band GPIO descriptor for wake-up. Returning -EOPNOTSUPP
+	 * allows the caller (MAC driver) to play through and offer its own
+	 * Wake-on-LAN scheme if available.
+	 */
+	if (!bcm54xx_phy_can_wakeup(phydev))
+		return -EOPNOTSUPP;
+
+	ret = bcm_phy_set_wol(phydev, wol);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
 static int bcm54xx_phy_probe(struct phy_device *phydev)
 {
 	struct bcm54xx_phy_priv *priv;
+	struct gpio_desc *wakeup_gpio;
+	int ret = 0;
 
 	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
+	priv->wake_irq = -ENXIO;
+
 	phydev->priv = priv;
 
 	priv->stats = devm_kcalloc(&phydev->mdio.dev,
@@ -821,7 +917,28 @@ static int bcm54xx_phy_probe(struct phy_device *phydev)
 	if (IS_ERR(priv->ptp))
 		return PTR_ERR(priv->ptp);
 
-	return 0;
+	/* We cannot utilize the _optional variant here since we want to know
+	 * whether the GPIO descriptor exists or not to advertise Wake-on-LAN
+	 * support or not.
+	 */
+	wakeup_gpio = devm_gpiod_get(&phydev->mdio.dev, "wakeup", GPIOD_IN);
+	if (PTR_ERR(wakeup_gpio) == -EPROBE_DEFER)
+		return PTR_ERR(wakeup_gpio);
+
+	if (!IS_ERR(wakeup_gpio)) {
+		priv->wake_irq = gpiod_to_irq(wakeup_gpio);
+		ret = irq_set_irq_type(priv->wake_irq, IRQ_TYPE_LEVEL_LOW);
+		if (ret)
+			return ret;
+	}
+
+	/* If we do not have a main interrupt or a side-band wake-up interrupt,
+	 * then the device cannot be marked as wake-up capable.
+	 */
+	if (!bcm54xx_phy_can_wakeup(phydev))
+		return 0;
+
+	return device_init_wakeup(&phydev->mdio.dev, true);
 }
 
 static void bcm54xx_get_stats(struct phy_device *phydev,
@@ -894,6 +1011,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.phy_id_mask	= 0xfffffff0,
 	.name		= "Broadcom BCM54210E",
 	/* PHY_GBIT_FEATURES */
+	.flags		= PHY_ALWAYS_CALL_SUSPEND,
 	.get_sset_count	= bcm_phy_get_sset_count,
 	.get_strings	= bcm_phy_get_strings,
 	.get_stats	= bcm54xx_get_stats,
@@ -904,6 +1022,8 @@ static struct phy_driver broadcom_drivers[] = {
 	.link_change_notify	= bcm54xx_link_change_notify,
 	.suspend	= bcm54xx_suspend,
 	.resume		= bcm54xx_resume,
+	.get_wol	= bcm54xx_phy_get_wol,
+	.set_wol	= bcm54xx_phy_set_wol,
 }, {
 	.phy_id		= PHY_ID_BCM5461,
 	.phy_id_mask	= 0xfffffff0,
diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
index 9e77165f3ef6..e9afbfb6d7a5 100644
--- a/include/linux/brcmphy.h
+++ b/include/linux/brcmphy.h
@@ -89,6 +89,7 @@
 #define MII_BCM54XX_EXP_SEL	0x17	/* Expansion register select */
 #define MII_BCM54XX_EXP_SEL_TOP	0x0d00	/* TOP_MISC expansion register select */
 #define MII_BCM54XX_EXP_SEL_SSD	0x0e00	/* Secondary SerDes select */
+#define MII_BCM54XX_EXP_SEL_WOL	0x0e00	/* Wake-on-LAN expansion select register */
 #define MII_BCM54XX_EXP_SEL_ER	0x0f00	/* Expansion register select */
 #define MII_BCM54XX_EXP_SEL_ETC	0x0d00	/* Expansion register spare + 2k mem */
 
@@ -253,6 +254,9 @@
 #define BCM54XX_TOP_MISC_IDDQ_SD		(1 << 2)
 #define BCM54XX_TOP_MISC_IDDQ_SR		(1 << 3)
 
+#define BCM54XX_TOP_MISC_LED_CTL		(MII_BCM54XX_EXP_SEL_TOP + 0x0C)
+#define  BCM54XX_LED4_SEL_INTR			BIT(1)
+
 /*
  * BCM5482: Secondary SerDes registers
  */
@@ -272,6 +276,57 @@
 #define BCM54612E_EXP_SPARE0		(MII_BCM54XX_EXP_SEL_ETC + 0x34)
 #define BCM54612E_LED4_CLK125OUT_EN	(1 << 1)
 
+
+/* Wake-on-LAN registers */
+#define BCM54XX_WOL_MAIN_CTL		(MII_BCM54XX_EXP_SEL_WOL + 0x80)
+#define  BCM54XX_WOL_EN			BIT(0)
+#define  BCM54XX_WOL_MODE_SINGLE_MPD	0
+#define  BCM54XX_WOL_MODE_SINGLE_MPDSEC	1
+#define  BCM54XX_WOL_MODE_DUAL		2
+#define  BCM54XX_WOL_MODE_SHIFT		1
+#define  BCM54XX_WOL_MODE_MASK		0x3
+#define  BCM54XX_WOL_MP_MSB_FF_EN	BIT(3)
+#define  BCM54XX_WOL_SECKEY_OPT_4B	0
+#define  BCM54XX_WOL_SECKEY_OPT_6B	1
+#define  BCM54XX_WOL_SECKEY_OPT_8B	2
+#define  BCM54XX_WOL_SECKEY_OPT_SHIFT	4
+#define  BCM54XX_WOL_SECKEY_OPT_MASK	0x3
+#define  BCM54XX_WOL_L2_TYPE_CHK	BIT(6)
+#define  BCM54XX_WOL_L4IPV4UDP_CHK	BIT(7)
+#define  BCM54XX_WOL_L4IPV6UDP_CHK	BIT(8)
+#define  BCM54XX_WOL_UDPPORT_CHK	BIT(9)
+#define  BCM54XX_WOL_CRC_CHK		BIT(10)
+#define  BCM54XX_WOL_SECKEY_MODE	BIT(11)
+#define  BCM54XX_WOL_RST		BIT(12)
+#define  BCM54XX_WOL_DIR_PKT_EN		BIT(13)
+#define  BCM54XX_WOL_MASK_MODE_DA_FF	0
+#define  BCM54XX_WOL_MASK_MODE_DA_MPD	1
+#define  BCM54XX_WOL_MASK_MODE_DA_ONLY	2
+#define  BCM54XX_WOL_MASK_MODE_MPD	3
+#define  BCM54XX_WOL_MASK_MODE_SHIFT	14
+#define  BCM54XX_WOL_MASK_MODE_MASK	0x3
+
+#define BCM54XX_WOL_INNER_PROTO		(MII_BCM54XX_EXP_SEL_WOL + 0x81)
+#define BCM54XX_WOL_OUTER_PROTO		(MII_BCM54XX_EXP_SEL_WOL + 0x82)
+#define BCM54XX_WOL_OUTER_PROTO2	(MII_BCM54XX_EXP_SEL_WOL + 0x83)
+
+#define BCM54XX_WOL_MPD_DATA1(x)	(MII_BCM54XX_EXP_SEL_WOL + 0x84 + (x))
+#define BCM54XX_WOL_MPD_DATA2(x)	(MII_BCM54XX_EXP_SEL_WOL + 0x87 + (x))
+#define BCM54XX_WOL_SEC_KEY_8B		(MII_BCM54XX_EXP_SEL_WOL + 0x8A)
+#define BCM54XX_WOL_MASK(x)		(MII_BCM54XX_EXP_SEL_WOL + 0x8B + (x))
+#define BCM54XX_SEC_KEY_STORE(x)	(MII_BCM54XX_EXP_SEL_WOL + 0x8E)
+#define BCM54XX_WOL_SHARED_CNT		(MII_BCM54XX_EXP_SEL_WOL + 0x92)
+
+#define BCM54XX_WOL_INT_MASK		(MII_BCM54XX_EXP_SEL_WOL + 0x93)
+#define  BCM54XX_WOL_PKT1		BIT(0)
+#define  BCM54XX_WOL_PKT2		BIT(1)
+#define  BCM54XX_WOL_DIR		BIT(2)
+#define  BCM54XX_WOL_ALL_INTRS		(BCM54XX_WOL_PKT1 | \
+					 BCM54XX_WOL_PKT2 | \
+					 BCM54XX_WOL_DIR)
+
+#define BCM54XX_WOL_INT_STATUS		(MII_BCM54XX_EXP_SEL_WOL + 0x94)
+
 /*****************************************************************************/
 /* Fast Ethernet Transceiver definitions. */
 /*****************************************************************************/
-- 
2.34.1


