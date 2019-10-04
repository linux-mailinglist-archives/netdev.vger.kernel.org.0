Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA6BCB716
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 11:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731115AbfJDJLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 05:11:55 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:59144 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730921AbfJDJLz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 05:11:55 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D195766A008B50E46E3B;
        Fri,  4 Oct 2019 17:11:52 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Fri, 4 Oct 2019
 17:11:44 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <yhchuang@realtek.com>, <pkshih@realtek.com>,
        <kvalo@codeaurora.org>, <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH] rtw88: 8822c: Remove set but not used variable 'corr_val'
Date:   Fri, 4 Oct 2019 17:18:56 +0800
Message-ID: <1570180736-133907-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/realtek/rtw88/rtw8822c.c: In function rtw8822c_dpk_dc_corr_check:
drivers/net/wireless/realtek/rtw88/rtw8822c.c:2166:5: warning: variable corr_val set but not used [-Wunused-but-set-variable]

It is not used since commit 5227c2ee453d ("rtw88:
8822c: add SW DPK support")

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index a300efd..52682d5 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -2163,7 +2163,7 @@ static void rtw8822c_dpk_rxbb_dc_cal(struct rtw_dev *rtwdev, u8 path)
 static u8 rtw8822c_dpk_dc_corr_check(struct rtw_dev *rtwdev, u8 path)
 {
 	u16 dc_i, dc_q;
-	u8 corr_val, corr_idx;
+	u8 corr_idx;

 	rtw_write32(rtwdev, REG_RXSRAM_CTL, 0x000900f0);
 	dc_i = (u16)rtw_read32_mask(rtwdev, REG_STAT_RPT, GENMASK(27, 16));
@@ -2176,7 +2176,6 @@ static u8 rtw8822c_dpk_dc_corr_check(struct rtw_dev *rtwdev, u8 path)

 	rtw_write32(rtwdev, REG_RXSRAM_CTL, 0x000000f0);
 	corr_idx = (u8)rtw_read32_mask(rtwdev, REG_STAT_RPT, GENMASK(7, 0));
-	corr_val = (u8)rtw_read32_mask(rtwdev, REG_STAT_RPT, GENMASK(15, 8));

 	if (dc_i > 200 || dc_q > 200 || corr_idx < 40 || corr_idx > 65)
 		return 1;
--
2.7.4

