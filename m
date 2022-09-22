Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47E045E6F92
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 00:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbiIVWVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 18:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbiIVWVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 18:21:09 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D69310F700
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 15:21:08 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id y141so8964830iof.5
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 15:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=xmsMzMwZV5ZOovBFH/X4I+q5eM58vu3t0RCGdrrJ4lo=;
        b=lwk5GNqrV4OxPP8qp73gshHXz55xffiQpviZS/ZOTCHHSNl65LvN3ggIYjmO5dCpLr
         Fs1n4D/MTlA9unQWakS2OsQZLJmgrDzJlQuYZwJ1a0+EFAVmYQ7HYjS6FbCFrUArfl8X
         CMqugiEzrmfX607XfSUB+NyuToRFg6KRA9OZ/ccE6GfqynlnZVkyhZA8Q0dsmDRaZ5kf
         m6GsxFiPKivasjIfTp65t4GxlIIZFMawNtLhYaV53HxpcCIBdCrSuVKmkeyedfxLqJ8j
         rl1kTPr6Ju25tooQeuv9p+vESpBHaWcPAsbikY3DWOzNUVMV7IiKd/wShKcDGbI5pKro
         psuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=xmsMzMwZV5ZOovBFH/X4I+q5eM58vu3t0RCGdrrJ4lo=;
        b=Ap9h3xWrY5cdyNG886H+yVIWysXtx/tOqK97dbHIhiWoUUEV8N1J6QXCkG1fi1qapm
         MMbAH4MhmvgxdSqr3PSNo0Dw57T4VL9GlLTg1rpUOKERFFrr88Vr9C48c1REkIcfyXAQ
         W+DyAvGS5gjLM5KZACC+J6bK8kbSMvKFkMT7UwYXimCAZEBhn+9n6UaBKOFamgE8MqYP
         OpmuT2vQDNyXDI+BgCcxN8dPIOwFZGrRnn5W7tMyiAWWVoJyQdilRu/cCwrG9aZ8n9gu
         C+fxZELHqH6AGqtEb4p05PAfQGa+81R6yZKiuQWVGYKjwlM2yvQ8kUHYbiWEKu+kgudy
         kQLQ==
X-Gm-Message-State: ACrzQf3amEPEmoqsQ5DFNJkFKg+TDZlriRqbmlVyFo5TWaua4r3h8zeN
        ug1fi6pSjFsRpb1EE9VwvlaelQ==
X-Google-Smtp-Source: AMsMyM7C9xX0hkqYnTdMkfO0HNRWwamhjwDGRl38P9k/ct9i5H95W9s0SYARVEP+o9wrJgr8JAKAuA==
X-Received: by 2002:a6b:b28b:0:b0:6a1:eb9e:bf62 with SMTP id b133-20020a6bb28b000000b006a1eb9ebf62mr2577093iof.87.1663885267395;
        Thu, 22 Sep 2022 15:21:07 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id g12-20020a92d7cc000000b002f592936fbfsm2483332ilq.41.2022.09.22.15.21.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 15:21:06 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/8] net: ipa: rearrange functions for similarity
Date:   Thu, 22 Sep 2022 17:20:55 -0500
Message-Id: <20220922222100.2543621-4-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922222100.2543621-1-elder@linaro.org>
References: <20220922222100.2543621-1-elder@linaro.org>
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

Both aggr_time_limit_encode() and hol_block_timer_encode() figure
out how to encode a millisecond time value so it can be programmed
into a register.  Rearranging them a bit can make their similarity
more obvious, with both taking essentially the same form.

