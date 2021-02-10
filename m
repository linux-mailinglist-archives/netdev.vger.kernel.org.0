Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1EF4316050
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 08:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232955AbhBJHsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 02:48:42 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:13338 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232936AbhBJHqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 02:46:36 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DbBby1ZLgz7j4v;
        Wed, 10 Feb 2021 15:44:30 +0800 (CST)
Received: from localhost.localdomain (10.175.102.38) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Wed, 10 Feb 2021 15:45:43 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Hulk Robot <hulkci@huawei.com>, Saeed Mahameed <saeedm@nvidia.com>,
        "Leon Romanovsky" <leon@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Parav Pandit <parav@nvidia.com>, Vu Pham <vuhuong@nvidia.com>
CC:     Wei Yongjun <weiyongjun1@huawei.com>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>
Subject: [PATCH net-next] net/mlx5: SF, Fix error return code in mlx5_sf_dev_probe()
Date:   Wed, 10 Feb 2021 07:54:17 +0000
Message-ID: <20210210075417.1096059-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.102.38]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix to return negative error code -ENOMEM from the ioremap() error
handling case instead of 0, as done elsewhere in this function.

Fixes: 1958fc2f0712 ("net/mlx5: SF, Add auxiliary device driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 .../net/ethernet/mellanox/mlx5/core/sf/dev/driver.c  | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
index daf63a8115e0..c4bf555c25ea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
@@ -37,6 +37,7 @@ static int mlx5_sf_dev_probe(struct auxiliary_device *adev, const struct auxilia
 	mdev->iseg = ioremap(mdev->iseg_base, sizeof(*mdev->iseg));
 	if (!mdev->iseg) {
 		mlx5_core_warn(mdev, "remap error\n");
+		err = -ENOMEM;
 		goto remap_err;
 	}
 

