Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8891C6CCC
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 11:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728879AbgEFJZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 05:25:28 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:45586 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728559AbgEFJZ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 05:25:27 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 693487915A09C7496414;
        Wed,  6 May 2020 17:25:25 +0800 (CST)
Received: from localhost (10.173.251.152) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Wed, 6 May 2020
 17:25:15 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <jerry.lilijun@huawei.com>,
        <xudingke@huawei.com>, Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net-next] net: renesas: Fix use correct return type for ndo_start_xmit()
Date:   Wed, 6 May 2020 17:25:14 +0800
Message-ID: <1588757114-12652-1-git-send-email-wangyunjian@huawei.com>
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
 drivers/net/ethernet/renesas/sh_eth.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 8ed73f4..f45331e 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2472,7 +2472,8 @@ static void sh_eth_tx_timeout(struct net_device *ndev, unsigned int txqueue)
 }
 
 /* Packet transmit function */
-static int sh_eth_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+static netdev_tx_t sh_eth_start_xmit(struct sk_buff *skb,
+				     struct net_device *ndev)
 {
 	struct sh_eth_private *mdp = netdev_priv(ndev);
 	struct sh_eth_txdesc *txdesc;
-- 
1.8.3.1


