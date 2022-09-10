Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 452CE5B438F
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 03:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbiIJBLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 21:11:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbiIJBLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 21:11:42 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 092B010043E
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 18:11:40 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id g8so125302iob.0
        for <netdev@vger.kernel.org>; Fri, 09 Sep 2022 18:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=1UAIle1abMp4ppcBNEu/1g47bVXwskpesnhdVVUVLXg=;
        b=zpaLuPY5WsMrQzCIfXUuiYac/KKjPfqh7KmdrgBvrz/skLJXlrPeNIu29//gc6hV9D
         OGOp3SONkOGwxncAgR77g0NgkM3Q7LIZoIBUKX4IIgHrbEoeiHI+6YZnvpPDLyIUi9te
         D3Uew1f8cNHMcB1/KgLLM1Cqtaoy08baFDQedrDGVpOZTsgkXsuzbj7rqXi0MnpPv3L/
         fjbte/WLjG7ayvnsjK0tIvzJ1ZHSoPCSvhyKMovwM+tevQlBhkXrKES4pcVJfXf65Z44
         KtUILUXTbVv3fyi9V2X+LqG9us7NIIUJHglxYUKemJaEOFwulFC1Z6n5NS84R25OaCgW
         uUbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=1UAIle1abMp4ppcBNEu/1g47bVXwskpesnhdVVUVLXg=;
        b=1xeejAeEVV80lh9fEBreky8/N2+Or9Gqb4tN/tDK+w6EvOmfCTnbN1SNG+EmHDMGu7
         90T4d+QkBsS5Hin7Mb9QSrm44mtQZ8VICrN5o9qanbvwMvwyKypT+EM8OiNBZ6+jj+Gh
         TaZz2cNbcMiQ3DBOdoGRp1d9Kj55E8LfhxUKW47NDhzyFC4oQqhNFZnSA4Q9wsyuOqHE
         fPYVQQXoZq5GmRztzpHsQgUcjo8kJDHT02HUBraKhEa6zlG04ibbwLFJCKa1BYz3MBIy
         UQ8kaS36sE7O0+ZgYmoHUmJoLERERY1Z0Qnhi1+FoCNJulTDDGFMa1RIWEkotCunFQNF
         gO+A==
X-Gm-Message-State: ACgBeo1Bld0tqyPNX4SNWtCkBh6VEsH8Y4g15U/kjBSTgDklpy8d3AL4
        vw60AYm+FCQdc9cwL9Xne8+Oeg==
X-Google-Smtp-Source: AA6agR7PrXHpnbRAXTicoUKOCKAJQIBDirUPrVqFtJrSiECQSJXhcXvdP9U/UNvklq0qk62rEz1eyA==
X-Received: by 2002:a05:6602:140d:b0:68b:1bd1:1c54 with SMTP id t13-20020a056602140d00b0068b1bd11c54mr7922355iov.9.1662772299060;
        Fri, 09 Sep 2022 18:11:39 -0700 (PDT)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id u133-20020a02238b000000b00348e1a6491asm733064jau.137.2022.09.09.18.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 18:11:38 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/6] net: ipa: don't reuse variable names
Date:   Fri,  9 Sep 2022 20:11:29 -0500
Message-Id: <20220910011131.1431934-5-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220910011131.1431934-1-elder@linaro.org>
References: <20220910011131.1431934-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ipa_endpoint_init_hdr(), as well as ipa_endpoint_init_hdr_ext(),
a top-level automatic variable named "offset" is used to represent
the offset of a register.

However, deeper within each of those functions is *another*
definition of a local variable with the same name, representing
something else.  Scoping rules ensure the result is what was
intended, but this variable name reuse is bad practice and makes
the code confusing.

Fix this by naming the inner variable "off".  Use "off" instead of
"checksum_offset" in ipa_endpoint_init_cfg() for consistency.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 66d2bfdf9e423..eb68ce47698d0 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -494,12 +494,12 @@ static void ipa_endpoint_init_cfg(struct ipa_endpoint *endpoint)
 		enum ipa_version version = endpoint->ipa->version;
 
 		if (endpoint->toward_ipa) {
-			u32 checksum_offset;
+			u32 off;
 
 			/* Checksum header offset is in 4-byte units */
-			checksum_offset = sizeof(struct rmnet_map_header);
-			checksum_offset /= sizeof(u32);
-			val |= u32_encode_bits(checksum_offset,
+			off = sizeof(struct rmnet_map_header);
+			off /= sizeof(u32);
+			val |= u32_encode_bits(off,
 					       CS_METADATA_HDR_OFFSET_FMASK);
 
 			enabled = version < IPA_VERSION_4_5
@@ -590,20 +590,20 @@ static void ipa_endpoint_init_hdr(struct ipa_endpoint *endpoint)
 
 		/* Define how to fill fields in a received QMAP header */
 		if (!endpoint->toward_ipa) {
-			u32 offset;	/* Field offset within header */
+			u32 off;	/* Field offset within header */
 
 			/* Where IPA will write the metadata value */
-			offset = offsetof(struct rmnet_map_header, mux_id);
-			val |= ipa_metadata_offset_encoded(version, offset);
+			off = offsetof(struct rmnet_map_header, mux_id);
+			val |= ipa_metadata_offset_encoded(version, off);
 
 			/* Where IPA will write the length */
-			offset = offsetof(struct rmnet_map_header, pkt_len);
+			off = offsetof(struct rmnet_map_header, pkt_len);
 			/* Upper bits are stored in HDR_EXT with IPA v4.5 */
 			if (version >= IPA_VERSION_4_5)
-				offset &= field_mask(HDR_OFST_PKT_SIZE_FMASK);
+				off &= field_mask(HDR_OFST_PKT_SIZE_FMASK);
 
 			val |= HDR_OFST_PKT_SIZE_VALID_FMASK;
-			val |= u32_encode_bits(offset, HDR_OFST_PKT_SIZE_FMASK);
+			val |= u32_encode_bits(off, HDR_OFST_PKT_SIZE_FMASK);
 		}
 		/* For QMAP TX, metadata offset is 0 (modem assumes this) */
 		val |= HDR_OFST_METADATA_VALID_FMASK;
@@ -653,11 +653,11 @@ static void ipa_endpoint_init_hdr_ext(struct ipa_endpoint *endpoint)
 	if (ipa->version >= IPA_VERSION_4_5) {
 		/* HDR_TOTAL_LEN_OR_PAD_OFFSET is 0, so MSB is 0 */
 		if (endpoint->config.qmap && !endpoint->toward_ipa) {
-			u32 offset;
+			u32 off;
 
-			offset = offsetof(struct rmnet_map_header, pkt_len);
-			offset >>= hweight32(HDR_OFST_PKT_SIZE_FMASK);
-			val |= u32_encode_bits(offset,
+			off = offsetof(struct rmnet_map_header, pkt_len);
+			off >>= hweight32(HDR_OFST_PKT_SIZE_FMASK);
+			val |= u32_encode_bits(off,
 					       HDR_OFST_PKT_SIZE_MSB_FMASK);
 			/* HDR_ADDITIONAL_CONST_LEN is 0 so MSB is 0 */
 		}
-- 
2.34.1

