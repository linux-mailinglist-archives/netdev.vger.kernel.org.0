Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFAED61707C
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 23:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbiKBWMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 18:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbiKBWLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 18:11:55 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45C0BC32
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 15:11:49 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id h206so12755650iof.10
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 15:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VEI5E4A3vhqdvxEYC9B1ojiSJqRCvJ6S+f0LRwCXl84=;
        b=sJgJzXAqRNzN7lh5eguknfY6N9k8MNwIdJZU9RBg0YAZftpPvzdYy8wNCGktoNwnTD
         w8sQ7LkwHni0YBJXn80O/6SAfXlZkiGX4LGlaaYZScGTdQ18cxx3AtmyB1cm3ddt0e2E
         5iLlxoXHnT1XX6/vep5twV8gz0QJjjNqqLNvv3qbSwlsKrTZtNPs2PDCGxus0glIZjyP
         PEDTxiA2D5KesViHh/zHOTE3vNwVFGVKmOH6+n96jE9jHO83/zuUa9T3sGGBrEE78t6X
         e5ZyoN8sm0b6pFcUJvlGmx3syzJ5y7ptwO2Jwi4Y1y/WzZnalxVxe8R5T4nV278cWFmk
         9/KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VEI5E4A3vhqdvxEYC9B1ojiSJqRCvJ6S+f0LRwCXl84=;
        b=m4JwacQyGscYRckdMTf17lp14aptot+TRlqlVO+ZedCjNnUwRG2rhEOsrdNmcdVvpB
         QYxb9fu3jez5fk0+y5qKMPb74/gpCpmcW6yXzsmn+X9ZQuEcpRTy/4CfGfAcgtve1haQ
         T11MPl1r6dG+CxAGmLKcG/mcpKvba/zKr5fa7BgQ8fbEzwLao19Q3aBwZNtP/d+/Yq6g
         YqAdpeFmP7tcTy691w4fbMfj/XT2azVDjEdwqp45uoGLwoRajCkkOrMKdIS7xLLfaeri
         cYP0G+J7NQQ+Kaa4Ze+SWtxMKll8qgFLm+YFvebUTiT78oCnCiu4hwceIT0/UF9+GkBM
         JaBQ==
X-Gm-Message-State: ACrzQf0+N0RLGp7D2JAB+3NqS7twsZU7vhkih/mOsA9PxWp7QT+aG2S7
        3+2qlmuRLstoV/rUSzzm82USsA==
X-Google-Smtp-Source: AMsMyM7D+x4wCjCzeeM5blvV+k6kc5ELuf07VPWCoSp27l9OlIJjFiWktoD7vRTYmi9R48sGJcs58Q==
X-Received: by 2002:a05:6602:1495:b0:6d4:a262:aeff with SMTP id a21-20020a056602149500b006d4a262aeffmr3399533iow.35.1667427109455;
        Wed, 02 Nov 2022 15:11:49 -0700 (PDT)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id f8-20020a02a108000000b0037465a1dd3fsm5073974jag.156.2022.11.02.15.11.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 15:11:49 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 5/9] net: ipa: use a bitmap for defined endpoints
Date:   Wed,  2 Nov 2022 17:11:35 -0500
Message-Id: <20221102221139.1091510-6-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221102221139.1091510-1-elder@linaro.org>
References: <20221102221139.1091510-1-elder@linaro.org>
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

IPA v5.0 supports more than 32 endpoints, so we will be unable to
represent endpoints defined in the configuration data with a 32-bit
value.  To prepare for that, convert the field in the IPA structure
representing defined endpoints to be a Linux bitmap.

Convert loops based on that field into for_each_set_bit() calls over
the new bitmap.  Note that the loop in ipa_endpoint_config() still
assumes there are 32 or fewer endpoints (when comparing against the
available endpoint bit mask); that assumption goes away in the next
patch.

Signed-off-by: Alex Elder <elder@linaro.org>
---
v2: - Don't print a message on bitmap allocation error

 drivers/net/ipa/ipa.h          |  6 ++---
 drivers/net/ipa/ipa_endpoint.c | 46 +++++++++++++---------------------
 2 files changed, 21 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ipa/ipa.h b/drivers/net/ipa/ipa.h
index a44595575d066..261c7263f9e31 100644
--- a/drivers/net/ipa/ipa.h
+++ b/drivers/net/ipa/ipa.h
@@ -62,7 +62,7 @@ struct ipa_interrupt;
  * @zero_virt:		Virtual address of preallocated zero-filled memory
  * @zero_size:		Size (bytes) of preallocated zero-filled memory
  * @endpoint_count:	Number of endpoints represented by bit masks below
- * @defined:		Bit mask indicating endpoints defined in config data
+ * @defined:		Bitmap of endpoints defined in config data
  * @available:		Bit mask indicating endpoints hardware supports
  * @filter_map:		Bit mask indicating endpoints that support filtering
  * @set_up:		Bit mask indicating endpoints set up
