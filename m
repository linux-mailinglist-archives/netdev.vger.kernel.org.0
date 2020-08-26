Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0C6252A32
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 11:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbgHZJgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 05:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728420AbgHZJfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 05:35:30 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19494C061363
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 02:34:41 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id b18so1092940wrs.7
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 02:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gIFuAgbU5KsSZartda2wv/vItp6gRgcDSq7Ia+efgpk=;
        b=avYQsDcIlHb1v5YkJd/vaqkVLjM5XIcFdZbGcQZAWvKMT1OUpi+Y2PQUXh8dRLs+BR
         z4rw/6NOguSsCeVFa6gnWDpsAbyQu9Dj83CYvpijW3Qq9SMDOeJepgI4wr+hBDGp5k75
         QzcY2wKuN/KWNg89b3So2XrfPhyAytAZQTLKt3aU9yjpqGZ+RlnVWKsHleZDYyoWVtne
         W6IyLZ8w8hUbG50HFhpg21opLILC1ZNMA93YaWgGQSxfMB9pEPBAE2Ml8222w76w7n8s
         kFmpRxCZlx8vznMIExuKDi67foRE7NJDwkyaZYAuswIfmY2kEUnh+5R+U2fvcLWM4vN4
         TccQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gIFuAgbU5KsSZartda2wv/vItp6gRgcDSq7Ia+efgpk=;
        b=dFSDVxKsqM49M72yVAANkODw4aqLtHGtoqS/UFko7YiAFtVyQT5O0Nesu+WUVbN8sQ
         JiVnP8sZVEydkbSWIe2KxgkaE2i3LdJk3OWJBUMO1SUgJ1fQkvfw0+dygSPiSwJXbSt4
         HAWVgBPpK9oSp1wbVl503NRsUHSkPoD5qTmqdzxgm6f4uHbht9aRy9cf782hoxfKz/IB
         C5f8Im5nIk+auj7koX6iNEIRCWRv+aJaNFTjuE5CgciVguFx6ChkZEoO/lbSNNZmqLrD
         sOaS86qWHY1gXq27Y2JABJcXzEO2nXQtzx86+kQ+Yw6vWPdJq/KXiQRH6M0p2a2SEVJl
         wRPQ==
X-Gm-Message-State: AOAM532hYnlx9JI5ASc3SzBYGWHjJ0gPtrgKBX3DUV/FO7tAu+28A2HA
        sw4DR03V3jCfab2HmWzeALZcvA==
X-Google-Smtp-Source: ABdhPJwGiOx6SWFxrf5y6KCMyUCNb/Pbq+bbg4PuiTg8ehYEhO9dGBYbCn1ae2FRCyZ8kjZM3uUqbQ==
X-Received: by 2002:adf:b1dc:: with SMTP id r28mr14310325wra.242.1598434479728;
        Wed, 26 Aug 2020 02:34:39 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id u3sm3978759wml.44.2020.08.26.02.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 02:34:39 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        zhong jiang <zhongjiang@huawei.com>,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Subject: [PATCH 28/30] wireless: broadcom: brcm80211: phy_n: Remove a bunch of unused variables
Date:   Wed, 26 Aug 2020 10:33:59 +0100
Message-Id: <20200826093401.1458456-29-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200826093401.1458456-1-lee.jones@linaro.org>
References: <20200826093401.1458456-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 In file included from drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c:16:
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c: In function ‘wlc_phy_spurwar_nphy’:
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c:19036:6: warning: variable ‘tempval’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c: In function ‘wlc_phy_tempsense_nphy’:
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c:21983:28: warning: variable ‘RfctrlMiscReg6_save’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c: In function ‘wlc_phy_rssi_compute_nphy’:
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c:22986:6: warning: variable ‘phyRx0_l’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c: In function ‘wlc_phy_runsamples_nphy’:
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c:23101:6: warning: variable ‘lpf_bw_ctl_miscreg4’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c:23100:50: warning: variable ‘lpf_bw_ctl_miscreg3’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c: In function ‘wlc_phy_iqcal_gainparams_nphy’:
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c:23406:6: warning: variable ‘idx’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c: In function ‘wlc_phy_a2_nphy’:
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c:24707:7: warning: variable ‘phy_a6’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c: In function ‘wlc_phy_a3_nphy’:
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c:24999:7: warning: variable ‘phy_a11’ set but not used [-Wunused-but-set-variable]

Cc: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>
Cc: Hante Meuleman <hante.meuleman@broadcom.com>
Cc: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Cc: Wright Feng <wright.feng@cypress.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: zhong jiang <zhongjiang@huawei.com>
Cc: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list.pdl@broadcom.com
Cc: brcm80211-dev-list@cypress.com
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 .../broadcom/brcm80211/brcmsmac/phy/phy_n.c   | 47 ++++---------------
 1 file changed, 8 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
