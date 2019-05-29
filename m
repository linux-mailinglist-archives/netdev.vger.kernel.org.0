Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBEF2E05B
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 16:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbfE2O6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 10:58:24 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:55022 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726087AbfE2O6Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 10:58:24 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 0D5251411A3C0405980B;
        Wed, 29 May 2019 22:58:05 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Wed, 29 May 2019
 22:57:56 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <yhchuang@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] rtw88: Remove set but not used variable 'ip_sel' and 'orig'
Date:   Wed, 29 May 2019 22:57:40 +0800
Message-ID: <20190529145740.22804-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warnings:

drivers/net/wireless/realtek/rtw88/pci.c: In function rtw_pci_phy_cfg:
drivers/net/wireless/realtek/rtw88/pci.c:978:6: warning: variable ip_sel set but not used [-Wunused-but-set-variable]
drivers/net/wireless/realtek/rtw88/phy.c: In function phy_tx_power_limit_config:
drivers/net/wireless/realtek/rtw88/phy.c:1607:11: warning: variable orig set but not used [-Wunused-but-set-variable]

They are never used, so can be removed.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 3 ---
 drivers/net/wireless/realtek/rtw88/phy.c | 3 +--
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index 353871c27779..8329f4e447b7 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -977,7 +977,6 @@ static void rtw_pci_phy_cfg(struct rtw_dev *rtwdev)
 	u16 cut;
 	u16 value;
 	u16 offset;
-	u16 ip_sel;
 	int i;
 
 	cut = BIT(0) << rtwdev->hal.cut_version;
@@ -990,7 +989,6 @@ static void rtw_pci_phy_cfg(struct rtw_dev *rtwdev)
 			break;
 		offset = para->offset;
 		value = para->value;
-		ip_sel = para->ip_sel;
 		if (para->ip_sel == RTW_IP_SEL_PHY)
 			rtw_mdio_write(rtwdev, offset, value, true);
 		else
@@ -1005,7 +1003,6 @@ static void rtw_pci_phy_cfg(struct rtw_dev *rtwdev)
 			break;
 		offset = para->offset;
 		value = para->value;
-		ip_sel = para->ip_sel;
 		if (para->ip_sel == RTW_IP_SEL_PHY)
 			rtw_mdio_write(rtwdev, offset, value, false);
 		else
diff --git a/drivers/net/wireless/realtek/rtw88/phy.c b/drivers/net/wireless/realtek/rtw88/phy.c
index 404d89432c96..c3e75ffe27b5 100644
--- a/drivers/net/wireless/realtek/rtw88/phy.c
+++ b/drivers/net/wireless/realtek/rtw88/phy.c
@@ -1604,12 +1604,11 @@ void rtw_phy_tx_power_by_rate_config(struct rtw_hal *hal)
 static void
 phy_tx_power_limit_config(struct rtw_hal *hal, u8 regd, u8 bw, u8 rs)
 {
-	s8 base, orig;
+	s8 base;
 	u8 ch;
 
 	for (ch = 0; ch < RTW_MAX_CHANNEL_NUM_2G; ch++) {
 		base = hal->tx_pwr_by_rate_base_2g[0][rs];
-		orig = hal->tx_pwr_limit_2g[regd][bw][rs][ch];
 		hal->tx_pwr_limit_2g[regd][bw][rs][ch] -= base;
 	}
 
-- 
2.17.1


