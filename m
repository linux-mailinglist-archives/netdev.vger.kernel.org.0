Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4913DC5F9
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 14:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233046AbhGaMk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 08:40:57 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:39810
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232690AbhGaMk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 08:40:56 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 572F73F0FD;
        Sat, 31 Jul 2021 12:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627735249;
        bh=oUq6gPgdLVraYDRbQRFMm2OILuIbppCsvEd0SKiqGuE=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=Qa+aNlMgECRGFRqmuzEkdbaBsr2JR/J5l8wJ3pc+dtD11jqap5mt9b/P7TC/4xXBl
         0OEPEBnnFhiTkNqBhauRBAWPTzvHYhb95qg4/+PS3AVrxOX05hqx3pI4K8mBvY4zCb
         kn4i/AJxg0sOZNjwc1c6W2Vq6jIfL+C1VBWK1eFDsqbS02RvJeOFJIE6GZ1LbYn8Wa
         Q/ofzr1RCPDMixYNcaDUvV3qq820sBk+whGGKu5wSxar+zI4lZHJxPxVeo9qPN4x/E
         Hx/+1FrTEAudD/eKN/0/kfIn49m/7GVUPtpqwBKufJTEKL2/tnfjp21eaFR2OxyG5W
         BhTPlHcd3UGyg==
From:   Colin King <colin.king@canonical.com>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] rtlwifi: rtl8192de: Remove redundant variable initializations
Date:   Sat, 31 Jul 2021 13:40:43 +0100
Message-Id: <20210731124044.101927-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variables rtstatus and place are being initialized with a values that
are never read, the initializations are redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
index 76dd881ef9bb..4eaa40d73baf 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
@@ -681,7 +681,7 @@ static bool _rtl92d_phy_bb_config(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
-	bool rtstatus = true;
+	bool rtstatus;
 
 	rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE, "==>\n");
 	rtstatus = _rtl92d_phy_config_bb_with_headerfile(hw,
@@ -1362,7 +1362,7 @@ u8 rtl92d_get_rightchnlplace_for_iqk(u8 chnl)
 		132, 134, 136, 138, 140, 149, 151, 153, 155,
 		157, 159, 161, 163, 165
 	};
-	u8 place = chnl;
+	u8 place;
 
 	if (chnl > 14) {
 		for (place = 14; place < sizeof(channel_all); place++) {
-- 
2.31.1

