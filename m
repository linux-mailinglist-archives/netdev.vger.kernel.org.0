Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7B97590A91
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 05:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235268AbiHLDVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 23:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiHLDVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 23:21:31 -0400
Received: from out199-12.us.a.mail.aliyun.com (out199-12.us.a.mail.aliyun.com [47.90.199.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6952CA3448;
        Thu, 11 Aug 2022 20:21:28 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VM.yJQ7_1660274470;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VM.yJQ7_1660274470)
          by smtp.aliyun-inc.com;
          Fri, 12 Aug 2022 11:21:23 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     j.vosburgh@gmail.com
Cc:     vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] bonding: return -ENOMEM on rlb_initialize() allocation failure
Date:   Fri, 12 Aug 2022 11:20:59 +0800
Message-Id: <20220812032059.64572-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/bonding/bond_alb.c:861 rlb_initialize() warn: returning -1 instead of -ENOMEM is sloppy.

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=1896
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/bonding/bond_alb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 60cb9a0225aa..96cb4404b3c7 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -858,7 +858,7 @@ static int rlb_initialize(struct bonding *bond)
 
 	new_hashtbl = kmalloc(size, GFP_KERNEL);
 	if (!new_hashtbl)
-		return -1;
+		return -ENOMEM;
 
 	spin_lock_bh(&bond->mode_lock);
 
-- 
2.20.1.7.g153144c

