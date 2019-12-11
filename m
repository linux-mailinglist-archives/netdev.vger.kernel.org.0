Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDF611B4AD
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 16:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732135AbfLKPtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 10:49:00 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35651 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732172AbfLKPsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 10:48:39 -0500
Received: by mail-wr1-f67.google.com with SMTP id g17so24573290wro.2;
        Wed, 11 Dec 2019 07:48:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hx73pcsUgJSxrgufL1jOhpoizW3oUY/70+LaPyCXp4c=;
        b=H/BArNKiHJcz8r2KnFMx4JPSJUrXZxUibPYOHF22Nnmwqa0ao+OstLbIqQcL97rPmB
         /0/V7ApWRvkgKZfsSmBR3Sw+XobUuvYy/w+4Y78IjcJWleCNK/aNePkemWgkLnlM3csH
         V28tRQwYAEGa5oqJfl1MoA19Bu7M0R3kHcADRgHhG9lTd5+weUC8J0dMQnwfNPMyaw65
         i2LRMKtDKE8gH/1jKWkHf71a9N0Q9z/qkfkKsLxq6d/SA1hfpUOEkA8VMtQEJX+OpxHw
         Z+bLdswTMaLTZV2K5SK3Lr2GbrItZWXQoLleWy0bsldFq8sryJwuM1tQwZBdPXMWlMTP
         E9Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hx73pcsUgJSxrgufL1jOhpoizW3oUY/70+LaPyCXp4c=;
        b=tHLnTWKXw8d2u+YMiXAdlqPpW2yjxFz71JKwCVaFrsPMG6RjIBmtMHsV9HgFJhRTTI
         Cr/IgXwSSsLI50wet/ERPiqIWJLZeXCTSHHTwxYuvUZdTlMjX7OJjCxXdyQRVe6V3gC/
         Rrgh4CMZZeMCTzL0cfxRwLaIwnTrybzMYaZopP8mP8Qu0cP8IK/Vg4vCOtYfgLvTzWQ+
         r46huTZ/oT7QCGlC1J+gCVFi9psSUukOk+J6n/iOLHaLPMw25d8aANV+bjn9zuyPDoSB
         43raW24D3bmwolHG4cCeE8aChJlGZjWduWkUOPQuJu0plxOAZ8QGfYNw7SQYJr2q9qv9
         Tejw==
X-Gm-Message-State: APjAAAWFKbjHhN9K/t1IWSScJWThItfyDTXLE5beTv1LOPSRDbputy3G
        xe0xSMpCPgDkrhs0lv/1Zk4=
X-Google-Smtp-Source: APXvYqwx4uTZOXPFPOnIekcfGr/QHXUMTwrew7xjvS7Um1oKAGwq5fAhUoh3w2KAtfeFQHqJo+O+cQ==
X-Received: by 2002:adf:fcc4:: with SMTP id f4mr439362wrs.247.1576079317544;
        Wed, 11 Dec 2019 07:48:37 -0800 (PST)
Received: from localhost.localdomain (dslb-002-204-142-082.002.204.pools.vodafone-ip.de. [2.204.142.82])
        by smtp.gmail.com with ESMTPSA id n16sm2677388wro.88.2019.12.11.07.48.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 07:48:37 -0800 (PST)
From:   Michael Straube <straube.linux@gmail.com>
To:     pkshih@realtek.com
Cc:     kvalo@codeaurora.org, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Straube <straube.linux@gmail.com>
Subject: [PATCH 6/6] rtlwifi: rtl8192de: use generic rtl_signal_scale_mapping
Date:   Wed, 11 Dec 2019 16:47:55 +0100
Message-Id: <20191211154755.15012-7-straube.linux@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191211154755.15012-1-straube.linux@gmail.com>
References: <20191211154755.15012-1-straube.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function _rtl92de_signal_scale_mapping is identical to the generic
version rtl_signal_scale_mapping. Remove _rtl92de_signal_scale_mapping
and use the generic function.

Signed-off-by: Michael Straube <straube.linux@gmail.com>
---
 .../wireless/realtek/rtlwifi/rtl8192de/trx.c  | 31 ++-----------------
 1 file changed, 2 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
index abb35d33cf69..85194aa30c36 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
@@ -33,33 +33,6 @@ static long _rtl92de_translate_todbm(struct ieee80211_hw *hw,
 	return signal_power;
 }
 
-static long _rtl92de_signal_scale_mapping(struct ieee80211_hw *hw, long currsig)
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
 static void _rtl92de_query_rxphystatus(struct ieee80211_hw *hw,
 				       struct rtl_stats *pstats,
 				       struct rx_desc_92d *pdesc,
@@ -202,10 +175,10 @@ static void _rtl92de_query_rxphystatus(struct ieee80211_hw *hw,
 		}
 	}
 	if (is_cck_rate)
-		pstats->signalstrength = (u8)(_rtl92de_signal_scale_mapping(hw,
+		pstats->signalstrength = (u8)(rtl_signal_scale_mapping(hw,
 				pwdb_all));
 	else if (rf_rx_num != 0)
-		pstats->signalstrength = (u8)(_rtl92de_signal_scale_mapping(hw,
+		pstats->signalstrength = (u8)(rtl_signal_scale_mapping(hw,
 				total_rssi /= rf_rx_num));
 }
 
-- 
2.24.0

