Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9BF9579C89
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 14:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238090AbiGSMk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 08:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241539AbiGSMjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 08:39:49 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A66D5E327
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 05:16:05 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id h14-20020a1ccc0e000000b0039eff745c53so9044204wmb.5
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 05:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jUzNsdnhvD/VjMTY/eS2UapJiTD9Uag6zWMc8hGErxY=;
        b=tFLikhLUmmmFwY1EqjHYL9BHWYhUQuRbGcS5/BeDHGexLBwVgO64iPXflIOf8cgbUX
         Ag6a/FL7jY77bhVRCIhn+eIZ1qV7TT6N7RWK6A2Hs8Pmlr8sWcuD9xGzRqrYUjluYSiA
         yM1YG+kdnP0Z5+QkNCzuXdul0LR3gLRfEKQnfZetvcvjJAB5Zgo0FOmCFYgvkB7HI6/9
         KHWwXJyxv+aieQV5jwxksDXULuenYR0WFWNeXNKsN9M137bWQ2SSmeh6XQoSrFABfcn6
         f2NyWxmekRlR2t07kzSrbo6h+gVi+jYnSHy4SjSIBZzfqiJ18u/4CYl72S/8VDJROwXr
         Mwvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jUzNsdnhvD/VjMTY/eS2UapJiTD9Uag6zWMc8hGErxY=;
        b=uuMDQd8ntCdWCP+7mmdMzIUX9TaSgszKOO/5ZpyTu70sJHafKSKHGM9xUa8/vIsrjz
         nLzELRN/obC5XXlsfPrbFoOdmty2dwDdWzh+/VnKwpQVsRPInN1xQdiPNaqmXB92IGqK
         cYcowUt1vv0EmXwDB/drAuiiJ+E+P3y1oy1cvQrpxlz5vGHwm3r3amJOWNhQ4UzYE3p3
         fPlVl4u3agrT3fvOVq62DGMfen9T/ZeWZkm5EYsyCh3eOuB2asivxKjOQ5loR00CAPjy
         extsym4KMfZjejvWW8QyipmCXonCB5xAWl9HcXFQj2d2mvBPCCIimah7q+t/O2OytW74
         J/Ng==
X-Gm-Message-State: AJIora8tkksiNiYEJHh7SHARQtFotu04u021RC5HBAewg8w48c0BVTPD
        vyfWfPyIYPaIzykdma71b3XxwQ==
X-Google-Smtp-Source: AGRyM1t0Sg7QNT07MTv5TipgUyeCoKHdQDcO7qU98Wz4I2f2qxfuFGxN5vcTKI5CEek753oIReH4Hw==
X-Received: by 2002:a7b:ce0a:0:b0:3a3:1adf:af34 with SMTP id m10-20020a7bce0a000000b003a31adfaf34mr9026119wmc.127.1658232963931;
        Tue, 19 Jul 2022 05:16:03 -0700 (PDT)
Received: from sagittarius-a.chello.ie (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id d16-20020a05600c34d000b0039c5642e430sm14423812wmq.20.2022.07.19.05.16.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 05:16:03 -0700 (PDT)
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
To:     kvalo@kernel.org, loic.poulain@linaro.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        bryan.odonoghue@linaro.org
Subject: [PATCH 1/4] wcn36xx: Rename clunky firmware feature bit enum
Date:   Tue, 19 Jul 2022 13:15:57 +0100
Message-Id: <20220719121600.1847440-2-bryan.odonoghue@linaro.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220719121600.1847440-1-bryan.odonoghue@linaro.org>
References: <20220719121600.1847440-1-bryan.odonoghue@linaro.org>
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

Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/hal.h  | 2 +-
 drivers/net/wireless/ath/wcn36xx/main.c | 2 +-
 drivers/net/wireless/ath/wcn36xx/smd.c  | 6 +++---
 drivers/net/wireless/ath/wcn36xx/smd.h  | 6 +++---
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/hal.h b/drivers/net/wireless/ath/wcn36xx/hal.h
index 46a49f0a51b3..5e48c97682c2 100644
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
index e34d3d0b7082..efd776b20e60 100644
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
index 7ac9a1e6f768..88ee92be8562 100644
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
index 3fd598ac2a27..186dad4fe80e 100644
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

