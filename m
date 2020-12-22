Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C42212E0ADB
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 14:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727676AbgLVNeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 08:34:25 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9237 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbgLVNeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 08:34:24 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4D0chv1ZJbzkWrN;
        Tue, 22 Dec 2020 21:32:47 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Tue, 22 Dec 2020 21:33:32 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <jmaloy@redhat.com>, <ying.xue@windriver.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <tipc-discussion@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: tipc: Replace expression with offsetof()
Date:   Tue, 22 Dec 2020 21:34:07 +0800
Message-ID: <20201222133407.19861-1-zhengyongjun3@huawei.com>
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

