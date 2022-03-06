Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3564CEA29
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 10:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbiCFJKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 04:10:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiCFJKE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 04:10:04 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9062D1F2;
        Sun,  6 Mar 2022 01:09:12 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id o23so11099451pgk.13;
        Sun, 06 Mar 2022 01:09:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MdKwZWcDlXNg70OUOcgY+Uv8sryuhH6Ae0VUERvAE1k=;
        b=SmqrWRC+Vcb49bqkKIs/1IUYyspO/4NrjRtaR4tHmFbv2+YU9Y6VhTD2voFMSbYNuo
         /EFzIMaU7rdpDhG9WtoNxsYSiGjcnQeIgWiaCNKu3W9ZPKZGKF8NvBGC2d2q/nX0GFG3
         5ovT6f5iHyxLLJkp7howMejysf9NJN94hBzHPua0rmmCjGBfL61Rt9o5LopnoHLs04+a
         s3LpwSkEDFQwDXoDapznPNqdNKX3CTNjde9NoyF5Z/WRDrduNsdNmRue4VNcZ6/d8+JT
         Xr6pp1CLZCK0f3HPLH9Ul4rwO41XYobkyffDG150R5I5I6CSyht4clW7TFHAtrDdb+wg
         JjtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MdKwZWcDlXNg70OUOcgY+Uv8sryuhH6Ae0VUERvAE1k=;
        b=vx/TWT6HoTt/pCv0cgYneUNY8oVjhRzOOMKMwAFQrd6UZCCcYSHFgybrIJJ1CTAsZX
         Yg+HEo+m2g2vEpg+kaIwTWYzI6hltnUVPwwv0zGvM7FSBGgXoXMxdNV3LDD/qJzZDGeL
         yWnnC4lDsRedFxt2rgsdA53eQ6+L3br7UMpt5M96m1czCz+ZtCc5ag6RmaG64CiknH2h
         ffxLW/8fYuHcKglKWHxdld0/rg0fS7F+XVGu152WoveuehG5c144znUNNQE7KKqD0B/Q
         dr9wh11ykc8utdFjpSPrkpLBeYV9LUw7jMq1v7QSW83Qh/EjoQSf0zPJZVPBU7enxNfD
         hm3A==
X-Gm-Message-State: AOAM530gJw88v73dGOIHWv0pgNsz8ScJ3OaBj3gRtrLNygFMY+V+mHoB
        g6cjzRNwCX4U9QqmmyS1c6QOGr0K+Dw4jAY=
X-Google-Smtp-Source: ABdhPJzfRxHHnkiS4mLAbA0wWkrZ6NdVfauQqYSUvfy1YomjO+Y+eJNmS0OqgU/NsK6UrHahHLs9JA==
X-Received: by 2002:a63:1620:0:b0:375:948e:65bf with SMTP id w32-20020a631620000000b00375948e65bfmr5601458pgl.49.1646557752323;
        Sun, 06 Mar 2022 01:09:12 -0800 (PST)
Received: from 8888.icu ([210.3.157.149])
        by smtp.gmail.com with ESMTPSA id f18-20020a056a001ad200b004bf321765dfsm11931375pfv.95.2022.03.06.01.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 01:09:11 -0800 (PST)
From:   Lu Jicong <jiconglu58@gmail.com>
To:     pkshih@realtek.com, kvalo@kernel.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lu Jicong <jiconglu58@gmail.com>
Subject: [PATCH] rtlwifi: rtl8192ce: remove duplicated function '_rtl92ce_phy_set_rf_sleep'
Date:   Sun,  6 Mar 2022 09:08:46 +0000
Message-Id: <20220306090846.28523-1-jiconglu58@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function exists in phy_common.c as '_rtl92c_phy_set_rf_sleep'.
Switch to the one in common file.

Signed-off-by: Lu Jicong <jiconglu58@gmail.com>
---
 .../wireless/realtek/rtlwifi/rtl8192ce/phy.c  | 32 +------------------
 1 file changed, 1 insertion(+), 31 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c
index 04735da11168..da54e51badd3 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c
@@ -396,36 +396,6 @@ void _rtl92ce_phy_lc_calibrate(struct ieee80211_hw *hw, bool is2t)
 	}
 }
 
-static void _rtl92ce_phy_set_rf_sleep(struct ieee80211_hw *hw)
-{
-	u32 u4b_tmp;
-	u8 delay = 5;
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-
-	rtl_write_byte(rtlpriv, REG_TXPAUSE, 0xFF);
-	rtl_set_rfreg(hw, RF90_PATH_A, 0x00, RFREG_OFFSET_MASK, 0x00);
-	rtl_write_byte(rtlpriv, REG_APSD_CTRL, 0x40);
-	u4b_tmp = rtl_get_rfreg(hw, RF90_PATH_A, 0, RFREG_OFFSET_MASK);
-	while (u4b_tmp != 0 && delay > 0) {
-		rtl_write_byte(rtlpriv, REG_APSD_CTRL, 0x0);
-		rtl_set_rfreg(hw, RF90_PATH_A, 0x00, RFREG_OFFSET_MASK, 0x00);
-		rtl_write_byte(rtlpriv, REG_APSD_CTRL, 0x40);
-		u4b_tmp = rtl_get_rfreg(hw, RF90_PATH_A, 0, RFREG_OFFSET_MASK);
-		delay--;
-	}
-	if (delay == 0) {
-		rtl_write_byte(rtlpriv, REG_APSD_CTRL, 0x00);
-		rtl_write_byte(rtlpriv, REG_SYS_FUNC_EN, 0xE2);
-		rtl_write_byte(rtlpriv, REG_SYS_FUNC_EN, 0xE3);
-		rtl_write_byte(rtlpriv, REG_TXPAUSE, 0x00);
-		rtl_dbg(rtlpriv, COMP_POWER, DBG_TRACE,
-			"Switch RF timeout !!!\n");
-		return;
-	}
-	rtl_write_byte(rtlpriv, REG_SYS_FUNC_EN, 0xE2);
-	rtl_write_byte(rtlpriv, REG_SPS0_CTRL, 0x22);
-}
-
 static bool _rtl92ce_phy_set_rf_power_state(struct ieee80211_hw *hw,
 					    enum rf_pwrstate rfpwr_state)
 {
@@ -519,7 +489,7 @@ static bool _rtl92ce_phy_set_rf_power_state(struct ieee80211_hw *hw,
 				jiffies_to_msecs(jiffies -
 						 ppsc->last_awake_jiffies));
 			ppsc->last_sleep_jiffies = jiffies;
-			_rtl92ce_phy_set_rf_sleep(hw);
+			_rtl92c_phy_set_rf_sleep(hw);
 			break;
 		}
 	default:
-- 
2.25.1

