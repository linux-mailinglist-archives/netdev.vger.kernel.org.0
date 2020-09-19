Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4BCA270B80
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 09:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbgISHnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 03:43:14 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13328 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726041AbgISHnN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Sep 2020 03:43:13 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 34AC932C1EE704B44C20;
        Sat, 19 Sep 2020 15:43:10 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Sat, 19 Sep 2020
 15:43:03 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <Larry.Finger@lwfinger.net>, <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] rtlwifi: rtl8192ee: use true,false for bool variable large_cfo_hit
Date:   Sat, 19 Sep 2020 15:44:12 +0800
Message-ID: <20200919074412.3459163-1-yanaijie@huawei.com>
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

drivers/net/wireless/realtek/rtlwifi/rtl8192ee/dm.c:721:27-47:
WARNING: Comparison of 0/1 to bool variable
drivers/net/wireless/realtek/rtlwifi/rtl8192ee/dm.c:722:3-23: WARNING:
Assignment of 0/1 to bool variable
drivers/net/wireless/realtek/rtlwifi/rtl8192ee/dm.c:725:2-22: WARNING:
Assignment of 0/1 to bool variable

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/dm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/dm.c
index 140f33089c4d..997ff115b9ab 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/dm.c
@@ -718,11 +718,11 @@ static void rtl92ee_dm_dynamic_atc_switch(struct ieee80211_hw *hw)
 			       (rtldm->cfo_ave_pre - cfo_ave) :
 			       (cfo_ave - rtldm->cfo_ave_pre);
 
-		if (cfo_ave_diff > 20 && rtldm->large_cfo_hit == 0) {
-			rtldm->large_cfo_hit = 1;
+		if (cfo_ave_diff > 20 && !rtldm->large_cfo_hit) {
+			rtldm->large_cfo_hit = true;
 			return;
 		}
-		rtldm->large_cfo_hit = 0;
+		rtldm->large_cfo_hit = false;
 
 		rtldm->cfo_ave_pre = cfo_ave;
 
-- 
2.25.4

