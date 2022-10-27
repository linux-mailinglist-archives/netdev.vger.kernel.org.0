Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E447960F72A
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 14:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235615AbiJ0M0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 08:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235593AbiJ0M0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 08:26:44 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D44C513ECEB
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 05:26:42 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id b79so1267708iof.5
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 05:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PANmuigY2dyK4ROc5rs4Gly3suQYhUI4Jvo2R9OvA2c=;
        b=CNIPTfja4d7m0UUvAc898mJLSi8nuvTEtwk390CUT8LLOZ1Yvw6rMwssAbUQFEmB83
         AAw/OYfkSg+b5It3jiavbaVjKPJ0VxHdydf4Hhueu2M7P+4oLvjAhR4ulNs4E5JQZNmO
         uTAtYpTZPKgwt4wJDjtzIAWZSaBYSTmslPpv47BzwfOekUMR5BhdZUj6C4sTCqkv/c1v
         gN6Qc9qFT0qpNKM5yEgRvsZrTXd729hp6tYoReRAuibU+gujlXUbdWW9IKJpvzvoYb+L
         fQy1m6utqPHp+d/BceLWEMvQzR6AphefF06vF4AoXgzIpg4+mckq3xlpgN7de5E8680J
         FGlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PANmuigY2dyK4ROc5rs4Gly3suQYhUI4Jvo2R9OvA2c=;
        b=wTVzpH4/UyxwiVXPEuyvvkON7G4pvH95wjU9OaYBUX4KZfRu7hOE7g8f0AuHfrPdl8
         mVbENFumciHSZeAcQM2QIsf1Hj0TAzl3qEzjYbofmZ710cw3wIqmoxS7DWCFIHydYT7q
         5/J1vlrgS9480grJ0ZlKHNXcOgUlIoXAqPi7Evo7GHl+U+ij6mSK3P4zWsp0iKoxDW6z
         /QJNbdXvt01zcBsiAEtuy52DKmiHAQwgThfyINoE9naFAajs0YDBZBe8riyO5JHnirJ+
         HYXz9P4/vspmd6Z8gFXd3Ze3pPnbRBcl6mbwcKcKbbcuzFFA93cIeBJvaYYOjCi8qriQ
         ADAg==
X-Gm-Message-State: ACrzQf0tIzpcDjvjsG5NGT7EpD1353vn8AJouNYWIaqV9GAeeDWJzz2U
        2ENDHf3MrqBuzoRirl37yiiNkw==
X-Google-Smtp-Source: AMsMyM7948ncau+MksGbU5iwfardCsWRE6DiqjByPQPSPYOlju6O4NNT+XrwmwJHOTge3Q4AeyB9bg==
X-Received: by 2002:a02:c90a:0:b0:363:2b87:887c with SMTP id t10-20020a02c90a000000b003632b87887cmr31914891jao.72.1666873602491;
        Thu, 27 Oct 2022 05:26:42 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id w24-20020a05663800d800b003566ff0eb13sm526528jao.34.2022.10.27.05.26.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 05:26:41 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/7] net: ipa: more completely check endpoint validity
Date:   Thu, 27 Oct 2022 07:26:29 -0500
Message-Id: <20221027122632.488694-5-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221027122632.488694-1-elder@linaro.org>
References: <20221027122632.488694-1-elder@linaro.org>
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

Ensure all defined TX endpoints are in the range [0, CONS_PIPES) and
defined RX endpoints are within [PROD_LOWEST, PROD_LOWEST+PROD_PIPES).

Modify the way local variables are used to make the checks easier
to understand.  Check for each endpoint being in valid range in the
loop, and drop the logical-AND check of initialized against
unavailable IDs.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 67 +++++++++++++++++++---------------
 1 file changed, 37 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 093e11ec7c2d1..6fc3cc6379fb0 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1843,14 +1843,13 @@ int ipa_endpoint_config(struct ipa *ipa)
 	struct device *dev = &ipa->pdev->dev;
 	const struct ipa_reg *reg;
 	u32 initialized;
+	u32 tx_count;
+	u32 rx_count;
 	u32 rx_base;
