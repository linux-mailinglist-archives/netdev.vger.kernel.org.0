Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2965411229
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 11:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236587AbhITJxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 05:53:03 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:37420 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236367AbhITJwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 05:52:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632131479; x=1663667479;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VnYOMjMEpb5JvuNo/2w6R+bDMUQ9dU4MVRLlawFW0TM=;
  b=AR8Gi8QE2HCevgOP863K7uU/PMaLAJXHAtcPY669sKXVS375zqo5aR3p
   WJXGkWi+429aaO5p2DDOciZ1ec6YzVXOiDaVt5vzZYaj+WJPcu9ozwoW6
   s0tn7U19bjhj5NCbEwKdJUiBZDft8UjD3vuGtrIXlNKh5gyrF/9UIiF3d
   vi0RDVAblHBcgqw0aVni6cytoFAiotg3FsLqsYtXjGnClAXReGcuEQ2EI
   Ub+2bkioUWq9lLUHpxARAmFARsxxvQIoth4q+xwLzBktTTe4090HnHZVV
   b8WQOZ71cpnLWGB+I1YxWYufknYUt5ZtGCabjZnjsg+JgdFGX76zjkuok
   Q==;
IronPort-SDR: UPUJcA8xRPYPnN0ZEhJ0IssqSBzCZsZb4x4xkdq1fRsg+Ita8zTv9meZP+Ow5gLYKE/jwR1Ls+
 TSSSXOca+xydBF1AE4urawSsohEHp/z3f9aGn9g8fwGngSIlHOBhxdCWjODdw+de8xVT5wGMDw
 fhR4mSH76A4o7hJuJCRJl0Acr6l01/lEzMOgzaZTs5Q64D/GrelBjc4KY2Pwshxf/3YqDnK5Kl
 T6Mf/iSmktrrS5llrRCHQs+tKgxak++BUUAsK2opurDT32B/+l9/aHeqmhdbu9NHRrATzTEaVt
 0XBtF+10TKE5NSfnSHQV4N46
X-IronPort-AV: E=Sophos;i="5.85,308,1624345200"; 
   d="scan'208";a="129913557"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Sep 2021 02:51:18 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 20 Sep 2021 02:51:18 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Mon, 20 Sep 2021 02:51:15 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <andrew@lunn.ch>, <linux@armlinux.org.uk>, <f.fainelli@gmail.com>,
        <alexandre.belloni@bootlin.com>, <vladimir.oltean@nxp.com>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-phy@lists.infradead.org>, <linux-pm@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC PATCH net-next 02/12] net: phy: mchp: Add support for LAN8804 PHY
Date:   Mon, 20 Sep 2021 11:52:08 +0200
Message-ID: <20210920095218.1108151-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210920095218.1108151-1-horatiu.vultur@microchip.com>
References: <20210920095218.1108151-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The LAN8804 SKY has same features as that of LAN8804 SKY except that it
doesn't support 1588, SyncE or Q-USGMII.

This PHY is found inside the LAN966X switches.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/phy/micrel.c   | 73 ++++++++++++++++++++++++++++++++++++++
 include/linux/micrel_phy.h |  1 +
 2 files changed, 74 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 5c928f827173..34800b547004 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1537,6 +1537,65 @@ static int ksz886x_cable_test_get_status(struct phy_device *phydev,
 	return ret;
 }
 
