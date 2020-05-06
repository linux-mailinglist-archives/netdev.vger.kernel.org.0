Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D54701C67EF
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 08:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgEFGLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 02:11:01 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:49118 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725782AbgEFGLB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 02:11:01 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id ABF153D0F29B18E021BA;
        Wed,  6 May 2020 14:10:51 +0800 (CST)
Received: from localhost (10.173.251.152) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Wed, 6 May 2020
 14:10:42 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <jerry.lilijun@huawei.com>,
        <xudingke@huawei.com>, Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net-next] net: cortina: Fix use correct return type for ndo_start_xmit()
Date:   Wed, 6 May 2020 14:10:41 +0800
Message-ID: <1588745441-90324-1-git-send-email-wangyunjian@huawei.com>
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
 drivers/net/ethernet/cortina/gemini.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 5bff5c2..8d13ea3 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1224,7 +1224,8 @@ static int gmac_map_tx_bufs(struct net_device *netdev, struct sk_buff *skb,
 	return -ENOMEM;
 }
 
-static int gmac_start_xmit(struct sk_buff *skb, struct net_device *netdev)
+static netdev_tx_t gmac_start_xmit(struct sk_buff *skb,
+				   struct net_device *netdev)
 {
 	struct gemini_ethernet_port *port = netdev_priv(netdev);
 	unsigned short m = (1 << port->txq_order) - 1;
-- 
1.8.3.1


