Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A946639DE1B
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 15:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbhFGNzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 09:55:06 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:4497 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbhFGNzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 09:55:06 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FzFB81jfGzZfTK;
        Mon,  7 Jun 2021 21:50:24 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 7 Jun 2021 21:53:12 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 7 Jun 2021
 21:53:12 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <claudiu.manoil@nxp.com>, <davem@davemloft.net>, <kuba@kernel.org>
Subject: [PATCH net-next] net: enetc: Use devm_platform_get_and_ioremap_resource()
Date:   Mon, 7 Jun 2021 21:57:14 +0800
Message-ID: <20210607135714.3979032-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use devm_platform_get_and_ioremap_resource() to simplify
code.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_ierb.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ierb.c b/drivers/net/ethernet/freescale/enetc/enetc_ierb.c
index 8b356c485507..ee1468e3eaa3 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ierb.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ierb.c
@@ -99,15 +99,13 @@ EXPORT_SYMBOL(enetc_ierb_register_pf);
 static int enetc_ierb_probe(struct platform_device *pdev)
 {
 	struct enetc_ierb *ierb;
-	struct resource *res;
 	void __iomem *regs;
 
 	ierb = devm_kzalloc(&pdev->dev, sizeof(*ierb), GFP_KERNEL);
 	if (!ierb)
 		return -ENOMEM;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	regs = devm_ioremap_resource(&pdev->dev, res);
+	regs = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
 	if (IS_ERR(regs))
 		return PTR_ERR(regs);
 
-- 
2.25.1

