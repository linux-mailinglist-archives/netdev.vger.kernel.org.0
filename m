Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 312194E9789
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 15:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242967AbiC1NJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 09:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242945AbiC1NJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 09:09:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D648C5DA5A
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 06:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648472860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=PtHN8VWVvChKHe7fcrbgQxII1uEL3nooKYmXW4yHoDA=;
        b=i78+TffzEHDloD0NigFnvcBaIGTVJqjNTxXnb4Pp40sNw7SPXDYEIKsfvE2nRQHjE8FW+Z
        z6gn+OFf0wYDjLcnqsioGXVxlIzpRC0IEfwaIAsXF1T3zg4oQznyNSldARjDSOqM3DG4Uc
        9IYW2buBRXCxRTZjDaBRoJtFm5szCXs=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-52-T6rs88AePTGIYSueFpLKzA-1; Mon, 28 Mar 2022 09:07:37 -0400
X-MC-Unique: T6rs88AePTGIYSueFpLKzA-1
Received: by mail-qv1-f72.google.com with SMTP id g2-20020a0562141cc200b004123b0abe18so11306896qvd.2
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 06:07:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PtHN8VWVvChKHe7fcrbgQxII1uEL3nooKYmXW4yHoDA=;
        b=o4dT3ioCKY+x7zbW618Kl3B8FDYkEK79tJmhHytfbONsCFGxvizbPYeL3aqafCX1np
         FIiQC4vcRF31UForRtfk/09aqBSkMBmJkv4CRJNDHbTJlAahEj22DxoZxVdZPTsEpMM3
         sfLJNy7iH1Vm4eHI9A6/6Sip1GMmr9/SXPPFZBrhar1nq9QUgviN21mk8d5VOyrfoDFd
         LCzYPmFssZ/CFb83xScR9lC0rQS7vIEeUHpLUJ4K4TVZSgHZtg6oI5L7U4qquRbK22dv
         QbSMDMsrl5uWZaqogTfnPmrRiqbXMs2lIsPsgQ/RXbjhHjMU18CpG7LJwNr4JOlo+9WW
         6tSA==
X-Gm-Message-State: AOAM533vuktN1E3CPuFzntxdwct20bYW/wVjUrSR7LE9OKFAcmcxFCJw
        V3eF6KxjaTO2Ah8Q0X6/6H3fbgvw97YvWIJUZaYU0XSkkp6lvMyDKoPrbWNMRNHfFUcRmx83AJV
        ZySIUSt/ZhhIiVEuA
X-Received: by 2002:a05:620a:44d6:b0:67b:2dd8:3064 with SMTP id y22-20020a05620a44d600b0067b2dd83064mr15958159qkp.219.1648472856939;
        Mon, 28 Mar 2022 06:07:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzXF6xziFnZvT7B9Thf2sImzwCkc8tQCsS4WrJzX9a9Q+rXQD1iC0oh26pKBl4kArr2VB9/qQ==
X-Received: by 2002:a05:620a:44d6:b0:67b:2dd8:3064 with SMTP id y22-20020a05620a44d600b0067b2dd83064mr15958127qkp.219.1648472856653;
        Mon, 28 Mar 2022 06:07:36 -0700 (PDT)
Received: from localhost.localdomain.com (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id n8-20020ac85a08000000b002e06aa02021sm13035414qta.49.2022.03.28.06.07.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 06:07:35 -0700 (PDT)
From:   trix@redhat.com
To:     toke@toke.dk, kvalo@kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH v2] ath9k: initialize arrays at compile time
Date:   Mon, 28 Mar 2022 06:07:27 -0700
Message-Id: <20220328130727.3090827-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Early clearing of arrays with
memset(array, 0, size);
is equivilent to initializing the array in its decl with
array[size] = {};

Convert the memsets to initializations.

