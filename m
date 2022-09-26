Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE01E5EB455
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 00:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbiIZWMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 18:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231420AbiIZWLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 18:11:24 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1775252B6
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 15:10:08 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id n192so5226683iod.3
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 15:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=RCFJLLkj0Ft04fLZmkF63PV73kiZ/piN9/80rnULfMc=;
        b=N8iCz6RalTNkE1lPL2jZ2QghLgxYRqhjXuM58BxW4a9BfrnYAQqgjOGDaRjBBeXB5h
         1a5T+t/o9L03qr7bGmgavHfpRAx6n2yP4YaVgPen+njsR1pd3D6wamMGL6rOh41KnDsd
         Unu/sz3Ahu0P2v0CdrGgcQYY+hqIzMsOVapEzPQpOOfiAdBxote4n5X4LEJXr88C3aZV
         H1zQhLTte1V7dBVN8nP8KFPxB66M3skVdDK+DBgFZClxg3vFUjrN85m9bU3uzMP/VQOE
         wJPTulMgMpntRIFmJDbUk84brPaJh2IWvCwIpuP2uyKF5uDkJBOY8X1iSV2TPtoIxR40
         6ArA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=RCFJLLkj0Ft04fLZmkF63PV73kiZ/piN9/80rnULfMc=;
        b=iA45el3/Ttgacopklbv/TH4LWGrZT95/HxaS1haD2Ft38Hz5skaQ8PV8Wx1J+qV87I
         P0VsCTImAHTLRC0/MBdKPnIsJ6jVDiIRDXwJwaw1yY2jS+rn6lPXmXrd3FNKmHZgOge+
         m5br/GMC5F0+mXKvIIfsTGswF60eQGzY0hYUkHf9SML09wlcih4sy1VRK7EMZ9o0lV5X
         XJDZziUHkogHnQ3OcFDMEtD6YZSYiZVaUnKntPHZU8U0laKmfv/YNgnzkhObhlhXm9+M
         UChw6Vh6MV681WIQh4Wo8IbcGrsyQL7L5dESWYTE4418pAiWCiAKSZYJY3beplJLRkwy
         Tnpg==
X-Gm-Message-State: ACrzQf1TyI5V/Hd91sxrZZG0UGLmH8wCwSHm3zcZqB3Y5EviXIxg1Qlk
        2baumhxoW2+gxQK5DQEk/0bPXg==
X-Google-Smtp-Source: AMsMyM57XWmCiIIjwNuXZSa50DBYSCKflkqKLOMVbNLXUVGtaXPeWKGL6HOmDUAUX5n1Dt3ViuD3vA==
X-Received: by 2002:a05:6638:2686:b0:35a:40db:95ea with SMTP id o6-20020a056638268600b0035a40db95eamr13226010jat.303.1664230207902;
        Mon, 26 Sep 2022 15:10:07 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id z20-20020a027a54000000b003567503cf92sm7631600jad.82.2022.09.26.15.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 15:10:06 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 13/15] net: ipa: define some IPA endpoint register fields
Date:   Mon, 26 Sep 2022 17:09:29 -0500
Message-Id: <20220926220931.3261749-14-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220926220931.3261749-1-elder@linaro.org>
References: <20220926220931.3261749-1-elder@linaro.org>
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

Define the fields for the ENDP_INIT_CTRL, ENDP_INIT_CFG, ENDP_INIT_NAT,
ENDP_INIT_HDR, and ENDP_INIT_HDR_EXT IPA registers for all supported
IPA versions.

Create enumerated types to identify fields for these IPA registers.
Use IPA_REG_STRIDE_FIELDS() to specify the field mask values defined
for these registers, for each supported version of IPA.

Move ipa_header_size_encoded() and ipa_metadata_offset_encoded() out
of "ipa_reg.h" and into "ipa_endpoint.c".  Change them so they take
an additional ipa_reg structure argument, and use ipa_reg_encode()
to encode the parts of the header size and offset prior to writing
to the register.  Change their names to be verbs rather than nouns.

Use ipa_reg_encode(), ipa_reg_bit, and ipa_reg_field_max() to
manipulate values to be written to these registers, remove the
definition of the no-longer-used *_FMASK symbols.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c       |  86 ++++++++++++++++-----
 drivers/net/ipa/ipa_reg.h            | 110 +++++++++------------------
 drivers/net/ipa/reg/ipa_reg-v3.1.c   |  53 +++++++++++--
 drivers/net/ipa/reg/ipa_reg-v3.5.1.c |  53 +++++++++++--
 drivers/net/ipa/reg/ipa_reg-v4.11.c  |  49 +++++++++++-
 drivers/net/ipa/reg/ipa_reg-v4.2.c   |  45 ++++++++++-
 drivers/net/ipa/reg/ipa_reg-v4.5.c   |  49 +++++++++++-
 drivers/net/ipa/reg/ipa_reg-v4.9.c   |  48 +++++++++++-
 8 files changed, 374 insertions(+), 119 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 24431d8f626b3..80310ea745baa 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -310,6 +310,7 @@ ipa_endpoint_init_ctrl(struct ipa_endpoint *endpoint, bool suspend_delay)
 {
 	struct ipa *ipa = endpoint->ipa;
 	const struct ipa_reg *reg;
+	u32 field_id;
 	u32 offset;
 	bool state;
 	u32 mask;
@@ -321,10 +322,12 @@ ipa_endpoint_init_ctrl(struct ipa_endpoint *endpoint, bool suspend_delay)
 		WARN_ON(ipa->version >= IPA_VERSION_4_0);
 
 	reg = ipa_reg(ipa, ENDP_INIT_CTRL);
-	mask = endpoint->toward_ipa ? ENDP_DELAY_FMASK : ENDP_SUSPEND_FMASK;
 	offset = ipa_reg_n_offset(reg, endpoint->endpoint_id);
 	val = ioread32(ipa->reg_virt + offset);
 
+	field_id = endpoint->toward_ipa ? ENDP_DELAY : ENDP_SUSPEND;
+	mask = ipa_reg_bit(reg, field_id);
+
 	state = !!(val & mask);
 
 	/* Don't bother if it's already in the requested state */
@@ -516,10 +519,8 @@ static void ipa_endpoint_init_cfg(struct ipa_endpoint *endpoint)
 			u32 off;
 
 			/* Checksum header offset is in 4-byte units */
-			off = sizeof(struct rmnet_map_header);
-			off /= sizeof(u32);
-			val |= u32_encode_bits(off,
-					       CS_METADATA_HDR_OFFSET_FMASK);
+			off = sizeof(struct rmnet_map_header) / sizeof(u32);
+			val |= ipa_reg_encode(reg, CS_METADATA_HDR_OFFSET, off);
 
 			enabled = version < IPA_VERSION_4_5
 					? IPA_CS_OFFLOAD_UL
@@ -532,7 +533,7 @@ static void ipa_endpoint_init_cfg(struct ipa_endpoint *endpoint)
 	} else {
 		enabled = IPA_CS_OFFLOAD_NONE;
 	}
