Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6191E26FA4E
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 12:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgIRKSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 06:18:23 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56636 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726365AbgIRKSW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 06:18:22 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 221EBF2213E9275D43B8;
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
Subject: [PATCH -next 3/9] rtlwifi: rtl8192cu: fix comparison to bool warning in mac.c
Date:   Fri, 18 Sep 2020 18:24:59 +0800
Message-ID: <20200918102505.16036-4-zhengbin13@huawei.com>
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

drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c:161:14-17: WARNING: Comparison to bool
drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c:168:13-16: WARNING: Comparison to bool
drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c:179:14-17: WARNING: Comparison to bool
drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c:186:13-16: WARNING: Comparison to bool

Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c
index d7afb6a186df..2890a495a23e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c
@@ -158,14 +158,14 @@ bool rtl92c_init_llt_table(struct ieee80211_hw *hw, u32 boundary)

 	for (i = 0; i < (boundary - 1); i++) {
 		rst = rtl92c_llt_write(hw, i , i + 1);
-		if (true != rst) {
+		if (!rst) {
 			pr_err("===> %s #1 fail\n", __func__);
 			return rst;
 		}
 	}
 	/* end of list */
 	rst = rtl92c_llt_write(hw, (boundary - 1), 0xFF);
-	if (true != rst) {
+	if (!rst) {
 		pr_err("===> %s #2 fail\n", __func__);
 		return rst;
 	}
@@ -176,14 +176,14 @@ bool rtl92c_init_llt_table(struct ieee80211_hw *hw, u32 boundary)
 	 */
 	for (i = boundary; i < LLT_LAST_ENTRY_OF_TX_PKT_BUFFER; i++) {
 		rst = rtl92c_llt_write(hw, i, (i + 1));
-		if (true != rst) {
+		if (!rst) {
 			pr_err("===> %s #3 fail\n", __func__);
 			return rst;
 		}
 	}
 	/* Let last entry point to the start entry of ring buffer */
 	rst = rtl92c_llt_write(hw, LLT_LAST_ENTRY_OF_TX_PKT_BUFFER, boundary);
-	if (true != rst) {
+	if (!rst) {
 		pr_err("===> %s #4 fail\n", __func__);
 		return rst;
 	}
--
2.26.0.106.g9fadedd

