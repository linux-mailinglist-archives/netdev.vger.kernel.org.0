Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8EACCB68C
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 10:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730921AbfJDIgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 04:36:55 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:43410 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728942AbfJDIgy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 04:36:54 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C027CBDCC17437E731EA;
        Fri,  4 Oct 2019 16:36:52 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Fri, 4 Oct 2019
 16:36:45 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <Larry.Finger@lwfinger.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH 5/8] rtlwifi: rtl8188ee: Remove set but not used variable 'h2c_parameter'
Date:   Fri, 4 Oct 2019 16:43:52 +0800
Message-ID: <1570178635-57582-6-git-send-email-zhengbin13@huawei.com>
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

drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c: In function rtl88e_dm_pwdb_monitor:
drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c:763:6: warning: variable h2c_parameter set but not used [-Wunused-but-set-variable]

It is not used since commit f1d2b4d338bf ("rtlwifi:
rtl818x: Move drivers into new realtek directory")

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c
index 333e355..dceb04a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c
@@ -759,14 +759,8 @@ static void rtl88e_dm_pwdb_monitor(struct ieee80211_hw *hw)
 		rtlpriv->dm.entry_min_undec_sm_pwdb = 0;
 	}
 	/* Indicate Rx signal strength to FW. */
-	if (rtlpriv->dm.useramask) {
-		u8 h2c_parameter[3] = { 0 };
-
-		h2c_parameter[2] = (u8)(rtlpriv->dm.undec_sm_pwdb & 0xFF);
-		h2c_parameter[0] = 0x20;
-	} else {
+	if (!rtlpriv->dm.useramask)
 		rtl_write_byte(rtlpriv, 0x4fe, rtlpriv->dm.undec_sm_pwdb);
-	}
 }

 void rtl88e_dm_init_edca_turbo(struct ieee80211_hw *hw)
--
2.7.4

