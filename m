Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE1052D71D
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 17:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240551AbiESPMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 11:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240530AbiESPM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 11:12:26 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D527BC1EC8
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 08:12:24 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id q203so6138789iod.0
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 08:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6+Fem4lozWtl3MTEsgHhD7kgm6g1Bv+TgSucDp8qwU4=;
        b=r8lduLPLV/+WJPs6xI0z67kdZYr4bhBq7UBDVx0J2I2/QhR92iwg/faGLrSIQp+SVc
         oPqcaYoq8nQwo3b727CCcKbujGQw8gtgmSR8zdRhRFgzrjxAm0nwezkpDCMjGN8cC3Tj
         gr2UnFJuvASHof5uaMd7mQ6nOJYcKFfwYi8fwh+K94DO4eluJqd53qqbAACScC+Gy/2r
         UF+d3O0iP/pqmA3smXJjUQyQOkDEWp1e5C8FRqD74EMDkR6fKblLTMwIqKqEBEC4mqHc
         vQtQsSoikiNSAJ0i+bynrEb5QLUJnx1GXrkYtL1GZPI8IMARs5QUtVqB6bjdpmX1jKbs
         XG7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6+Fem4lozWtl3MTEsgHhD7kgm6g1Bv+TgSucDp8qwU4=;
        b=WzHtFXlJeDcSQzS1VQwX6LKGUOV9dcrVr+DtmG+4Z4WHRh3f/lddCUvJa6EVzN2OLJ
         KUqf0DBc1bokXcuoEgz8zY685YKFpt88oFh94Oj2CWf8RsSYGEiG2RetkmTQJ3dstriD
         bHf98suL7GIu+qrkT5Ag29NkWI5cxAZysEj0tlFPX37n6kmz9ljOdibFQ9xLC8s9Dv7W
         uqgwfi8LFxX7ziKHWhRPtogcEFv4nai9mXeU9Tyj5NIUX4m0I2NzqfGBamGkPJp4x+CK
         mfLkoCs56AC7j61WpzZdup/QoZg/SYYEo3UgrmmXI9mXdoxKU/stR/twkKIIn1UnqsBo
         F1Xg==
X-Gm-Message-State: AOAM5321vDdXfu9slklZl0CJkwBF5eWCA/gNuMDb3R1LuR0gRRXxHQB7
        Y47yUl5fosGAezk3uZxRkOhsnA==
X-Google-Smtp-Source: ABdhPJxBWtqaGJIJb1L/gDMiDvisXZovCsnyBQNBra6+I7P0WT7dPYuwficRbqp0p8zoo1epJtVNzQ==
X-Received: by 2002:a6b:5017:0:b0:65b:aa4:96cf with SMTP id e23-20020a6b5017000000b0065b0aa496cfmr2820248iob.47.1652973144210;
        Thu, 19 May 2022 08:12:24 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id g6-20020a025b06000000b0032e271a558csm683887jab.168.2022.05.19.08.12.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 08:12:23 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/7] net: ipa: ignore endianness if there is no header
Date:   Thu, 19 May 2022 10:12:13 -0500
Message-Id: <20220519151217.654890-4-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220519151217.654890-1-elder@linaro.org>
References: <20220519151217.654890-1-elder@linaro.org>
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

If we program an RX endpoint to have no header (header length is 0),
header-related endpoint configuration values are meaningless and are
ignored.

The only case we support that defines a header is QMAP endpoints.
In ipa_endpoint_init_hdr_ext() we set the endianness mask value
unconditionally, but it should not be done if there is no header
(meaning it is not configured for QMAP).

Set the endianness conditionally, and rearrange the logic in that
function slightly to avoid testing the qmap flag twice.

Delete an incorrect comment in ipa_endpoint_init_aggr().

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index e133eb2bebcfb..3fcd7c64c9bba 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -587,19 +587,23 @@ static void ipa_endpoint_init_hdr_ext(struct ipa_endpoint *endpoint)
 	struct ipa *ipa = endpoint->ipa;
 	u32 val = 0;
 
-	val |= HDR_ENDIANNESS_FMASK;		/* big endian */
+	if (endpoint->data->qmap) {
+		/* We have a header, so we must specify its endianness */
+		val |= HDR_ENDIANNESS_FMASK;	/* big endian */
 
-	/* A QMAP header contains a 6 bit pad field at offset 0.  The RMNet
-	 * driver assumes this field is meaningful in packets it receives,
-	 * and assumes the header's payload length includes that padding.
-	 * The RMNet driver does *not* pad packets it sends, however, so
-	 * the pad field (although 0) should be ignored.
-	 */
-	if (endpoint->data->qmap && !endpoint->toward_ipa) {
-		val |= HDR_TOTAL_LEN_OR_PAD_VALID_FMASK;
-		/* HDR_TOTAL_LEN_OR_PAD is 0 (pad, not total_len) */
-		val |= HDR_PAYLOAD_LEN_INC_PADDING_FMASK;
-		/* HDR_TOTAL_LEN_OR_PAD_OFFSET is 0 */
+		/* A QMAP header contains a 6 bit pad field at offset 0.
+		 * The RMNet driver assumes this field is meaningful in
+		 * packets it receives, and assumes the header's payload
+		 * length includes that padding.  The RMNet driver does
+		 * *not* pad packets it sends, however, so the pad field
+		 * (although 0) should be ignored.
+		 */
+		if (!endpoint->toward_ipa) {
+			val |= HDR_TOTAL_LEN_OR_PAD_VALID_FMASK;
+			/* HDR_TOTAL_LEN_OR_PAD is 0 (pad, not total_len) */
+			val |= HDR_PAYLOAD_LEN_INC_PADDING_FMASK;
+			/* HDR_TOTAL_LEN_OR_PAD_OFFSET is 0 */
+		}
 	}
 
 	/* HDR_PAYLOAD_LEN_INC_PADDING is 0 */
@@ -759,8 +763,6 @@ static void ipa_endpoint_init_aggr(struct ipa_endpoint *endpoint)
 
 			close_eof = rx_data->aggr_close_eof;
 			val |= aggr_sw_eof_active_encoded(version, close_eof);
-
-			/* AGGR_HARD_BYTE_LIMIT_ENABLE is 0 */
 		} else {
 			val |= u32_encode_bits(IPA_ENABLE_DEAGGR,
 					       AGGR_EN_FMASK);
-- 
2.32.0

