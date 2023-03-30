Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 065E96CF917
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 04:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjC3CSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 22:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjC3CSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 22:18:54 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3832349ED;
        Wed, 29 Mar 2023 19:18:53 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R411e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VeyhhZG_1680142724;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VeyhhZG_1680142724)
          by smtp.aliyun-inc.com;
          Thu, 30 Mar 2023 10:18:50 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     Larry.Finger@lwfinger.net
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] b43legacy: Remove the unused function prev_slot()
Date:   Thu, 30 Mar 2023 10:18:41 +0800
Message-Id: <20230330021841.67724-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function prev_slot is defined in the dma.c file, but not called
elsewhere, so remove this unused function.

drivers/net/wireless/broadcom/b43legacy/dma.c:130:19: warning: unused function 'prev_slot'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4642
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/wireless/broadcom/b43legacy/dma.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43legacy/dma.c b/drivers/net/wireless/broadcom/b43legacy/dma.c
index 6869f2bf1bae..60e41de72f29 100644
--- a/drivers/net/wireless/broadcom/b43legacy/dma.c
+++ b/drivers/net/wireless/broadcom/b43legacy/dma.c
@@ -127,14 +127,6 @@ static inline int next_slot(struct b43legacy_dmaring *ring, int slot)
 	return slot + 1;
 }
 
-static inline int prev_slot(struct b43legacy_dmaring *ring, int slot)
-{
-	B43legacy_WARN_ON(!(slot >= 0 && slot <= ring->nr_slots - 1));
-	if (slot == 0)
-		return ring->nr_slots - 1;
-	return slot - 1;
-}
-
 #ifdef CONFIG_B43LEGACY_DEBUG
 static void update_max_used_slots(struct b43legacy_dmaring *ring,
 				  int current_used_slots)
-- 
2.20.1.7.g153144c

