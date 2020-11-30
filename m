Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A432C92D3
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 00:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388940AbgK3XiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 18:38:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388860AbgK3Xh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 18:37:58 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4299BC0613D3
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 15:37:18 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id d8so12510146ioc.13
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 15:37:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ls6ZikrHvoiYVZgb6g/fijukDjRX3YaJwgzv63JXyJM=;
        b=LKlfRNVrjf+qN5ebEP0Kra+aVaFplw1DNo+iOV6rKxJch3b0PksxxI5OOQ9QcH3hFt
         lO+cIi3BQOARzccwYCX6i7OhCSrmnx2wKRYVgti7wqYuqdB2NTnEcJp0J5sZ0djUn5Qc
         5dAjH6FJHt3QS56hKxNhAKxbUfT4NmP9SxIZPO/D0qbNcW+V4+6Abf8Ynxn1qXtx+8rT
         QRi9MKGw8ZYWDmlyTJ63pI33XE0Nu1XmyrzQbp0XMeRG94vfg1dy8H2p7h14YiAM/QAp
         82ZKut169Dmv+iPq5+aICRnpyLzJ44spcSSFiLfbCqttsVMSEoXLal15QxDJOxesB+ar
         ehsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ls6ZikrHvoiYVZgb6g/fijukDjRX3YaJwgzv63JXyJM=;
        b=MjwINJW0D5PpMgz2piaTh0DKl3rJvO7U30+tP/j6/KeQfhuwlT3+lDiy9Je6AlD40W
         p3/r03KDSeh6X6G8gNYkWj+9kT6cRQ6QWHxbAvdldFu/Ip2gOqOTnjjQnoP4qS+SIrbI
         dBTJiyz86q61gLh3FzdV/8d5TvJqFA1mTsD6emvVtDafR50ahjraq2S3LXhkT4e8ItBW
         U9+7oI99/YCYwWLAgVj0hZHWOdePb+P2NVQYkycTTlVVl6Incq2w3hhbjBQrWGUMgmE5
         SuxMNJTAxkFHbWT8PXCJsnPuKotsBdWpXsZuTdQWxK252dU2ICT10XeWoBM6NF5801g+
         muog==
X-Gm-Message-State: AOAM532pSfpt8Ap4x6fNRzevAfTjOtFqBMA/8qMHoCNO+hAPT5otQmak
        U597Dp84y1IZyGgymWe95CaPblg8R/Zq+w==
X-Google-Smtp-Source: ABdhPJwmslWBwtyrQnocPeVULdY8i3ICsIJTifO+M8+vfl35yRmcuV+d05nkS1JfH6aJRsEmfSWDTA==
X-Received: by 2002:a02:a304:: with SMTP id q4mr172780jai.97.1606779437492;
        Mon, 30 Nov 2020 15:37:17 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o195sm62574ila.38.2020.11.30.15.37.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 15:37:16 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/4] net: ipa: update IPA aggregation registers for IPA v4.5
Date:   Mon, 30 Nov 2020 17:37:09 -0600
Message-Id: <20201130233712.29113-2-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201130233712.29113-1-elder@linaro.org>
References: <20201130233712.29113-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPA v4.5 significantly changes the format of the configuration
register used for endpoint aggregation.  The AGGR_BYTE_LIMIT field
is now larger, and the positions of other fields are shifted.  This
complicates the way we have to access this register because functions
like u32_encode_bits() require their field mask argument to be constant.

A further complication is that we want to know the maximum value
representable by at least one of these fields, and that too requires
a constant field mask.

This patch adds support for IPA v4.5 endpoint aggregation registers
in a way that continues to support "legacy" IPA hardware.  It does
so in a way that keeps field masks constant.

First, for each variable field mask, we define an inline function
whose return value is either the legacy value or the IPA v4.5 value.

Second, we define functions for these fields that encode a value
to use in each field based on the IPA version (this approach is
already used elsewhere).  The field mask provided is supplied by
the function mentioned above.

Finally, for the aggregation byte limit fields where we want to
know the maximum representable value, we define a function that
returns that maximum, computed from the appropriate field mask.

We can no longer verify at build time that our buffer size is
in the range that can be represented by the aggregation byte
limit field.  So remove the test done by a BUILD_BUG_ON() call
in ipa_endpoint_validate_build(), and implement a comparable check
at the top of ipa_endpoint_data_valid().

Doing that makes ipa_endpoint_validate_build() contain a single
line BUILD_BUG_ON() call, so just remove that function and move
the remaining line into ipa_endpoint_data_valid().

One final note:  the aggregation time limit value for IPA v4.5 needs
to be computed differently.  That is handled in an upcoming patch.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 102 ++++++++++++++++++++++-----------
 drivers/net/ipa/ipa_reg.h      |  38 ++++++++++--
 2 files changed, 101 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 27f543b6780b1..f260c80f50649 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -37,7 +37,7 @@
 #define IPA_ENDPOINT_QMAP_METADATA_MASK		0x000000ff /* host byte order */
 
 #define IPA_ENDPOINT_RESET_AGGR_RETRY_MAX	3
