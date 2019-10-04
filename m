Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E85ECB684
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 10:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387612AbfJDIhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 04:37:07 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:43574 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731354AbfJDIhE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 04:37:04 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id D817735762423652B4D8;
        Fri,  4 Oct 2019 16:36:52 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Fri, 4 Oct 2019
 16:36:45 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <Larry.Finger@lwfinger.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH 7/8] rtlwifi: btcoex: Remove set but not used variables 'wifi_busy','bt_info_ext'
Date:   Fri, 4 Oct 2019 16:43:54 +0800
Message-ID: <1570178635-57582-8-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1570178635-57582-1-git-send-email-zhengbin13@huawei.com>
References: <1570178635-57582-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c: In function btc8723b1ant_tdma_dur_adj_for_acl:
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c:1428:7: warning: variable wifi_busy set but not used [-Wunused-but-set-variable]
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c: In function btc8723b1ant_tdma_dur_adj_for_acl:
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c:1427:22: warning: variable bt_info_ext set but not used [-Wunused-but-set-variable]

'wifi_busy' is not used since commit 158707f9584c ("rtlwifi:
btcoex: Restore 23b 1ant routine for tdma adjustment")

'bt_info_ext' is not used since commit 2622d7d86a57 ("rtlwifi:
btcoex: 23b 1ant: TDMA duration for ACL busy")

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
index 5f57399..528e442 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -1424,17 +1424,11 @@ void btc8723b1ant_tdma_dur_adj_for_acl(struct btc_coexist *btcoexist,
 	 * -1: decrease WiFi duration
 	 */
 	s32 result;
-	u8 retry_count = 0, bt_info_ext;
-	bool wifi_busy = false;
+	u8 retry_count = 0;

 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], TdmaDurationAdjustForAcl()\n");

-	if (wifi_status == BT_8723B_1ANT_WIFI_STATUS_CONNECTED_BUSY)
-		wifi_busy = true;
-	else
-		wifi_busy = false;
-
 	if ((wifi_status ==
 	     BT_8723B_1ANT_WIFI_STATUS_NON_CONNECTED_ASSO_AUTH_SCAN) ||
 	    (wifi_status == BT_8723B_1ANT_WIFI_STATUS_CONNECTED_SCAN) ||
@@ -1472,7 +1466,6 @@ void btc8723b1ant_tdma_dur_adj_for_acl(struct btc_coexist *btcoexist,
 	} else {
 		/* acquire the BT TRx retry count from BT_Info byte2 */
 		retry_count = coex_sta->bt_retry_cnt;
-		bt_info_ext = coex_sta->bt_info_ext;

 		if ((coex_sta->low_priority_tx) > 1050 ||
 		    (coex_sta->low_priority_rx) > 1250)
--
2.7.4