-	val |= u32_encode_bits(enabled, CS_OFFLOAD_EN_FMASK);
+	val |= ipa_reg_encode(reg, CS_OFFLOAD_EN, enabled);
 	/* CS_GEN_QMB_MASTER_SEL is 0 */
 
 	iowrite32(val, ipa->reg_virt + ipa_reg_n_offset(reg, endpoint_id));
@@ -549,7 +550,7 @@ static void ipa_endpoint_init_nat(struct ipa_endpoint *endpoint)
 		return;
 
 	reg = ipa_reg(ipa, ENDP_INIT_NAT);
-	val = u32_encode_bits(IPA_NAT_BYPASS, NAT_EN_FMASK);
+	val = ipa_reg_encode(reg, NAT_EN, IPA_NAT_BYPASS);
 
 	iowrite32(val, ipa->reg_virt + ipa_reg_n_offset(reg, endpoint_id));
 }
@@ -575,6 +576,50 @@ ipa_qmap_header_size(enum ipa_version version, struct ipa_endpoint *endpoint)
 	return header_size;
 }
 
+/* Encoded value for ENDP_INIT_HDR register HDR_LEN* field(s) */
+static u32 ipa_header_size_encode(enum ipa_version version,
+				  const struct ipa_reg *reg, u32 header_size)
+{
+	u32 field_max = ipa_reg_field_max(reg, HDR_LEN);
+	u32 val;
+
+	/* We know field_max can be used as a mask (2^n - 1) */
+	val = ipa_reg_encode(reg, HDR_LEN, header_size & field_max);
+	if (version < IPA_VERSION_4_5) {
+		WARN_ON(header_size > field_max);
+		return val;
+	}
+
+	/* IPA v4.5 adds a few more most-significant bits */
+	header_size >>= hweight32(field_max);
+	WARN_ON(header_size > ipa_reg_field_max(reg, HDR_LEN_MSB));
+	val |= ipa_reg_encode(reg, HDR_LEN_MSB, header_size);
+
+	return val;
+}
+
+/* Encoded value for ENDP_INIT_HDR register OFST_METADATA* field(s) */
+static u32 ipa_metadata_offset_encode(enum ipa_version version,
+				      const struct ipa_reg *reg, u32 offset)
+{
+	u32 field_max = ipa_reg_field_max(reg, HDR_OFST_METADATA);
+	u32 val;
+
+	/* We know field_max can be used as a mask (2^n - 1) */
+	val = ipa_reg_encode(reg, HDR_OFST_METADATA, offset);
+	if (version < IPA_VERSION_4_5) {
+		WARN_ON(offset > field_max);
+		return val;
+	}
+
+	/* IPA v4.5 adds a few more most-significant bits */
+	offset >>= hweight32(field_max);
+	WARN_ON(offset > ipa_reg_field_max(reg, HDR_OFST_METADATA_MSB));
+	val |= ipa_reg_encode(reg, HDR_OFST_METADATA_MSB, offset);
+
+	return val;
+}
+
 /**
  * ipa_endpoint_init_hdr() - Initialize HDR endpoint configuration register
  * @endpoint:	Endpoint pointer
@@ -609,7 +654,7 @@ static void ipa_endpoint_init_hdr(struct ipa_endpoint *endpoint)
 		size_t header_size;
 
 		header_size = ipa_qmap_header_size(version, endpoint);
-		val = ipa_header_size_encoded(version, header_size);
+		val = ipa_header_size_encode(version, reg, header_size);
 
 		/* Define how to fill fields in a received QMAP header */
 		if (!endpoint->toward_ipa) {
@@ -617,19 +662,19 @@ static void ipa_endpoint_init_hdr(struct ipa_endpoint *endpoint)
 
 			/* Where IPA will write the metadata value */
 			off = offsetof(struct rmnet_map_header, mux_id);
-			val |= ipa_metadata_offset_encoded(version, off);
+			val |= ipa_metadata_offset_encode(version, reg, off);
 
 			/* Where IPA will write the length */
 			off = offsetof(struct rmnet_map_header, pkt_len);
 			/* Upper bits are stored in HDR_EXT with IPA v4.5 */
 			if (version >= IPA_VERSION_4_5)
-				off &= field_mask(HDR_OFST_PKT_SIZE_FMASK);
+				off &= ipa_reg_field_max(reg, HDR_OFST_PKT_SIZE);
 
-			val |= HDR_OFST_PKT_SIZE_VALID_FMASK;
-			val |= u32_encode_bits(off, HDR_OFST_PKT_SIZE_FMASK);
+			val |= ipa_reg_bit(reg, HDR_OFST_PKT_SIZE_VALID);
+			val |= ipa_reg_encode(reg, HDR_OFST_PKT_SIZE, off);
 		}
 		/* For QMAP TX, metadata offset is 0 (modem assumes this) */
