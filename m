Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3D52129624
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 13:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbfLWMwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 07:52:33 -0500
Received: from srv2.anyservers.com ([77.79.239.202]:55792 "EHLO
        srv2.anyservers.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbfLWMwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 07:52:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=asmblr.net;
         s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
        In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vovnieWsOioxvKBQ+ywK4TcFJNMUSxOQUge6FPuNbJ0=; b=VXvV03Y9KS70ZzbE//u6QT+LX7
        Iv692V7jBVCey8u/bowQGTiyWhnTJiayDYNoP1ZcUr0r8p0cbSPuf19IifYx/6cHh7PNyWdngPsIW
        NP2QfZOkIgVzEOVFugGp85mV01LW4RlvnNHVqGgX6N1iO4z5odC6XlilWmCVjZrnJewlhYAv/kJ8V
        hS8o8OQVSphvA0/38qeKhYcgVf+5fhcL8KscXSj6RdUahQhhbeO44JAHnV09l5jm2SQILcEndAbR6
        ha5TkHHdp1lLjHnaOYlGVv8g3/kpwm3xainhuE03+09wyPRyqA/D2it5s/e2SgznOzZWYikKA1NhP
        KY/d6OOQ==;
Received: from 89-64-37-27.dynamic.chello.pl ([89.64.37.27]:49046 helo=milkyway.galaxy)
        by srv2.anyservers.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92)
        (envelope-from <amade@asmblr.net>)
        id 1ijMxP-00Gi5o-P4; Mon, 23 Dec 2019 13:37:07 +0100
From:   =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org,
        =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>
Subject: [PATCH 3/9] rtlwifi: rtl8192ce: Make functions static & rm sw.h
Date:   Mon, 23 Dec 2019 13:37:09 +0100
Message-Id: <20191223123715.7177-4-amade@asmblr.net>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191223123715.7177-1-amade@asmblr.net>
References: <20191223123715.7177-1-amade@asmblr.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - srv2.anyservers.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - asmblr.net
X-Get-Message-Sender-Via: srv2.anyservers.com: authenticated_id: amade@asmblr.net
X-Authenticated-Sender: srv2.anyservers.com: amade@asmblr.net
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some of functions which were exposed in sw.h, are only used in sw.c, so
just make them static. The rtl92c_init_var_map function is not defined
anywhere, while declared in sw.h. Two other functions are also declared
in phy.h (which is included in sw.c) and their definitions are in phy.c
Overall sw.h is unnecessary and can be removed.

Signed-off-by: Amadeusz Sławiński <amade@asmblr.net>
---
 .../net/wireless/realtek/rtlwifi/rtl8192ce/sw.c   |  5 ++---
 .../net/wireless/realtek/rtlwifi/rtl8192ce/sw.h   | 15 ---------------
 2 files changed, 2 insertions(+), 18 deletions(-)
 delete mode 100644 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.h

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c
index 900788e4018c..ed68c850f9a2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c
@@ -14,7 +14,6 @@
 #include "../rtl8192c/phy_common.h"
 #include "hw.h"
 #include "rf.h"
-#include "sw.h"
 #include "trx.h"
 #include "led.h"
 
@@ -65,7 +64,7 @@ static void rtl92c_init_aspm_vars(struct ieee80211_hw *hw)
 	rtlpci->const_support_pciaspm = rtlpriv->cfg->mod_params->aspm_support;
 }
 
-int rtl92c_init_sw_vars(struct ieee80211_hw *hw)
+static int rtl92c_init_sw_vars(struct ieee80211_hw *hw)
 {
 	int err;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -161,7 +160,7 @@ int rtl92c_init_sw_vars(struct ieee80211_hw *hw)
 	return 0;
 }
 
-void rtl92c_deinit_sw_vars(struct ieee80211_hw *hw)
+static void rtl92c_deinit_sw_vars(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.h
deleted file mode 100644
index f2d121a60159..000000000000
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright(c) 2009-2012  Realtek Corporation.*/
-
-#ifndef __RTL92CE_SW_H__
-#define __RTL92CE_SW_H__
-
-int rtl92c_init_sw_vars(struct ieee80211_hw *hw);
-void rtl92c_deinit_sw_vars(struct ieee80211_hw *hw);
-void rtl92c_init_var_map(struct ieee80211_hw *hw);
-bool _rtl92ce_phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
-					    u8 configtype);
-bool _rtl92ce_phy_config_bb_with_pgheaderfile(struct ieee80211_hw *hw,
-					      u8 configtype);
-
-#endif
-- 
2.24.1

