Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE4C512A1FB
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 15:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbfLXOJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 09:09:03 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:50220 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726184AbfLXOJA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Dec 2019 09:09:00 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id A6175A19D7FDE83FE0D3;
        Tue, 24 Dec 2019 22:08:55 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Tue, 24 Dec 2019
 22:08:47 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <yhchuang@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH -next 5/6] wil6210: use true,false for bool variable
Date:   Tue, 24 Dec 2019 22:16:05 +0800
Message-ID: <1577196966-84926-6-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1577196966-84926-1-git-send-email-zhengbin13@huawei.com>
References: <1577196966-84926-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes coccicheck warning:

drivers/net/wireless/ath/wil6210/main.c:765:1-14: WARNING: Assignment of 0/1 to bool variable
drivers/net/wireless/ath/wil6210/txrx.c:1143:1-19: WARNING: Assignment of 0/1 to bool variable
drivers/net/wireless/ath/wil6210/wmi.c:1516:4-23: WARNING: Assignment of 0/1 to bool variable
drivers/net/wireless/ath/wil6210/wmi.c:1523:4-23: WARNING: Assignment of 0/1 to bool variable
drivers/net/wireless/ath/wil6210/wmi.c:1538:4-30: WARNING: Assignment of 0/1 to bool variable
drivers/net/wireless/ath/wil6210/wmi.c:1545:4-30: WARNING: Assignment of 0/1 to bool variable

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 2 +-
 drivers/net/wireless/ath/wil6210/txrx.c | 2 +-
 drivers/net/wireless/ath/wil6210/wmi.c  | 8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 6d39547..3ba5b25 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -762,7 +762,7 @@ int wil_priv_init(struct wil6210_priv *wil)
 	 */
 	wil->rx_buff_id_count = WIL_RX_BUFF_ARR_SIZE_DEFAULT;

-	wil->amsdu_en = 1;
+	wil->amsdu_en = true;

 	return 0;

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 17118d6..bc8c15f 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -1140,7 +1140,7 @@ static int wil_tx_desc_map(union wil_tx_desc *desc, dma_addr_t pa,
 void wil_tx_data_init(struct wil_ring_tx_data *txdata)
 {
 	spin_lock_bh(&txdata->lock);
-	txdata->dot1x_open = 0;
+	txdata->dot1x_open = false;
 	txdata->enabled = 0;
 	txdata->idle = 0;
 	txdata->last_idle = 0;
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index dcba0a4..23e1ed6 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -1513,14 +1513,14 @@ static void wmi_link_stats_parse(struct wil6210_vif *vif, u64 tsf,
 			if (vif->fw_stats_ready) {
 				/* clean old statistics */
 				vif->fw_stats_tsf = 0;
-				vif->fw_stats_ready = 0;
+				vif->fw_stats_ready = false;
 			}

 			wil_link_stats_store_basic(vif, payload + hdr_size);

 			if (!has_next) {
 				vif->fw_stats_tsf = tsf;
-				vif->fw_stats_ready = 1;
+				vif->fw_stats_ready = true;
 			}

 			break;
@@ -1535,14 +1535,14 @@ static void wmi_link_stats_parse(struct wil6210_vif *vif, u64 tsf,
 			if (wil->fw_stats_global.ready) {
 				/* clean old statistics */
 				wil->fw_stats_global.tsf = 0;
-				wil->fw_stats_global.ready = 0;
+				wil->fw_stats_global.ready = false;
 			}

 			wil_link_stats_store_global(vif, payload + hdr_size);

 			if (!has_next) {
 				wil->fw_stats_global.tsf = tsf;
-				wil->fw_stats_global.ready = 1;
+				wil->fw_stats_global.ready = true;
 			}

 			break;
--
2.7.4

