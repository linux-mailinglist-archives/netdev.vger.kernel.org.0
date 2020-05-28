Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F551E58E6
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 09:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgE1Hj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 03:39:28 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5297 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725839AbgE1Hj2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 03:39:28 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 91F35AA34D5E91D3E78B;
        Thu, 28 May 2020 15:39:25 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Thu, 28 May 2020 15:39:18 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
CC:     YueHaibing <yuehaibing@huawei.com>, <netdev@vger.kernel.org>,
        <tipc-discussion@lists.sourceforge.net>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next] tipc: remove set but not used variable 'prev'
Date:   Thu, 28 May 2020 07:43:59 +0000
Message-ID: <20200528074359.116680-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

net/tipc/msg.c: In function 'tipc_msg_append':
net/tipc/msg.c:215:24: warning:
 variable 'prev' set but not used [-Wunused-but-set-variable]

commit 0a3e060f340d ("tipc: add test for Nagle algorithm effectiveness")
left behind this, remove it.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/tipc/msg.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/tipc/msg.c b/net/tipc/msg.c
index 23809039dda1..c0afcd627c5e 100644
--- a/net/tipc/msg.c
+++ b/net/tipc/msg.c
@@ -212,7 +212,7 @@ int tipc_buf_append(struct sk_buff **headbuf, struct sk_buff **buf)
 int tipc_msg_append(struct tipc_msg *_hdr, struct msghdr *m, int dlen,
 		    int mss, struct sk_buff_head *txq)
 {
-	struct sk_buff *skb, *prev;
+	struct sk_buff *skb;
 	int accounted, total, curr;
 	int mlen, cpy, rem = dlen;
 	struct tipc_msg *hdr;
@@ -223,7 +223,6 @@ int tipc_msg_append(struct tipc_msg *_hdr, struct msghdr *m, int dlen,
 
 	while (rem) {
 		if (!skb || skb->len >= mss) {
-			prev = skb;
 			skb = tipc_buf_acquire(mss, GFP_KERNEL);
 			if (unlikely(!skb))
 				return -ENOMEM;