-	u32 rx_mask;
-	u32 tx_mask;
-	int ret = 0;
-	u32 max;
+	u32 limit;
 	u32 val;
 
-	/* Prior to IPAv3.5, the FLAVOR_0 register was not supported.
+	/* Prior to IPA v3.5, the FLAVOR_0 register was not supported.
 	 * Furthermore, the endpoints were not grouped such that TX
 	 * endpoint numbers started with 0 and RX endpoints had numbers
 	 * higher than all TX endpoints, so we can't do the simple
@@ -1866,33 +1865,25 @@ int ipa_endpoint_config(struct ipa *ipa)
 	}
 
 	/* Find out about the endpoints supplied by the hardware, and ensure
-	 * the highest one doesn't exceed the number we support.
+	 * the highest one doesn't exceed the number supported by software.
 	 */
 	reg = ipa_reg(ipa, FLAVOR_0);
 	val = ioread32(ipa->reg_virt + ipa_reg_offset(reg));
 
-	/* Our RX is an IPA producer */
+	/* Our RX is an IPA producer; our TX is an IPA consumer. */
+	tx_count = ipa_reg_decode(reg, MAX_CONS_PIPES, val);
+	rx_count = ipa_reg_decode(reg, MAX_PROD_PIPES, val);
 	rx_base = ipa_reg_decode(reg, PROD_LOWEST, val);
-	max = rx_base + ipa_reg_decode(reg, MAX_PROD_PIPES, val);
-	if (max > IPA_ENDPOINT_MAX) {
-		dev_err(dev, "too many endpoints (%u > %u)\n",
-			max, IPA_ENDPOINT_MAX);
+
+	limit = rx_base + rx_count;
+	if (limit > IPA_ENDPOINT_MAX) {
+		dev_err(dev, "too many endpoints, %u > %u\n",
+			limit, IPA_ENDPOINT_MAX);
 		return -EINVAL;
 	}
-	rx_mask = GENMASK(max - 1, rx_base);
 
-	/* Our TX is an IPA consumer */
-	max = ipa_reg_decode(reg, MAX_CONS_PIPES, val);
-	tx_mask = GENMASK(max - 1, 0);
-
-	ipa->available = rx_mask | tx_mask;
-
-	/* Check for initialized endpoints not supported by the hardware */
-	if (ipa->initialized & ~ipa->available) {
-		dev_err(dev, "unavailable endpoint id(s) 0x%08x\n",
-			ipa->initialized & ~ipa->available);
-		ret = -EINVAL;		/* Report other errors too */
-	}
+	/* Mark all supported RX and TX endpoints as available */
+	ipa->available = GENMASK(limit - 1, rx_base) | GENMASK(tx_count - 1, 0);
 
 	initialized = ipa->initialized;
 	while (initialized) {
@@ -1901,16 +1892,32 @@ int ipa_endpoint_config(struct ipa *ipa)
 
 		initialized ^= BIT(endpoint_id);
 
-		/* Make sure it's pointing in the right direction */
-		endpoint = &ipa->endpoint[endpoint_id];
-		if ((endpoint_id < rx_base) != endpoint->toward_ipa) {
-			dev_err(dev, "endpoint id %u wrong direction\n",
+		if (endpoint_id >= limit) {
+			dev_err(dev, "invalid endpoint id, %u > %u\n",
+				endpoint_id, limit - 1);
+			return -EINVAL;
+		}
+
+		if (!(BIT(endpoint_id) & ipa->available)) {
+			dev_err(dev, "unavailable endpoint id %u\n",
 				endpoint_id);
-			ret = -EINVAL;
+			return -EINVAL;
 		}
+
+		/* Make sure it's pointing in the right direction */
+		endpoint = &ipa->endpoint[endpoint_id];
+		if (endpoint->toward_ipa) {
+			if (endpoint_id < tx_count)
+				continue;
+		} else if (endpoint_id >= rx_base) {
+			continue;
+		}
+
+		dev_err(dev, "endpoint id %u wrong direction\n", endpoint_id);
+		return -EINVAL;
 	}
 
-	return ret;
+	return 0;
 }
 
 void ipa_endpoint_deconfig(struct ipa *ipa)
-- 
2.34.1

