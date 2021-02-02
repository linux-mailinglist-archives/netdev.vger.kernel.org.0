Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A954730BBF2
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 11:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhBBKSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 05:18:46 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:41281 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229835AbhBBKSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 05:18:44 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R821e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0UNfdAcH_1612261072;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UNfdAcH_1612261072)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 02 Feb 2021 18:17:59 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     boris.ostrovsky@oracle.com
Cc:     jgross@suse.com, sstabellini@kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] drivers: net: xen-netfront: Simplify the calculation of variables
Date:   Tue,  2 Feb 2021 18:17:49 +0800
Message-Id: <1612261069-13315-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warnings:

./drivers/net/xen-netfront.c:1816:52-54: WARNING !A || A && B is
equivalent to !A || B.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/xen-netfront.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index b01848e..5158841 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1813,7 +1813,7 @@ static int setup_netfront(struct xenbus_device *dev,
 	 *  a) feature-split-event-channels == 0
 	 *  b) feature-split-event-channels == 1 but failed to setup
 	 */
-	if (!feature_split_evtchn || (feature_split_evtchn && err))
+	if (!feature_split_evtchn || err)
 		err = setup_netfront_single(queue);
 
 	if (err)
-- 
1.8.3.1

