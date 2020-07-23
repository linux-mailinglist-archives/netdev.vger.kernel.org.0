Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41AF22AE74
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbgGWLze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:55:34 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:18544 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgGWLzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 07:55:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595505332; x=1627041332;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J3apM0TMNZPjzmKoMGW/09O+HqgQgUeIiaTSSKA7Xsw=;
  b=cNxkofp/pvlCNYJMWEBAFDsdgNgK4hQYmawIGcmVohJmcZxOvd4BoK0z
   hwwA+yycUtfUNiQg2siWUWsYjm6ZaMcMaX1QYW0oJI7KkqMyEHd1DBu9B
   AzIXxjRD/puF5ciejBzBxmndy8DYnAX0Occb7hKW7L07EwICMEqnBX4lk
   Issih6RiVGmFyfYBm5N8z2NgNR/r+sfnWMOsdn+GDLDn3p4nK4h45JFhD
   w4ZbAPtIhkXoG0rsCXW8Y2HGj0+Puq+WMN4K8TBgbguD+107T8RNOtHzp
   ZMSz+UfLsQ2eDyN50zotL4ZnS385qBC++cOC71jxeZcWws6amkQGzKr77
   w==;
IronPort-SDR: StEJ5FJAZ7xFYigqujBYO1rn1L2zxPt2NqPgm2mliNo/g5HWN6kt7CtHvi7Zsy8syB5cWX0i5b
 Wmxp/An4yI8IezGVUbGAdtq165q1DhexASnRQ9YiyggBRo7B5k4b2RmEGMnd6IHfwzSc8qF0Cn
 mAA8figQDEyjEKakigtuSIlN/Q72IuCo4BqNt4rIfQSzKXpyzwVOJBqzco3/EFlPp9nOOifRpC
 jGLJmQuTzLECNjEAoIuqL+Hfdd0F7FFNF227IjxGKbYbAA9ocPWoq9ufun7GN1BdssL0+BbU3+
 9aY=
X-IronPort-AV: E=Sophos;i="5.75,386,1589266800"; 
   d="scan'208";a="85096759"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Jul 2020 04:55:31 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 23 Jul 2020 04:54:52 -0700
