Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2703D7DB62
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 14:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730826AbfHAM0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 08:26:01 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3731 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726014AbfHAM0A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 08:26:00 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 12FDD479233C989B242E;
        Thu,  1 Aug 2019 20:25:58 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Thu, 1 Aug 2019
 20:25:48 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <hauke@hauke-m.de>, <andrew@lunn.ch>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net: dsa: lantiq: use devm_platform_ioremap_resource() to simplify code
Date:   Thu, 1 Aug 2019 20:25:46 +0800
Message-ID: <20190801122546.8516-1-yuehaibing@huawei.com>
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
 drivers/net/dsa/lantiq_gswip.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 4e64835..2175ec1 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1822,7 +1822,6 @@ static int gswip_gphy_fw_list(struct gswip_priv *priv,
 static int gswip_probe(struct platform_device *pdev)
 {
 	struct gswip_priv *priv;
-	struct resource *gswip_res, *mdio_res, *mii_res;
 	struct device_node *mdio_np, *gphy_fw_np;
 	struct device *dev = &pdev->dev;
 	int err;
@@ -1833,18 +1832,15 @@ static int gswip_probe(struct platform_device *pdev)
 	if (!priv)
 		return -ENOMEM;
 
-	gswip_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	priv->gswip = devm_ioremap_resource(dev, gswip_res);
+	priv->gswip = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(priv->gswip))
 		return PTR_ERR(priv->gswip);
 
-	mdio_res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	priv->mdio = devm_ioremap_resource(dev, mdio_res);
+	priv->mdio = devm_platform_ioremap_resource(pdev, 1);
 	if (IS_ERR(priv->mdio))
 		return PTR_ERR(priv->mdio);
 
-	mii_res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
-	priv->mii = devm_ioremap_resource(dev, mii_res);
+	priv->mii = devm_platform_ioremap_resource(pdev, 2);
 	if (IS_ERR(priv->mii))
 		return PTR_ERR(priv->mii);
 
-- 
2.7.4


