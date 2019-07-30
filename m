Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7B77AB0E
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 16:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731384AbfG3ObR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 10:31:17 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3254 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727785AbfG3ObR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 10:31:17 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 4D35179A98F3D92FA255;
        Tue, 30 Jul 2019 22:31:14 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Tue, 30 Jul 2019
 22:31:06 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <claudiu.manoil@nxp.com>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] enetc: Fix build error without PHYLIB
Date:   Tue, 30 Jul 2019 22:29:59 +0800
Message-ID: <20190730142959.50892-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If PHYLIB is not set, build enetc will fails:

drivers/net/ethernet/freescale/enetc/enetc.o: In function `enetc_open':
enetc.c: undefined reference to `phy_disconnect'
enetc.c: undefined reference to `phy_start'
drivers/net/ethernet/freescale/enetc/enetc.o: In function `enetc_close':
enetc.c: undefined reference to `phy_stop'
enetc.c: undefined reference to `phy_disconnect'
drivers/net/ethernet/freescale/enetc/enetc_ethtool.o: undefined reference to `phy_ethtool_get_link_ksettings'
drivers/net/ethernet/freescale/enetc/enetc_ethtool.o: undefined reference to `phy_ethtool_set_link_ksettings'
drivers/net/ethernet/freescale/enetc/enetc_mdio.o: In function `enetc_mdio_probe':
enetc_mdio.c: undefined reference to `mdiobus_alloc_size'
enetc_mdio.c: undefined reference to `mdiobus_free'

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: d4fd0404c1c9 ("enetc: Introduce basic PF and VF ENETC ethernet drivers")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/freescale/enetc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/enetc/Kconfig b/drivers/net/ethernet/freescale/enetc/Kconfig
index ed0d010..46fdf36b 100644
--- a/drivers/net/ethernet/freescale/enetc/Kconfig
+++ b/drivers/net/ethernet/freescale/enetc/Kconfig
@@ -2,6 +2,7 @@
 config FSL_ENETC
 	tristate "ENETC PF driver"
 	depends on PCI && PCI_MSI && (ARCH_LAYERSCAPE || COMPILE_TEST)
+	select PHYLIB
 	help
 	  This driver supports NXP ENETC gigabit ethernet controller PCIe
 	  physical function (PF) devices, managing ENETC Ports at a privileged
-- 
2.7.4


