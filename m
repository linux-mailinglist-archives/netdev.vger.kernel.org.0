Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2347C27E1B5
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 08:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728349AbgI3Gtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 02:49:52 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:60419 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbgI3Gtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 02:49:49 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.69 with qID 08U6nBoqD032161, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb04.realtek.com.tw[172.21.6.97])
        by rtits2.realtek.com.tw (8.15.2/2.66/5.86) with ESMTPS id 08U6nBoqD032161
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 30 Sep 2020 14:49:11 +0800
Received: from localhost.localdomain (172.21.179.130) by
 RTEXMB04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Wed, 30 Sep 2020 14:49:10 +0800
From:   Willy Liu <willy.liu@realtek.com>
To:     <andrew@lunn.ch>
CC:     <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ryankao@realtek.com>,
        Willy Liu <willy.liu@realtek.com>
Subject: [PATCH net v1] net: phy: realtek: Modify 2.5G PHY name to RTL8226
Date:   Wed, 30 Sep 2020 14:48:58 +0800
Message-ID: <1601448538-18004-1-git-send-email-willy.liu@realtek.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.179.130]
X-ClientProxiedBy: RTEXMB01.realtek.com.tw (172.21.6.94) To
 RTEXMB04.realtek.com.tw (172.21.6.97)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Realtek single-chip Ethernet PHY solutions can be separated as below:
10M/100Mbps: RTL8201X
1Gbps: RTL8211X
2.5Gbps: RTL8226/RTL8221X
RTL8226 is the first version for realtek that compatible 2.5Gbps single PHY.
Since RTL8226 is single port only, realtek changes its name to RTL8221B from
the second version.
PHY ID for RTL8226 is 0x001cc800 and RTL8226B/RTL8221B is 0x001cc840.

RTL8125 is not a single PHY solution, it integrates PHY/MAC/PCIE bus
controller and embedded memory.

Signed-off-by: Willy Liu <willy.liu@realtek.com>
---
 drivers/net/phy/realtek.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 0f09609..f207607 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -401,7 +401,7 @@ static int rtlgen_write_mmd(struct phy_device *phydev, int devnum, u16 regnum,
 	return ret;
 }
 
-static int rtl8125_read_mmd(struct phy_device *phydev, int devnum, u16 regnum)
+static int rtl822x_read_mmd(struct phy_device *phydev, int devnum, u16 regnum)
 {
 	int ret = rtlgen_read_mmd(phydev, devnum, regnum);
 
@@ -425,7 +425,7 @@ static int rtl8125_read_mmd(struct phy_device *phydev, int devnum, u16 regnum)
 	return ret;
 }
 
-static int rtl8125_write_mmd(struct phy_device *phydev, int devnum, u16 regnum,
+static int rtl822x_write_mmd(struct phy_device *phydev, int devnum, u16 regnum,
 			     u16 val)
 {
 	int ret = rtlgen_write_mmd(phydev, devnum, regnum, val);
@@ -442,7 +442,7 @@ static int rtl8125_write_mmd(struct phy_device *phydev, int devnum, u16 regnum,
 	return ret;
 }
 
-static int rtl8125_get_features(struct phy_device *phydev)
+static int rtl822x_get_features(struct phy_device *phydev)
 {
 	int val;
 
@@ -460,7 +460,7 @@ static int rtl8125_get_features(struct phy_device *phydev)
 	return genphy_read_abilities(phydev);
 }
 
-static int rtl8125_config_aneg(struct phy_device *phydev)
+static int rtl822x_config_aneg(struct phy_device *phydev)
 {
 	int ret = 0;
 
@@ -480,7 +480,7 @@ static int rtl8125_config_aneg(struct phy_device *phydev)
 	return __genphy_config_aneg(phydev, ret);
 }
 
-static int rtl8125_read_status(struct phy_device *phydev)
+static int rtl822x_read_status(struct phy_device *phydev)
 {
 	int ret;
 
@@ -522,7 +522,7 @@ static int rtlgen_match_phy_device(struct phy_device *phydev)
 	       !rtlgen_supports_2_5gbps(phydev);
 }
 
-static int rtl8125_match_phy_device(struct phy_device *phydev)
+static int rtl8226_match_phy_device(struct phy_device *phydev)
 {
 	return phydev->phy_id == RTL_GENERIC_PHYID &&
 	       rtlgen_supports_2_5gbps(phydev);
@@ -627,29 +627,29 @@ static int rtlgen_resume(struct phy_device *phydev)
 		.read_mmd	= rtlgen_read_mmd,
 		.write_mmd	= rtlgen_write_mmd,
 	}, {
-		.name		= "RTL8125 2.5Gbps internal",
-		.match_phy_device = rtl8125_match_phy_device,
-		.get_features	= rtl8125_get_features,
-		.config_aneg	= rtl8125_config_aneg,
-		.read_status	= rtl8125_read_status,
+		.name		= "RTL8226 2.5Gbps PHY",
+		.match_phy_device = rtl8226_match_phy_device,
+		.get_features	= rtl822x_get_features,
+		.config_aneg	= rtl822x_config_aneg,
+		.read_status	= rtl822x_read_status,
 		.suspend	= genphy_suspend,
 		.resume		= rtlgen_resume,
 		.read_page	= rtl821x_read_page,
 		.write_page	= rtl821x_write_page,
-		.read_mmd	= rtl8125_read_mmd,
-		.write_mmd	= rtl8125_write_mmd,
+		.read_mmd	= rtl822x_read_mmd,
+		.write_mmd	= rtl822x_write_mmd,
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc840),
-		.name		= "RTL8125B 2.5Gbps internal",
-		.get_features	= rtl8125_get_features,
-		.config_aneg	= rtl8125_config_aneg,
-		.read_status	= rtl8125_read_status,
+		.name		= "RTL8226B_RTL8221B 2.5Gbps PHY",
+		.get_features	= rtl822x_get_features,
+		.config_aneg	= rtl822x_config_aneg,
+		.read_status	= rtl822x_read_status,
 		.suspend	= genphy_suspend,
 		.resume		= rtlgen_resume,
 		.read_page	= rtl821x_read_page,
 		.write_page	= rtl821x_write_page,
-		.read_mmd	= rtl8125_read_mmd,
-		.write_mmd	= rtl8125_write_mmd,
+		.read_mmd	= rtl822x_read_mmd,
+		.write_mmd	= rtl822x_write_mmd,
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc961),
 		.name		= "RTL8366RB Gigabit Ethernet",
-- 
1.9.1

