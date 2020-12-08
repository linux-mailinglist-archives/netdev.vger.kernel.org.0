Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB5D62D2C55
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 14:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729553AbgLHN4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 08:56:10 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:8967 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgLHN4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 08:56:10 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Cr1s073dhzhnnQ;
        Tue,  8 Dec 2020 21:55:00 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Tue, 8 Dec 2020 21:55:15 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net/mlx4: simplify the return expression of mlx4_init_cq_table()
Date:   Tue, 8 Dec 2020 21:55:43 +0800
Message-ID: <20201208135543.11820-1-zhengyongjun3@huawei.com>
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
 drivers/net/ethernet/mellanox/mlx4/cq.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/cq.c b/drivers/net/ethernet/mellanox/mlx4/cq.c
index 3b8576b9c2f9..68bd18ee6ee3 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cq.c
@@ -462,19 +462,14 @@ EXPORT_SYMBOL_GPL(mlx4_cq_free);
 int mlx4_init_cq_table(struct mlx4_dev *dev)
 {
 	struct mlx4_cq_table *cq_table = &mlx4_priv(dev)->cq_table;
-	int err;
 
 	spin_lock_init(&cq_table->lock);
 	INIT_RADIX_TREE(&cq_table->tree, GFP_ATOMIC);
 	if (mlx4_is_slave(dev))
 		return 0;
 
-	err = mlx4_bitmap_init(&cq_table->bitmap, dev->caps.num_cqs,
-			       dev->caps.num_cqs - 1, dev->caps.reserved_cqs, 0);
-	if (err)
-		return err;
-
-	return 0;
+	return mlx4_bitmap_init(&cq_table->bitmap, dev->caps.num_cqs,
+			        dev->caps.num_cqs - 1, dev->caps.reserved_cqs, 0);
 }
 
 void mlx4_cleanup_cq_table(struct mlx4_dev *dev)
-- 
2.22.0

