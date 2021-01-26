Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C18A2304452
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 18:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390208AbhAZIeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 03:34:01 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:51621 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390159AbhAZIda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 03:33:30 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UMxkBnT_1611649917;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0UMxkBnT_1611649917)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 26 Jan 2021 16:32:13 +0800
From:   Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
To:     kvalo@codeaurora.org
Cc:     pkshih@realtek.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH v3] rtlwifi: Simplify bool comparison
Date:   Tue, 26 Jan 2021 16:31:56 +0800
Message-Id: <1611649916-21936-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:
./drivers/net/wireless/realtek/rtlwifi/ps.c:798:7-21: WARNING:
Comparison to bool
./drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c:3848:7-17:
WARNING: Comparison of 0/1 to bool variable

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
---

Changes in v3:
-modify email address to a unique one
-modify subject prefix to "rtlwifi"
-merge this patch with another patch 

 drivers/net/wireless/realtek/rtlwifi/ps.c            | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/ps.c b/drivers/net/wireless/realtek/rtlwifi/ps.c
index f9988225..629c032 100644
--- a/drivers/net/wireless/realtek/rtlwifi/ps.c
+++ b/drivers/net/wireless/realtek/rtlwifi/ps.c
@@ -798,9 +798,9 @@ static void rtl_p2p_noa_ie(struct ieee80211_hw *hw, void *data,
 		ie += 3 + noa_len;
 	}
 
-	if (find_p2p_ie == true) {
+	if (find_p2p_ie) {
 		if ((p2pinfo->p2p_ps_mode > P2P_PS_NONE) &&
-		    (find_p2p_ps_ie == false))
+		    (!find_p2p_ps_ie))
 			rtl_p2p_ps_cmd(hw, P2P_PS_DISABLE);
 	}
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
index 372d6f8..1fb857c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -3848,7 +3848,7 @@ static void _rtl8821ae_iqk_tx(struct ieee80211_hw *hw, enum radio_path path)
 			else
 				rtl_write_dword(rtlpriv, 0xc8c, 0x00163e96);
 
-			if (vdf_enable == 1) {
+			if (vdf_enable) {
 				rtl_dbg(rtlpriv, COMP_IQK, DBG_LOUD, "VDF_enable\n");
 				for (k = 0; k <= 2; k++) {
 					switch (k) {
-- 
1.8.3.1

