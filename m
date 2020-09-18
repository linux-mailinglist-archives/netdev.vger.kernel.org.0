Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2005126FA51
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 12:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbgIRKS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 06:18:29 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56608 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726682AbgIRKS2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 06:18:28 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 322BFC70EA387288DC57;
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
Subject: [PATCH -next 8/9] rtlwifi: rtl8192de: fix comparison to bool warning in hw.c
Date:   Fri, 18 Sep 2020 18:25:04 +0800
Message-ID: <20200918102505.16036-9-zhengbin13@huawei.com>
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

drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c:566:14-20: WARNING: Comparison to bool
drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c:572:13-19: WARNING: Comparison to bool
drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c:581:14-20: WARNING: Comparison to bool
drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c:587:13-19: WARNING: Comparison to bool

Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
index 2deadc7339ce..f849291cc587 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
@@ -563,13 +563,13 @@ static bool _rtl92de_llt_table_init(struct ieee80211_hw *hw)
 	/* 18.  LLT_table_init(Adapter);  */
 	for (i = 0; i < (txpktbuf_bndy - 1); i++) {
 		status = _rtl92de_llt_write(hw, i, i + 1);
-		if (true != status)
+		if (!status)
 			return status;
 	}

 	/* end of list */
 	status = _rtl92de_llt_write(hw, (txpktbuf_bndy - 1), 0xFF);
-	if (true != status)
+	if (!status)
 		return status;

 	/* Make the other pages as ring buffer */
@@ -578,13 +578,13 @@ static bool _rtl92de_llt_table_init(struct ieee80211_hw *hw)
 	/* Otherwise used as local loopback buffer.  */
 	for (i = txpktbuf_bndy; i < maxpage; i++) {
 		status = _rtl92de_llt_write(hw, i, (i + 1));
-		if (true != status)
+		if (!status)
 			return status;
 	}

 	/* Let last entry point to the start entry of ring buffer */
 	status = _rtl92de_llt_write(hw, maxpage, txpktbuf_bndy);
-	if (true != status)
+	if (!status)
 		return status;

 	return true;
--
2.26.0.106.g9fadedd