+#define LAN_EXT_PAGE_ACCESS_CONTROL			0x16
+#define LAN_EXT_PAGE_ACCESS_ADDRESS_DATA		0x17
+#define LAN_EXT_PAGE_ACCESS_CTRL_EP_FUNC		0x4000
+
+#define LAN8804_ALIGN_SWAP				0x4a
+#define LAN8804_ALIGN_TX_A_B_SWAP			0x1
+#define LAN8804_ALIGN_TX_A_B_SWAP_MASK			GENMASK(2, 0)
+#define LAN8814_CLOCK_MANAGEMENT			0xd
+#define LAN8814_LINK_QUALITY				0x8e
+
+static int lanphy_read_page_reg(struct phy_device *phydev, int page, u32 addr)
+{
+	u32 data;
+
+	phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL, page);
+	phy_write(phydev, LAN_EXT_PAGE_ACCESS_ADDRESS_DATA, addr);
+	phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL,
+		  (page | LAN_EXT_PAGE_ACCESS_CTRL_EP_FUNC));
+	data = phy_read(phydev, LAN_EXT_PAGE_ACCESS_ADDRESS_DATA);
+
+	return data;
+}
+
+static int lanphy_write_page_reg(struct phy_device *phydev, int page, u16 addr,
+				 u16 val)
+{
+	phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL, page);
+	phy_write(phydev, LAN_EXT_PAGE_ACCESS_ADDRESS_DATA, addr);
+	phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL,
+		  (page | LAN_EXT_PAGE_ACCESS_CTRL_EP_FUNC));
+
+	val = phy_write(phydev, LAN_EXT_PAGE_ACCESS_ADDRESS_DATA, val);
+	if (val) {
+		phydev_err(phydev, "Error: phy_write has returned error %d\n",
+			   val);
+		return val;
+	}
+	return 0;
+}
+
+static int lan8804_config_init(struct phy_device *phydev)
+{
+	int val;
+
+	/* MDI-X setting for swap A,B transmit */
+	val = lanphy_read_page_reg(phydev, 2, LAN8804_ALIGN_SWAP);
+	val &= ~LAN8804_ALIGN_TX_A_B_SWAP_MASK;
+	val |= LAN8804_ALIGN_TX_A_B_SWAP;
+	lanphy_write_page_reg(phydev, 2, LAN8804_ALIGN_SWAP, val);
+
+	/* Make sure that the PHY will not stop generating the clock when the
+	 * link partner goes down
+	 */
+	lanphy_write_page_reg(phydev, 31, LAN8814_CLOCK_MANAGEMENT, 0x27e);
+	lanphy_read_page_reg(phydev, 1, LAN8814_LINK_QUALITY);
+
+	return 0;
+}
+
 static struct phy_driver ksphy_driver[] = {
 {
 	.phy_id		= PHY_ID_KS8737,
@@ -1718,6 +1777,20 @@ static struct phy_driver ksphy_driver[] = {
 	.get_stats	= kszphy_get_stats,
 	.suspend	= genphy_suspend,
 	.resume		= kszphy_resume,
+}, {
+	.phy_id		= PHY_ID_LAN8804,
+	.phy_id_mask	= MICREL_PHY_ID_MASK,
+	.name		= "Microchip LAN966X Gigabit PHY",
+	.config_init	= lan8804_config_init,
+	.driver_data	= &ksz9021_type,
+	.probe		= kszphy_probe,
+	.soft_reset	= genphy_soft_reset,
+	.read_status	= ksz9031_read_status,
+	.get_sset_count	= kszphy_get_sset_count,
+	.get_strings	= kszphy_get_strings,
+	.get_stats	= kszphy_get_stats,
+	.suspend	= genphy_suspend,
+	.resume		= kszphy_resume,
 }, {
 	.phy_id		= PHY_ID_KSZ9131,
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
diff --git a/include/linux/micrel_phy.h b/include/linux/micrel_phy.h
index 3d43c60b49fa..1f7c33b2f5a3 100644
--- a/include/linux/micrel_phy.h
+++ b/include/linux/micrel_phy.h
@@ -28,6 +28,7 @@
 #define PHY_ID_KSZ9031		0x00221620
 #define PHY_ID_KSZ9131		0x00221640
 #define PHY_ID_LAN8814		0x00221660
+#define PHY_ID_LAN8804		0x00221670
 
 #define PHY_ID_KSZ886X		0x00221430
 #define PHY_ID_KSZ8863		0x00221435
-- 
2.31.1

