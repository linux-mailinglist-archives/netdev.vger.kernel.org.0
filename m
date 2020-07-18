Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8981D224B3E
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 14:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgGRMzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 08:55:11 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7782 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726532AbgGRMzL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Jul 2020 08:55:11 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 28884130209C09D2155B;
        Sat, 18 Jul 2020 20:55:07 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Sat, 18 Jul 2020
 20:55:01 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ap420073@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] net: hsr: remove redundant null check
Date:   Sat, 18 Jul 2020 20:53:38 +0800
Message-ID: <20200718125338.52424-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because kfree_skb already checked NULL skb parameter,
so the additional checks are unnecessary, just remove them.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 net/hsr/hsr_forward.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index ed13760463de..92c8ad75200b 100644
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
2.17.1

