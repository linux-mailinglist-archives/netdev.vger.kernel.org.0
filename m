Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE191C3834
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 13:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbgEDLeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 07:34:10 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:55996 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728630AbgEDLeJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 07:34:09 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id EB0C3A751E5CC6D8243C;
        Mon,  4 May 2020 19:34:07 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Mon, 4 May 2020
 19:33:58 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] rtlwifi: rtl8188ee: remove Comparison to bool in rf.c
Date:   Mon, 4 May 2020 19:33:21 +0800
Message-ID: <20200504113321.41118-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:

drivers/net/wireless/realtek/rtlwifi/rtl8188ee/rf.c:476:6-14: WARNING:
Comparison to bool
drivers/net/wireless/realtek/rtlwifi/rtl8188ee/rf.c:54:5-22: WARNING:
Comparison to bool

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/rf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/rf.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/rf.c
index 0f401ad92c2e..c376817a1bf4 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/rf.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/rf.c
@@ -51,7 +51,7 @@ void rtl88e_phy_rf6052_set_cck_txpower(struct ieee80211_hw *hw,
 	if (rtlefuse->eeprom_regulatory != 0)
 		turbo_scanoff = true;
 
-	if (mac->act_scanning == true) {
+	if (mac->act_scanning) {
 		tx_agc[RF90_PATH_A] = 0x3f3f3f3f;
 		tx_agc[RF90_PATH_B] = 0x3f3f3f3f;
 
@@ -473,7 +473,7 @@ static bool _rtl88e_phy_rf6052_config_parafile(struct ieee80211_hw *hw)
 			break;
 		}
 
-		if (rtstatus != true) {
+		if (!rtstatus) {
 			RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 				 "Radio[%d] Fail!!\n", rfpath);
 			return false;
-- 
2.21.1

