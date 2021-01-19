Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C23162FB3B3
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 09:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730835AbhASICL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 03:02:11 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:59551 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730806AbhASIAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 03:00:04 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R951e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0UMDlRSu_1611043152;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0UMDlRSu_1611043152)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 19 Jan 2021 15:59:16 +0800
From:   Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
To:     pkshih@realtek.com
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        Larry.Finger@lwfinger.net, chiu@endlessos.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH v3] rtlwifi: rtl8192se: Simplify bool comparison
Date:   Tue, 19 Jan 2021 15:59:10 +0800
Message-Id: <1611043150-78723-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the follow coccicheck warnings:

./drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c:2305:6-27:
WARNING: Comparison of 0/1 to bool variable.

./drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c:1376:5-26:
WARNING: Comparison of 0/1 to bool variable.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
---
Changes in v3:
  - Modified subject.

 drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
index 47fabce..aff8ab0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
@@ -1373,7 +1373,7 @@ static void _rtl92se_gen_refreshledstate(struct ieee80211_hw *hw)
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_led *pled0 = &rtlpriv->ledctl.sw_led0;
 
-	if (rtlpci->up_first_time == 1)
+	if (rtlpci->up_first_time)
 		return;
 
 	if (rtlpriv->psc.rfoff_reason == RF_CHANGE_BY_IPS)
@@ -2302,7 +2302,7 @@ bool rtl92se_gpio_radio_on_off_checking(struct ieee80211_hw *hw, u8 *valid)
 	bool turnonbypowerdomain = false;
 
 	/* just 8191se can check gpio before firstup, 92c/92d have fixed it */
-	if ((rtlpci->up_first_time == 1) || (rtlpci->being_init_adapter))
+	if (rtlpci->up_first_time || rtlpci->being_init_adapter)
 		return false;
 
 	if (ppsc->swrf_processing)
-- 
1.8.3.1