-		val |= HDR_OFST_METADATA_VALID_FMASK;
+		val |= ipa_reg_bit(reg, HDR_OFST_METADATA_VALID);
 
 		/* HDR_ADDITIONAL_CONST_LEN is 0; (RX only) */
 		/* HDR_A5_MUX is 0 */
@@ -651,7 +696,7 @@ static void ipa_endpoint_init_hdr_ext(struct ipa_endpoint *endpoint)
 	reg = ipa_reg(ipa, ENDP_INIT_HDR_EXT);
 	if (endpoint->config.qmap) {
 		/* We have a header, so we must specify its endianness */
-		val |= HDR_ENDIANNESS_FMASK;	/* big endian */
+		val |= ipa_reg_bit(reg, HDR_ENDIANNESS);	/* big endian */
 
 		/* A QMAP header contains a 6 bit pad field at offset 0.
 		 * The RMNet driver assumes this field is meaningful in
@@ -661,16 +706,16 @@ static void ipa_endpoint_init_hdr_ext(struct ipa_endpoint *endpoint)
 		 * (although 0) should be ignored.
 		 */
 		if (!endpoint->toward_ipa) {
-			val |= HDR_TOTAL_LEN_OR_PAD_VALID_FMASK;
+			val |= ipa_reg_bit(reg, HDR_TOTAL_LEN_OR_PAD_VALID);
 			/* HDR_TOTAL_LEN_OR_PAD is 0 (pad, not total_len) */
-			val |= HDR_PAYLOAD_LEN_INC_PADDING_FMASK;
+			val |= ipa_reg_bit(reg, HDR_PAYLOAD_LEN_INC_PADDING);
 			/* HDR_TOTAL_LEN_OR_PAD_OFFSET is 0 */
 		}
 	}
 
 	/* HDR_PAYLOAD_LEN_INC_PADDING is 0 */
 	if (!endpoint->toward_ipa)
-		val |= u32_encode_bits(pad_align, HDR_PAD_TO_ALIGNMENT_FMASK);
+		val |= ipa_reg_encode(reg, HDR_PAD_TO_ALIGNMENT, pad_align);
 
 	/* IPA v4.5 adds some most-significant bits to a few fields,
 	 * two of which are defined in the HDR (not HDR_EXT) register.
@@ -678,12 +723,13 @@ static void ipa_endpoint_init_hdr_ext(struct ipa_endpoint *endpoint)
 	if (ipa->version >= IPA_VERSION_4_5) {
 		/* HDR_TOTAL_LEN_OR_PAD_OFFSET is 0, so MSB is 0 */
 		if (endpoint->config.qmap && !endpoint->toward_ipa) {
+			u32 mask = ipa_reg_field_max(reg, HDR_OFST_PKT_SIZE);
 			u32 off;     /* Field offset within header */
 
 			off = offsetof(struct rmnet_map_header, pkt_len);
-			off >>= hweight32(HDR_OFST_PKT_SIZE_FMASK);
-			val |= u32_encode_bits(off,
-					       HDR_OFST_PKT_SIZE_MSB_FMASK);
+			/* Low bits are in the ENDP_INIT_HDR register */
+			off >>= hweight32(mask);
+			val |= ipa_reg_encode(reg, HDR_OFST_PKT_SIZE_MSB, off);
 			/* HDR_ADDITIONAL_CONST_LEN is 0 so MSB is 0 */
 		}
 	}
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index 0df61aaa8b819..bf8191ba2dda7 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -371,16 +371,18 @@ enum ipa_reg_rsrc_grp_rsrc_type_field_id {
 };
 
 /* ENDP_INIT_CTRL register */
-/* Valid only for RX (IPA producer) endpoints (do not use for IPA v4.0+) */
-#define ENDP_SUSPEND_FMASK			GENMASK(0, 0)
-/* Valid only for TX (IPA consumer) endpoints */
-#define ENDP_DELAY_FMASK			GENMASK(1, 1)
+enum ipa_reg_endp_init_ctrl_field_id {
+	ENDP_SUSPEND,					/* Not v4.0+ */
+	ENDP_DELAY,					/* Not v4.2+ */
+};
 
 /* ENDP_INIT_CFG register */
