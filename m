Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4431567F694
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 10:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232019AbjA1JEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 04:04:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbjA1JEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 04:04:35 -0500
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE8C36441;
        Sat, 28 Jan 2023 01:04:30 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R631e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VaH.HXv_1674896655;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VaH.HXv_1674896655)
          by smtp.aliyun-inc.com;
          Sat, 28 Jan 2023 17:04:28 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     michael.chan@broadcom.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] net: b44: Remove the unused function __b44_cam_read()
Date:   Sat, 28 Jan 2023 17:04:13 +0800
Message-Id: <20230128090413.79824-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function __b44_cam_read() is defined in the b44.c file, but not called
elsewhere, so remove this unused function.

drivers/net/ethernet/broadcom/b44.c:199:20: warning: unused function '__b44_cam_read'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3858
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/ethernet/broadcom/b44.c | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/broadcom/b44.c
index b751dc8486dc..392ec09a1d8a 100644
--- a/drivers/net/ethernet/broadcom/b44.c
+++ b/drivers/net/ethernet/broadcom/b44.c
@@ -196,28 +196,6 @@ static int b44_wait_bit(struct b44 *bp, unsigned long reg,
 	return 0;
 }
 
-static inline void __b44_cam_read(struct b44 *bp, unsigned char *data, int index)
-{
-	u32 val;
-
-	bw32(bp, B44_CAM_CTRL, (CAM_CTRL_READ |
-			    (index << CAM_CTRL_INDEX_SHIFT)));
-
-	b44_wait_bit(bp, B44_CAM_CTRL, CAM_CTRL_BUSY, 100, 1);
-
-	val = br32(bp, B44_CAM_DATA_LO);
-
-	data[2] = (val >> 24) & 0xFF;
-	data[3] = (val >> 16) & 0xFF;
-	data[4] = (val >> 8) & 0xFF;
-	data[5] = (val >> 0) & 0xFF;
-
-	val = br32(bp, B44_CAM_DATA_HI);
-
-	data[0] = (val >> 8) & 0xFF;
-	data[1] = (val >> 0) & 0xFF;
-}
-
 static inline void __b44_cam_write(struct b44 *bp,
 				   const unsigned char *data, int index)
 {
-- 
2.20.1.7.g153144c

