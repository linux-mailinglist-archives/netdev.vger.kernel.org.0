Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD5B2608D5
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 05:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbgIHDCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 23:02:35 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:11255 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728327AbgIHDCa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 23:02:30 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id AE48EE57535693C496F3;
        Tue,  8 Sep 2020 11:02:27 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Tue, 8 Sep 2020 11:02:19 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 4/7] net: hns3: remove unused field 'io_base' in struct hns3_enet_ring
Date:   Tue, 8 Sep 2020 10:59:51 +0800
Message-ID: <1599533994-32744-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599533994-32744-1-git-send-email-tanhuazhong@huawei.com>
References: <1599533994-32744-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'io_base' has been defined and initialized, but never used,
so remove it.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 2 --
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h | 1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 47ab2a5..1d66f84 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3670,12 +3670,10 @@ static void hns3_ring_get_cfg(struct hnae3_queue *q, struct hns3_nic_priv *priv,
 		ring = &priv->ring[q->tqp_index];
 		desc_num = priv->ae_handle->kinfo.num_tx_desc;
 		ring->queue_index = q->tqp_index;
-		ring->io_base = (u8 __iomem *)q->io_base + HNS3_TX_REG_OFFSET;
 	} else {
 		ring = &priv->ring[q->tqp_index + queue_num];
 		desc_num = priv->ae_handle->kinfo.num_rx_desc;
 		ring->queue_index = q->tqp_index;
-		ring->io_base = q->io_base;
 	}
 
 	hnae3_set_bit(ring->flag, HNAE3_RING_TYPE_B, ring_type);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 9922c5f..0c146e7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -380,7 +380,6 @@ struct ring_stats {
 };
 
 struct hns3_enet_ring {
-	u8 __iomem *io_base; /* base io address for the ring */
 	struct hns3_desc *desc; /* dma map address space */
 	struct hns3_desc_cb *desc_cb;
 	struct hns3_enet_ring *next;
-- 
2.7.4

