Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77681C4CA1
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 05:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbgEEDWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 23:22:39 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3407 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726345AbgEEDWj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 23:22:39 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 782D667C833889C311CD;
        Tue,  5 May 2020 11:22:36 +0800 (CST)
Received: from localhost (10.173.251.152) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Tue, 5 May 2020
 11:22:21 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <jerry.lilijun@huawei.com>,
        <xudingke@huawei.com>, Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net-next] net: nxp: Fix use correct return type for ndo_start_xmit()
Date:   Tue, 5 May 2020 11:22:20 +0800
Message-ID: <1588648940-33028-1-git-send-email-wangyunjian@huawei.com>
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
 drivers/net/ethernet/nxp/lpc_eth.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index d20cf03..f41959f 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -1029,7 +1029,8 @@ static int lpc_eth_close(struct net_device *ndev)
 	return 0;
 }
 
-static int lpc_eth_hard_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+static netdev_tx_t lpc_eth_hard_start_xmit(struct sk_buff *skb,
+					   struct net_device *ndev)
 {
 	struct netdata_local *pldat = netdev_priv(ndev);
 	u32 len, txidx;
-- 
1.8.3.1


