Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E970D1205
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 17:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731433AbfJIPED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 11:04:03 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:38108 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729865AbfJIPEC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 11:04:02 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 85C58CBB2DF5AD50A978;
        Wed,  9 Oct 2019 23:04:00 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Wed, 9 Oct 2019
 23:03:50 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <richardcochran@gmail.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] ptp: ptp_dte: use devm_platform_ioremap_resource() to simplify code
Date:   Wed, 9 Oct 2019 23:03:25 +0800
Message-ID: <20191009150325.12736-1-yuehaibing@huawei.com>
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

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/ptp/ptp_dte.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/ptp/ptp_dte.c b/drivers/ptp/ptp_dte.c
index 0dcfdc8..82d31ba 100644
--- a/drivers/ptp/ptp_dte.c
+++ b/drivers/ptp/ptp_dte.c
@@ -240,14 +240,12 @@ static int ptp_dte_probe(struct platform_device *pdev)
 {
 	struct ptp_dte *ptp_dte;
 	struct device *dev = &pdev->dev;
-	struct resource *res;
 
 	ptp_dte = devm_kzalloc(dev, sizeof(struct ptp_dte), GFP_KERNEL);
 	if (!ptp_dte)
 		return -ENOMEM;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	ptp_dte->regs = devm_ioremap_resource(dev, res);
+	ptp_dte->regs = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(ptp_dte->regs))
 		return PTR_ERR(ptp_dte->regs);
 
-- 
2.7.4


