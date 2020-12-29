Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D760D2E712C
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 14:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgL2Nx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 08:53:29 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10005 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727037AbgL2Nx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 08:53:28 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4D4wnn0GRjzhw13;
        Tue, 29 Dec 2020 21:51:57 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.498.0; Tue, 29 Dec 2020 21:52:39 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <saeedm@nvidia.com>, <leon@kernel.org>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net/mlx5: Use kzalloc for allocating only one thing
Date:   Tue, 29 Dec 2020 21:53:18 +0800
Message-ID: <20201229135318.24195-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use kzalloc rather than kcalloc(1,...)

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
@@

- kcalloc(1,
+ kzalloc(
          ...)
// </smpl>

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index df1363a34a42..9837d2e8d687 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -1782,7 +1782,7 @@ static int dr_action_create_modify_action(struct mlx5dr_domain *dmn,
 	if (!chunk)
 		return -ENOMEM;
 
-	hw_actions = kcalloc(1, max_hw_actions * DR_MODIFY_ACTION_SIZE, GFP_KERNEL);
+	hw_actions = kzalloc(max_hw_actions * DR_MODIFY_ACTION_SIZE, GFP_KERNEL);
 	if (!hw_actions) {
 		ret = -ENOMEM;
 		goto free_chunk;
-- 
2.22.0

