Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFC7459DCF
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 09:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbhKWI0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 03:26:18 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:15850 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbhKWI0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 03:26:18 -0500
Received: from dggeml709-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Hyxw22vXHz9148;
        Tue, 23 Nov 2021 16:22:42 +0800 (CST)
Received: from localhost.localdomain (10.175.102.38) by
 dggeml709-chm.china.huawei.com (10.3.17.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Tue, 23 Nov 2021 16:23:07 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     <weiyongjun1@huawei.com>, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dmytro Linkin <dlinkin@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Parav Pandit <parav@nvidia.com>, Huy Nguyen <huyn@nvidia.com>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH net-next] net/mlx5: Fix error return code in esw_qos_create()
Date:   Tue, 23 Nov 2021 08:36:16 +0000
Message-ID: <20211123083616.2366704-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.102.38]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggeml709-chm.china.huawei.com (10.3.17.139)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 85c5f7c9200e ("net/mlx5: E-switch, Create QoS on demand")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
index ff0a07a91992..11e742d342ec 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
@@ -590,6 +590,7 @@ static int esw_qos_create(struct mlx5_eswitch *esw, struct netlink_ext_ack *exta
 		if (IS_ERR(esw->qos.group0)) {
 			esw_warn(dev, "E-Switch create rate group 0 failed (%ld)\n",
 				 PTR_ERR(esw->qos.group0));
+			err = PTR_ERR(esw->qos.group0);
 			goto err_group0;
 		}
 	}

