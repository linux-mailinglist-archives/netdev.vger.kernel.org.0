Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 691F42724F6
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 15:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbgIUNKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 09:10:30 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13804 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727331AbgIUNK2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 09:10:28 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C9984B85D2801ABBABC2;
        Mon, 21 Sep 2020 21:10:26 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Mon, 21 Sep 2020 21:10:16 +0800
From:   Qinglang Miao <miaoqinglang@huawei.com>
To:     Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Qinglang Miao <miaoqinglang@huawei.com>
Subject: [PATCH -next] mlxsw: spectrum_router: simplify the return expression of __mlxsw_sp_router_init()
Date:   Mon, 21 Sep 2020 21:10:41 +0800
Message-ID: <20200921131041.92294-1-miaoqinglang@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the return expression.

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 24f1fd1f8..9188fc32b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -8033,7 +8033,6 @@ static int __mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp)
 	bool usp = net->ipv4.sysctl_ip_fwd_update_priority;
 	char rgcr_pl[MLXSW_REG_RGCR_LEN];
 	u64 max_rifs;
-	int err;
 
 	if (!MLXSW_CORE_RES_VALID(mlxsw_sp->core, MAX_RIFS))
 		return -EIO;
@@ -8042,10 +8041,7 @@ static int __mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp)
 	mlxsw_reg_rgcr_pack(rgcr_pl, true, true);
 	mlxsw_reg_rgcr_max_router_interfaces_set(rgcr_pl, max_rifs);
 	mlxsw_reg_rgcr_usp_set(rgcr_pl, usp);
-	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(rgcr), rgcr_pl);
-	if (err)
-		return err;
-	return 0;
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(rgcr), rgcr_pl);
 }
 
 static void __mlxsw_sp_router_fini(struct mlxsw_sp *mlxsw_sp)
-- 
2.23.0

