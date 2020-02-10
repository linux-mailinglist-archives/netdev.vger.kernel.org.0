Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3459615709A
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 09:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbgBJINV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 03:13:21 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:10607 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727892AbgBJINU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Feb 2020 03:13:20 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 75685F55FB316096A9D4;
        Mon, 10 Feb 2020 16:13:18 +0800 (CST)
Received: from euler.huawei.com (10.175.104.193) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Mon, 10 Feb 2020 16:13:12 +0800
From:   Chen Wandun <chenwandun@huawei.com>
To:     <mathew.j.martineau@linux.intel.com>,
        <matthieu.baerts@tessares.net>, <davem@davemloft.net>,
        <kuba@kernel.org>, <fw@strlen.de>, <netdev@vger.kernel.org>,
        <mptcp@lists.01.org>, <linux-kernel@vger.kernel.org>
CC:     <chenwandun@huawei.com>
Subject: [PATCH next] mptcp: make the symbol 'mptcp_sk_clone_lock' static
Date:   Mon, 10 Feb 2020 16:27:59 +0800
Message-ID: <20200210082759.12157-1-chenwandun@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.104.193]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following sparse warning:
net/mptcp/protocol.c:646:13: warning: symbol 'mptcp_sk_clone_lock' was not declared. Should it be static?

Fixes: b0519de8b3f1 ("mptcp: fix use-after-free for ipv6")
Signed-off-by: Chen Wandun <chenwandun@huawei.com>
---
 net/mptcp/protocol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 73780b4cb108..030dee668e0a 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -643,7 +643,7 @@ static struct ipv6_pinfo *mptcp_inet6_sk(const struct sock *sk)
 }
 #endif
 
-struct sock *mptcp_sk_clone_lock(const struct sock *sk)
+static struct sock *mptcp_sk_clone_lock(const struct sock *sk)
 {
 	struct sock *nsk = sk_clone_lock(sk, GFP_ATOMIC);
 
-- 
2.17.1

