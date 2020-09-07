Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D618F2601E6
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 19:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731182AbgIGRO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 13:14:27 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:52550 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729772AbgIGOO4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 10:14:56 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 97629845ECC8F70CA9D2;
        Mon,  7 Sep 2020 22:14:46 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Mon, 7 Sep 2020
 22:14:43 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <f.fainelli@gmail.com>,
        <timur@kernel.org>, <zhengdejin5@gmail.com>,
        <hkallweit1@gmail.com>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: ethernet: dnet: Remove set but unused variable 'len'
Date:   Mon, 7 Sep 2020 22:12:07 +0800
Message-ID: <20200907141207.11778-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/ethernet/dnet.c: In function dnet_start_xmit
drivers/net/ethernet/dnet.c:511:15: warning: variable ‘len’ set but not used [-Wunused-but-set-variable]

commit 4796417417a6 ("dnet: Dave DNET ethernet controller driver (updated)")
involved this unused variable, remove it.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/ethernet/dnet.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/dnet.c b/drivers/net/ethernet/dnet.c
index db98274501a0..3143df9a398c 100644
--- a/drivers/net/ethernet/dnet.c
+++ b/drivers/net/ethernet/dnet.c
@@ -508,7 +508,7 @@ static netdev_tx_t dnet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	struct dnet *bp = netdev_priv(dev);
 	u32 tx_status, irq_enable;
-	unsigned int len, i, tx_cmd, wrsz;
+	unsigned int i, tx_cmd, wrsz;
 	unsigned long flags;
 	unsigned int *bufp;
 
@@ -518,9 +518,6 @@ static netdev_tx_t dnet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	       skb->len, skb->head, skb->data);
 	dnet_print_skb(skb);
 
-	/* frame size (words) */
-	len = (skb->len + 3) >> 2;
-
 	spin_lock_irqsave(&bp->lock, flags);
 
 	tx_status = dnet_readl(bp, TX_STATUS);
-- 
2.17.1

