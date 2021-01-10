Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABB62F0721
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 13:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbhAJMQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 07:16:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbhAJMQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 07:16:43 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB6FC0617A5;
        Sun, 10 Jan 2021 04:15:47 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id p12so6106037pju.5;
        Sun, 10 Jan 2021 04:15:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pDEEvJ1raRHovODvVibZtDrKwCKJS8ji5cQnuEVu9AU=;
        b=MBjX5Y9FARb2FMBMlNC5DaPzVJYt9sa0Habl/+AgRVKXnklO3mQ3Kd95BGdG0h4APM
         Y+YhKW270hNPN+GAlVuc4n7KgSHwgA5WKEjy1BcdubFnuwKO8+dFnzebnz0KwgUB3Rd7
         EeYcBgAIxt8GKk5zamNAft+QCWbaN83hW0eE/igQZUxbq6tQFRONrDFEhCKJJewbmbWj
         XHdRg1Fo4UDU9iSoqqfJWkyTgNdgL+lovu2OlyB18snHusjCtYJ3EP7sFoindhpY5Dsv
         oF1aH8pNj5jyHsnjgV7qj3Gpfa2gmE2lMkQbVgzoCKUPYWb9GuNGamnmhXq7ElclRLK8
         4SWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pDEEvJ1raRHovODvVibZtDrKwCKJS8ji5cQnuEVu9AU=;
        b=jNgFCXVojVSY73yoBMfal0GXp05Lw1ETx5leC4hFdlCbu3ckb+/7wzIQ2K2qrHNwaY
         Xa9NyRq8mQtNbYurc4ZfJGMuYD2qx6DOVl+VJAZzNhTiDFIT8tovKQoAOWeccr8gWTbN
         xcBU46UIS5PquAwFhTbk/I6ISg163Sm70eA/iBt2+pE9NJupdL9swv4cidCRa2HDrKji
         0MX9JLE3PoMTPWLxyEQ0NO4AUvDYoqop7JcBcghx0Bp+t6RHtpXGVKbk9s9m6asJ4cNQ
         WPK+FpsWYjx/XRkI438dnjQax6ddn3fcPW6ZJD0NbQr6Whng9AfNsfHVeLZUr83MwcXp
         fujw==
X-Gm-Message-State: AOAM533AWwVBWlxONHh/j1OjvrHh4FVrRclxrhMReOFdZSfQ0VFGJVZ6
        66XIVEH6+sqP0UW2V45BfvzXds960M1whA==
X-Google-Smtp-Source: ABdhPJwmOW2gS/r2V+OiuIjnYnknqXowh5GM0aAdpna5+cM/rvaentF8D04RcnV2A9dHu71MAGaQ9Q==
X-Received: by 2002:a17:90b:1945:: with SMTP id nk5mr12666347pjb.30.1610280947142;
        Sun, 10 Jan 2021 04:15:47 -0800 (PST)
Received: from localhost.localdomain ([2405:201:600d:a089:381d:ba42:3c3c:81ce])
        by smtp.googlemail.com with ESMTPSA id y5sm10959791pjt.42.2021.01.10.04.15.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Jan 2021 04:15:46 -0800 (PST)
From:   Aditya Srivastava <yashsri421@gmail.com>
To:     linux-wireless@vger.kernel.org
Cc:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        lukas.bulwahn@gmail.com, yashsri421@gmail.com
Subject: [PATCH 3/5] rtlwifi: rtl8188ee: fix bool comparison in expressions
Date:   Sun, 10 Jan 2021 17:45:23 +0530
Message-Id: <20210110121525.2407-4-yashsri421@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210110121525.2407-1-yashsri421@gmail.com>
References: <3c121981-1468-fc9d-7813-483246066cc4@lwfinger.net>
 <20210110121525.2407-1-yashsri421@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are certain conditional expressions in rtl8188ee, where a boolean
variable is compared with true/false, in forms such as (foo == true) or
(false != bar), which does not comply with checkpatch.pl (CHECK:
BOOL_COMPARISON), according to which boolean variables should be
themselves used in the condition, rather than comparing with true/false

E.g., in drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c,
"if (mac->act_scanning == true)" can be replaced with
"if (mac->act_scanning)"

Replace all such expressions with the bool variables appropriately

Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c | 8 ++++----
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c
index d10c14c694da..6f61d6a10627 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c
@@ -474,11 +474,11 @@ static void rtl88e_dm_dig(struct ieee80211_hw *hw)
 	u8 dm_dig_max, dm_dig_min;
 	u8 current_igi = dm_dig->cur_igvalue;
 
-	if (rtlpriv->dm.dm_initialgain_enable == false)
+	if (!rtlpriv->dm.dm_initialgain_enable)
 		return;
-	if (dm_dig->dig_enable_flag == false)
+	if (!dm_dig->dig_enable_flag)
 		return;
-	if (mac->act_scanning == true)
+	if (mac->act_scanning)
 		return;
 
 	if (mac->link_state >= MAC80211_LINKED)
@@ -1637,7 +1637,7 @@ static void rtl88e_dm_fast_ant_training(struct ieee80211_hw *hw)
 			}
 		}
 
-		if (bpkt_filter_match == false) {
+		if (!bpkt_filter_match) {
 			rtl_set_bbreg(hw, DM_REG_TXAGC_A_1_MCS32_11N,
 				      BIT(16), 0);
 			rtl_set_bbreg(hw, DM_REG_IGI_A_11N, BIT(7), 0);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
index bd9160b166c5..861cc663ca93 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
@@ -1269,12 +1269,12 @@ void rtl88ee_set_check_bssid(struct ieee80211_hw *hw, bool check_bssid)
 	if (rtlpriv->psc.rfpwr_state != ERFON)
 		return;
 
-	if (check_bssid == true) {
+	if (check_bssid) {
 		reg_rcr |= (RCR_CBSSID_DATA | RCR_CBSSID_BCN);
 		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR,
 					      (u8 *)(&reg_rcr));
 		_rtl88ee_set_bcn_ctrl_reg(hw, 0, BIT(4));
-	} else if (check_bssid == false) {
+	} else if (!check_bssid) {
 		reg_rcr &= (~(RCR_CBSSID_DATA | RCR_CBSSID_BCN));
 		_rtl88ee_set_bcn_ctrl_reg(hw, BIT(4), 0);
 		rtlpriv->cfg->ops->set_hw_reg(hw,
-- 
2.17.1

