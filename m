Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF95511B4B5
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 16:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388702AbfLKPtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 10:49:23 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40856 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732393AbfLKPsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 10:48:33 -0500
Received: by mail-wr1-f66.google.com with SMTP id c14so24544040wrn.7;
        Wed, 11 Dec 2019 07:48:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IGE1EZUwmuYxZ2Mr6HgxG/3CVQcz/FGb9rzGPe/Zmdw=;
        b=K+IhQdX61p0DNtryFjvI+O95fa02XCaX+fJS84QR58V9gaWJRhRI9ixClf2eV6teDl
         bkJRGQtmGKWOhr97rTwTPQ4EJhJjeKurhIVIUacxn1w2p7X61WykKpWbS4GJ5n7lK6I8
         p5TpUwBxe3yjKHtbYGmnlo0Rxu8dN8v7fnnWYVoRjwsPPuP/rQnTgP1FVZ17DLSx9mWy
         raZ16oh3Qu3idCPSlSqdLWo+TSuXqVlisK55iB4lqeOoEf74BjPJ3feoBT36oa35jMWM
         L26CFs389pitsobSshnEcVXzhUTUaMrqZmp0JnTh4X3o//5mzkc5qqCuEnr72ru7FH+v
         jPwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IGE1EZUwmuYxZ2Mr6HgxG/3CVQcz/FGb9rzGPe/Zmdw=;
        b=NzB+cBFq7svBrMJQB25xXvBBoV9R/lYJig+F6ZVAoGfosBXq6GhssO/JDer9dhrhWD
         6i1qeIVYsbXlvFVXvUSXGTnhwX5m/mg3T95X+/RWciMSv8SXqZTc/poA14GwZ2eRq/ag
         Wxa7TydIGGd6nP7qsIL9Gh4BcCpKUbl44/xWC7fCHipd3VGhomuhrHfhOGXR7TE4HMHu
         WM4+rz3UWD5HNrubADQ5ksKeWsBZOpsGkpWwVDijl+7A60OV4wK6ZHjV/F4khHDIPG04
         SV11SqG2XgG4Ta1z8+cGOC55oNQsQ8vY42WQL8ByjXjQj+ZBFQB21qp/fwdFvkYIyUJC
         5fAA==
X-Gm-Message-State: APjAAAUtW8Tmb4S0RwXrxd4SHMQx1eVDWPBYAoqiuAONoM2MDtaK7KAj
        bH8L33sg8dssCVIS4s1wl8Q=
X-Google-Smtp-Source: APXvYqxtnLcKlpVW5V/2bsbKm53q/msqRT+C1dVoFjS8gzd0jI835avZh2s7fMaA3YMf0+DkjJ1BJA==
X-Received: by 2002:a5d:49c3:: with SMTP id t3mr462740wrs.113.1576079312153;
        Wed, 11 Dec 2019 07:48:32 -0800 (PST)
Received: from localhost.localdomain (dslb-002-204-142-082.002.204.pools.vodafone-ip.de. [2.204.142.82])
        by smtp.gmail.com with ESMTPSA id n16sm2677388wro.88.2019.12.11.07.48.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 07:48:31 -0800 (PST)
From:   Michael Straube <straube.linux@gmail.com>
To:     pkshih@realtek.com
Cc:     kvalo@codeaurora.org, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Straube <straube.linux@gmail.com>
Subject: [PATCH 1/6] rtlwifi: rtl8192ce: use generic rtl_query_rxpwrpercentage
Date:   Wed, 11 Dec 2019 16:47:50 +0100
Message-Id: <20191211154755.15012-2-straube.linux@gmail.com>
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
 .../net/wireless/realtek/rtlwifi/rtl8192ce/trx.c   | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
index fc9a3aae047f..dec66b3ac365 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
@@ -23,16 +23,6 @@ static u8 _rtl92ce_map_hwqueue_to_fwqueue(struct sk_buff *skb, u8 hw_queue)
 	return skb->priority;
 }
 
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
 static long _rtl92ce_signal_scale_mapping(struct ieee80211_hw *hw,
 		long currsig)
 {
@@ -194,7 +184,7 @@ static void _rtl92ce_query_rxphystatus(struct ieee80211_hw *hw,
 			rx_pwr[i] =
 			    ((p_drvinfo->gain_trsw[i] & 0x3f) * 2) - 110;
 			/* Translate DBM to percentage. */
-			rssi = _rtl92c_query_rxpwrpercentage(rx_pwr[i]);
+			rssi = rtl_query_rxpwrpercentage(rx_pwr[i]);
 			total_rssi += rssi;
 			/* Get Rx snr value in DB */
 			rtlpriv->stats.rx_snr_db[i] =
@@ -209,7 +199,7 @@ static void _rtl92ce_query_rxphystatus(struct ieee80211_hw *hw,
 		 * hardware (for rate adaptive)
 		 */
 		rx_pwr_all = ((p_drvinfo->pwdb_all >> 1) & 0x7f) - 110;
-		pwdb_all = _rtl92c_query_rxpwrpercentage(rx_pwr_all);
+		pwdb_all = rtl_query_rxpwrpercentage(rx_pwr_all);
 		pstats->rx_pwdb_all = pwdb_all;
 		pstats->rxpower = rx_pwr_all;
 		pstats->recvsignalpower = rx_pwr_all;
-- 
2.24.0

