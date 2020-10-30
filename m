Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21B2F29FD84
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 06:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbgJ3F5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 01:57:36 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:54638 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgJ3F5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 01:57:35 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 09U5vAlL5025733, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb04.realtek.com.tw[172.21.6.97])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 09U5vAlL5025733
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 30 Oct 2020 13:57:10 +0800
Received: from localhost.localdomain (172.21.179.130) by
 RTEXMB04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Fri, 30 Oct 2020 13:57:10 +0800
From:   Willy Liu <willy.liu@realtek.com>
To:     <andrew@lunn.ch>
CC:     <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ryankao@realtek.com>,
        Willy Liu <willy.liu@realtek.com>
Subject: [PATCH net-next] net: phy: realtek: Add support for RTL8221B-CG series
Date:   Fri, 30 Oct 2020 13:56:20 +0800
Message-ID: <1604037380-16735-1-git-send-email-willy.liu@realtek.com>
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
---
 drivers/net/phy/realtek.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)
 mode change 100644 => 100755 drivers/net/phy/realtek.c

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
old mode 100644
new mode 100755
index fb1db71..2ba0d73
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

