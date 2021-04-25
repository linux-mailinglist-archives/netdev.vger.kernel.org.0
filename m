Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2790436A6C2
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 12:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbhDYKno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 06:43:44 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:46850 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229551AbhDYKno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 06:43:44 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UWgU-OO_1619347377;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UWgU-OO_1619347377)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 25 Apr 2021 18:43:03 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] net: davicom: Remove redundant assignment to ret
Date:   Sun, 25 Apr 2021 18:42:56 +0800
Message-Id: <1619347376-56140-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable ret is set to zero but this value is never read as it is
overwritten with a new value later on, hence it is a redundant
assignment and can be removed.

Cleans up the following clang-analyzer warning:

drivers/net/ethernet/davicom/dm9000.c:1527:5: warning: Value stored to
'ret' is never read [clang-analyzer-deadcode.DeadStores].

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/ethernet/davicom/dm9000.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
index 8a9096a..e0c0349 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -1524,7 +1524,6 @@ static struct dm9000_plat_data *dm9000_parse_dt(struct device *dev)
 			if (ret) {
 				dev_err(db->dev, "irq %d cannot set wakeup (%d)\n",
 					db->irq_wake, ret);
-				ret = 0;
 			} else {
 				irq_set_irq_wake(db->irq_wake, 0);
 				db->wake_supported = 1;
-- 
1.8.3.1

