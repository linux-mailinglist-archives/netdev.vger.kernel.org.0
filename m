Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95D11A9E80
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 11:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731864AbfIEJfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 05:35:41 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:54584 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730839AbfIEJfl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 05:35:41 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id ADB7A41D25BC6B19D5FB;
        Thu,  5 Sep 2019 17:35:39 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.439.0; Thu, 5 Sep 2019 17:35:32 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Mark Bloch <markb@mellanox.com>,
        Alex Vesker <valex@mellanox.com>,
        "Erez Shitrit" <erezsh@mellanox.com>
CC:     Wei Yongjun <weiyongjun1@huawei.com>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next] net/mlx5: DR, Remove useless set memory to zero use memset()
Date:   Thu, 5 Sep 2019 09:53:26 +0000
Message-ID: <20190905095326.127277-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The memory return by kzalloc() has already be set to zero, so
remove useless memset(0).

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index ef0dea44f3b3..5df8436b2ae3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -899,7 +899,6 @@ int mlx5dr_send_ring_alloc(struct mlx5dr_domain *dmn)
 		goto clean_qp;
 	}
 
-	memset(dmn->send_ring->buf, 0, size);
 	dmn->send_ring->buf_size = size;
 
 	dmn->send_ring->mr = dr_reg_mr(dmn->mdev,



