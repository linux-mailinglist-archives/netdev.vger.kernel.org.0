Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6A8197A40
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 15:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728614AbfHUNDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 09:03:12 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5180 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726371AbfHUNDL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 09:03:11 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C071BA4BB39E89886BF5;
        Wed, 21 Aug 2019 21:03:02 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Wed, 21 Aug 2019
 21:02:46 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] cirrus: cs89x0: use devm_platform_ioremap_resource() to simplify code
Date:   Wed, 21 Aug 2019 21:02:41 +0800
Message-ID: <20190821130241.58276-1-yuehaibing@huawei.com>
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
 drivers/net/ethernet/cirrus/cs89x0.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/cirrus/cs89x0.c b/drivers/net/ethernet/cirrus/cs89x0.c
index b3e7faf..2d30972 100644
--- a/drivers/net/ethernet/cirrus/cs89x0.c
+++ b/drivers/net/ethernet/cirrus/cs89x0.c
@@ -1845,7 +1845,6 @@ static int __init cs89x0_platform_probe(struct platform_device *pdev)
 {
 	struct net_device *dev = alloc_etherdev(sizeof(struct net_local));
 	struct net_local *lp;
-	struct resource *mem_res;
 	void __iomem *virt_addr;
 	int err;
 
@@ -1861,8 +1860,7 @@ static int __init cs89x0_platform_probe(struct platform_device *pdev)
 		goto free;
 	}
 
-	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	virt_addr = devm_ioremap_resource(&pdev->dev, mem_res);
+	virt_addr = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(virt_addr)) {
 		err = PTR_ERR(virt_addr);
 		goto free;
-- 
2.7.4


