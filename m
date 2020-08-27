Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8709A25490C
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 17:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728486AbgH0PTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 11:19:39 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:10284 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728740AbgH0Led (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 07:34:33 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 53886F752459F2C1F3AB;
        Thu, 27 Aug 2020 19:17:10 +0800 (CST)
Received: from huawei.com (10.175.104.175) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Thu, 27 Aug 2020
 19:17:01 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linmiaohe@huawei.com>
Subject: [PATCH] net: Add 'else' to split mutually exclusive case
Date:   Thu, 27 Aug 2020 07:15:52 -0400
Message-ID: <20200827111552.38789-1-linmiaohe@huawei.com>
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

Add else to split mutually exclusive case and avoid unnecessary check.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 net/ipv4/ping.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 19a947bf0faa..265676fd2bbd 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -422,7 +422,7 @@ int ping_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	if (sk->sk_family == AF_INET && isk->inet_rcv_saddr)
 		sk->sk_userlocks |= SOCK_BINDADDR_LOCK;
 #if IS_ENABLED(CONFIG_IPV6)
-	if (sk->sk_family == AF_INET6 && !ipv6_addr_any(&sk->sk_v6_rcv_saddr))
+	else if (sk->sk_family == AF_INET6 && !ipv6_addr_any(&sk->sk_v6_rcv_saddr))
 		sk->sk_userlocks |= SOCK_BINDADDR_LOCK;
 #endif
 
-- 
2.19.1

