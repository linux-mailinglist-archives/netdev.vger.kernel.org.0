Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAB0E36D530
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 11:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238608AbhD1J7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 05:59:04 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:41646 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238345AbhD1J7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 05:59:03 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UX3IH4b_1619603887;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UX3IH4b_1619603887)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 28 Apr 2021 17:58:17 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     ralf@linux-mips.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] net: netrom: nr_in: Remove redundant assignment to ns
Date:   Wed, 28 Apr 2021 17:58:05 +0800
Message-Id: <1619603885-115604-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable ns is set to 'skb->data[17]' but this value is never read as
it is overwritten or not used later on, hence it is a redundant
assignment and can be removed.

Cleans up the following clang-analyzer warning:

net/netrom/nr_in.c:156:2: warning: Value stored to 'ns' is never read
[clang-analyzer-deadcode.DeadStores].

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 net/netrom/nr_in.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netrom/nr_in.c b/net/netrom/nr_in.c
index 69e5890..2f084b6 100644
--- a/net/netrom/nr_in.c
+++ b/net/netrom/nr_in.c
@@ -153,7 +153,6 @@ static int nr_state3_machine(struct sock *sk, struct sk_buff *skb, int frametype
 	int queued = 0;
 
 	nr = skb->data[18];
-	ns = skb->data[17];
 
 	switch (frametype) {
 	case NR_CONNREQ:
-- 
1.8.3.1

