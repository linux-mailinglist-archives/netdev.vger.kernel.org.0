Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30BA2259D2C
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 19:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728824AbgIAR1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 13:27:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:32844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728622AbgIAR1e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 13:27:34 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21ABC2078B;
        Tue,  1 Sep 2020 17:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598981252;
        bh=0MvMgowgO4wUGjb12rwuT/GAZ5YwAxDSOL62thxz3nk=;
        h=Date:From:To:Cc:Subject:From;
        b=ICjLM0YCR71fx1CTkItZi9wZVytF4ifg5MJMqlMTNdg/ZkArwkWuI+Ve1F3l+VO18
         Y+z8MrK7bBN9ADpZMYmffeQOktUJCFrL+y5Xrp2ixowlDqSThBOaDUbuqE1ynSp5vK
         fUUOK+kewd9Q0zSA/N5KG2DUiYN/lg2iXIeaq1+M=
Date:   Tue, 1 Sep 2020 12:33:41 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] mt76: Use fallthrough pseudo-keyword
Message-ID: <20200901173341.GA2527@embeddedor>
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
 drivers/net/wireless/mediatek/mt76/mt7603/dma.c     | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c     | 4 ++--
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c     | 6 +++---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c     | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c     | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c    | 6 +++---
 drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c | 1 -
 drivers/net/wireless/mediatek/mt76/mt7915/dma.c     | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c     | 4 ++--
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c     | 2 +-
 drivers/net/wireless/mediatek/mt76/usb.c            | 2 +-
 11 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/dma.c b/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
index a08b85281170..1dfcd7407535 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
@@ -123,7 +123,7 @@ void mt7603_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 			mt76_rx(&dev->mt76, q, skb);
 			return;
 		}
-		/* fall through */
+		fallthrough;
 	default:
 		dev_kfree_skb(skb);
 		break;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