Signed-off-by: Tom Rix <trix@redhat.com>
---
v2: cleanup commit log
    change { 0 } to {}
    
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
index dc24da1ff00b1..142b11085bbc6 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -891,10 +891,9 @@ static void ar9003_hw_tx_iq_cal_outlier_detection(struct ath_hw *ah,
 {
 	int i, im, nmeasurement;
 	int magnitude, phase;
-	u32 tx_corr_coeff[MAX_MEASUREMENT][AR9300_MAX_CHAINS];
+	u32 tx_corr_coeff[MAX_MEASUREMENT][AR9300_MAX_CHAINS] = {};
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
+	u32 tx_corr_coeff[MAX_MEASUREMENT][AR9300_MAX_CHAINS] = {};
 	int i, im;
 
-	memset(tx_corr_coeff, 0, sizeof(tx_corr_coeff));
 	for (i = 0; i < MAX_MEASUREMENT / 2; i++) {
 		tx_corr_coeff[i * 2][0] = tx_corr_coeff[(i * 2) + 1][0] =
 					AR_PHY_TX_IQCAL_CORR_COEFF_B0(i);
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index b0a4ca3559fd8..25dd9d92f656f 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -5451,14 +5451,12 @@ static void ath9k_hw_ar9300_set_txpower(struct ath_hw *ah,
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
 	struct ar9300_modal_eep_header *modal_hdr;
-	u8 targetPowerValT2[ar9300RateSize];
+	u8 targetPowerValT2[ar9300RateSize] = {};
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
index 34e1009402846..ab3987777dd08 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
@@ -419,13 +419,16 @@ static inline int find_proper_scale(int expn, int N)
 static bool create_pa_curve(u32 *data_L, u32 *data_U, u32 *pa_table, u16 *gain)
 {
 	unsigned int thresh_accum_cnt;
-	int x_est[NUM_BIN + 1], Y[NUM_BIN + 1], theta[NUM_BIN + 1];
+	int x_est[NUM_BIN + 1] = {};
+	int Y[NUM_BIN + 1] = {};
+	int theta[NUM_BIN + 1] = {};
 	int PA_in[NUM_BIN + 1];
 	int B1_tmp[NUM_BIN + 1], B2_tmp[NUM_BIN + 1];
 	unsigned int B1_abs_max, B2_abs_max;
 	int max_index, scale_factor;
-	int y_est[NUM_BIN + 1];
-	int x_est_fxp1_nonlin, x_tilde[NUM_BIN + 1];
+	int y_est[NUM_BIN + 1] = {};
+	int x_est_fxp1_nonlin;
+	int x_tilde[NUM_BIN + 1] = {};
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
index efb7889142d47..03675f6e0409e 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -480,7 +480,7 @@ void ath9k_hw_get_gain_boundaries_pdadcs(struct ath_hw *ah,
 		[AR5416_MAX_PWR_RANGE_IN_HALF_DB];
 
 	u8 *pVpdL, *pVpdR, *pPwrL, *pPwrR;
-	u8 minPwrT4[AR5416_NUM_PD_GAINS];
+	u8 minPwrT4[AR5416_NUM_PD_GAINS] = {};
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
index e8c2cc03be0cb..b74a60fd6cf17 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -583,12 +583,10 @@ static void ath9k_hw_4k_set_txpower(struct ath_hw *ah,
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	struct ar5416_eeprom_4k *pEepData = &ah->eeprom.map4k;
 	struct modal_eep_4k_header *pModal = &pEepData->modalHeader;
-	int16_t ratesArray[Ar5416RateSize];
+	int16_t ratesArray[Ar5416RateSize] = {};
 	u8 ht40PowerIncForPdadc = 2;
 	int i;
 
-	memset(ratesArray, 0, sizeof(ratesArray));
-
 	if (ath9k_hw_4k_get_eeprom_rev(ah) >= AR5416_EEP_MINOR_VER_2)
 		ht40PowerIncForPdadc = pModal->ht40PowerIncForPdadc;
 
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index 3caa149b10131..f70e3ef9b10b3 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -711,12 +711,10 @@ static void ath9k_hw_ar9287_set_txpower(struct ath_hw *ah,
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	struct ar9287_eeprom *pEepData = &ah->eeprom.map9287;
 	struct modal_eep_ar9287_header *pModal = &pEepData->modalHeader;
-	int16_t ratesArray[Ar5416RateSize];
+	int16_t ratesArray[Ar5416RateSize] = {};
 	u8 ht40PowerIncForPdadc = 2;
 	int i;
 
-	memset(ratesArray, 0, sizeof(ratesArray));
-
 	if (ath9k_hw_ar9287_get_eeprom_rev(ah) >= AR9287_EEP_MINOR_VER_2)
 		ht40PowerIncForPdadc = pModal->ht40PowerIncForPdadc;
 
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 9729a69d3e2e3..4d24c877cbfc2 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -1150,12 +1150,10 @@ static void ath9k_hw_def_set_txpower(struct ath_hw *ah,
 	struct ar5416_eeprom_def *pEepData = &ah->eeprom.def;
 	struct modal_eep_header *pModal =
 		&(pEepData->modalHeader[IS_CHAN_2GHZ(chan)]);
-	int16_t ratesArray[Ar5416RateSize];
+	int16_t ratesArray[Ar5416RateSize] = {};
 	u8 ht40PowerIncForPdadc = 2;
 	int i, cck_ofdm_delta = 0;
 
-	memset(ratesArray, 0, sizeof(ratesArray));
-
 	if (ath9k_hw_def_get_eeprom_rev(ah) >= AR5416_EEP_MINOR_VER_2)
 		ht40PowerIncForPdadc = pModal->ht40PowerIncForPdadc;
 
diff --git a/drivers/net/wireless/ath/ath9k/wow.c b/drivers/net/wireless/ath/ath9k/wow.c
index 8d0b1730a9d5b..0232fba96d74c 100644
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
+	u8 dis_deauth_pattern[MAX_PATTERN_SIZE] = {};
+	u8 dis_deauth_mask[MAX_PATTERN_SIZE] = {};
 
 	/*
 	 * Create Dissassociate / Deauthenticate packet filter
-- 
2.26.3

