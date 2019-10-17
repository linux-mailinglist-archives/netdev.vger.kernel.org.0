Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98443DAA24
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 12:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404981AbfJQKhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 06:37:21 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4239 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727268AbfJQKhU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 06:37:20 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 83CE2B9B9276EA885477;
        Thu, 17 Oct 2019 18:37:12 +0800 (CST)
Received: from localhost.localdomain (10.67.212.75) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.439.0; Thu, 17 Oct 2019 18:37:02 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>
CC:     <tglx@linutronix.de>, <peterz@infradead.org>, <fw@strlen.de>,
        <bigeasy@linutronix.de>, <pabeni@redhat.com>,
        <jonathan.lemon@gmail.com>, <anshuman.khandual@arm.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH net-next] pktgen: remove unnecessary assignment in pktgen_xmit()
Date:   Thu, 17 Oct 2019 18:34:13 +0800
Message-ID: <1571308453-213479-1-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.75]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

variable ret is not used after jumping to "unlock" label, so
the assignment is redundant.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 net/core/pktgen.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 48b1e42..294bfcf 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -3404,7 +3404,6 @@ static void pktgen_xmit(struct pktgen_dev *pkt_dev)
 	HARD_TX_LOCK(odev, txq, smp_processor_id());
 
 	if (unlikely(netif_xmit_frozen_or_drv_stopped(txq))) {
-		ret = NETDEV_TX_BUSY;
 		pkt_dev->last_ok = 0;
 		goto unlock;
 	}
-- 
2.8.1

