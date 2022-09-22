Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 827EB5E6F90
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 00:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbiIVWVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 18:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbiIVWVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 18:21:09 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F3E10D656
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 15:21:06 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id h194so8970706iof.4
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 15:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=fOJuWqvAnwdqxCGdTOZjQMpso1NiM0QWWLIjlpoN+6A=;
        b=X4dwlDiBTpCjHyEP+isay760jMKIQNVLRCK/TCTHNXBq/pSvWGHr/2bAOfDG09UWVt
         jduT5Dh0VTNoVz7NxirfDrYW7qg+6XJyPxRPqtiIaGBDiUVhd2hbg48Q7aLy/sNNiTIx
         KtUM1lUnA62uSAIEH4RWvmaUhuxC7xCcysdGQKMv9WjNJWMzzLpgjTJnIPsnI5u0aeG0
         wOct/PFsjmKRDmegnOvpQMBSGiJYenuqxw2kbMRGpFsDs613bAYGpLi+8YyHMlUxRbkM
         bXQuG0CFHlLtQzUa2KLYqQ+kPVAYk5vQhyH2yMo/08xmCcyVULot3+2m8HkGGLuNKLS4
         4t7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=fOJuWqvAnwdqxCGdTOZjQMpso1NiM0QWWLIjlpoN+6A=;
        b=E+43QFaXn30BMGkqgWbY0FGs4nXg8nlpIb/WzwgBXVfcS8j6ix79JwsZzQHYsstYHS
         5tQFKaTXkD9JzfkKRDIRx+8YdZrJC9X5VV51q17ESiuy3HiW30d+xglk4uTzj1WAu8za
         BwtK1zQhSmvZjpynbQlNF/pT6TFBWpe+MPpaJWOycC8wKIycqC+kCMKh4gmwvku5wmWU
         muywYl0ywVKLyQVHmutamU7yTrycnoWtYUM06H4YZpY95vOg0knD10T4yBHocVvB+fyZ
         2d0JaQKfphvyl6BNi3wmX0Y5ydOdi7X8bMlQUOQHg07LBDRYLGJJF++M2LT1d7hx4Q4U
         xfBw==
X-Gm-Message-State: ACrzQf3uWurt8r5bWkyVqVSrPiihXLxE7QbDQbb21YcYbJMrqEcc5hbX
        epKwkeaC3QHmL9AQwpr4xDwIaQ==
X-Google-Smtp-Source: AMsMyM5PHtyZKk/jZ5bXHhlQmYH/5oF2MoMvcVRqC2j9oJ2D1U0AQOz4HOQ7q55j4k+WM+K+fsn0aQ==
X-Received: by 2002:a05:6638:26f:b0:35a:bc20:41f2 with SMTP id x15-20020a056638026f00b0035abc2041f2mr3229899jaq.121.1663885266030;
        Thu, 22 Sep 2022 15:21:06 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id g12-20020a92d7cc000000b002f592936fbfsm2483332ilq.41.2022.09.22.15.21.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 15:21:05 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/8] net: ipa: introduce ipa_qtime_val()
Date:   Thu, 22 Sep 2022 17:20:54 -0500
Message-Id: <20220922222100.2543621-3-elder@linaro.org>
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

Create a new function ipa_qtime_val() which returns a value that
indicates what should be encoded for a register with a time field
expressed using Qtime.  Use it to factor out common code in
aggr_time_limit_encoded() and hol_block_timer_qtime_val().

Rename aggr_time_limit_encoded() and hol_block_timer_qtime_val() so
their names are both verbs ending in "encode".  Rename the "limit"
argument to the former to be "milliseconds" for consistency.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 80 +++++++++++++++++++---------------
 1 file changed, 44 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index fe0eb882104ee..7d91b423a1be7 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -725,17 +725,42 @@ static u32 aggr_byte_limit_encoded(enum ipa_version version, u32 limit)
 	return u32_encode_bits(limit, aggr_byte_limit_fmask(false));
 }
 
+/* For IPA v4.5+, times are expressed using Qtime.  The AP uses one of two
+ * pulse generators (0 and 1) to measure elapsed time.  In ipa_qtime_config()
+ * they're configured to have granularity 100 usec and 1 msec, respectively.
+ *
+ * The return value is the positive or negative Qtime value to use to
+ * express the (microsecond) time provided.  A positive return value
+ * means pulse generator 0 can be used; otherwise use pulse generator 1.
+ */
+static int ipa_qtime_val(u32 microseconds, u32 max)
+{
+	u32 val;
+
+	/* Use 100 microsecond granularity if possible */
+	val = DIV_ROUND_CLOSEST(microseconds, 100);
+	if (val <= max)
+		return (int)val;
+
+	/* Have to use pulse generator 1 (millisecond granularity) */
+	val = DIV_ROUND_CLOSEST(microseconds, 1000);
+	WARN_ON(val > max);
+
+	return (int)-val;
+}
+
 /* Encode the aggregation timer limit (microseconds) based on IPA version */
