Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09BFC39C818
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 14:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbhFEMWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 08:22:49 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:4323 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbhFEMWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 08:22:48 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FxzBM5hYXz1BFWZ;
        Sat,  5 Jun 2021 20:16:11 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 5 Jun 2021 20:20:58 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Sat, 5 Jun 2021
 20:20:58 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <khalasa@piap.pl>, <davem@davemloft.net>, <kuba@kernel.org>
Subject: [PATCH net-next v2] net: ethernet: ixp4xx_eth: Use devm_platform_get_and_ioremap_resource()
Date:   Sat, 5 Jun 2021 20:25:15 +0800
Message-ID: <20210605122515.2476263-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use devm_platform_get_and_ioremap_resource() to simplify
code.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
v2:
  remove 'res'
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index 1ecceeb9700d..85c66af9e56d 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -1425,7 +1425,6 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 	struct device_node *np = dev->of_node;
 	struct eth_plat_info *plat;
 	struct net_device *ndev;
-	struct resource *res;
 	struct port *port;
 	int err;
 
@@ -1482,10 +1481,7 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 	port->id = plat->npe;
 
 	/* Get the port resource and remap */
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
-	port->regs = devm_ioremap_resource(dev, res);
+	port->regs = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
 	if (IS_ERR(port->regs))
 		return PTR_ERR(port->regs);
 
-- 
2.25.1

