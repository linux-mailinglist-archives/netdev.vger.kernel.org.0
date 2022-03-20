Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81FD84E1C41
	for <lists+netdev@lfdr.de>; Sun, 20 Mar 2022 16:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245032AbiCTPWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 11:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234346AbiCTPWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 11:22:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF98E1AE63D
        for <netdev@vger.kernel.org>; Sun, 20 Mar 2022 08:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647789641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mMHoF4oLIGcLK1h/iBDUgENjgW/5WCbA77DMrsLcqDY=;
        b=XPBi0duBcLpdu8UI9PRDc2WSc27OIGQBFq6Uf+DMPHeP5Dklh5yJ5wiEQ9Tau9Sn+TPjkW
        NCsH19YWZZPE1n6KWPLRdy1r3cMIc4CDLOum+N9Aax/aD5amrJw0T9CkyE08PbE58apx79
        oQ/whKseIAH8HLKm3EhFATC42QEJ8v0=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-zSRr7HqYOESrSRKojn38tg-1; Sun, 20 Mar 2022 11:20:40 -0400
X-MC-Unique: zSRr7HqYOESrSRKojn38tg-1
Received: by mail-qv1-f70.google.com with SMTP id p12-20020a0c9a0c000000b0043299cbbd36so10012059qvd.16
        for <netdev@vger.kernel.org>; Sun, 20 Mar 2022 08:20:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mMHoF4oLIGcLK1h/iBDUgENjgW/5WCbA77DMrsLcqDY=;
        b=YDzKbw2ddy7x36AMFzMGhzmRtsQthx6uisKy6jESZ14B04+fheJcr9BCPQA9frnRnK
         2jnkP5rAah/54JHInhH7B8/UxtK5HcXA7YRug55SOtEI03QXSPs4j3M6ITxsQIA8GGN9
         Ktbmzzuit1nKuCypFGo0njzurdenUDXLTWHYH+FJbaC+xrcjwnHXvbIUp5u2tMfDf/au
         cuayAmh1zfZSp6hj2iyXeHWdS416ixYfBF3DblIj0kTgpKVLuXpLV5f7EDHDnQ5mgaH7
         HeCDkA682sx0CqgJEn5p/4CRlgkqYNNoFCprjfiKNRYEci68MTea/03Jxn3So9s0GSGf
         OT8g==
X-Gm-Message-State: AOAM530ZC43Jn8J6kvtnYCbjRyyU1I6DJjUT54JAlv+e3XUMy2V12ICP
        SBlBJmO9IVqStGZaRjPY+pIsVkGPcimYVMtexWBs2suAgdT5Xudzui8Ey6KvDMLysMwnjzRMa09
        DIrdVI2qst2kt0d+p
X-Received: by 2002:a05:620a:d96:b0:67a:ee04:d947 with SMTP id q22-20020a05620a0d9600b0067aee04d947mr10823544qkl.237.1647789639575;
        Sun, 20 Mar 2022 08:20:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJww3Jh7JH+2cXy3Yo745MCSk50TxGBn+pD01Iwa4SBik/FxBhJb/yL+61DlFQRR1guQkKBzUw==
X-Received: by 2002:a05:620a:d96:b0:67a:ee04:d947 with SMTP id q22-20020a05620a0d9600b0067aee04d947mr10823533qkl.237.1647789639296;
        Sun, 20 Mar 2022 08:20:39 -0700 (PDT)
Received: from localhost.localdomain.com (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id x20-20020ac85f14000000b002e1ee1c56c3sm8541952qta.76.2022.03.20.08.20.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Mar 2022 08:20:38 -0700 (PDT)
From:   trix@redhat.com
To:     toke@toke.dk, kvalo@kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] ath9k: initialize arrays at compile time
Date:   Sun, 20 Mar 2022 08:20:28 -0700
Message-Id: <20220320152028.2263518-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Early clearing of arrays with
memset(array, 0, size);
is equivilent to initializing the array in its decl with
array[size] = { 0 };

