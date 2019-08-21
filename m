Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3D3979F7
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 14:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728547AbfHUMwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 08:52:14 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4746 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726484AbfHUMwO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 08:52:14 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 6811BDEE7C763584CA04;
        Wed, 21 Aug 2019 20:52:10 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Wed, 21 Aug 2019
 20:52:02 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <will@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] via-rhine: use devm_platform_ioremap_resource() to simplify code
Date:   Wed, 21 Aug 2019 20:50:50 +0800
Message-ID: <20190821125050.67652-1-yuehaibing@huawei.com>
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
 drivers/net/ethernet/via/via-rhine.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
index ab55416..ed12dbd 100644
--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -1127,15 +1127,13 @@ static int rhine_init_one_platform(struct platform_device *pdev)
 	const struct of_device_id *match;
 	const u32 *quirks;
 	int irq;
-	struct resource *res;
 	void __iomem *ioaddr;
 
 	match = of_match_device(rhine_of_tbl, &pdev->dev);
 	if (!match)
 		return -EINVAL;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	ioaddr = devm_ioremap_resource(&pdev->dev, res);
+	ioaddr = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(ioaddr))
 		return PTR_ERR(ioaddr);
 
-- 
2.7.4


