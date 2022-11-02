Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB600617076
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 23:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbiKBWMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 18:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231497AbiKBWLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 18:11:55 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF40663DC
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 15:11:51 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id z9so161504ilu.10
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 15:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=awvIszSlBYbQTFNtVRRr363ktjZrC0gWJbbrDOYC/aw=;
        b=lebLyog2wztMpEEot55TP04NnKX9SjVNcWNDniFxJiAhXNDUBG7PZtVGfrjk778O8X
         xJOVjjZ72UBD6RXLHTBI2wD/A4CDaEH/TaGFrmBvlaNVB99bUcU/5kmDICdH3kI9P3jj
         C81M2wiDcc4ScK75rxHEGG7nk+Aw44LWcjC7PmdL1Wi4e5Px8siVV1FxytzI4/Ac+d5L
         psS0FXtpoSSYingR6m+H5itkBrsTHOVjXYYyLpnAc2b+4E2am8mcfkCkiiYcwnYC2HSd
         P5edIo/IpJpOPq7nhlXIjBIFr5HkF2gDPEdizYYQSg3HkEPlzbXeVKJZHdZuLw7U0KPS
         OOZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=awvIszSlBYbQTFNtVRRr363ktjZrC0gWJbbrDOYC/aw=;
        b=Ld65KEgm4J5nF82p6LEU61p3nqf/2JHfPqGeTif68LwV7efzfIJAk9YqX2Uxt5hYMy
         xKvyDnGDyEtUYXFa9+z+/yKZzNXoSgy310L/XHSMe11Cn0Hk0oIWDe/8nexe0EUH5P1Z
         57g2q23W79kJJrWkouzFbuuqhh8iUDZ7hsxo98FPvdTOPKeklqblrMv/0SCYFX1KoqPK
         B2XtgAjq/LuLKcyw2G+IvDP7Art9ND+czxsXcPyma7gu5d06rbWue6Ue/GdKR2/geYR/
         XwAnBpJYmy2dl8buNTWKAYguG+IPmx7xG9Ws3fk2zxlCa9R8FLi6O3VA3P47RLF30dGZ
         qjMw==
X-Gm-Message-State: ACrzQf0fItTDPGqe7tH+BFW/XpBUaTMZcKP18P9wlt/pr9F9k1N4tzvt
        aQ8MaS8fk142FjasmofXnegVBw==
X-Google-Smtp-Source: AMsMyM4Z3094/M2GJ8V7ebv6UBJRpF/VBtgWWeNwfEpC15G2vSCq7cMYjjUoq+lmDuIVgi+t+RlX9g==
X-Received: by 2002:a05:6e02:d04:b0:300:8716:e7b1 with SMTP id g4-20020a056e020d0400b003008716e7b1mr16448650ilj.231.1667427110619;
        Wed, 02 Nov 2022 15:11:50 -0700 (PDT)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id f8-20020a02a108000000b0037465a1dd3fsm5073974jag.156.2022.11.02.15.11.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 15:11:50 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 6/9] net: ipa: use a bitmap for available endpoints
Date:   Wed,  2 Nov 2022 17:11:36 -0500
Message-Id: <20221102221139.1091510-7-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221102221139.1091510-1-elder@linaro.org>
References: <20221102221139.1091510-1-elder@linaro.org>
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

Similar to the previous patch, replace the 32-bit unsigned used to
track endpoints supported by hardware with a Linux bitmap, to allow
an arbitrary number of endpoints to be represented.

Move ipa_endpoint_deconfig() above ipa_endpoint_config() and use
it in the error path of the latter function.

Signed-off-by: Alex Elder <elder@linaro.org>
---
v2: - Use ipa_endpoint_deconfig() in ipa_endpoint_config() cleanup

 drivers/net/ipa/ipa.h           |  8 ++++--
 drivers/net/ipa/ipa_endpoint.c  | 49 ++++++++++++++++++++++-----------
 drivers/net/ipa/ipa_interrupt.c |  8 ++++--
 3 files changed, 43 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ipa/ipa.h b/drivers/net/ipa/ipa.h
