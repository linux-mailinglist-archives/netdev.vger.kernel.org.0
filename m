Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9419B39F82A
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 15:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233088AbhFHNzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 09:55:03 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:5294 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233074AbhFHNzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 09:55:03 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Fzs5G0HMdz1BK1Q;
        Tue,  8 Jun 2021 21:48:18 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 8 Jun 2021 21:53:08 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 8 Jun 2021
 21:53:08 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <sergei.shtylyov@gmail.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
Subject: [PATCH net-next] sh_eth: Use devm_platform_get_and_ioremap_resource()
Date:   Tue, 8 Jun 2021 21:57:18 +0800
Message-ID: <20210608135718.3009950-1-yangyingliang@huawei.com>
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
 drivers/net/ethernet/renesas/sh_eth.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index c5b154868c1f..177523be4fb6 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -3225,9 +3225,6 @@ static int sh_eth_drv_probe(struct platform_device *pdev)
 	struct net_device *ndev;
 	int ret;
 
-	/* get base addr */
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-
 	ndev = alloc_etherdev(sizeof(struct sh_eth_private));
 	if (!ndev)
 		return -ENOMEM;
@@ -3245,7 +3242,7 @@ static int sh_eth_drv_probe(struct platform_device *pdev)
 	mdp = netdev_priv(ndev);
 	mdp->num_tx_ring = TX_RING_SIZE;
 	mdp->num_rx_ring = RX_RING_SIZE;
-	mdp->addr = devm_ioremap_resource(&pdev->dev, res);
+	mdp->addr = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
 	if (IS_ERR(mdp->addr)) {
 		ret = PTR_ERR(mdp->addr);
 		goto out_release;
-- 
2.25.1

