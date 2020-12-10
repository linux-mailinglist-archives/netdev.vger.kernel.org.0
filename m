Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F9F2D5C4C
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 14:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389602AbgLJNub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 08:50:31 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9178 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389594AbgLJNuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 08:50:24 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CsFd771gwzkmF9;
        Thu, 10 Dec 2020 21:48:59 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Thu, 10 Dec 2020 21:49:31 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <mcoquelin.stm32@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net/mlx4: simplify the return expression of mlx4_init_srq_table()
Date:   Thu, 10 Dec 2020 21:50:00 +0800
Message-ID: <20201210135000.1022-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the return expression.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx4/srq.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/srq.c b/drivers/net/ethernet/mellanox/mlx4/srq.c
index cbe4d9746ddf..dd890f5d7b72 100644
--- a/drivers/net/ethernet/mellanox/mlx4/srq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/srq.c
@@ -272,19 +272,14 @@ EXPORT_SYMBOL_GPL(mlx4_srq_query);
 int mlx4_init_srq_table(struct mlx4_dev *dev)
 {
 	struct mlx4_srq_table *srq_table = &mlx4_priv(dev)->srq_table;
-	int err;
 
 	spin_lock_init(&srq_table->lock);
 	INIT_RADIX_TREE(&srq_table->tree, GFP_ATOMIC);
 	if (mlx4_is_slave(dev))
 		return 0;
 
-	err = mlx4_bitmap_init(&srq_table->bitmap, dev->caps.num_srqs,
-			       dev->caps.num_srqs - 1, dev->caps.reserved_srqs, 0);
-	if (err)
-		return err;
-
-	return 0;
+	return mlx4_bitmap_init(&srq_table->bitmap, dev->caps.num_srqs,
+				dev->caps.num_srqs - 1, dev->caps.reserved_srqs, 0);
 }
 
 void mlx4_cleanup_srq_table(struct mlx4_dev *dev)
-- 
2.22.0

