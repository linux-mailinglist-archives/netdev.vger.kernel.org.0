Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 127782647E2
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 16:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731017AbgIJOVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 10:21:04 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56900 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728350AbgIJOK2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 10:10:28 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 8B386963CF3E2762CCAB;
        Thu, 10 Sep 2020 22:09:57 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Thu, 10 Sep 2020
 22:09:47 +0800
From:   Zheng Bin <zhengbin13@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH -next 1/3] rtlwifi: rtl8723ae: fix comparison pointer to bool warning in rf.c
Date:   Thu, 10 Sep 2020 22:16:40 +0800
Message-ID: <20200910141642.127006-2-zhengbin13@huawei.com>
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

drivers/net/wireless/realtek/rtlwifi/rtl8723ae/rf.c:52:5-22: WARNING: Comparison to bool
drivers/net/wireless/realtek/rtlwifi/rtl8723ae/rf.c:482:6-14: WARNING: Comparison to bool

Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/rf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/rf.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/rf.c
index ecec8c9f0992..b8ed80c84266 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/rf.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/rf.c
@@ -49,7 +49,7 @@ void rtl8723e_phy_rf6052_set_cck_txpower(struct ieee80211_hw *hw,
 	if (rtlefuse->eeprom_regulatory != 0)
 		turbo_scanoff = true;

-	if (mac->act_scanning == true) {
+	if (mac->act_scanning) {
 		tx_agc[RF90_PATH_A] = 0x3f3f3f3f;
 		tx_agc[RF90_PATH_B] = 0x3f3f3f3f;

@@ -479,7 +479,7 @@ static bool _rtl8723e_phy_rf6052_config_parafile(struct ieee80211_hw *hw)
 			break;
 		}

-		if (rtstatus != true) {
+		if (!rtstatus) {
 			rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
 				"Radio[%d] Fail!!\n", rfpath);
 			return false;
--
2.26.0.106.g9fadedd