-#define FRAG_OFFLOAD_EN_FMASK			GENMASK(0, 0)
-#define CS_OFFLOAD_EN_FMASK			GENMASK(2, 1)
-#define CS_METADATA_HDR_OFFSET_FMASK		GENMASK(6, 3)
-#define CS_GEN_QMB_MASTER_SEL_FMASK		GENMASK(8, 8)
+enum ipa_reg_endp_init_cfg_field_id {
+	FRAG_OFFLOAD_EN,
+	CS_OFFLOAD_EN,
+	CS_METADATA_HDR_OFFSET,
+	CS_GEN_QMB_MASTER_SEL,
+};
 
 /** enum ipa_cs_offload_en - ENDP_INIT_CFG register CS_OFFLOAD_EN field value */
 enum ipa_cs_offload_en {
@@ -391,7 +393,9 @@ enum ipa_cs_offload_en {
 };
 
 /* ENDP_INIT_NAT register */
-#define NAT_EN_FMASK				GENMASK(1, 0)
+enum ipa_reg_endp_init_nat_field_id {
+	NAT_EN,
+};
 
 /** enum ipa_nat_en - ENDP_INIT_NAT register NAT_EN field value */
 enum ipa_nat_en {
@@ -401,72 +405,32 @@ enum ipa_nat_en {
 };
 
 /* ENDP_INIT_HDR register */
-#define HDR_LEN_FMASK				GENMASK(5, 0)
-#define HDR_OFST_METADATA_VALID_FMASK		GENMASK(6, 6)
-#define HDR_OFST_METADATA_FMASK			GENMASK(12, 7)
-#define HDR_ADDITIONAL_CONST_LEN_FMASK		GENMASK(18, 13)
-#define HDR_OFST_PKT_SIZE_VALID_FMASK		GENMASK(19, 19)
-#define HDR_OFST_PKT_SIZE_FMASK			GENMASK(25, 20)
-/* The next field is not present for IPA v4.9+ */
-#define HDR_A5_MUX_FMASK			GENMASK(26, 26)
-#define HDR_LEN_INC_DEAGG_HDR_FMASK		GENMASK(27, 27)
-/* The next field is not present for IPA v4.5+ */
-#define HDR_METADATA_REG_VALID_FMASK		GENMASK(28, 28)
-/* The next two fields are present for IPA v4.5+ */
-#define HDR_LEN_MSB_FMASK			GENMASK(29, 28)
-#define HDR_OFST_METADATA_MSB_FMASK		GENMASK(31, 30)
-
-/* Encoded value for ENDP_INIT_HDR register HDR_LEN* field(s) */
-static inline u32 ipa_header_size_encoded(enum ipa_version version,
-					  u32 header_size)
-{
-	u32 size = header_size & field_mask(HDR_LEN_FMASK);
-	u32 val;
-
-	val = u32_encode_bits(size, HDR_LEN_FMASK);
-	if (version < IPA_VERSION_4_5) {
-		WARN_ON(header_size != size);
-		return val;
-	}
-
-	/* IPA v4.5 adds a few more most-significant bits */
-	size = header_size >> hweight32(HDR_LEN_FMASK);
-	val |= u32_encode_bits(size, HDR_LEN_MSB_FMASK);
-
-	return val;
-}
-
-/* Encoded value for ENDP_INIT_HDR register OFST_METADATA* field(s) */
-static inline u32 ipa_metadata_offset_encoded(enum ipa_version version,
-					      u32 offset)
-{
-	u32 off = offset & field_mask(HDR_OFST_METADATA_FMASK);
-	u32 val;
-
-	val = u32_encode_bits(off, HDR_OFST_METADATA_FMASK);
-	if (version < IPA_VERSION_4_5) {
-		WARN_ON(offset != off);
-		return val;
-	}
-
-	/* IPA v4.5 adds a few more most-significant bits */
-	off = offset >> hweight32(HDR_OFST_METADATA_FMASK);
-	val |= u32_encode_bits(off, HDR_OFST_METADATA_MSB_FMASK);
-
-	return val;
-}
+enum ipa_reg_endp_init_hdr_field_id {
+	HDR_LEN,
+	HDR_OFST_METADATA_VALID,
+	HDR_OFST_METADATA,
+	HDR_ADDITIONAL_CONST_LEN,
+	HDR_OFST_PKT_SIZE_VALID,
+	HDR_OFST_PKT_SIZE,
+	HDR_A5_MUX,					/* Not v4.9+ */
+	HDR_LEN_INC_DEAGG_HDR,
+	HDR_METADATA_REG_VALID,				/* Not v4.5+ */
+	HDR_LEN_MSB,					/* v4.5+ */
+	HDR_OFST_METADATA_MSB,				/* v4.5+ */
+};
 
 /* ENDP_INIT_HDR_EXT register */
-#define HDR_ENDIANNESS_FMASK			GENMASK(0, 0)
-#define HDR_TOTAL_LEN_OR_PAD_VALID_FMASK	GENMASK(1, 1)
-#define HDR_TOTAL_LEN_OR_PAD_FMASK		GENMASK(2, 2)
-#define HDR_PAYLOAD_LEN_INC_PADDING_FMASK	GENMASK(3, 3)
-#define HDR_TOTAL_LEN_OR_PAD_OFFSET_FMASK	GENMASK(9, 4)
-#define HDR_PAD_TO_ALIGNMENT_FMASK		GENMASK(13, 10)
-/* The next three fields are present for IPA v4.5+ */
-#define HDR_TOTAL_LEN_OR_PAD_OFFSET_MSB_FMASK	GENMASK(17, 16)
-#define HDR_OFST_PKT_SIZE_MSB_FMASK		GENMASK(19, 18)
-#define HDR_ADDITIONAL_CONST_LEN_MSB_FMASK	GENMASK(21, 20)
+enum ipa_reg_endp_init_hdr_ext_field_id {
+	HDR_ENDIANNESS,
+	HDR_TOTAL_LEN_OR_PAD_VALID,
+	HDR_TOTAL_LEN_OR_PAD,
+	HDR_PAYLOAD_LEN_INC_PADDING,
+	HDR_TOTAL_LEN_OR_PAD_OFFSET,
+	HDR_PAD_TO_ALIGNMENT,
+	HDR_TOTAL_LEN_OR_PAD_OFFSET_MSB,		/* v4.5+ */
+	HDR_OFST_PKT_SIZE_MSB,				/* v4.5+ */
+	HDR_ADDITIONAL_CONST_LEN_MSB,			/* v4.5+ */
+};
 
 /* ENDP_INIT_MODE register */
 #define MODE_FMASK				GENMASK(2, 0)
diff --git a/drivers/net/ipa/reg/ipa_reg-v3.1.c b/drivers/net/ipa/reg/ipa_reg-v3.1.c
index 67739c59c1987..ced82061ba625 100644
--- a/drivers/net/ipa/reg/ipa_reg-v3.1.c
+++ b/drivers/net/ipa/reg/ipa_reg-v3.1.c
@@ -238,15 +238,58 @@ static const u32 ipa_reg_dst_rsrc_grp_67_rsrc_type_fmask[] = {
 IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_67_RSRC_TYPE, dst_rsrc_grp_67_rsrc_type,
 		      0x0000050c, 0x0020);
 
-IPA_REG_STRIDE(ENDP_INIT_CTRL, endp_init_ctrl, 0x00000800, 0x0070);
+static const u32 ipa_reg_endp_init_ctrl_fmask[] = {
+	[ENDP_SUSPEND]					= BIT(0),
+	[ENDP_DELAY]					= BIT(1),
+						/* Bits 2-31 reserved */
+};
 
-IPA_REG_STRIDE(ENDP_INIT_CFG, endp_init_cfg, 0x00000808, 0x0070);
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_CTRL, endp_init_ctrl, 0x00000800, 0x0070);
 
-IPA_REG_STRIDE(ENDP_INIT_NAT, endp_init_nat, 0x0000080c, 0x0070);
+static const u32 ipa_reg_endp_init_cfg_fmask[] = {
+	[FRAG_OFFLOAD_EN]				= BIT(0),
+	[CS_OFFLOAD_EN]					= GENMASK(2, 1),
+	[CS_METADATA_HDR_OFFSET]			= GENMASK(6, 3),
+						/* Bit 7 reserved */
+	[CS_GEN_QMB_MASTER_SEL]				= BIT(8),
+						/* Bits 9-31 reserved */
+};
 
-IPA_REG_STRIDE(ENDP_INIT_HDR, endp_init_hdr, 0x00000810, 0x0070);
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_CFG, endp_init_cfg, 0x00000808, 0x0070);
 
