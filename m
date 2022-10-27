Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE6460F730
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 14:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235642AbiJ0M1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 08:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235509AbiJ0M0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 08:26:48 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E8A144E39
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 05:26:46 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id 63so1254449iov.8
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 05:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=epeLvt8lBCaZ5l7avoF50kT1TtYCZEpBvcBKlNT2iwg=;
        b=ASZTBTVg0XueoY1mvGbHkTi9Ugs5LisP/oDcEfaQOmPS1HYaqq9S6/676ekGpiR3vC
         UGmIy2WKb2YUQPBdPfh4H/TZsoRvP8FO3XsAIPgrc3wzmtxeKeIXKrSfzN/I4HztApCU
         pGuLaS4tJlPkem/X7itLVokqzg+g9nvzSj5yFXYu6Sf1r1j45Eepd+hfbhyFxPAYt+YP
         WuhnKJ/6SvlDpfivLdVOzukQ294KArdt7oeMW7jQCG9Qmuz/SiUhdODIUm8it+oDHlmg
         DeW59JdtbrEHqowOpFKFDfgXZzRi29ncMWVW7Q9L6XJQvSGUhLxkjTZf1krqzaDKOvJw
         Yl9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=epeLvt8lBCaZ5l7avoF50kT1TtYCZEpBvcBKlNT2iwg=;
        b=buoC60nY6IMdqmNfyB+Y2JnL+aKtUNmeS4oD2lYZhlO+9bOBS1muw2+08g4f9x3iEW
         xPxFGH4KOhLgPkPcaLLNST96MD2dVA3XWl3Iws2w0kqhJVo/OAY1XiBUOzb/uYvu/tOk
         akQtEjMjaTZZ2imRRer8LZ1GBE863jRkkg4dEYTINr7ZSBR7zAe6sK9VL7eqiixz/fO+
         hfza2IyM/CMR4Zhuk4uoEdLnr4/5619VqSB/CEJKPbswCUNNSIJBmKhflEtQydIoZ/JP
         nN5BdHrp9H9tGderAC9BPapIh8ZHgvKX7glm78jf2yKoSKcHrqIEhJh4vpwArkA4hpt+
         6wAA==
X-Gm-Message-State: ACrzQf3J7JxXTv7jS2/v9ChZv7wP3HeeQ3ZECBckbEbJM9DBqheRuKGr
        aVauy0tnugzIFS2soW9Cc3lIVg==
X-Google-Smtp-Source: AMsMyM6ni5QhUhys+hLhqfkIp7C+QW9+qOAkWkXOowfVcKCznQjFWQgqgckN5rrzBZOwgl6zplX0ww==
X-Received: by 2002:a02:2242:0:b0:375:29b5:b885 with SMTP id o63-20020a022242000000b0037529b5b885mr935862jao.162.1666873605571;
        Thu, 27 Oct 2022 05:26:45 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id w24-20020a05663800d800b003566ff0eb13sm526528jao.34.2022.10.27.05.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 05:26:44 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/7] net: ipa: determine the maximum endpoint ID
Date:   Thu, 27 Oct 2022 07:26:31 -0500
Message-Id: <20221027122632.488694-7-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221027122632.488694-1-elder@linaro.org>
References: <20221027122632.488694-1-elder@linaro.org>
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

Each endpoint ID has an entry in the IPA endpoint array.  But the
size of that array is defined at compile time.  Instead, rename
ipa_endpoint_data_valid() to be ipa_endpoint_max() and have it
return the maximum endpoint ID defined in configuration data.
That function will still validate configuration data.

Zero is returned on error; it's a valid endpoint ID, but we need
more than one, so it can't be the maximum.  The next patch makes use
of the returned maximum value.

Finally, rename the "initialized" mask of endpoints defined by
configuration data to be "defined".

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa.h          |  6 +--
 drivers/net/ipa/ipa_endpoint.c | 67 ++++++++++++++++++----------------
 2 files changed, 39 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ipa/ipa.h b/drivers/net/ipa/ipa.h
