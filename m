Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375186973C7
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 02:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233255AbjBOBlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 20:41:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232720AbjBOBlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 20:41:06 -0500
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B48D02ED57;
        Tue, 14 Feb 2023 17:41:04 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VbhioS7_1676425261;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0VbhioS7_1676425261)
          by smtp.aliyun-inc.com;
          Wed, 15 Feb 2023 09:41:02 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, kvalo@kernel.org, edumazet@google.com,
        pabeni@redhat.com, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] wifi: ath10k: Remove the unused function shadow_dst_wr_ind_addr() and ath10k_ce_error_intr_enable()
Date:   Wed, 15 Feb 2023 09:40:58 +0800
Message-Id: <20230215014058.116775-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function shadow_dst_wr_ind_addr() and ath10k_ce_error_intr_enable()
are defined in the ce.c file, the code calling them has been removed,
so remove these unused functions.

Eliminate the following warnings:
drivers/net/wireless/ath/ath10k/ce.c:80:19: warning: unused function 'shadow_dst_wr_ind_addr'
drivers/net/wireless/ath/ath10k/ce.c:441:20: warning: unused function 'ath10k_ce_error_intr_enable'

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4063
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/wireless/ath/ath10k/ce.c | 52 ----------------------------
 1 file changed, 52 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index c2f3bd35c392..b656cfc03648 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -77,45 +77,6 @@ static inline u32 shadow_sr_wr_ind_addr(struct ath10k *ar,
 	return addr;
 }
 
-static inline u32 shadow_dst_wr_ind_addr(struct ath10k *ar,
-					 struct ath10k_ce_pipe *ce_state)
-{
-	u32 ce_id = ce_state->id;
-	u32 addr = 0;
-
-	switch (ce_id) {
-	case 1:
-		addr = 0x00032034;
-		break;
-	case 2:
-		addr = 0x00032038;
-		break;
-	case 5:
-		addr = 0x00032044;
-		break;
-	case 7:
-		addr = 0x0003204C;
-		break;
-	case 8:
-		addr = 0x00032050;
-		break;
-	case 9:
-		addr = 0x00032054;
-		break;
-	case 10:
-		addr = 0x00032058;
-		break;
-	case 11:
-		addr = 0x0003205C;
-		break;
-	default:
-		ath10k_warn(ar, "invalid CE id: %d", ce_id);
-		break;
-	}
-
-	return addr;
-}
-
 static inline unsigned int
 ath10k_set_ring_byte(unsigned int offset,
 		     struct ath10k_hw_ce_regs_addr_map *addr_map)
@@ -438,19 +399,6 @@ static inline void ath10k_ce_watermark_intr_disable(struct ath10k *ar,
 			  host_ie_addr & ~(wm_regs->wm_mask));
 }
 
-static inline void ath10k_ce_error_intr_enable(struct ath10k *ar,
-					       u32 ce_ctrl_addr)
-{
-	struct ath10k_hw_ce_misc_regs *misc_regs = ar->hw_ce_regs->misc_regs;
-
-	u32 misc_ie_addr = ath10k_ce_read32(ar, ce_ctrl_addr +
-					    ar->hw_ce_regs->misc_ie_addr);
-
-	ath10k_ce_write32(ar,
-			  ce_ctrl_addr + ar->hw_ce_regs->misc_ie_addr,
-			  misc_ie_addr | misc_regs->err_mask);
-}
-
 static inline void ath10k_ce_error_intr_disable(struct ath10k *ar,
 						u32 ce_ctrl_addr)
 {
-- 
2.20.1.7.g153144c