-IPA_REG_STRIDE(ENDP_INIT_HDR_EXT, endp_init_hdr_ext, 0x00000814, 0x0070);
+static const u32 ipa_reg_endp_init_nat_fmask[] = {
+	[NAT_EN]					= GENMASK(1, 0),
+						/* Bits 2-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_NAT, endp_init_nat, 0x0000080c, 0x0070);
+
+static const u32 ipa_reg_endp_init_hdr_fmask[] = {
+	[HDR_LEN]					= GENMASK(5, 0),
+	[HDR_OFST_METADATA_VALID]			= BIT(6),
+	[HDR_OFST_METADATA]				= GENMASK(12, 7),
+	[HDR_ADDITIONAL_CONST_LEN]			= GENMASK(18, 13),
+	[HDR_OFST_PKT_SIZE_VALID]			= BIT(19),
+	[HDR_OFST_PKT_SIZE]				= GENMASK(25, 20),
+	[HDR_A5_MUX]					= BIT(26),
+	[HDR_LEN_INC_DEAGG_HDR]				= BIT(27),
+	[HDR_METADATA_REG_VALID]			= BIT(28),
+						/* Bits 29-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_HDR, endp_init_hdr, 0x00000810, 0x0070);
+
+static const u32 ipa_reg_endp_init_hdr_ext_fmask[] = {
+	[HDR_ENDIANNESS]				= BIT(0),
+	[HDR_TOTAL_LEN_OR_PAD_VALID]			= BIT(1),
+	[HDR_TOTAL_LEN_OR_PAD]				= BIT(2),
+	[HDR_PAYLOAD_LEN_INC_PADDING]			= BIT(3),
+	[HDR_TOTAL_LEN_OR_PAD_OFFSET]			= GENMASK(9, 4),
+	[HDR_PAD_TO_ALIGNMENT]				= GENMASK(13, 10),
+						/* Bits 14-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_HDR_EXT, endp_init_hdr_ext, 0x00000814, 0x0070);
 
 IPA_REG_STRIDE(ENDP_INIT_HDR_METADATA_MASK, endp_init_hdr_metadata_mask,
 	       0x00000818, 0x0070);
diff --git a/drivers/net/ipa/reg/ipa_reg-v3.5.1.c b/drivers/net/ipa/reg/ipa_reg-v3.5.1.c
index 3f491992c93f1..d90367eab9ccf 100644
--- a/drivers/net/ipa/reg/ipa_reg-v3.5.1.c
+++ b/drivers/net/ipa/reg/ipa_reg-v3.5.1.c
@@ -217,15 +217,58 @@ static const u32 ipa_reg_dst_rsrc_grp_23_rsrc_type_fmask[] = {
 IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_23_RSRC_TYPE, dst_rsrc_grp_23_rsrc_type,
 		      0x00000504, 0x0020);
 
-IPA_REG_STRIDE(ENDP_INIT_CTRL, endp_init_ctrl, 0x00000800, 0x0070);
+static const u32 ipa_reg_endp_init_ctrl_fmask[] = {
+	[ENDP_SUSPEND]					= BIT(0),
+	[ENDP_DELAY]					= BIT(1),
+						/* Bits 2-31 reserved */
+};
 
-IPA_REG_STRIDE(ENDP_INIT_CFG, endp_init_cfg, 0x00000808, 0x0070);
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_CTRL, endp_init_ctrl, 0x00000800, 0x0070);
 
-IPA_REG_STRIDE(ENDP_INIT_NAT, endp_init_nat, 0x0000080c, 0x0070);
+static const u32 ipa_reg_endp_init_cfg_fmask[] = {
+	[FRAG_OFFLOAD_EN]				= BIT(0),
+	[CS_OFFLOAD_EN]					= GENMASK(2, 1),
+	[CS_METADATA_HDR_OFFSET]			= GENMASK(6, 3),
+						/* Bit 7 reserved */
+	[CS_GEN_QMB_MASTER_SEL]				= BIT(8),
+						/* Bits 9-31 reserved */
+};
 
-IPA_REG_STRIDE(ENDP_INIT_HDR, endp_init_hdr, 0x00000810, 0x0070);
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_CFG, endp_init_cfg, 0x00000808, 0x0070);
 