index 8060c1514396..95602cbef3c3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
@@ -592,7 +592,7 @@ mt7603_mac_fill_rx(struct mt7603_dev *dev, struct sk_buff *skb)
 		switch (FIELD_GET(MT_RXV1_TX_MODE, rxdg0)) {
 		case MT_PHY_TYPE_CCK:
 			cck = true;
-			/* fall through */
+			fallthrough;
 		case MT_PHY_TYPE_OFDM:
 			i = mt76_get_rate(&dev->mt76, sband, i, cck);
 			break;
@@ -1161,7 +1161,7 @@ mt7603_fill_txs(struct mt7603_dev *dev, struct mt7603_sta *sta,
 	switch (FIELD_GET(MT_TX_RATE_MODE, final_rate)) {
 	case MT_PHY_TYPE_CCK:
 		cck = true;
-		/* fall through */
+		fallthrough;
 	case MT_PHY_TYPE_OFDM:
 		if (dev->mphy.chandef.chan->band == NL80211_BAND_5GHZ)
 			sband = &dev->mphy.sband_5g.sband;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index 3dd8dd28690e..60be7f409470 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -378,7 +378,7 @@ static int mt7615_mac_fill_rx(struct mt7615_dev *dev, struct sk_buff *skb)
 		switch (FIELD_GET(MT_RXV1_TX_MODE, rxdg0)) {
 		case MT_PHY_TYPE_CCK:
 			cck = true;
-			/* fall through */
+			fallthrough;
 		case MT_PHY_TYPE_OFDM:
 			i = mt76_get_rate(&dev->mt76, sband, i, cck);
 			break;
@@ -1271,7 +1271,7 @@ static bool mt7615_fill_txs(struct mt7615_dev *dev, struct mt7615_sta *sta,
 	switch (FIELD_GET(MT_TX_RATE_MODE, final_rate)) {
 	case MT_PHY_TYPE_CCK:
 		cck = true;
-		/* fall through */
+		fallthrough;
 	case MT_PHY_TYPE_OFDM:
 		mphy = &dev->mphy;
 		if (sta->wcid.ext_phy && dev->mt76.phy2)
@@ -1478,7 +1478,7 @@ void mt7615_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 			mt76_rx(&dev->mt76, q, skb);
 			return;
 		}
-		/* fall through */
+		fallthrough;
 	default:
 		dev_kfree_skb(skb);
 		break;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index 7781530fb3e6..7128c6082142 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -3279,7 +3279,7 @@ static int mt7615_dcoc_freq_idx(u16 freq, u8 bw)
 			freq = freq_bw40[idx];
 			break;
 		}
-		/* fall through */
+		fallthrough;
 	case NL80211_CHAN_WIDTH_40:
 		idx = mt7615_find_freq_idx(freq_bw40, ARRAY_SIZE(freq_bw40),
 					   freq);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 09f34deb6ba1..3de33aadf794 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -734,7 +734,7 @@ mt76x0_phy_get_delta_power(struct mt76x02_dev *dev, u8 tx_mode,
 	case 1:
 		if (chan->band == NL80211_BAND_2GHZ)
 			tssi_target += 29491; /* 3.6 * 8192 */
-		/* fall through */
+		fallthrough;
 	case 0:
 		break;
 	default:
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index e4e03beabe43..11900bcc1be0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -300,7 +300,7 @@ mt76x02_mac_process_tx_rate(struct ieee80211_tx_rate *txrate, u16 rate,
 		return 0;
 	case MT_PHY_TYPE_HT_GF:
 		txrate->flags |= IEEE80211_TX_RC_GREEN_FIELD;
-		/* fall through */
+		fallthrough;
 	case MT_PHY_TYPE_HT:
 		txrate->flags |= IEEE80211_TX_RC_MCS;
 		txrate->idx = idx;
@@ -462,7 +462,7 @@ mt76x02_tx_rate_fallback(struct ieee80211_tx_rate *rates, int idx, int phy)
 			rates[1].idx = 0;
 			break;
 		}
-		/* fall through */
+		fallthrough;
 	default:
 		rates[1].idx = max_t(int, rates[0].idx - 1, 0);
 		break;
@@ -677,7 +677,7 @@ mt76x02_mac_process_rate(struct mt76x02_dev *dev,
 		return 0;
 	case MT_PHY_TYPE_HT_GF:
 		status->enc_flags |= RX_ENC_FLAG_HT_GF;
-		/* fall through */
+		fallthrough;
 	case MT_PHY_TYPE_HT:
 		status->encoding = RX_ENC_HT;
 		status->rate_idx = idx;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
index 38f473d587c9..e7febc982930 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
@@ -21,7 +21,6 @@ static int mt7915_ser_trigger_set(void *data, u64 val)
 	switch (val) {
 	case SER_SET_RECOVER_L1:
 	case SER_SET_RECOVER_L2:
-		/* fall through */
 		ret = mt7915_mcu_set_ser(dev, SER_ENABLE, BIT(val), 0);
 		if (ret)
 			return ret;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/dma.c b/drivers/net/wireless/mediatek/mt76/mt7915/dma.c
index a8832c5e6004..12e5a4988d70 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/dma.c
@@ -72,7 +72,7 @@ void mt7915_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 			mt76_rx(&dev->mt76, q, skb);
 			return;
 		}
-		/* fall through */
+		fallthrough;
 	default:
 		dev_kfree_skb(skb);
 		break;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index 036207f828f3..ab65315a509a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -468,7 +468,7 @@ int mt7915_mac_fill_rx(struct mt7915_dev *dev, struct sk_buff *skb)
 			switch (mode) {
 			case MT_PHY_TYPE_CCK:
 				cck = true;
-				/* fall through */
+				fallthrough;
 			case MT_PHY_TYPE_OFDM:
 				i = mt76_get_rate(&dev->mt76, sband, i, cck);
 				break;
@@ -487,7 +487,7 @@ int mt7915_mac_fill_rx(struct mt7915_dev *dev, struct sk_buff *skb)
 				break;
 			case MT_PHY_TYPE_HE_MU:
 				status->flag |= RX_FLAG_RADIOTAP_HE_MU;
-				/* fall through */
+				fallthrough;
 			case MT_PHY_TYPE_HE_SU:
 			case MT_PHY_TYPE_HE_EXT_SU:
 			case MT_PHY_TYPE_HE_TB:
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index ac8ec257da03..98953f7469ee 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -1407,7 +1407,7 @@ mt7915_mcu_sta_he_tlv(struct sk_buff *skb, struct ieee80211_sta *sta)
 
 		he->max_nss_mcs[CMD_HE_MCS_BW160] =
 				he_cap->he_mcs_nss_supp.rx_mcs_160;
-		/* fall through */
+		fallthrough;
 	default:
 		he->max_nss_mcs[CMD_HE_MCS_BW80] =
 				he_cap->he_mcs_nss_supp.rx_mcs_80;
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index dcab5993763a..aa44b10f69e8 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -616,7 +616,7 @@ static void mt76u_complete_rx(struct urb *urb)
 	default:
 		dev_err_ratelimited(dev->dev, "rx urb failed: %d\n",
 				    urb->status);
-		/* fall through */
+		fallthrough;
 	case 0:
 		break;
 	}
-- 
2.27.0

