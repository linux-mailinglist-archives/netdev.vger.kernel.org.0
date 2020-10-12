Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62FB728C137
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 21:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391301AbgJLTKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 15:10:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730857AbgJLTCt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 15:02:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FA89208D5;
        Mon, 12 Oct 2020 19:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602529368;
        bh=QRWbLLlc5LX4W6tV/eifgyen0KK9C7vxrps4PQ+Cm0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iGR0DTQCbeOzyqgztIr+ENvLRGoi0Pp5AcYYzaNKAXwHP6dkkGrXlpPayZP+we249
         kXiKO8GMuJVfRI6X5rZ0vsvXanaqoCgDkPVEZ1XM5X9bNOgWW/hdHzK0pq6SiDUv5V
         ea+R3bApGjVqTPnZ4ML2xwDnBh8gjUHRieVxgdFk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.8 06/24] mt76: mt7615: reduce maximum VHT MPDU length to 7991
Date:   Mon, 12 Oct 2020 15:02:21 -0400
Message-Id: <20201012190239.3279198-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201012190239.3279198-1-sashal@kernel.org>
References: <20201012190239.3279198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit efb1676306f664625c0c546dd10d18d33c75e3fc ]

After fixing mac80211 to allow larger A-MSDUs in some cases, there have been
reports of performance regressions and packet loss with some clients.
It appears that the issue occurs when the hardware is transmitting A-MSDUs
bigger than 8k. Limit the local VHT MPDU size capability to 7991, matching
the value used for MT7915 as well.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200923052442.24141-1-nbd@nbd.name
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/init.c b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
index e2d80518e5af9..992a36602ad4c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
@@ -453,7 +453,7 @@ void mt7615_init_device(struct mt7615_dev *dev)
 	dev->mphy.sband_2g.sband.ht_cap.cap |= IEEE80211_HT_CAP_LDPC_CODING;
 	dev->mphy.sband_5g.sband.ht_cap.cap |= IEEE80211_HT_CAP_LDPC_CODING;
 	dev->mphy.sband_5g.sband.vht_cap.cap |=
-			IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454 |
+			IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_7991 |
 			IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_MASK;
 	mt7615_cap_dbdc_disable(dev);
 	dev->phy.dfs_state = -1;
-- 
2.25.1