-IPA_REG_STRIDE(ENDP_INIT_HDR_EXT, endp_init_hdr_ext, 0x00000814, 0x0070);
+static const u32 ipa_reg_endp_init_nat_fmask[] = {
+	[NAT_EN]					= GENMASK(1, 0),
+						/* Bits 2-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_NAT, endp_init_nat, 0x0000080c, 0x0070);
+
+static const u32 ipa_reg_endp_init_hdr_fmask[] = {
+	[HDR_LEN]					= GENMASK(5, 0),
+	[HDR_OFST_METADATA_VALID]			= BIT(6),
+	[HDR_OFST_METADATA]				= GENMASK(12, 7),
+	[HDR_ADDITIONAL_CONST_LEN]			= GENMASK(18, 13),
+	[HDR_OFST_PKT_SIZE_VALID]			= BIT(19),
+	[HDR_OFST_PKT_SIZE]				= GENMASK(25, 20),
+	[HDR_A5_MUX]					= BIT(26),
+	[HDR_LEN_INC_DEAGG_HDR]				= BIT(27),
+	[HDR_METADATA_REG_VALID]			= BIT(28),
+						/* Bits 29-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_HDR, endp_init_hdr, 0x00000810, 0x0070);
+
+static const u32 ipa_reg_endp_init_hdr_ext_fmask[] = {
+	[HDR_ENDIANNESS]				= BIT(0),
+	[HDR_TOTAL_LEN_OR_PAD_VALID]			= BIT(1),
+	[HDR_TOTAL_LEN_OR_PAD]				= BIT(2),
+	[HDR_PAYLOAD_LEN_INC_PADDING]			= BIT(3),
+	[HDR_TOTAL_LEN_OR_PAD_OFFSET]			= GENMASK(9, 4),
+	[HDR_PAD_TO_ALIGNMENT]				= GENMASK(13, 10),
+						/* Bits 14-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_HDR_EXT, endp_init_hdr_ext, 0x00000814, 0x0070);
 
 IPA_REG_STRIDE(ENDP_INIT_HDR_METADATA_MASK, endp_init_hdr_metadata_mask,
 	       0x00000818, 0x0070);
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.11.c b/drivers/net/ipa/reg/ipa_reg-v4.11.c
index 7df6837a69328..ed775c8aa79c8 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.11.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.11.c
@@ -274,13 +274,54 @@ static const u32 ipa_reg_dst_rsrc_grp_23_rsrc_type_fmask[] = {
 IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_23_RSRC_TYPE, dst_rsrc_grp_23_rsrc_type,
 		      0x00000504, 0x0020);
 
-IPA_REG_STRIDE(ENDP_INIT_CFG, endp_init_cfg, 0x00000808, 0x0070);
+static const u32 ipa_reg_endp_init_cfg_fmask[] = {
+	[FRAG_OFFLOAD_EN]				= BIT(0),
+	[CS_OFFLOAD_EN]					= GENMASK(2, 1),
+	[CS_METADATA_HDR_OFFSET]			= GENMASK(6, 3),
+						/* Bit 7 reserved */
+	[CS_GEN_QMB_MASTER_SEL]				= BIT(8),
+						/* Bits 9-31 reserved */
+};
 
-IPA_REG_STRIDE(ENDP_INIT_NAT, endp_init_nat, 0x0000080c, 0x0070);
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_CFG, endp_init_cfg, 0x00000808, 0x0070);
 
-IPA_REG_STRIDE(ENDP_INIT_HDR, endp_init_hdr, 0x00000810, 0x0070);
+static const u32 ipa_reg_endp_init_nat_fmask[] = {
+	[NAT_EN]					= GENMASK(1, 0),
+						/* Bits 2-31 reserved */
+};
 
-IPA_REG_STRIDE(ENDP_INIT_HDR_EXT, endp_init_hdr_ext, 0x00000814, 0x0070);
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_NAT, endp_init_nat, 0x0000080c, 0x0070);
+
+static const u32 ipa_reg_endp_init_hdr_fmask[] = {
+	[HDR_LEN]					= GENMASK(5, 0),
+	[HDR_OFST_METADATA_VALID]			= BIT(6),
+	[HDR_OFST_METADATA]				= GENMASK(12, 7),
+	[HDR_ADDITIONAL_CONST_LEN]			= GENMASK(18, 13),
+	[HDR_OFST_PKT_SIZE_VALID]			= BIT(19),
+	[HDR_OFST_PKT_SIZE]				= GENMASK(25, 20),
+						/* Bit 26 reserved */
+	[HDR_LEN_INC_DEAGG_HDR]				= BIT(27),
+	[HDR_LEN_MSB]					= GENMASK(29, 28),
+	[HDR_OFST_METADATA_MSB]				= GENMASK(31, 30),
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_HDR, endp_init_hdr, 0x00000810, 0x0070);
+
+static const u32 ipa_reg_endp_init_hdr_ext_fmask[] = {
+	[HDR_ENDIANNESS]				= BIT(0),
+	[HDR_TOTAL_LEN_OR_PAD_VALID]			= BIT(1),
+	[HDR_TOTAL_LEN_OR_PAD]				= BIT(2),
+	[HDR_PAYLOAD_LEN_INC_PADDING]			= BIT(3),
+	[HDR_TOTAL_LEN_OR_PAD_OFFSET]			= GENMASK(9, 4),
+	[HDR_PAD_TO_ALIGNMENT]				= GENMASK(13, 10),
+						/* Bits 14-15 reserved */
+	[HDR_TOTAL_LEN_OR_PAD_OFFSET_MSB]		= GENMASK(17, 16),
+	[HDR_OFST_PKT_SIZE_MSB]				= GENMASK(19, 18),
+	[HDR_ADDITIONAL_CONST_LEN_MSB]			= GENMASK(21, 20),
+						/* Bits 22-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_HDR_EXT, endp_init_hdr_ext, 0x00000814, 0x0070);
 
 IPA_REG_STRIDE(ENDP_INIT_HDR_METADATA_MASK, endp_init_hdr_metadata_mask,
 	       0x00000818, 0x0070);
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.2.c b/drivers/net/ipa/reg/ipa_reg-v4.2.c
index a680e131ea84f..22e30c7ebac96 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.2.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.2.c
@@ -248,13 +248,50 @@ static const u32 ipa_reg_dst_rsrc_grp_23_rsrc_type_fmask[] = {
 IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_23_RSRC_TYPE, dst_rsrc_grp_23_rsrc_type,
 		      0x00000504, 0x0020);
 
-IPA_REG_STRIDE(ENDP_INIT_CFG, endp_init_cfg, 0x00000808, 0x0070);
+static const u32 ipa_reg_endp_init_cfg_fmask[] = {
+	[FRAG_OFFLOAD_EN]				= BIT(0),
+	[CS_OFFLOAD_EN]					= GENMASK(2, 1),
+	[CS_METADATA_HDR_OFFSET]			= GENMASK(6, 3),
+						/* Bit 7 reserved */
+	[CS_GEN_QMB_MASTER_SEL]				= BIT(8),
+						/* Bits 9-31 reserved */
+};
 
