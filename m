Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBFE336CF4
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 08:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbhCKHLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 02:11:33 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:52660 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232056AbhCKHLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 02:11:12 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R891e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0URQUgGY_1615446664;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0URQUgGY_1615446664)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 11 Mar 2021 15:11:10 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH v2] netdevsim: fib: Remove redundant code
Date:   Thu, 11 Mar 2021 15:11:01 +0800
Message-Id: <1615446661-67765-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warnings:

./drivers/net/netdevsim/fib.c:874:5-8: Unneeded variable: "err". Return
"0" on line 889.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
Changes in v2:
  - Modify the function type to void.

 drivers/net/netdevsim/fib.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index 46fb414..3ca0f54 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -869,10 +869,8 @@ static int nsim_fib6_event(struct nsim_fib_data *data,
 	return err;
 }
 
-static int nsim_fib_event(struct nsim_fib_event *fib_event)
+static void nsim_fib_event(struct nsim_fib_event *fib_event)
 {
-	int err = 0;
-
 	switch (fib_event->family) {
 	case AF_INET:
 		nsim_fib4_event(fib_event->data, &fib_event->fen_info,
@@ -885,8 +883,6 @@ static int nsim_fib_event(struct nsim_fib_event *fib_event)
 		nsim_fib6_event_fini(&fib_event->fib6_event);
 		break;
 	}
-
-	return err;
 }
 
 static int nsim_fib4_prepare_event(struct fib_notifier_info *info,
-- 
1.8.3.1

