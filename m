Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBBA57A1CF
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239194AbiGSOiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239107AbiGSOiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:38:05 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A39C13D4F
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 07:33:07 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id e15so16636714wro.5
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 07:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jUzNsdnhvD/VjMTY/eS2UapJiTD9Uag6zWMc8hGErxY=;
        b=kTZwZ4QNONQziT2cZm06wRm+yA5PfWOT09ipBh75AVGEp8ewKOL8L1n3Wbp0iINC5O
         /rTw8rDxnW80ZpQzfcafZ/u5UQfXNxawODEVR32eJT5iyEv0ttL8khOU/APRjQwYcCeN
         9ZFLQvKxANgMrjR+JJDpIASrjSEI90HtfKo06ptbcaIOFPMzWYW8PR97QUukdB56NgLG
         WJ2bsrSi/qc0NPjKf6DpnM4mazdumFwKb+rKGpCxlKf0Oc4cS8jOLHoOj+NU9d9u+eoB
         Ud9SAbgeIIirOL9o3aRqWQONwa5KF2fehUn7+5SZjHkW61kD1gOnJTXinRIESVovwHj1
         KRIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jUzNsdnhvD/VjMTY/eS2UapJiTD9Uag6zWMc8hGErxY=;
        b=fW5yYj2Bdnah4kZ7h8qVJbvA3zYDwAMOcqvbH43gJeqXwyX8AqVlv31f+AQiQjntKh
         JctVxohnfRhCu3tqUnKUHjMyrG05YR8YredJq4RCLFc+3Bvt3sYOUQGrDerQYz4JPREF
         EDH+1V43UlV6q6VAWT1lY/JZ2HZOZNAzOGQKpAnEdEDmF44IgROWW0kKHxrD2YhaKFJw
         P4PUyeATeatL+Q0zJPRw1Ffe5ubj2X+fjNPOtBjDzoLb1UhGygGjjEWbYF2QjFY6LlUj
         meO20Kv9938iMJNqh/QvyB6Zx02ii6sgzzW9S5LqxQgDpRQcbHWru6vr1YF282tHEAxo
         Deiw==
X-Gm-Message-State: AJIora9L86Zm9Qc28zDIB3STKlREI/eOhpMlHHRrUtQJTNX/beIt3h3C
        ihjCwGjC/kNzHwfP3tJTB9pKzg==
X-Google-Smtp-Source: AGRyM1sY73wntQwXW5t8XQEgD3AyJ6EXNGPbhWUZgB9cwdB8yN8H5eXcbxqq4k/E+YABOYdwoPRcSw==
X-Received: by 2002:adf:f84a:0:b0:21d:6e52:7957 with SMTP id d10-20020adff84a000000b0021d6e527957mr28146454wrq.252.1658241186021;
        Tue, 19 Jul 2022 07:33:06 -0700 (PDT)
Received: from sagittarius-a.chello.ie (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id d15-20020adffbcf000000b0020fff0ea0a3sm13634378wrs.116.2022.07.19.07.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 07:33:05 -0700 (PDT)
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
To:     kvalo@kernel.org, loic.poulain@linaro.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        bryan.odonoghue@linaro.org
Subject: [PATCH v2 1/4] wcn36xx: Rename clunky firmware feature bit enum
Date:   Tue, 19 Jul 2022 15:32:59 +0100
Message-Id: <20220719143302.2071223-2-bryan.odonoghue@linaro.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220719143302.2071223-1-bryan.odonoghue@linaro.org>
References: <20220719143302.2071223-1-bryan.odonoghue@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

