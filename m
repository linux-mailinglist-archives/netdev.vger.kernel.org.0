Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE83D3DF0AE
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 16:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236380AbhHCOuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 10:50:04 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:55830
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234524AbhHCOuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 10:50:02 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 0C69B3F0FA;
        Tue,  3 Aug 2021 14:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1628002190;
        bh=AuuIcnFkWh+0MWsN35BTfKmOqzjfjcwoZ+u0/Q+59dA=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version:Content-Type;
        b=vOBGGw6eyp2iriBNOPZLV0Nhg8P7OFyNNQ+oAgd8xLrM/8Z4Q+O6m+Q/o4D4iyjxX
         fvYUzcC+l2f1IAnX9jaCNmm9Rv9NYRHBoVC/tZ7kP5SQAzNEtzsC/z7ah+jJ9IXgUC
         KxEX1Yql0IEYOS9xKgbqezIEDzj2RLW7a1hq8paQioN48IyIf6WbNoWxaWDJwSjwRU
         oE4VBuoeZ19FQq1yjTaeFaYFIJtgRTn260dygEVDl/FMGsyNfPPKqXUdA/R6WJYIYT
         9uKTmidrgNAtZc3wmiU5ikkObfXjmt1RQcoRmk569yy9k7Bufx5znKIOKlKSnJFHpL
         YYAXG0vc/jQgw==
From:   Colin King <colin.king@canonical.com>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3][V2] rtlwifi: rtl8192de: make arrays static const, makes object smaller
Date:   Tue,  3 Aug 2021 15:49:48 +0100
Message-Id: <20210803144949.79433-2-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803144949.79433-1-colin.king@canonical.com>
References: <20210803144949.79433-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Don't populate arrays the stack but instead make them static const. Replace
array channel_info with channel_all since it contains the same data as
channel_all. Makes object code smaller by 961 bytes.

Before:
   text	   data	    bss	    dec	   hex	filename
 128147	  44250	   1024	 173421	 2a56d	../realtek/rtlwifi/rtl8192de/phy.o

After
   text	   data	    bss	    dec	   hex	filename
 127122	  44314	   1024	 172460	 2a1ac	../realtek/rtlwifi/rtl8192de/phy.o

(gcc version 10.2.0)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---

V2: Remove channel_info and replace with channel_all since it is the
    same as channel_info. Thanks to Joe Perches for spotting this.
---
 .../wireless/realtek/rtlwifi/rtl8192de/phy.c  | 48 ++++++++-----------
 1 file changed, 20 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
index 50c2d8f6f9c0..8ae69d914312 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
@@ -160,6 +160,15 @@ static u32 targetchnl_2g[TARGET_CHNL_NUM_2G] = {
 	25711, 25658, 25606, 25554, 25502, 25451, 25328
 };
 
+static const u8 channel_all[59] = {
+	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
+	36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58,
+	60, 62, 64, 100, 102, 104, 106, 108, 110, 112,
+	114, 116, 118, 120, 122, 124, 126, 128,	130,
+	132, 134, 136, 138, 140, 149, 151, 153, 155,
+	157, 159, 161, 163, 165
+};
+
 static u32 _rtl92d_phy_calculate_bit_shift(u32 bitmask)
 {
 	u32 i = ffs(bitmask);
@@ -1354,14 +1363,6 @@ static void _rtl92d_phy_switch_rf_setting(struct ieee80211_hw *hw, u8 channel)
 
 u8 rtl92d_get_rightchnlplace_for_iqk(u8 chnl)
 {
-	u8 channel_all[59] = {
-		1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
-		36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58,
-		60, 62, 64, 100, 102, 104, 106, 108, 110, 112,
-		114, 116, 118, 120, 122, 124, 126, 128,	130,
-		132, 134, 136, 138, 140, 149, 151, 153, 155,
-		157, 159, 161, 163, 165
-	};
 	u8 place = chnl;
 
 	if (chnl > 14) {
@@ -3220,37 +3221,28 @@ void rtl92d_phy_config_macphymode_info(struct ieee80211_hw *hw)
 u8 rtl92d_get_chnlgroup_fromarray(u8 chnl)
 {
 	u8 group;
-	u8 channel_info[59] = {
-		1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
-		36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56,
-		58, 60, 62, 64, 100, 102, 104, 106, 108,
-		110, 112, 114, 116, 118, 120, 122, 124,
-		126, 128, 130, 132, 134, 136, 138, 140,
-		149, 151, 153, 155, 157, 159, 161, 163,
-		165
-	};
 
-	if (channel_info[chnl] <= 3)
+	if (channel_all[chnl] <= 3)
 		group = 0;
-	else if (channel_info[chnl] <= 9)
+	else if (channel_all[chnl] <= 9)
 		group = 1;
-	else if (channel_info[chnl] <= 14)
+	else if (channel_all[chnl] <= 14)
 		group = 2;
-	else if (channel_info[chnl] <= 44)
+	else if (channel_all[chnl] <= 44)
 		group = 3;
-	else if (channel_info[chnl] <= 54)
+	else if (channel_all[chnl] <= 54)
 		group = 4;
-	else if (channel_info[chnl] <= 64)
+	else if (channel_all[chnl] <= 64)
 		group = 5;
-	else if (channel_info[chnl] <= 112)
+	else if (channel_all[chnl] <= 112)
 		group = 6;
-	else if (channel_info[chnl] <= 126)
+	else if (channel_all[chnl] <= 126)
 		group = 7;
-	else if (channel_info[chnl] <= 140)
+	else if (channel_all[chnl] <= 140)
 		group = 8;
-	else if (channel_info[chnl] <= 153)
+	else if (channel_all[chnl] <= 153)
 		group = 9;
-	else if (channel_info[chnl] <= 159)
+	else if (channel_all[chnl] <= 159)
 		group = 10;
 	else
 		group = 11;
-- 
2.31.1

