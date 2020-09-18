Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4BFB26FA53
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 12:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgIRKSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 06:18:36 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56780 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726780AbgIRKS3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 06:18:29 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 4200C7BAEA47F4CED0DD;
        Fri, 18 Sep 2020 18:18:20 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Fri, 18 Sep 2020
 18:18:12 +0800
From:   Zheng Bin <zhengbin13@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH -next 5/9] rtlwifi: rtl8821ae: fix comparison to bool warning in phy.c
Date:   Fri, 18 Sep 2020 18:25:01 +0800
Message-ID: <20200918102505.16036-6-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.26.0.106.g9fadedd
In-Reply-To: <20200918102505.16036-1-zhengbin13@huawei.com>
References: <20200918102505.16036-1-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes coccicheck warning:

drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c:1816:5-13: WARNING: Comparison to bool
drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c:1825:5-13: WARNING: Comparison to bool
drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c:1839:5-13: WARNING: Comparison to bool

Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
index 7832fae3d00f..38669b4d6190 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -1813,7 +1813,7 @@ static bool _rtl8821ae_phy_bb8821a_config_parafile(struct ieee80211_hw *hw)

 	rtstatus = _rtl8821ae_phy_config_bb_with_headerfile(hw,
 						       BASEBAND_CONFIG_PHY_REG);
-	if (rtstatus != true) {
+	if (!rtstatus) {
 		pr_err("Write BB Reg Fail!!\n");
 		return false;
 	}
@@ -1822,7 +1822,7 @@ static bool _rtl8821ae_phy_bb8821a_config_parafile(struct ieee80211_hw *hw)
 		rtstatus = _rtl8821ae_phy_config_bb_with_pgheaderfile(hw,
 						    BASEBAND_CONFIG_PHY_REG);
 	}
-	if (rtstatus != true) {
+	if (!rtstatus) {
 		pr_err("BB_PG Reg Fail!!\n");
 		return false;
 	}
@@ -1836,7 +1836,7 @@ static bool _rtl8821ae_phy_bb8821a_config_parafile(struct ieee80211_hw *hw)
 	rtstatus = _rtl8821ae_phy_config_bb_with_headerfile(hw,
 						BASEBAND_CONFIG_AGC_TAB);

-	if (rtstatus != true) {
+	if (!rtstatus) {
 		pr_err("AGC Table Fail\n");
 		return false;
 	}
--
2.26.0.106.g9fadedd

