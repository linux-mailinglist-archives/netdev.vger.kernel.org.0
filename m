Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 082262A4F0
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 16:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbfEYOou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 10:44:50 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:17161 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726126AbfEYOou (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 May 2019 10:44:50 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 00FA5E169CEB782C28C0;
        Sat, 25 May 2019 22:44:47 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Sat, 25 May 2019
 22:44:37 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] rtlwifi: rtl8821ae: Remove set but not used variables 'cur_txokcnt' and 'b_last_is_cur_rdl_state'
Date:   Sat, 25 May 2019 22:43:32 +0800
Message-ID: <20190525144332.17268-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c: In function rtl8821ae_dm_check_rssi_monitor:
drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c:658:6: warning: variable cur_txokcnt set but not used [-Wunused-but-set-variable]
drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c: In function rtl8821ae_dm_check_edca_turbo:
drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c:2657:7: warning: variable b_last_is_cur_rdl_state set but not used [-Wunused-but-set-variable]

They are never used so can be removed.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
index 49d05b631ba1..84b30464964d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
@@ -655,10 +655,9 @@ static void rtl8821ae_dm_check_rssi_monitor(struct ieee80211_hw *hw)
 	u8 h2c_parameter[4] = { 0 };
 	long tmp_entry_max_pwdb = 0, tmp_entry_min_pwdb = 0xff;
 	u8 stbc_tx = 0;
-	u64 cur_txokcnt = 0, cur_rxokcnt = 0;
+	u64 cur_rxokcnt = 0;
 	static u64 last_txokcnt = 0, last_rxokcnt;
 
-	cur_txokcnt = rtlpriv->stats.txbytesunicast - last_txokcnt;
 	cur_rxokcnt = rtlpriv->stats.rxbytesunicast - last_rxokcnt;
 	last_txokcnt = rtlpriv->stats.txbytesunicast;
 	last_rxokcnt = rtlpriv->stats.rxbytesunicast;
@@ -2654,7 +2653,6 @@ static void rtl8821ae_dm_check_edca_turbo(struct ieee80211_hw *hw)
 	u32 edca_be = 0x5ea42b;
 	u8 iot_peer = 0;
 	bool *pb_is_cur_rdl_state = NULL;
-	bool b_last_is_cur_rdl_state = false;
 	bool b_bias_on_rx = false;
 	bool b_edca_turbo_on = false;
 
@@ -2672,7 +2670,6 @@ static void rtl8821ae_dm_check_edca_turbo(struct ieee80211_hw *hw)
 	 * list paramter for different platform
 	 *===============================
 	 */
-	b_last_is_cur_rdl_state = rtlpriv->dm.is_cur_rdlstate;
 	pb_is_cur_rdl_state = &rtlpriv->dm.is_cur_rdlstate;
 
 	cur_tx_ok_cnt = rtlpriv->stats.txbytesunicast - rtldm->last_tx_ok_cnt;
-- 
2.17.1