index 261c7263f9e31..c603575e2a58b 100644
--- a/drivers/net/ipa/ipa.h
+++ b/drivers/net/ipa/ipa.h
@@ -61,9 +61,10 @@ struct ipa_interrupt;
  * @zero_addr:		DMA address of preallocated zero-filled memory
  * @zero_virt:		Virtual address of preallocated zero-filled memory
  * @zero_size:		Size (bytes) of preallocated zero-filled memory
- * @endpoint_count:	Number of endpoints represented by bit masks below
+ * @endpoint_count:	Number of defined bits in most bitmaps below
+ * @available_count:	Number of defined bits in the available bitmap
  * @defined:		Bitmap of endpoints defined in config data
- * @available:		Bit mask indicating endpoints hardware supports
+ * @available:		Bitmap of endpoints supported by hardware
  * @filter_map:		Bit mask indicating endpoints that support filtering
  * @set_up:		Bit mask indicating endpoints set up
  * @enabled:		Bit mask indicating endpoints enabled
@@ -119,8 +120,9 @@ struct ipa {
 
 	/* Bitmaps indicating endpoint state */
 	u32 endpoint_count;
+	u32 available_count;
 	unsigned long *defined;		/* Defined in configuration data */
-	u32 available;			/* Supported by hardware */
+	unsigned long *available;	/* Supported by hardware */
 	u32 filter_map;
 	u32 set_up;
 	u32 enabled;
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index abc939c272b5a..a7932e8d0b2bf 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -351,19 +351,17 @@ ipa_endpoint_program_delay(struct ipa_endpoint *endpoint, bool enable)
 static bool ipa_endpoint_aggr_active(struct ipa_endpoint *endpoint)
 {
 	u32 endpoint_id = endpoint->endpoint_id;
-	u32 mask = BIT(endpoint_id % 32);
 	struct ipa *ipa = endpoint->ipa;
 	u32 unit = endpoint_id / 32;
 	const struct ipa_reg *reg;
 	u32 val;
 
-	/* This works until we actually have more than 32 endpoints */
-	WARN_ON(!(mask & ipa->available));
+	WARN_ON(!test_bit(endpoint_id, ipa->available));
 
 	reg = ipa_reg(ipa, STATE_AGGR_ACTIVE);
 	val = ioread32(ipa->reg_virt + ipa_reg_n_offset(reg, unit));
 
-	return !!(val & mask);
+	return !!(val & BIT(endpoint_id % 32));
 }
 
 static void ipa_endpoint_force_close(struct ipa_endpoint *endpoint)
@@ -374,8 +372,7 @@ static void ipa_endpoint_force_close(struct ipa_endpoint *endpoint)
 	u32 unit = endpoint_id / 32;
 	const struct ipa_reg *reg;
 
-	/* This works until we actually have more than 32 endpoints */
-	WARN_ON(!(mask & ipa->available));
+	WARN_ON(!test_bit(endpoint_id, ipa->available));
 
 	reg = ipa_reg(ipa, AGGR_FORCE_CLOSE);
 	iowrite32(mask, ipa->reg_virt + ipa_reg_n_offset(reg, unit));
@@ -1841,6 +1838,13 @@ void ipa_endpoint_teardown(struct ipa *ipa)
 	ipa->set_up = 0;
 }
 
+void ipa_endpoint_deconfig(struct ipa *ipa)
+{
+	ipa->available_count = 0;
+	bitmap_free(ipa->available);
+	ipa->available = NULL;
+}
+
 int ipa_endpoint_config(struct ipa *ipa)
 {
 	struct device *dev = &ipa->pdev->dev;
@@ -1863,7 +1867,13 @@ int ipa_endpoint_config(struct ipa *ipa)
 	 * assume the configuration is valid.
 	 */
 	if (ipa->version < IPA_VERSION_3_5) {
-		ipa->available = ~0;
+		ipa->available = bitmap_zalloc(IPA_ENDPOINT_MAX, GFP_KERNEL);
+		if (!ipa->available)
+			return -ENOMEM;
+		ipa->available_count = IPA_ENDPOINT_MAX;
+
+		bitmap_set(ipa->available, 0, IPA_ENDPOINT_MAX);
+
 		return 0;
 	}
 
@@ -1885,8 +1895,15 @@ int ipa_endpoint_config(struct ipa *ipa)
 		return -EINVAL;
 	}
 
