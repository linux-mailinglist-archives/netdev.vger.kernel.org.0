Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6817A24CF23
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 09:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbgHUHWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 03:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728053AbgHUHRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 03:17:03 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3530BC06134D
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:17:01 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id x5so837791wmi.2
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=txAef8UV6p9lWbjGqibKlS8DeWgF5/E7/8EXAcRD1Ek=;
        b=ggumRlASNfo6IBsNwOR+DOLqJqUFqSHYv04ipEx6+RkxwTkoxrEEK+jcsywQJZKZyx
         NusCAT/GEKwhq3ysMwvZhJ0Sx5Rbmi5YKB8F1JkY9+xYPCQPd17tHFuCP6sI1OlH63c0
         zJ+o3OmIBiKQCA6C+72nXfEmLin5d9YhwtjqE53/0pJJXcTYO/lyC0sGH+GGk4cuKZm3
         Ae1s9kvrBI4npw+FyXh5uc4sfpHK9qYSjPgCtwNvyg5E3ZkE+b3/c1ZBA8Ja+ayzW7cu
         OA70i3WMyDvzey6COO722Z07Ju/U2LO5MuAL5c8as+qAgVwXP3fJ06JKA7MPBRTkQNce
         jSXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=txAef8UV6p9lWbjGqibKlS8DeWgF5/E7/8EXAcRD1Ek=;
        b=TZ98r+h9GUZ7hZHQOULhS0VEG60/V7z4hd1dUvp3vnk/Q69sV7JhzOxB4MAU7ptjhh
         vVLUlQxtuw5rqY/QHkRz3Zm5E/OYvcLxQuVjG6IpSM95sUfb75zVjLIIpI3GOiQ6zsRg
         RAvgb7Eb8Th1VKg+ctbN4/htiSZjEMs06qyuNghG09V+uCLMpVx0w2ALgq/jwtngbn8d
         EnVX7dpKbMETym512yHXb1D73pRfNZjW3ucl2ZDmTL6jMNjijyi9zKst/y3nw14Q5CXm
         CTgio8g+G8IDx88s9WJIvIkqw9OyJy+gNOOpddG2V34ogXRq3eOfLIm7tH4+S/h92TBC
         WnAg==
X-Gm-Message-State: AOAM532lGq/xB/xUyNxo7oL7JDaGgnJhAL3ySHqNQSy0YMKEbEaa8s3e
        /kXUBtAZQ0LhDwUWOtNWOn1YPg==
X-Google-Smtp-Source: ABdhPJxO41iehDOpsx9yNOMJXgNrDT76P3MJMA3dMnz35C+CmWMMuJg334OKZYV7kwvTXaxRhWMseg==
X-Received: by 2002:a1c:7702:: with SMTP id t2mr1629710wmi.169.1597994219747;
        Fri, 21 Aug 2020 00:16:59 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id y24sm2667957wmi.17.2020.08.21.00.16.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 00:16:59 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Subject: [PATCH 09/32] wireless: broadcom: brcm80211: brcmsmac: main: Remove a bunch of unused variables
Date:   Fri, 21 Aug 2020 08:16:21 +0100
Message-Id: <20200821071644.109970-10-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821071644.109970-1-lee.jones@linaro.org>
References: <20200821071644.109970-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 from drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c:27:
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c: In function ‘brcms_c_dotxstatus’:
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c:845:6: warning: variable ‘mcl’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c: In function ‘brcms_b_phy_reset’:
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c:1779:7: warning: variable ‘phy_in_reset’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c: In function ‘brcms_ucode_download’:
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c:2273:23: warning: variable ‘wlc’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c: In function ‘brcms_b_coreinit’:
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c:3176:6: warning: variable ‘sflags’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c: In function ‘brcms_c_set_chanspec’:
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c:3902:7: warning: variable ‘switchband’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c: In function ‘brcms_c_down’:
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c:5182:7: warning: variable ‘dev_gone’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c: In function ‘brcms_c_ofdm_rateset_war’:
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c:5393:5: warning: variable ‘r’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c: In function ‘mac80211_wlc_set_nrate’:
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c:5876:6: warning: variable ‘bcmerror’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c: In function ‘brcms_c_d11hdrs_mac80211’:
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c:6213:7: warning: variable ‘short_preamble’ set but not used [-Wunused-but-set-variable]

Cc: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>
Cc: Hante Meuleman <hante.meuleman@broadcom.com>
Cc: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Cc: Wright Feng <wright.feng@cypress.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list.pdl@broadcom.com
Cc: brcm80211-dev-list@cypress.com
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 .../broadcom/brcm80211/brcmsmac/main.c        | 38 ++-----------------
 1 file changed, 3 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
