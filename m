Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 997133E457B
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 14:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234619AbhHIMUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 08:20:02 -0400
Received: from mx20.baidu.com ([111.202.115.85]:50906 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233632AbhHIMUB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 08:20:01 -0400
Received: from BC-Mail-Ex18.internal.baidu.com (unknown [172.31.51.12])
        by Forcepoint Email with ESMTPS id 960A8509129FF25E33E3;
        Mon,  9 Aug 2021 20:19:38 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-Ex18.internal.baidu.com (172.31.51.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Mon, 9 Aug 2021 20:19:38 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Mon, 9 Aug 2021 20:19:37 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <saeedm@nvidia.com>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Cai Huoqing <caihuoqing@baidu.com>
Subject: [PATCH v2] net/mlx5e: Make use of mlx5_core_warn()
Date:   Mon, 9 Aug 2021 20:19:31 +0800
Message-ID: <20210809121931.2519-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-Ex23.internal.baidu.com (172.31.51.17) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

to replace printk(KERN_WARNING ...) with mlx5_core_warn() kindly
if we use mlx5_core_warn(), the prefix "mlx5:" not needed

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index e5c4344a114e..304cca0f54d3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2702,7 +2702,8 @@ static int offload_pedit_fields(struct mlx5e_priv *priv,
 		if (s_mask && a_mask) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "can't set and add to the same HW field");
-			printk(KERN_WARNING "mlx5: can't set and add to the same HW field (%x)\n", f->field);
+			mlx5_core_warn(priv->mdev,
+				       "can't set and add to the same HW field (%x)\n", f->field);
 			return -EOPNOTSUPP;
 		}
 
@@ -2741,8 +2742,9 @@ static int offload_pedit_fields(struct mlx5e_priv *priv,
 		if (first < next_z && next_z < last) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "rewrite of few sub-fields isn't supported");
-			printk(KERN_WARNING "mlx5: rewrite of few sub-fields (mask %lx) isn't offloaded\n",
-			       mask);
+			mlx5_core_warn(priv->mdev,
+				       "rewrite of few sub-fields (mask %lx) isn't offloaded\n",
+				       mask);
 			return -EOPNOTSUPP;
 		}
 
-- 
2.25.1

