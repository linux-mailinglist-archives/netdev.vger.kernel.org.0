Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7282F3E50F8
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 04:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236474AbhHJCJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 22:09:10 -0400
Received: from mx20.baidu.com ([111.202.115.85]:38926 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232947AbhHJCJK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 22:09:10 -0400
Received: from BC-Mail-Ex09.internal.baidu.com (unknown [172.31.51.49])
        by Forcepoint Email with ESMTPS id 19A22F8184B5946A4E92;
        Tue, 10 Aug 2021 10:08:36 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-Ex09.internal.baidu.com (172.31.51.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Tue, 10 Aug 2021 10:08:35 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Tue, 10 Aug 2021 10:08:35 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <saeedm@nvidia.com>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Cai Huoqing <caihuoqing@baidu.com>
Subject: [PATCH v3] net/mlx5e: Make use of netdev_warn()
Date:   Tue, 10 Aug 2021 10:08:22 +0800
Message-ID: <20210810020822.2650-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-EX02.internal.baidu.com (172.31.51.42) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

to replace printk(KERN_WARNING ...) with netdev_warn() kindly

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index e5c4344a114e..712feae789f7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2702,7 +2702,9 @@ static int offload_pedit_fields(struct mlx5e_priv *priv,
 		if (s_mask && a_mask) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "can't set and add to the same HW field");
-			printk(KERN_WARNING "mlx5: can't set and add to the same HW field (%x)\n", f->field);
+			netdev_warn(priv->netdev,
+				    "mlx5: can't set and add to the same HW field (%x)\n",
+				    f->field);
 			return -EOPNOTSUPP;
 		}
 
@@ -2741,8 +2743,9 @@ static int offload_pedit_fields(struct mlx5e_priv *priv,
 		if (first < next_z && next_z < last) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "rewrite of few sub-fields isn't supported");
-			printk(KERN_WARNING "mlx5: rewrite of few sub-fields (mask %lx) isn't offloaded\n",
-			       mask);
+			netdev_warn(priv->netdev,
+				    "mlx5: rewrite of few sub-fields (mask %lx) isn't offloaded\n",
+				    mask);
 			return -EOPNOTSUPP;
 		}
 
-- 
2.25.1

