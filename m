Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECC8270B81
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 09:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgISHnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 03:43:24 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13329 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726041AbgISHnY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Sep 2020 03:43:24 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id DCD2BD9E564FEBFC79AE;
        Sat, 19 Sep 2020 15:43:21 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Sat, 19 Sep 2020
 15:43:15 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] rtlwifi: rtl8821ae: use true,false for bool variable large_cfo_hit
Date:   Sat, 19 Sep 2020 15:44:28 +0800
Message-ID: <20200919074428.3459234-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This addresses the following coccinelle warning:

drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c:2680:27-47: WARNING:
Comparison of 0/1 to bool variable
drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c:2683:3-23: WARNING:
Assignment of 0/1 to bool variable
drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c:2686:3-23: WARNING:
Assignment of 0/1 to bool variable

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
index 93893825e6d6..f6bff0ebd6b0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
@@ -2677,13 +2677,13 @@ static void rtl8821ae_dm_dynamic_atc_switch(struct ieee80211_hw *hw)
 						(rtldm->cfo_ave_pre - cfo_ave) :
 						(cfo_ave - rtldm->cfo_ave_pre);
 
-		if (cfo_ave_diff > 20 && rtldm->large_cfo_hit == 0) {
+		if (cfo_ave_diff > 20 && !rtldm->large_cfo_hit) {
 			rtl_dbg(rtlpriv, COMP_DIG, DBG_LOUD,
 				"first large CFO hit\n");
-			rtldm->large_cfo_hit = 1;
+			rtldm->large_cfo_hit = true;
 			return;
 		} else
-			rtldm->large_cfo_hit = 0;
+			rtldm->large_cfo_hit = false;
 
 		rtldm->cfo_ave_pre = cfo_ave;
 
-- 
2.25.4

