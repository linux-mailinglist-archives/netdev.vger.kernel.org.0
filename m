Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 885ADCB688
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 10:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731273AbfJDIgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 04:36:55 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:43498 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728462AbfJDIgy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 04:36:54 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C9D50EECC2E21AD98F6B;
        Fri,  4 Oct 2019 16:36:52 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Fri, 4 Oct 2019
 16:36:44 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <Larry.Finger@lwfinger.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH 2/8] rtlwifi: rtl8723ae: Remove set but not used variables 'reg_ecc','reg_ec4','reg_eac','b_pathb_ok'
Date:   Fri, 4 Oct 2019 16:43:49 +0800
Message-ID: <1570178635-57582-3-git-send-email-zhengbin13@huawei.com>
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

drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c: In function rtl8723e_phy_iq_calibrate:
drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c:1346:6: warning: variable reg_ecc set but not used [-Wunused-but-set-variable]
drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c: In function rtl8723e_phy_iq_calibrate:
drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c:1345:61: warning: variable reg_ec4 set but not used [-Wunused-but-set-variable]
drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c: In function rtl8723e_phy_iq_calibrate:
drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c:1345:34: warning: variable reg_eac set but not used [-Wunused-but-set-variable]
drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c: In function rtl8723e_phy_iq_calibrate:
drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c:1344:19: warning: variable b_pathb_ok set but not used [-Wunused-but-set-variable]

They are not used since commit f1d2b4d338bf ("rtlwifi:
rtl818x: Move drivers into new realtek directory")

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c
index 22441dd..1385e5a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c
@@ -1338,9 +1338,9 @@ void rtl8723e_phy_iq_calibrate(struct ieee80211_hw *hw, bool b_recovery)

 	long result[4][8];
 	u8 i, final_candidate;
-	bool b_patha_ok, b_pathb_ok;
-	long reg_e94, reg_e9c, reg_ea4, reg_eac, reg_eb4, reg_ebc, reg_ec4,
-	    reg_ecc, reg_tmp = 0;
+	bool b_patha_ok;
+	long reg_e94, reg_e9c, reg_ea4, reg_eb4, reg_ebc,
+	   reg_tmp = 0;
 	bool is12simular, is13simular, is23simular;
 	u32 iqk_bb_reg[10] = {
 		ROFDM0_XARXIQIMBALANCE,
@@ -1369,7 +1369,6 @@ void rtl8723e_phy_iq_calibrate(struct ieee80211_hw *hw, bool b_recovery)
 	}
 	final_candidate = 0xff;
 	b_patha_ok = false;
-	b_pathb_ok = false;
 	is12simular = false;
 	is23simular = false;
 	is13simular = false;
@@ -1409,23 +1408,16 @@ void rtl8723e_phy_iq_calibrate(struct ieee80211_hw *hw, bool b_recovery)
 		reg_e94 = result[i][0];
 		reg_e9c = result[i][1];
 		reg_ea4 = result[i][2];
-		reg_eac = result[i][3];
 		reg_eb4 = result[i][4];
 		reg_ebc = result[i][5];
-		reg_ec4 = result[i][6];
-		reg_ecc = result[i][7];
 	}
 	if (final_candidate != 0xff) {
 		rtlphy->reg_e94 = reg_e94 = result[final_candidate][0];
 		rtlphy->reg_e9c = reg_e9c = result[final_candidate][1];
 		reg_ea4 = result[final_candidate][2];
-		reg_eac = result[final_candidate][3];
 		rtlphy->reg_eb4 = reg_eb4 = result[final_candidate][4];
 		rtlphy->reg_ebc = reg_ebc = result[final_candidate][5];
-		reg_ec4 = result[final_candidate][6];
-		reg_ecc = result[final_candidate][7];
 		b_patha_ok = true;
-		b_pathb_ok = true;
 	} else {
 		rtlphy->reg_e94 = rtlphy->reg_eb4 = 0x100;
 		rtlphy->reg_e9c = rtlphy->reg_ebc = 0x0;
--
2.7.4

