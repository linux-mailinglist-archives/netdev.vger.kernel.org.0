Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBF136C41C
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 12:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235133AbhD0Kfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 06:35:45 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:60266 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238407AbhD0KdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 06:33:14 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UWzqAtW_1619519543;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UWzqAtW_1619519543)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 27 Apr 2021 18:32:29 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     davem@davemloft.net, kuba@kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] net/smc: Remove redundant assignment to rc
Date:   Tue, 27 Apr 2021 18:32:22 +0800
Message-Id: <1619519542-62846-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable rc is set to zero but this value is never read as it is
overwritten with a new value later on, hence it is a redundant
assignment and can be removed.

Cleans up the following clang-analyzer warning:

net/smc/af_smc.c:1079:3: warning: Value stored to 'rc' is never read
[clang-analyzer-deadcode.DeadStores].

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 net/smc/af_smc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 47340b3..be3e80b 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1076,7 +1076,6 @@ static int smc_connect(struct socket *sock, struct sockaddr *addr,
 		rc = -EISCONN;
 		goto out;
 	case SMC_INIT:
-		rc = 0;
 		break;
 	}
 
-- 
1.8.3.1