Received: from xasv.mchp-main.com (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 23 Jul 2020 04:54:48 -0700
From:   Andre Edich <andre.edich@microchip.com>
To:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <steve.glendinning@shawell.net>
CC:     <Parthiban.Veerasooran@microchip.com>,
        Andre Edich <andre.edich@microchip.com>
Subject: [PATCH net-next v2 1/6] smsc95xx: remove redundant function arguments
Date:   Thu, 23 Jul 2020 13:55:02 +0200
Message-ID: <20200723115507.26194-2-andre.edich@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200723115507.26194-1-andre.edich@microchip.com>
References: <20200723115507.26194-1-andre.edich@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch removes arguments netdev and phy_id from the functions
smsc95xx_mdio_read_nopm and smsc95xx_mdio_write_nopm.  Both removed
arguments are recovered from a new argument `struct usbnet *dev`.

Signed-off-by: Andre Edich <andre.edich@microchip.com>
---
 drivers/net/usb/smsc95xx.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index bb4ccbda031a..3fdf7c2b2d25 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -261,16 +261,18 @@ static void __smsc95xx_mdio_write(struct net_device *netdev, int phy_id,
 	mutex_unlock(&dev->phy_mutex);
 }
 
-static int smsc95xx_mdio_read_nopm(struct net_device *netdev, int phy_id,
-				   int idx)
+static int smsc95xx_mdio_read_nopm(struct usbnet *dev, int idx)
 {
-	return __smsc95xx_mdio_read(netdev, phy_id, idx, 1);
+	struct mii_if_info *mii = &dev->mii;
+
+	return __smsc95xx_mdio_read(dev->net, mii->phy_id, idx, 1);
 }
 
-static void smsc95xx_mdio_write_nopm(struct net_device *netdev, int phy_id,
-				     int idx, int regval)
+static void smsc95xx_mdio_write_nopm(struct usbnet *dev, int idx, int regval)
 {
-	__smsc95xx_mdio_write(netdev, phy_id, idx, regval, 1);
+	struct mii_if_info *mii = &dev->mii;
+
+	__smsc95xx_mdio_write(dev->net, mii->phy_id, idx, regval, 1);
 }
 
 static int smsc95xx_mdio_read(struct net_device *netdev, int phy_id, int idx)
@@ -1347,39 +1349,37 @@ static u32 smsc_crc(const u8 *buffer, size_t len, int filter)
 
 static int smsc95xx_enable_phy_wakeup_interrupts(struct usbnet *dev, u16 mask)
 {
-	struct mii_if_info *mii = &dev->mii;
 	int ret;
 
 	netdev_dbg(dev->net, "enabling PHY wakeup interrupts\n");
 
 	/* read to clear */
-	ret = smsc95xx_mdio_read_nopm(dev->net, mii->phy_id, PHY_INT_SRC);
+	ret = smsc95xx_mdio_read_nopm(dev, PHY_INT_SRC);
 	if (ret < 0)
 		return ret;
 
 	/* enable interrupt source */
-	ret = smsc95xx_mdio_read_nopm(dev->net, mii->phy_id, PHY_INT_MASK);
+	ret = smsc95xx_mdio_read_nopm(dev, PHY_INT_MASK);
 	if (ret < 0)
 		return ret;
 
 	ret |= mask;
 
-	smsc95xx_mdio_write_nopm(dev->net, mii->phy_id, PHY_INT_MASK, ret);
+	smsc95xx_mdio_write_nopm(dev, PHY_INT_MASK, ret);
 
 	return 0;
 }
 
 static int smsc95xx_link_ok_nopm(struct usbnet *dev)
 {
-	struct mii_if_info *mii = &dev->mii;
 	int ret;
 
 	/* first, a dummy read, needed to latch some MII phys */
-	ret = smsc95xx_mdio_read_nopm(dev->net, mii->phy_id, MII_BMSR);
+	ret = smsc95xx_mdio_read_nopm(dev, MII_BMSR);
 	if (ret < 0)
 		return ret;
 
-	ret = smsc95xx_mdio_read_nopm(dev->net, mii->phy_id, MII_BMSR);
+	ret = smsc95xx_mdio_read_nopm(dev, MII_BMSR);
 	if (ret < 0)
 		return ret;
 
@@ -1428,7 +1428,6 @@ static int smsc95xx_enter_suspend0(struct usbnet *dev)
 static int smsc95xx_enter_suspend1(struct usbnet *dev)
 {
 	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
-	struct mii_if_info *mii = &dev->mii;
 	u32 val;
 	int ret;
 
@@ -1436,17 +1435,17 @@ static int smsc95xx_enter_suspend1(struct usbnet *dev)
 	 * compatibility with non-standard link partners
 	 */
 	if (pdata->features & FEATURE_PHY_NLP_CROSSOVER)
-		smsc95xx_mdio_write_nopm(dev->net, mii->phy_id,	PHY_EDPD_CONFIG,
-			PHY_EDPD_CONFIG_DEFAULT);
+		smsc95xx_mdio_write_nopm(dev, PHY_EDPD_CONFIG,
+					 PHY_EDPD_CONFIG_DEFAULT);
 
 	/* enable energy detect power-down mode */
-	ret = smsc95xx_mdio_read_nopm(dev->net, mii->phy_id, PHY_MODE_CTRL_STS);
+	ret = smsc95xx_mdio_read_nopm(dev, PHY_MODE_CTRL_STS);
 	if (ret < 0)
 		return ret;
 
 	ret |= MODE_CTRL_STS_EDPWRDOWN_;
 
-	smsc95xx_mdio_write_nopm(dev->net, mii->phy_id, PHY_MODE_CTRL_STS, ret);
+	smsc95xx_mdio_write_nopm(dev, PHY_MODE_CTRL_STS, ret);
 
 	/* enter SUSPEND1 mode */
 	ret = smsc95xx_read_reg_nopm(dev, PM_CTRL, &val);
-- 
2.27.0

