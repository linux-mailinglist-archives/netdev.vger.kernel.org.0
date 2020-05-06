Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFDA31C6F73
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 13:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgEFLi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 07:38:59 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3865 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725824AbgEFLi7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 07:38:59 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 1AE87B22D6E8466B42CE;
        Wed,  6 May 2020 19:38:57 +0800 (CST)
Received: from localhost (10.173.251.152) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Wed, 6 May 2020
 19:38:49 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <jerry.lilijun@huawei.com>,
        <xudingke@huawei.com>, Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net-next] net: lantiq: Fix use correct return type for ndo_start_xmit()
Date:   Wed, 6 May 2020 19:38:46 +0800
Message-ID: <1588765126-7812-1-git-send-email-wangyunjian@huawei.com>
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
 drivers/net/ethernet/lantiq_xrx200.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index 900affb..1645e4e 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -276,7 +276,8 @@ static int xrx200_tx_housekeeping(struct napi_struct *napi, int budget)
 	return pkts;
 }
 
-static int xrx200_start_xmit(struct sk_buff *skb, struct net_device *net_dev)
+static netdev_tx_t xrx200_start_xmit(struct sk_buff *skb,
+				     struct net_device *net_dev)
 {
 	struct xrx200_priv *priv = netdev_priv(net_dev);
 	struct xrx200_chan *ch = &priv->chan_tx;
-- 
1.8.3.1


