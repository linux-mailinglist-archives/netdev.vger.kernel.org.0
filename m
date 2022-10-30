Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 609106126A5
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 02:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbiJ3ATC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 20:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiJ3ASq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 20:18:46 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F7724BE7
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 17:18:45 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id h18so4719956ilq.9
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 17:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R88kCoeCwDv+6qx8H8D1eKrnunl5yRlCsLCL15HFklE=;
        b=F1+aFWl9mh16nV+3OhidAUkfR8KopPxpN92zsTwEGVEphUWqJtVtDlSMjRjOpGxUmG
         XMy8lwKkGE6/E+YVPj3ZDdAfaUwmGqDWbgmu/4YtRWvg37LLXBK7uXdbioJX7PNlwt1k
         3uLIEXp2cgBNoVpCWmmqSmmsfrhloczhjmsqFt7MbVy9W1zYyjYi/wvQDRiwJshL9Q4o
         JFcVsjhnAfuTeixlcaASHodHRvZbmLzbK31vH1B2qqe08f2z5w7JKSCZ/NGx1/O4hUop
         /TKpWLB+1Dg1hY1a4ZR/Nxdq3ZUsolUL9IxMovRHXE+P4b2Db0kaPXFNOcw7gv6qo0h0
         gPqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R88kCoeCwDv+6qx8H8D1eKrnunl5yRlCsLCL15HFklE=;
        b=s3smrmxoSHYk7bGkqDPI1VTvPMDcFjPDvhWPEQ2skKm1bR4t5HnnS7RAXdnnYY6dX2
         oZrjUS4muzjCqHSIvi/JmmKcdaBJcB+93MxMp21YYfhTswDxwROPh1jluGnE2DvCPFG3
         j9FDUaSqtS9DGOsKthdKDtf8w8l1iEqWbQVcTEDKMV/rUDFu+ApMDqRFg4pRPnrg/OSv
         Bh5R/7zqb3FpQU4Sbo5u/Bg9QQhPy3BTWNWBR02au7EeRcA68Nfj+n/M4aBgSs30fIQL
         4GsTXSYnf/fJTXQlmd7hK1QTReJK1y8fX2e3vQ3wjQzBiTK+bjN3Iow5C0qyS6jM8PX9
         LD7Q==
X-Gm-Message-State: ACrzQf2czB/ymdkE1d6QHcz1NfVlpy9rVxbKaH4+JpZscqL+7Nl+dqnU
        ZsijEYiIyhMVbGCI8npHWUvKDg==
X-Google-Smtp-Source: AMsMyM5Eufyl9Abspn/K5iqnZ9+ZEgPo1s95Ze8BT24YGErCd18WlOw/mlZwABCMJ7cu+3WyezWs7Q==
X-Received: by 2002:a92:502:0:b0:2fc:5e54:b4a6 with SMTP id q2-20020a920502000000b002fc5e54b4a6mr2946656ile.41.1667089124808;
        Sat, 29 Oct 2022 17:18:44 -0700 (PDT)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id co20-20020a0566383e1400b00375126ae55fsm1087519jab.58.2022.10.29.17.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 17:18:44 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/9] net: ipa: use a bitmap for defined endpoints
Date:   Sat, 29 Oct 2022 19:18:24 -0500
Message-Id: <20221030001828.754010-6-elder@linaro.org>
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
 drivers/net/ipa/ipa.h          |  6 ++---
 drivers/net/ipa/ipa_endpoint.c | 49 +++++++++++++++-------------------
 2 files changed, 24 insertions(+), 31 deletions(-)

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
index 32559ed498c19..56908ee097cf6 100644
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
@@ -1983,6 +1970,7 @@ void ipa_endpoint_exit(struct ipa *ipa)
 u32 ipa_endpoint_init(struct ipa *ipa, u32 count,
 		      const struct ipa_gsi_endpoint_data *data)
 {
+	struct device *dev = &ipa->pdev->dev;
 	enum ipa_endpoint_name name;
 	u32 filter_map;
 
@@ -1993,7 +1981,12 @@ u32 ipa_endpoint_init(struct ipa *ipa, u32 count,
 	if (!ipa->endpoint_count)
 		return 0;	/* Error */
 
-	ipa->defined = 0;
+	/* Set up the defined endpoint bitmap */
+	ipa->defined = bitmap_zalloc(ipa->endpoint_count, GFP_KERNEL);
+	if (!ipa->defined) {
+		dev_err(dev, "unable to allocate defined endpoint bitmap\n");
+		return 0;
+	}
 
 	filter_map = 0;
 	for (name = 0; name < count; name++, data++) {
-- 
2.34.1

