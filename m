Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14CDA11B4B1
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 16:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388681AbfLKPtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 10:49:13 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53038 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732673AbfLKPsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 10:48:35 -0500
Received: by mail-wm1-f68.google.com with SMTP id p9so7639330wmc.2;
        Wed, 11 Dec 2019 07:48:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C9m088SAYQmhRl4obMqPAQXfSLnOFVuekwVkFXaFEP0=;
        b=d/dm7nwPZT6OwN3imVmFmjIsiVH3322UofPrAtVrN0xcvLPlGMrcwaOU59r0ZGCZ4Z
         0pZsmKKMBnHLCcVtrUmlLKxx5CJm3Xoa2zeISbFVZpiYGrQi3AZd8FA3bTOSZ1+rNTxF
         91LBRp4stM+vO4lKBgKVPMaXPCvfv9vBnDY8NDeN24+eW7Jy5M/7JHOOnugtoOWDxNYL
         nnhkzsRJSO/xEjZmBzPtIB79FPrjaqmtK9KTucsg6fQ5NGRr++k8byKkXjTIvAsjiMCK
         DE6/9aiwyUUJn69j4sBAPqshMNF4kzXXMsMHT5Q7lsXmEgUncUbMT6I3pKlk+aE+Mj2Z
         D3cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C9m088SAYQmhRl4obMqPAQXfSLnOFVuekwVkFXaFEP0=;
        b=m99abQb32qw8/4rTCvLvrBSqu8pi6IQLrVzVJUE77vMknPBhvdjfMBSgOS5Nca8zAA
         xSGul8H5S/4C7yGcDGbYcvq9SE2GcDJzNSmCRfgxNtCqvMbRtviGnFZIMRH6+PO4JWvs
         R4Q5RRjJT+wpqh11uD0hnbJY7TI+14W89xMGeeFCj4QSswmDNjs/Dbef86MWarbpWa9O
         mMWs5CdegNabHZIFkZkqg3c6FXFjF38KzjtI1AquCYccd4Rk/EVqrJA0AxMcID5XTgp5
         uFm0zHxbSmRP/xkgJhWfqc5W9FHIUjgNKVpCaBCR0VIF8EChzdzCz4Jq9HNGhuuA+Qk8
         v7ZA==
X-Gm-Message-State: APjAAAVI6sfTBkBnwO9X/Xsgn54AGFPE0PA7MrqSSbL1K7yf3NBzPzC7
        BmCW3nP88cPzZva9dVpwEk8=
X-Google-Smtp-Source: APXvYqzoAbn9+TS92EG8pFC2srLWZ/weCFBlV1HJnvivHfj4/iW+yQqjp5dWtbDaFB7jXWjR+gzHeg==
X-Received: by 2002:a1c:e909:: with SMTP id q9mr573933wmc.30.1576079313173;
        Wed, 11 Dec 2019 07:48:33 -0800 (PST)
Received: from localhost.localdomain (dslb-002-204-142-082.002.204.pools.vodafone-ip.de. [2.204.142.82])
        by smtp.gmail.com with ESMTPSA id n16sm2677388wro.88.2019.12.11.07.48.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 07:48:32 -0800 (PST)
From:   Michael Straube <straube.linux@gmail.com>
To:     pkshih@realtek.com
Cc:     kvalo@codeaurora.org, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Straube <straube.linux@gmail.com>
Subject: [PATCH 2/6] rtlwifi: rtl8192cu: use generic rtl_query_rxpwrpercentage
Date:   Wed, 11 Dec 2019 16:47:51 +0100
Message-Id: <20191211154755.15012-3-straube.linux@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191211154755.15012-1-straube.linux@gmail.com>
References: <20191211154755.15012-1-straube.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function _rtl92c_query_rxpwrpercentage is identical to the generic
version rtl_query_rxpwrpercentage. Remove _rtl92c_query_rxpwrpercentage
and use the generic function.

Signed-off-by: Michael Straube <straube.linux@gmail.com>
---
 .../net/wireless/realtek/rtlwifi/rtl8192cu/mac.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c
index cec19b32c7e2..c8652283a516 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c
@@ -567,16 +567,6 @@ void rtl92c_set_min_space(struct ieee80211_hw *hw, bool is2T)
 
 /*==============================================================*/
 
-static u8 _rtl92c_query_rxpwrpercentage(s8 antpower)
-{
-	if ((antpower <= -100) || (antpower >= 20))
-		return 0;
-	else if (antpower >= 0)
-		return 100;
-	else
-		return 100 + antpower;
-}
-
 static long _rtl92c_signal_scale_mapping(struct ieee80211_hw *hw,
 		long currsig)
 {
@@ -678,7 +668,7 @@ static void _rtl92c_query_rxphystatus(struct ieee80211_hw *hw,
 				break;
 			}
 		}
-		pwdb_all = _rtl92c_query_rxpwrpercentage(rx_pwr_all);
+		pwdb_all = rtl_query_rxpwrpercentage(rx_pwr_all);
 		pstats->rx_pwdb_all = pwdb_all;
 		pstats->recvsignalpower = rx_pwr_all;
 		if (packet_match_bssid) {
@@ -707,7 +697,7 @@ static void _rtl92c_query_rxphystatus(struct ieee80211_hw *hw,
 				rf_rx_num++;
 			rx_pwr[i] =
 			    ((p_drvinfo->gain_trsw[i] & 0x3f) * 2) - 110;
-			rssi = _rtl92c_query_rxpwrpercentage(rx_pwr[i]);
+			rssi = rtl_query_rxpwrpercentage(rx_pwr[i]);
 			total_rssi += rssi;
 			rtlpriv->stats.rx_snr_db[i] =
 			    (long)(p_drvinfo->rxsnr[i] / 2);
@@ -716,7 +706,7 @@ static void _rtl92c_query_rxphystatus(struct ieee80211_hw *hw,
 				pstats->rx_mimo_signalstrength[i] = (u8) rssi;
 		}
 		rx_pwr_all = ((p_drvinfo->pwdb_all >> 1) & 0x7f) - 110;
-		pwdb_all = _rtl92c_query_rxpwrpercentage(rx_pwr_all);
+		pwdb_all = rtl_query_rxpwrpercentage(rx_pwr_all);
 		pstats->rx_pwdb_all = pwdb_all;
 		pstats->rxpower = rx_pwr_all;
 		pstats->recvsignalpower = rx_pwr_all;
-- 
2.24.0

