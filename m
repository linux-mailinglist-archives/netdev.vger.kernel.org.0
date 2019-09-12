Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE77B12F2
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 18:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733293AbfILQox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 12:44:53 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:53334 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727764AbfILQos (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Sep 2019 12:44:48 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 4F04B4D8D9060BE943DC;
        Fri, 13 Sep 2019 00:44:45 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.439.0; Fri, 13 Sep 2019 00:44:35 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <kvalo@codeaurora.org>
CC:     <davem@davemloft.net>, <zhongjiang@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] wlegacy: Remove unneeded variable and make function to be void
Date:   Fri, 13 Sep 2019 00:41:31 +0800
Message-ID: <1568306492-42998-3-git-send-email-zhongjiang@huawei.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1568306492-42998-1-git-send-email-zhongjiang@huawei.com>
References: <1568306492-42998-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

il4965_set_tkip_dynamic_key_info  do not need return value to
cope with different ases. And change functon return type to void.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/net/wireless/intel/iwlegacy/4965-mac.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/4965-mac.c b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
index ffb705b..a7bbfe2 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
@@ -3326,12 +3326,11 @@ struct il_mod_params il4965_mod_params = {
 	return il_send_add_sta(il, &sta_cmd, CMD_SYNC);
 }
 
-static int
+static void
 il4965_set_tkip_dynamic_key_info(struct il_priv *il,
 				 struct ieee80211_key_conf *keyconf, u8 sta_id)
 {
 	unsigned long flags;
-	int ret = 0;
 	__le16 key_flags = 0;
 
 	key_flags |= (STA_KEY_FLG_TKIP | STA_KEY_FLG_MAP_KEY_MSK);
@@ -3367,8 +3366,6 @@ struct il_mod_params il4965_mod_params = {
 	memcpy(il->stations[sta_id].sta.key.key, keyconf->key, 16);
 
 	spin_unlock_irqrestore(&il->sta_lock, flags);
-
-	return ret;
 }
 
 void
@@ -3483,8 +3480,7 @@ struct il_mod_params il4965_mod_params = {
 		    il4965_set_ccmp_dynamic_key_info(il, keyconf, sta_id);
 		break;
 	case WLAN_CIPHER_SUITE_TKIP:
-		ret =
-		    il4965_set_tkip_dynamic_key_info(il, keyconf, sta_id);
+		il4965_set_tkip_dynamic_key_info(il, keyconf, sta_id);
 		break;
 	case WLAN_CIPHER_SUITE_WEP40:
 	case WLAN_CIPHER_SUITE_WEP104:
-- 
1.7.12.4