index 77494fc30c2c9..21691581b5327 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
@@ -842,7 +842,6 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 	uint supr_status;
 	bool lastframe;
 	struct ieee80211_hdr *h;
-	u16 mcl;
 	struct ieee80211_tx_info *tx_info;
 	struct ieee80211_tx_rate *txrate;
 	int i;
@@ -879,7 +878,6 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 	}
 
 	txh = (struct d11txh *) (p->data);
-	mcl = le16_to_cpu(txh->MacTxControlLow);
 
 	if (txs->phyerr)
 		brcms_dbg_tx(wlc->hw->d11core, "phyerr 0x%x, rate 0x%x\n",
@@ -1776,7 +1774,6 @@ void brcms_b_phy_reset(struct brcms_hardware *wlc_hw)
 {
 	struct brcms_phy_pub *pih = wlc_hw->band->pi;
 	u32 phy_bw_clkbits;
-	bool phy_in_reset = false;
 
 	brcms_dbg_info(wlc_hw->d11core, "wl%d: reset phy\n", wlc_hw->unit);
 
@@ -1799,7 +1796,6 @@ void brcms_b_phy_reset(struct brcms_hardware *wlc_hw)
 		/* reset the PHY */
 		brcms_b_core_ioctl(wlc_hw, (SICF_PRST | SICF_PCLKE),
 				   (SICF_PRST | SICF_PCLKE));
-		phy_in_reset = true;
 	} else {
 		brcms_b_core_ioctl(wlc_hw,
 				   (SICF_PRST | SICF_PCLKE | SICF_BWMASK),
@@ -2270,11 +2266,8 @@ static void brcms_ucode_write(struct brcms_hardware *wlc_hw,
 
 static void brcms_ucode_download(struct brcms_hardware *wlc_hw)
 {
-	struct brcms_c_info *wlc;
 	struct brcms_ucode *ucode = &wlc_hw->wlc->wl->ucode;
 
-	wlc = wlc_hw->wlc;
-
 	if (wlc_hw->ucode_loaded)
 		return;
 
@@ -3173,7 +3166,6 @@ static void brcms_b_coreinit(struct brcms_c_info *wlc)
 {
 	struct brcms_hardware *wlc_hw = wlc->hw;
 	struct bcma_device *core = wlc_hw->d11core;
-	u32 sflags;
 	u32 bcnint_us;
 	uint i = 0;
 	bool fifosz_fixup = false;
@@ -3206,7 +3198,7 @@ static void brcms_b_coreinit(struct brcms_c_info *wlc)
 
 	brcms_c_gpio_init(wlc);
 
-	sflags = bcma_aread32(core, BCMA_IOST);
+	bcma_aread32(core, BCMA_IOST);
 
 	if (D11REV_IS(wlc_hw->corerev, 17) || D11REV_IS(wlc_hw->corerev, 23)) {
 		if (BRCMS_ISNPHY(wlc_hw->band))
@@ -3899,7 +3891,6 @@ static void brcms_c_setband(struct brcms_c_info *wlc,
 static void brcms_c_set_chanspec(struct brcms_c_info *wlc, u16 chanspec)
 {
 	uint bandunit;
-	bool switchband = false;
 	u16 old_chanspec = wlc->chanspec;
 
 	if (!brcms_c_valid_chanspec_db(wlc->cmi, chanspec)) {
@@ -3912,7 +3903,6 @@ static void brcms_c_set_chanspec(struct brcms_c_info *wlc, u16 chanspec)
 	if (wlc->pub->_nbands > 1) {
 		bandunit = chspec_bandunit(chanspec);
 		if (wlc->band->bandunit != bandunit || wlc->bandinit_pending) {
-			switchband = true;
 			if (wlc->bandlocked) {
 				brcms_err(wlc->hw->d11core,
 					  "wl%d: %s: chspec %d band is locked!\n",
@@ -5179,7 +5169,6 @@ uint brcms_c_down(struct brcms_c_info *wlc)
 
 	uint callbacks = 0;
 	int i;
-	bool dev_gone = false;
 
 	brcms_dbg_info(wlc->hw->d11core, "wl%d\n", wlc->pub->unit);
 
@@ -5197,7 +5186,7 @@ uint brcms_c_down(struct brcms_c_info *wlc)
 
 	callbacks += brcms_b_bmac_down_prep(wlc->hw);
 
-	dev_gone = brcms_deviceremoved(wlc);
+	brcms_deviceremoved(wlc);
 
 	/* Call any registered down handlers */
 	for (i = 0; i < BRCMS_MAXMODULES; i++) {
@@ -5390,15 +5379,7 @@ brcms_c_set_internal_rateset(struct brcms_c_info *wlc,
 
 static void brcms_c_ofdm_rateset_war(struct brcms_c_info *wlc)
 {
-	u8 r;
-	bool war = false;
-
-	if (wlc->pub->associated)
-		r = wlc->bsscfg->current_bss->rateset.rates[0];
-	else
-		r = wlc->default_bss->rateset.rates[0];
-
-	wlc_phy_ofdm_rateset_war(wlc->band->pi, war);
+	wlc_phy_ofdm_rateset_war(wlc->band->pi, false);
 }
 
 int brcms_c_set_channel(struct brcms_c_info *wlc, u16 channel)
@@ -5873,7 +5854,6 @@ mac80211_wlc_set_nrate(struct brcms_c_info *wlc, struct brcms_band *cur_band,
 	bool issgi = ((int_val & NRATE_SGI_MASK) >> NRATE_SGI_SHIFT);
 	bool override_mcs_only = ((int_val & NRATE_OVERRIDE_MCS_ONLY)
 				  == NRATE_OVERRIDE_MCS_ONLY);
-	int bcmerror = 0;
 
 	if (!ismcs)
 		return (u32) rate;
@@ -5884,7 +5864,6 @@ mac80211_wlc_set_nrate(struct brcms_c_info *wlc, struct brcms_band *cur_band,
 		if (stf > PHY_TXC1_MODE_SDM) {
 			brcms_err(core, "wl%d: %s: Invalid stf\n",
 				  wlc->pub->unit, __func__);
-			bcmerror = -EINVAL;
 			goto done;
 		}
 
@@ -5895,7 +5874,6 @@ mac80211_wlc_set_nrate(struct brcms_c_info *wlc, struct brcms_band *cur_band,
 			     && (stf != PHY_TXC1_MODE_CDD))) {
 				brcms_err(core, "wl%d: %s: Invalid mcs 32\n",
 					  wlc->pub->unit, __func__);
-				bcmerror = -EINVAL;
 				goto done;
 			}
 			/* mcs > 7 must use stf SDM */
@@ -5917,7 +5895,6 @@ mac80211_wlc_set_nrate(struct brcms_c_info *wlc, struct brcms_band *cur_band,
 			     && (stf == PHY_TXC1_MODE_STBC))) {
 				brcms_err(core, "wl%d: %s: Invalid STBC\n",
 					  wlc->pub->unit, __func__);
-				bcmerror = -EINVAL;
 				goto done;
 			}
 		}
@@ -5925,7 +5902,6 @@ mac80211_wlc_set_nrate(struct brcms_c_info *wlc, struct brcms_band *cur_band,
 		if ((stf != PHY_TXC1_MODE_CDD) && (stf != PHY_TXC1_MODE_SISO)) {
 			brcms_err(core, "wl%d: %s: Invalid OFDM\n",
 				  wlc->pub->unit, __func__);
-			bcmerror = -EINVAL;
 			goto done;
 		}
 	} else if (is_cck_rate(rate)) {
@@ -5933,20 +5909,17 @@ mac80211_wlc_set_nrate(struct brcms_c_info *wlc, struct brcms_band *cur_band,
 		    || (stf != PHY_TXC1_MODE_SISO)) {
 			brcms_err(core, "wl%d: %s: Invalid CCK\n",
 				  wlc->pub->unit, __func__);
-			bcmerror = -EINVAL;
 			goto done;
 		}
 	} else {
 		brcms_err(core, "wl%d: %s: Unknown rate type\n",
 			  wlc->pub->unit, __func__);
-		bcmerror = -EINVAL;
 		goto done;
 	}
 	/* make sure multiple antennae are available for non-siso rates */
 	if ((stf != PHY_TXC1_MODE_SISO) && (wlc->stf->txstreams == 1)) {
 		brcms_err(core, "wl%d: %s: SISO antenna but !SISO "
 			  "request\n", wlc->pub->unit, __func__);
-		bcmerror = -EINVAL;
 		goto done;
 	}
 
@@ -6210,7 +6183,6 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	bool use_rts = false;
 	bool use_cts = false;
 	bool use_rifs = false;
-	bool short_preamble[2] = { false, false };
 	u8 preamble_type[2] = { BRCMS_LONG_PREAMBLE, BRCMS_LONG_PREAMBLE };
 	u8 rts_preamble_type[2] = { BRCMS_LONG_PREAMBLE, BRCMS_LONG_PREAMBLE };
 	u8 *rts_plcp, rts_plcp_fallback[D11_PHY_HDR_LEN];
@@ -6296,10 +6268,6 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 				rspec[k] =
 				    hw->wiphy->bands[tx_info->band]->
 				    bitrates[txrate[k]->idx].hw_value;
-				short_preamble[k] =
-				    txrate[k]->
-				    flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE ?
-				    true : false;
 			} else {
 				rspec[k] = BRCM_RATE_1M;
 			}
-- 
2.25.1

