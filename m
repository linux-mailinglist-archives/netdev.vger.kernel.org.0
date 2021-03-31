Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADCA034FC4C
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 11:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234546AbhCaJN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 05:13:58 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:56834 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234501AbhCaJNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 05:13:49 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UTwuZub_1617182027;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UTwuZub_1617182027)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 31 Mar 2021 17:13:47 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     pkshih@realtek.com
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] rtlwifi: rtl8188ee: remove redundant assignment of variable rtlpriv->btcoexist.reg_bt_sco
Date:   Wed, 31 Mar 2021 17:13:43 +0800
Message-Id: <1617182023-110950-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Assigning value "3" to "rtlpriv->btcoexist.reg_bt_sco" here, but that
stored value is overwritten before it can be used.

Coverity reports this problem as
CWE563: A value assigned to a variable is never used.
drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c:
rtl8188ee_bt_reg_init

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
index 861cc66..bf686a9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
@@ -2466,8 +2466,6 @@ void rtl8188ee_bt_reg_init(struct ieee80211_hw *hw)
 
 	/* 0:Low, 1:High, 2:From Efuse. */
 	rtlpriv->btcoexist.reg_bt_iso = 2;
-	/* 0:Idle, 1:None-SCO, 2:SCO, 3:From Counter. */
-	rtlpriv->btcoexist.reg_bt_sco = 3;
 	/* 0:Disable BT control A-MPDU, 1:Enable BT control A-MPDU. */
 	rtlpriv->btcoexist.reg_bt_sco = 0;
 }
-- 
1.8.3.1

