Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D247270B83
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 09:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgISHne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 03:43:34 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13330 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726041AbgISHne (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Sep 2020 03:43:34 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 3EC60B6C95119CE91C1B;
        Sat, 19 Sep 2020 15:43:32 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Sat, 19 Sep 2020
 15:43:24 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] rtlwifi: rtl8723be: use true,false for bool variable large_cfo_hit
Date:   Sat, 19 Sep 2020 15:44:37 +0800
Message-ID: <20200919074437.3459305-1-yanaijie@huawei.com>
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

drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c:1155:27-47: WARNING:
Comparison of 0/1 to bool variable
drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c:1156:3-23: WARNING:
Assignment of 0/1 to bool variable
drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c:1159:3-23: WARNING:
Assignment of 0/1 to bool variable

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c
index fbcff23eb058..c3c990cc032f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c
@@ -1152,11 +1152,11 @@ static void rtl8723be_dm_dynamic_atc_switch(struct ieee80211_hw *hw)
 			       (rtldm->cfo_ave_pre - cfo_ave) :
 			       (cfo_ave - rtldm->cfo_ave_pre);
 
-		if (cfo_ave_diff > 20 && rtldm->large_cfo_hit == 0) {
-			rtldm->large_cfo_hit = 1;
+		if (cfo_ave_diff > 20 && !rtldm->large_cfo_hit) {
+			rtldm->large_cfo_hit = true;
 			return;
 		} else
-			rtldm->large_cfo_hit = 0;
+			rtldm->large_cfo_hit = false;
 
 		rtldm->cfo_ave_pre = cfo_ave;
 
-- 
2.25.4

