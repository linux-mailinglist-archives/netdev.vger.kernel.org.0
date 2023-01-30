Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B36D681C3C
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 22:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbjA3VEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 16:04:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbjA3VEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 16:04:10 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D342447EC6
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 13:03:58 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id r6so2465096ioj.5
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 13:03:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4fo8/oJYkHVkmTqER82lUxzE/JMQrzARbb9xB0zqsC4=;
        b=ZbVl4Huwv8a6Zl2VEXke70GYO1eY33pZPkG/bA4G7/Iv3IqfDqHRGSiANdo2bpMhxv
         sx5GrHGw0Tk4MGQM3l5QPcVtJypYZyRCcrLw7o6D+zRdH2AMvZfZiilvJ7OVt4FaB7Op
         yzF75UFbSmEjzDZiCmrkq44JxPqqt3UWYVLVC9OigmvPodboT/g2QGRpf4L5RBzr9if9
         ztebkPLSbkTSWCYRXUeVMtY5S7Q90OYESSlDNhu8IqKLExaEboNYUIiD7Rlpsr3AgYCn
         OcMGqD+3NGXv6TEJYLPTFEpkXglFr+o3W5PkqY706b9ZwfK4xGioSYib4zpIrt5olBsu
         qD2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4fo8/oJYkHVkmTqER82lUxzE/JMQrzARbb9xB0zqsC4=;
        b=OmYlcMYNdKQD1FsTT4qJD72q4nq35O25ePOgJO1DDA1PNYdmC1Y2Y8u7OiZi3OddOC
         5cJE690HXycLZN81aKQetvpofNYM4XAcPGoYj2kQWkfiDyFymViRLj4fjaHvgKswFJ9U
         lSI+jY7vzWniN2dSsF6FI+BsJVt79Yk8xkjM5PlFg7bwvMeMQNU3t1x5+khAaGUOxRqi
         EyaqJZraxq8dGnHydSXh4leOsYNnEE7kFZwvmp24U7DkPHCYNiUMFkk9gBJdbfWh85uc
         NJyXAmhqsmzlbOnlfGSkkec4hyh/UiWTMQLH9BpHgXlBIrpri3+B1bNKz76U+TZq7jWV
         s3IA==
X-Gm-Message-State: AO0yUKUzFGUsVrW3JRtQmZgq5Kue2XRqe8YujbjFe7ZKM/3jHi17UnRi
        zNM4yylGBEU+XRtgVVFyHDc6BQ==
X-Google-Smtp-Source: AK7set8Vrfpwm5KZwHFRRr9R1zxO0mONaZuyf9XhHh+OIdVb5ANOo5qd87I7/XTBfMvltZbzxiHDEg==
X-Received: by 2002:a6b:1492:0:b0:716:b6e1:7d39 with SMTP id 140-20020a6b1492000000b00716b6e17d39mr6996892iou.5.1675112638443;
        Mon, 30 Jan 2023 13:03:58 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id a30-20020a02735e000000b003aef8fded9asm1992046jae.127.2023.01.30.13.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 13:03:56 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 7/8] net: ipa: support a third pulse register
Date:   Mon, 30 Jan 2023 15:01:57 -0600
Message-Id: <20230130210158.4126129-8-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230130210158.4126129-1-elder@linaro.org>
References: <20230130210158.4126129-1-elder@linaro.org>
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

The AP has third pulse generator available starting with IPA v5.0.
Redefine ipa_qtime_val() to support that possibility.  Pass the IPA
pointer as an argument so the version can be determined.  And stop
using the sign of the returned tick count to indicate which of two
pulse generators to use.

Instead, have the caller provide the address of a variable that will
hold the selected pulse generator for the Qtime value.  And for
version 5.0, check whether the third pulse generator best represents
the time period.

Add code in ipa_qtime_config() to configure the fourth pulse
generator for IPA v5.0+; in that case configure both the third and
fourth pulse generators to use 10 msec granularity.

Consistently use "ticks" for local variables that represent a tick
count.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 91 +++++++++++++++++-----------------
 drivers/net/ipa/ipa_main.c     |  7 ++-
 2 files changed, 52 insertions(+), 46 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index c029209191d41..798dfa4484d5a 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -922,64 +922,72 @@ static void ipa_endpoint_init_mode(struct ipa_endpoint *endpoint)
 	iowrite32(val, ipa->reg_virt + offset);
 }
 
-/* For IPA v4.5+, times are expressed using Qtime.  The AP uses one of two
- * pulse generators (0 and 1) to measure elapsed time.  In ipa_qtime_config()
- * they're configured to have granularity 100 usec and 1 msec, respectively.
- *
- * The return value is the positive or negative Qtime value to use to
- * express the (microsecond) time provided.  A positive return value
- * means pulse generator 0 can be used; otherwise use pulse generator 1.
+/* For IPA v4.5+, times are expressed using Qtime.  A time is represented
+ * at one of several available granularities, which are configured in
+ * ipa_qtime_config().  Three (or, starting with IPA v5.0, four) pulse
+ * generators are set up with different "tick" periods.  A Qtime value
+ * encodes a tick count along with an indication of a pulse generator
+ * (which has a fixed tick period).  Two pulse generators are always
+ * available to the AP; a third is available starting with IPA v5.0.
+ * This function determines which pulse generator most accurately
+ * represents the time period provided, and returns the tick count to
+ * use to represent that time.
  */
