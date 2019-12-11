Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D53C911B4A9
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 16:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388396AbfLKPso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 10:48:44 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39732 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387787AbfLKPsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 10:48:39 -0500
Received: by mail-wm1-f67.google.com with SMTP id d5so5948992wmb.4;
        Wed, 11 Dec 2019 07:48:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M7WbKpVa7YBzu+uEMBm4uH2YlentzYifl+jvtz9sZI8=;
        b=GLl7OYdyVOqJOXdJdJDBBBMF/qIehkMWMoR8aTWr59HCkn466SyzTBdRATzuRwi23X
         dbe5d2X4ZRY/gucvweNPVDvvu7zIx1sma/roGCFeaJpLhZo5N5Mu8cK1/n5Q2+R+Bwit
         PMR68JfRDKbqnKd8MabQzV0lEgOCUgcSPO5qF6c3fbgf+FX5WUOYx/O00+f79QxEwmaq
         Rts+gEukwH4fhmLhWSDINWVKBI/t0Wgr6+NNBnr1sM4PkoowtStgS3fsLhPcKjvsqBJj
         F/vn05BcstTTHZVAGqZra9682LHWyf+9GwBNcgHfbPIdHWi7l35Zm7tZUisTl3e1nL4P
         J3qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M7WbKpVa7YBzu+uEMBm4uH2YlentzYifl+jvtz9sZI8=;
        b=WNWnlgwyyz3QyYYMN14G59GDtFqLb6yyDv4ha0M6xCuUfTir6DkmbIMwuajhikbIcu
         6yblTAwI1qQBqhWM/cJtqRzeNJjGTpLw18nDSX47CLCyFGJU2oYA5fvh/+iJnfiuCsQQ
         Z5iSCIXGAzcrSYSqNeepPJgDLRIQaQXLqfvN24uB4C61Jwfy4P++UZSzCb3EQqdO8Cwy
         NpKYlcu2fqwsnLLpBM2D/H1tfPIQ90p3sE5WHrdtICFQGS5JsEsXv0p2DNONa39FzE0b
         p3M3hKzkRVxMqSos8TYSlze92eW0BpiKaHILVWL7whNHTs7Vz6uzJmX7nBPI7UnsTWCt
         j3hA==
X-Gm-Message-State: APjAAAWMGG0+6sKIUr2NgEsYm2C3nFB1RwKK1pigcUy+++gtv1KCTOqf
        p5Ph5/Et8OLln8O3FuIKv3jA3SwB
X-Google-Smtp-Source: APXvYqwyidIIr1JaTp9lVcN9cl+wvViecMLVjOQXQQr02X2ZWDqSMLFmsgVyaQQD8dQWmP2RLfFfWg==
X-Received: by 2002:a7b:c1cc:: with SMTP id a12mr466879wmj.53.1576079316572;
        Wed, 11 Dec 2019 07:48:36 -0800 (PST)
Received: from localhost.localdomain (dslb-002-204-142-082.002.204.pools.vodafone-ip.de. [2.204.142.82])
        by smtp.gmail.com with ESMTPSA id n16sm2677388wro.88.2019.12.11.07.48.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 07:48:36 -0800 (PST)
From:   Michael Straube <straube.linux@gmail.com>
To:     pkshih@realtek.com
Cc:     kvalo@codeaurora.org, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Straube <straube.linux@gmail.com>
Subject: [PATCH 5/6] rtlwifi: rtl8192cu: use generic rtl_signal_scale_mapping
Date:   Wed, 11 Dec 2019 16:47:54 +0100
Message-Id: <20191211154755.15012-6-straube.linux@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191211154755.15012-1-straube.linux@gmail.com>
References: <20191211154755.15012-1-straube.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function _rtl92c_signal_scale_mapping is identical to the generic
version rtl_signal_scale_mapping. Remove _rtl92c_signal_scale_mapping
and use the generic function.

Signed-off-by: Michael Straube <straube.linux@gmail.com>
---
 .../wireless/realtek/rtlwifi/rtl8192cu/mac.c  | 33 ++-----------------
 1 file changed, 2 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c
index c8652283a516..b4b67341dc83 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c
@@ -567,34 +567,6 @@ void rtl92c_set_min_space(struct ieee80211_hw *hw, bool is2T)
 
 /*==============================================================*/
 
-static long _rtl92c_signal_scale_mapping(struct ieee80211_hw *hw,
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
-	return retsig;
-}
-
 static void _rtl92c_query_rxphystatus(struct ieee80211_hw *hw,
 				      struct rtl_stats *pstats,
 				      struct rx_desc_92c *p_desc,
@@ -729,11 +701,10 @@ static void _rtl92c_query_rxphystatus(struct ieee80211_hw *hw,
 	}
 	if (is_cck_rate)
 		pstats->signalstrength =
-		    (u8) (_rtl92c_signal_scale_mapping(hw, pwdb_all));
+		    (u8)(rtl_signal_scale_mapping(hw, pwdb_all));
 	else if (rf_rx_num != 0)
 		pstats->signalstrength =
-		    (u8) (_rtl92c_signal_scale_mapping
-			  (hw, total_rssi /= rf_rx_num));
+		    (u8)(rtl_signal_scale_mapping(hw, total_rssi /= rf_rx_num));
 }
 
 void rtl92c_translate_rx_signal_stuff(struct ieee80211_hw *hw,
-- 
2.24.0

