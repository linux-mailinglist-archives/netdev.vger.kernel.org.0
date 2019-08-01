Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 777FB7DB97
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 14:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731314AbfHAMeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 08:34:44 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:38504 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726422AbfHAMeo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 08:34:44 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 4E91771ADC02004EE92D;
        Thu,  1 Aug 2019 20:34:42 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Thu, 1 Aug 2019
 20:34:32 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <timur@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net: qcom/emac: use devm_platform_ioremap_resource() to simplify code
Date:   Thu, 1 Aug 2019 20:34:30 +0800
Message-ID: <20190801123430.41672-1-yuehaibing@huawei.com>
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
 drivers/net/ethernet/qualcomm/emac/emac.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/emac/emac.c b/drivers/net/ethernet/qualcomm/emac/emac.c
index bfe1046..c84ab05 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac.c
@@ -544,7 +544,6 @@ static int emac_probe_resources(struct platform_device *pdev,
 				struct emac_adapter *adpt)
 {
 	struct net_device *netdev = adpt->netdev;
-	struct resource *res;
 	char maddr[ETH_ALEN];
 	int ret = 0;
 
@@ -561,14 +560,12 @@ static int emac_probe_resources(struct platform_device *pdev,
 	adpt->irq.irq = ret;
 
 	/* base register address */
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	adpt->base = devm_ioremap_resource(&pdev->dev, res);
+	adpt->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(adpt->base))
 		return PTR_ERR(adpt->base);
 
 	/* CSR register address */
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	adpt->csr = devm_ioremap_resource(&pdev->dev, res);
+	adpt->csr = devm_platform_ioremap_resource(pdev, 1);
 	if (IS_ERR(adpt->csr))
 		return PTR_ERR(adpt->csr);
 
-- 
2.7.4


