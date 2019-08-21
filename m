Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB2D97B16
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 15:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728929AbfHUNjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 09:39:19 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4748 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728567AbfHUNjS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 09:39:18 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 8C64CB48D585B239B4D7;
        Wed, 21 Aug 2019 21:39:13 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Wed, 21 Aug 2019
 21:39:05 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <andrew@lunn.ch>, <mcgrof@kernel.org>,
        <tglx@linutronix.de>, <ynezz@true.cz>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] pxa168_eth: use devm_platform_ioremap_resource() to simplify code
Date:   Wed, 21 Aug 2019 21:38:54 +0800
Message-ID: <20190821133854.4308-1-yuehaibing@huawei.com>
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

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/marvell/pxa168_eth.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
index 3aa9987..51b77c2 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -1425,8 +1425,7 @@ static int pxa168_eth_probe(struct platform_device *pdev)
 	pep->dev = dev;
 	pep->clk = clk;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	pep->base = devm_ioremap_resource(&pdev->dev, res);
+	pep->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(pep->base)) {
 		err = -ENOMEM;
 		goto err_netdev;
-- 
2.7.4