+	/* Allocate and initialize the available endpoint bitmap */
+	ipa->available = bitmap_zalloc(limit, GFP_KERNEL);
+	if (!ipa->available)
+		return -ENOMEM;
+	ipa->available_count = limit;
+
 	/* Mark all supported RX and TX endpoints as available */
-	ipa->available = GENMASK(limit - 1, rx_base) | GENMASK(tx_count - 1, 0);
+	bitmap_set(ipa->available, 0, tx_count);
+	bitmap_set(ipa->available, rx_base, rx_count);
 
 	for_each_set_bit(endpoint_id, ipa->defined, ipa->endpoint_count) {
 		struct ipa_endpoint *endpoint;
@@ -1894,13 +1911,13 @@ int ipa_endpoint_config(struct ipa *ipa)
 		if (endpoint_id >= limit) {
 			dev_err(dev, "invalid endpoint id, %u > %u\n",
 				endpoint_id, limit - 1);
-			return -EINVAL;
+			goto err_free_bitmap;
 		}
 
-		if (!(BIT(endpoint_id) & ipa->available)) {
+		if (!test_bit(endpoint_id, ipa->available)) {
 			dev_err(dev, "unavailable endpoint id %u\n",
 				endpoint_id);
-			return -EINVAL;
+			goto err_free_bitmap;
 		}
 
 		/* Make sure it's pointing in the right direction */
@@ -1913,15 +1930,15 @@ int ipa_endpoint_config(struct ipa *ipa)
 		}
 
 		dev_err(dev, "endpoint id %u wrong direction\n", endpoint_id);
-		return -EINVAL;
+		goto err_free_bitmap;
 	}
 
 	return 0;
-}
 
-void ipa_endpoint_deconfig(struct ipa *ipa)
-{
-	ipa->available = 0;	/* Nothing more to do */
+err_free_bitmap:
+	ipa_endpoint_deconfig(ipa);
+
+	return -EINVAL;
 }
 
 static void ipa_endpoint_init_one(struct ipa *ipa, enum ipa_endpoint_name name,
diff --git a/drivers/net/ipa/ipa_interrupt.c b/drivers/net/ipa/ipa_interrupt.c
index a62bc667bda0e..a49f66efacb87 100644
--- a/drivers/net/ipa/ipa_interrupt.c
+++ b/drivers/net/ipa/ipa_interrupt.c
@@ -132,14 +132,13 @@ static void ipa_interrupt_suspend_control(struct ipa_interrupt *interrupt,
 					  u32 endpoint_id, bool enable)
 {
 	struct ipa *ipa = interrupt->ipa;
-	u32 mask = BIT(endpoint_id % 32);
 	u32 unit = endpoint_id / 32;
 	const struct ipa_reg *reg;
 	u32 offset;
+	u32 mask;
 	u32 val;
 
-	/* This works until we actually have more than 32 endpoints */
-	WARN_ON(!(mask & ipa->available));
+	WARN_ON(!test_bit(endpoint_id, ipa->available));
 
 	/* IPA version 3.0 does not support TX_SUSPEND interrupt control */
 	if (ipa->version == IPA_VERSION_3_0)
@@ -148,10 +147,13 @@ static void ipa_interrupt_suspend_control(struct ipa_interrupt *interrupt,
 	reg = ipa_reg(ipa, IRQ_SUSPEND_EN);
 	offset = ipa_reg_n_offset(reg, unit);
 	val = ioread32(ipa->reg_virt + offset);
+
+	mask = BIT(endpoint_id);
 	if (enable)
 		val |= mask;
 	else
 		val &= ~mask;
+
 	iowrite32(val, ipa->reg_virt + offset);
 }
 
-- 
2.34.1

