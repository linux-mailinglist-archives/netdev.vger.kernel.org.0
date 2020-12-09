Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E3D2D3E96
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 10:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728951AbgLIJXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 04:23:46 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9564 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727920AbgLIJXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 04:23:45 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CrWly6DVqzM2cV;
        Wed,  9 Dec 2020 17:22:22 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Wed, 9 Dec 2020 17:22:57 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <kuba@kernel.org>, <linux-kernel@vger.kernel.org>,
        <mcoquelin.stm32@gmail.com>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: stmmac: simplify the return dwmac5_rxp_disable()
Date:   Wed, 9 Dec 2020 17:23:25 +0800
Message-ID: <20201209092325.20415-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the return expression.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
index 67ba67ed0cb9..03e79a677c8b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
@@ -305,17 +305,13 @@ int dwmac5_safety_feat_dump(struct stmmac_safety_stats *stats,
 static int dwmac5_rxp_disable(void __iomem *ioaddr)
 {
 	u32 val;
-	int ret;
 
 	val = readl(ioaddr + MTL_OPERATION_MODE);
 	val &= ~MTL_FRPE;
 	writel(val, ioaddr + MTL_OPERATION_MODE);
 
-	ret = readl_poll_timeout(ioaddr + MTL_RXP_CONTROL_STATUS, val,
+	return readl_poll_timeout(ioaddr + MTL_RXP_CONTROL_STATUS, val,
 			val & RXPI, 1, 10000);
-	if (ret)
-		return ret;
-	return 0;
 }
 
 static void dwmac5_rxp_enable(void __iomem *ioaddr)
-- 
2.22.0

