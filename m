Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8C467DBD0
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 14:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731502AbfHAMrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 08:47:06 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3734 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730334AbfHAMrF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 08:47:05 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B38B2842A503DCDBCCAA;
        Thu,  1 Aug 2019 20:47:02 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Thu, 1 Aug 2019
 20:46:53 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <iyappan@os.amperecomputing.com>,
        <keyur@os.amperecomputing.com>, <quan@os.amperecomputing.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net: phy: xgene: use devm_platform_ioremap_resource() to simplify code
Date:   Thu, 1 Aug 2019 20:46:30 +0800
Message-ID: <20190801124630.5656-1-yuehaibing@huawei.com>
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
 drivers/net/phy/mdio-xgene.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/phy/mdio-xgene.c b/drivers/net/phy/mdio-xgene.c
index 717cc2a..34990ea 100644
--- a/drivers/net/phy/mdio-xgene.c
+++ b/drivers/net/phy/mdio-xgene.c
@@ -328,7 +328,6 @@ static int xgene_mdio_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct mii_bus *mdio_bus;
 	const struct of_device_id *of_id;
-	struct resource *res;
 	struct xgene_mdio_pdata *pdata;
 	void __iomem *csr_base;
 	int mdio_id = 0, ret = 0;
@@ -355,8 +354,7 @@ static int xgene_mdio_probe(struct platform_device *pdev)
 	pdata->mdio_id = mdio_id;
 	pdata->dev = dev;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	csr_base = devm_ioremap_resource(dev, res);
+	csr_base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(csr_base))
 		return PTR_ERR(csr_base);
 	pdata->mac_csr_addr = csr_base;
-- 
2.7.4


