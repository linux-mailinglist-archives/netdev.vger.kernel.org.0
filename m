Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78886629779
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 12:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237684AbiKOLbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 06:31:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiKOLbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 06:31:31 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C821F1A3BA
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 03:31:30 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id j15so23767513wrq.3
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 03:31:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QmJK2z6YewxghveqGIb9UQBF6OMvTjY+OevUyUnH0xk=;
        b=k4Wk8SJzRhqnAXgbsU5UoMU6S3GG5pKKmOwOlxbFHnJZK2Gd1ISJplEGnPTTgav2Io
         p7LEnsWo+qY65f9r4bO1QhQR6I4KnqEVRZPkC1UPoU1BJcIcIfyqLGVFB7l9ytX6LKg6
         RmVHalJsc+Af9sEHGLvpgJLFysuZSAyGXkcXC8TD/7d1jjz3gJPLcr3em5oZDNlj6u0h
         Koi50OZFkn26y6VCrs6mCrl4zccZ3ee9sJ20m7msyngMafejHfgADR+HiVh/QPIcHx9f
         zkEl0TlYx7/uSs54/CmF2F3cGX0vHoxQB4RFA8oVgsyUlOVRS+DVFxyZm9d/jsCxKiHn
         uOUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QmJK2z6YewxghveqGIb9UQBF6OMvTjY+OevUyUnH0xk=;
        b=7uimhxF8n22+phsfEHKu5SiMH4EeidYU90tjtsm03L03dMRuNXD8B4iwW0fMeAa8p4
         TpalHsDMEmTjPVHu7OcaKFXJ2dk1oSQgt7Et80aS6txArweab9SS9saSQPorpQi7JJVX
         4gk5CQkR1Am9QDZAbw0p4DvKBjzl2Vygkv++V9uTcPzNLMBPM+KVWdkRlvSyc8y82wFU
         d21m4bpL+XNmbUXebLsqh9oaHpQDmV/TSDxxx5kwiqV1a3xr3Kgvuwc8Nb8j0ZsTexG7
         gdGdU/7+JQgVGjmMATIVFL6hvksPGm8DlBru+8pcKnpcvYo/SISPxtMmxDEF5/+InLXY
         JpLQ==
X-Gm-Message-State: ANoB5pnOHX/NQ18CLA1A6aDCPk2xlEiFkyhojAOY2iizaL1j2AB0HO/d
        +udwtlnRikXqOS205/MbG1eBlQ==
X-Google-Smtp-Source: AA0mqf5T/TlbfoU3tRLzxMxknGknMiobNOGrTYTtHcl5JPzD7NAwIFrBv5OSukCtRDjOYMCppujbXA==
X-Received: by 2002:a5d:4903:0:b0:236:87f4:75d with SMTP id x3-20020a5d4903000000b0023687f4075dmr10004008wrq.447.1668511889176;
        Tue, 15 Nov 2022 03:31:29 -0800 (PST)
Received: from zoltan.localdomain ([81.128.185.34])
        by smtp.gmail.com with ESMTPSA id r18-20020adfe692000000b00238df11940fsm12273091wrm.16.2022.11.15.03.31.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 03:31:27 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     andersson@kernel.org, konrad.dybcio@linaro.org, agross@kernel.org,
        elder@kernel.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 3/5] net: ipa: introduce "qcom,gsi-loader" property
Date:   Tue, 15 Nov 2022 05:31:17 -0600
Message-Id: <20221115113119.249893-4-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221115113119.249893-1-elder@linaro.org>
References: <20221115113119.249893-1-elder@linaro.org>
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

Introduce a new way of specifying how the GSI firmware gets loaded
for IPA.  Currently, this is indicated by the presence or absence of
the Boolean "modem-init" Device Tree property.  The new property
must have a value--either "self" or "modem"--which indicates whether
the AP or modem is the GSI firmware loader, respectively.

For legacy systems, the new property will not exist, and the
"modem-init" property will be used.  For newer systems, the
"qcom,gsi-loader" property *must* exist, and must have one of the
two prescribed values.  It is an error to have both properties
defined, and it is an error for the new property to have an
unrecognized value.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_main.c | 44 ++++++++++++++++++++++++++++++++------
 1 file changed, 37 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 9e43b79d233e9..214e524dce795 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -87,11 +87,13 @@
  * @IPA_LOADER_DEFER:		System not ready; try again later
  * @IPA_LOADER_SELF:		AP loads GSI firmware
  * @IPA_LOADER_MODEM:		Modem loads GSI firmware, signals when done
+ * @IPA_LOADER_INVALID:	GSI firmware loader specification is invalid
  */
 enum ipa_firmware_loader {
 	IPA_LOADER_DEFER,
 	IPA_LOADER_SELF,
 	IPA_LOADER_MODEM,
+	IPA_LOADER_INVALID,
 };
 
 /**
@@ -711,9 +713,37 @@ static void ipa_validate_build(void)
 
 static enum ipa_firmware_loader ipa_firmware_loader(struct device *dev)
 {
-	if (of_property_read_bool(dev->of_node, "modem-init"))
+	bool modem_init;
+	const char *str;
+	int ret;
+
+	/* Look up the old and new properties by name */
+	modem_init = of_property_read_bool(dev->of_node, "modem-init");
+	ret = of_property_read_string(dev->of_node, "qcom,gsi-loader", &str);
+
+	/* If the new property doesn't exist, it's legacy behavior */
+	if (ret == -EINVAL) {
+		if (modem_init)
+			return IPA_LOADER_MODEM;
+		goto out_self;
+	}
+
+	/* Any other error on the new property means it's poorly defined */
+	if (ret)
+		return IPA_LOADER_INVALID;
+
+	/* New property value exists; if old one does too, that's invalid */
+	if (modem_init)
+		return IPA_LOADER_INVALID;
+
+	/* Modem loads GSI firmware for "modem" */
+	if (!strcmp(str, "modem"))
 		return IPA_LOADER_MODEM;
 
+	/* Any value other than "self" is an error */
+	if (strcmp(str, "self"))
+		return IPA_LOADER_INVALID;
+out_self:
 	/* We need Trust Zone to load firmware; make sure it's available */
 	if (qcom_scm_is_available())
 		return IPA_LOADER_SELF;
@@ -773,6 +803,8 @@ static int ipa_probe(struct platform_device *pdev)
 	}
 
 	loader = ipa_firmware_loader(dev);
+	if (loader == IPA_LOADER_INVALID)
+		return -EINVAL;
 	if (loader == IPA_LOADER_DEFER)
 		return -EPROBE_DEFER;
 
@@ -834,20 +866,18 @@ static int ipa_probe(struct platform_device *pdev)
 
 	dev_info(dev, "IPA driver initialized");
 
-	/* If the modem is doing early initialization, it will trigger a
-	 * call to ipa_setup() when it has finished.  In that case we're
-	 * done here.
+	/* If the modem is loading GSI firmware, it will trigger a call to
+	 * ipa_setup() when it has finished.  In that case we're done here.
 	 */
 	if (loader == IPA_LOADER_MODEM)
 		goto done;
 
-	/* Otherwise we need to load the firmware and have Trust Zone validate
-	 * and install it.  If that succeeds we can proceed with setup.
-	 */
+	/* The AP is loading GSI firmware; do so now */
 	ret = ipa_firmware_load(dev);
 	if (ret)
 		goto err_deconfig;
 
+	/* GSI firmware is loaded; proceed to setup */
 	ret = ipa_setup(ipa);
 	if (ret)
 		goto err_deconfig;
-- 
2.34.1

