Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8977898BA4
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 08:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731824AbfHVGsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 02:48:46 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5189 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729942AbfHVGsp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 02:48:45 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 7299B4B329C9C06D80F1;
        Thu, 22 Aug 2019 14:48:40 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.439.0; Thu, 22 Aug 2019 14:48:30 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>, <davem@davemloft.net>
CC:     YueHaibing <yuehaibing@huawei.com>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net/mlx5e: Use PTR_ERR_OR_ZERO in mlx5e_tc_add_nic_flow()
Date:   Thu, 22 Aug 2019 06:52:19 +0000
Message-ID: <20190822065219.73945-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use PTR_ERR_OR_ZERO rather than if(IS_ERR(...)) + PTR_ERR

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 3917834b48ff..9d38c9e88f76 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -985,10 +985,7 @@ mlx5e_tc_add_nic_flow(struct mlx5e_priv *priv,
 					    &flow_act, dest, dest_ix);
 	mutex_unlock(&priv->fs.tc.t_lock);
 
-	if (IS_ERR(flow->rule[0]))
-		return PTR_ERR(flow->rule[0]);
-
-	return 0;
+	return PTR_ERR_OR_ZERO(flow->rule[0]);
 }
 
 static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *priv,



