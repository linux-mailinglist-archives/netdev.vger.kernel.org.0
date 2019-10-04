Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC9ACB685
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 10:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731291AbfJDIgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 04:36:55 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:43542 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727242AbfJDIgy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 04:36:54 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id CE866F7FA72FED97EB6B;
        Fri,  4 Oct 2019 16:36:52 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Fri, 4 Oct 2019
 16:36:44 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <Larry.Finger@lwfinger.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH 3/8] rtlwifi: rtl8192c: Remove set but not used variables 'reg_ecc','reg_eac'
Date:   Fri, 4 Oct 2019 16:43:50 +0800
Message-ID: <1570178635-57582-4-git-send-email-zhengbin13@huawei.com>
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

drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c: In function rtl92c_phy_iq_calibrate:
drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c:1373:6: warning: variable reg_ecc set but not used [-Wunused-but-set-variable]
drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c: In function rtl92c_phy_iq_calibrate:
drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c:1372:34: warning: variable reg_eac set but not used [-Wunused-but-set-variable]

They are not used since commit f1d2b4d338bf ("rtlwifi:
rtl818x: Move drivers into new realtek directory")

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c
index 0efd19a..661249d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c
@@ -1369,8 +1369,8 @@ void rtl92c_phy_iq_calibrate(struct ieee80211_hw *hw, bool b_recovery)
 	long result[4][8];
 	u8 i, final_candidate;
 	bool b_patha_ok, b_pathb_ok;
-	long reg_e94, reg_e9c, reg_ea4, reg_eac, reg_eb4, reg_ebc, reg_ec4,
-	    reg_ecc, reg_tmp = 0;
+	long reg_e94, reg_e9c, reg_ea4, reg_eb4, reg_ebc, reg_ec4,
+	    reg_tmp = 0;
 	bool is12simular, is13simular, is23simular;
 	u32 iqk_bb_reg[10] = {
 		ROFDM0_XARXIQIMBALANCE,
@@ -1445,21 +1445,17 @@ void rtl92c_phy_iq_calibrate(struct ieee80211_hw *hw, bool b_recovery)
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
 		rtlphy->reg_e94 = reg_e94 = result[final_candidate][0];
 		rtlphy->reg_e9c = reg_e9c = result[final_candidate][1];
 		reg_ea4 = result[final_candidate][2];
-		reg_eac = result[final_candidate][3];
 		rtlphy->reg_eb4 = reg_eb4 = result[final_candidate][4];
 		rtlphy->reg_ebc = reg_ebc = result[final_candidate][5];
 		reg_ec4 = result[final_candidate][6];
-		reg_ecc = result[final_candidate][7];
 		b_patha_ok = true;
 		b_pathb_ok = true;
 	} else {
--
2.7.4

