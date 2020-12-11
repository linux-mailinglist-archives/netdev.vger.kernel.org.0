Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68F132D71E9
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 09:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392284AbgLKIhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 03:37:55 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9511 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392128AbgLKIhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 03:37:32 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Cskdn2MnHzhqj1;
        Fri, 11 Dec 2020 16:36:13 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Fri, 11 Dec 2020 16:36:38 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sagis@google.com>, <jonolson@google.com>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] gve: simplify the gve code return expression
Date:   Fri, 11 Dec 2020 16:37:06 +0800
Message-ID: <20201211083706.1565-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the return expression at diffrent gve_adminq.c file, simplify this all.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/ethernet/google/gve/gve_adminq.c | 21 +++-----------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index 24ae6a28a806..6719181afdfd 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -318,7 +318,6 @@ static int gve_adminq_create_tx_queue(struct gve_priv *priv, u32 queue_index)
 {
 	struct gve_tx_ring *tx = &priv->tx[queue_index];
 	union gve_adminq_command cmd;
-	int err;
 
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.opcode = cpu_to_be32(GVE_ADMINQ_CREATE_TX_QUEUE);
@@ -332,11 +331,7 @@ static int gve_adminq_create_tx_queue(struct gve_priv *priv, u32 queue_index)
 		.ntfy_id = cpu_to_be32(tx->ntfy_id),
 	};
 
-	err = gve_adminq_issue_cmd(priv, &cmd);
-	if (err)
-		return err;
-
-	return 0;
+	return gve_adminq_issue_cmd(priv, &cmd);
 }
 
 int gve_adminq_create_tx_queues(struct gve_priv *priv, u32 num_queues)
@@ -357,7 +352,6 @@ static int gve_adminq_create_rx_queue(struct gve_priv *priv, u32 queue_index)
 {
 	struct gve_rx_ring *rx = &priv->rx[queue_index];
 	union gve_adminq_command cmd;
-	int err;
 
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.opcode = cpu_to_be32(GVE_ADMINQ_CREATE_RX_QUEUE);
@@ -372,11 +366,7 @@ static int gve_adminq_create_rx_queue(struct gve_priv *priv, u32 queue_index)
 		.queue_page_list_id = cpu_to_be32(rx->data.qpl->id),
 	};
 
-	err = gve_adminq_issue_cmd(priv, &cmd);
-	if (err)
-		return err;
-
-	return 0;
+	return gve_adminq_issue_cmd(priv, &cmd);
 }
 
 int gve_adminq_create_rx_queues(struct gve_priv *priv, u32 num_queues)
@@ -396,7 +386,6 @@ int gve_adminq_create_rx_queues(struct gve_priv *priv, u32 num_queues)
 static int gve_adminq_destroy_tx_queue(struct gve_priv *priv, u32 queue_index)
 {
 	union gve_adminq_command cmd;
-	int err;
 
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.opcode = cpu_to_be32(GVE_ADMINQ_DESTROY_TX_QUEUE);
@@ -404,11 +393,7 @@ static int gve_adminq_destroy_tx_queue(struct gve_priv *priv, u32 queue_index)
 		.queue_id = cpu_to_be32(queue_index),
 	};
 
-	err = gve_adminq_issue_cmd(priv, &cmd);
-	if (err)
-		return err;
-
-	return 0;
+	return gve_adminq_issue_cmd(priv, &cmd);
 }
 
 int gve_adminq_destroy_tx_queues(struct gve_priv *priv, u32 num_queues)
-- 
2.22.0

