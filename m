Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C39E26126AA
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 02:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbiJ3ATJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 20:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbiJ3ASt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 20:18:49 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA704363F
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 17:18:47 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id p184so7364110iof.11
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 17:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lk3pnPj9yt9t91KAvzsXB5y55ZuWPJLZLwDcUNTFozw=;
        b=dfJAjEjOKaMWvJQAhG9FkquaM+/gFfJ8lFxaU5DP/wGG8THdDVUZDLBDCpHS0/eOuP
         nvmVVwABhf9vIWdiiF0tM8KcJQUlTV/np8Yn1lT2CICzOCfvowO4xkBBIWmqdJ+lSd3m
         6/ruvJahVNZvwp0FfHUtHHjRCjPu2IluiebekKaSy+WNUbZ9xhoMGxMEzci6gI6b7BHE
         Ldbmrkk1kVuWQEkv91HsMChlRqfIDUyChimWcWrZK2nsWsXdstWxoVofxc0CNhmBpyTv
         oAuPi0jUUeAezOsSLtp84umLwHx3EgcuZ0cSjpB8SFy7SlWBzJUBvNvOSPsvWsKva5ZF
         1RjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lk3pnPj9yt9t91KAvzsXB5y55ZuWPJLZLwDcUNTFozw=;
        b=p4xnFnuw73pVgNvVCtSnCLOZsepvYf+yQHUC99ZxNcFk6etPdi2AHPF4iIJbyeqhwK
         JHa+t9LnAq5s6ZWD6ESiSt7d8Fh113bGkkezHpZ27TfRx0eVp0qySsKbfb3OKn0fqyfW
         yCWn19nR/Xuhv9r6YmErJDZFo86VjJUmp/osYQ+uNBiOnDmvEs2PUoVYGBKGn6KRT3RL
         H/4cY34h/XyIoHM86lT8bCa3gKfvvWmlEoT0zmDjLZ7Yd6cLW6zwshLnAJfTLFCpldaK
         Axcu+bOX6azWPwpYzagncOmbjawhiLCb6aCQA+z7OGCh/98InPfGGILO/VPMzUUSBvto
         9X+A==
X-Gm-Message-State: ACrzQf2thGK8GacoOI6jKXSTKsF477ha7R/qC2gExv5TJ3vrNs3pwhwt
        K37oltYxSmqQdHaHEz011RlUdg==
X-Google-Smtp-Source: AMsMyM6pKOO2LZSwxRvFzTKWQrnSxFDtSsPBbehdKiBWkltRcPp+9U74Dd0nN4/o4TSBeXNyTF3rBQ==
X-Received: by 2002:a05:6638:2605:b0:363:a059:36bd with SMTP id m5-20020a056638260500b00363a05936bdmr3535592jat.267.1667089126738;
        Sat, 29 Oct 2022 17:18:46 -0700 (PDT)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id co20-20020a0566383e1400b00375126ae55fsm1087519jab.58.2022.10.29.17.18.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 17:18:46 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/9] net: ipa: use a bitmap for available endpoints
Date:   Sat, 29 Oct 2022 19:18:25 -0500
Message-Id: <20221030001828.754010-7-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221030001828.754010-1-elder@linaro.org>
References: <20221030001828.754010-1-elder@linaro.org>
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

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa.h           |  8 +++---
 drivers/net/ipa/ipa_endpoint.c  | 44 +++++++++++++++++++++++----------
 drivers/net/ipa/ipa_interrupt.c |  8 +++---
 3 files changed, 41 insertions(+), 19 deletions(-)

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
index 56908ee097cf6..8d4cb2c30ec90 100644
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
@@ -1863,7 +1860,13 @@ int ipa_endpoint_config(struct ipa *ipa)
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
 
@@ -1885,8 +1888,15 @@ int ipa_endpoint_config(struct ipa *ipa)
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
@@ -1894,13 +1904,13 @@ int ipa_endpoint_config(struct ipa *ipa)
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
@@ -1913,15 +1923,23 @@ int ipa_endpoint_config(struct ipa *ipa)
 		}
 
 		dev_err(dev, "endpoint id %u wrong direction\n", endpoint_id);
-		return -EINVAL;
+		goto err_free_bitmap;
 	}
 
 	return 0;
+
+err_free_bitmap:
+	bitmap_free(ipa->available);
+	ipa->available = NULL;
+
+	return -EINVAL;
 }
 
 void ipa_endpoint_deconfig(struct ipa *ipa)
 {
-	ipa->available = 0;	/* Nothing more to do */
+	ipa->available_count = 0;
+	bitmap_free(ipa->available);
+	ipa->available = NULL;
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

