Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7B11582A75
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 18:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234828AbiG0QRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 12:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234775AbiG0QRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 12:17:01 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD314AD7D
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 09:17:00 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id b26so25208626wrc.2
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 09:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Xn+2PPw3qXG1E9aLSfczRJoR0Hf6xrhbQrL0FrfFNVc=;
        b=SBHlSxEUCd7xleJ2pvApBLzLNux2D2tvPf0QBXtohaPztIe0vSRQ/+iooys8QG9392
         Zn3E9EjxebSYIjSM4WInyeu6jHM9Uevb7BiPtdbece1+suI9QeZwL1XUS1Qng2AwcAtA
         EgQEhMe1a2W9I/hW+hhJEWxm5vwYHzFgjqPzT3yldCjyTIqLoKGLIkdLNs6i0FPLePyQ
         NIgBvauJEHhGW2xpNOvGiTACaHeRob+bUox35ZviQPMbPLVcKMJ3qnYK+Bpy0VZTYpYz
         zOGk67vkibrfDPfp3h7DgOQCF1S+T57r3gSvNl3na1l6yjTqVyU45uFJZBQLlJK4FPge
         7b9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xn+2PPw3qXG1E9aLSfczRJoR0Hf6xrhbQrL0FrfFNVc=;
        b=12I4GN0TT6z34PfJe06gXQ/zNaoamWISKxxHdiXVrLDbuhe9Zr4wWlJ7vewHeb1sqR
         fww4KayZHTVlPxLT6X5WiiMfqK2uXyf8a6mCI15mxuPIRYOIEo39Ad74BgtxXsEKfz4q
         jrVntsSPJ9TJIdIXSMRM3XfjvypSVXFhZf4YflHUKqGPBNo4Ae5/UtwWbiH3YG6iYSsa
         QCg8wBPl1qh6VNh0jlK4t5xcAOn8LWugKbOH6EKRJdjNXQq1HgpzbPv0l+tAHCf03H/n
         iiTSWNDhe+7DSiPHgk9nidMykLk82E7tNHP4aJ/m1HgWCiZLrpUFZXfSC8GMjfmJNUhM
         +Xvw==
X-Gm-Message-State: AJIora91/8xMBvh3jO8nvSRK3JfXgKE60iibFIFw2tWWLYEET5M2uA5g
        J5oQ6AAYkfXXIqn3yP+M8uu9Gg==
X-Google-Smtp-Source: AGRyM1stPt+AGUK02PAY4LnQHFzXMIku4ST6GCCF8UVI804cJYH08NZZG55XrnPSQYzoSUYWDGa/tA==
X-Received: by 2002:a5d:4a01:0:b0:21d:8ce1:8b6d with SMTP id m1-20020a5d4a01000000b0021d8ce18b6dmr14881674wrq.718.1658938618615;
        Wed, 27 Jul 2022 09:16:58 -0700 (PDT)
