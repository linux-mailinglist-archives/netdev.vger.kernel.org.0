Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCE0A62B3FC
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 08:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232893AbiKPHda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 02:33:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232704AbiKPHdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 02:33:08 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 200D0B7D7
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 23:33:07 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id fn7-20020a05600c688700b003b4fb113b86so846162wmb.0
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 23:33:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QmJK2z6YewxghveqGIb9UQBF6OMvTjY+OevUyUnH0xk=;
        b=AlwDnToVO2of7fWwUMmka1YavMRruNRrWzdBbvlUDfspCxIL90nNvyGeVYFxHCrwSa
         qiaS3T7X63l9vutvktkMzPsvV8+N7I0qVjejVbxzFPUn4sPaJ9OvXFZQf/3f/5Ln5k/J
         27Ef6HD165TVua+NrERnzzR9+lFEZMrxkT+ZvGI5Ar3alJ/9KDz7dwt28z68oxuq6yex
         NjSkHgdlAHsHw0IWX+vT0UusfXj/zSydp4igAc+jsX7kHqFJvcBcfuPkR1jKh8G9IMZL
         uyl10CjRKz1Pwp714ZcObGaRQTsbaKt022qSs/ZqnPdqurS8vCUHEnKTzKUM61/2OolN
         3GGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QmJK2z6YewxghveqGIb9UQBF6OMvTjY+OevUyUnH0xk=;
        b=u1LrU7khBZyIMWyJ8Zg+T7DDHROiCkx751WgASwitj806BGfRw9HXFNdWxXD3KAH4p
         McxTn5s4TXmuzzD5Y4pPDNUZEIcY5MJNXJlYcNYdJReU3NxG+qkyxG4HxZhzJieQjPUv
         +XNWiEJcjE4BchAkzfadkBgSXlOh8zWt2zWBExzcb91j1Q+3/r3ZTF7EJnGK3BSqBVQz
         CVj36tn8nkQiAYkKyjLCYkyQ6X4uMCw4RGvlFGxilAFUP0GrhR53LQuHNIM4QRlK6Iwb
         eBHBL0sPzq4qHVn6mj+ttSvmJXej3gVU2Fta9REq6GQHO5o0ukObdInqkDVySlRldxOa
         /6jw==
X-Gm-Message-State: ANoB5pnx8Q2J0K1/f9VwTYGqw70F++3pbdw3VpSCCw9GFhYphgttA7hZ
        yaZzsWBQbrM1OxS376XA6L26Kg==
X-Google-Smtp-Source: AA0mqf62Ld8reiwgFoaddozR7mLXKWhrMlpi/Ugv0wlkVD+1Yr31Rmsy7IfPlu/JMX7DeFk05uwbXQ==
X-Received: by 2002:a1c:e914:0:b0:3cf:d055:9138 with SMTP id q20-20020a1ce914000000b003cfd0559138mr1126362wmc.140.1668583985420;
        Tue, 15 Nov 2022 23:33:05 -0800 (PST)
Received: from zoltan.localdomain ([167.98.215.174])
        by smtp.gmail.com with ESMTPSA id g34-20020a05600c4ca200b003cfd4e6400csm1058823wmp.19.2022.11.15.23.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 23:33:04 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     andersson@kernel.org, konrad.dybcio@linaro.org, agross@kernel.org,
        elder@kernel.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 3/5] net: ipa: introduce "qcom,gsi-loader" property
Date:   Wed, 16 Nov 2022 01:32:54 -0600
Message-Id: <20221116073257.34010-4-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221116073257.34010-1-elder@linaro.org>
References: <20221116073257.34010-1-elder@linaro.org>
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

