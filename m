Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1941D377124
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 12:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbhEHKEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 06:04:15 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:54086 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229869AbhEHKEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 06:04:11 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UY8aQ.Z_1620468187;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UY8aQ.Z_1620468187)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 08 May 2021 18:03:08 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, nathan@kernel.org, ndesaulniers@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] neighbour: Remove redundant initialization of 'bucket'
Date:   Sat,  8 May 2021 18:03:05 +0800
Message-Id: <1620468185-122101-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Integer variable 'bucket' is being initialized however
this value is never read as 'bucket' is assigned zero
in for statement. Remove the redundant assignment.

Cleans up clang warning:

net/core/neighbour.c:3144:6: warning: Value stored to 'bucket' during
its initialization is never read [clang-analyzer-deadcode.DeadStores]

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 net/core/neighbour.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 98f20efb..2b2f333 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -3141,7 +3141,7 @@ static struct pneigh_entry *pneigh_get_first(struct seq_file *seq)
 	struct net *net = seq_file_net(seq);
 	struct neigh_table *tbl = state->tbl;
 	struct pneigh_entry *pn = NULL;
-	int bucket = state->bucket;
+	int bucket;
 
 	state->flags |= NEIGH_SEQ_IS_PNEIGH;
 	for (bucket = 0; bucket <= PNEIGH_HASHMASK; bucket++) {
-- 
1.8.3.1

