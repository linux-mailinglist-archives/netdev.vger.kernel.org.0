Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A5B20E6B0
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404409AbgF2Vtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404381AbgF2Vt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 17:49:27 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD4CC08C5DD
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 14:49:27 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id y2so18867343ioy.3
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 14:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UVmv87Qr1j8KuR4CHHUPvULFMEa3w3NlP5if+cF+DAQ=;
        b=Jqf6BHa+i7sTatx5HYbEKr9kHF5raBaBKQbUVzpsdnVR5jGHP/Cn7fidP/oSKDyObY
         vQZYIb6k+8teeAHLwrtp7VxKG+HSNzWXsunMo81zAor3DT/RQbdZfNfgmQhFvM/842j8
         USmwnL8EqFMqiwdhkDRed78EZhRhkKPdnsaBGLZOR2lesbL/WrdINUFvCu6TTI/D8kkV
         DuwNJKMzJszBhaxcEbmL7D9TcCyTeBT1ObXpr6SXfOErYz/mIKuxQfIE3WamSXDJR43T
         TrCnT1RrZp5JOCKU/H3kw6qWywt155ODnILI5Hvkp29D4rIF6nxvtLGzPVscGVtYiyOU
         gqog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UVmv87Qr1j8KuR4CHHUPvULFMEa3w3NlP5if+cF+DAQ=;
        b=gxiOslGJcnNNelqTv2EzNwCsx7tSUbGONO4ml5QB17xvvUDDzQPzsUHRCrGhqZP9qD
         nzeN1YTFaxC9a6HqVT1oJ2Q+f8ojjLpH7rL6ptTlJVdSQU8Vqa+uVz0oewmJMrQGfqJS
         96RrRnucshHrS9lGu0YGgpxk5scbPYJZb9kCIWlOYaW0cv7rAgJhEkW+SzXTPJ0lrOTf
         MlOcdPqbpCkPd+0DqKIoXqHntPD/Ioo2mAEYhQ2gP8Dcrz/CNTJLOiC3bj/Rrat0xA/J
         08fSKJnbLlFk/f8eeO/kLj7gGdJN+5ZYDCM6lgSReRH+Luqk9Af6eyr/ZCHZEfAP/N8y
         HYlA==
X-Gm-Message-State: AOAM531uCCKKHFZydJ70c8VxhPr6U24leld3THL4G37Nt7CXY+ZklW19
        CBXc93wkuFMehAlqQL40r17pyA==
X-Google-Smtp-Source: ABdhPJw+G8OtN00d/NzD8u0nhIUZBQS6fnzi+BWryOh8TrzvfO2W5JolEM7+5cs6vjBNPM75+e+KIQ==
X-Received: by 2002:a05:6602:13c6:: with SMTP id o6mr18212654iov.84.1593467367213;
        Mon, 29 Jun 2020 14:49:27 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id u10sm555500iow.38.2020.06.29.14.49.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 14:49:26 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/5] net: ipa: clarify endpoint register macro constraints
Date:   Mon, 29 Jun 2020 16:49:18 -0500
Message-Id: <20200629214919.1196017-5-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629214919.1196017-1-elder@linaro.org>
References: <20200629214919.1196017-1-elder@linaro.org>
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

