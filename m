Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F00C116EA1
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 03:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbfEHBbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 21:31:13 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:46401 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbfEHBbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 21:31:13 -0400
Received: by mail-lf1-f66.google.com with SMTP id k18so13220214lfj.13;
        Tue, 07 May 2019 18:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NyDW43yoQYjW9g0Ln4yG00lKc6rchQbeDoTk5+PUiIQ=;
        b=sZsknXAoC7hrqMauGhpBA73NQsaklEaVCQjQu+RTHTt7WDI+Tv+2N4y6XAPf4sSbMg
         4Ja3PYpadReWKlf8sqJ8A2ohrlQT/1oiqft2GhDeJpdeoEWE/JOZ+aNMfEZ7NBC+hm2M
         dO10FZGTL8nI73OwEw7fsm7nAnOugZPfL2RxIZky+A6XLhpyqg2mIPOusrBn0juZGjNW
         aR0F9qR0soX4SfNu0vFoYvu2Yx6oKD5M2EIuIKpTZ0D3TYdta8fXuUEfEvEEgs/uBJ/I
         Vu8v/bI0+ES+XGYEpf1aKiYT8MuXAVaF5F/BqakCuDylft5QgK0JwxWrsFp0bVITM8zv
         DvTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NyDW43yoQYjW9g0Ln4yG00lKc6rchQbeDoTk5+PUiIQ=;
        b=ddsqOrmtNoKiJ8Djv6YcOHShBDRQZhmT7/dRvzG5z91jQc9Ghe1R4pq0/jXmhMof7X
         9uruVkUR5Vy/HDKOl3Na9EYS4n4w59BLpldcf9ZfLtlypjZG50PWB+a0HwB1GGa8y+ky
         xJt5Twy3Ajy+LsFQykvnSn9ch8M1uDpXSabvh6h3FnI/njBcwppgXYs2jGxmcULF8Ldc
         uGQEblf+Y2g+3X9DfICC1mXhMrInkbJ87afVHgq0+kn814Qs/E645ZvWa6kCAT3M7P6t
         BU7eOXZ1PQ7KVDR5nzAIeAUbJGBm0WPGUJW300B1YF6S7LmmsEwReoPIHpbwwc/L8sD9
         AVQQ==
X-Gm-Message-State: APjAAAVbyZeE3xxOzN5SIGWWjd4RAdQBkKRne40nq1N01ebGKUgMO8CG
        8+hGgzwGyLTLExD8MDpyid0=
X-Google-Smtp-Source: APXvYqw0rWwMkJk0vCghDpYg2q4B9+Pig9Oct/JCcTMlnnIjWwrNDI2ADUWPy0X4fVThO29Gv0Tnyg==
X-Received: by 2002:ac2:5606:: with SMTP id v6mr36511lfd.129.1557279070452;
        Tue, 07 May 2019 18:31:10 -0700 (PDT)
Received: from localhost.localdomain ([5.164.217.122])
        by smtp.gmail.com with ESMTPSA id o1sm3524339ljd.74.2019.05.07.18.31.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 18:31:09 -0700 (PDT)
From:   Serge Semin <fancer.lancer@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Serge Semin <Sergey.Semin@t-platforms.ru>,
        Vladimir Oltean <olteanv@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] net: phy: realtek: Add rtl8211e rx/tx delays config
Date:   Wed,  8 May 2019 04:29:20 +0300
Message-Id: <20190508012920.13710-2-fancer.lancer@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190508012920.13710-1-fancer.lancer@gmail.com>
References: <20190508012920.13710-1-fancer.lancer@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two chip pins named TXDLY and RXDLY which actually adds the 2ns
delays to TXC and RXC for TXD/RXD latching. Alas this is the only
documented info regarding the RGMII timing control configurations the PHY
provides. It turns out the same settings can be setup via MDIO registers
hidden in the extension pages layout. Particularly the extension page 0xa4
provides a register 0x1c, which bits 1 and 2 control the described delays.
They are used to implement the "rgmii-{id,rxid,txid}" phy-mode.

The hidden RGMII configs register utilization was found in the rtl8211e
U-boot driver:
https://elixir.bootlin.com/u-boot/v2019.01/source/drivers/net/phy/realtek.c#L99

