Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF402E710C
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 14:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgL2Nt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 08:49:58 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:10376 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbgL2Nt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 08:49:58 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4D4wjk47Brz7Gvx;
        Tue, 29 Dec 2020 21:48:26 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Tue, 29 Dec 2020 21:49:07 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <khalasa@piap.pl>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: ixp4xx_eth: Use DEFINE_SPINLOCK() for spinlock
Date:   Tue, 29 Dec 2020 21:49:47 +0800
Message-ID: <20201229134947.23306-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

spinlock can be initialized automatically with DEFINE_SPINLOCK()
rather than explicitly calling spin_lock_init().

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index 2e5202923510..0152f1e70783 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -247,7 +247,7 @@ static inline void memcpy_swab32(u32 *dest, u32 *src, int cnt)
 }
 #endif
 
-static spinlock_t mdio_lock;
+static DEFINE_SPINLOCK(mdio_lock);
 static struct eth_regs __iomem *mdio_regs; /* mdio command and status only */
 static struct mii_bus *mdio_bus;
 static int ports_open;
@@ -528,7 +528,6 @@ static int ixp4xx_mdio_register(struct eth_regs __iomem *regs)
 
 	mdio_regs = regs;
 	__raw_writel(DEFAULT_CORE_CNTRL, &mdio_regs->core_control);
-	spin_lock_init(&mdio_lock);
 	mdio_bus->name = "IXP4xx MII Bus";
 	mdio_bus->read = &ixp4xx_mdio_read;
 	mdio_bus->write = &ixp4xx_mdio_write;
-- 
2.22.0