-static u32 aggr_time_limit_encoded(enum ipa_version version, u32 limit)
+static u32 aggr_time_limit_encode(enum ipa_version version, u32 microseconds)
 {
 	u32 gran_sel;
 	u32 fmask;
 	u32 val;
+	int ret;
 
 	if (version < IPA_VERSION_4_5) {
 		/* We set aggregation granularity in ipa_hardware_config() */
 		fmask = aggr_time_limit_fmask(true);
-		val = DIV_ROUND_CLOSEST(limit, IPA_AGGR_GRANULARITY);
+		val = DIV_ROUND_CLOSEST(microseconds, IPA_AGGR_GRANULARITY);
 		WARN(val > field_max(fmask),
 		     "aggr_time_limit too large (%u > %u usec)\n",
 		     val, field_max(fmask) * IPA_AGGR_GRANULARITY);
@@ -743,23 +768,14 @@ static u32 aggr_time_limit_encoded(enum ipa_version version, u32 limit)
 		return u32_encode_bits(val, fmask);
 	}
 
-	/* IPA v4.5 expresses the time limit using Qtime.  The AP has
-	 * pulse generators 0 and 1 available, which were configured
-	 * in ipa_qtime_config() to have granularity 100 usec and
-	 * 1 msec, respectively.  Use pulse generator 0 if possible,
-	 * otherwise fall back to pulse generator 1.
-	 */
+	/* Compute the Qtime limit value to use */
 	fmask = aggr_time_limit_fmask(false);
-	val = DIV_ROUND_CLOSEST(limit, 100);
-	if (val > field_max(fmask)) {
-		/* Have to use pulse generator 1 (millisecond granularity) */
+	ret = ipa_qtime_val(microseconds, field_max(fmask));
+	if (ret < 0) {
+		val = -ret;
 		gran_sel = AGGR_GRAN_SEL_FMASK;
-		val = DIV_ROUND_CLOSEST(limit, 1000);
-		WARN(val > field_max(fmask),
-		     "aggr_time_limit too large (%u > %u usec)\n",
-		     limit, field_max(fmask) * 1000);
 	} else {
-		/* We can use pulse generator 0 (100 usec granularity) */
+		val = ret;
 		gran_sel = 0;
 	}
 
@@ -799,7 +815,7 @@ static void ipa_endpoint_init_aggr(struct ipa_endpoint *endpoint)
 			val |= aggr_byte_limit_encoded(version, limit);
 
 			limit = rx_config->aggr_time_limit;
-			val |= aggr_time_limit_encoded(version, limit);
+			val |= aggr_time_limit_encode(version, limit);
 
 			/* AGGR_PKT_LIMIT is 0 (unlimited) */
 
@@ -825,24 +841,18 @@ static void ipa_endpoint_init_aggr(struct ipa_endpoint *endpoint)
  * represents the given number of microseconds.  The result
  * includes both the timer value and the selected timer granularity.
  */
-static u32 hol_block_timer_qtime_val(struct ipa *ipa, u32 microseconds)
+static u32 hol_block_timer_qtime_encode(struct ipa *ipa, u32 microseconds)
 {
 	u32 gran_sel;
 	u32 val;
+	int ret;
 
-	/* IPA v4.5 expresses time limits using Qtime.  The AP has
-	 * pulse generators 0 and 1 available, which were configured
-	 * in ipa_qtime_config() to have granularity 100 usec and
-	 * 1 msec, respectively.  Use pulse generator 0 if possible,
-	 * otherwise fall back to pulse generator 1.
-	 */
-	val = DIV_ROUND_CLOSEST(microseconds, 100);
-	if (val > field_max(TIME_LIMIT_FMASK)) {
-		/* Have to use pulse generator 1 (millisecond granularity) */
+	ret = ipa_qtime_val(microseconds, field_max(TIME_LIMIT_FMASK));
+	if (ret < 0) {
+		val = -ret;
 		gran_sel = GRAN_SEL_FMASK;
-		val = DIV_ROUND_CLOSEST(microseconds, 1000);
 	} else {
-		/* We can use pulse generator 0 (100 usec granularity) */
+		val = ret;
 		gran_sel = 0;
 	}
 
@@ -854,12 +864,10 @@ static u32 hol_block_timer_qtime_val(struct ipa *ipa, u32 microseconds)
  * derived from the 19.2 MHz SoC XO clock.  For older IPA versions
  * each tick represents 128 cycles of the IPA core clock.
  *
- * Return the encoded value that should be written to that register
- * that represents the timeout period provided.  For IPA v4.2 this
- * encodes a base and scale value, while for earlier versions the
- * value is a simple tick count.
+ * Return the encoded value representing the timeout period provided
+ * that should be written to the ENDP_INIT_HOL_BLOCK_TIMER register.
  */
-static u32 hol_block_timer_val(struct ipa *ipa, u32 microseconds)
+static u32 hol_block_timer_encode(struct ipa *ipa, u32 microseconds)
 {
 	u32 width;
 	u32 scale;
@@ -872,7 +880,7 @@ static u32 hol_block_timer_val(struct ipa *ipa, u32 microseconds)
 		return 0;	/* Nothing to compute if timer period is 0 */
 
 	if (ipa->version >= IPA_VERSION_4_5)
-		return hol_block_timer_qtime_val(ipa, microseconds);
+		return hol_block_timer_qtime_encode(ipa, microseconds);
 
 	/* Use 64 bit arithmetic to avoid overflow... */
 	rate = ipa_core_clock_rate(ipa);
@@ -920,7 +928,7 @@ static void ipa_endpoint_init_hol_block_timer(struct ipa_endpoint *endpoint,
 
 	/* This should only be changed when HOL_BLOCK_EN is disabled */
 	offset = IPA_REG_ENDP_INIT_HOL_BLOCK_TIMER_N_OFFSET(endpoint_id);
-	val = hol_block_timer_val(ipa, microseconds);
+	val = hol_block_timer_encode(ipa, microseconds);
 	iowrite32(val, ipa->reg_virt + offset);
 }
 
-- 
2.34.1

