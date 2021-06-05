Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 269CD39C709
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 11:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhFEJYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 05:24:21 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:7116 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbhFEJYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 05:24:20 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FxvGm1m1rzYqlx;
        Sat,  5 Jun 2021 17:19:44 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 5 Jun 2021 17:22:29 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Sat, 5 Jun 2021
 17:22:29 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <hauke@hauke-m.de>, <davem@davemloft.net>, <kuba@kernel.org>
Subject: [PATCH net-next] net: lantiq: Use devm_platform_get_and_ioremap_resource()
Date:   Sat, 5 Jun 2021 17:26:47 +0800
Message-ID: <20210605092647.2374125-1-yangyingliang@huawei.com>
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
 drivers/net/ethernet/lantiq_xrx200.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index 36dc3e5f6218..003df49e40b1 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -456,13 +456,7 @@ static int xrx200_probe(struct platform_device *pdev)
 	net_dev->max_mtu = XRX200_DMA_DATA_LEN;
 
 	/* load the memory ranges */
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(dev, "failed to get resources\n");
-		return -ENOENT;
-	}
-
-	priv->pmac_reg = devm_ioremap_resource(dev, res);
+	priv->pmac_reg = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
 	if (IS_ERR(priv->pmac_reg))
 		return PTR_ERR(priv->pmac_reg);
 
-- 
2.25.1

