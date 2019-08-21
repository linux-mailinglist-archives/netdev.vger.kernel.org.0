Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7A2797A19
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 14:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbfHUM6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 08:58:25 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5179 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728556AbfHUM6Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 08:58:24 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 1F4E599F2AA65AB6C3F8;
        Wed, 21 Aug 2019 20:58:22 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Wed, 21 Aug 2019
 20:58:15 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <ynezz@true.cz>, <allison@lohutok.net>,
        <lukas@wunner.de>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net: ks8851-ml: use devm_platform_ioremap_resource() to simplify code
Date:   Wed, 21 Aug 2019 20:58:11 +0800
Message-ID: <20190821125811.70524-1-yuehaibing@huawei.com>
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
 drivers/net/ethernet/micrel/ks8851_mll.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851_mll.c b/drivers/net/ethernet/micrel/ks8851_mll.c
index e52b015..a41a90c 100644
--- a/drivers/net/ethernet/micrel/ks8851_mll.c
+++ b/drivers/net/ethernet/micrel/ks8851_mll.c
@@ -1225,7 +1225,6 @@ MODULE_DEVICE_TABLE(of, ks8851_ml_dt_ids);
 static int ks8851_probe(struct platform_device *pdev)
 {
 	int err;
-	struct resource *io_d, *io_c;
 	struct net_device *netdev;
 	struct ks_net *ks;
 	u16 id, data;
@@ -1240,15 +1239,13 @@ static int ks8851_probe(struct platform_device *pdev)
 	ks = netdev_priv(netdev);
 	ks->netdev = netdev;
 
-	io_d = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	ks->hw_addr = devm_ioremap_resource(&pdev->dev, io_d);
+	ks->hw_addr = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(ks->hw_addr)) {
 		err = PTR_ERR(ks->hw_addr);
 		goto err_free;
 	}
 
-	io_c = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	ks->hw_addr_cmd = devm_ioremap_resource(&pdev->dev, io_c);
+	ks->hw_addr_cmd = devm_platform_ioremap_resource(pdev, 1);
 	if (IS_ERR(ks->hw_addr_cmd)) {
 		err = PTR_ERR(ks->hw_addr_cmd);
 		goto err_free;
-- 
2.7.4


