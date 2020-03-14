Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21BD218591B
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 03:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727513AbgCOCel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 22:34:41 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:59700 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726667AbgCOCek (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Mar 2020 22:34:40 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id CD76F611D5F8A1C35A9B;
        Sat, 14 Mar 2020 18:47:55 +0800 (CST)
Received: from localhost (10.173.223.234) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Sat, 14 Mar 2020
 18:47:47 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <saeedm@mellanox.com>, <leon@kernel.org>, <davem@davemloft.net>,
        <ozsh@mellanox.com>, <paulb@mellanox.com>, <roid@mellanox.com>,
        <jiri@mellanox.com>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net/mlx5e: CT: remove set but not used variable 'unnew'
Date:   Sat, 14 Mar 2020 18:44:46 +0800
Message-ID: <20200314104446.54364-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.173.223.234]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c:
 In function mlx5_tc_ct_parse_match:
drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c:699:36: warning:
 variable unnew set but not used [-Wunused-but-set-variable]

commit 4c3844d9e97e ("net/mlx5e: CT: Introduce connection tracking")
involed this unused variable, remove it.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 956d9ddcdeed..9fe150957d65 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -696,7 +696,7 @@ mlx5_tc_ct_parse_match(struct mlx5e_priv *priv,
 {
 	struct mlx5_tc_ct_priv *ct_priv = mlx5_tc_ct_get_ct_priv(priv);
 	struct flow_dissector_key_ct *mask, *key;
-	bool trk, est, untrk, unest, new, unnew;
+	bool trk, est, untrk, unest, new;
 	u32 ctstate = 0, ctstate_mask = 0;
 	u16 ct_state_on, ct_state_off;
 	u16 ct_state, ct_state_mask;
@@ -739,7 +739,6 @@ mlx5_tc_ct_parse_match(struct mlx5e_priv *priv,
 	new = ct_state_on & TCA_FLOWER_KEY_CT_FLAGS_NEW;
 	est = ct_state_on & TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED;
 	untrk = ct_state_off & TCA_FLOWER_KEY_CT_FLAGS_TRACKED;
-	unnew = ct_state_off & TCA_FLOWER_KEY_CT_FLAGS_NEW;
 	unest = ct_state_off & TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED;
 
 	ctstate |= trk ? MLX5_CT_STATE_TRK_BIT : 0;
-- 
2.20.1


