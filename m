Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0699920F5B2
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 15:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387581AbgF3Nd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 09:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387538AbgF3NdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 09:33:13 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 825EEC03E97B
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 06:33:13 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id e64so16045430iof.12
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 06:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VivmetwM/ISybdgajhPoVZntM81ebOCgMDarkRt8jT4=;
        b=DaBoNeghK4qZvxJiBWLlENnutQceqDV+6kJ1XLOz8412+b0u5Qy1XRve8/mnAzac+u
         UJSQqcZLuZNEMOoMT6nIVzXAiXzRVAH0VrohiVwobdi70t/GSO3zygGkLgz1w+hnxc/S
         JjqASpXngaMnTgatQhvT2TnwA7W1iQ+TVm3ZqRR8gcXpXuWmEJ/ZMu8foZsVp5ztMUpk
         xHEIdmelad+E5thd6Wkt+4Flt9ScCkhalfdp9Lr3dhbGJ/1HVk+Kv9yfUOgq5xSO9nTW
         YfyfMyCW1Z9CmjJeiCKVCqeLjjmKv6YFcYdAmwm10rGMzYg3Z6zs0yThONKbU7d9bqEK
         U1ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VivmetwM/ISybdgajhPoVZntM81ebOCgMDarkRt8jT4=;
        b=AQYfoeeyiaRPVFq+sGXmJA2sJFdyqm9kdAzuHmF/NyvrxMtKQoBSz+12BIhEEDvqp6
         jbNXz+5mICTc+QkC/d2Lt2job+w1df60F646H/ZE85ALw+6YHTFraoc0YnttJVZScOOL
         /hQvgOhjiW+ku2R4RheeWIXDYC2BVFbXs8RlHUkvZHHxnJe0pwDx1GbwX0GUR5SsY/67
         3liJwI9P36tAi8I7y3hL9vtIN36p4Gt4RxreT++Mmb4WB5+wfUsr/uiVGcf6NsBeFLx1
         ynYfghNv5lflDUZvldvaICNHQU7/oWLv2QIu32vkfU52yguwhlgghP5dRg2cdpPs4YNV
         Llmw==
X-Gm-Message-State: AOAM530+TN7KzsvHxn+wwJqtgoculTdso1mai8D0CIHT64gFI6h1xcCR
        IUO3HxkboRpJ90JLPzu6DVs/Pg==
X-Google-Smtp-Source: ABdhPJzvhcL+sR7MlsUoG0f6dLY298MCZ3igvYEHJ60D0QhQlOtDmMEx/3fYG/7gGDxMFk1XGCUcuw==
X-Received: by 2002:a02:370b:: with SMTP id r11mr22384215jar.119.1593523992125;
        Tue, 30 Jun 2020 06:33:12 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id u15sm1538776iog.18.2020.06.30.06.33.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 06:33:11 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 4/5] net: ipa: clarify endpoint register macro constraints
Date:   Tue, 30 Jun 2020 08:33:03 -0500
Message-Id: <20200630133304.1331058-5-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200630133304.1331058-1-elder@linaro.org>
References: <20200630133304.1331058-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A handful of registers are valid only for RX endpoints, and some
others are valid only for TX endpoints.  For these endpoints, add
a comment above their defined offset macro that indicates the
endpoints to which they apply.

Extend the endpoint parameter naming convention as well, to make
these constraints more explicit.

Signed-off-by: Alex Elder <elder@linaro.org>
---
v2: No change from version 1.

 drivers/net/ipa/ipa_reg.h | 43 +++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index 0a688d8c1d7c..10e4ac9ead68 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -32,10 +32,12 @@ struct ipa;
  * parameter is supplied to the offset macro.  The "ee" value is a member of
  * the gsi_ee enumerated type.
  *
- * The offset of a register dependent on endpoint id is computed by a macro
- * that is supplied a parameter "ep".  The "ep" value is assumed to be less
- * than the maximum endpoint value for the current hardware, and that will
- * not exceed IPA_ENDPOINT_MAX.
+ * The offset of a register dependent on endpoint ID is computed by a macro
+ * that is supplied a parameter "ep", "txep", or "rxep".  A register with an
+ * "ep" parameter is valid for any endpoint; a register with a "txep" or
+ * "rxep" parameter is valid only for TX or RX endpoints, respectively.  The
+ * "*ep" value is assumed to be less than the maximum valid endpoint ID
+ * for the current hardware, and that will not exceed IPA_ENDPOINT_MAX.
  *
  * The offset of registers related to filter and route tables is computed
  * by a macro that is supplied a parameter "er".  The "er" represents an
@@ -293,11 +295,13 @@ static inline u32 ipa_reg_idle_indication_cfg_offset(enum ipa_version version)
 #define HDR_TOTAL_LEN_OR_PAD_OFFSET_FMASK	GENMASK(9, 4)
 #define HDR_PAD_TO_ALIGNMENT_FMASK		GENMASK(13, 10)
 
