Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15D5F45B214
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 03:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240753AbhKXCjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 21:39:41 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:51447 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235796AbhKXCjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 21:39:41 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R581e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0Uy37Bby_1637721389;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0Uy37Bby_1637721389)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 24 Nov 2021 10:36:30 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH -next 1/2] tsnep: fix resource_size.cocci warnings
Date:   Wed, 24 Nov 2021 10:36:23 +0800
Message-Id: <1637721384-70836-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use resource_size function on resource object
instead of explicit computation.

Clean up coccicheck warning:
./drivers/net/ethernet/engleder/tsnep_main.c:1155:21-24: ERROR: Missing
resource_size with io

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/ethernet/engleder/tsnep_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 6a7feb2..c48e8ea 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -1152,7 +1152,7 @@ static int tsnep_probe(struct platform_device *pdev)
 	adapter->addr = devm_ioremap_resource(&pdev->dev, io);
 	if (IS_ERR(adapter->addr))
 		return PTR_ERR(adapter->addr);
-	adapter->size = io->end - io->start + 1;
+	adapter->size = resource_size(io);
 	adapter->irq = platform_get_irq(pdev, 0);
 	netdev->mem_start = io->start;
 	netdev->mem_end = io->end;
-- 
1.8.3.1

