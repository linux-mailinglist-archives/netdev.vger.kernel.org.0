Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B27A6B1322
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 19:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730941AbfILRCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 13:02:09 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:40150 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730583AbfILRCI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Sep 2019 13:02:08 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 71FFFFE284DD2F055170;
        Fri, 13 Sep 2019 01:02:05 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.439.0; Fri, 13 Sep 2019 01:02:04 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <davem@davemloft.net>, <saeedm@mellanox.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] net/mlx5: Remove unneeded variable in mlx5_unload_one
Date:   Fri, 13 Sep 2019 00:59:02 +0800
Message-ID: <1568307542-43797-1-git-send-email-zhongjiang@huawei.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mlx5_unload_one do not need local variable to store different value,
Hence just remove it.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 9648c22..c39bb37 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1228,8 +1228,6 @@ static int mlx5_load_one(struct mlx5_core_dev *dev, bool boot)
 
 static int mlx5_unload_one(struct mlx5_core_dev *dev, bool cleanup)
 {
-	int err = 0;
-
 	if (cleanup) {
 		mlx5_unregister_device(dev);
 		mlx5_drain_health_wq(dev);
@@ -1257,7 +1255,7 @@ static int mlx5_unload_one(struct mlx5_core_dev *dev, bool cleanup)
 	mlx5_function_teardown(dev, cleanup);
 out:
 	mutex_unlock(&dev->intf_state_mutex);
-	return err;
+	return 0;
 }
 
 static int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
-- 
1.7.12.4

