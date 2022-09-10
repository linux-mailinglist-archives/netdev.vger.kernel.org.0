Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87DC35B4387
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 03:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbiIJBLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 21:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiIJBLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 21:11:38 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D02FC676
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 18:11:36 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id h194so973036iof.4
        for <netdev@vger.kernel.org>; Fri, 09 Sep 2022 18:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=8IhN48uB19RDEOY3f6Cdr9YhMwFwA3ArVNn1nzV0N/4=;
        b=O7S4EymRcbI05VmHJr6NW11/lwMC5FbhqvY2vAp2D5a0CQXnJkF2g0eu8QTvmxqQ7t
         zqMDTC70c/jZHx0eXfxXAieBYq9XfY9cvss7EKZerrMtHBUDdZ3tb4k20B8oFfqBNJFL
         DbgIM8cS18QF1p8gmQy4Qv3BMuRFH8f9LVzKCT+fvi+DcIcLMoI2faRDRYtNrTX+rp3n
         ++ZTQjyn5KNkK19xm/efSx5IBNmGDO8I0kmozVnw/JRbbMaWS5Q5UZ6k++oEPA0Hss3F
         HTwFX6qv90m50uRQIUXi7KLkATp0cefDZIMRXem6XsbzH/br9K6Btw+UZFs6Gx3qM03R
         shPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=8IhN48uB19RDEOY3f6Cdr9YhMwFwA3ArVNn1nzV0N/4=;
        b=w+ZG9Zt/zPHi25Cl+2qJ7vcIP+l7ksnm/OnPhtugrCReEZl9Pe8IWRFMrVxfCkMFAn
         P19+XWxaIw0DwNJD9svoK38cwT4iKhK5bONtCfMYthDDY71ul26OL1BIVglwHvUmu1yF
         /lOjF/qMoFItDXMvEaSSXRIZRZc/Xud4LRN6uqgDz+/vUauui0Ol/AQYps80WXiBi5H9
         9Ko3Trn5i6pBerXwBmLU1O46f3IbpSNpdWfQqYCrvjZDu7OwkS31IsmBk3EvFg4xmZuR
         vlVjdYymdZqLNIxX60TlpGqK19thotPrGs6lANyBV9xsuGMrCp8qiMemKXCHHR9EZSwT
         fvIg==
X-Gm-Message-State: ACgBeo1SCtjcl1NSxa4RsD27EUY78lwI1PXAsm4rFi5mK3eesrFNtc9S
        XodvUUml0o6hNOVe8O7HoD8aXA==
X-Google-Smtp-Source: AA6agR4Nk1FGVTEk4Yco6UNP9NTI27B1EOIv+0+KFBhCKO/i6nfwF1gtuY+Vy1t4nU+K4oYnXcjssg==
X-Received: by 2002:a05:6602:2d41:b0:688:e962:2b53 with SMTP id d1-20020a0566022d4100b00688e9622b53mr8001330iow.79.1662772295979;
        Fri, 09 Sep 2022 18:11:35 -0700 (PDT)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id u133-20020a02238b000000b00348e1a6491asm733064jau.137.2022.09.09.18.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 18:11:35 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/6] net: ipa: don't define unneeded GSI register offsets
Date:   Fri,  9 Sep 2022 20:11:26 -0500
Message-Id: <20220910011131.1431934-2-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220910011131.1431934-1-elder@linaro.org>
References: <20220910011131.1431934-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Each GSI execution environment (EE) is able to access many of the
GSI registers associated with the other EEs.  A block of GSI
registers is contained within a region of memory, and an EE's
register offset can be determined by adding the register's base
offset to the product of the EE ID and a fixed constant.

Despite this possibility, the AP IPA code *never* accesses any GSI
registers other than its own.  So there's no need to define the
macros that compute register offsets for other EEs.

Redefine the AP access macros to compute the offset the way the more
general "any EE" macro would, and get rid of the unneeded macros.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi_reg.h | 208 ++++++++++----------------------------
 1 file changed, 52 insertions(+), 156 deletions(-)

diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index 5bd8b31656d30..b36fd10a57d69 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -55,14 +55,10 @@
 /* The inter-EE IRQ registers are relative to gsi->virt_raw (IPA v3.5+) */
 
 #define GSI_INTER_EE_SRC_CH_IRQ_MSK_OFFSET \
-			GSI_INTER_EE_N_SRC_CH_IRQ_MSK_OFFSET(GSI_EE_AP)
-#define GSI_INTER_EE_N_SRC_CH_IRQ_MSK_OFFSET(ee) \
-			(0x0000c020 + 0x1000 * (ee))
+			(0x0000c020 + 0x1000 * GSI_EE_AP)
 
 #define GSI_INTER_EE_SRC_EV_CH_IRQ_MSK_OFFSET \
-			GSI_INTER_EE_N_SRC_EV_CH_IRQ_MSK_OFFSET(GSI_EE_AP)
-#define GSI_INTER_EE_N_SRC_EV_CH_IRQ_MSK_OFFSET(ee) \
-			(0x0000c024 + 0x1000 * (ee))
+			(0x0000c024 + 0x1000 * GSI_EE_AP)
 
 /* All other register offsets are relative to gsi->virt */
 
@@ -81,9 +77,7 @@ enum gsi_channel_type {
 };
 
 #define GSI_CH_C_CNTXT_0_OFFSET(ch) \
-		GSI_EE_N_CH_C_CNTXT_0_OFFSET((ch), GSI_EE_AP)
-#define GSI_EE_N_CH_C_CNTXT_0_OFFSET(ch, ee) \
-		(0x0001c000 + 0x4000 * (ee) + 0x80 * (ch))
+			(0x0001c000 + 0x4000 * GSI_EE_AP + 0x80 * (ch))
 #define CHTYPE_PROTOCOL_FMASK		GENMASK(2, 0)
 #define CHTYPE_DIR_FMASK		GENMASK(3, 3)
 #define EE_FMASK			GENMASK(7, 4)
@@ -112,9 +106,7 @@ chtype_protocol_encoded(enum ipa_version version, enum gsi_channel_type type)
 }
 
 #define GSI_CH_C_CNTXT_1_OFFSET(ch) \
-		GSI_EE_N_CH_C_CNTXT_1_OFFSET((ch), GSI_EE_AP)
-#define GSI_EE_N_CH_C_CNTXT_1_OFFSET(ch, ee) \
-		(0x0001c004 + 0x4000 * (ee) + 0x80 * (ch))
+			(0x0001c004 + 0x4000 * GSI_EE_AP + 0x80 * (ch))
 
 /* Encoded value for CH_C_CNTXT_1 register R_LENGTH field */
 static inline u32 r_length_encoded(enum ipa_version version, u32 length)
@@ -125,19 +117,13 @@ static inline u32 r_length_encoded(enum ipa_version version, u32 length)
 }
 
 #define GSI_CH_C_CNTXT_2_OFFSET(ch) \
-		GSI_EE_N_CH_C_CNTXT_2_OFFSET((ch), GSI_EE_AP)
-#define GSI_EE_N_CH_C_CNTXT_2_OFFSET(ch, ee) \
-		(0x0001c008 + 0x4000 * (ee) + 0x80 * (ch))
+			(0x0001c008 + 0x4000 * GSI_EE_AP + 0x80 * (ch))
 
 #define GSI_CH_C_CNTXT_3_OFFSET(ch) \
-		GSI_EE_N_CH_C_CNTXT_3_OFFSET((ch), GSI_EE_AP)
-#define GSI_EE_N_CH_C_CNTXT_3_OFFSET(ch, ee) \
-		(0x0001c00c + 0x4000 * (ee) + 0x80 * (ch))
+			(0x0001c00c + 0x4000 * GSI_EE_AP + 0x80 * (ch))
 
 #define GSI_CH_C_QOS_OFFSET(ch) \
