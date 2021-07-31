Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E85353DC5FA
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 14:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233114AbhGaMk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 08:40:58 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:55296
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232692AbhGaMk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 08:40:57 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 753DA3F0A8;
        Sat, 31 Jul 2021 12:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627735249;
        bh=WmppQV2MYziB7/h7Q9+1v9o0+Fs4+5hGMgdCIXdYWlE=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version:Content-Type;
        b=wBgNYQm0hDv5l3lbaflmQrk2gx4/xLXmvgoKToO/EQ2eXXfXsFsqJO+9k/xFAgK5Y
         OXli37WVFc1ew44JhiLeGwTCLezOOaZgJ1U7/jYBCuhXQ8pqOpvo7nPF0zKwPtiN+b
         SwPuvFk258yapl4rqqJ8BjaTtZi/c4lRMtsZD49tXm0xO3UMxF4AsZHWU/TPxCwNIR
         dT1nd2YBlzDuXk43T7esgwymw6zrViog60XHzkKYovAwX/yWQEG6QcToXSZmJSyrA2
         gzMSS03Zl4LtmN1ZKsjlHtiafiZ1rBROa12etRyfQgWgYGe6VMRM2WKPN80F2rQPxB
         W2Gz31QLcJW6Q==
From:   Colin King <colin.king@canonical.com>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] rtlwifi: rtl8192de:  make arrays static const, makes object smaller
Date:   Sat, 31 Jul 2021 13:40:44 +0100
Message-Id: <20210731124044.101927-2-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210731124044.101927-1-colin.king@canonical.com>
References: <20210731124044.101927-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Don't populate arrays the stack but instead make them static const
Makes the object code smaller by 852 bytes.

Before:
   text	   data	    bss	    dec	    hex	filename
 128211	  44250	   1024	 173485	  2a5ad	../realtek/rtlwifi/rtl8192de/phy.o

After:
   text	   data	    bss	    dec	    hex	filename
 127199	  44410	   1024	 172633	  2a259	../realtek/rtlwifi/rtl8192de/phy.o

(gcc version 10.2.0)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
index 4eaa40d73baf..79956254f798 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
@@ -1354,7 +1354,7 @@ static void _rtl92d_phy_switch_rf_setting(struct ieee80211_hw *hw, u8 channel)
 
 u8 rtl92d_get_rightchnlplace_for_iqk(u8 chnl)
 {
-	u8 channel_all[59] = {
+	static const u8 channel_all[59] = {
 		1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
 		36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58,
 		60, 62, 64, 100, 102, 104, 106, 108, 110, 112,
@@ -3220,7 +3220,7 @@ void rtl92d_phy_config_macphymode_info(struct ieee80211_hw *hw)
 u8 rtl92d_get_chnlgroup_fromarray(u8 chnl)
 {
 	u8 group;
-	u8 channel_info[59] = {
+	static const u8 channel_info[59] = {
 		1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
 		36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56,
 		58, 60, 62, 64, 100, 102, 104, 106, 108,
-- 
2.31.1

