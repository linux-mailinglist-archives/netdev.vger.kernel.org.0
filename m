Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 985273B829
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 17:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391118AbfFJPUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 11:20:06 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:18121 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390367AbfFJPUG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 11:20:06 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 75CD99FD8F804A894B66;
        Mon, 10 Jun 2019 23:19:56 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Mon, 10 Jun 2019
 23:19:46 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <edumazet@google.com>, <davem@davemloft.net>,
        <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>,
        <jbaron@akamai.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] tcp: Make tcp_fastopen_alloc_ctx static
Date:   Mon, 10 Jun 2019 23:19:08 +0800
Message-ID: <20190610151908.23116-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix sparse warning:

net/ipv4/tcp_fastopen.c:75:29: warning:
 symbol 'tcp_fastopen_alloc_ctx' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/ipv4/tcp_fastopen.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index 8e15804..7d19fa4 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -72,9 +72,9 @@ void tcp_fastopen_ctx_destroy(struct net *net)
 		call_rcu(&ctxt->rcu, tcp_fastopen_ctx_free);
 }
 
-struct tcp_fastopen_context *tcp_fastopen_alloc_ctx(void *primary_key,
-						    void *backup_key,
-						    unsigned int len)
+static struct tcp_fastopen_context *tcp_fastopen_alloc_ctx(void *primary_key,
+							   void *backup_key,
+							   unsigned int len)
 {
 	struct tcp_fastopen_context *new_ctx;
 	void *key = primary_key;
-- 
2.7.4


