Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0A42E76FC
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 09:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgL3ISo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 03:18:44 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10097 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbgL3ISn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 03:18:43 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4D5PJp5wQVzMBql;
        Wed, 30 Dec 2020 16:16:58 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Wed, 30 Dec 2020 16:17:56 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <mlxsw@nvidia.com>, Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net/mlxfw: Use kzalloc for allocating only one thing
Date:   Wed, 30 Dec 2020 16:18:35 +0800
Message-ID: <20201230081835.536-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use kzalloc rather than kcalloc(1,...)

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
@@

- kcalloc(1,
+ kzalloc(
          ...)
// </smpl>

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2.c b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2.c
index 5d9ddf36fb4e..e6f677e42007 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2.c
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2.c
@@ -267,7 +267,7 @@ struct mlxfw_mfa2_file *mlxfw_mfa2_file_init(const struct firmware *fw)
 	const void *first_tlv_ptr;
 	const void *cb_top_ptr;
 
-	mfa2_file = kcalloc(1, sizeof(*mfa2_file), GFP_KERNEL);
+	mfa2_file = kzalloc(sizeof(*mfa2_file), GFP_KERNEL);
 	if (!mfa2_file)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.22.0

