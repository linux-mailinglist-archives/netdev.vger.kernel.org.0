Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 450E336B14E
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 12:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232957AbhDZKLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 06:11:40 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:48872 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232178AbhDZKLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 06:11:39 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R891e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UWpp.OX_1619431850;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UWpp.OX_1619431850)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 26 Apr 2021 18:10:57 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] caif: Remove redundant variable expectlen
Date:   Mon, 26 Apr 2021 18:10:49 +0800
Message-Id: <1619431849-85597-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable expectlen is being assigned a value from a calculation
however the variable is never read, so this redundant variable
can be removed.

Cleans up the following clang-analyzer warning:

net/caif/cfserl.c:126:5: warning: Value stored to 'expectlen' is never
read [clang-analyzer-deadcode.DeadStores].

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 net/caif/cfserl.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/caif/cfserl.c b/net/caif/cfserl.c
index e11725a..fef72e6 100644
--- a/net/caif/cfserl.c
+++ b/net/caif/cfserl.c
@@ -123,7 +123,6 @@ static int cfserl_receive(struct cflayer *l, struct cfpkt *newpkt)
 				if (pkt != NULL)
 					cfpkt_destroy(pkt);
 				layr->incomplete_frm = NULL;
-				expectlen = 0;
 				spin_unlock(&layr->sync);
 				return -EPROTO;
 			}
-- 
1.8.3.1

