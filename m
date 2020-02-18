Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63DC8161ECE
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 03:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgBRCAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 21:00:09 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10196 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726140AbgBRCAI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Feb 2020 21:00:08 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id B0213BD0F2FC8BAE92CD;
        Tue, 18 Feb 2020 10:00:03 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Tue, 18 Feb 2020
 09:59:56 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <netanel@amazon.com>, <akiyano@amazon.com>, <gtzalik@amazon.com>,
        <saeedb@amazon.com>, <zorik@amazon.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <sameehj@amazon.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net: ena: remove set but not used variable 'rx_ring'
Date:   Tue, 18 Feb 2020 09:59:51 +0800
Message-ID: <20200218015951.7224-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/ethernet/amazon/ena/ena_netdev.c: In function ena_xdp_xmit_buff:
drivers/net/ethernet/amazon/ena/ena_netdev.c:316:19: warning:
 variable rx_ring set but not used [-Wunused-but-set-variable]

commit 548c4940b9f1 ("net: ena: Implement XDP_TX action")
left behind this unused variable.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 081acf0..894e8c1 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -313,7 +313,6 @@ static int ena_xdp_xmit_buff(struct net_device *dev,
 	struct ena_com_tx_ctx ena_tx_ctx = {0};
 	struct ena_tx_buffer *tx_info;
 	struct ena_ring *xdp_ring;
-	struct ena_ring *rx_ring;
 	u16 next_to_use, req_id;
 	int rc;
 	void *push_hdr;
@@ -324,8 +323,6 @@ static int ena_xdp_xmit_buff(struct net_device *dev,
 	req_id = xdp_ring->free_ids[next_to_use];
 	tx_info = &xdp_ring->tx_buffer_info[req_id];
 	tx_info->num_of_bufs = 0;
-	rx_ring = &xdp_ring->adapter->rx_ring[qid -
-		  xdp_ring->adapter->xdp_first_ring];
 	page_ref_inc(rx_info->page);
 	tx_info->xdp_rx_page = rx_info->page;
 
-- 
2.7.4


