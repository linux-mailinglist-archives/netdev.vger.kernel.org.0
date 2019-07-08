Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B50A620B8
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 16:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731922AbfGHOnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 10:43:11 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2242 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728764AbfGHOnK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 10:43:10 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6E8F1943E1589C1575CA;
        Mon,  8 Jul 2019 22:43:08 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Mon, 8 Jul 2019
 22:42:58 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <paweldembicki@gmail.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net: dsa: vsc73xx: Fix Kconfig warning and build errors
Date:   Mon, 8 Jul 2019 22:42:24 +0800
Message-ID: <20190708144224.33376-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
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

Move OF and NET_DSA dependencies to NET_DSA_VITESSE_VSC73XX/
NET_DSA_VITESSE_VSC73XX_PLATFORM to fix this.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 631e83bf7c0e ("net: dsa: vsc73xx: add support for parallel mode")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/dsa/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index cf9dbd1..e28c209 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -100,8 +100,6 @@ config NET_DSA_SMSC_LAN9303_MDIO
 
 config NET_DSA_VITESSE_VSC73XX
 	tristate
-	depends on OF
-	depends on NET_DSA
 	select FIXED_PHY
 	select VITESSE_PHY
 	select GPIOLIB
@@ -112,6 +110,7 @@ config NET_DSA_VITESSE_VSC73XX
 config NET_DSA_VITESSE_VSC73XX_SPI
 	tristate "Vitesse VSC7385/7388/7395/7398 SPI mode support"
 	depends on SPI
+	depends on OF && NET_DSA
 	select NET_DSA_VITESSE_VSC73XX
 	---help---
 	  This enables support for the Vitesse VSC7385, VSC7388, VSC7395
@@ -120,6 +119,7 @@ config NET_DSA_VITESSE_VSC73XX_SPI
 config NET_DSA_VITESSE_VSC73XX_PLATFORM
 	tristate "Vitesse VSC7385/7388/7395/7398 Platform mode support"
 	depends on HAS_IOMEM
+	depends on OF && NET_DSA
 	select NET_DSA_VITESSE_VSC73XX
 	---help---
 	  This enables support for the Vitesse VSC7385, VSC7388, VSC7395
-- 
2.7.4


