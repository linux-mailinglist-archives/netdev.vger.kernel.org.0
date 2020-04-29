Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9980D1BE049
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 16:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbgD2OKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 10:10:19 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3341 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726691AbgD2OKT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 10:10:19 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C86CD686A7DCC01E1F55;
        Wed, 29 Apr 2020 22:10:12 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Wed, 29 Apr 2020
 22:09:58 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] rtlwifi: remove comparison of 0/1 to bool variable
Date:   Wed, 29 Apr 2020 22:09:24 +0800
Message-ID: <20200429140924.7750-1-yanaijie@huawei.com>
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

The variable 'rtlpriv->rfkill.rfkill_state' is bool and can directly
assigned to bool values.

Fix the following coccicheck warning:

drivers/net/wireless/realtek/rtlwifi/core.c:1725:14-42: WARNING:
Comparison of 0/1 to bool variable

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index f73e690bbe8e..4dd82c6052f0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -1722,7 +1722,7 @@ static void rtl_op_rfkill_poll(struct ieee80211_hw *hw)
 				 "wireless radio switch turned %s\n",
 				  radio_state ? "on" : "off");
 
-			blocked = (rtlpriv->rfkill.rfkill_state == 1) ? 0 : 1;
+			blocked = !rtlpriv->rfkill.rfkill_state;
 			wiphy_rfkill_set_hw_state(hw->wiphy, blocked);
 		}
 	}
-- 
2.21.1