To do this:
  - Return 0 immediately in aggr_time_limit_encode() if the
    microseconds value supplied is zero.
  - Reverse the test at top of aggr_time_limit_encode(), so we
    compute and return the Qtime value in the "true" block,
    and compute the result the old way otherwise.
  - Open-code (and eliminate) hol_block_timer_qtime_encode() at the
    top of hol_block_timer_encode() in the case we use Qtimer.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 86 ++++++++++++++++------------------
 1 file changed, 41 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 7d91b423a1be7..6db62b6fb6632 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -752,34 +752,38 @@ static int ipa_qtime_val(u32 microseconds, u32 max)
 /* Encode the aggregation timer limit (microseconds) based on IPA version */
 static u32 aggr_time_limit_encode(enum ipa_version version, u32 microseconds)
 {
-	u32 gran_sel;
 	u32 fmask;
 	u32 val;
-	int ret;
 
-	if (version < IPA_VERSION_4_5) {
-		/* We set aggregation granularity in ipa_hardware_config() */
-		fmask = aggr_time_limit_fmask(true);
-		val = DIV_ROUND_CLOSEST(microseconds, IPA_AGGR_GRANULARITY);
-		WARN(val > field_max(fmask),
-		     "aggr_time_limit too large (%u > %u usec)\n",
-		     val, field_max(fmask) * IPA_AGGR_GRANULARITY);
+	if (!microseconds)
+		return 0;	/* Nothing to compute if time limit is 0 */
 
-		return u32_encode_bits(val, fmask);
-	}
+	if (version >= IPA_VERSION_4_5) {
+		u32 gran_sel;
+		int ret;
+
+		/* Compute the Qtime limit value to use */
+		fmask = aggr_time_limit_fmask(false);
+		ret = ipa_qtime_val(microseconds, field_max(fmask));
+		if (ret < 0) {
+			val = -ret;
+			gran_sel = AGGR_GRAN_SEL_FMASK;
+		} else {
+			val = ret;
+			gran_sel = 0;
+		}
 
-	/* Compute the Qtime limit value to use */
-	fmask = aggr_time_limit_fmask(false);
-	ret = ipa_qtime_val(microseconds, field_max(fmask));
-	if (ret < 0) {
-		val = -ret;
-		gran_sel = AGGR_GRAN_SEL_FMASK;
-	} else {
-		val = ret;
-		gran_sel = 0;
+		return gran_sel | u32_encode_bits(val, fmask);
 	}
 
-	return gran_sel | u32_encode_bits(val, fmask);
+	/* We set aggregation granularity in ipa_hardware_config() */
+	fmask = aggr_time_limit_fmask(true);
+	val = DIV_ROUND_CLOSEST(microseconds, IPA_AGGR_GRANULARITY);
+	WARN(val > field_max(fmask),
+	     "aggr_time_limit too large (%u > %u usec)\n",
+	     val, field_max(fmask) * IPA_AGGR_GRANULARITY);
+
+	return u32_encode_bits(val, fmask);
 }
 
 static u32 aggr_sw_eof_active_encoded(enum ipa_version version, bool enabled)
@@ -837,28 +841,6 @@ static void ipa_endpoint_init_aggr(struct ipa_endpoint *endpoint)
 	iowrite32(val, endpoint->ipa->reg_virt + offset);
 }
 
-/* Return the Qtime-based head-of-line blocking timer value that
- * represents the given number of microseconds.  The result
- * includes both the timer value and the selected timer granularity.
- */
-static u32 hol_block_timer_qtime_encode(struct ipa *ipa, u32 microseconds)
-{
-	u32 gran_sel;
-	u32 val;
-	int ret;
-
-	ret = ipa_qtime_val(microseconds, field_max(TIME_LIMIT_FMASK));
-	if (ret < 0) {
-		val = -ret;
-		gran_sel = GRAN_SEL_FMASK;
-	} else {
-		val = ret;
-		gran_sel = 0;
-	}
-
-	return gran_sel | u32_encode_bits(val, TIME_LIMIT_FMASK);
-}
-
 /* The head-of-line blocking timer is defined as a tick count.  For
  * IPA version 4.5 the tick count is based on the Qtimer, which is
  * derived from the 19.2 MHz SoC XO clock.  For older IPA versions
@@ -879,8 +861,22 @@ static u32 hol_block_timer_encode(struct ipa *ipa, u32 microseconds)
 	if (!microseconds)
 		return 0;	/* Nothing to compute if timer period is 0 */
 
-	if (ipa->version >= IPA_VERSION_4_5)
-		return hol_block_timer_qtime_encode(ipa, microseconds);
+	if (ipa->version >= IPA_VERSION_4_5) {
+		u32 gran_sel;
+		int ret;
+
+		/* Compute the Qtime limit value to use */
+		ret = ipa_qtime_val(microseconds, field_max(TIME_LIMIT_FMASK));
+		if (ret < 0) {
+			val = -ret;
+			gran_sel = GRAN_SEL_FMASK;
+		} else {
+			val = ret;
+			gran_sel = 0;
+		}
+
+		return gran_sel | u32_encode_bits(val, TIME_LIMIT_FMASK);
+	}
 
 	/* Use 64 bit arithmetic to avoid overflow... */
 	rate = ipa_core_clock_rate(ipa);
-- 
2.34.1

