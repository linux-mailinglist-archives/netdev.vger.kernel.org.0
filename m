Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0D99E9F2
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 15:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729800AbfH0Nsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 09:48:50 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5673 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725825AbfH0Nsu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 09:48:50 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 06188DC8136FC1B594BC;
        Tue, 27 Aug 2019 21:48:25 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Tue, 27 Aug 2019
 21:48:14 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] phy: mdio-moxart: use devm_platform_ioremap_resource() to simplify code
Date:   Tue, 27 Aug 2019 21:48:04 +0800
Message-ID: <20190827134804.14888-1-yuehaibing@huawei.com>
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
 drivers/net/phy/mdio-moxart.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/phy/mdio-moxart.c b/drivers/net/phy/mdio-moxart.c
index af3910f..2d16fc4 100644
--- a/drivers/net/phy/mdio-moxart.c
+++ b/drivers/net/phy/mdio-moxart.c
@@ -113,7 +113,6 @@ static int moxart_mdio_probe(struct platform_device *pdev)
 	struct device_node *np = pdev->dev.of_node;
 	struct mii_bus *bus;
 	struct moxart_mdio_data *data;
-	struct resource *res;
 	int ret, i;
 
 	bus = mdiobus_alloc_size(sizeof(*data));
@@ -138,8 +137,7 @@ static int moxart_mdio_probe(struct platform_device *pdev)
 		bus->irq[i] = PHY_IGNORE_INTERRUPT;
 
 	data = bus->priv;
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	data->base = devm_ioremap_resource(&pdev->dev, res);
+	data->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(data->base)) {
 		ret = PTR_ERR(data->base);
 		goto err_out_free_mdiobus;
-- 
2.7.4


