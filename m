Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9659C6126B1
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 02:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbiJ3AUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 20:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiJ3ATI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 20:19:08 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 264314F6B2
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 17:18:53 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id c65so4043931iof.1
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 17:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cEUlpLn6RuLc4Fo/uPSYCehvdn31euMXFsdMmyCklyk=;
        b=SgQo6EF4wTm/UBaevZtlQYHMSlg7mAp5S8g0l0XvdCufc9TjYfk8eg50qb7ggL3r0+
         musLPB0I22VqJZrSvjCgVwVYGvZNf5prBF0zZ+fBVXIMt+a7KjCieF8pGqSQ0qIjzkD1
         9uoK2iP8Hz4rwvZqYh91jq2MsQrZgCDV9QSIY86oo2k7s0tn2epfkA0nEUHGdYfu/zfl
         BduYuQWAYUGnfgfS8/cVLUhnmDAONGv97oB772BePT7HsJCs3+D/533siTlS9fhYbDyx
         7MVOrpcGYlJlDtLeEtoqD6cRmVZ7dEcTAfYSRdiKjgJ2RPFKbAxYhljzKXkSJqIpUI7G
         zXSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cEUlpLn6RuLc4Fo/uPSYCehvdn31euMXFsdMmyCklyk=;
        b=D2iIymH5B4TeNyinJFUmGHMzWkJombjoGGqvokVAfX/eChQ0DzoJpcL+BuNoYj0lB1
         cvuAKIEAWQpdsnzz5L/Pf6kwnYW8xu7cznRoDasUaf0V5KsqGdsyF6C/54p8r3S4ke2m
         GlP5UJOU06Eqw0O4w2L4lO6EouUklxtGPeCMoNMBDXBsI9EkwZsaMuTCtco3uw1B14QW
         vrIwAi9js+xpEqpZyiP4XuvoKCBRiwhplDV2pBg1EIP41r6VL7Me5fNAIGCO4tpZTfXK
         q/Vxc43ukcDYN8mEcaiI0Hf3MADKMaVWiD9zV8jYsslxC3zFz7JT5xTmq8xKQTXbAmzF
         TQPQ==
X-Gm-Message-State: ACrzQf08izzFWFz9aI59YhUC/BNcGKUD1zE5unuFwWnUcoZL/z7RS3sb
        9zquCBkqnsUpLTb77EpGzTrcN6XCP+9i2Q==
X-Google-Smtp-Source: AMsMyM5JicI5H6e3IRZLxXLnhj7L4y9fUvtaoryjcSsgFFK+c547ySMaskYTWqNT4deOVsAKiqB/tg==
X-Received: by 2002:a02:6d15:0:b0:375:3523:b643 with SMTP id m21-20020a026d15000000b003753523b643mr3579915jac.144.1667089132781;
        Sat, 29 Oct 2022 17:18:52 -0700 (PDT)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id co20-20020a0566383e1400b00375126ae55fsm1087519jab.58.2022.10.29.17.18.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 17:18:52 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 9/9] net: ipa: use a bitmap for enabled endpoints
Date:   Sat, 29 Oct 2022 19:18:28 -0500
Message-Id: <20221030001828.754010-10-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221030001828.754010-1-elder@linaro.org>
References: <20221030001828.754010-1-elder@linaro.org>
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

Replace the 32-bit unsigned used to track enabled endpoints with a
Linux bitmap, to allow an arbitrary number of endpoints to be
represented.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa.h          |  4 ++--
 drivers/net/ipa/ipa_endpoint.c | 28 ++++++++++++++++------------
 2 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ipa/ipa.h b/drivers/net/ipa/ipa.h
index f14d1bd34e7e5..5372db58b5bdc 100644
--- a/drivers/net/ipa/ipa.h
+++ b/drivers/net/ipa/ipa.h
@@ -67,7 +67,7 @@ struct ipa_interrupt;
  * @available:		Bitmap of endpoints supported by hardware
  * @filtered:		Bitmap of endpoints that support filtering
  * @set_up:		Bitmap of endpoints that are set up for use
- * @enabled:		Bit mask indicating endpoints enabled
+ * @enabled:		Bitmap of currently enabled endpoints
  * @modem_tx_count:	Number of defined modem TX endoints
  * @endpoint:		Array of endpoint information
  * @channel_map:	Mapping of GSI channel to IPA endpoint