-static int ipa_qtime_val(u32 microseconds, u32 max)
+static u32
+ipa_qtime_val(struct ipa *ipa, u32 microseconds, u32 max, u32 *select)
 {
-	u32 val;
+	u32 which = 0;
+	u32 ticks;
 
-	/* Use 100 microsecond granularity if possible */
-	val = DIV_ROUND_CLOSEST(microseconds, 100);
-	if (val <= max)
-		return (int)val;
+	/* Pulse generator 0 has 100 microsecond granularity */
+	ticks = DIV_ROUND_CLOSEST(microseconds, 100);
+	if (ticks <= max)
+		goto out;
 
-	/* Have to use pulse generator 1 (millisecond granularity) */
-	val = DIV_ROUND_CLOSEST(microseconds, 1000);
-	WARN_ON(val > max);
+	/* Pulse generator 1 has millisecond granularity */
+	which = 1;
+	ticks = DIV_ROUND_CLOSEST(microseconds, 1000);
+	if (ticks <= max)
+		goto out;
 
-	return (int)-val;
+	if (ipa->version >= IPA_VERSION_5_0) {
+		/* Pulse generator 2 has 10 millisecond granularity */
+		which = 2;
+		ticks = DIV_ROUND_CLOSEST(microseconds, 100);
+	}
+	WARN_ON(ticks > max);
+out:
+	*select = which;
+
+	return ticks;
 }
 
 /* Encode the aggregation timer limit (microseconds) based on IPA version */
 static u32 aggr_time_limit_encode(struct ipa *ipa, const struct ipa_reg *reg,
 				  u32 microseconds)
 {
+	u32 ticks;
 	u32 max;
-	u32 val;
 
 	if (!microseconds)
 		return 0;	/* Nothing to compute if time limit is 0 */
 
 	max = ipa_reg_field_max(reg, TIME_LIMIT);
 	if (ipa->version >= IPA_VERSION_4_5) {
-		u32 gran_sel;
-		int ret;
+		u32 select;
 
-		/* Compute the Qtime limit value to use */
-		ret = ipa_qtime_val(microseconds, max);
-		if (ret < 0) {
-			val = -ret;
-			gran_sel = ipa_reg_encode(reg, AGGR_GRAN_SEL, 1);
-		} else {
-			val = ret;
-			gran_sel = 0;
-		}
+		ticks = ipa_qtime_val(ipa, microseconds, max, &select);
 
-		return gran_sel | ipa_reg_encode(reg, TIME_LIMIT, val);
+		return ipa_reg_encode(reg, AGGR_GRAN_SEL, select) |
+		       ipa_reg_encode(reg, TIME_LIMIT, ticks);
 	}
 
 	/* We program aggregation granularity in ipa_hardware_config() */
-	val = DIV_ROUND_CLOSEST(microseconds, IPA_AGGR_GRANULARITY);
-	WARN(val > max, "aggr_time_limit too large (%u > %u usec)\n",
+	ticks = DIV_ROUND_CLOSEST(microseconds, IPA_AGGR_GRANULARITY);
+	WARN(ticks > max, "aggr_time_limit too large (%u > %u usec)\n",
 	     microseconds, max * IPA_AGGR_GRANULARITY);
 
-	return ipa_reg_encode(reg, TIME_LIMIT, val);
+	return ipa_reg_encode(reg, TIME_LIMIT, ticks);
 }
 
 static void ipa_endpoint_init_aggr(struct ipa_endpoint *endpoint)
@@ -1050,20 +1058,13 @@ static u32 hol_block_timer_encode(struct ipa *ipa, const struct ipa_reg *reg,
 
 	if (ipa->version >= IPA_VERSION_4_5) {
 		u32 max = ipa_reg_field_max(reg, TIMER_LIMIT);
-		u32 gran_sel;
-		int ret;
+		u32 select;
+		u32 ticks;
 
-		/* Compute the Qtime limit value to use */
-		ret = ipa_qtime_val(microseconds, max);
-		if (ret < 0) {
-			val = -ret;
-			gran_sel = ipa_reg_encode(reg, TIMER_GRAN_SEL, 1);
-		} else {
-			val = ret;
-			gran_sel = 0;
-		}
+		ticks = ipa_qtime_val(ipa, microseconds, max, &select);
 
-		return gran_sel | ipa_reg_encode(reg, TIMER_LIMIT, val);
+		return ipa_reg_encode(reg, TIMER_GRAN_SEL, 1) |
+		       ipa_reg_encode(reg, TIMER_LIMIT, ticks);
 	}
 
 	/* Use 64 bit arithmetic to avoid overflow */
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index f3466b913394c..60d7c558163f1 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -390,7 +390,12 @@ static void ipa_qtime_config(struct ipa *ipa)
 	reg = ipa_reg(ipa, TIMERS_PULSE_GRAN_CFG);
 	val = ipa_reg_encode(reg, PULSE_GRAN_0, IPA_GRAN_100_US);
 	val |= ipa_reg_encode(reg, PULSE_GRAN_1, IPA_GRAN_1_MS);
-	val |= ipa_reg_encode(reg, PULSE_GRAN_2, IPA_GRAN_1_MS);
+	if (ipa->version >= IPA_VERSION_5_0) {
+		val |= ipa_reg_encode(reg, PULSE_GRAN_2, IPA_GRAN_10_MS);
+		val |= ipa_reg_encode(reg, PULSE_GRAN_3, IPA_GRAN_10_MS);
+	} else {
+		val |= ipa_reg_encode(reg, PULSE_GRAN_2, IPA_GRAN_1_MS);
+	}
 
 	iowrite32(val, ipa->reg_virt + ipa_reg_offset(reg));
 
-- 
2.34.1

