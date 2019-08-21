Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B16B297AFF
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 15:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728567AbfHUNh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 09:37:29 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:55296 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727949AbfHUNh2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 09:37:28 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 97B5B46B22618961939D;
        Wed, 21 Aug 2019 21:37:12 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Wed, 21 Aug 2019
 21:37:02 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <bigeasy@linutronix.de>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net: mvneta: use devm_platform_ioremap_resource() to simplify code
Date:   Wed, 21 Aug 2019 21:33:02 +0800
Message-ID: <20190821133302.72880-1-yuehaibing@huawei.com>
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
 drivers/net/ethernet/marvell/mvneta_bm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta_bm.c b/drivers/net/ethernet/marvell/mvneta_bm.c
index 82ee2bc..46c942e 100644
--- a/drivers/net/ethernet/marvell/mvneta_bm.c
+++ b/drivers/net/ethernet/marvell/mvneta_bm.c
@@ -411,15 +411,13 @@ static int mvneta_bm_probe(struct platform_device *pdev)
 {
 	struct device_node *dn = pdev->dev.of_node;
 	struct mvneta_bm *priv;
-	struct resource *res;
 	int err;
 
 	priv = devm_kzalloc(&pdev->dev, sizeof(struct mvneta_bm), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	priv->reg_base = devm_ioremap_resource(&pdev->dev, res);
+	priv->reg_base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(priv->reg_base))
 		return PTR_ERR(priv->reg_base);
 
-- 
2.7.4


