Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB4F2647F1
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 16:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731063AbgIJOYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 10:24:32 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56932 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730434AbgIJOK1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 10:10:27 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 911E06F8FFDF841198DC;
        Thu, 10 Sep 2020 22:09:57 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Thu, 10 Sep 2020
 22:09:48 +0800
From:   Zheng Bin <zhengbin13@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH -next 3/3] rtlwifi: rtl8723ae: fix comparison pointer to bool warning in phy.c
Date:   Thu, 10 Sep 2020 22:16:42 +0800
Message-ID: <20200910141642.127006-4-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.26.0.106.g9fadedd
In-Reply-To: <20200910141642.127006-1-zhengbin13@huawei.com>
References: <20200910141642.127006-1-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes coccicheck warning:

drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c:191:5-13: WARNING: Comparison to bool
drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c:205:5-13: WARNING: Comparison to bool
drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c:211:5-13: WARNING: Comparison to bool
drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c:625:5-30: WARNING: Comparison to bool

Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c
index 5ba645bc46dc..fa0eed434d4f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c
@@ -188,7 +188,7 @@ static bool _rtl8723e_phy_bb8192c_config_parafile(struct ieee80211_hw *hw)
 	rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE, "\n");
 	rtstatus = _rtl8723e_phy_config_bb_with_headerfile(hw,
 						BASEBAND_CONFIG_PHY_REG);
-	if (rtstatus != true) {
+	if (!rtstatus) {
 		pr_err("Write BB Reg Fail!!\n");
 		return false;
 	}
@@ -202,13 +202,13 @@ static bool _rtl8723e_phy_bb8192c_config_parafile(struct ieee80211_hw *hw)
 		rtstatus = _rtl8723e_phy_config_bb_with_pgheaderfile(hw,
 					BASEBAND_CONFIG_PHY_REG);
 	}
-	if (rtstatus != true) {
+	if (!rtstatus) {
 		pr_err("BB_PG Reg Fail!!\n");
 		return false;
 	}
 	rtstatus =
 	  _rtl8723e_phy_config_bb_with_headerfile(hw, BASEBAND_CONFIG_AGC_TAB);
-	if (rtstatus != true) {
+	if (!rtstatus) {
 		pr_err("AGC Table Fail\n");
 		return false;
 	}
@@ -622,7 +622,7 @@ void rtl8723e_phy_set_txpower_level(struct ieee80211_hw *hw, u8 channel)
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
 	u8 cckpowerlevel[2], ofdmpowerlevel[2];

-	if (rtlefuse->txpwr_fromeprom == false)
+	if (!rtlefuse->txpwr_fromeprom)
 		return;
 	_rtl8723e_get_txpower_index(hw, channel,
 				    &cckpowerlevel[0], &ofdmpowerlevel[0]);
--
2.26.0.106.g9fadedd

