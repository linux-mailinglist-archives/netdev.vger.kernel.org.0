Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C06459DEF
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 09:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234722AbhKWI24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 03:28:56 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:49202 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231240AbhKWI2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 03:28:55 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UxwCppt_1637655945;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0UxwCppt_1637655945)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 23 Nov 2021 16:25:45 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, guwen@linux.alibaba.com,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH net 1/2] net/smc: Clean up local struct sock variables
Date:   Tue, 23 Nov 2021 16:25:16 +0800
Message-Id: <20211123082515.65956-2-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211123082515.65956-1-tonylu@linux.alibaba.com>
References: <20211123082515.65956-1-tonylu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There remains some variables to replace with local struct sock. So clean
them up all.

Fixes: 3163c5071f25 ("net/smc: use local struct sock variables consistently")
Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
Reviewed-by: Wen Gu <guwen@linux.alibaba.com>
---
 net/smc/smc_close.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
index 0f9ffba07d26..9b235fbb089a 100644
--- a/net/smc/smc_close.c
+++ b/net/smc/smc_close.c
@@ -354,9 +354,9 @@ static void smc_close_passive_work(struct work_struct *work)
 	if (rxflags->peer_conn_abort) {
 		/* peer has not received all data */
 		smc_close_passive_abort_received(smc);
-		release_sock(&smc->sk);
+		release_sock(sk);
 		cancel_delayed_work_sync(&conn->tx_work);
-		lock_sock(&smc->sk);
+		lock_sock(sk);
 		goto wakeup;
 	}
 
-- 
2.32.0.3.g01195cf9f

