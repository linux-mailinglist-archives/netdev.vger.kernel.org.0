Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDE511B4A4
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 16:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388160AbfLKPsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 10:48:40 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38079 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387642AbfLKPsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 10:48:37 -0500
Received: by mail-wm1-f65.google.com with SMTP id p17so7482798wmi.3;
        Wed, 11 Dec 2019 07:48:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tJ9GgmN6U03hXpj95yNvwg3ura76vS0QtmHZxEuQ1r8=;
        b=bCfc0N8TD8ThkdO45KdNSqrYXfycHCcZDi7Lq64aG9VSkqQbCEgbJkMiNfqhyyusKK
         8wWDExidv6xKTJsiCBf+W26UHLE5MHz/J7OJkS3On9ARjNHGxnhY/ja+jhYPKPwJlpPh
         /D8C26QjRXCAym+/X5L3wgY27XdoMUXQpVeypEreDqVSoceoZz9r3anrXlbafGYXyKkH
         Y0O18Tymasb56Xa+x6WzuRsIEUxeIraCMUpgIaA+Fw+AcVypuWuPWAWFI65DEOXtzV5d
         0C8iBPIT/rhASGLUfsfLufDzNEKHllqWwKL//RbYcoy0hYeKohoe/mWCQ0Ri482YSnxn
         aD/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tJ9GgmN6U03hXpj95yNvwg3ura76vS0QtmHZxEuQ1r8=;
        b=GHFjANXL+y05aF6DBQTDq946cEJWZd/jMDlVI4lS9wdkN3xQY3RFPAFY1vLwePqSp6
         DP7oDI1SlbLc4bUveefTYI33xJ1TzZXPZHuTZVATQI3JORoZqkLWL6siqftLLuFUQwcC
         kbB0oNIz515yP0/XV9ra86gz9FLfdvR+i5BSUfa9Ak8K68ps/a2O+OzAF2yBhk3VgbG3
         THU/59prEqwu/VqktW657UefF5hsBwoyyLM0vg/hTUDTtlwscLK2ZN7gymhryxqHvJlF
         AyPAQdAFkt1AlAxxxv3bsRslQnBunUmxUArPUO7sSJcmkhnnCoZStiw9mN1EuLLt6W1W
         4NdQ==
X-Gm-Message-State: APjAAAXh4stYGTxj1BZsXdrc2kjLe3n+cwu80WKwY7b/6dWhkUape9Dh
        qr+hG6JosgOeRmbUWVoLqF4=
X-Google-Smtp-Source: APXvYqwmp7N+PjJmu1C3SaKII8d3PVKdPJXNac+V3JaWw91A4TjC9Y+sti0/v02A0Ry18NHnqOPFmg==
X-Received: by 2002:a7b:c552:: with SMTP id j18mr476461wmk.123.1576079315614;
        Wed, 11 Dec 2019 07:48:35 -0800 (PST)
Received: from localhost.localdomain (dslb-002-204-142-082.002.204.pools.vodafone-ip.de. [2.204.142.82])
        by smtp.gmail.com with ESMTPSA id n16sm2677388wro.88.2019.12.11.07.48.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 07:48:35 -0800 (PST)
From:   Michael Straube <straube.linux@gmail.com>
To:     pkshih@realtek.com
Cc:     kvalo@codeaurora.org, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Straube <straube.linux@gmail.com>
Subject: [PATCH 4/6] rtlwifi: rtl8192ce: use generic rtl_signal_scale_mapping
Date:   Wed, 11 Dec 2019 16:47:53 +0100
Message-Id: <20191211154755.15012-5-straube.linux@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191211154755.15012-1-straube.linux@gmail.com>
References: <20191211154755.15012-1-straube.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function _rtl92ce_signal_scale_mapping is identical to the generic
version rtl_signal_scale_mapping. Remove _rtl92ce_signal_scale_mapping
and use the generic function.

Signed-off-by: Michael Straube <straube.linux@gmail.com>
---
 .../wireless/realtek/rtlwifi/rtl8192ce/trx.c  | 34 ++-----------------
 1 file changed, 2 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
index dec66b3ac365..8fc3cb824066 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
@@ -23,35 +23,6 @@ static u8 _rtl92ce_map_hwqueue_to_fwqueue(struct sk_buff *skb, u8 hw_queue)
 	return skb->priority;
 }
 
-static long _rtl92ce_signal_scale_mapping(struct ieee80211_hw *hw,
-		long currsig)
-{
-	long retsig;
-
-	if (currsig >= 61 && currsig <= 100)
-		retsig = 90 + ((currsig - 60) / 4);
-	else if (currsig >= 41 && currsig <= 60)
-		retsig = 78 + ((currsig - 40) / 2);
-	else if (currsig >= 31 && currsig <= 40)
-		retsig = 66 + (currsig - 30);
-	else if (currsig >= 21 && currsig <= 30)
-		retsig = 54 + (currsig - 20);
-	else if (currsig >= 5 && currsig <= 20)
-		retsig = 42 + (((currsig - 5) * 2) / 3);
-	else if (currsig == 4)
-		retsig = 36;
-	else if (currsig == 3)
-		retsig = 27;
-	else if (currsig == 2)
-		retsig = 18;
-	else if (currsig == 1)
-		retsig = 9;
-	else
-		retsig = currsig;
-
-	return retsig;
-}
-
 static void _rtl92ce_query_rxphystatus(struct ieee80211_hw *hw,
 				       struct rtl_stats *pstats,
 				       struct rx_desc_92c *pdesc,
@@ -231,11 +202,10 @@ static void _rtl92ce_query_rxphystatus(struct ieee80211_hw *hw,
 	 */
 	if (is_cck_rate)
 		pstats->signalstrength =
-		    (u8)(_rtl92ce_signal_scale_mapping(hw, pwdb_all));
+		    (u8)(rtl_signal_scale_mapping(hw, pwdb_all));
 	else if (rf_rx_num != 0)
 		pstats->signalstrength =
-		    (u8)(_rtl92ce_signal_scale_mapping
-			  (hw, total_rssi /= rf_rx_num));
+		    (u8)(rtl_signal_scale_mapping(hw, total_rssi /= rf_rx_num));
 }
 
 static void _rtl92ce_translate_rx_signal_stuff(struct ieee80211_hw *hw,
-- 
2.24.0

