Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4767352E07
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 19:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235786AbhDBRJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 13:09:45 -0400
Received: from smtp01.smtpout.orange.fr ([80.12.242.123]:26621 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235392AbhDBRJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 13:09:44 -0400
Received: from localhost.localdomain ([90.126.11.170])
        by mwinf5d54 with ME
        id nt9d2400h3g7mfN03t9eFj; Fri, 02 Apr 2021 19:09:40 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 02 Apr 2021 19:09:40 +0200
X-ME-IP: 90.126.11.170
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] rtlwifi: remove rtl_get_tid_h
Date:   Fri,  2 Apr 2021 19:09:35 +0200
Message-Id: <db340a67a95c119e4f9ba8fa99aea1c73d0dcfc9.1617383263.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'rtl_get_tid_h()' is the same as 'ieee80211_get_tid()'.
So this function can be removed to save a line of code.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/wireless/realtek/rtlwifi/wifi.h | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index fdccfd29fd61..9119144bb5a3 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -3086,14 +3086,9 @@ static inline __le16 rtl_get_fc(struct sk_buff *skb)
 	return rtl_get_hdr(skb)->frame_control;
 }
 
-static inline u16 rtl_get_tid_h(struct ieee80211_hdr *hdr)
-{
-	return (ieee80211_get_qos_ctl(hdr))[0] & IEEE80211_QOS_CTL_TID_MASK;
-}
-
 static inline u16 rtl_get_tid(struct sk_buff *skb)
 {
-	return rtl_get_tid_h(rtl_get_hdr(skb));
+	return ieee80211_get_tid(rtl_get_hdr(skb));
 }
 
 static inline struct ieee80211_sta *get_sta(struct ieee80211_hw *hw,
-- 
2.27.0

