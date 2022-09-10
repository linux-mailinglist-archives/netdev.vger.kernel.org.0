Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 964965B4396
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 03:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbiIJBMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 21:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbiIJBLp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 21:11:45 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B7E10B022
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 18:11:41 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id g8so125321iob.0
        for <netdev@vger.kernel.org>; Fri, 09 Sep 2022 18:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=Z8jWx+yuiUXA8uHYnPzxLNZNcdvj0qoXA4NsCQNbsvU=;
        b=uDfbcoX5N5k063md7ShugKpvT0lTa+KxUU46/U8xZIvGCnIgZ//Q8a96OST1uzReUJ
         xswu0yP6bxSkaG1zXAB1QJShMHBjlMSH7iOOFNRay79+0pQMgYx9CKj40GFOH8uVtdyv
         bIjE2tS98KEIeLiMjYM6sjQ36xsYTKPjtvr8z0xaC16hCqphnIyiAsMi1KOxsbNIXE/c
         +UQ7KbqEIxD7hcP6h/NR+lK/gB158dnK1T7Au1Ss6wkeJpSxglqOXFk0jkVq/YTXj4Z2
         8A3JsE17PcfGYdJaW+ck/XAIK1cuKg4CO5IlaTMW0Ea1Qa4Hjb2Vsuxmt37FfyLYV4yO
         BFKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Z8jWx+yuiUXA8uHYnPzxLNZNcdvj0qoXA4NsCQNbsvU=;
        b=u6jCBIHI4ONyxR4ShY5ANeGeSEChCK6GDv+FRZeuzMAy3Mc1I2wEYm8RxKMJAaBUIq
         aG8UfDsuccEMAz948QRvBlIYEWdncMC0fZsWirBeuI2D9HJ643cci5VcT4dfND3q4DD7
         D5qCc1n+CvUfK6abvL6o4yD2YPJKc9tlDlaDkMuHU2uFgL9+OIQX5Zsky/MJgT1yQUVD
         NmUyGA8WUBsm7iqttpVLUnXxdYxCoSihdUftHgLEH+KKUz7sG5ZhgK5cMINauqxhEdbR
         fjQKGtPUdZNK+tv8ddrULLxrbmQlyVPmsuJO7LlW6UBiB2Xe/XqYZmeEFt82+Say8X3h
         znVw==
X-Gm-Message-State: ACgBeo27I4ie1qaSnzZe4buXRRGuxpSibfbZ0dYH/Mg7xma4lMC4eCfL
        xzsKUQYJm9QSS15nhRhlc4qhpA==
X-Google-Smtp-Source: AA6agR6I72nJQz69y/9x1SjfSGV5avygudDukRCX76QXzUFjgYoeW9U96o33Jnn62ueKRyDMAlTCmQ==
X-Received: by 2002:a05:6602:2c02:b0:690:b560:7fae with SMTP id w2-20020a0566022c0200b00690b5607faemr7735799iov.169.1662772300078;
        Fri, 09 Sep 2022 18:11:40 -0700 (PDT)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id u133-20020a02238b000000b00348e1a6491asm733064jau.137.2022.09.09.18.11.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 18:11:39 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/6] net: ipa: update sequencer definition constraints
Date:   Fri,  9 Sep 2022 20:11:30 -0500
Message-Id: <20220910011131.1431934-6-elder@linaro.org>
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

Starting with IPA v4.5, replication is done differently from before,
and as a result the "replication" portion of the how the sequencer
is specified must be zero.

Add a check for the configuration data failing that requirement, and
only update the sesquencer type value when it's supported.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 16 +++++++++++++---
 drivers/net/ipa/ipa_reg.h      |  1 +
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index eb68ce47698d0..fe0eb882104ee 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -182,6 +182,15 @@ static bool ipa_endpoint_data_valid_one(struct ipa *ipa, u32 count,
 		return true;	/* Nothing more to check for RX */
 	}
 
+	/* Starting with IPA v4.5 sequencer replication is obsolete */
+	if (ipa->version >= IPA_VERSION_4_5) {
+		if (data->endpoint.config.tx.seq_rep_type) {
+			dev_err(dev, "no-zero seq_rep_type TX endpoint %u\n",
+				data->endpoint_id);
+			return false;
+		}
+	}
+
 	if (data->endpoint.config.status_enable) {
 		other_name = data->endpoint.config.tx.status_endpoint;
 		if (other_name >= count) {
@@ -995,9 +1004,10 @@ static void ipa_endpoint_init_seq(struct ipa_endpoint *endpoint)
 	/* Low-order byte configures primary packet processing */
 	val |= u32_encode_bits(endpoint->config.tx.seq_type, SEQ_TYPE_FMASK);
 
-	/* Second byte configures replicated packet processing */
-	val |= u32_encode_bits(endpoint->config.tx.seq_rep_type,
-			       SEQ_REP_TYPE_FMASK);
+	/* Second byte (if supported) configures replicated packet processing */
+	if (endpoint->ipa->version < IPA_VERSION_4_5)
+		val |= u32_encode_bits(endpoint->config.tx.seq_rep_type,
+				       SEQ_REP_TYPE_FMASK);
 
 	iowrite32(val, endpoint->ipa->reg_virt + offset);
 }
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index 6f35438cda890..b7b7fb553c445 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -585,6 +585,7 @@ static inline u32 rsrc_grp_encoded(enum ipa_version version, u32 rsrc_grp)
 #define IPA_REG_ENDP_INIT_SEQ_N_OFFSET(txep) \
 					(0x0000083c + 0x0070 * (txep))
 #define SEQ_TYPE_FMASK				GENMASK(7, 0)
+/* The next field must be zero for IPA v4.5+ */
 #define SEQ_REP_TYPE_FMASK			GENMASK(15, 8)
 
 /**
-- 
2.34.1

