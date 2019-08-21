Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58D06979E7
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 14:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728529AbfHUMtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 08:49:09 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:39880 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726984AbfHUMtI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 08:49:08 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id AC19A28137F4342D1431;
        Wed, 21 Aug 2019 20:49:03 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Wed, 21 Aug 2019
 20:48:55 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <grygorii.strashko@ti.com>,
        <ivan.khoronzhuk@linaro.org>, <andrew@lunn.ch>, <ynezz@true.cz>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net: ethernet: ti: use devm_platform_ioremap_resource() to simplify code
Date:   Wed, 21 Aug 2019 20:48:50 +0800
Message-ID: <20190821124850.9592-1-yuehaibing@huawei.com>
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
 drivers/net/ethernet/ti/cpsw.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 32a8974..5401095 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -2764,7 +2764,7 @@ static int cpsw_probe(struct platform_device *pdev)
 	struct net_device		*ndev;
 	struct cpsw_priv		*priv;
 	void __iomem			*ss_regs;
-	struct resource			*res, *ss_res;
+	struct resource			*ss_res;
 	struct gpio_descs		*mode;
 	const struct soc_device_attribute *soc;
 	struct cpsw_common		*cpsw;
@@ -2798,8 +2798,7 @@ static int cpsw_probe(struct platform_device *pdev)
 		return PTR_ERR(ss_regs);
 	cpsw->regs = ss_regs;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	cpsw->wr_regs = devm_ioremap_resource(dev, res);
+	cpsw->wr_regs = devm_platform_ioremap_resource(pdev, 1);
 	if (IS_ERR(cpsw->wr_regs))
 		return PTR_ERR(cpsw->wr_regs);
 
-- 
2.7.4


