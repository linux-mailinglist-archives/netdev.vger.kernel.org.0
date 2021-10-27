Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2113143C598
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 10:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241059AbhJ0IzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 04:55:11 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:37648 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241052AbhJ0IzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 04:55:09 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R291e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0Uts5tnL_1635324761;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0Uts5tnL_1635324761)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 27 Oct 2021 16:52:42 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        ubraun@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, jacob.qi@linux.alibaba.com,
        xuanzhuo@linux.alibaba.com, guwen@linux.alibaba.com,
        dust.li@linux.alibaba.com
Subject: [PATCH net 3/4] net/smc: Correct spelling mistake to TCPF_SYN_RECV
Date:   Wed, 27 Oct 2021 16:52:09 +0800
Message-Id: <20211027085208.16048-4-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211027085208.16048-1-tonylu@linux.alibaba.com>
References: <20211027085208.16048-1-tonylu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wen Gu <guwen@linux.alibaba.com>

There should use TCPF_SYN_RECV instead of TCP_SYN_RECV.

Fixes: 50717a37db03 ("net/smc: nonblocking connect rework")
Cc: Ursula Braun <ubraun@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
Reviewed-by: Tony Lu <tony.ly@linux.alibaba.com>
---
 net/smc/af_smc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index c038efc23ce3..78b663dbfa1f 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1057,7 +1057,7 @@ static void smc_connect_work(struct work_struct *work)
 	if (smc->clcsock->sk->sk_err) {
 		smc->sk.sk_err = smc->clcsock->sk->sk_err;
 	} else if ((1 << smc->clcsock->sk->sk_state) &
-					(TCPF_SYN_SENT | TCP_SYN_RECV)) {
+					(TCPF_SYN_SENT | TCPF_SYN_RECV)) {
 		rc = sk_stream_wait_connect(smc->clcsock->sk, &timeo);
 		if ((rc == -EPIPE) &&
 		    ((1 << smc->clcsock->sk->sk_state) &
-- 
2.19.1.6.gb485710b

