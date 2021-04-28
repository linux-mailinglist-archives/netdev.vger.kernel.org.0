Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4339036D52D
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 11:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238487AbhD1J6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 05:58:22 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:43109 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238401AbhD1J6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 05:58:21 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UX3sbaj_1619603854;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UX3sbaj_1619603854)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 28 Apr 2021 17:57:35 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, nathan@kernel.org, ndesaulniers@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] net: tun: Remove redundant assignment to ret
Date:   Wed, 28 Apr 2021 17:57:32 +0800
Message-Id: <1619603852-114996-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable 'ret' is set to zero but this value is never read as it is
overwritten with a new value later on, hence it is a redundant
assignment and can be removed.

Cleans up the following clang-analyzer warning:

drivers/net/tun.c:3008:2: warning: Value stored to 'ret' is never read
[clang-analyzer-deadcode.DeadStores]

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/tun.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 4cf38be..d92c11a 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3005,7 +3005,6 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 		return open_related_ns(&net->ns, get_net_ns);
 	}
 
-	ret = 0;
 	rtnl_lock();
 
 	tun = tun_get(tfile);
-- 
1.8.3.1

