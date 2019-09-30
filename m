Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 420C0C1D61
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 10:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730224AbfI3IsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 04:48:14 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3186 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729899AbfI3IsN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Sep 2019 04:48:13 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 46C27C786ED6CAB8386C;
        Mon, 30 Sep 2019 16:48:09 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Mon, 30 Sep 2019
 16:48:00 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH 3/6] rtlwifi: rtl8192ee: Remove set but not used variable 'err'
Date:   Mon, 30 Sep 2019 16:54:49 +0800
Message-ID: <1569833692-93288-4-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1569833692-93288-1-git-send-email-zhengbin13@huawei.com>
References: <1569833692-93288-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c: In function rtl92ee_download_fw:
drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c:111:6: warning: variable err set but not used [-Wunused-but-set-variable]

It is not used since commit c93ac39da006 ("rtlwifi:
Remove some redundant code")

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
index 67305ce..322798c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
@@ -108,7 +108,6 @@ int rtl92ee_download_fw(struct ieee80211_hw *hw, bool buse_wake_on_wlan_fw)
 	struct rtlwifi_firmware_header *pfwheader;
 	u8 *pfwdata;
 	u32 fwsize;
-	int err;
 	enum version_8192e version = rtlhal->version;

 	if (!rtlhal->pfirmware)
@@ -146,7 +145,7 @@ int rtl92ee_download_fw(struct ieee80211_hw *hw, bool buse_wake_on_wlan_fw)
 	_rtl92ee_write_fw(hw, version, pfwdata, fwsize);
 	_rtl92ee_enable_fw_download(hw, false);

-	err = _rtl92ee_fw_free_to_go(hw);
+	(void)_rtl92ee_fw_free_to_go(hw);

 	return 0;
 }
--
2.7.4