There is also a freebsd-folks discussion regarding this register:
https://reviews.freebsd.org/D13591

It confirms that the register bits field must control the so called
configuration pins described in the table 12-13 of the official PHY
datasheet:
8:6 = PHY Address
5:4 = Auto-Negotiation
3 = Interface Mode Select
2 = RX Delay
1 = TX Delay
0 = SELRGV

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Serge Semin <fancer.lancer@gmail.com>

---
Changelog v2
- Disable delays for rgmii mode and leave them as is for the rest of
  the modes.
- Remove genphy_config_init() invocation. It's redundant for rtl8211e phy.
- Fix confused return value checking of extended-page selector call.
- Fix commit message typos.

Changelog v3
- Add Andrew' Reviewed-by tag
- Initialize ret with 0 to prevent the "may be used uninitialized" warning.
---
 drivers/net/phy/realtek.c | 51 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 10df52ccddfe..d27f072f227b 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -23,11 +23,15 @@
 
 #define RTL821x_INSR				0x13
 
+#define RTL821x_EXT_PAGE_SELECT			0x1e
 #define RTL821x_PAGE_SELECT			0x1f
 
 #define RTL8211F_INSR				0x1d
 
 #define RTL8211F_TX_DELAY			BIT(8)
+#define RTL8211E_TX_DELAY			BIT(1)
+#define RTL8211E_RX_DELAY			BIT(2)
+#define RTL8211E_MODE_MII_GMII			BIT(3)
 
 #define RTL8201F_ISR				0x1e
 #define RTL8201F_IER				0x13
@@ -174,6 +178,52 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 	return phy_modify_paged(phydev, 0xd08, 0x11, RTL8211F_TX_DELAY, val);
 }
 
+static int rtl8211e_config_init(struct phy_device *phydev)
+{
+	int ret = 0, oldpage;
+	u16 val;
+
+	/* enable TX/RX delay for rgmii-* modes, and disable them for rgmii. */
+	switch (phydev->interface) {
+	case PHY_INTERFACE_MODE_RGMII:
+		val = 0;
+		break;
+	case PHY_INTERFACE_MODE_RGMII_ID:
+		val = RTL8211E_TX_DELAY | RTL8211E_RX_DELAY;
+		break;
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+		val = RTL8211E_RX_DELAY;
+		break;
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+		val = RTL8211E_TX_DELAY;
+		break;
+	default: /* the rest of the modes imply leaving delays as is. */
+		return 0;
+	}
+
+	/* According to a sample driver there is a 0x1c config register on the
+	 * 0xa4 extension page (0x7) layout. It can be used to disable/enable
+	 * the RX/TX delays otherwise controlled by hardware strobes. It can
+	 * also be used to customize the whole configuration register:
+	 * 8:6 = PHY Address, 5:4 = Auto-Negotiation, 3 = Interface Mode Select,
+	 * 2 = RX Delay, 1 = TX Delay, 0 = SELRGV (see original PHY datasheet
+	 * for details).
+	 */
+	oldpage = phy_select_page(phydev, 0x7);
+	if (oldpage < 0)
+		goto err_restore_page;
+
+	ret = phy_write(phydev, RTL821x_EXT_PAGE_SELECT, 0xa4);
+	if (ret)
+		goto err_restore_page;
+
+	ret = phy_modify(phydev, 0x1c, RTL8211E_TX_DELAY | RTL8211E_RX_DELAY,
+			 val);
+
+err_restore_page:
+	return phy_restore_page(phydev, oldpage, ret);
+}
+
 static int rtl8211b_suspend(struct phy_device *phydev)
 {
 	phy_write(phydev, MII_MMD_DATA, BIT(9));
@@ -257,6 +307,7 @@ static struct phy_driver realtek_drvs[] = {
 		PHY_ID_MATCH_EXACT(0x001cc915),
 		.name		= "RTL8211E Gigabit Ethernet",
 		.features	= PHY_GBIT_FEATURES,
+		.config_init	= &rtl8211e_config_init,
 		.ack_interrupt	= &rtl821x_ack_interrupt,
 		.config_intr	= &rtl8211e_config_intr,
 		.suspend	= genphy_suspend,
-- 
2.21.0

