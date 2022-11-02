Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 545CF617082
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 23:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbiKBWMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 18:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231534AbiKBWL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 18:11:58 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F26BCE14
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 15:11:54 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id m15so184390ilq.2
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 15:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+xtIdRfPlPgVtPzZBa18RgWUGmJjs2ni8p7EMA1XR/M=;
        b=Wlu9sAWkAYKtytrHJSptm5bLfYhtqmKOZxq0vQB6Xbe7ISfAnAYy3/64MSTJM6tnGT
         uoyWm89UIrjUA3iKlbny0wiZOM1NldRVWeNRm+P1poTzL/o6MCBqVPmoZfnxTG6HZwgF
         C6Hd5sFMJwyIEs+OzyfP4FkG5EBzAxxIJDMJBQCJYcn7FGAX+8qRf4b/JCbJ1A1Z2yl3
         esI3uryzAWE4aLokITyfVozcEd5Bd70+Dz+NZg5PTINEKObVeAHMpnpRUBBjTkEUVTWq
         YABaR371XFKMe1dpmRaOKNEPoHNZqpGvDZtcJbO02wU9OmxzumrypjtakiYovO06m6tq
         USbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+xtIdRfPlPgVtPzZBa18RgWUGmJjs2ni8p7EMA1XR/M=;
        b=lHVsm00gRDfD1k7c14Z7qu1mJLIamxKOM5VK/+MivdmMnAVVtC6hLTVj6ML47VPWPr
         ZQ6gmcsdoZsMp6aJ+fZJshT9YbFjIxGMShWyRFY7N7Iign1fIRgzmi+ll7OSsGSMW+TW
         18F/8jrfN346kUGCQCBntBsS7zfX8VAUL7jq2zHS93y0HunkcYe3c+KfrrZRaps/aKyc
         DTe8hE50YUhUms7+16hnfnc673SOS8vTo6L1pxk1dYfktnXpc/VHsEaEJYKeV99jiaa3
         RuJBEGU2g619AX2w/TGFc6SiM6m1XkyGYws+LjX//Kgp3OmnOus4A4fY9tk6H/Jice2A
         Ps+Q==
X-Gm-Message-State: ACrzQf3uiypg1KS8hBUfSTZ7DG4af8gh2IRsh1gMmP0aLgCrXHaO6IWI
        bfMygp6c9xgslbmeLFHvHsORuA==
X-Google-Smtp-Source: AMsMyM45fLWHlrj4gmHAd/3pn69z+QK7aXuuqdfQT4KO1R/jaVShnXVcIiBsfCN2Oaepv/z9baag3g==
X-Received: by 2002:a92:dac2:0:b0:300:c4e1:8b76 with SMTP id o2-20020a92dac2000000b00300c4e18b76mr6512177ilq.319.1667427114261;
        Wed, 02 Nov 2022 15:11:54 -0700 (PDT)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id f8-20020a02a108000000b0037465a1dd3fsm5073974jag.156.2022.11.02.15.11.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 15:11:53 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 9/9] net: ipa: use a bitmap for enabled endpoints
Date:   Wed,  2 Nov 2022 17:11:39 -0500
Message-Id: <20221102221139.1091510-10-elder@linaro.org>
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

Replace the 32-bit unsigned used to track enabled endpoints with a
Linux bitmap, to allow an arbitrary number of endpoints to be
represented.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa.h          |  4 ++--
 drivers/net/ipa/ipa_endpoint.c | 32 ++++++++++++++++++++------------
 2 files changed, 22 insertions(+), 14 deletions(-)

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
index 3fe20b4d9c90b..136932464261c 100644
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
@@ -1971,6 +1970,8 @@ void ipa_endpoint_exit(struct ipa *ipa)
 	for_each_set_bit(endpoint_id, ipa->defined, ipa->endpoint_count)
 		ipa_endpoint_exit_one(&ipa->endpoint[endpoint_id]);
 
+	bitmap_free(ipa->enabled);
+	ipa->enabled = NULL;
 	bitmap_free(ipa->set_up);
 	ipa->set_up = NULL;
 	bitmap_free(ipa->defined);
@@ -2003,6 +2004,10 @@ int ipa_endpoint_init(struct ipa *ipa, u32 count,
 	if (!ipa->set_up)
 		goto err_free_defined;
 
+	ipa->enabled = bitmap_zalloc(ipa->endpoint_count, GFP_KERNEL);
+	if (!ipa->enabled)
+		goto err_free_set_up;
+
 	filtered = 0;
 	for (name = 0; name < count; name++, data++) {
 		if (ipa_gsi_endpoint_data_empty(data))
@@ -2027,6 +2032,9 @@ int ipa_endpoint_init(struct ipa *ipa, u32 count,
 
 	return 0;
 
+err_free_set_up:
+	bitmap_free(ipa->set_up);
+	ipa->set_up = NULL;
 err_free_defined:
 	bitmap_free(ipa->defined);
 	ipa->defined = NULL;
-- 
2.34.1

