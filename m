Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A74A1C1E6F
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 11:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730601AbfI3JtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 05:49:23 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3235 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728581AbfI3JtW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Sep 2019 05:49:22 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 4A6D356F2F55C9DA981A;
        Mon, 30 Sep 2019 17:49:20 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Mon, 30 Sep 2019
 17:49:11 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] can: grcan: use devm_platform_ioremap_resource() to simplify code
Date:   Mon, 30 Sep 2019 17:49:09 +0800
Message-ID: <20190930094909.49672-1-yuehaibing@huawei.com>
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
 drivers/net/can/grcan.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/can/grcan.c b/drivers/net/can/grcan.c
index b8f1f2b69dd3..378200b682fa 100644
--- a/drivers/net/can/grcan.c
+++ b/drivers/net/can/grcan.c
@@ -1652,7 +1652,6 @@ static int grcan_setup_netdev(struct platform_device *ofdev,
 static int grcan_probe(struct platform_device *ofdev)
 {
 	struct device_node *np = ofdev->dev.of_node;
-	struct resource *res;
 	u32 sysid, ambafreq;
 	int irq, err;
 	void __iomem *base;
@@ -1672,8 +1671,7 @@ static int grcan_probe(struct platform_device *ofdev)
 		goto exit_error;
 	}
 
-	res = platform_get_resource(ofdev, IORESOURCE_MEM, 0);
-	base = devm_ioremap_resource(&ofdev->dev, res);
+	base = devm_platform_ioremap_resource(ofdev, 0);
 	if (IS_ERR(base)) {
 		err = PTR_ERR(base);
 		goto exit_error;
-- 
2.20.1


