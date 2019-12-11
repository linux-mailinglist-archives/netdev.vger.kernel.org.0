Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65D3A11B4A8
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 16:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388341AbfLKPsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 10:48:43 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55244 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733285AbfLKPsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 10:48:37 -0500
Received: by mail-wm1-f67.google.com with SMTP id b11so7637503wmj.4;
        Wed, 11 Dec 2019 07:48:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=75Og2PgxTcMUhS7+nyHAmRRnlhdiala21Qw5AEaCLOU=;
        b=GVBh/bVBnOXig14DsIcX0JQX0jmfwGWLA4DfBfEzlU/ONm/GMm2CtBowHCdUmGZSzp
         mUw8u8jJOZBtqXgX1EnnzEdvF4oTqZ8LCw4X2t3/90+cuVzirPcZqq6bF3zcVZOFYM1/
         wC5FT05uAJl7QtNxZZO978r2tmBgjbrQkdw1ZXfpRh3mwHwb5+HCaP/CmuYvO8d2jmgU
         z4z4vcjgzKfF0mrJ3xB6sGHeBEAw+qE49NgKO5mYzNyFW7TY+V1a6J3YmmZ/u0Mm7SE4
         f00qw8RPWB+VH+LXnHr+HQJC5wVkbQFqGMkYP0pbMvzh51AVfNW4omp9zpvrzmvbyoow
         PUnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=75Og2PgxTcMUhS7+nyHAmRRnlhdiala21Qw5AEaCLOU=;
        b=a/jfd6tsYr3LqrJgw3B5j8mpQpBs+8oTnHN0Ws8d1bPlcLuYld1clFGykQYxZHOlL3
         ysAKPHG4vel6Ne6RIu5QbuwPO2iAFeGX9QkGxJvjhnuaEcBi7OE2KLr6Jh/J14CTHsHM
         23HD20lZIH35Spe4yH36pW87EUNVp46xVTq2ba8fKi8LXGD3MHKfhrlKtuxWzk5+vDBg
         U969sjI20p1wFETvCEfu8caxnQQ3ObknqU0lLbLFLJZVeGPnH9BnLtRA68B/kzAoj+ja
         9i8BHhORL4GlQn3mBoSmIoMROOSJKPNaEwqcDiisQ2NEWONaGELL4lq5AU5xEiiOuNd/
         P13Q==
X-Gm-Message-State: APjAAAUymSfxLDiMQWjo064fDnHqSAX+fQ4eHfAq/OIRKz0NurUz2H1b
        RDrgkqOtVN2UGJCLFWLnvrQ=
X-Google-Smtp-Source: APXvYqz8MitotPjFdulow2qRETyIjAHEcrSmEewJj51115gA898L1NOuqch/mbKBXpkxm/o62FWORQ==
X-Received: by 2002:a1c:7419:: with SMTP id p25mr444983wmc.129.1576079314633;
        Wed, 11 Dec 2019 07:48:34 -0800 (PST)
Received: from localhost.localdomain (dslb-002-204-142-082.002.204.pools.vodafone-ip.de. [2.204.142.82])
        by smtp.gmail.com with ESMTPSA id n16sm2677388wro.88.2019.12.11.07.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 07:48:34 -0800 (PST)
From:   Michael Straube <straube.linux@gmail.com>
To:     pkshih@realtek.com
Cc:     kvalo@codeaurora.org, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Straube <straube.linux@gmail.com>
Subject: [PATCH 3/6] rtlwifi: rtl8192de: use generic rtl_query_rxpwrpercentage
Date:   Wed, 11 Dec 2019 16:47:52 +0100
Message-Id: <20191211154755.15012-4-straube.linux@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191211154755.15012-1-straube.linux@gmail.com>
References: <20191211154755.15012-1-straube.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function _rtl92d_query_rxpwrpercentage is identical to the generic
version rtl_query_rxpwrpercentage. Remove _rtl92d_query_rxpwrpercentage
and use the generic function.

Signed-off-by: Michael Straube <straube.linux@gmail.com>
---
 .../net/wireless/realtek/rtlwifi/rtl8192de/trx.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
index 92c9fb45f800..abb35d33cf69 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
@@ -23,16 +23,6 @@ static u8 _rtl92de_map_hwqueue_to_fwqueue(struct sk_buff *skb, u8 hw_queue)
 	return skb->priority;
 }
 
-static u8 _rtl92d_query_rxpwrpercentage(s8 antpower)
-{
-	if ((antpower <= -100) || (antpower >= 20))
-		return 0;
-	else if (antpower >= 0)
-		return 100;
-	else
-		return 100 + antpower;
-}
-
 static long _rtl92de_translate_todbm(struct ieee80211_hw *hw,
 				     u8 signal_strength_index)
 {
@@ -141,7 +131,7 @@ static void _rtl92de_query_rxphystatus(struct ieee80211_hw *hw,
 				break;
 			}
 		}
-		pwdb_all = _rtl92d_query_rxpwrpercentage(rx_pwr_all);
+		pwdb_all = rtl_query_rxpwrpercentage(rx_pwr_all);
 		/* CCK gain is smaller than OFDM/MCS gain,  */
 		/* so we add gain diff by experiences, the val is 6 */
 		pwdb_all += 6;
@@ -183,7 +173,7 @@ static void _rtl92de_query_rxphystatus(struct ieee80211_hw *hw,
 				rf_rx_num++;
 			rx_pwr[i] = ((p_drvinfo->gain_trsw[i] & 0x3f) * 2)
 				    - 110;
-			rssi = _rtl92d_query_rxpwrpercentage(rx_pwr[i]);
+			rssi = rtl_query_rxpwrpercentage(rx_pwr[i]);
 			total_rssi += rssi;
 			rtlpriv->stats.rx_snr_db[i] =
 					 (long)(p_drvinfo->rxsnr[i] / 2);
@@ -191,7 +181,7 @@ static void _rtl92de_query_rxphystatus(struct ieee80211_hw *hw,
 				pstats->rx_mimo_signalstrength[i] = (u8) rssi;
 		}
 		rx_pwr_all = ((p_drvinfo->pwdb_all >> 1) & 0x7f) - 106;
-		pwdb_all = _rtl92d_query_rxpwrpercentage(rx_pwr_all);
+		pwdb_all = rtl_query_rxpwrpercentage(rx_pwr_all);
 		pstats->rx_pwdb_all = pwdb_all;
 		pstats->rxpower = rx_pwr_all;
 		pstats->recvsignalpower = rx_pwr_all;
-- 
2.24.0