Since compile time is preferred over runtime,
convert the memsets to initializations.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c  |  6 ++----
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |  4 +---
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c  | 14 ++++++--------
 drivers/net/wireless/ath/ath9k/eeprom.c        |  3 +--
 drivers/net/wireless/ath/ath9k/eeprom_4k.c     |  4 +---
 drivers/net/wireless/ath/ath9k/eeprom_9287.c   |  4 +---
 drivers/net/wireless/ath/ath9k/eeprom_def.c    |  4 +---
 drivers/net/wireless/ath/ath9k/wow.c           |  7 ++-----
 8 files changed, 15 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index dc24da1ff00b1..39fcc158cb159 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -891,10 +891,9 @@ static void ar9003_hw_tx_iq_cal_outlier_detection(struct ath_hw *ah,
 {
 	int i, im, nmeasurement;
 	int magnitude, phase;
-	u32 tx_corr_coeff[MAX_MEASUREMENT][AR9300_MAX_CHAINS];
+	u32 tx_corr_coeff[MAX_MEASUREMENT][AR9300_MAX_CHAINS] = { 0 };
 	struct ath9k_hw_cal_data *caldata = ah->caldata;
 
-	memset(tx_corr_coeff, 0, sizeof(tx_corr_coeff));
 	for (i = 0; i < MAX_MEASUREMENT / 2; i++) {
 		tx_corr_coeff[i * 2][0] = tx_corr_coeff[(i * 2) + 1][0] =
 					AR_PHY_TX_IQCAL_CORR_COEFF_B0(i);
@@ -1155,10 +1154,9 @@ static void ar9003_hw_tx_iq_cal_post_proc(struct ath_hw *ah,
 static void ar9003_hw_tx_iq_cal_reload(struct ath_hw *ah)
 {
 	struct ath9k_hw_cal_data *caldata = ah->caldata;
-	u32 tx_corr_coeff[MAX_MEASUREMENT][AR9300_MAX_CHAINS];
+	u32 tx_corr_coeff[MAX_MEASUREMENT][AR9300_MAX_CHAINS] = { 0 };
 	int i, im;
 
-	memset(tx_corr_coeff, 0, sizeof(tx_corr_coeff));
 	for (i = 0; i < MAX_MEASUREMENT / 2; i++) {
 		tx_corr_coeff[i * 2][0] = tx_corr_coeff[(i * 2) + 1][0] =
 					AR_PHY_TX_IQCAL_CORR_COEFF_B0(i);
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index b0a4ca3559fd8..55fdee5ec93be 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -5451,14 +5451,12 @@ static void ath9k_hw_ar9300_set_txpower(struct ath_hw *ah,
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
 	struct ar9300_modal_eep_header *modal_hdr;
-	u8 targetPowerValT2[ar9300RateSize];
+	u8 targetPowerValT2[ar9300RateSize] = { 0 };
 	u8 target_power_val_t2_eep[ar9300RateSize];
 	u8 targetPowerValT2_tpc[ar9300RateSize];
 	unsigned int i = 0, paprd_scale_factor = 0;
 	u8 pwr_idx, min_pwridx = 0;
 
-	memset(targetPowerValT2, 0 , sizeof(targetPowerValT2));
-
 	/*
 	 * Get target powers from EEPROM - our baseline for TX Power
 	 */
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
index 34e1009402846..d9c5b6bb5db07 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
@@ -419,13 +419,16 @@ static inline int find_proper_scale(int expn, int N)
 static bool create_pa_curve(u32 *data_L, u32 *data_U, u32 *pa_table, u16 *gain)
 {
 	unsigned int thresh_accum_cnt;
-	int x_est[NUM_BIN + 1], Y[NUM_BIN + 1], theta[NUM_BIN + 1];
+	int x_est[NUM_BIN + 1] = { 0 };
+	int Y[NUM_BIN + 1] = { 0 };
+	int theta[NUM_BIN + 1] = { 0 };
 	int PA_in[NUM_BIN + 1];
 	int B1_tmp[NUM_BIN + 1], B2_tmp[NUM_BIN + 1];
 	unsigned int B1_abs_max, B2_abs_max;
 	int max_index, scale_factor;
-	int y_est[NUM_BIN + 1];
-	int x_est_fxp1_nonlin, x_tilde[NUM_BIN + 1];
+	int y_est[NUM_BIN + 1] = { 0 };
+	int x_est_fxp1_nonlin;
+	int x_tilde[NUM_BIN + 1] = { 0 };
 	unsigned int x_tilde_abs;
 	int G_fxp, Y_intercept, order_x_by_y, M, I, L, sum_y_sqr, sum_y_quad;
 	int Q_x, Q_B1, Q_B2, beta_raw, alpha_raw, scale_B;
@@ -439,11 +442,6 @@ static bool create_pa_curve(u32 *data_L, u32 *data_U, u32 *pa_table, u16 *gain)
 	thresh_accum_cnt = 16;
 	scale_factor = 5;
 	max_index = 0;
-	memset(theta, 0, sizeof(theta));
-	memset(x_est, 0, sizeof(x_est));
-	memset(Y, 0, sizeof(Y));
-	memset(y_est, 0, sizeof(y_est));
-	memset(x_tilde, 0, sizeof(x_tilde));
 
 	for (i = 0; i < NUM_BIN; i++) {
 		s32 accum_cnt, accum_tx, accum_rx, accum_ang;
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index efb7889142d47..061d33921495c 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -480,7 +480,7 @@ void ath9k_hw_get_gain_boundaries_pdadcs(struct ath_hw *ah,
 		[AR5416_MAX_PWR_RANGE_IN_HALF_DB];
 
 	u8 *pVpdL, *pVpdR, *pPwrL, *pPwrR;
-	u8 minPwrT4[AR5416_NUM_PD_GAINS];
+	u8 minPwrT4[AR5416_NUM_PD_GAINS] = { 0 };
 	u8 maxPwrT4[AR5416_NUM_PD_GAINS];
 	int16_t vpdStep;
 	int16_t tmpVal;
@@ -500,7 +500,6 @@ void ath9k_hw_get_gain_boundaries_pdadcs(struct ath_hw *ah,
 	else
 		intercepts = AR5416_PD_GAIN_ICEPTS;
 
-	memset(&minPwrT4, 0, AR5416_NUM_PD_GAINS);
 	ath9k_hw_get_channel_centers(ah, chan, &centers);
 
 	for (numPiers = 0; numPiers < availPiers; numPiers++) {
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index e8c2cc03be0cb..1d295d7fa0848 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -583,12 +583,10 @@ static void ath9k_hw_4k_set_txpower(struct ath_hw *ah,
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	struct ar5416_eeprom_4k *pEepData = &ah->eeprom.map4k;
 	struct modal_eep_4k_header *pModal = &pEepData->modalHeader;
-	int16_t ratesArray[Ar5416RateSize];
+	int16_t ratesArray[Ar5416RateSize] = { 0 };
 	u8 ht40PowerIncForPdadc = 2;
 	int i;
 
-	memset(ratesArray, 0, sizeof(ratesArray));
-
 	if (ath9k_hw_4k_get_eeprom_rev(ah) >= AR5416_EEP_MINOR_VER_2)
 		ht40PowerIncForPdadc = pModal->ht40PowerIncForPdadc;
 
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index 3caa149b10131..b068e15226022 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -711,12 +711,10 @@ static void ath9k_hw_ar9287_set_txpower(struct ath_hw *ah,
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	struct ar9287_eeprom *pEepData = &ah->eeprom.map9287;
 	struct modal_eep_ar9287_header *pModal = &pEepData->modalHeader;
-	int16_t ratesArray[Ar5416RateSize];
+	int16_t ratesArray[Ar5416RateSize] = { 0 };
 	u8 ht40PowerIncForPdadc = 2;
 	int i;
 
-	memset(ratesArray, 0, sizeof(ratesArray));
-
 	if (ath9k_hw_ar9287_get_eeprom_rev(ah) >= AR9287_EEP_MINOR_VER_2)
 		ht40PowerIncForPdadc = pModal->ht40PowerIncForPdadc;
 
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 9729a69d3e2e3..b5ee261c86382 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -1150,12 +1150,10 @@ static void ath9k_hw_def_set_txpower(struct ath_hw *ah,
 	struct ar5416_eeprom_def *pEepData = &ah->eeprom.def;
 	struct modal_eep_header *pModal =
 		&(pEepData->modalHeader[IS_CHAN_2GHZ(chan)]);
-	int16_t ratesArray[Ar5416RateSize];
+	int16_t ratesArray[Ar5416RateSize] = { 0 };
 	u8 ht40PowerIncForPdadc = 2;
 	int i, cck_ofdm_delta = 0;
 
-	memset(ratesArray, 0, sizeof(ratesArray));
-
 	if (ath9k_hw_def_get_eeprom_rev(ah) >= AR5416_EEP_MINOR_VER_2)
 		ht40PowerIncForPdadc = pModal->ht40PowerIncForPdadc;
 
diff --git a/drivers/net/wireless/ath/ath9k/wow.c b/drivers/net/wireless/ath/ath9k/wow.c
index 8d0b1730a9d5b..3d39c7ec1da30 100644
--- a/drivers/net/wireless/ath/ath9k/wow.c
+++ b/drivers/net/wireless/ath/ath9k/wow.c
@@ -53,11 +53,8 @@ static int ath9k_wow_add_disassoc_deauth_pattern(struct ath_softc *sc)
 	struct ath_common *common = ath9k_hw_common(ah);
 	int pattern_count = 0;
 	int ret, i, byte_cnt = 0;
-	u8 dis_deauth_pattern[MAX_PATTERN_SIZE];
-	u8 dis_deauth_mask[MAX_PATTERN_SIZE];
-
-	memset(dis_deauth_pattern, 0, MAX_PATTERN_SIZE);
-	memset(dis_deauth_mask, 0, MAX_PATTERN_SIZE);
+	u8 dis_deauth_pattern[MAX_PATTERN_SIZE] = { 0 };
+	u8 dis_deauth_mask[MAX_PATTERN_SIZE] = { 0 };
 
 	/*
 	 * Create Dissassociate / Deauthenticate packet filter
-- 
2.26.3

