Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5E8259D37
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 19:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732475AbgIAR3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 13:29:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726900AbgIAR3y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 13:29:54 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91EE920866;
        Tue,  1 Sep 2020 17:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598981393;
        bh=+s+pCurhvidYuSPa5gLrpalcWwRdWwzFktQe+NIAdVs=;
        h=Date:From:To:Cc:Subject:From;
        b=pLFRoNLzcPgdZE4K1Nv9wRlDf1cGZh5X+Ixcih4U6XT2LYU/mxHz6sPJBunBRLh6c
         H9RVhxy6iW5YGyllgPQj3i0+qaNUS0qvzqyX6Wpt9cBjOawsurfGKA9UtGtrBvnSIw
         CA18o22vkpuDCKAO1pIQI7T3HOgOovl2kYaQnJmE=
Date:   Tue, 1 Sep 2020 12:36:03 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jakub Kicinski <kubakici@wp.pl>, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] mt7601u: Use fallthrough pseudo-keyword
Message-ID: <20200901173603.GA2701@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the existing /* fall through */ comments and its variants with
the new pseudo-keyword macro fallthrough[1]. Also, remove unnecessary
fall-through markings when it is the case.

[1] https://www.kernel.org/doc/html/v5.7/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/mediatek/mt7601u/dma.c | 4 ++--
 drivers/net/wireless/mediatek/mt7601u/mac.c | 4 ++--
 drivers/net/wireless/mediatek/mt7601u/phy.c | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/dma.c b/drivers/net/wireless/mediatek/mt7601u/dma.c
index f6a0454abe04..09f931d4598c 100644
--- a/drivers/net/wireless/mediatek/mt7601u/dma.c
+++ b/drivers/net/wireless/mediatek/mt7601u/dma.c
@@ -196,7 +196,7 @@ static void mt7601u_complete_rx(struct urb *urb)
 	default:
 		dev_err_ratelimited(dev->dev, "rx urb failed: %d\n",
 				    urb->status);
-		/* fall through */
+		fallthrough;
 	case 0:
 		break;
 	}
@@ -241,7 +241,7 @@ static void mt7601u_complete_tx(struct urb *urb)
 	default:
 		dev_err_ratelimited(dev->dev, "tx urb failed: %d\n",
 				    urb->status);
-		/* fall through */
+		fallthrough;
 	case 0:
 		break;
 	}
diff --git a/drivers/net/wireless/mediatek/mt7601u/mac.c b/drivers/net/wireless/mediatek/mt7601u/mac.c
index cad5e81fcf77..d2ee1aaa3c81 100644
--- a/drivers/net/wireless/mediatek/mt7601u/mac.c
+++ b/drivers/net/wireless/mediatek/mt7601u/mac.c
@@ -45,7 +45,7 @@ mt76_mac_process_tx_rate(struct ieee80211_tx_rate *txrate, u16 rate)
 		return;
 	case MT_PHY_TYPE_HT_GF:
 		txrate->flags |= IEEE80211_TX_RC_GREEN_FIELD;
-		/* fall through */
+		fallthrough;
 	case MT_PHY_TYPE_HT:
 		txrate->flags |= IEEE80211_TX_RC_MCS;
 		txrate->idx = idx;
@@ -419,7 +419,7 @@ mt76_mac_process_rate(struct ieee80211_rx_status *status, u16 rate)
 		return;
 	case MT_PHY_TYPE_HT_GF:
 		status->enc_flags |= RX_ENC_FLAG_HT_GF;
-		/* fall through */
+		fallthrough;
 	case MT_PHY_TYPE_HT:
 		status->encoding = RX_ENC_HT;
 		status->rate_idx = idx;
diff --git a/drivers/net/wireless/mediatek/mt7601u/phy.c b/drivers/net/wireless/mediatek/mt7601u/phy.c
index d863ab4a66c9..430ae4c1d7db 100644
--- a/drivers/net/wireless/mediatek/mt7601u/phy.c
+++ b/drivers/net/wireless/mediatek/mt7601u/phy.c
@@ -787,7 +787,7 @@ mt7601u_phy_rf_pa_mode_val(struct mt7601u_dev *dev, int phy_mode, int tx_rate)
 	switch (phy_mode) {
 	case MT_PHY_TYPE_OFDM:
 		tx_rate += 4;
-		/* fall through */
+		fallthrough;
 	case MT_PHY_TYPE_CCK:
 		reg = dev->rf_pa_mode[0];
 		break;
-- 
2.27.0