index a3f094568cfb2..8580a27547891 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
@@ -19033,7 +19033,6 @@ static void wlc_phy_spurwar_nphy(struct brcms_phy *pi)
 	u32 nphy_adj_noise_var_buf[] = { 0x3ff, 0x3ff };
 	bool isAdjustNoiseVar = false;
 	uint numTonesAdjust = 0;
-	u32 tempval = 0;
 
 	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
 		if (pi->phyhang_avoid)
@@ -19139,9 +19138,6 @@ static void wlc_phy_spurwar_nphy(struct brcms_phy *pi)
 					numTonesAdjust,
 					nphy_adj_tone_id_buf,
 					nphy_adj_noise_var_buf);
-
-				tempval = 0;
-
 			} else {
 				wlc_phy_adjust_min_noisevar_nphy(pi, 0, NULL,
 								 NULL);
@@ -21980,7 +21976,7 @@ s16 wlc_phy_tempsense_nphy(struct brcms_phy *pi)
 		u16 auxADC_rssi_ctrlL, auxADC_rssi_ctrlH;
 		s32 auxADC_Vl;
 		u16 RfctrlOverride5_save, RfctrlOverride6_save;
-		u16 RfctrlMiscReg5_save, RfctrlMiscReg6_save;
+		u16 RfctrlMiscReg5_save;
 		u16 RSSIMultCoef0QPowerDet_save;
 		u16 tempsense_Rcal;
 
@@ -21995,7 +21991,7 @@ s16 wlc_phy_tempsense_nphy(struct brcms_phy *pi)
 		RfctrlOverride5_save = read_phy_reg(pi, 0x346);
 		RfctrlOverride6_save = read_phy_reg(pi, 0x347);
 		RfctrlMiscReg5_save = read_phy_reg(pi, 0x344);
-		RfctrlMiscReg6_save = read_phy_reg(pi, 0x345);
+		read_phy_reg(pi, 0x345); /* RfctrlMiscReg6_save */
 
 		wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x0A, 16,
 					&auxADC_Vmid_save);