-#define IPA_REG_ENDP_INIT_HDR_METADATA_MASK_N_OFFSET(ep) \
-					(0x00000818 + 0x0070 * (ep))
+/* Valid only for RX (IPA producer) endpoints */
+#define IPA_REG_ENDP_INIT_HDR_METADATA_MASK_N_OFFSET(rxep) \
+					(0x00000818 + 0x0070 * (rxep))
 
-#define IPA_REG_ENDP_INIT_MODE_N_OFFSET(ep) \
-					(0x00000820 + 0x0070 * (ep))
+/* Valid only for TX (IPA consumer) endpoints */
+#define IPA_REG_ENDP_INIT_MODE_N_OFFSET(txep) \
+					(0x00000820 + 0x0070 * (txep))
 #define MODE_FMASK				GENMASK(2, 0)
 #define DEST_PIPE_INDEX_FMASK			GENMASK(8, 4)
 #define BYTE_THRESHOLD_FMASK			GENMASK(27, 12)
@@ -316,19 +320,21 @@ static inline u32 ipa_reg_idle_indication_cfg_offset(enum ipa_version version)
 #define AGGR_FORCE_CLOSE_FMASK			GENMASK(22, 22)
 #define AGGR_HARD_BYTE_LIMIT_ENABLE_FMASK	GENMASK(24, 24)
 
-#define IPA_REG_ENDP_INIT_HOL_BLOCK_EN_N_OFFSET(ep) \
-					(0x0000082c +  0x0070 * (ep))
+/* Valid only for RX (IPA producer) endpoints */
+#define IPA_REG_ENDP_INIT_HOL_BLOCK_EN_N_OFFSET(rxep) \
+					(0x0000082c +  0x0070 * (rxep))
 #define HOL_BLOCK_EN_FMASK			GENMASK(0, 0)
 
-/* The next register is valid only for RX (IPA producer) endpoints */
-#define IPA_REG_ENDP_INIT_HOL_BLOCK_TIMER_N_OFFSET(ep) \
-					(0x00000830 +  0x0070 * (ep))
+/* Valid only for RX (IPA producer) endpoints */
+#define IPA_REG_ENDP_INIT_HOL_BLOCK_TIMER_N_OFFSET(rxep) \
+					(0x00000830 +  0x0070 * (rxep))
 /* The next fields are present for IPA v4.2 only */
 #define BASE_VALUE_FMASK			GENMASK(4, 0)
 #define SCALE_FMASK				GENMASK(12, 8)
 
-#define IPA_REG_ENDP_INIT_DEAGGR_N_OFFSET(ep) \
-					(0x00000834 + 0x0070 * (ep))
+/* Valid only for TX (IPA consumer) endpoints */
+#define IPA_REG_ENDP_INIT_DEAGGR_N_OFFSET(txep) \
+					(0x00000834 + 0x0070 * (txep))
 #define DEAGGR_HDR_LEN_FMASK			GENMASK(5, 0)
 #define PACKET_OFFSET_VALID_FMASK		GENMASK(7, 7)
 #define PACKET_OFFSET_LOCATION_FMASK		GENMASK(13, 8)
@@ -338,8 +344,9 @@ static inline u32 ipa_reg_idle_indication_cfg_offset(enum ipa_version version)
 					(0x00000838 + 0x0070 * (ep))
 #define RSRC_GRP_FMASK				GENMASK(1, 0)
 
-#define IPA_REG_ENDP_INIT_SEQ_N_OFFSET(ep) \
-					(0x0000083c + 0x0070 * (ep))
+/* Valid only for TX (IPA consumer) endpoints */
+#define IPA_REG_ENDP_INIT_SEQ_N_OFFSET(txep) \
+					(0x0000083c + 0x0070 * (txep))
 #define HPS_SEQ_TYPE_FMASK			GENMASK(3, 0)
 #define DPS_SEQ_TYPE_FMASK			GENMASK(7, 4)
 #define HPS_REP_SEQ_TYPE_FMASK			GENMASK(11, 8)
@@ -353,7 +360,7 @@ static inline u32 ipa_reg_idle_indication_cfg_offset(enum ipa_version version)
 /* The next field is present for IPA v4.0 and above */
 #define STATUS_PKT_SUPPRESS_FMASK		GENMASK(9, 9)
 
-/* "er" is either an endpoint id (for filters) or a route id (for routes) */
+/* "er" is either an endpoint ID (for filters) or a route ID (for routes) */
 #define IPA_REG_ENDP_FILTER_ROUTER_HSH_CFG_N_OFFSET(er) \
 					(0x0000085c + 0x0070 * (er))
 #define FILTER_HASH_MSK_SRC_ID_FMASK		GENMASK(0, 0)
-- 
2.25.1

