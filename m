Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C917C1D57
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 10:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730206AbfI3IsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 04:48:12 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3182 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730117AbfI3IsM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Sep 2019 04:48:12 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 2EDFA3D0026E69F40A4A;
        Mon, 30 Sep 2019 16:48:09 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Mon, 30 Sep 2019
 16:48:00 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH 6/6] rtlwifi: rtl8723be: Remove set but not used variables 'reg_ecc','reg_eac'
Date:   Mon, 30 Sep 2019 16:54:52 +0800
Message-ID: <1569833692-93288-7-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1569833692-93288-1-git-send-email-zhengbin13@huawei.com>
References: <1569833692-93288-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c: In function rtl8723be_phy_iq_calibrate:
drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c:2255:7: warning: variable reg_ecc set but not used [-Wunused-but-set-variable]
drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c: In function rtl8723be_phy_iq_calibrate:
drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c:2254:34: warning: variable reg_eac set but not used [-Wunused-but-set-variable]

They are not used since commit a619d1abe20c ("rtlwifi:
rtl8723be: Add new driver")

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
index aa8a095..d483644 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
@@ -2251,8 +2251,8 @@ void rtl8723be_phy_iq_calibrate(struct ieee80211_hw *hw, bool b_recovery)
 	long result[4][8];
 	u8 i, final_candidate, idx;
 	bool b_patha_ok, b_pathb_ok;
-	long reg_e94, reg_e9c, reg_ea4, reg_eac, reg_eb4, reg_ebc, reg_ec4;
-	long reg_ecc, reg_tmp = 0;
+	long reg_e94, reg_e9c, reg_ea4, reg_eb4, reg_ebc, reg_ec4;
+	long reg_tmp = 0;
 	bool is12simular, is13simular, is23simular;
 	u32 iqk_bb_reg[9] = {
 		ROFDM0_XARXIQIMBALANCE,
@@ -2334,11 +2334,9 @@ void rtl8723be_phy_iq_calibrate(struct ieee80211_hw *hw, bool b_recovery)
 		reg_e94 = result[i][0];
 		reg_e9c = result[i][1];
 		reg_ea4 = result[i][2];
-		reg_eac = result[i][3];
 		reg_eb4 = result[i][4];
 		reg_ebc = result[i][5];
 		reg_ec4 = result[i][6];
-		reg_ecc = result[i][7];
 	}
 	if (final_candidate != 0xff) {
 		reg_e94 = result[final_candidate][0];
@@ -2346,13 +2344,11 @@ void rtl8723be_phy_iq_calibrate(struct ieee80211_hw *hw, bool b_recovery)
 		reg_e9c = result[final_candidate][1];
 		rtlphy->reg_e9c = reg_e9c;
 		reg_ea4 = result[final_candidate][2];
-		reg_eac = result[final_candidate][3];
 		reg_eb4 = result[final_candidate][4];
 		rtlphy->reg_eb4 = reg_eb4;
 		reg_ebc = result[final_candidate][5];
 		rtlphy->reg_ebc = reg_ebc;
 		reg_ec4 = result[final_candidate][6];
-		reg_ecc = result[final_candidate][7];
 		b_patha_ok = true;
 		b_pathb_ok = true;
 	} else {
--
2.7.4