@@ -22983,7 +22979,7 @@ int
 wlc_phy_rssi_compute_nphy(struct brcms_phy *pi, struct d11rxhdr *rxh)
 {
 	s16 rxpwr, rxpwr0, rxpwr1;
-	s16 phyRx0_l, phyRx2_l;
+	s16 phyRx2_l;
 
 	rxpwr = 0;
 	rxpwr0 = rxh->PhyRxStatus_1 & PRXS1_nphy_PWR0_MASK;
@@ -22994,7 +22990,6 @@ wlc_phy_rssi_compute_nphy(struct brcms_phy *pi, struct d11rxhdr *rxh)
 	if (rxpwr1 > 127)
 		rxpwr1 -= 256;
 
-	phyRx0_l = rxh->PhyRxStatus_0 & 0x00ff;
 	phyRx2_l = rxh->PhyRxStatus_2 & 0x00ff;
 	if (phyRx2_l > 127)
 		phyRx2_l -= 256;
@@ -23097,8 +23092,7 @@ wlc_phy_runsamples_nphy(struct brcms_phy *pi, u16 num_samps, u16 loops,
 	u16 bb_mult;
 	u8 phy_bw, sample_cmd;
 	u16 orig_RfseqCoreActv;
-	u16 lpf_bw_ctl_override3, lpf_bw_ctl_override4, lpf_bw_ctl_miscreg3,
-	    lpf_bw_ctl_miscreg4;
+	u16 lpf_bw_ctl_override3, lpf_bw_ctl_override4;
 
 	if (pi->phyhang_avoid)
 		wlc_phy_stay_in_carriersearch_nphy(pi, true);
@@ -23111,12 +23105,7 @@ wlc_phy_runsamples_nphy(struct brcms_phy *pi, u16 num_samps, u16 loops,
 
 		lpf_bw_ctl_override3 = read_phy_reg(pi, 0x342) & (0x1 << 7);
 		lpf_bw_ctl_override4 = read_phy_reg(pi, 0x343) & (0x1 << 7);
-		if (lpf_bw_ctl_override3 | lpf_bw_ctl_override4) {
-			lpf_bw_ctl_miscreg3 = read_phy_reg(pi, 0x340) &
-					      (0x7 << 8);
-			lpf_bw_ctl_miscreg4 = read_phy_reg(pi, 0x341) &
-					      (0x7 << 8);
-		} else {
+		if (!(lpf_bw_ctl_override3 | lpf_bw_ctl_override4)) {
 			wlc_phy_rfctrl_override_nphy_rev7(
 				pi,
 				(0x1 << 7),
@@ -23126,12 +23115,9 @@ wlc_phy_runsamples_nphy(struct brcms_phy *pi, u16 num_samps, u16 loops,
 				NPHY_REV7_RFCTRLOVERRIDE_ID1);
 
 			pi->nphy_sample_play_lpf_bw_ctl_ovr = true;
-
-			lpf_bw_ctl_miscreg3 = read_phy_reg(pi, 0x340) &
-					      (0x7 << 8);
-			lpf_bw_ctl_miscreg4 = read_phy_reg(pi, 0x341) &
-					      (0x7 << 8);
 		}
+		read_phy_reg(pi, 0x340); /* lpf_bw_ctl_miscreg3 */
+		read_phy_reg(pi, 0x341); /* lpf_bw_ctl_miscreg4 */
 	}
 
 	if ((pi->nphy_bb_mult_save & BB_MULT_VALID_MASK) == 0) {
@@ -23403,7 +23389,6 @@ wlc_phy_iqcal_gainparams_nphy(struct brcms_phy *pi, u16 core_no,
 			      struct nphy_iqcal_params *params)
 {
 	u8 k;
-	int idx;
 	u16 gain_index;
 	u8 band_idx = (CHSPEC_IS5G(pi->radio_chanspec) ? 1 : 0);
 
@@ -23436,13 +23421,10 @@ wlc_phy_iqcal_gainparams_nphy(struct brcms_phy *pi, u16 core_no,
 			      (target_gain.pga[core_no] << 4) |
 			      (target_gain.txgm[core_no] << 8));
 
-		idx = -1;
 		for (k = 0; k < NPHY_IQCAL_NUMGAINS; k++) {
 			if (tbl_iqcal_gainparams_nphy[band_idx][k][0] ==
-			    gain_index) {
-				idx = k;
+			    gain_index)
 				break;
-			}
 		}
 
 		params->txgm = tbl_iqcal_gainparams_nphy[band_idx][k][1];
@@ -24704,7 +24686,6 @@ wlc_phy_a2_nphy(struct brcms_phy *pi, struct nphy_ipa_txcalgains *txgains,
 {
 	u16 phy_a1, phy_a2, phy_a3;
 	u16 phy_a4, phy_a5;
-	bool phy_a6;
 	u8 phy_a7, m[2];
 	u32 phy_a8 = 0;
 	struct nphy_txgains phy_a9;
@@ -24714,9 +24695,6 @@ wlc_phy_a2_nphy(struct brcms_phy *pi, struct nphy_ipa_txcalgains *txgains,
 
 	phy_a7 = (core == PHY_CORE_0) ? 1 : 0;
 
-	phy_a6 = ((cal_mode == CAL_GCTRL)
-		  || (cal_mode == CAL_SOFT)) ? true : false;
-
 	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 
 		phy_a9 = wlc_phy_get_tx_gain_nphy(pi);
@@ -24996,7 +24974,6 @@ static u8 wlc_phy_a3_nphy(struct brcms_phy *pi, u8 start_gain, u8 core)
 	s32 phy_a7, phy_a8;
 	u32 phy_a9;
 	int phy_a10;
-	bool phy_a11 = false;
 	int phy_a12;
 	u8 phy_a13 = 0;
 	u8 phy_a14;
@@ -25064,8 +25041,6 @@ static u8 wlc_phy_a3_nphy(struct brcms_phy *pi, u8 start_gain, u8 core)
 			if (!phy_a6 && (phy_a3 != phy_a5)) {
 				if (!phy_a3)
 					phy_a12 -= (u8) phy_a1;
-
-				phy_a11 = true;
 				break;
 			}
 
@@ -25079,8 +25054,6 @@ static u8 wlc_phy_a3_nphy(struct brcms_phy *pi, u8 start_gain, u8 core)
 					phy_a12 = phy_a14;
 				else
 					phy_a12 = phy_a13;
-
-				phy_a11 = true;
 				break;
 			}
 
@@ -25110,8 +25083,6 @@ static u8 wlc_phy_a3_nphy(struct brcms_phy *pi, u8 start_gain, u8 core)
 			if (!phy_a6 && (phy_a3 != phy_a5)) {
 				if (!phy_a3)
 					phy_a12 -= (u8) phy_a1;
-
-				phy_a11 = true;
 				break;
 			}
 
@@ -25125,8 +25096,6 @@ static u8 wlc_phy_a3_nphy(struct brcms_phy *pi, u8 start_gain, u8 core)
 					phy_a12 = 0;
 				else
 					phy_a12 = 127;
-
-				phy_a11 = true;
 				break;
 			}
 
-- 
2.25.1

