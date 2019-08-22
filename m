Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D48F98B6C
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 08:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731252AbfHVGbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 02:31:41 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:52366 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725710AbfHVGbl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 02:31:41 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id AA1FC32C661A14A7954D;
        Thu, 22 Aug 2019 14:31:36 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Thu, 22 Aug 2019 14:31:28 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     "David S . Miller" <davem@davemloft.net>,
        YueHaibing <yuehaibing@huawei.com>
CC:     <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: [PATCH net-next] cirrus: cs89x0: remove set but not used variable 'lp'
Date:   Thu, 22 Aug 2019 06:35:17 +0000
Message-ID: <20190822063517.71231-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/ethernet/cirrus/cs89x0.c: In function 'cs89x0_platform_probe':
drivers/net/ethernet/cirrus/cs89x0.c:1847:20: warning:
 variable 'lp' set but not used [-Wunused-but-set-variable]

It is not used since commit 6751edeb8700 ("cirrus: cs89x0: Use
managed interfaces")

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/cirrus/cs89x0.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/cirrus/cs89x0.c b/drivers/net/ethernet/cirrus/cs89x0.c
index 2d30972df06b..c9aebcde403a 100644
--- a/drivers/net/ethernet/cirrus/cs89x0.c
+++ b/drivers/net/ethernet/cirrus/cs89x0.c
@@ -1844,15 +1844,12 @@ cleanup_module(void)
 static int __init cs89x0_platform_probe(struct platform_device *pdev)
 {
 	struct net_device *dev = alloc_etherdev(sizeof(struct net_local));
-	struct net_local *lp;
 	void __iomem *virt_addr;
 	int err;
 
 	if (!dev)
 		return -ENOMEM;
 
-	lp = netdev_priv(dev);
-
 	dev->irq = platform_get_irq(pdev, 0);
 	if (dev->irq <= 0) {
 		dev_warn(&dev->dev, "interrupt resource missing\n");



