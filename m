Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D64897A42
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 15:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728720AbfHUNDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 09:03:17 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:49172 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728677AbfHUNDR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 09:03:17 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 3C08CC7E30EE44F232FF;
        Wed, 21 Aug 2019 21:00:17 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Wed, 21 Aug 2019
 21:00:08 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <bh74.an@samsung.com>,
        <ks.giri@samsung.com>, <vipul.pandya@samsung.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net: sxgbe: use devm_platform_ioremap_resource() to simplify code
Date:   Wed, 21 Aug 2019 20:59:59 +0800
Message-ID: <20190821125959.17728-1-yuehaibing@huawei.com>
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
 drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c
index d2c4811..2412c87 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c
@@ -78,7 +78,6 @@ static int sxgbe_platform_probe(struct platform_device *pdev)
 {
 	int ret;
 	int i, chan;
-	struct resource *res;
 	struct device *dev = &pdev->dev;
 	void __iomem *addr;
 	struct sxgbe_priv_data *priv = NULL;
@@ -88,8 +87,7 @@ static int sxgbe_platform_probe(struct platform_device *pdev)
 	struct device_node *node = dev->of_node;
 
 	/* Get memory resource */
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	addr = devm_ioremap_resource(dev, res);
+	addr = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(addr))
 		return PTR_ERR(addr);
 
-- 
2.7.4


