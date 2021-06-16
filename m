Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5C453A96DC
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 12:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232421AbhFPKHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 06:07:05 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:7308 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232249AbhFPKGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 06:06:50 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G4gdp0Mxcz1BN9T;
        Wed, 16 Jun 2021 17:59:42 +0800 (CST)
Received: from dggema753-chm.china.huawei.com (10.1.198.195) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 18:04:42 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggema753-chm.china.huawei.com (10.1.198.195) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 16 Jun 2021 18:04:42 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>,
        Weihang Li <liweihang@huawei.com>
Subject: [PATCH v2 net-next 8/8] net: phy: replace if-else statements with switch
Date:   Wed, 16 Jun 2021 18:01:26 +0800
Message-ID: <1623837686-22569-9-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623837686-22569-1-git-send-email-liweihang@huawei.com>
References: <1623837686-22569-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggema753-chm.china.huawei.com (10.1.198.195)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch statement is clearer than a group of 'if-else'.

Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/net/phy/marvell.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 23751d9..3de93c9 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -809,14 +809,19 @@ static int m88e1111_config_init_rgmii_delays(struct phy_device *phydev)
 {
 	int delay;
 
-	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID) {
+	switch (phydev->interface) {
+	case PHY_INTERFACE_MODE_RGMII_ID:
 		delay = MII_M1111_RGMII_RX_DELAY | MII_M1111_RGMII_TX_DELAY;
-	} else if (phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID) {
+		break;
+	case PHY_INTERFACE_MODE_RGMII_RXID:
 		delay = MII_M1111_RGMII_RX_DELAY;
-	} else if (phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID) {
+		break;
+	case PHY_INTERFACE_MODE_RGMII_TXID:
 		delay = MII_M1111_RGMII_TX_DELAY;
-	} else {
+		break;
+	default:
 		delay = 0;
+		break;
 	}
 
 	return phy_modify(phydev, MII_M1111_PHY_EXT_CR,
-- 
2.8.1

