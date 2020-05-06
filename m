Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D06D1C7120
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 14:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728856AbgEFM4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 08:56:20 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3869 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728855AbgEFM4T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 08:56:19 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id F16146EFEB742B0604A7;
        Wed,  6 May 2020 20:55:59 +0800 (CST)
Received: from localhost (10.173.251.152) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Wed, 6 May 2020
 20:55:53 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <jerry.lilijun@huawei.com>,
        <xudingke@huawei.com>, Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net-next] net: 7990: Fix use correct return type for ndo_start_xmit()
Date:   Wed, 6 May 2020 20:55:52 +0800
Message-ID: <1588769752-5200-1-git-send-email-wangyunjian@huawei.com>
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
 drivers/net/ethernet/amd/7990.c | 2 +-
 drivers/net/ethernet/amd/7990.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/7990.c b/drivers/net/ethernet/amd/7990.c
index cf3562e8..50fb663 100644
--- a/drivers/net/ethernet/amd/7990.c
+++ b/drivers/net/ethernet/amd/7990.c
@@ -536,7 +536,7 @@ void lance_tx_timeout(struct net_device *dev, unsigned int txqueue)
 }
 EXPORT_SYMBOL_GPL(lance_tx_timeout);
 
-int lance_start_xmit(struct sk_buff *skb, struct net_device *dev)
+netdev_tx_t lance_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct lance_private *lp = netdev_priv(dev);
 	volatile struct lance_init_block *ib = lp->init_block;
diff --git a/drivers/net/ethernet/amd/7990.h b/drivers/net/ethernet/amd/7990.h
index 8266b3c..e53551d 100644
--- a/drivers/net/ethernet/amd/7990.h
+++ b/drivers/net/ethernet/amd/7990.h
@@ -241,7 +241,7 @@ struct lance_private {
 /* Now the prototypes we export */
 int lance_open(struct net_device *dev);
 int lance_close(struct net_device *dev);
-int lance_start_xmit(struct sk_buff *skb, struct net_device *dev);
+netdev_tx_t lance_start_xmit(struct sk_buff *skb, struct net_device *dev);
 void lance_set_multicast(struct net_device *dev);
 void lance_tx_timeout(struct net_device *dev, unsigned int txqueue);
 #ifdef CONFIG_NET_POLL_CONTROLLER
-- 
1.8.3.1


