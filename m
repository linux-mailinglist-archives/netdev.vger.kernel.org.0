Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54218CB67C
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 10:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731341AbfJDIg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 04:36:56 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:43414 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729994AbfJDIg4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 04:36:56 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C51DCDE0C2880A6A8D89;
        Fri,  4 Oct 2019 16:36:52 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Fri, 4 Oct 2019
 16:36:46 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <Larry.Finger@lwfinger.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH 8/8] rtlwifi: rtl8723: Remove set but not used variable 'own'
Date:   Fri, 4 Oct 2019 16:43:55 +0800
Message-ID: <1570178635-57582-9-git-send-email-zhengbin13@huawei.com>
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

drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c: In function rtl8723_cmd_send_packet:
drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c:226:5: warning: variable own set but not used [-Wunused-but-set-variable]

It is not used since commit f1d2b4d338bf ("rtlwifi:
rtl818x: Move drivers into new realtek directory")

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c
index 18ce285..37036e6 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c
@@ -223,7 +223,6 @@ bool rtl8723_cmd_send_packet(struct ieee80211_hw *hw,
 	struct rtl8192_tx_ring *ring;
 	struct rtl_tx_desc *pdesc;
 	struct sk_buff *pskb = NULL;
-	u8 own;
 	unsigned long flags;

 	ring = &rtlpci->tx_ring[BEACON_QUEUE];
@@ -233,9 +232,6 @@ bool rtl8723_cmd_send_packet(struct ieee80211_hw *hw,
 	spin_lock_irqsave(&rtlpriv->locks.irq_th_lock, flags);

 	pdesc = &ring->desc[0];
-	own = (u8)rtlpriv->cfg->ops->get_desc(hw, (u8 *)pdesc, true,
-					      HW_DESC_OWN);
-
 	rtlpriv->cfg->ops->fill_tx_cmddesc(hw, (u8 *)pdesc, 1, 1, skb);

 	__skb_queue_tail(&ring->queue, skb);
--
2.7.4