Received: from sagittarius-a.chello.ie (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id l4-20020a05600012c400b0021e4829d359sm17245474wrx.39.2022.07.27.09.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 09:16:58 -0700 (PDT)
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
To:     kvalo@kernel.org, loic.poulain@linaro.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, bryan.odonoghue@linaro.org
Subject: [PATCH v3 1/4] wcn36xx: Rename clunky firmware feature bit enum
Date:   Wed, 27 Jul 2022 17:16:52 +0100
Message-Id: <20220727161655.2286867-2-bryan.odonoghue@linaro.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220727161655.2286867-1-bryan.odonoghue@linaro.org>
References: <20220727161655.2286867-1-bryan.odonoghue@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The enum name "place_holder_in_cap_bitmap" is self descriptively asking to
be changed to something else.

Rename place_holder_in_cap_bitmap to wcn36xx_firmware_feat_caps so that the
contents and intent of the enum is obvious.

Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/hal.h  | 2 +-
 drivers/net/wireless/ath/wcn36xx/main.c | 2 +-
 drivers/net/wireless/ath/wcn36xx/smd.c  | 6 +++---
 drivers/net/wireless/ath/wcn36xx/smd.h  | 6 +++---
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/hal.h b/drivers/net/wireless/ath/wcn36xx/hal.h
index 46a49f0a51b34..5e48c97682c20 100644
--- a/drivers/net/wireless/ath/wcn36xx/hal.h
+++ b/drivers/net/wireless/ath/wcn36xx/hal.h
@@ -4760,7 +4760,7 @@ struct wcn36xx_hal_set_power_params_resp {
 
 /* Capability bitmap exchange definitions and macros starts */
 
-enum place_holder_in_cap_bitmap {
+enum wcn36xx_firmware_feat_caps {
 	MCC = 0,
 	P2P = 1,
 	DOT11AC = 2,
diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index e34d3d0b70820..efd776b20e608 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -260,7 +260,7 @@ static const char * const wcn36xx_caps_names[] = {
 
 #undef DEFINE
 
-static const char *wcn36xx_get_cap_name(enum place_holder_in_cap_bitmap x)
+static const char *wcn36xx_get_cap_name(enum wcn36xx_firmware_feat_caps x)
 {
 	if (x >= ARRAY_SIZE(wcn36xx_caps_names))
 		return "UNKNOWN";
diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 7ac9a1e6f7686..88ee92be85625 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -2431,7 +2431,7 @@ int wcn36xx_smd_dump_cmd_req(struct wcn36xx *wcn, u32 arg1, u32 arg2,
 	return ret;
 }
 
-void set_feat_caps(u32 *bitmap, enum place_holder_in_cap_bitmap cap)
+void set_feat_caps(u32 *bitmap, enum wcn36xx_firmware_feat_caps cap)
 {
 	int arr_idx, bit_idx;
 
@@ -2445,7 +2445,7 @@ void set_feat_caps(u32 *bitmap, enum place_holder_in_cap_bitmap cap)
 	bitmap[arr_idx] |= (1 << bit_idx);
 }
 
-int get_feat_caps(u32 *bitmap, enum place_holder_in_cap_bitmap cap)
+int get_feat_caps(u32 *bitmap, enum wcn36xx_firmware_feat_caps cap)
 {
 	int arr_idx, bit_idx;
 
@@ -2460,7 +2460,7 @@ int get_feat_caps(u32 *bitmap, enum place_holder_in_cap_bitmap cap)
 	return (bitmap[arr_idx] & (1 << bit_idx)) ? 1 : 0;
 }
 
-void clear_feat_caps(u32 *bitmap, enum place_holder_in_cap_bitmap cap)
+void clear_feat_caps(u32 *bitmap, enum wcn36xx_firmware_feat_caps cap)
 {
 	int arr_idx, bit_idx;
 
diff --git a/drivers/net/wireless/ath/wcn36xx/smd.h b/drivers/net/wireless/ath/wcn36xx/smd.h
index 3fd598ac2a27e..186dad4fe80eb 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.h
+++ b/drivers/net/wireless/ath/wcn36xx/smd.h
@@ -125,9 +125,9 @@ int wcn36xx_smd_keep_alive_req(struct wcn36xx *wcn,
 int wcn36xx_smd_dump_cmd_req(struct wcn36xx *wcn, u32 arg1, u32 arg2,
 			     u32 arg3, u32 arg4, u32 arg5);
 int wcn36xx_smd_feature_caps_exchange(struct wcn36xx *wcn);
-void set_feat_caps(u32 *bitmap, enum place_holder_in_cap_bitmap cap);
-int get_feat_caps(u32 *bitmap, enum place_holder_in_cap_bitmap cap);
-void clear_feat_caps(u32 *bitmap, enum place_holder_in_cap_bitmap cap);
+void set_feat_caps(u32 *bitmap, enum wcn36xx_firmware_feat_caps cap);
+int get_feat_caps(u32 *bitmap, enum wcn36xx_firmware_feat_caps cap);
+void clear_feat_caps(u32 *bitmap, enum wcn36xx_firmware_feat_caps cap);
 
 int wcn36xx_smd_add_ba_session(struct wcn36xx *wcn,
 		struct ieee80211_sta *sta,
-- 
2.36.1

