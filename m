Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7CF1BF6D1
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 13:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgD3L0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 07:26:54 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:57894 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726309AbgD3L0x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 07:26:53 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D1021175CEDB90FD2B05;
        Thu, 30 Apr 2020 19:26:51 +0800 (CST)
Received: from localhost (10.173.251.152) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Thu, 30 Apr 2020
 19:26:41 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <jerry.lilijun@huawei.com>,
        <xudingke@huawei.com>, Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net-next] rionet: Fix use correct return type for ndo_start_xmit()
Date:   Thu, 30 Apr 2020 19:26:40 +0800
Message-ID: <1588246000-37152-1-git-send-email-wangyunjian@huawei.com>
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
 drivers/net/rionet.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/rionet.c b/drivers/net/rionet.c
index 8eeb38c..2056d6a 100644
--- a/drivers/net/rionet.c
+++ b/drivers/net/rionet.c
@@ -166,7 +166,8 @@ static int rionet_queue_tx_msg(struct sk_buff *skb, struct net_device *ndev,
 	return 0;
 }
 
-static int rionet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+static netdev_tx_t rionet_start_xmit(struct sk_buff *skb,
+				     struct net_device *ndev)
 {
 	int i;
 	struct rionet_private *rnet = netdev_priv(ndev);
-- 
1.8.3.1


