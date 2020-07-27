Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A90DE22F90E
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 21:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbgG0T33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 15:29:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:35962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726541AbgG0T32 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 15:29:28 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE7D020729;
        Mon, 27 Jul 2020 19:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595878167;
        bh=ytTEJ+stPjTn4AC1GT+S1W3B63rhspPmd4oDrpegaSw=;
        h=Date:From:To:Cc:Subject:From;
        b=Wj2MuMRmisOIMf71eqoAVofvEi+5yKNZEwbDdd14S93cWbx8Rd0s7jQe5uEROfTSt
         MKz+JJ9NdWSLYd8CYK0KBq2Wp1AQwYYbPWKMq5Lts+y6UQHbUADxudmSOWNtuhrVre
         R2ux50sKyf4rmnK/FzFDV9ODOgBSK4cqsK2y9kKs=
Date:   Mon, 27 Jul 2020 14:35:20 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] ath9k: Use fallthrough pseudo-keyword
Message-ID: <20200727193520.GA832@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the existing /* fall through */ comments and its variants with
the new pseudo-keyword macro fallthrough[1].

[1] https://www.kernel.org/doc/html/v5.7/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c | 4 ++--
 drivers/net/wireless/ath/ath9k/ar9002_mac.c | 2 +-
 drivers/net/wireless/ath/ath9k/ar9002_phy.c | 2 +-
 drivers/net/wireless/ath/ath9k/ar9003_mac.c | 2 +-
 drivers/net/wireless/ath/ath9k/channel.c    | 4 ++--
 drivers/net/wireless/ath/ath9k/eeprom_def.c | 2 +-
 drivers/net/wireless/ath/ath9k/hw.c         | 6 +++---
 drivers/net/wireless/ath/ath9k/main.c       | 2 +-
 8 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index dae95402eb3a..0d34356baf73 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -579,14 +579,14 @@ static void ar5008_hw_init_chain_masks(struct ath_hw *ah)
 	case 0x5:
 		REG_SET_BIT(ah, AR_PHY_ANALOG_SWAP,
 			    AR_PHY_SWAP_ALT_CHAIN);
-		/* fall through */
+		fallthrough;
 	case 0x3:
 		if (ah->hw_version.macVersion == AR_SREV_REVISION_5416_10) {
 			REG_WRITE(ah, AR_PHY_RX_CHAINMASK, 0x7);
 			REG_WRITE(ah, AR_PHY_CAL_CHAINMASK, 0x7);
 			break;
 		}
-		/* fall through */
+		fallthrough;
 	case 0x1:
 	case 0x2:
 	case 0x7:
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_mac.c b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
index 4b3c9b108197..ce9a0a53771e 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
@@ -267,7 +267,7 @@ ar9002_set_txdesc(struct ath_hw *ah, void *ds, struct ath_tx_info *i)
 	switch (i->aggr) {
 	case AGGR_BUF_FIRST:
 		ctl6 |= SM(i->aggr_len, AR_AggrLen);
-		/* fall through */
+		fallthrough;
 	case AGGR_BUF_MIDDLE:
 		ctl1 |= AR_IsAggr | AR_MoreAggr;
 		ctl6 |= SM(i->ndelim, AR_PadDelim);
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index 6f32b8d2ec7f..fcfed8e59d29 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -119,7 +119,7 @@ static int ar9002_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 				aModeRefSel = 2;
 			if (aModeRefSel)
 				break;
-			/* fall through */
+			fallthrough;
 		case 1:
 		default:
 			aModeRefSel = 0;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index e1fe7a7c3ad8..76b538942a79 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -120,7 +120,7 @@ ar9003_set_txdesc(struct ath_hw *ah, void *ds, struct ath_tx_info *i)
 	switch (i->aggr) {
 	case AGGR_BUF_FIRST:
 		ctl17 |= SM(i->aggr_len, AR_AggrLen);
-		/* fall through */
+		fallthrough;
 	case AGGR_BUF_MIDDLE:
 		ctl12 |= AR_IsAggr | AR_MoreAggr;
 		ctl17 |= SM(i->ndelim, AR_PadDelim);
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index fd61ae4782b6..6cf087522157 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -706,7 +706,7 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 			"Move chanctx state from FORCE_ACTIVE to IDLE\n");
 
 		sc->sched.state = ATH_CHANCTX_STATE_IDLE;
-		/* fall through */
+		fallthrough;
 	case ATH_CHANCTX_EVENT_SWITCH:
 		if (!test_bit(ATH_OP_MULTI_CHANNEL, &common->op_flags) ||
 		    sc->sched.state == ATH_CHANCTX_STATE_FORCE_ACTIVE ||
@@ -1080,7 +1080,7 @@ static void ath_offchannel_timer(struct timer_list *t)
 			mod_timer(&sc->offchannel.timer, jiffies + HZ / 10);
 			break;
 		}
-		/* fall through */
+		fallthrough;
 	case ATH_OFFCHANNEL_SUSPEND:
 		if (!sc->offchannel.scan_req)
 			return;
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 56b44fc7a8e6..9729a69d3e2e 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -402,7 +402,7 @@ static u32 ath9k_hw_def_get_eeprom(struct ath_hw *ah,
 			return AR5416_PWR_TABLE_OFFSET_DB;
 	case EEP_ANTENNA_GAIN_2G:
 		band = 1;
-		/* fall through */
+		fallthrough;
 	case EEP_ANTENNA_GAIN_5G:
 		return max_t(u8, max_t(u8,
 			pModal[band].antennaGainCh[0],
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 8c97db73e34c..6609ce122e6e 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1277,12 +1277,12 @@ static void ath9k_hw_set_operating_mode(struct ath_hw *ah, int opmode)
 			REG_SET_BIT(ah, AR_CFG, AR_CFG_AP_ADHOC_INDICATION);
 			break;
 		}
-		/* fall through */
+		fallthrough;
 	case NL80211_IFTYPE_OCB:
 	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_AP:
 		set |= AR_STA_ID1_STA_AP;
-		/* fall through */
+		fallthrough;
 	case NL80211_IFTYPE_STATION:
 		REG_CLR_BIT(ah, AR_CFG, AR_CFG_AP_ADHOC_INDICATION);
 		break;
@@ -2293,7 +2293,7 @@ void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period)
 	case NL80211_IFTYPE_ADHOC:
 		REG_SET_BIT(ah, AR_TXCFG,
 			    AR_TXCFG_ADHOC_BEACON_ATIM_TX_POLICY);
-		/* fall through */
+		fallthrough;
 	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_AP:
 		REG_WRITE(ah, AR_NEXT_TBTT_TIMER, next_beacon);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a47f6e978095..0ea3b80f664c 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1934,7 +1934,7 @@ static int ath9k_ampdu_action(struct ieee80211_hw *hw,
 	case IEEE80211_AMPDU_TX_STOP_FLUSH:
 	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
 		flush = true;
-		/* fall through */
+		fallthrough;
 	case IEEE80211_AMPDU_TX_STOP_CONT:
 		ath9k_ps_wakeup(sc);
 		ath_tx_aggr_stop(sc, sta, tid);
-- 
2.27.0

