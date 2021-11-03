Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E89D64441E1
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 13:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231607AbhKCMv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 08:51:57 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:33412 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230435AbhKCMv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 08:51:57 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R621e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UuvF03H_1635943758;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0UuvF03H_1635943758)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 03 Nov 2021 20:49:19 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, guwen@linux.alibaba.com,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH net-next] net/smc: Print function name in smcr_link_down tracepoint
Date:   Wed,  3 Nov 2021 20:48:37 +0800
Message-Id: <20211103124836.63180-1-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This makes the output of smcr_link_down tracepoint easier to use and
understand without additional translating function's pointer address.

It prints the function name with offset:

  <idle>-0       [000] ..s.    69.087164: smcr_link_down: lnk=00000000dab41cdc lgr=000000007d5d8e24 state=0 rc=1 dev=mlx5_0 location=smc_wr_tx_tasklet_fn+0x5ef/0x6f0 [smc]

Link: https://lore.kernel.org/netdev/11f17a34-fd35-f2ec-3f20-dd0c34e55fde@linux.ibm.com/
Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
Reviewed-by: Wen Gu <guwen@linux.alibaba.com>
---
 net/smc/smc_tracepoint.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/smc/smc_tracepoint.h b/net/smc/smc_tracepoint.h
index b4c36795a928..ec17f29646f5 100644
--- a/net/smc/smc_tracepoint.h
+++ b/net/smc/smc_tracepoint.h
@@ -99,7 +99,7 @@ TRACE_EVENT(smcr_link_down,
 			   __entry->location = location;
 	    ),
 
-	    TP_printk("lnk=%p lgr=%p state=%d dev=%s location=%p",
+	    TP_printk("lnk=%p lgr=%p state=%d dev=%s location=%pS",
 		      __entry->lnk, __entry->lgr,
 		      __entry->state, __get_str(name),
 		      __entry->location)
-- 
2.19.1.6.gb485710b