index 82225316a2e25..e975f63271c96 100644
--- a/drivers/net/ipa/ipa.h
+++ b/drivers/net/ipa/ipa.h
@@ -61,9 +61,9 @@ struct ipa_interrupt;
  * @zero_addr:		DMA address of preallocated zero-filled memory
  * @zero_virt:		Virtual address of preallocated zero-filled memory
  * @zero_size:		Size (bytes) of preallocated zero-filled memory
+ * @defined:		Bit mask indicating endpoints defined in config data
  * @available:		Bit mask indicating endpoints hardware supports
  * @filter_map:		Bit mask indicating endpoints that support filtering
- * @initialized:	Bit mask indicating endpoints initialized
  * @set_up:		Bit mask indicating endpoints set up
  * @enabled:		Bit mask indicating endpoints enabled
  * @modem_tx_count:	Number of defined modem TX endoints
@@ -117,9 +117,9 @@ struct ipa {
 	size_t zero_size;
 
 	/* Bit masks indicating endpoint state */
-	u32 available;		/* supported by hardware */
+	u32 defined;			/* Defined in configuration data */
+	u32 available;			/* Supported by hardware */
 	u32 filter_map;
-	u32 initialized;
 	u32 set_up;
 	u32 enabled;
 
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 740b2e4e0c50a..9fd72ba149afa 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -243,42 +243,47 @@ static bool ipa_endpoint_data_valid_one(struct ipa *ipa, u32 count,
 	return true;
 }
 
-static bool ipa_endpoint_data_valid(struct ipa *ipa, u32 count,
-				    const struct ipa_gsi_endpoint_data *data)
+/* Validate endpoint configuration data.  Return max defined endpoint ID */
+static u32 ipa_endpoint_max(struct ipa *ipa, u32 count,
+			    const struct ipa_gsi_endpoint_data *data)
 {
 	const struct ipa_gsi_endpoint_data *dp = data;
 	struct device *dev = &ipa->pdev->dev;
 	enum ipa_endpoint_name name;
+	u32 max;
 
 	if (count > IPA_ENDPOINT_COUNT) {
 		dev_err(dev, "too many endpoints specified (%u > %u)\n",
 			count, IPA_ENDPOINT_COUNT);
-		return false;
+		return 0;
 	}
 
 	/* Make sure needed endpoints have defined data */
 	if (ipa_gsi_endpoint_data_empty(&data[IPA_ENDPOINT_AP_COMMAND_TX])) {
 		dev_err(dev, "command TX endpoint not defined\n");
-		return false;
+		return 0;
 	}
 	if (ipa_gsi_endpoint_data_empty(&data[IPA_ENDPOINT_AP_LAN_RX])) {
 		dev_err(dev, "LAN RX endpoint not defined\n");
-		return false;
+		return 0;
 	}
 	if (ipa_gsi_endpoint_data_empty(&data[IPA_ENDPOINT_AP_MODEM_TX])) {
 		dev_err(dev, "AP->modem TX endpoint not defined\n");
-		return false;
+		return 0;
 	}
 	if (ipa_gsi_endpoint_data_empty(&data[IPA_ENDPOINT_AP_MODEM_RX])) {
 		dev_err(dev, "AP<-modem RX endpoint not defined\n");
-		return false;
+		return 0;
 	}
 
-	for (name = 0; name < count; name++, dp++)
+	max = 0;
+	for (name = 0; name < count; name++, dp++) {
 		if (!ipa_endpoint_data_valid_one(ipa, count, data, dp))
-			return false;
+			return 0;
+		max = max_t(u32, max, dp->endpoint_id);
+	}
 
-	return true;
+	return max;
 }
 
 /* Allocate a transaction to use on a non-command endpoint */
@@ -448,7 +453,7 @@ void ipa_endpoint_modem_pause_all(struct ipa *ipa, bool enable)
 /* Reset all modem endpoints to use the default exception endpoint */
 int ipa_endpoint_modem_exception_reset_all(struct ipa *ipa)
 {
-	u32 initialized = ipa->initialized;
+	u32 defined = ipa->defined;
 	struct gsi_trans *trans;
 	u32 count;
 
@@ -463,13 +468,13 @@ int ipa_endpoint_modem_exception_reset_all(struct ipa *ipa)
 		return -EBUSY;
 	}
 
-	while (initialized) {
-		u32 endpoint_id = __ffs(initialized);
+	while (defined) {
+		u32 endpoint_id = __ffs(defined);
 		struct ipa_endpoint *endpoint;
 		const struct ipa_reg *reg;
 		u32 offset;
 
-		initialized ^= BIT(endpoint_id);
+		defined ^= BIT(endpoint_id);
 
 		/* We only reset modem TX endpoints */
 		endpoint = &ipa->endpoint[endpoint_id];
@@ -1812,13 +1817,13 @@ static void ipa_endpoint_teardown_one(struct ipa_endpoint *endpoint)
 
 void ipa_endpoint_setup(struct ipa *ipa)
 {
-	u32 initialized = ipa->initialized;
+	u32 defined = ipa->defined;
 
 	ipa->set_up = 0;
-	while (initialized) {
-		u32 endpoint_id = __ffs(initialized);
+	while (defined) {
+		u32 endpoint_id = __ffs(defined);
 
-		initialized ^= BIT(endpoint_id);
+		defined ^= BIT(endpoint_id);
 
 		ipa_endpoint_setup_one(&ipa->endpoint[endpoint_id]);
 	}
@@ -1842,10 +1847,10 @@ int ipa_endpoint_config(struct ipa *ipa)
 {
 	struct device *dev = &ipa->pdev->dev;
 	const struct ipa_reg *reg;
-	u32 initialized;
 	u32 tx_count;
 	u32 rx_count;
 	u32 rx_base;
+	u32 defined;
 	u32 limit;
 	u32 val;
 
@@ -1885,12 +1890,12 @@ int ipa_endpoint_config(struct ipa *ipa)
 	/* Mark all supported RX and TX endpoints as available */
 	ipa->available = GENMASK(limit - 1, rx_base) | GENMASK(tx_count - 1, 0);
 
-	initialized = ipa->initialized;
-	while (initialized) {
-		u32 endpoint_id = __ffs(initialized);
+	defined = ipa->defined;
+	while (defined) {
+		u32 endpoint_id = __ffs(defined);
 		struct ipa_endpoint *endpoint;
 
-		initialized ^= BIT(endpoint_id);
+		defined ^= BIT(endpoint_id);
 
 		if (endpoint_id >= limit) {
 			dev_err(dev, "invalid endpoint id, %u > %u\n",
@@ -1943,24 +1948,24 @@ static void ipa_endpoint_init_one(struct ipa *ipa, enum ipa_endpoint_name name,
 	endpoint->toward_ipa = data->toward_ipa;
 	endpoint->config = data->endpoint.config;
 
-	ipa->initialized |= BIT(endpoint->endpoint_id);
+	ipa->defined |= BIT(endpoint->endpoint_id);
 }
 
 static void ipa_endpoint_exit_one(struct ipa_endpoint *endpoint)
 {
-	endpoint->ipa->initialized &= ~BIT(endpoint->endpoint_id);
+	endpoint->ipa->defined &= ~BIT(endpoint->endpoint_id);
 
 	memset(endpoint, 0, sizeof(*endpoint));
 }
 
 void ipa_endpoint_exit(struct ipa *ipa)
 {
-	u32 initialized = ipa->initialized;
+	u32 defined = ipa->defined;
 
-	while (initialized) {
-		u32 endpoint_id = __fls(initialized);
+	while (defined) {
+		u32 endpoint_id = __fls(defined);
 
-		initialized ^= BIT(endpoint_id);
+		defined ^= BIT(endpoint_id);
 
 		ipa_endpoint_exit_one(&ipa->endpoint[endpoint_id]);
 	}
@@ -1977,10 +1982,10 @@ u32 ipa_endpoint_init(struct ipa *ipa, u32 count,
 
 	BUILD_BUG_ON(!IPA_REPLENISH_BATCH);
 
-	if (!ipa_endpoint_data_valid(ipa, count, data))
+	if (!ipa_endpoint_max(ipa, count, data))
 		return 0;	/* Error */
 
-	ipa->initialized = 0;
+	ipa->defined = 0;
 
 	filter_map = 0;
 	for (name = 0; name < count; name++, data++) {
-- 
2.34.1