@@ -117,9 +117,9 @@ struct ipa {
 	void *zero_virt;
 	size_t zero_size;
 
-	/* Bit masks indicating endpoint state */
+	/* Bitmaps indicating endpoint state */
 	u32 endpoint_count;
-	u32 defined;			/* Defined in configuration data */
+	unsigned long *defined;		/* Defined in configuration data */
 	u32 available;			/* Supported by hardware */
 	u32 filter_map;
 	u32 set_up;
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 32559ed498c19..abc939c272b5a 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -459,8 +459,8 @@ void ipa_endpoint_modem_pause_all(struct ipa *ipa, bool enable)
 /* Reset all modem endpoints to use the default exception endpoint */
 int ipa_endpoint_modem_exception_reset_all(struct ipa *ipa)
 {
-	u32 defined = ipa->defined;
 	struct gsi_trans *trans;
+	u32 endpoint_id;
 	u32 count;
 
 	/* We need one command per modem TX endpoint, plus the commands
@@ -474,14 +474,11 @@ int ipa_endpoint_modem_exception_reset_all(struct ipa *ipa)
 		return -EBUSY;
 	}
 
-	while (defined) {
-		u32 endpoint_id = __ffs(defined);
+	for_each_set_bit(endpoint_id, ipa->defined, ipa->endpoint_count) {
 		struct ipa_endpoint *endpoint;
 		const struct ipa_reg *reg;
 		u32 offset;
 
-		defined ^= BIT(endpoint_id);
-
 		/* We only reset modem TX endpoints */
 		endpoint = &ipa->endpoint[endpoint_id];
 		if (!(endpoint->ee_id == GSI_EE_MODEM && endpoint->toward_ipa))
@@ -1823,16 +1820,11 @@ static void ipa_endpoint_teardown_one(struct ipa_endpoint *endpoint)
 
 void ipa_endpoint_setup(struct ipa *ipa)
 {
-	u32 defined = ipa->defined;
+	u32 endpoint_id;
 
 	ipa->set_up = 0;
-	while (defined) {
-		u32 endpoint_id = __ffs(defined);
-
-		defined ^= BIT(endpoint_id);
-
+	for_each_set_bit(endpoint_id, ipa->defined, ipa->endpoint_count)
 		ipa_endpoint_setup_one(&ipa->endpoint[endpoint_id]);
-	}
 }
 
 void ipa_endpoint_teardown(struct ipa *ipa)
@@ -1853,10 +1845,10 @@ int ipa_endpoint_config(struct ipa *ipa)
 {
 	struct device *dev = &ipa->pdev->dev;
 	const struct ipa_reg *reg;
+	u32 endpoint_id;
 	u32 tx_count;
 	u32 rx_count;
 	u32 rx_base;
-	u32 defined;
 	u32 limit;
 	u32 val;
 
@@ -1896,13 +1888,9 @@ int ipa_endpoint_config(struct ipa *ipa)
 	/* Mark all supported RX and TX endpoints as available */
 	ipa->available = GENMASK(limit - 1, rx_base) | GENMASK(tx_count - 1, 0);
 
-	defined = ipa->defined;
-	while (defined) {
-		u32 endpoint_id = __ffs(defined);
+	for_each_set_bit(endpoint_id, ipa->defined, ipa->endpoint_count) {
 		struct ipa_endpoint *endpoint;
 
-		defined ^= BIT(endpoint_id);
-
 		if (endpoint_id >= limit) {
 			dev_err(dev, "invalid endpoint id, %u > %u\n",
 				endpoint_id, limit - 1);
@@ -1954,27 +1942,26 @@ static void ipa_endpoint_init_one(struct ipa *ipa, enum ipa_endpoint_name name,
 	endpoint->toward_ipa = data->toward_ipa;
 	endpoint->config = data->endpoint.config;
 
-	ipa->defined |= BIT(endpoint->endpoint_id);
+	__set_bit(endpoint->endpoint_id, ipa->defined);
 }
 
 static void ipa_endpoint_exit_one(struct ipa_endpoint *endpoint)
 {
-	endpoint->ipa->defined &= ~BIT(endpoint->endpoint_id);
+	__clear_bit(endpoint->endpoint_id, endpoint->ipa->defined);
 
 	memset(endpoint, 0, sizeof(*endpoint));
 }
 
 void ipa_endpoint_exit(struct ipa *ipa)
 {
-	u32 defined = ipa->defined;
-
-	while (defined) {
-		u32 endpoint_id = __fls(defined);
-
-		defined ^= BIT(endpoint_id);
+	u32 endpoint_id;
 
+	for_each_set_bit(endpoint_id, ipa->defined, ipa->endpoint_count)
 		ipa_endpoint_exit_one(&ipa->endpoint[endpoint_id]);
-	}
+
+	bitmap_free(ipa->defined);
+	ipa->defined = NULL;
+
 	memset(ipa->name_map, 0, sizeof(ipa->name_map));
 	memset(ipa->channel_map, 0, sizeof(ipa->channel_map));
 }
@@ -1993,7 +1980,10 @@ u32 ipa_endpoint_init(struct ipa *ipa, u32 count,
 	if (!ipa->endpoint_count)
 		return 0;	/* Error */
 
-	ipa->defined = 0;
+	/* Initialize the defined endpoint bitmap */
+	ipa->defined = bitmap_zalloc(ipa->endpoint_count, GFP_KERNEL);
+	if (!ipa->defined)
+		return 0;	/* Error */
 
 	filter_map = 0;
 	for (name = 0; name < count; name++, data++) {
-- 
2.34.1