-IPA_REG_STRIDE(ENDP_INIT_NAT, endp_init_nat, 0x0000080c, 0x0070);
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_CFG, endp_init_cfg, 0x00000808, 0x0070);
 
-IPA_REG_STRIDE(ENDP_INIT_HDR, endp_init_hdr, 0x00000810, 0x0070);
+static const u32 ipa_reg_endp_init_nat_fmask[] = {
+	[NAT_EN]					= GENMASK(1, 0),
+						/* Bits 2-31 reserved */
+};
 
-IPA_REG_STRIDE(ENDP_INIT_HDR_EXT, endp_init_hdr_ext, 0x00000814, 0x0070);
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_NAT, endp_init_nat, 0x0000080c, 0x0070);
+
+static const u32 ipa_reg_endp_init_hdr_fmask[] = {
+	[HDR_LEN]					= GENMASK(5, 0),
+	[HDR_OFST_METADATA_VALID]			= BIT(6),
+	[HDR_OFST_METADATA]				= GENMASK(12, 7),
+	[HDR_ADDITIONAL_CONST_LEN]			= GENMASK(18, 13),
+	[HDR_OFST_PKT_SIZE_VALID]			= BIT(19),
+	[HDR_OFST_PKT_SIZE]				= GENMASK(25, 20),
+	[HDR_A5_MUX]					= BIT(26),
+	[HDR_LEN_INC_DEAGG_HDR]				= BIT(27),
+	[HDR_METADATA_REG_VALID]			= BIT(28),
+						/* Bits 29-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_HDR, endp_init_hdr, 0x00000810, 0x0070);
+
+static const u32 ipa_reg_endp_init_hdr_ext_fmask[] = {
+	[HDR_ENDIANNESS]				= BIT(0),
+	[HDR_TOTAL_LEN_OR_PAD_VALID]			= BIT(1),
+	[HDR_TOTAL_LEN_OR_PAD]				= BIT(2),
+	[HDR_PAYLOAD_LEN_INC_PADDING]			= BIT(3),
+	[HDR_TOTAL_LEN_OR_PAD_OFFSET]			= GENMASK(9, 4),
+	[HDR_PAD_TO_ALIGNMENT]				= GENMASK(13, 10),
+						/* Bits 14-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_HDR_EXT, endp_init_hdr_ext, 0x00000814, 0x0070);
 
 IPA_REG_STRIDE(ENDP_INIT_HDR_METADATA_MASK, endp_init_hdr_metadata_mask,
 	       0x00000818, 0x0070);
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.5.c b/drivers/net/ipa/reg/ipa_reg-v4.5.c
index f43684f92fee9..d5739f7d15ca5 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.5.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.5.c
@@ -294,13 +294,54 @@ static const u32 ipa_reg_dst_rsrc_grp_45_rsrc_type_fmask[] = {
 IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_45_RSRC_TYPE, dst_rsrc_grp_45_rsrc_type,
 		      0x00000508, 0x0020);
 
-IPA_REG_STRIDE(ENDP_INIT_CFG, endp_init_cfg, 0x00000808, 0x0070);
+static const u32 ipa_reg_endp_init_cfg_fmask[] = {
+	[FRAG_OFFLOAD_EN]				= BIT(0),
+	[CS_OFFLOAD_EN]					= GENMASK(2, 1),
+	[CS_METADATA_HDR_OFFSET]			= GENMASK(6, 3),
+						/* Bit 7 reserved */
+	[CS_GEN_QMB_MASTER_SEL]				= BIT(8),
+						/* Bits 9-31 reserved */
+};
 
-IPA_REG_STRIDE(ENDP_INIT_NAT, endp_init_nat, 0x0000080c, 0x0070);
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_CFG, endp_init_cfg, 0x00000808, 0x0070);
 
-IPA_REG_STRIDE(ENDP_INIT_HDR, endp_init_hdr, 0x00000810, 0x0070);
+static const u32 ipa_reg_endp_init_nat_fmask[] = {
+	[NAT_EN]					= GENMASK(1, 0),
+						/* Bits 2-31 reserved */
+};
 
