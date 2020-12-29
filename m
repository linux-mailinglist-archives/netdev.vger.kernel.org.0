Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F282E7106
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 14:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbgL2NtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 08:49:19 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:10375 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbgL2NtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 08:49:18 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4D4whw0SMHz7KC4;
        Tue, 29 Dec 2020 21:47:44 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Tue, 29 Dec 2020 21:48:25 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <jmaloy@redhat.com>, <ying.xue@windriver.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <tipc-discussion@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: tipc: Replace expression with offsetof()
Date:   Tue, 29 Dec 2020 21:49:04 +0800
Message-ID: <20201229134904.23136-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the existing offsetof() macro instead of duplicating code.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/tipc/monitor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/monitor.c b/net/tipc/monitor.c
index 6dce2abf436e..48fac3b17e40 100644
--- a/net/tipc/monitor.c
+++ b/net/tipc/monitor.c
@@ -108,7 +108,7 @@ const int tipc_max_domain_size = sizeof(struct tipc_mon_domain);
  */
 static int dom_rec_len(struct tipc_mon_domain *dom, u16 mcnt)
 {
-	return ((void *)&dom->members - (void *)dom) + (mcnt * sizeof(u32));
+	return (offsetof(struct tipc_mon_domain, members)) + (mcnt * sizeof(u32));
 }
 
 /* dom_size() : calculate size of own domain based on number of peers
-- 
2.22.0

