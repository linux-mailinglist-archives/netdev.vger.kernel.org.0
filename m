Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA26BCF0AD
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 03:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729518AbfJHByk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 21:54:40 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3265 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726917AbfJHByk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 21:54:40 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 1E106737AEDE40E00F7E;
        Tue,  8 Oct 2019 09:54:35 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Tue, 8 Oct 2019
 09:54:28 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH] rtlwifi: rtl8192ee: Remove set but not used variable 'cur_tx_wp'
Date:   Tue, 8 Oct 2019 10:01:40 +0800
Message-ID: <1570500100-61244-1-git-send-email-zhengbin13@huawei.com>
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

drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c: In function rtl92ee_is_tx_desc_closed:
drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c:1005:18: warning: variable cur_tx_wp set but not used [-Wunused-but-set-variable]

It is not used since commit cf54622c8076 ("rtlwifi:
cleanup the code that check whether TX ring is available")

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
index 27f1a63..92d514c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
@@ -1010,14 +1010,13 @@ bool rtl92ee_is_tx_desc_closed(struct ieee80211_hw *hw, u8 hw_queue, u16 index)
 	struct rtl8192_tx_ring *ring = &rtlpci->tx_ring[hw_queue];

 	{
-		u16 cur_tx_rp, cur_tx_wp;
+		u16 cur_tx_rp;
 		u32 tmpu32;

 		tmpu32 =
 		  rtl_read_dword(rtlpriv,
 				 get_desc_addr_fr_q_idx(hw_queue));
 		cur_tx_rp = (u16)((tmpu32 >> 16) & 0x0fff);
-		cur_tx_wp = (u16)(tmpu32 & 0x0fff);

 		/* don't need to update ring->cur_tx_wp */
 		ring->cur_tx_rp = cur_tx_rp;
--
2.7.4

