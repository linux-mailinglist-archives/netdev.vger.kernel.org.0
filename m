Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 178A926FA63
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 12:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgIRKSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 06:18:47 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56580 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726533AbgIRKSZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 06:18:25 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 27BF4E6DBB8D80B0B27B;
        Fri, 18 Sep 2020 18:18:20 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Fri, 18 Sep 2020
 18:18:13 +0800
From:   Zheng Bin <zhengbin13@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH -next 7/9] rtlwifi: rtl8192ce: fix comparison to bool warning in hw.c
Date:   Fri, 18 Sep 2020 18:25:03 +0800
Message-ID: <20200918102505.16036-8-zhengbin13@huawei.com>
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

drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c:616:14-20: WARNING: Comparison to bool
drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c:621:13-19: WARNING: Comparison to bool
drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c:626:14-20: WARNING: Comparison to bool
drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c:631:13-19: WARNING: Comparison to bool

Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
index d4cd186036fd..bb5a0c4aec93 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
@@ -613,22 +613,22 @@ static bool _rtl92ce_llt_table_init(struct ieee80211_hw *hw)

 	for (i = 0; i < (txpktbuf_bndy - 1); i++) {
 		status = _rtl92ce_llt_write(hw, i, i + 1);
-		if (true != status)
+		if (!status)
 			return status;
 	}

 	status = _rtl92ce_llt_write(hw, (txpktbuf_bndy - 1), 0xFF);
-	if (true != status)
+	if (!status)
 		return status;

 	for (i = txpktbuf_bndy; i < maxpage; i++) {
 		status = _rtl92ce_llt_write(hw, i, (i + 1));
-		if (true != status)
+		if (!status)
 			return status;
 	}

 	status = _rtl92ce_llt_write(hw, maxpage, txpktbuf_bndy);
-	if (true != status)
+	if (!status)
 		return status;

 	return true;
--
2.26.0.106.g9fadedd