-#define IPA_AGGR_TIME_LIMIT_DEFAULT		500	/* microseconds */
+#define IPA_AGGR_TIME_LIMIT			500	/* microseconds */
 
 /** enum ipa_status_opcode - status element opcode hardware values */
 enum ipa_status_opcode {
@@ -74,31 +74,6 @@ struct ipa_status {
 
 #ifdef IPA_VALIDATE
 
-static void ipa_endpoint_validate_build(void)
-{
-	/* The aggregation byte limit defines the point at which an
-	 * aggregation window will close.  It is programmed into the
-	 * IPA hardware as a number of KB.  We don't use "hard byte
-	 * limit" aggregation, which means that we need to supply
-	 * enough space in a receive buffer to hold a complete MTU
-	 * plus normal skb overhead *after* that aggregation byte
-	 * limit has been crossed.
-	 *
-	 * This check just ensures we don't define a receive buffer
-	 * size that would exceed what we can represent in the field
-	 * that is used to program its size.
-	 */
-	BUILD_BUG_ON(IPA_RX_BUFFER_SIZE >
-		     field_max(AGGR_BYTE_LIMIT_FMASK) * SZ_1K +
-		     IPA_MTU + IPA_RX_BUFFER_OVERHEAD);
-
-	/* I honestly don't know where this requirement comes from.  But
-	 * it holds, and if we someday need to loosen the constraint we
-	 * can try to track it down.
-	 */
-	BUILD_BUG_ON(sizeof(struct ipa_status) % 4);
-}
-
 static bool ipa_endpoint_data_valid_one(struct ipa *ipa, u32 count,
 			    const struct ipa_gsi_endpoint_data *all_data,
 			    const struct ipa_gsi_endpoint_data *data)
@@ -180,14 +155,24 @@ static bool ipa_endpoint_data_valid_one(struct ipa *ipa, u32 count,
 	return true;
 }
 
+static u32 aggr_byte_limit_max(enum ipa_version version)
+{
+	if (version < IPA_VERSION_4_5)
+		return field_max(aggr_byte_limit_fmask(true));
+
+	return field_max(aggr_byte_limit_fmask(false));
+}
+
 static bool ipa_endpoint_data_valid(struct ipa *ipa, u32 count,
 				    const struct ipa_gsi_endpoint_data *data)
 {
 	const struct ipa_gsi_endpoint_data *dp = data;
 	struct device *dev = &ipa->pdev->dev;
 	enum ipa_endpoint_name name;
+	u32 limit;
 
-	ipa_endpoint_validate_build();
+	/* Not sure where this constraint come from... */
+	BUILD_BUG_ON(sizeof(struct ipa_status) % 4);
 
 	if (count > IPA_ENDPOINT_COUNT) {
 		dev_err(dev, "too many endpoints specified (%u > %u)\n",
@@ -195,6 +180,26 @@ static bool ipa_endpoint_data_valid(struct ipa *ipa, u32 count,
 		return false;
 	}
 
+	/* The aggregation byte limit defines the point at which an
+	 * aggregation window will close.  It is programmed into the
+	 * IPA hardware as a number of KB.  We don't use "hard byte
+	 * limit" aggregation, which means that we need to supply
+	 * enough space in a receive buffer to hold a complete MTU
+	 * plus normal skb overhead *after* that aggregation byte
+	 * limit has been crossed.
+	 *
+	 * This check ensures we don't define a receive buffer size
+	 * that would exceed what we can represent in the field that
+	 * is used to program its size.
+	 */
+	limit = aggr_byte_limit_max(ipa->version) * SZ_1K;
+	limit += IPA_MTU + IPA_RX_BUFFER_OVERHEAD;
+	if (limit < IPA_RX_BUFFER_SIZE) {
+		dev_err(dev, "buffer size too big for aggregation (%u > %u)\n",
+			IPA_RX_BUFFER_SIZE, limit);
+		return false;
+	}
+
 	/* Make sure needed endpoints have defined data */
 	if (ipa_gsi_endpoint_data_empty(&data[IPA_ENDPOINT_AP_COMMAND_TX])) {
 		dev_err(dev, "command TX endpoint not defined\n");
@@ -624,29 +629,60 @@ static u32 ipa_aggr_size_kb(u32 rx_buffer_size)
 	return rx_buffer_size / SZ_1K;
 }
 
+/* Encoded values for AGGR endpoint register fields */
+static u32 aggr_byte_limit_encoded(enum ipa_version version, u32 limit)
+{
+	if (version < IPA_VERSION_4_5)
+		return u32_encode_bits(limit, aggr_byte_limit_fmask(true));
+
+	return u32_encode_bits(limit, aggr_byte_limit_fmask(false));
+}
+
+static u32 aggr_time_limit_encoded(enum ipa_version version, u32 limit)
+{
+	/* Convert limit (microseconds) to aggregation timer ticks */
+	limit = DIV_ROUND_CLOSEST(limit, IPA_AGGR_GRANULARITY);
+	if (version < IPA_VERSION_4_5)
+		return u32_encode_bits(limit, aggr_time_limit_fmask(true));
+
+	return u32_encode_bits(limit, aggr_time_limit_fmask(false));
+}
+
+static u32 aggr_sw_eof_active_encoded(enum ipa_version version, bool enabled)
+{
+	u32 val = enabled ? 1 : 0;
+
+	if (version < IPA_VERSION_4_5)
+		return u32_encode_bits(val, aggr_sw_eof_active_fmask(true));
+
+	return u32_encode_bits(val, aggr_sw_eof_active_fmask(false));
+}
+
 static void ipa_endpoint_init_aggr(struct ipa_endpoint *endpoint)
 {
 	u32 offset = IPA_REG_ENDP_INIT_AGGR_N_OFFSET(endpoint->endpoint_id);
+	enum ipa_version version = endpoint->ipa->version;
 	u32 val = 0;
 
 	if (endpoint->data->aggregation) {
 		if (!endpoint->toward_ipa) {
+			bool close_eof;
 			u32 limit;
 
 			val |= u32_encode_bits(IPA_ENABLE_AGGR, AGGR_EN_FMASK);
 			val |= u32_encode_bits(IPA_GENERIC, AGGR_TYPE_FMASK);
 
 			limit = ipa_aggr_size_kb(IPA_RX_BUFFER_SIZE);
-			val |= u32_encode_bits(limit, AGGR_BYTE_LIMIT_FMASK);
+			val |= aggr_byte_limit_encoded(version, limit);
 
-			limit = IPA_AGGR_TIME_LIMIT_DEFAULT;
-			limit = DIV_ROUND_CLOSEST(limit, IPA_AGGR_GRANULARITY);
-			val |= u32_encode_bits(limit, AGGR_TIME_LIMIT_FMASK);
+			limit = IPA_AGGR_TIME_LIMIT;
+			val |= aggr_time_limit_encoded(version, limit);
 
 			/* AGGR_PKT_LIMIT is 0 (unlimited) */
 
-			if (endpoint->data->rx.aggr_close_eof)
-				val |= AGGR_SW_EOF_ACTIVE_FMASK;
+			close_eof = endpoint->data->rx.aggr_close_eof;
+			val |= aggr_sw_eof_active_encoded(version, close_eof);
+
 			/* AGGR_HARD_BYTE_LIMIT_ENABLE is 0 */
 		} else {
 			val |= u32_encode_bits(IPA_ENABLE_DEAGGR,
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index 3fabafd7e32c6..09dcfa2998f04 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -450,12 +450,38 @@ enum ipa_mode {
 					(0x00000824 +  0x0070 * (ep))
 #define AGGR_EN_FMASK				GENMASK(1, 0)
 #define AGGR_TYPE_FMASK				GENMASK(4, 2)
-#define AGGR_BYTE_LIMIT_FMASK			GENMASK(9, 5)
-#define AGGR_TIME_LIMIT_FMASK			GENMASK(14, 10)
-#define AGGR_PKT_LIMIT_FMASK			GENMASK(20, 15)
-#define AGGR_SW_EOF_ACTIVE_FMASK		GENMASK(21, 21)
-#define AGGR_FORCE_CLOSE_FMASK			GENMASK(22, 22)
-#define AGGR_HARD_BYTE_LIMIT_ENABLE_FMASK	GENMASK(24, 24)
+static inline u32 aggr_byte_limit_fmask(bool legacy)
+{
+	return legacy ? GENMASK(9, 5) : GENMASK(10, 5);
+}
+
+static inline u32 aggr_time_limit_fmask(bool legacy)
+{
+	return legacy ? GENMASK(14, 10) : GENMASK(16, 12);
+}
+
+static inline u32 aggr_pkt_limit_fmask(bool legacy)
+{
+	return legacy ? GENMASK(20, 15) : GENMASK(22, 17);
+}
+
+static inline u32 aggr_sw_eof_active_fmask(bool legacy)
+{
+	return legacy ? GENMASK(21, 21) : GENMASK(23, 23);
+}
+
+static inline u32 aggr_force_close_fmask(bool legacy)
+{
+	return legacy ? GENMASK(22, 22) : GENMASK(24, 24);
+}
+
+static inline u32 aggr_hard_byte_limit_enable_fmask(bool legacy)
+{
+	return legacy ? GENMASK(24, 24) : GENMASK(26, 26);
+}
+
+/* The next field is present for IPA v4.5 */
+#define AGGR_GRAN_SEL_FMASK			GENMASK(27, 27)
 
 /** enum ipa_aggr_en - aggregation enable field in ENDP_INIT_AGGR_N */
 enum ipa_aggr_en {
-- 
2.20.1

