Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7F98A792A
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 05:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbfIDDMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 23:12:21 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5750 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727709AbfIDDMV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 23:12:21 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 9368273DDC4D110DB424;
        Wed,  4 Sep 2019 11:12:18 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Wed, 4 Sep 2019 11:12:12 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <davem@davemloft.net>, <arvid.brodin@alten.se>
CC:     <zhongjiang@huawei.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: hsr: remove an redundant null check before kfree_skb
Date:   Wed, 4 Sep 2019 11:09:18 +0800
Message-ID: <1567566558-7764-1-git-send-email-zhongjiang@huawei.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kfree_skb has taken the null pointer into account. Hence just remove
the null check before kfree_skb.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 net/hsr/hsr_forward.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index ddd9605..0c9e5b0 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -367,10 +367,8 @@ void hsr_forward_skb(struct sk_buff *skb, struct hsr_port *port)
 		port->dev->stats.tx_bytes += skb->len;
 	}
 
-	if (frame.skb_hsr)
-		kfree_skb(frame.skb_hsr);
-	if (frame.skb_std)
-		kfree_skb(frame.skb_std);
+	kfree_skb(frame.skb_hsr);
+	kfree_skb(frame.skb_std);
 	return;
 
 out_drop:
-- 
1.7.12.4

