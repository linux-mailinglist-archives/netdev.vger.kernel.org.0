Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FAFCD7869
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 16:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732681AbfJOO07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 10:26:59 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:45148 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732050AbfJOO07 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 10:26:59 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 4CB0152FA015268CFAAA;
        Tue, 15 Oct 2019 22:26:56 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Tue, 15 Oct 2019
 22:26:47 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <michal.simek@xilinx.com>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] can: xilinx_can: use devm_platform_ioremap_resource() to simplify code
Date:   Tue, 15 Oct 2019 22:26:19 +0800
Message-ID: <20191015142619.17148-1-yuehaibing@huawei.com>
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
 drivers/net/can/xilinx_can.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 911b343..5d45c50 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -1652,7 +1652,6 @@ MODULE_DEVICE_TABLE(of, xcan_of_match);
  */
 static int xcan_probe(struct platform_device *pdev)
 {
-	struct resource *res; /* IO mem resources */
 	struct net_device *ndev;
 	struct xcan_priv *priv;
 	const struct of_device_id *of_id;
@@ -1664,8 +1663,7 @@ static int xcan_probe(struct platform_device *pdev)
 	const char *hw_tx_max_property;
 
 	/* Get the virtual base address for the device */
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	addr = devm_ioremap_resource(&pdev->dev, res);
+	addr = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(addr)) {
 		ret = PTR_ERR(addr);
 		goto err;
-- 
2.7.4


