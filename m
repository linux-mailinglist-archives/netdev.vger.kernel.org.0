Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 914C4D784D
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 16:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732514AbfJOOVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 10:21:19 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:39948 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732394AbfJOOVT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 10:21:19 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 473981E75273BD38DDBC;
        Tue, 15 Oct 2019 22:21:16 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Tue, 15 Oct 2019
 22:21:09 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <yuehaibing@huawei.com>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] can: ifi: use devm_platform_ioremap_resource() to simplify code
Date:   Tue, 15 Oct 2019 22:20:46 +0800
Message-ID: <20191015142046.24844-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use devm_platform_ioremap_resource() to simplify the code a bit.
This is detected by coccinelle.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/can/ifi_canfd/ifi_canfd.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/can/ifi_canfd/ifi_canfd.c b/drivers/net/can/ifi_canfd/ifi_canfd.c
index fedd927..04d59be 100644
--- a/drivers/net/can/ifi_canfd/ifi_canfd.c
+++ b/drivers/net/can/ifi_canfd/ifi_canfd.c
@@ -942,13 +942,11 @@ static int ifi_canfd_plat_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct net_device *ndev;
 	struct ifi_canfd_priv *priv;
-	struct resource *res;
 	void __iomem *addr;
 	int irq, ret;
 	u32 id, rev;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	addr = devm_ioremap_resource(dev, res);
+	addr = devm_platform_ioremap_resource(pdev, 0);
 	irq = platform_get_irq(pdev, 0);
 	if (IS_ERR(addr) || irq < 0)
 		return -EINVAL;
-- 
2.7.4


