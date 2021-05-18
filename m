Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03AFA386FBC
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 04:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239893AbhERCBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 22:01:24 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:54091 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235741AbhERCBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 22:01:22 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0UZGJFVz_1621303201;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UZGJFVz_1621303201)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 18 May 2021 10:00:02 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     pkshih@realtek.com
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        nathan@kernel.org, ndesaulniers@google.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] rtlwifi: Remove redundant assignments to ul_enc_algo
Date:   Tue, 18 May 2021 09:59:59 +0800
Message-Id: <1621303199-1542-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable ul_enc_algo is being initialized with a value that is never
read, it is being set again in the following switch statements in
all of the case and default paths. Hence the unitialization is
redundant and can be removed.

Clean up clang warning:

drivers/net/wireless/realtek/rtlwifi/cam.c:170:6: warning: Value stored
to 'ul_enc_algo' during its initialization is never read
[clang-analyzer-deadcode.DeadStores]

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/wireless/realtek/rtlwifi/cam.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/cam.c b/drivers/net/wireless/realtek/rtlwifi/cam.c
index 7aa28da..7a0355d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/cam.c
+++ b/drivers/net/wireless/realtek/rtlwifi/cam.c
@@ -167,7 +167,7 @@ void rtl_cam_mark_invalid(struct ieee80211_hw *hw, u8 uc_index)
 
 	u32 ul_command;
 	u32 ul_content;
-	u32 ul_enc_algo = rtlpriv->cfg->maps[SEC_CAM_AES];
+	u32 ul_enc_algo;
 
 	switch (rtlpriv->sec.pairwise_enc_algorithm) {
 	case WEP40_ENCRYPTION:
-- 
1.8.3.1

