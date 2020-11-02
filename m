Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27CC22A22D0
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 02:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbgKBBxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 20:53:14 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:44033 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727403AbgKBBxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 20:53:14 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 0A21qPNb9029212, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb04.realtek.com.tw[172.21.6.97])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 0A21qPNb9029212
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 2 Nov 2020 09:52:25 +0800
Received: from localhost.localdomain (172.21.179.130) by
 RTEXMB04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Mon, 2 Nov 2020 09:52:25 +0800
From:   Willy Liu <willy.liu@realtek.com>
To:     <andrew@lunn.ch>
CC:     <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ryankao@realtek.com>,
        Willy Liu <willy.liu@realtek.com>
Subject: [PATCH net-next v2] net: phy: realtek: Add support for RTL8221B-CG series
Date:   Mon, 2 Nov 2020 09:52:07 +0800
Message-ID: <1604281927-9874-1-git-send-email-willy.liu@realtek.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.179.130]
X-ClientProxiedBy: RTEXMB01.realtek.com.tw (172.21.6.94) To
 RTEXMB04.realtek.com.tw (172.21.6.97)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Realtek single-port 2.5Gbps Ethernet PHYs are list as below:
RTL8226-CG: the 1st generation 2.5Gbps single port PHY
RTL8226B-CG/RTL8221B-CG: the 2nd generation 2.5Gbps single port PHY
RTL8221B-VB-CG: the 3rd generation 2.5Gbps single port PHY
RTL8221B-VM-CG: the 2.5Gbps single port PHY with MACsec feature

This patch adds the minimal drivers to manage these transceivers.

Signed-off-by: Willy Liu <willy.liu@realtek.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/realtek.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index fb1db71..2ba0d73 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -660,6 +660,46 @@ static int rtlgen_resume(struct phy_device *phydev)
 		.read_mmd	= rtl822x_read_mmd,
 		.write_mmd	= rtl822x_write_mmd,
 	}, {
+		PHY_ID_MATCH_EXACT(0x001cc838),
+		.name           = "RTL8226-CG 2.5Gbps PHY",
+		.get_features   = rtl822x_get_features,
+		.config_aneg    = rtl822x_config_aneg,
+		.read_status    = rtl822x_read_status,
+		.suspend        = genphy_suspend,
+		.resume         = rtlgen_resume,
+		.read_page      = rtl821x_read_page,
+		.write_page     = rtl821x_write_page,
+	}, {
+		PHY_ID_MATCH_EXACT(0x001cc848),
+		.name           = "RTL8226B-CG_RTL8221B-CG 2.5Gbps PHY",
+		.get_features   = rtl822x_get_features,
+		.config_aneg    = rtl822x_config_aneg,
+		.read_status    = rtl822x_read_status,
+		.suspend        = genphy_suspend,
+		.resume         = rtlgen_resume,
+		.read_page      = rtl821x_read_page,
+		.write_page     = rtl821x_write_page,
+	}, {
+		PHY_ID_MATCH_EXACT(0x001cc849),
+		.name           = "RTL8221B-VB-CG 2.5Gbps PHY",
+		.get_features   = rtl822x_get_features,
+		.config_aneg    = rtl822x_config_aneg,
+		.read_status    = rtl822x_read_status,
+		.suspend        = genphy_suspend,
+		.resume         = rtlgen_resume,
+		.read_page      = rtl821x_read_page,
+		.write_page     = rtl821x_write_page,
+	}, {
+		PHY_ID_MATCH_EXACT(0x001cc84a),
+		.name           = "RTL8221B-VM-CG 2.5Gbps PHY",
+		.get_features   = rtl822x_get_features,
+		.config_aneg    = rtl822x_config_aneg,
+		.read_status    = rtl822x_read_status,
+		.suspend        = genphy_suspend,
+		.resume         = rtlgen_resume,
+		.read_page      = rtl821x_read_page,
+		.write_page     = rtl821x_write_page,
+	}, {
 		PHY_ID_MATCH_EXACT(0x001cc961),
 		.name		= "RTL8366RB Gigabit Ethernet",
 		.config_init	= &rtl8366rb_config_init,
-- 
1.9.1

