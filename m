Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7E972D3836
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 02:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbgLIBU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 20:20:26 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:9398 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbgLIBU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 20:20:26 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CrK2S1PMZz7BZQ;
        Wed,  9 Dec 2020 09:19:12 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Wed, 9 Dec 2020 09:19:34 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH v2 net-next] net/mlx4: simplify the return expression of mlx4_init_cq_table()
Date:   Wed, 9 Dec 2020 09:20:02 +0800
Message-ID: <20201209012002.18766-1-zhengyongjun3@huawei.com>
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
index 3b8576b9c2f9..f7053a74e6a8 100644
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
+				dev->caps.num_cqs - 1, dev->caps.reserved_cqs, 0);
 }
 
 void mlx4_cleanup_cq_table(struct mlx4_dev *dev)
-- 
2.22.0

