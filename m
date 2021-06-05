Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B88639C79F
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 12:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbhFELAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 07:00:01 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:4488 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbhFELAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 07:00:00 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FxxP71gMkzZcnQ;
        Sat,  5 Jun 2021 18:55:23 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 5 Jun 2021 18:58:10 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Sat, 5 Jun 2021
 18:58:09 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
CC:     <kvalo@codeaurora.org>, <davem@davemloft.net>, <kuba@kernel.org>
Subject: [PATCH net-next] ath10k: Use devm_platform_get_and_ioremap_resource()
Date:   Sat, 5 Jun 2021 19:02:27 +0800
Message-ID: <20210605110227.2429420-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use devm_platform_get_and_ioremap_resource() to simplify
code.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/wireless/ath/ath10k/ahb.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ahb.c b/drivers/net/wireless/ath/ath10k/ahb.c
index 869524852fba..ab8f77ae5e66 100644
--- a/drivers/net/wireless/ath/ath10k/ahb.c
+++ b/drivers/net/wireless/ath/ath10k/ahb.c
@@ -442,14 +442,7 @@ static int ath10k_ahb_resource_init(struct ath10k *ar)
 
 	pdev = ar_ahb->pdev;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		ath10k_err(ar, "failed to get memory resource\n");
-		ret = -ENXIO;
-		goto out;
-	}
-
-	ar_ahb->mem = devm_ioremap_resource(&pdev->dev, res);
+	ar_ahb->mem = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
 	if (IS_ERR(ar_ahb->mem)) {
 		ath10k_err(ar, "mem ioremap error\n");
 		ret = PTR_ERR(ar_ahb->mem);
-- 
2.25.1

