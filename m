Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC4762E75
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 05:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbfGIDEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 23:04:40 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2190 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725886AbfGIDEk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 23:04:40 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id A7D0215961FB8D5B5554;
        Tue,  9 Jul 2019 11:04:35 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Tue, 9 Jul 2019
 11:04:26 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <paweldembicki@gmail.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net: dsa: vsc73xx: Fix Kconfig warning and build errors
Date:   Tue, 9 Jul 2019 11:02:24 +0800
Message-ID: <20190709030224.40292-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
In-Reply-To: <20190708172808.GG9027@lunn.ch>
References: <20190708172808.GG9027@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix Kconfig dependency warning and subsequent build errors
caused by OF is not set:

WARNING: unmet direct dependencies detected for NET_DSA_VITESSE_VSC73XX
  Depends on [n]: NETDEVICES [=y] && HAVE_NET_DSA [=y] && OF [=n] && NET_DSA [=m]
  Selected by [m]:
  - NET_DSA_VITESSE_VSC73XX_PLATFORM [=m] && NETDEVICES [=y] && HAVE_NET_DSA [=y] && HAS_IOMEM [=y]

Make NET_DSA_VITESSE_VSC73XX_SPI and NET_DSA_VITESSE_VSC73XX_PLATFORM
depends on NET_DSA_VITESSE_VSC73XX to fix this.

Reported-by: Hulk Robot <hulkci@huawei.com>
Suggested-by: Andrew Lunn <andrew@lunn.ch>
Fixes: 95711cd5f0b4 ("net: dsa: vsc73xx: Split vsc73xx driver")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
v2: Use "depends on" instead of "select" NET_DSA_VITESSE_VSC73XX
---
 drivers/net/dsa/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index cf9dbd1..618853d 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -99,7 +99,7 @@ config NET_DSA_SMSC_LAN9303_MDIO
 	  for MDIO managed mode.
 
 config NET_DSA_VITESSE_VSC73XX
-	tristate
+	tristate "Vitesse VSC7385/7388/7395/7398 support"
 	depends on OF
 	depends on NET_DSA
 	select FIXED_PHY
@@ -112,7 +112,7 @@ config NET_DSA_VITESSE_VSC73XX
 config NET_DSA_VITESSE_VSC73XX_SPI
 	tristate "Vitesse VSC7385/7388/7395/7398 SPI mode support"
 	depends on SPI
-	select NET_DSA_VITESSE_VSC73XX
+	depends on NET_DSA_VITESSE_VSC73XX
 	---help---
 	  This enables support for the Vitesse VSC7385, VSC7388, VSC7395
 	  and VSC7398 SparX integrated ethernet switches in SPI managed mode.
@@ -120,7 +120,7 @@ config NET_DSA_VITESSE_VSC73XX_SPI
 config NET_DSA_VITESSE_VSC73XX_PLATFORM
 	tristate "Vitesse VSC7385/7388/7395/7398 Platform mode support"
 	depends on HAS_IOMEM
-	select NET_DSA_VITESSE_VSC73XX
+	depends on NET_DSA_VITESSE_VSC73XX
 	---help---
 	  This enables support for the Vitesse VSC7385, VSC7388, VSC7395
 	  and VSC7398 SparX integrated ethernet switches, connected over
-- 
2.7.4