-		GSI_EE_N_CH_C_QOS_OFFSET((ch), GSI_EE_AP)
-#define GSI_EE_N_CH_C_QOS_OFFSET(ch, ee) \
-		(0x0001c05c + 0x4000 * (ee) + 0x80 * (ch))
+			(0x0001c05c + 0x4000 * GSI_EE_AP + 0x80 * (ch))
 #define WRR_WEIGHT_FMASK		GENMASK(3, 0)
 #define MAX_PREFETCH_FMASK		GENMASK(8, 8)
 #define USE_DB_ENG_FMASK		GENMASK(9, 9)
@@ -158,29 +144,19 @@ enum gsi_prefetch_mode {
 };
 
 #define GSI_CH_C_SCRATCH_0_OFFSET(ch) \
-		GSI_EE_N_CH_C_SCRATCH_0_OFFSET((ch), GSI_EE_AP)
-#define GSI_EE_N_CH_C_SCRATCH_0_OFFSET(ch, ee) \
-		(0x0001c060 + 0x4000 * (ee) + 0x80 * (ch))
+			(0x0001c060 + 0x4000 * GSI_EE_AP + 0x80 * (ch))
 
 #define GSI_CH_C_SCRATCH_1_OFFSET(ch) \
-		GSI_EE_N_CH_C_SCRATCH_1_OFFSET((ch), GSI_EE_AP)
-#define GSI_EE_N_CH_C_SCRATCH_1_OFFSET(ch, ee) \
-		(0x0001c064 + 0x4000 * (ee) + 0x80 * (ch))
+			(0x0001c064 + 0x4000 * GSI_EE_AP + 0x80 * (ch))
 
 #define GSI_CH_C_SCRATCH_2_OFFSET(ch) \
-		GSI_EE_N_CH_C_SCRATCH_2_OFFSET((ch), GSI_EE_AP)
-#define GSI_EE_N_CH_C_SCRATCH_2_OFFSET(ch, ee) \
-		(0x0001c068 + 0x4000 * (ee) + 0x80 * (ch))
+			(0x0001c068 + 0x4000 * GSI_EE_AP + 0x80 * (ch))
 
 #define GSI_CH_C_SCRATCH_3_OFFSET(ch) \
-		GSI_EE_N_CH_C_SCRATCH_3_OFFSET((ch), GSI_EE_AP)
-#define GSI_EE_N_CH_C_SCRATCH_3_OFFSET(ch, ee) \
-		(0x0001c06c + 0x4000 * (ee) + 0x80 * (ch))
+			(0x0001c06c + 0x4000 * GSI_EE_AP + 0x80 * (ch))
 
 #define GSI_EV_CH_E_CNTXT_0_OFFSET(ev) \
-		GSI_EE_N_EV_CH_E_CNTXT_0_OFFSET((ev), GSI_EE_AP)
-#define GSI_EE_N_EV_CH_E_CNTXT_0_OFFSET(ev, ee) \
-		(0x0001d000 + 0x4000 * (ee) + 0x80 * (ev))
+			(0x0001d000 + 0x4000 * GSI_EE_AP + 0x80 * (ev))
 /* enum gsi_channel_type defines EV_CHTYPE field values in EV_CH_E_CNTXT_0 */
 #define EV_CHTYPE_FMASK			GENMASK(3, 0)
 #define EV_EE_FMASK			GENMASK(7, 4)
