Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB56D22F949
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 21:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728562AbgG0Tni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 15:43:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:39958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbgG0Tni (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 15:43:38 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7858320738;
        Mon, 27 Jul 2020 19:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595879017;
        bh=lxdBxXJ5zxVKvvxwH9ezbqRV5SEW+6CysTLL1xhSRH0=;
        h=Date:From:To:Cc:Subject:From;
        b=HivMI1fID38/+kcrg9AV6RGk9Adcd7AijgDE+kRiAxSWOR82Z62jTmDc8yldXCc/l
         alt8WMRc8SGbPuHRFHdnCV4iBv+m902tP+sf/BXX6UJarINKUTVzpObgUZanfsKDKk
         yvc6eUcDXmLs8hXIqRMQQgV3WGEQbDqEBzjqAMOI=
Date:   Mon, 27 Jul 2020 14:49:30 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jiri Slaby <jirislaby@kernel.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] ath5k: Use fallthrough pseudo-keyword
Message-ID: <20200727194930.GA1491@embeddedor>
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
 drivers/net/wireless/ath/ath5k/eeprom.c | 4 ++--
 drivers/net/wireless/ath/ath5k/pcu.c    | 4 ++--
 drivers/net/wireless/ath/ath5k/phy.c    | 6 +++---
 drivers/net/wireless/ath/ath5k/reset.c  | 2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
index 307f1fea0a88..1fbc2c19848f 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -1172,13 +1172,13 @@ ath5k_cal_data_offset_2413(struct ath5k_eeprom_info *ee, int mode)
 			offset += ath5k_pdgains_size_2413(ee,
 					AR5K_EEPROM_MODE_11B) +
 					AR5K_EEPROM_N_2GHZ_CHAN_2413 / 2;
-		/* fall through */
+		fallthrough;
 	case AR5K_EEPROM_MODE_11B:
 		if (AR5K_EEPROM_HDR_11A(ee->ee_header))
 			offset += ath5k_pdgains_size_2413(ee,
 					AR5K_EEPROM_MODE_11A) +
 					AR5K_EEPROM_N_5GHZ_CHAN / 2;
-		/* fall through */
+		fallthrough;
 	case AR5K_EEPROM_MODE_11A:
 		break;
 	default:
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index 05140d8baa36..7e9c3f0f8607 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -670,7 +670,7 @@ ath5k_hw_init_beacon_timers(struct ath5k_hw *ah, u32 next_beacon, u32 interval)
 		break;
 	case NL80211_IFTYPE_ADHOC:
 		AR5K_REG_ENABLE_BITS(ah, AR5K_TXCFG, AR5K_TXCFG_ADHOC_BCN_ATIM);
-		/* fall through */
+		fallthrough;
 	default:
 		/* On non-STA modes timer1 is used as next DMA
 		 * beacon alert (DBA) timer and timer2 as next
@@ -913,7 +913,7 @@ ath5k_hw_set_opmode(struct ath5k_hw *ah, enum nl80211_iftype op_mode)
 		pcu_reg |= AR5K_STA_ID1_KEYSRCH_MODE
 			| (ah->ah_version == AR5K_AR5210 ?
 				AR5K_STA_ID1_PWR_SV : 0);
-		/* fall through */
+		fallthrough;
 	case NL80211_IFTYPE_MONITOR:
 		pcu_reg |= AR5K_STA_ID1_KEYSRCH_MODE
 			| (ah->ah_version == AR5K_AR5210 ?
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index ae08572c4b58..00f9e347d414 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -3229,10 +3229,10 @@ ath5k_write_pwr_to_pdadc_table(struct ath5k_hw *ah, u8 ee_mode)
 	switch (pdcurves) {
 	case 3:
 		reg |= AR5K_REG_SM(pdg_to_idx[2], AR5K_PHY_TPC_RG1_PDGAIN_3);
-		/* Fall through */
+		fallthrough;
 	case 2:
 		reg |= AR5K_REG_SM(pdg_to_idx[1], AR5K_PHY_TPC_RG1_PDGAIN_2);
-		/* Fall through */
+		fallthrough;
 	case 1:
 		reg |= AR5K_REG_SM(pdg_to_idx[0], AR5K_PHY_TPC_RG1_PDGAIN_1);
 		break;
@@ -3353,7 +3353,7 @@ ath5k_setup_channel_powertable(struct ath5k_hw *ah,
 					table_min[pdg] = table_max[pdg] - 126;
 			}
 
-			/* Fall through */
+			fallthrough;
 		case AR5K_PWRTABLE_PWR_TO_PCDAC:
 		case AR5K_PWRTABLE_PWR_TO_PDADC:
 
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 56d7925a0c2c..9fdb5283b39c 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -522,7 +522,7 @@ ath5k_hw_set_power_mode(struct ath5k_hw *ah, enum ath5k_power_mode mode,
 	switch (mode) {
 	case AR5K_PM_AUTO:
 		staid &= ~AR5K_STA_ID1_DEFAULT_ANTENNA;
-		/* fallthrough */
+		fallthrough;
 	case AR5K_PM_NETWORK_SLEEP:
 		if (set_chip)
 			ath5k_hw_reg_write(ah,
-- 
2.27.0

