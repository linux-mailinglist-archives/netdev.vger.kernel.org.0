Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF2C023A75C
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 15:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgHCNUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 09:20:31 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8751 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725948AbgHCNUb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 09:20:31 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 3A3FB65EF7DEDF839AB2;
        Mon,  3 Aug 2020 21:20:27 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Mon, 3 Aug 2020
 21:20:20 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <brianvv@google.com>,
        <rdunlap@infradead.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] fib: Fix undef compile warning
Date:   Mon, 3 Aug 2020 21:19:48 +0800
Message-ID: <20200803131948.41736-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net/core/fib_rules.c:26:7: warning: "CONFIG_IP_MULTIPLE_TABLES" is not defined, evaluates to 0 [-Wundef]
 #elif CONFIG_IP_MULTIPLE_TABLES
       ^~~~~~~~~~~~~~~~~~~~~~~~~

Fixes: 8b66a6fd34f5 ("fib: fix another fib_rules_ops indirect call wrapper problem")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/core/fib_rules.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index a7a3f500a857..51678a528f85 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -23,7 +23,7 @@
 #else
 #define INDIRECT_CALL_MT(f, f2, f1, ...) INDIRECT_CALL_1(f, f2, __VA_ARGS__)
 #endif
-#elif CONFIG_IP_MULTIPLE_TABLES
+#elif defined(CONFIG_IP_MULTIPLE_TABLES)
 #define INDIRECT_CALL_MT(f, f2, f1, ...) INDIRECT_CALL_1(f, f1, __VA_ARGS__)
 #else
 #define INDIRECT_CALL_MT(f, f2, f1, ...) f(__VA_ARGS__)
-- 
2.17.1


