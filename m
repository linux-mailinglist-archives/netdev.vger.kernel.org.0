Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F13E11C4C7C
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 05:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgEEDHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 23:07:36 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:34056 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726286AbgEEDHg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 23:07:36 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 964AADF6DE1001F56FFA;
        Tue,  5 May 2020 11:07:30 +0800 (CST)
Received: from localhost (10.173.251.152) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Tue, 5 May 2020
 11:06:46 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <jerry.lilijun@huawei.com>,
        <xudingke@huawei.com>, Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net-next] net: altera: Fix use correct return type for ndo_start_xmit()
Date:   Tue, 5 May 2020 11:06:45 +0800
Message-ID: <1588648005-84716-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.173.251.152]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

The method ndo_start_xmit() returns a value of type netdev_tx_t. Fix
the ndo function to use the correct type.

Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
---
 drivers/net/ethernet/altera/altera_tse_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index 1671c1f..907125a 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -554,7 +554,7 @@ static irqreturn_t altera_isr(int irq, void *dev_id)
  * physically contiguous fragment starting at
  * skb->data, for length of skb_headlen(skb).
  */
-static int tse_start_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t tse_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct altera_tse_private *priv = netdev_priv(dev);
 	unsigned int txsize = priv->tx_ring_size;
@@ -562,7 +562,7 @@ static int tse_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct tse_buffer *buffer = NULL;
 	int nfrags = skb_shinfo(skb)->nr_frags;
 	unsigned int nopaged_len = skb_headlen(skb);
-	enum netdev_tx ret = NETDEV_TX_OK;
+	netdev_tx_t ret = NETDEV_TX_OK;
 	dma_addr_t dma_addr;
 
 	spin_lock_bh(&priv->tx_lock);
-- 
1.8.3.1


