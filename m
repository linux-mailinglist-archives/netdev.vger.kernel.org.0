Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30A912EA3F9
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 04:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbhAEDi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 22:38:57 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10018 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbhAEDi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 22:38:57 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4D8yqP47Q5zj1WF;
        Tue,  5 Jan 2021 11:37:21 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Tue, 5 Jan 2021 11:38:04 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <kuba@kernel.org>,
        <huangdaode@huawei.com>, "Yufeng Mo" <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 2/3] net: hns3: fix the number of queues actually used by ARQ
Date:   Tue, 5 Jan 2021 11:37:27 +0800
Message-ID: <1609817848-47370-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1609817848-47370-1-git-send-email-tanhuazhong@huawei.com>
References: <1609817848-47370-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

HCLGE_MBX_MAX_ARQ_MSG_NUM is used to apply memory for the number
of queues used by ARQ(Asynchronous Receive Queue), so the head
and tail pointers should also use this macro.

Fixes: 07a0556a3a73 ("net: hns3: Changes to support ARQ(Asynchronous Receive Queue)")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
index fb5e884..33defa4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
@@ -169,7 +169,7 @@ struct hclgevf_mbx_arq_ring {
 #define hclge_mbx_ring_ptr_move_crq(crq) \
 	(crq->next_to_use = (crq->next_to_use + 1) % crq->desc_num)
 #define hclge_mbx_tail_ptr_move_arq(arq) \
-	(arq.tail = (arq.tail + 1) % HCLGE_MBX_MAX_ARQ_MSG_SIZE)
+		(arq.tail = (arq.tail + 1) % HCLGE_MBX_MAX_ARQ_MSG_NUM)
 #define hclge_mbx_head_ptr_move_arq(arq) \
-		(arq.head = (arq.head + 1) % HCLGE_MBX_MAX_ARQ_MSG_SIZE)
+		(arq.head = (arq.head + 1) % HCLGE_MBX_MAX_ARQ_MSG_NUM)
 #endif
-- 
2.7.4

