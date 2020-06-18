Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C24D81FDAB5
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 03:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgFRBEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 21:04:47 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56184 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726925AbgFRBEp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 21:04:45 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 4C975E157E6EF9496482;
        Thu, 18 Jun 2020 09:04:44 +0800 (CST)
Received: from SWX921481.china.huawei.com (10.126.203.42) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Thu, 18 Jun 2020 09:04:35 +0800
From:   Barry Song <song.bao.hua@hisilicon.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <netdev@vger.kernel.org>, <linyunsheng@huawei.com>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        Barry Song <song.bao.hua@hisilicon.com>
Subject: [PATCH 3/5] net: hns3: rename buffer-related functions
Date:   Thu, 18 Jun 2020 13:02:09 +1200
Message-ID: <20200618010211.75840-4-song.bao.hua@hisilicon.com>
X-Mailer: git-send-email 2.21.0.windows.1
In-Reply-To: <20200618010211.75840-1-song.bao.hua@hisilicon.com>
References: <20200618010211.75840-1-song.bao.hua@hisilicon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.126.203.42]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is for improving the readability.

Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 61b5a849b162..3cd2216e49b9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2405,7 +2405,7 @@ static int hns3_alloc_desc(struct hns3_enet_ring *ring)
 	return 0;
 }
 
-static int hns3_reserve_buffer_map(struct hns3_enet_ring *ring,
+static int hns3_alloc_and_map_buffer(struct hns3_enet_ring *ring,
 				   struct hns3_desc_cb *cb)
 {
 	int ret;
@@ -2426,9 +2426,9 @@ static int hns3_reserve_buffer_map(struct hns3_enet_ring *ring,
 	return ret;
 }
 
-static int hns3_alloc_buffer_attach(struct hns3_enet_ring *ring, int i)
+static int hns3_alloc_and_attach_buffer(struct hns3_enet_ring *ring, int i)
 {
-	int ret = hns3_reserve_buffer_map(ring, &ring->desc_cb[i]);
+	int ret = hns3_alloc_and_map_buffer(ring, &ring->desc_cb[i]);
 
 	if (ret)
 		return ret;
@@ -2444,7 +2444,7 @@ static int hns3_alloc_ring_buffers(struct hns3_enet_ring *ring)
 	int i, j, ret;
 
 	for (i = 0; i < ring->desc_num; i++) {
-		ret = hns3_alloc_buffer_attach(ring, i);
+		ret = hns3_alloc_and_attach_buffer(ring, i);
 		if (ret)
 			goto out_buffer_fail;
 	}
@@ -2590,7 +2590,7 @@ static void hns3_nic_alloc_rx_buffers(struct hns3_enet_ring *ring,
 
 			hns3_reuse_buffer(ring, ring->next_to_use);
 		} else {
-			ret = hns3_reserve_buffer_map(ring, &res_cbs);
+			ret = hns3_alloc_and_map_buffer(ring, &res_cbs);
 			if (ret) {
 				u64_stats_update_begin(&ring->syncp);
 				ring->stats.sw_err_cnt++;
@@ -4184,7 +4184,7 @@ static int hns3_clear_rx_ring(struct hns3_enet_ring *ring)
 		 * stack, so we need to replace the buffer here.
 		 */
 		if (!ring->desc_cb[ring->next_to_use].reuse_flag) {
-			ret = hns3_reserve_buffer_map(ring, &res_cbs);
+			ret = hns3_alloc_and_map_buffer(ring, &res_cbs);
 			if (ret) {
 				u64_stats_update_begin(&ring->syncp);
 				ring->stats.sw_err_cnt++;
-- 
2.23.0


