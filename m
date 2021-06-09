Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C94EA3A15D0
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 15:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233449AbhFINne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 09:43:34 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:5359 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232031AbhFINnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 09:43:31 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4G0SpT6pJ8z6tmm;
        Wed,  9 Jun 2021 21:37:37 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 9 Jun 2021 21:41:29 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 9 Jun 2021
 21:41:29 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>
Subject: [PATCH net-next] net: ethernet: ti: am65-cpts: Use devm_platform_ioremap_resource_byname()
Date:   Wed, 9 Jun 2021 21:45:37 +0800
Message-ID: <20210609134537.3188927-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the devm_platform_ioremap_resource_byname() helper instead of
calling platform_get_resource_byname() and devm_ioremap_resource()
separately.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/ti/am65-cpts.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpts.c b/drivers/net/ethernet/ti/am65-cpts.c
index 9caaae79fc95..c30a6e510aa3 100644
--- a/drivers/net/ethernet/ti/am65-cpts.c
+++ b/drivers/net/ethernet/ti/am65-cpts.c
@@ -1037,11 +1037,9 @@ static int am65_cpts_probe(struct platform_device *pdev)
 	struct device_node *node = pdev->dev.of_node;
 	struct device *dev = &pdev->dev;
 	struct am65_cpts *cpts;
-	struct resource *res;
 	void __iomem *base;
 
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "cpts");
-	base = devm_ioremap_resource(dev, res);
+	base = devm_platform_ioremap_resource_byname(pdev, "cpts");
 	if (IS_ERR(base))
 		return PTR_ERR(base);
 
-- 
2.25.1