-IPA_REG_STRIDE(ENDP_INIT_HDR_EXT, endp_init_hdr_ext, 0x00000814, 0x0070);
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_NAT, endp_init_nat, 0x0000080c, 0x0070);
+
+static const u32 ipa_reg_endp_init_hdr_fmask[] = {
+	[HDR_LEN]					= GENMASK(5, 0),
+	[HDR_OFST_METADATA_VALID]			= BIT(6),
+	[HDR_OFST_METADATA]				= GENMASK(12, 7),
+	[HDR_ADDITIONAL_CONST_LEN]			= GENMASK(18, 13),
+	[HDR_OFST_PKT_SIZE_VALID]			= BIT(19),
+	[HDR_OFST_PKT_SIZE]				= GENMASK(25, 20),
+	[HDR_A5_MUX]					= BIT(26),
+	[HDR_LEN_INC_DEAGG_HDR]				= BIT(27),
+	[HDR_LEN_MSB]					= GENMASK(29, 28),
+	[HDR_OFST_METADATA_MSB]				= GENMASK(31, 30),
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_HDR, endp_init_hdr, 0x00000810, 0x0070);
+
+static const u32 ipa_reg_endp_init_hdr_ext_fmask[] = {
+	[HDR_ENDIANNESS]				= BIT(0),
+	[HDR_TOTAL_LEN_OR_PAD_VALID]			= BIT(1),
+	[HDR_TOTAL_LEN_OR_PAD]				= BIT(2),
+	[HDR_PAYLOAD_LEN_INC_PADDING]			= BIT(3),
+	[HDR_TOTAL_LEN_OR_PAD_OFFSET]			= GENMASK(9, 4),
+	[HDR_PAD_TO_ALIGNMENT]				= GENMASK(13, 10),
+						/* Bits 14-15 reserved */
+	[HDR_TOTAL_LEN_OR_PAD_OFFSET_MSB]		= GENMASK(17, 16),
+	[HDR_OFST_PKT_SIZE_MSB]				= GENMASK(19, 18),
+	[HDR_ADDITIONAL_CONST_LEN_MSB]			= GENMASK(21, 20),
+						/* Bits 22-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_HDR_EXT, endp_init_hdr_ext, 0x00000814, 0x0070);
 
 IPA_REG_STRIDE(ENDP_INIT_HDR_METADATA_MASK, endp_init_hdr_metadata_mask,
 	       0x00000818, 0x0070);
diff --git a/drivers/net/ipa/reg/ipa_reg-v4.9.c b/drivers/net/ipa/reg/ipa_reg-v4.9.c
index ab71c3195cc32..206e7af959623 100644
--- a/drivers/net/ipa/reg/ipa_reg-v4.9.c
+++ b/drivers/net/ipa/reg/ipa_reg-v4.9.c
@@ -272,13 +272,53 @@ static const u32 ipa_reg_dst_rsrc_grp_23_rsrc_type_fmask[] = {
 IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_23_RSRC_TYPE, dst_rsrc_grp_23_rsrc_type,
 		      0x00000504, 0x0020);
 
-IPA_REG_STRIDE(ENDP_INIT_CFG, endp_init_cfg, 0x00000808, 0x0070);
+static const u32 ipa_reg_endp_init_cfg_fmask[] = {
+	[FRAG_OFFLOAD_EN]				= BIT(0),
+	[CS_OFFLOAD_EN]					= GENMASK(2, 1),
+	[CS_METADATA_HDR_OFFSET]			= GENMASK(6, 3),
+						/* Bit 7 reserved */
+	[CS_GEN_QMB_MASTER_SEL]				= BIT(8),
+						/* Bits 9-31 reserved */
+};
 
-IPA_REG_STRIDE(ENDP_INIT_NAT, endp_init_nat, 0x0000080c, 0x0070);
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_CFG, endp_init_cfg, 0x00000808, 0x0070);
 
-IPA_REG_STRIDE(ENDP_INIT_HDR, endp_init_hdr, 0x00000810, 0x0070);
+static const u32 ipa_reg_endp_init_nat_fmask[] = {
+	[NAT_EN]					= GENMASK(1, 0),
+						/* Bits 2-31 reserved */
+};
 
-IPA_REG_STRIDE(ENDP_INIT_HDR_EXT, endp_init_hdr_ext, 0x00000814, 0x0070);
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_NAT, endp_init_nat, 0x0000080c, 0x0070);
+
+static const u32 ipa_reg_endp_init_hdr_fmask[] = {
+	[HDR_LEN]					= GENMASK(5, 0),
+	[HDR_OFST_METADATA_VALID]			= BIT(6),
+	[HDR_OFST_METADATA]				= GENMASK(12, 7),
+	[HDR_ADDITIONAL_CONST_LEN]			= GENMASK(18, 13),
+	[HDR_OFST_PKT_SIZE_VALID]			= BIT(19),
+	[HDR_OFST_PKT_SIZE]				= GENMASK(25, 20),
+	[HDR_LEN_INC_DEAGG_HDR]				= BIT(27),
+	[HDR_LEN_MSB]					= GENMASK(29, 28),
+	[HDR_OFST_METADATA_MSB]				= GENMASK(31, 30),
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_HDR, endp_init_hdr, 0x00000810, 0x0070);
+
+static const u32 ipa_reg_endp_init_hdr_ext_fmask[] = {
+	[HDR_ENDIANNESS]				= BIT(0),
+	[HDR_TOTAL_LEN_OR_PAD_VALID]			= BIT(1),
+	[HDR_TOTAL_LEN_OR_PAD]				= BIT(2),
+	[HDR_PAYLOAD_LEN_INC_PADDING]			= BIT(3),
+	[HDR_TOTAL_LEN_OR_PAD_OFFSET]			= GENMASK(9, 4),
+	[HDR_PAD_TO_ALIGNMENT]				= GENMASK(13, 10),
+						/* Bits 14-15 reserved */
+	[HDR_TOTAL_LEN_OR_PAD_OFFSET_MSB]		= GENMASK(17, 16),
+	[HDR_OFST_PKT_SIZE_MSB]				= GENMASK(19, 18),
+	[HDR_ADDITIONAL_CONST_LEN_MSB]			= GENMASK(21, 20),
+						/* Bits 22-31 reserved */
+};
+
+IPA_REG_STRIDE_FIELDS(ENDP_INIT_HDR_EXT, endp_init_hdr_ext, 0x00000814, 0x0070);
 
 IPA_REG_STRIDE(ENDP_INIT_HDR_METADATA_MASK, endp_init_hdr_metadata_mask,
 	       0x00000818, 0x0070);
-- 
2.34.1

