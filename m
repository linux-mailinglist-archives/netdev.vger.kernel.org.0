Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A312F0722
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 13:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbhAJMQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 07:16:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbhAJMQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 07:16:54 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE82C0617A7;
        Sun, 10 Jan 2021 04:15:56 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id iq13so6110723pjb.3;
        Sun, 10 Jan 2021 04:15:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=T7ThywqXuhxC8F6Hh3LDj1yvDqMYokNpJlLIGbeNsvg=;
        b=RJNN5BgGe8mKnEWypJ7UYPnfrK6Jxoaz8eUBmO+P/O89GAkqfT1ln2VZIiVO2f8AXR
         bhqozprqbGV9Mg/ZisW9ECc8jP/mk+nqS89Qnr/DRD88jkss5HEz2HfSx7AEn0ycLRq8
         4hG3cAX+L5XMyK58ByN8Bq4Jx9965rX7jPr59WKW3hJecoeWEck83icdNU7NEqtcCnnD
         MiR34KsXkRGX+jrHvt9stgwoqGIcQI+WMBIahCmFsuBT3TLpSzgaXzgn1wkofsKpqLkf
         tcGZbrtuyd9FCx8XYlBBXTf2Z9vflnJIN5b7Jpzr9zSYvzKCjPd3qWhafuqVw5qOig/y
         fw0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=T7ThywqXuhxC8F6Hh3LDj1yvDqMYokNpJlLIGbeNsvg=;
        b=WTF7Mt/4tiZqCukmKSDi8Uq5r03gQc1vQArVJOKD1N+ZUj+M8u/8GaL3nfxtNFUSaq
         dm5RtHR1vxtDIjQ1d+iQetIEb7aV79G6x0UQGVQRqXu+Rby/SZjc22aWV1LPMH04D3D5
         MkjPL38YGaWUDsZIcflkmQUUsmVyZapmrf/mkL0dE1ov34QwzSkj2C1Kz9b3E/c/bngi
         3OZCL1pEd0aTALsJebGGOouBEmCSpSE8LuVepEKO82UPVjPldOc/RdOetfjj84QynrZL
         ZM1J4Uk0v6e8YZliBDasUgPx26JBYGvMdVFNvvviB6DHImDPxL1tR+9Z2QS/uZApZGEw
         lQaw==
X-Gm-Message-State: AOAM5335079NuY5memGFaSxfpvekn/na9u0cR6/ATUfB/bZclXiynj2O
        dDrvqrnTHyOmhLwR/X2ZUtWU1yTjHXqGtA==
X-Google-Smtp-Source: ABdhPJys2QAtK2nStXpmMUaaqsBFY49SSm7RfqzrRy2zOk36qHLcn1ATn8LKYR/FYtmW8MIDE65AIQ==
X-Received: by 2002:a17:90a:5303:: with SMTP id x3mr13072178pjh.54.1610280955942;
        Sun, 10 Jan 2021 04:15:55 -0800 (PST)
Received: from localhost.localdomain ([2405:201:600d:a089:381d:ba42:3c3c:81ce])
        by smtp.googlemail.com with ESMTPSA id y5sm10959791pjt.42.2021.01.10.04.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Jan 2021 04:15:55 -0800 (PST)
From:   Aditya Srivastava <yashsri421@gmail.com>
To:     linux-wireless@vger.kernel.org
Cc:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        lukas.bulwahn@gmail.com, yashsri421@gmail.com
Subject: [PATCH 5/5] rtlwifi: rtl8821ae: fix bool comparison in expressions
Date:   Sun, 10 Jan 2021 17:45:25 +0530
Message-Id: <20210110121525.2407-6-yashsri421@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210110121525.2407-1-yashsri421@gmail.com>
References: <3c121981-1468-fc9d-7813-483246066cc4@lwfinger.net>
 <20210110121525.2407-1-yashsri421@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are certain conditional expressions in rtl8821ae, where a boolean
variable is compared with true/false, in forms such as (foo == true) or
(false != bar), which does not comply with checkpatch.pl (CHECK:
BOOL_COMPARISON), according to which boolean variables should be
themselves used in the condition, rather than comparing with true/false

E.g., in drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c,
"if (rtlefuse->autoload_failflag == false)" can be replaced with
"if (!rtlefuse->autoload_failflag)"

Replace all such expressions with the bool variables appropriately

Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
index 372d6f8caf06..e214b9062cc1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -1812,7 +1812,7 @@ static bool _rtl8821ae_phy_bb8821a_config_parafile(struct ieee80211_hw *hw)
 		return false;
 	}
 	_rtl8821ae_phy_init_tx_power_by_rate(hw);
-	if (rtlefuse->autoload_failflag == false) {
+	if (!rtlefuse->autoload_failflag) {
 		rtstatus = _rtl8821ae_phy_config_bb_with_pgheaderfile(hw,
 						    BASEBAND_CONFIG_PHY_REG);
 	}
@@ -3980,7 +3980,7 @@ static void _rtl8821ae_iqk_tx(struct ieee80211_hw *hw, enum radio_path path)
 				}
 			}
 
-			if (tx0iqkok == false)
+			if (!tx0iqkok)
 				break;				/* TXK fail, Don't do RXK */
 
 			if (vdf_enable == 1) {
@@ -4090,7 +4090,7 @@ static void _rtl8821ae_iqk_tx(struct ieee80211_hw *hw, enum radio_path path)
 						}
 					}
 
-					if (tx0iqkok == false) {   /* If RX mode TXK fail, then take TXK Result */
+					if (!tx0iqkok) {   /* If RX mode TXK fail, then take TXK Result */
 						tx_x0_rxk[cal] = tx_x0[cal];
 						tx_y0_rxk[cal] = tx_y0[cal];
 						tx0iqkok = true;
@@ -4249,7 +4249,7 @@ static void _rtl8821ae_iqk_tx(struct ieee80211_hw *hw, enum radio_path path)
 					}
 				}
 
-				if (tx0iqkok == false) {   /* If RX mode TXK fail, then take TXK Result */
+				if (!tx0iqkok) {   /* If RX mode TXK fail, then take TXK Result */
 					tx_x0_rxk[cal] = tx_x0[cal];
 					tx_y0_rxk[cal] = tx_y0[cal];
 					tx0iqkok = true;
-- 
2.17.1

