Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED2871C87AD
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 13:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbgEGLJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 07:09:48 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:51028 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725809AbgEGLJs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 07:09:48 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 81558BB68AC7B0BAF879;
        Thu,  7 May 2020 19:09:46 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Thu, 7 May 2020
 19:09:36 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <tariqt@mellanox.com>, <davem@davemloft.net>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <kuba@kernel.org>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH net-next] net: mlx4: remove unneeded variable "err" in mlx4_en_ethtool_add_mac_rule()
Date:   Thu, 7 May 2020 19:08:57 +0800
Message-ID: <20200507110857.38035-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:

drivers/net/ethernet/mellanox/mlx4/en_ethtool.c:1396:5-8: Unneeded
variable: "err". Return "0" on line 1411

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
index 216e6b2e9eed..b816154bc79a 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -1392,7 +1392,6 @@ static int mlx4_en_ethtool_add_mac_rule(struct ethtool_rxnfc *cmd,
 					struct mlx4_spec_list *spec_l2,
 					unsigned char *mac)
 {
-	int err = 0;
 	__be64 mac_msk = cpu_to_be64(MLX4_MAC_MASK << 16);
 
 	spec_l2->id = MLX4_NET_TRANS_RULE_ID_ETH;
@@ -1407,7 +1406,7 @@ static int mlx4_en_ethtool_add_mac_rule(struct ethtool_rxnfc *cmd,
 
 	list_add_tail(&spec_l2->list, rule_list_h);
 
-	return err;
+	return 0;
 }
 
 static int mlx4_en_ethtool_add_mac_rule_by_ipv4(struct mlx4_en_priv *priv,
-- 
2.21.1

