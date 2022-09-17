Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9775BB7D2
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 12:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbiIQKjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 06:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiIQKjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 06:39:32 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 728CEEBF;
        Sat, 17 Sep 2022 03:39:31 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MV6n91RpfzXdVx;
        Sat, 17 Sep 2022 18:36:45 +0800 (CST)
Received: from kwepemm600013.china.huawei.com (7.193.23.68) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 17 Sep 2022 18:39:29 +0800
Received: from localhost.localdomain (10.67.165.2) by
 kwepemm600013.china.huawei.com (7.193.23.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 17 Sep 2022 18:39:28 +0800
From:   Haoyue Xu <xuhaoyue1@hisilicon.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <michal.simek@xilinx.com>
CC:     <huangdaode@huawei.com>, <liyangyang20@huawei.com>,
        <xuhaoyue1@hisilicon.com>, <huangjunxian6@hisilicon.com>,
        <linuxarm@huawei.com>, <liangwenpeng@huawei.com>
Subject: [PATCH net-next 4/7] net: ll_temac: delete unnecessary else branch
Date:   Sat, 17 Sep 2022 18:38:40 +0800
Message-ID: <20220917103843.526877-5-xuhaoyue1@hisilicon.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20220917103843.526877-1-xuhaoyue1@hisilicon.com>
References: <20220917103843.526877-1-xuhaoyue1@hisilicon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.2]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600013.china.huawei.com (7.193.23.68)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: huangjunxian <huangjunxian6@hisilicon.com>

Cleaning some static warnings of unnecessary else branch.

Signed-off-by: huangjunxian <huangjunxian6@hisilicon.com>
Signed-off-by: Haoyue Xu <xuhaoyue1@hisilicon.com>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 562b461224e7..15d7b7ed0830 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -117,8 +117,8 @@ int temac_indirect_busywait(struct temac_local *lp)
 	spin_until_cond(hard_acs_rdy_or_timeout(lp, timeout));
 	if (WARN_ON(!hard_acs_rdy(lp)))
 		return -ETIMEDOUT;
-	else
-		return 0;
+
+	return 0;
 }
 
 /*
@@ -307,11 +307,9 @@ static void temac_dma_bd_release(struct net_device *ndev)
 	for (i = 0; i < lp->rx_bd_num; i++) {
 		if (!lp->rx_skb[i])
 			break;
-		else {
-			dma_unmap_single(ndev->dev.parent, lp->rx_bd_v[i].phys,
-					 XTE_MAX_JUMBO_FRAME_SIZE, DMA_FROM_DEVICE);
-			dev_kfree_skb(lp->rx_skb[i]);
-		}
+		dma_unmap_single(ndev->dev.parent, lp->rx_bd_v[i].phys,
+				 XTE_MAX_JUMBO_FRAME_SIZE, DMA_FROM_DEVICE);
+		dev_kfree_skb(lp->rx_skb[i]);
 	}
 	if (lp->rx_bd_v)
 		dma_free_coherent(ndev->dev.parent,
-- 
2.30.0

