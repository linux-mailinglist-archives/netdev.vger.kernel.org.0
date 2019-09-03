Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA21A6212
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 08:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbfICG7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 02:59:16 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5725 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726473AbfICG7M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 02:59:12 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B030542BB1209F07EE3E;
        Tue,  3 Sep 2019 14:59:10 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Tue, 3 Sep 2019 14:59:04 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <davem@davemloft.net>
CC:     <saeedm@mellanox.com>, <leon@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <zhongjiang@huawei.com>
Subject: [PATCH] net/mlx5: Use PTR_ERR_OR_ZERO rather than its implementation
Date:   Tue, 3 Sep 2019 14:56:10 +0800
Message-ID: <1567493770-20074-1-git-send-email-zhongjiang@huawei.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PTR_ERR_OR_ZERO contains if(IS_ERR(...)) + PTR_ERR. It is better
to use it directly. hence just replace it.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 5581a80..2e0b467 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -989,10 +989,7 @@ static void mlx5e_hairpin_flow_del(struct mlx5e_priv *priv,
 					    &flow_act, dest, dest_ix);
 	mutex_unlock(&priv->fs.tc.t_lock);
 
-	if (IS_ERR(flow->rule[0]))
-		return PTR_ERR(flow->rule[0]);
-
-	return 0;
+	return PTR_ERR_OR_ZERO(flow->rule[0]);
 }
 
 static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *priv,
-- 
1.7.12.4

