Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C2E1BF522
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 12:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbgD3KQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 06:16:36 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3400 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726420AbgD3KQf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 06:16:35 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 91565B6187D2177EE2DC;
        Thu, 30 Apr 2020 18:16:32 +0800 (CST)
Received: from localhost (10.173.251.152) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Thu, 30 Apr 2020
 18:16:21 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <jerry.lilijun@huawei.com>,
        <xudingke@huawei.com>, Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net-next] net: caif: Fix use correct return type for ndo_start_xmit()
Date:   Thu, 30 Apr 2020 18:16:16 +0800
Message-ID: <1588241776-35896-1-git-send-email-wangyunjian@huawei.com>
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
 net/caif/chnl_net.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/caif/chnl_net.c b/net/caif/chnl_net.c
index a566289..79b6a04 100644
--- a/net/caif/chnl_net.c
+++ b/net/caif/chnl_net.c
@@ -211,7 +211,8 @@ static void chnl_flowctrl_cb(struct cflayer *layr, enum caif_ctrlcmd flow,
 	}
 }
 
-static int chnl_net_start_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t chnl_net_start_xmit(struct sk_buff *skb,
+				       struct net_device *dev)
 {
 	struct chnl_net *priv;
 	struct cfpkt *pkt = NULL;
-- 
1.8.3.1


