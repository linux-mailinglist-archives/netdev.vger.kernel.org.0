Return-Path: <netdev+bounces-928-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D43E6FB664
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 20:44:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD20928109A
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 18:44:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96DC311192;
	Mon,  8 May 2023 18:43:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859DD11188
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 18:43:42 +0000 (UTC)
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4DB659E8;
	Mon,  8 May 2023 11:43:39 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id af79cd13be357-7575ff76964so116135485a.2;
        Mon, 08 May 2023 11:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683571418; x=1686163418;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NMLTaac8rhvSbe/caPsDcy8khu+PZxjEUlyzscx2eKA=;
        b=DrVLIab/7J/kQZTEhB0cpR5ABkpqIcnpGqLZAImu5UV5AFs/XOJfcKEvL50M8Y6+Js
         RXg1xHNjb6N/M7QFsZgcHFJlGFKPWYV76hq4r+xmMI71bvNGXUN74JUefYjiIshVPAZu
         udlefvkj0b9h+HOx8S9tz4QlqJhSZz1aYgDqLdzYwuz+Mqdpm5rSuDsR2fdB4ooXCSOj
         pkG0+sGkEBfXlPP+9TeN5Kn/33oZ9/jVkEWpfB7ufDw0Vri9yPi4/Ji3RKiYSWagl8uL
         ok13PANuWy2iSMLLelrqviSULV67IDwrtsly0kWwmGU3xaOu1D2OsYkqie2CRWkhRY3X
         f4vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683571418; x=1686163418;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NMLTaac8rhvSbe/caPsDcy8khu+PZxjEUlyzscx2eKA=;
        b=Uxz+UN68anLw0HDTutXhHkLQ4tpZSRKQlrBXT9Zy8VT7dWTjNjTvW9R6gSBJ4gsMaI
         j3niworNaE44Oe0Ohv1npF/T7KjAmlYYs9lT8fMETAVm1okZkTmYUlGJSWq4GxaKjs09
         Z6cJ5ACEOeEtDi6OC7OgFF5IGITIwq5ufvzklg4i3VGGLX6fxGu0oWfKIwfc6SDsj6Vs
         LOkeosDJVJjAI2gpvY+eqaRqDSKTmt91s0YMqPQotzv3zYezdFJsldbLj0m1zHRjp1eO
         X7aAOlc2a11jbQr1BTsNKBadYWSx+5/u3ldSmhRn/ruipdg+O1xSW2BuTV5lZDm7iJrh
         PXYQ==
X-Gm-Message-State: AC+VfDyHOXXyc2N+644x7peUJ0RoadmI4z12WAoBW6vEq2nGPYw5YLhK
	jEjne6hb4j7C9wxTNRTPJOi8UXsSvhU=
X-Google-Smtp-Source: ACHHUZ7Z2b4Oo4Lmmx+DSACF7wASYvMSlycMNruoSKf1WSu1DDkuSQ+MC1flEToLEuDdgI5nbWkhig==
X-Received: by 2002:a05:622a:13c8:b0:3ef:4007:485a with SMTP id p8-20020a05622a13c800b003ef4007485amr16533078qtk.68.1683571418182;
        Mon, 08 May 2023 11:43:38 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v26-20020ac83d9a000000b003d3a34d2eb2sm3193988qtf.41.2023.05.08.11.43.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 11:43:37 -0700 (PDT)
From: Florian Fainelli <f.fainelli@gmail.com>
To: netdev@vger.kernel.org
Cc: Florian Fainelli <f.fainelli@gmail.com>,
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
Subject: [PATCH net-next 2/3] net: phy: broadcom: Add support for Wake-on-LAN
Date: Mon,  8 May 2023 11:43:08 -0700
Message-Id: <20230508184309.1628108-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230508184309.1628108-1-f.fainelli@gmail.com>
References: <20230508184309.1628108-1-f.fainelli@gmail.com>
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

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/bcm-phy-lib.c | 212 ++++++++++++++++++++++++++++++++++
 drivers/net/phy/bcm-phy-lib.h |   5 +
 drivers/net/phy/broadcom.c    | 124 +++++++++++++++++++-
 include/linux/brcmphy.h       |  55 +++++++++
 4 files changed, 392 insertions(+), 4 deletions(-)

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
index 3f142dc266a9..a9dfa230495b 100644
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
 
@@ -437,14 +460,38 @@ static int bcm54xx_iddq_set(struct phy_device *phydev, bool enable)
 	return ret;
 }
 
-static int bcm54xx_suspend(struct phy_device *phydev)
+static int bcm54xx_set_wakeup_irq(struct phy_device *phydev, bool state)
 {
+	struct bcm54xx_phy_priv *priv = phydev->priv;
 	int ret;
 
+	if (!bcm54xx_phy_can_wakeup(phydev))
+		return 0;
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
+static int bcm54xx_suspend(struct phy_device *phydev)
+{
+	int ret = 0;
+
 	bcm54xx_ptp_stop(phydev);
 
+	/* Acknowledge any Wake-on-LAN interrupt prior to suspend */
+	ret = bcm_phy_read_exp(phydev, BCM54XX_WOL_INT_STATUS);
+	if (ret < 0)
+		return ret;
+
 	if (phydev->wol_enabled)
-		return 0;
+		return bcm54xx_set_wakeup_irq(phydev, true);
 
 	/* We cannot use a read/modify/write here otherwise the PHY gets into
 	 * a bad state where its LEDs keep flashing, thus defeating the purpose
@@ -459,7 +506,13 @@ static int bcm54xx_suspend(struct phy_device *phydev)
 
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
@@ -807,14 +860,54 @@ static int brcm_fet_suspend(struct phy_device *phydev)
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
@@ -827,7 +920,28 @@ static int bcm54xx_phy_probe(struct phy_device *phydev)
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
+		return ret;
+
+	return device_init_wakeup(&phydev->mdio.dev, true);
 }
 
 static void bcm54xx_get_stats(struct phy_device *phydev,
@@ -910,6 +1024,8 @@ static struct phy_driver broadcom_drivers[] = {
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


