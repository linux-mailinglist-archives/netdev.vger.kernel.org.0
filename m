Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E96AC1BDD8E
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 15:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgD2N0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 09:26:43 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:50006 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726669AbgD2N0m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 09:26:42 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 57ED0A9850F2DA043BC5;
        Wed, 29 Apr 2020 21:26:35 +0800 (CST)
Received: from localhost (10.166.215.154) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Wed, 29 Apr 2020
 21:26:26 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <ubraun@linux.ibm.com>, <kgraul@linux.ibm.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <yuehaibing@huawei.com>
CC:     <linux-s390@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net/smc: remove unused inline function smc_curs_read
Date:   Wed, 29 Apr 2020 21:26:23 +0800
Message-ID: <20200429132623.48608-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.166.215.154]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit bac6de7b6370 ("net/smc: eliminate cursor read and write calls")
left behind this.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/smc/smc_cdc.h | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/net/smc/smc_cdc.h b/net/smc/smc_cdc.h
index 861dc24c588c..5a19e5e2280e 100644
--- a/net/smc/smc_cdc.h
+++ b/net/smc/smc_cdc.h
@@ -97,23 +97,6 @@ static inline void smc_curs_add(int size, union smc_host_cursor *curs,
 	}
 }
 
-/* SMC cursors are 8 bytes long and require atomic reading and writing */
-static inline u64 smc_curs_read(union smc_host_cursor *curs,
-				struct smc_connection *conn)
-{
-#ifndef KERNEL_HAS_ATOMIC64
-	unsigned long flags;
-	u64 ret;
-
-	spin_lock_irqsave(&conn->acurs_lock, flags);
-	ret = curs->acurs;
-	spin_unlock_irqrestore(&conn->acurs_lock, flags);
-	return ret;
-#else
-	return atomic64_read(&curs->acurs);
-#endif
-}
-
 /* Copy cursor src into tgt */
 static inline void smc_curs_copy(union smc_host_cursor *tgt,
 				 union smc_host_cursor *src,
-- 
2.17.1


