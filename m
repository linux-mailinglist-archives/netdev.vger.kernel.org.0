Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83AE43394F2
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 18:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232949AbhCLRa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 12:30:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48400 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232666AbhCLR35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 12:29:57 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lKlbi-0001et-6K; Fri, 12 Mar 2021 17:29:50 +0000
From:   Colin King <colin.king@canonical.com>
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mt76: mt7921: remove redundant check on type
Date:   Fri, 12 Mar 2021 17:29:49 +0000
Message-Id: <20210312172949.153418-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently in the switch statement case where type is
NL80211_IFTYPE_STATION there is a check to see if type
is not NL80211_IFTYPE_STATION.  This check is always false
and is redundant dead code that can be removed.

Addresses-Coverity: ("Logically dead code")
Fixes: e0f9fdda81bd ("mt76: mt7921: add ieee80211_ops")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 729f6c42cdde..c8975f372cf2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -224,9 +224,6 @@ static int get_omac_idx(enum nl80211_iftype type, u64 mask)
 		if (i)
 			return i - 1;
 
-		if (type != NL80211_IFTYPE_STATION)
-			break;
-
 		/* next, try to find a free repeater entry for the sta */
 		i = get_free_idx(mask >> REPEATER_BSSID_START, 0,
 				 REPEATER_BSSID_MAX - REPEATER_BSSID_START);
-- 
2.30.2

