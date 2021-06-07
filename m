Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F54D39E1E8
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbhFGQO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:14:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:47666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231543AbhFGQOY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:14:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1939613C0;
        Mon,  7 Jun 2021 16:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082352;
        bh=Vspvsrwq+HMh5zo2lywXb+v0OGmxGRWtwUajJD+vy9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZdwzqTAO3u8S/nTVKdhhk10WqUTx/QrYG8JSZ7LCmf8yANK3iN/jzHgL861Tpiv4D
         ObBv+i079+yoQ3a2l60E5/3Vt/fNm7GJunLb9GjyR60cHHbVzlUsxAA+EtQlINm3n4
         swtYPBmCVcJYuQefpEy/6Cs3862b50Lq/jzdLpxuiurqTyJueL9Arj9dKxrNljArfb
         tbKZloPG+G7GhY1PIoR4rU/E8FLs0FPrcPS4STEU+VRt8FhrR/rUw9SoXYMl79bjd1
         SOJc2622UoTBDNE0wFwGIOoskG09woeUWlWL5HKdj+DO9D35XoRTJT2ajpDHjtI7wb
         DJuaNPSMSUsow==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 13/49] mt76: mt7921: fix max aggregation subframes setting
Date:   Mon,  7 Jun 2021 12:11:39 -0400
Message-Id: <20210607161215.3583176-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161215.3583176-1-sashal@kernel.org>
References: <20210607161215.3583176-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 94bb18b03d43f32e9440e8e350b7f533137c40f6 ]

The hardware can only handle 64 subframes in rx direction and 128 for tx.
Improves throughput with APs that can handle more than that

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210507100211.15709-2-nbd@nbd.name
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/init.c b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
index 89a13b4a74a4..c0001e38fcce 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
@@ -74,8 +74,8 @@ mt7921_init_wiphy(struct ieee80211_hw *hw)
 	struct wiphy *wiphy = hw->wiphy;
 
 	hw->queues = 4;
-	hw->max_rx_aggregation_subframes = IEEE80211_MAX_AMPDU_BUF;
-	hw->max_tx_aggregation_subframes = IEEE80211_MAX_AMPDU_BUF;
+	hw->max_rx_aggregation_subframes = 64;
+	hw->max_tx_aggregation_subframes = 128;
 
 	phy->slottime = 9;
 
-- 
2.30.2

