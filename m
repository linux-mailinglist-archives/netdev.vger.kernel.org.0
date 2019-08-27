Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E76CE9E9DD
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 15:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729729AbfH0Nr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 09:47:57 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5671 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725825AbfH0Nr5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 09:47:57 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 97BF0BD997FD7DC6858C;
        Tue, 27 Aug 2019 21:47:47 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Tue, 27 Aug 2019
 21:47:41 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] phy: mdio-hisi-femac: use devm_platform_ioremap_resource() to simplify code
Date:   Tue, 27 Aug 2019 21:47:22 +0800
Message-ID: <20190827134722.14332-1-yuehaibing@huawei.com>
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
 drivers/net/phy/mdio-hisi-femac.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/phy/mdio-hisi-femac.c b/drivers/net/phy/mdio-hisi-femac.c
index 287f3cc..f231c2f 100644
--- a/drivers/net/phy/mdio-hisi-femac.c
+++ b/drivers/net/phy/mdio-hisi-femac.c
@@ -74,7 +74,6 @@ static int hisi_femac_mdio_probe(struct platform_device *pdev)
 	struct device_node *np = pdev->dev.of_node;
 	struct mii_bus *bus;
 	struct hisi_femac_mdio_data *data;
-	struct resource *res;
 	int ret;
 
 	bus = mdiobus_alloc_size(sizeof(*data));
@@ -88,8 +87,7 @@ static int hisi_femac_mdio_probe(struct platform_device *pdev)
 	bus->parent = &pdev->dev;
 
 	data = bus->priv;
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	data->membase = devm_ioremap_resource(&pdev->dev, res);
+	data->membase = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(data->membase)) {
 		ret = PTR_ERR(data->membase);
 		goto err_out_free_mdiobus;
-- 
2.7.4


