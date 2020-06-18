Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A33A1FDAB3
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 03:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbgFRBEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 21:04:38 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:6275 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726925AbgFRBEh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 21:04:37 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 24E1A870145D785E347D;
        Thu, 18 Jun 2020 09:04:36 +0800 (CST)
Received: from SWX921481.china.huawei.com (10.126.203.42) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Thu, 18 Jun 2020 09:04:25 +0800
From:   Barry Song <song.bao.hua@hisilicon.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <netdev@vger.kernel.org>, <linyunsheng@huawei.com>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        Barry Song <song.bao.hua@hisilicon.com>
Subject: [PATCH 2/5] net: hns3: pointer type of buffer should be void
Date:   Thu, 18 Jun 2020 13:02:08 +1200
Message-ID: <20200618010211.75840-3-song.bao.hua@hisilicon.com>
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

Move the type of buffer address from unsigned char to void

Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 1817d7f2e5f6..61b5a849b162 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3070,7 +3070,7 @@ static int hns3_handle_rx_bd(struct hns3_enet_ring *ring)
 		return -ENXIO;
 
 	if (!skb)
-		ring->va = (unsigned char *)desc_cb->buf + desc_cb->page_offset;
+		ring->va = desc_cb->buf + desc_cb->page_offset;
 
 	/* Prefetch first cache line of first page
 	 * Idea is to cache few bytes of the header of the packet. Our L1 Cache
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 66cd4395f781..9f64077ee834 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -407,7 +407,7 @@ struct hns3_enet_ring {
 
 	u32 pull_len; /* head length for current packet */
 	u32 frag_num;
-	unsigned char *va; /* first buffer address for current packet */
+	void *va; /* first buffer address for current packet */
 
 	u32 flag;          /* ring attribute */
 
-- 
2.23.0


