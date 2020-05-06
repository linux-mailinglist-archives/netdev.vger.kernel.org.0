Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5165D1C7006
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 14:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgEFMKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 08:10:40 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:59892 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727067AbgEFMKk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 08:10:40 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 94C5E4FE28293A2DF725;
        Wed,  6 May 2020 20:10:37 +0800 (CST)
Received: from localhost (10.173.251.152) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Wed, 6 May 2020
 20:10:28 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <jerry.lilijun@huawei.com>,
        <xudingke@huawei.com>, Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net-next] net: moxa: Fix use correct return type for ndo_start_xmit()
Date:   Wed, 6 May 2020 20:10:28 +0800
Message-ID: <1588767028-1672-1-git-send-email-wangyunjian@huawei.com>
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
 drivers/net/ethernet/moxa/moxart_ether.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/moxa/moxart_ether.c b/drivers/net/ethernet/moxa/moxart_ether.c
index e165175..1b25cc4 100644
--- a/drivers/net/ethernet/moxa/moxart_ether.c
+++ b/drivers/net/ethernet/moxa/moxart_ether.c
@@ -331,14 +331,15 @@ static irqreturn_t moxart_mac_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static int moxart_mac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+static netdev_tx_t moxart_mac_start_xmit(struct sk_buff *skb,
+					 struct net_device *ndev)
 {
 	struct moxart_mac_priv_t *priv = netdev_priv(ndev);
 	void *desc;
 	unsigned int len;
 	unsigned int tx_head;
 	u32 txdes1;
-	int ret = NETDEV_TX_BUSY;
+	netdev_tx_t ret = NETDEV_TX_BUSY;
 
 	spin_lock_irq(&priv->txlock);
 
-- 
1.8.3.1


