Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDCA03E421B
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 11:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234161AbhHIJJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 05:09:27 -0400
Received: from mx20.baidu.com ([111.202.115.85]:39178 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234130AbhHIJJZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 05:09:25 -0400
Received: from BC-Mail-Ex21.internal.baidu.com (unknown [172.31.51.15])
        by Forcepoint Email with ESMTPS id CA252185AD81A4ECADD6;
        Mon,  9 Aug 2021 17:08:50 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-Ex21.internal.baidu.com (172.31.51.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Mon, 9 Aug 2021 17:08:50 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Mon, 9 Aug 2021 17:08:50 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <saeedm@nvidia.com>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Cai Huoqing <caihuoqing@baidu.com>
Subject: [PATCH] net/mlx5e: Make use of pr_warn()
Date:   Mon, 9 Aug 2021 17:08:43 +0800
Message-ID: <20210809090843.2456-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

to replace printk(KERN_WARNING ...) with pr_warn() kindly

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index e5c4344a114e..ab7c059e630f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2702,7 +2702,7 @@ static int offload_pedit_fields(struct mlx5e_priv *priv,
 		if (s_mask && a_mask) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "can't set and add to the same HW field");
-			printk(KERN_WARNING "mlx5: can't set and add to the same HW field (%x)\n", f->field);
+			pr_warn("mlx5: can't set and add to the same HW field (%x)\n", f->field);
 			return -EOPNOTSUPP;
 		}
 
@@ -2741,8 +2741,8 @@ static int offload_pedit_fields(struct mlx5e_priv *priv,
 		if (first < next_z && next_z < last) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "rewrite of few sub-fields isn't supported");
-			printk(KERN_WARNING "mlx5: rewrite of few sub-fields (mask %lx) isn't offloaded\n",
-			       mask);
+			pr_warn("mlx5: rewrite of few sub-fields (mask %lx) isn't offloaded\n",
+				mask);
 			return -EOPNOTSUPP;
 		}
 
-- 
2.25.1

