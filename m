Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70B17248475
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 14:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbgHRMIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 08:08:36 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:9764 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726357AbgHRMIe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 08:08:34 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 472B2D419263F9D20B84;
        Tue, 18 Aug 2020 20:08:29 +0800 (CST)
Received: from huawei.com (10.175.104.175) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Tue, 18 Aug 2020
 20:08:18 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <jmaloy@redhat.com>, <ying.xue@windriver.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <tipc-discussion@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>, <linmiaohe@huawei.com>
Subject: [PATCH] net: tipc: Convert to use the preferred fallthrough macro
Date:   Tue, 18 Aug 2020 08:07:13 -0400
Message-ID: <20200818120713.25381-1-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.175]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the uses of fallthrough comments to fallthrough macro.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 net/tipc/bearer.c | 2 +-
 net/tipc/link.c   | 2 +-
 net/tipc/socket.c | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
index 808b147df7d5..650414110452 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -652,7 +652,7 @@ static int tipc_l2_device_event(struct notifier_block *nb, unsigned long evt,
 			test_and_set_bit_lock(0, &b->up);
 			break;
 		}
-		/* fall through */
+		fallthrough;
 	case NETDEV_GOING_DOWN:
 		clear_bit_unlock(0, &b->up);
 		tipc_reset_bearer(net, b);
diff --git a/net/tipc/link.c b/net/tipc/link.c
index 107578122973..b7362556da95 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -1239,7 +1239,7 @@ static bool tipc_data_input(struct tipc_link *l, struct sk_buff *skb,
 			skb_queue_tail(mc_inputq, skb);
 			return true;
 		}
-		/* fall through */
+		fallthrough;
 	case CONN_MANAGER:
 		skb_queue_tail(inputq, skb);
 		return true;
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 07419f36116a..2679e97e0389 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -783,7 +783,7 @@ static __poll_t tipc_poll(struct file *file, struct socket *sock,
 	case TIPC_ESTABLISHED:
 		if (!tsk->cong_link_cnt && !tsk_conn_cong(tsk))
 			revents |= EPOLLOUT;
-		/* fall through */
+		fallthrough;
 	case TIPC_LISTEN:
 	case TIPC_CONNECTING:
 		if (!skb_queue_empty_lockless(&sk->sk_receive_queue))
@@ -2597,7 +2597,7 @@ static int tipc_connect(struct socket *sock, struct sockaddr *dest,
 		 * case is EINPROGRESS, rather than EALREADY.
 		 */
 		res = -EINPROGRESS;
-		/* fall through */
+		fallthrough;
 	case TIPC_CONNECTING:
 		if (!timeout) {
 			if (previous == TIPC_CONNECTING)
-- 
2.19.1

