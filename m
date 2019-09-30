Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22B36C1D56
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 10:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730191AbfI3IsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 04:48:11 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3183 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729899AbfI3IsL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Sep 2019 04:48:11 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 38E7D77053A048E6B021;
        Mon, 30 Sep 2019 16:48:09 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Mon, 30 Sep 2019
 16:48:00 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH 5/6] rtlwifi: rtl8192ee: Remove set but not used variables 'reg_ecc','reg_eac'
Date:   Mon, 30 Sep 2019 16:54:51 +0800
Message-ID: <1569833692-93288-6-git-send-email-zhengbin13@huawei.com>
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

drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c: In function rtl92ee_phy_iq_calibrate:
drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c:2805:34: warning: variable reg_ecc set but not used [-Wunused-but-set-variable]
drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c: In function rtl92ee_phy_iq_calibrate:
drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c:2804:34: warning: variable reg_eac set but not used [-Wunused-but-set-variable]

They are not used since commit b1a3bfc97cd9 ("rtlwifi:
rtl8192ee: Move driver from staging to the regular tree")

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c
index 222abc4..f03de8b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c
@@ -2801,8 +2801,8 @@ void rtl92ee_phy_iq_calibrate(struct ieee80211_hw *hw, bool b_recovery)
 	long result[4][8];
 	u8 i, final_candidate;
 	bool b_patha_ok, b_pathb_ok;
-	long reg_e94, reg_e9c, reg_ea4, reg_eac;
-	long reg_eb4, reg_ebc, reg_ec4, reg_ecc;
+	long reg_e94, reg_e9c, reg_ea4;
+	long reg_eb4, reg_ebc, reg_ec4;
 	bool is12simular, is13simular, is23simular;
 	u8 idx;
 	u32 iqk_bb_reg[IQK_BB_REG_NUM] = {
@@ -2873,11 +2873,9 @@ void rtl92ee_phy_iq_calibrate(struct ieee80211_hw *hw, bool b_recovery)
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
@@ -2886,13 +2884,11 @@ void rtl92ee_phy_iq_calibrate(struct ieee80211_hw *hw, bool b_recovery)
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

