Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0470235460C
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 19:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238453AbhDER3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 13:29:42 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15482 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238299AbhDER3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 13:29:41 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FDczc1x2YzwR1P;
        Tue,  6 Apr 2021 01:27:24 +0800 (CST)
Received: from A190218597.china.huawei.com (10.47.69.183) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Tue, 6 Apr 2021 01:29:23 +0800
From:   Salil Mehta <salil.mehta@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <salil.mehta@huawei.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        <linuxarm@openeuler.org>
Subject: [PATCH net] net: hns3: Limiting the scope of vector_ring_chain variable
Date:   Mon, 5 Apr 2021 18:28:25 +0100
Message-ID: <20210405172825.28380-1-salil.mehta@huawei.com>
X-Mailer: git-send-email 2.8.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.47.69.183]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Limiting the scope of the variable vector_ring_chain to the block where it
is used.

Fixes: 424eb834a9be ("net: hns3: Unified HNS3 {VF|PF} Ethernet Driver for hip08 SoC")
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index bf4302a5cf95..65752f363f43 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3704,7 +3704,6 @@ static void hns3_nic_set_cpumask(struct hns3_nic_priv *priv)
 
 static int hns3_nic_init_vector_data(struct hns3_nic_priv *priv)
 {
-	struct hnae3_ring_chain_node vector_ring_chain;
 	struct hnae3_handle *h = priv->ae_handle;
 	struct hns3_enet_tqp_vector *tqp_vector;
 	int ret;
@@ -3736,6 +3735,8 @@ static int hns3_nic_init_vector_data(struct hns3_nic_priv *priv)
 	}
 
 	for (i = 0; i < priv->vector_num; i++) {
+		struct hnae3_ring_chain_node vector_ring_chain;
+
 		tqp_vector = &priv->tqp_vector[i];
 
 		tqp_vector->rx_group.total_bytes = 0;
-- 
2.17.1