@@ -125,7 +125,7 @@ struct ipa {
 	unsigned long *available;	/* Supported by hardware */
 	u64 filtered;			/* Support filtering (AP and modem) */
 	unsigned long *set_up;
-	u32 enabled;
+	unsigned long *enabled;
 
 	u32 modem_tx_count;
 	struct ipa_endpoint endpoint[IPA_ENDPOINT_MAX];
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 564a209f75a0f..ea9ed2da4ff0c 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1666,6 +1666,7 @@ static void ipa_endpoint_program(struct ipa_endpoint *endpoint)
 
 int ipa_endpoint_enable_one(struct ipa_endpoint *endpoint)
 {
+	u32 endpoint_id = endpoint->endpoint_id;
 	struct ipa *ipa = endpoint->ipa;
 	struct gsi *gsi = &ipa->gsi;
 	int ret;
@@ -1675,37 +1676,35 @@ int ipa_endpoint_enable_one(struct ipa_endpoint *endpoint)
 		dev_err(&ipa->pdev->dev,
 			"error %d starting %cX channel %u for endpoint %u\n",
 			ret, endpoint->toward_ipa ? 'T' : 'R',
-			endpoint->channel_id, endpoint->endpoint_id);
+			endpoint->channel_id, endpoint_id);
 		return ret;
 	}
 
 	if (!endpoint->toward_ipa) {
-		ipa_interrupt_suspend_enable(ipa->interrupt,
-					     endpoint->endpoint_id);
+		ipa_interrupt_suspend_enable(ipa->interrupt, endpoint_id);
 		ipa_endpoint_replenish_enable(endpoint);
 	}
 
-	ipa->enabled |= BIT(endpoint->endpoint_id);
+	__set_bit(endpoint_id, ipa->enabled);
 
 	return 0;
 }
 
 void ipa_endpoint_disable_one(struct ipa_endpoint *endpoint)
 {
-	u32 mask = BIT(endpoint->endpoint_id);
+	u32 endpoint_id = endpoint->endpoint_id;
 	struct ipa *ipa = endpoint->ipa;
 	struct gsi *gsi = &ipa->gsi;
 	int ret;
 
-	if (!(ipa->enabled & mask))
+	if (!test_bit(endpoint_id, ipa->enabled))
 		return;
 
-	ipa->enabled ^= mask;
+	__clear_bit(endpoint_id, endpoint->ipa->enabled);
 
 	if (!endpoint->toward_ipa) {
 		ipa_endpoint_replenish_disable(endpoint);
-		ipa_interrupt_suspend_disable(ipa->interrupt,
-					      endpoint->endpoint_id);
+		ipa_interrupt_suspend_disable(ipa->interrupt, endpoint_id);
 	}
 
 	/* Note that if stop fails, the channel's state is not well-defined */
@@ -1713,7 +1712,7 @@ void ipa_endpoint_disable_one(struct ipa_endpoint *endpoint)
 	if (ret)
 		dev_err(&ipa->pdev->dev,
 			"error %d attempting to stop endpoint %u\n", ret,
-			endpoint->endpoint_id);
+			endpoint_id);
 }
 
 void ipa_endpoint_suspend_one(struct ipa_endpoint *endpoint)
@@ -1722,7 +1721,7 @@ void ipa_endpoint_suspend_one(struct ipa_endpoint *endpoint)
 	struct gsi *gsi = &endpoint->ipa->gsi;
 	int ret;
 
-	if (!(endpoint->ipa->enabled & BIT(endpoint->endpoint_id)))
+	if (!test_bit(endpoint->endpoint_id, endpoint->ipa->enabled))
 		return;
 
 	if (!endpoint->toward_ipa) {
@@ -1742,7 +1741,7 @@ void ipa_endpoint_resume_one(struct ipa_endpoint *endpoint)
 	struct gsi *gsi = &endpoint->ipa->gsi;
 	int ret;
 
-	if (!(endpoint->ipa->enabled & BIT(endpoint->endpoint_id)))
+	if (!test_bit(endpoint->endpoint_id, endpoint->ipa->enabled))
 		return;
 
 	if (!endpoint->toward_ipa)
@@ -1970,8 +1969,10 @@ void ipa_endpoint_exit(struct ipa *ipa)
 	for_each_set_bit(endpoint_id, ipa->defined, ipa->endpoint_count)
 		ipa_endpoint_exit_one(&ipa->endpoint[endpoint_id]);
 
+	bitmap_free(ipa->enabled);
 	bitmap_free(ipa->set_up);
 	bitmap_free(ipa->defined);
+	ipa->enabled = NULL;
 	ipa->set_up = NULL;
 	ipa->defined = NULL;
 
@@ -1997,8 +1998,11 @@ int ipa_endpoint_init(struct ipa *ipa, u32 count,
 	/* Set up the defined endpoint bitmap */
 	ipa->defined = bitmap_zalloc(ipa->endpoint_count, GFP_KERNEL);
 	ipa->set_up = bitmap_zalloc(ipa->endpoint_count, GFP_KERNEL);
+	ipa->enabled = bitmap_zalloc(ipa->endpoint_count, GFP_KERNEL);
 	if (!ipa->defined || !ipa->set_up) {
 		dev_err(dev, "unable to allocate endpoint bitmaps\n");
+		bitmap_free(ipa->set_up);
+		ipa->set_up = NULL;
 		bitmap_free(ipa->defined);
 		ipa->defined = NULL;
 		return -ENOMEM;
-- 
2.34.1

