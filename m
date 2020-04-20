Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C17311B005C
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 06:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbgDTEA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 00:00:28 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2805 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725681AbgDTEA2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 00:00:28 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 27E02A16B7C134081862;
        Mon, 20 Apr 2020 12:00:25 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Mon, 20 Apr 2020
 12:00:16 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <yanaijie@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] rtlwifi: rtl8723ae: fix warning comparison to bool
Date:   Mon, 20 Apr 2020 12:26:58 +0800
Message-ID: <20200420042658.18733-1-yanaijie@huawei.com>
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

drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c:617:14-20: WARNING:
Comparison to bool
drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c:622:13-19: WARNING:
Comparison to bool
drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c:627:14-20: WARNING:
Comparison to bool
drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c:632:13-19: WARNING:
Comparison to bool
drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c:937:5-13: WARNING:
Comparison to bool

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
index 655460f61bbc..7a46c6a9deae 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
@@ -614,22 +614,22 @@ static bool _rtl8723e_llt_table_init(struct ieee80211_hw *hw)
 
 	for (i = 0; i < (txpktbuf_bndy - 1); i++) {
 		status = _rtl8723e_llt_write(hw, i, i + 1);
-		if (true != status)
+		if (!status)
 			return status;
 	}
 
 	status = _rtl8723e_llt_write(hw, (txpktbuf_bndy - 1), 0xFF);
-	if (true != status)
+	if (!status)
 		return status;
 
 	for (i = txpktbuf_bndy; i < maxpage; i++) {
 		status = _rtl8723e_llt_write(hw, i, (i + 1));
-		if (true != status)
+		if (!status)
 			return status;
 	}
 
 	status = _rtl8723e_llt_write(hw, maxpage, txpktbuf_bndy);
-	if (true != status)
+	if (!status)
 		return status;
 
 	rtl_write_byte(rtlpriv, REG_CR, 0xff);
@@ -934,7 +934,7 @@ int rtl8723e_hw_init(struct ieee80211_hw *hw)
 
 	rtlpriv->intf_ops->disable_aspm(hw);
 	rtstatus = _rtl8712e_init_mac(hw);
-	if (rtstatus != true) {
+	if (!rtstatus) {
 		pr_err("Init MAC failed\n");
 		err = 1;
 		goto exit;
-- 
2.21.1

