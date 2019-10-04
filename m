Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61AABCB682
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 10:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387575AbfJDIhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 04:37:04 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:43576 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729994AbfJDIg7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 04:36:59 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 03FB4D4B44CE81B90E00;
        Fri,  4 Oct 2019 16:36:53 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Fri, 4 Oct 2019
 16:36:45 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <Larry.Finger@lwfinger.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH 6/8] rtlwifi: btcoex: Remove set but not used variable 'result'
Date:   Fri, 4 Oct 2019 16:43:53 +0800
Message-ID: <1570178635-57582-7-git-send-email-zhengbin13@huawei.com>
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

drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c: In function btc8192e2ant_tdma_duration_adjust:
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c:1584:6: warning: variable result set but not used [-Wunused-but-set-variable]

It is not used since commit 27a31a60a4de ("rtlwifi:
btcoex: remove unused functions")

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
index 3ebc7c9..3c96c32 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
@@ -1578,10 +1578,6 @@ static void btc8192e2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	static int up, dn, m, n, wait_cnt;
-	/* 0: no change, +1: increase WiFi duration,
-	 * -1: decrease WiFi duration
-	 */
-	int result;
 	u8 retry_cnt = 0;

 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
@@ -1669,7 +1665,6 @@ static void btc8192e2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 		dn = 0;
 		m = 1;
 		n = 3;
-		result = 0;
 		wait_cnt = 0;
 	} else {
 		/* accquire the BT TRx retry count from BT_Info byte2 */
@@ -1679,7 +1674,6 @@ static void btc8192e2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], up=%d, dn=%d, m=%d, n=%d, wait_cnt=%d\n",
 			 up, dn, m, n, wait_cnt);
-		result = 0;
 		wait_cnt++;
 		/* no retry in the last 2-second duration */
 		if (retry_cnt == 0) {
@@ -1694,7 +1688,6 @@ static void btc8192e2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 				n = 3;
 				up = 0;
 				dn = 0;
-				result = 1;
 				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 					 "[BTCoex]Increase wifi duration!!\n");
 			}
@@ -1718,7 +1711,6 @@ static void btc8192e2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 				up = 0;
 				dn = 0;
 				wait_cnt = 0;
-				result = -1;
 				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 					 "Reduce wifi duration for retry<3\n");
 			}
@@ -1735,7 +1727,6 @@ static void btc8192e2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 			up = 0;
 			dn = 0;
 			wait_cnt = 0;
-			result = -1;
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "Decrease wifi duration for retryCounter>3!!\n");
 		}
--
2.7.4

