Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF59364173
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 14:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239128AbhDSMS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 08:18:29 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:16601 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239042AbhDSMS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 08:18:28 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FP5PN41CYz1BGVR;
        Mon, 19 Apr 2021 20:15:36 +0800 (CST)
Received: from localhost (10.174.242.151) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.498.0; Mon, 19 Apr 2021
 20:17:49 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>
CC:     <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        <dingxiaoxiong@huawei.com>, Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net] net/mlx5e: Fix uninitialised struct field moder.comps
Date:   Mon, 19 Apr 2021 20:17:42 +0800
Message-ID: <1618834662-20292-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.242.151]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

The 'comps' struct field in 'moder' is not being initialized
in mlx5e_get_def_rx_moderation(). So initialize 'moder' to
zero to avoid the issue.

Addresses-Coverity: ("Uninitialized scalar variable")
Fixes: 398c2b05bbee ("linux/dim: Add completions count to dim_sample")
Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 5db63b9f3b70..9bcedfb0adfa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4881,7 +4881,7 @@ static struct dim_cq_moder mlx5e_get_def_tx_moderation(u8 cq_period_mode)
 
 static struct dim_cq_moder mlx5e_get_def_rx_moderation(u8 cq_period_mode)
 {
-	struct dim_cq_moder moder;
+	struct dim_cq_moder moder = {};
 
 	moder.cq_period_mode = cq_period_mode;
 	moder.pkts = MLX5E_PARAMS_DEFAULT_RX_CQ_MODERATION_PKTS;
-- 
2.23.0