@@ -190,9 +166,7 @@ enum gsi_prefetch_mode {
 #define EV_ELEMENT_SIZE_FMASK		GENMASK(31, 24)
 
 #define GSI_EV_CH_E_CNTXT_1_OFFSET(ev) \
-		GSI_EE_N_EV_CH_E_CNTXT_1_OFFSET((ev), GSI_EE_AP)
-#define GSI_EE_N_EV_CH_E_CNTXT_1_OFFSET(ev, ee) \
-		(0x0001d004 + 0x4000 * (ee) + 0x80 * (ev))
+			(0x0001d004 + 0x4000 * GSI_EE_AP + 0x80 * (ev))
 /* Encoded value for EV_CH_C_CNTXT_1 register EV_R_LENGTH field */
 static inline u32 ev_r_length_encoded(enum ipa_version version, u32 length)
 {
@@ -202,83 +176,53 @@ static inline u32 ev_r_length_encoded(enum ipa_version version, u32 length)
 }
 
 #define GSI_EV_CH_E_CNTXT_2_OFFSET(ev) \
-		GSI_EE_N_EV_CH_E_CNTXT_2_OFFSET((ev), GSI_EE_AP)
-#define GSI_EE_N_EV_CH_E_CNTXT_2_OFFSET(ev, ee) \
-		(0x0001d008 + 0x4000 * (ee) + 0x80 * (ev))
+			(0x0001d008 + 0x4000 * GSI_EE_AP + 0x80 * (ev))
 
 #define GSI_EV_CH_E_CNTXT_3_OFFSET(ev) \
-		GSI_EE_N_EV_CH_E_CNTXT_3_OFFSET((ev), GSI_EE_AP)
-#define GSI_EE_N_EV_CH_E_CNTXT_3_OFFSET(ev, ee) \
-		(0x0001d00c + 0x4000 * (ee) + 0x80 * (ev))
+			(0x0001d00c + 0x4000 * GSI_EE_AP + 0x80 * (ev))
 
 #define GSI_EV_CH_E_CNTXT_4_OFFSET(ev) \
-		GSI_EE_N_EV_CH_E_CNTXT_4_OFFSET((ev), GSI_EE_AP)
-#define GSI_EE_N_EV_CH_E_CNTXT_4_OFFSET(ev, ee) \
-		(0x0001d010 + 0x4000 * (ee) + 0x80 * (ev))
+			(0x0001d010 + 0x4000 * GSI_EE_AP + 0x80 * (ev))
 
 #define GSI_EV_CH_E_CNTXT_8_OFFSET(ev) \
-		GSI_EE_N_EV_CH_E_CNTXT_8_OFFSET((ev), GSI_EE_AP)
-#define GSI_EE_N_EV_CH_E_CNTXT_8_OFFSET(ev, ee) \
-		(0x0001d020 + 0x4000 * (ee) + 0x80 * (ev))
+			(0x0001d020 + 0x4000 * GSI_EE_AP + 0x80 * (ev))
 #define MODT_FMASK			GENMASK(15, 0)
 #define MODC_FMASK			GENMASK(23, 16)
 #define MOD_CNT_FMASK			GENMASK(31, 24)
 
 #define GSI_EV_CH_E_CNTXT_9_OFFSET(ev) \
-		GSI_EE_N_EV_CH_E_CNTXT_9_OFFSET((ev), GSI_EE_AP)
-#define GSI_EE_N_EV_CH_E_CNTXT_9_OFFSET(ev, ee) \
-		(0x0001d024 + 0x4000 * (ee) + 0x80 * (ev))
+			(0x0001d024 + 0x4000 * GSI_EE_AP + 0x80 * (ev))
 
 #define GSI_EV_CH_E_CNTXT_10_OFFSET(ev) \
-		GSI_EE_N_EV_CH_E_CNTXT_10_OFFSET((ev), GSI_EE_AP)
-#define GSI_EE_N_EV_CH_E_CNTXT_10_OFFSET(ev, ee) \
-		(0x0001d028 + 0x4000 * (ee) + 0x80 * (ev))
+			(0x0001d028 + 0x4000 * GSI_EE_AP + 0x80 * (ev))
 
 #define GSI_EV_CH_E_CNTXT_11_OFFSET(ev) \
-		GSI_EE_N_EV_CH_E_CNTXT_11_OFFSET((ev), GSI_EE_AP)
-#define GSI_EE_N_EV_CH_E_CNTXT_11_OFFSET(ev, ee) \
-		(0x0001d02c + 0x4000 * (ee) + 0x80 * (ev))
+			(0x0001d02c + 0x4000 * GSI_EE_AP + 0x80 * (ev))
 
 #define GSI_EV_CH_E_CNTXT_12_OFFSET(ev) \
-		GSI_EE_N_EV_CH_E_CNTXT_12_OFFSET((ev), GSI_EE_AP)
-#define GSI_EE_N_EV_CH_E_CNTXT_12_OFFSET(ev, ee) \
-		(0x0001d030 + 0x4000 * (ee) + 0x80 * (ev))
+			(0x0001d030 + 0x4000 * GSI_EE_AP + 0x80 * (ev))
 
 #define GSI_EV_CH_E_CNTXT_13_OFFSET(ev) \
-		GSI_EE_N_EV_CH_E_CNTXT_13_OFFSET((ev), GSI_EE_AP)
-#define GSI_EE_N_EV_CH_E_CNTXT_13_OFFSET(ev, ee) \
-		(0x0001d034 + 0x4000 * (ee) + 0x80 * (ev))
+			(0x0001d034 + 0x4000 * GSI_EE_AP + 0x80 * (ev))
 
 #define GSI_EV_CH_E_SCRATCH_0_OFFSET(ev) \
-		GSI_EE_N_EV_CH_E_SCRATCH_0_OFFSET((ev), GSI_EE_AP)
-#define GSI_EE_N_EV_CH_E_SCRATCH_0_OFFSET(ev, ee) \
-		(0x0001d048 + 0x4000 * (ee) + 0x80 * (ev))
+			(0x0001d048 + 0x4000 * GSI_EE_AP + 0x80 * (ev))
 
 #define GSI_EV_CH_E_SCRATCH_1_OFFSET(ev) \
-		GSI_EE_N_EV_CH_E_SCRATCH_1_OFFSET((ev), GSI_EE_AP)
-#define GSI_EE_N_EV_CH_E_SCRATCH_1_OFFSET(ev, ee) \
-		(0x0001d04c + 0x4000 * (ee) + 0x80 * (ev))
+			(0x0001d04c + 0x4000 * GSI_EE_AP + 0x80 * (ev))
 
 #define GSI_CH_C_DOORBELL_0_OFFSET(ch) \
-		GSI_EE_N_CH_C_DOORBELL_0_OFFSET((ch), GSI_EE_AP)
-#define GSI_EE_N_CH_C_DOORBELL_0_OFFSET(ch, ee) \
-			(0x0001e000 + 0x4000 * (ee) + 0x08 * (ch))
+			(0x0001e000 + 0x4000 * GSI_EE_AP + 0x08 * (ch))
 
 #define GSI_EV_CH_E_DOORBELL_0_OFFSET(ev) \
-			GSI_EE_N_EV_CH_E_DOORBELL_0_OFFSET((ev), GSI_EE_AP)
-#define GSI_EE_N_EV_CH_E_DOORBELL_0_OFFSET(ev, ee) \
-			(0x0001e100 + 0x4000 * (ee) + 0x08 * (ev))
+			(0x0001e100 + 0x4000 * GSI_EE_AP + 0x08 * (ev))
 
 #define GSI_GSI_STATUS_OFFSET \
-			GSI_EE_N_GSI_STATUS_OFFSET(GSI_EE_AP)
-#define GSI_EE_N_GSI_STATUS_OFFSET(ee) \
-			(0x0001f000 + 0x4000 * (ee))
+			(0x0001f000 + 0x4000 * GSI_EE_AP)
 #define ENABLED_FMASK			GENMASK(0, 0)
 
 #define GSI_CH_CMD_OFFSET \
-			GSI_EE_N_CH_CMD_OFFSET(GSI_EE_AP)
-#define GSI_EE_N_CH_CMD_OFFSET(ee) \
-			(0x0001f008 + 0x4000 * (ee))
+			(0x0001f008 + 0x4000 * GSI_EE_AP)
 #define CH_CHID_FMASK			GENMASK(7, 0)
 #define CH_OPCODE_FMASK			GENMASK(31, 24)
 
@@ -293,9 +237,7 @@ enum gsi_ch_cmd_opcode {
 };
 
 #define GSI_EV_CH_CMD_OFFSET \
-			GSI_EE_N_EV_CH_CMD_OFFSET(GSI_EE_AP)
-#define GSI_EE_N_EV_CH_CMD_OFFSET(ee) \
-			(0x0001f010 + 0x4000 * (ee))
+			(0x0001f010 + 0x4000 * GSI_EE_AP)
 #define EV_CHID_FMASK			GENMASK(7, 0)
 #define EV_OPCODE_FMASK			GENMASK(31, 24)
 
@@ -307,9 +249,7 @@ enum gsi_evt_cmd_opcode {
 };
 
 #define GSI_GENERIC_CMD_OFFSET \
-			GSI_EE_N_GENERIC_CMD_OFFSET(GSI_EE_AP)
-#define GSI_EE_N_GENERIC_CMD_OFFSET(ee) \
-			(0x0001f018 + 0x4000 * (ee))
+			(0x0001f018 + 0x4000 * GSI_EE_AP)
 #define GENERIC_OPCODE_FMASK		GENMASK(4, 0)
 #define GENERIC_CHID_FMASK		GENMASK(9, 5)
 #define GENERIC_EE_FMASK		GENMASK(13, 10)
@@ -326,9 +266,7 @@ enum gsi_generic_cmd_opcode {
 
 /* The next register is present for IPA v3.5.1 and above */
 #define GSI_GSI_HW_PARAM_2_OFFSET \
-			GSI_EE_N_GSI_HW_PARAM_2_OFFSET(GSI_EE_AP)
-#define GSI_EE_N_GSI_HW_PARAM_2_OFFSET(ee) \
-			(0x0001f040 + 0x4000 * (ee))
+			(0x0001f040 + 0x4000 * GSI_EE_AP)
 #define IRAM_SIZE_FMASK			GENMASK(2, 0)
 #define NUM_CH_PER_EE_FMASK		GENMASK(7, 3)
 #define NUM_EV_PER_EE_FMASK		GENMASK(12, 8)
@@ -357,13 +295,9 @@ enum gsi_iram_size {
 
 /* IRQ condition for each type is cleared by writing type-specific register */
 #define GSI_CNTXT_TYPE_IRQ_OFFSET \
-			GSI_EE_N_CNTXT_TYPE_IRQ_OFFSET(GSI_EE_AP)
-#define GSI_EE_N_CNTXT_TYPE_IRQ_OFFSET(ee) \
-			(0x0001f080 + 0x4000 * (ee))
+			(0x0001f080 + 0x4000 * GSI_EE_AP)
 #define GSI_CNTXT_TYPE_IRQ_MSK_OFFSET \
-			GSI_EE_N_CNTXT_TYPE_IRQ_MSK_OFFSET(GSI_EE_AP)
-#define GSI_EE_N_CNTXT_TYPE_IRQ_MSK_OFFSET(ee) \
-			(0x0001f088 + 0x4000 * (ee))
+			(0x0001f088 + 0x4000 * GSI_EE_AP)
 
 /* Values here are bit positions in the TYPE_IRQ and TYPE_IRQ_MSK registers */
 enum gsi_irq_type_id {
@@ -377,62 +311,38 @@ enum gsi_irq_type_id {
 };
 
 #define GSI_CNTXT_SRC_CH_IRQ_OFFSET \
-			GSI_EE_N_CNTXT_SRC_CH_IRQ_OFFSET(GSI_EE_AP)
-#define GSI_EE_N_CNTXT_SRC_CH_IRQ_OFFSET(ee) \
-			(0x0001f090 + 0x4000 * (ee))
+			(0x0001f090 + 0x4000 * GSI_EE_AP)
 
 #define GSI_CNTXT_SRC_EV_CH_IRQ_OFFSET \
-			GSI_EE_N_CNTXT_SRC_EV_CH_IRQ_OFFSET(GSI_EE_AP)
-#define GSI_EE_N_CNTXT_SRC_EV_CH_IRQ_OFFSET(ee) \
-			(0x0001f094 + 0x4000 * (ee))
+			(0x0001f094 + 0x4000 * GSI_EE_AP)
 
 #define GSI_CNTXT_SRC_CH_IRQ_MSK_OFFSET \
-			GSI_EE_N_CNTXT_SRC_CH_IRQ_MSK_OFFSET(GSI_EE_AP)
-#define GSI_EE_N_CNTXT_SRC_CH_IRQ_MSK_OFFSET(ee) \
-			(0x0001f098 + 0x4000 * (ee))
+			(0x0001f098 + 0x4000 * GSI_EE_AP)
 
 #define GSI_CNTXT_SRC_EV_CH_IRQ_MSK_OFFSET \
-			GSI_EE_N_CNTXT_SRC_EV_CH_IRQ_MSK_OFFSET(GSI_EE_AP)
-#define GSI_EE_N_CNTXT_SRC_EV_CH_IRQ_MSK_OFFSET(ee) \
-			(0x0001f09c + 0x4000 * (ee))
+			(0x0001f09c + 0x4000 * GSI_EE_AP)
 
 #define GSI_CNTXT_SRC_CH_IRQ_CLR_OFFSET \
-			GSI_EE_N_CNTXT_SRC_CH_IRQ_CLR_OFFSET(GSI_EE_AP)
-#define GSI_EE_N_CNTXT_SRC_CH_IRQ_CLR_OFFSET(ee) \
-			(0x0001f0a0 + 0x4000 * (ee))
+			(0x0001f0a0 + 0x4000 * GSI_EE_AP)
 
 #define GSI_CNTXT_SRC_EV_CH_IRQ_CLR_OFFSET \
-			GSI_EE_N_CNTXT_SRC_EV_CH_IRQ_CLR_OFFSET(GSI_EE_AP)
-#define GSI_EE_N_CNTXT_SRC_EV_CH_IRQ_CLR_OFFSET(ee) \
-			(0x0001f0a4 + 0x4000 * (ee))
+			(0x0001f0a4 + 0x4000 * GSI_EE_AP)
 
 #define GSI_CNTXT_SRC_IEOB_IRQ_OFFSET \
-			GSI_EE_N_CNTXT_SRC_IEOB_IRQ_OFFSET(GSI_EE_AP)
-#define GSI_EE_N_CNTXT_SRC_IEOB_IRQ_OFFSET(ee) \
-			(0x0001f0b0 + 0x4000 * (ee))
+			(0x0001f0b0 + 0x4000 * GSI_EE_AP)
 
 #define GSI_CNTXT_SRC_IEOB_IRQ_MSK_OFFSET \
-			GSI_EE_N_CNTXT_SRC_IEOB_IRQ_MSK_OFFSET(GSI_EE_AP)
-#define GSI_EE_N_CNTXT_SRC_IEOB_IRQ_MSK_OFFSET(ee) \
-			(0x0001f0b8 + 0x4000 * (ee))
+			(0x0001f0b8 + 0x4000 * GSI_EE_AP)
 
 #define GSI_CNTXT_SRC_IEOB_IRQ_CLR_OFFSET \
-			GSI_EE_N_CNTXT_SRC_IEOB_IRQ_CLR_OFFSET(GSI_EE_AP)
-#define GSI_EE_N_CNTXT_SRC_IEOB_IRQ_CLR_OFFSET(ee) \
-			(0x0001f0c0 + 0x4000 * (ee))
+			(0x0001f0c0 + 0x4000 * GSI_EE_AP)
 
 #define GSI_CNTXT_GLOB_IRQ_STTS_OFFSET \
-			GSI_EE_N_CNTXT_GLOB_IRQ_STTS_OFFSET(GSI_EE_AP)
-#define GSI_EE_N_CNTXT_GLOB_IRQ_STTS_OFFSET(ee) \
-			(0x0001f100 + 0x4000 * (ee))
+			(0x0001f100 + 0x4000 * GSI_EE_AP)
 #define GSI_CNTXT_GLOB_IRQ_EN_OFFSET \
-			GSI_EE_N_CNTXT_GLOB_IRQ_EN_OFFSET(GSI_EE_AP)
-#define GSI_EE_N_CNTXT_GLOB_IRQ_EN_OFFSET(ee) \
-			(0x0001f108 + 0x4000 * (ee))
+			(0x0001f108 + 0x4000 * GSI_EE_AP)
 #define GSI_CNTXT_GLOB_IRQ_CLR_OFFSET \
-			GSI_EE_N_CNTXT_GLOB_IRQ_CLR_OFFSET(GSI_EE_AP)
-#define GSI_EE_N_CNTXT_GLOB_IRQ_CLR_OFFSET(ee) \
-			(0x0001f110 + 0x4000 * (ee))
+			(0x0001f110 + 0x4000 * GSI_EE_AP)
 /* Values here are bit positions in the GLOB_IRQ_* registers */
 enum gsi_global_irq_id {
 	ERROR_INT				= 0x0,
@@ -442,17 +352,11 @@ enum gsi_global_irq_id {
 };
 
 #define GSI_CNTXT_GSI_IRQ_STTS_OFFSET \
-			GSI_EE_N_CNTXT_GSI_IRQ_STTS_OFFSET(GSI_EE_AP)
-#define GSI_EE_N_CNTXT_GSI_IRQ_STTS_OFFSET(ee) \
-			(0x0001f118 + 0x4000 * (ee))
+			(0x0001f118 + 0x4000 * GSI_EE_AP)
 #define GSI_CNTXT_GSI_IRQ_EN_OFFSET \
-			GSI_EE_N_CNTXT_GSI_IRQ_EN_OFFSET(GSI_EE_AP)
-#define GSI_EE_N_CNTXT_GSI_IRQ_EN_OFFSET(ee) \
-			(0x0001f120 + 0x4000 * (ee))
+			(0x0001f120 + 0x4000 * GSI_EE_AP)
 #define GSI_CNTXT_GSI_IRQ_CLR_OFFSET \
-			GSI_EE_N_CNTXT_GSI_IRQ_CLR_OFFSET(GSI_EE_AP)
-#define GSI_EE_N_CNTXT_GSI_IRQ_CLR_OFFSET(ee) \
-			(0x0001f128 + 0x4000 * (ee))
+			(0x0001f128 + 0x4000 * GSI_EE_AP)
 /* Values here are bit positions in the (general) GSI_IRQ_* registers */
 enum gsi_general_id {
 	BREAK_POINT				= 0x0,
@@ -462,15 +366,11 @@ enum gsi_general_id {
 };
 
 #define GSI_CNTXT_INTSET_OFFSET \
-			GSI_EE_N_CNTXT_INTSET_OFFSET(GSI_EE_AP)
-#define GSI_EE_N_CNTXT_INTSET_OFFSET(ee) \
-			(0x0001f180 + 0x4000 * (ee))
+			(0x0001f180 + 0x4000 * GSI_EE_AP)
 #define INTYPE_FMASK			GENMASK(0, 0)
 
 #define GSI_ERROR_LOG_OFFSET \
-			GSI_EE_N_ERROR_LOG_OFFSET(GSI_EE_AP)
-#define GSI_EE_N_ERROR_LOG_OFFSET(ee) \
-			(0x0001f200 + 0x4000 * (ee))
+			(0x0001f200 + 0x4000 * GSI_EE_AP)
 
 /* Fields below are present for IPA v3.5.1 and above */
 #define ERR_ARG3_FMASK			GENMASK(3, 0)
@@ -501,14 +401,10 @@ enum gsi_err_type {
 };
 
 #define GSI_ERROR_LOG_CLR_OFFSET \
-			GSI_EE_N_ERROR_LOG_CLR_OFFSET(GSI_EE_AP)
-#define GSI_EE_N_ERROR_LOG_CLR_OFFSET(ee) \
-			(0x0001f210 + 0x4000 * (ee))
+			(0x0001f210 + 0x4000 * GSI_EE_AP)
 
 #define GSI_CNTXT_SCRATCH_0_OFFSET \
-			GSI_EE_N_CNTXT_SCRATCH_0_OFFSET(GSI_EE_AP)
-#define GSI_EE_N_CNTXT_SCRATCH_0_OFFSET(ee) \
-			(0x0001f400 + 0x4000 * (ee))
+			(0x0001f400 + 0x4000 * GSI_EE_AP)
 #define INTER_EE_RESULT_FMASK		GENMASK(2, 0)
 #define GENERIC_EE_RESULT_FMASK		GENMASK(7, 5)
 
-- 
2.34.1

