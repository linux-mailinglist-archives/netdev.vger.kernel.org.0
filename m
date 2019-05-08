Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10744181D0
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 23:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbfEHVw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 17:52:27 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42920 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726837AbfEHVw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 17:52:27 -0400
Received: by mail-lj1-f194.google.com with SMTP id 188so207146ljf.9;
        Wed, 08 May 2019 14:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ce9SVTx37srshlbtpi0Hb0qG++vxFook/tLW3MBzfkQ=;
        b=EUGBa/bCvTdC4VNOvz1rkrBb2Gwa5KHUC8R0B2eGI7S/2dXr9BR07XV86zUZKeFEBz
         9X/uasgC+Kkbo5/azf1SnENbU9C08wzZGUkowvGpT6W0W7Rs3oMAJpGAaiZi/ws1LQAF
         NihI9KniVMMBklTTRSwRqZ4mnfvHpE/JXZsmXFbEAKANxZe9p9yu9unDmY28pbcJcW9H
         Iw7l7Ot1uy4+RE8Qw22sFSKbIisuqL00t6bCUrrg9hYb5kdlP2vCnfFBMcYwliWfu7jP
         EDnHxABSqkDMXWXobVs1sWkqNFwRJdHguz4YxJDb9DLeaBfkTRlei6+IM1HNNvXjXaSf
         k7aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ce9SVTx37srshlbtpi0Hb0qG++vxFook/tLW3MBzfkQ=;
        b=qHbE4f+N7MSCXPgmpCENB+e0sy8G+58OTYp8HwtubH+xRfgWFEIEX+DccJ0t7d01ei
         jGc5KTarpvg2QVZgpe5LfXegokQ4Ho/dcVlDBe28hCO7KlSIaQdcAZ+77/Q7gNgN1TD1
         967hTIemf/Qoiz9nCObSETjER19wo2f+6INE1pHfM2q0HAVMSV/F1jMzX1o4/gzjr8KW
         HgEhm4pKhz65yzsW1d8XssJY0anBdDtiDoyNh+WrcAJBFWf2X6/lMWNPBYc7cxux6MWw
         VOKzRo9dlHqNu5BGTLZNTX4v3At7e+q64+3XQ5CPTxbOlWF9YqYvpibY1Bq30/tXJ5Ym
         NlIw==
X-Gm-Message-State: APjAAAU5s89sueW1c0rGrm8jgjK2ZXD3zEFIXOInMmKSbsaOQqCG3NB/
        Xtj363UC+oQtQpMZ046Cebc=
X-Google-Smtp-Source: APXvYqzEA88d3HUMmOjd7XrDC2woinUpAtQFkfaf28bs4jGQuIolYfrxMJDEJErzmIggxIthbmwsOQ==
X-Received: by 2002:a2e:90cc:: with SMTP id o12mr62371ljg.133.1557352344143;
        Wed, 08 May 2019 14:52:24 -0700 (PDT)
Received: from localhost.localdomain ([5.164.217.122])
        by smtp.gmail.com with ESMTPSA id l5sm28279lfh.70.2019.05.08.14.52.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 14:52:23 -0700 (PDT)
From:   Serge Semin <fancer.lancer@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Serge Semin <Sergey.Semin@t-platforms.ru>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/2] net: phy: realtek: Add rtl8211e rx/tx delays config
Date:   Thu,  9 May 2019 00:51:15 +0300
Message-Id: <20190508215115.19802-2-fancer.lancer@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190508215115.19802-1-fancer.lancer@gmail.com>
References: <20190508215115.19802-1-fancer.lancer@gmail.com>
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

Changelog v4
- Rebase onto net-next
---
 drivers/net/phy/realtek.c | 51 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index d6a10f323117..cfbc0ca61123 100644
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
@@ -167,6 +171,52 @@ static int rtl8211f_config_init(struct phy_device *phydev)
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
+	 * the RX/TX delays otherwise controlled by RXDLY/TXDLY pins. It can
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
@@ -239,6 +289,7 @@ static struct phy_driver realtek_drvs[] = {
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc915),
 		.name		= "RTL8211E Gigabit Ethernet",
+		.config_init	= &rtl8211e_config_init,
 		.ack_interrupt	= &rtl821x_ack_interrupt,
 		.config_intr	= &rtl8211e_config_intr,
 		.suspend	= genphy_suspend,
-- 
2.21.0

