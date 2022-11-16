Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0453962B3F6
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 08:33:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbiKPHdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 02:33:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232711AbiKPHdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 02:33:06 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE59B1F6
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 23:33:04 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id a14so28466167wru.5
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 23:33:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IbFCvRl1cs7XC6NWdvqbuTmw/rqE6VsOAXoQYLExO5Q=;
        b=DU7zoibqF3VBeTWDB1vEVwMsv4KlatyI3tqd0l3rYwWf91OWuP87YxY4SgVZW5bSja
         P/AuW06El34WSS9tvrxvmpqlp+Iu7W/jCxl/UUk9jczg1+LrryegvgjlQ92BF7QN8m7E
         yymio/ffeYE8OJuEs9x2SWrTUyDYP6TgfYL3LtfA6PmSmnPVgvgCNmvrfIRbAbC1+d3D
         mb2qWhHHyUgmEBaBBEO6OsdRKR4iPwe9qZN3jHsmKu9t4x4HHiICUE/l5ZoMmwnD+q0s
         caM5y++t4iivpSWgOlOnjFS1OXBeQy67ZtcG9aK4ni7NUIqc6kzCLWRwqYI7cfW+w4RL
         3DeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IbFCvRl1cs7XC6NWdvqbuTmw/rqE6VsOAXoQYLExO5Q=;
        b=J1yQ6lUXMBhHaHmYifOTZJNm8Kpw1jg7wPLz9w99qCvFLZdvci1iagFUY5J5IWOKLo
         G6kibyBRMsPYDv9kYEvEK+O6/kjewGrjQlaZZ8f2doIDLYVDVVf6UdY3lYORbN7r1tAA
         Jrje2omynBaZ9FI7pNaQ2pfs8V+Vao5MstIOg5PUheVyaoPC0NOf/9aXBPR6zNw7RXSX
         MTDqvQcLvDr8mpFj5Tyq8QIe4/Ls19JLh1409F03bNR35vekbIMGkk6+SGYYtbIDX4vt
         fOzLs2hejtRK8DdnCMV5VwNd0ymvHbYlJMN1oHXmdXKNqJWN1fIAQDr4PrGyI5vU4+wy
         EkQw==
X-Gm-Message-State: ANoB5plYZ4q8NVzvQ2YC0LAxPo7A1QrwNjSV5KTa1FJROAzYBy3IbRFR
        xoLoruVFGg2TcOK6IRUq1peDLg==
X-Google-Smtp-Source: AA0mqf6cWWDeTZxYs8eiGGu1JwEuX0r4Ne2NcNUJL+s0RO7tr8L1y6+afgEwv7VvBlyhwtpJLHEcrQ==
X-Received: by 2002:a5d:5446:0:b0:236:6442:3a65 with SMTP id w6-20020a5d5446000000b0023664423a65mr13222982wrv.84.1668583984173;
        Tue, 15 Nov 2022 23:33:04 -0800 (PST)
Received: from zoltan.localdomain ([167.98.215.174])
        by smtp.gmail.com with ESMTPSA id g34-20020a05600c4ca200b003cfd4e6400csm1058823wmp.19.2022.11.15.23.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 23:33:03 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     andersson@kernel.org, konrad.dybcio@linaro.org, agross@kernel.org,
        elder@kernel.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 2/5] net: ipa: encapsulate decision about firmware load
Date:   Wed, 16 Nov 2022 01:32:53 -0600
Message-Id: <20221116073257.34010-3-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221116073257.34010-1-elder@linaro.org>
References: <20221116073257.34010-1-elder@linaro.org>
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

The GSI layer used for IPA requires firmware to be loaded.

Currently either the AP or the modem loads the firmware,
distinguished by whether the "modem-init" Device Tree
property is defined.

Some newer systems implement a third option.  In preparation for
that, encapsulate the code that determines how the GSI firmware
gets loaded in a new function, ipa_firmware_loader().

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_main.c | 39 ++++++++++++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index ebb6c9b311eb9..9e43b79d233e9 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -81,6 +81,19 @@
 /* Divider for 19.2 MHz crystal oscillator clock to get common timer clock */
 #define IPA_XO_CLOCK_DIVIDER	192	/* 1 is subtracted where used */
 
+/**
+ * enum ipa_firmware_loader: How GSI firmware gets loaded
+ *
+ * @IPA_LOADER_DEFER:		System not ready; try again later
+ * @IPA_LOADER_SELF:		AP loads GSI firmware
+ * @IPA_LOADER_MODEM:		Modem loads GSI firmware, signals when done
+ */
+enum ipa_firmware_loader {
+	IPA_LOADER_DEFER,
+	IPA_LOADER_SELF,
+	IPA_LOADER_MODEM,
+};
+
 /**
  * ipa_setup() - Set up IPA hardware
  * @ipa:	IPA pointer
@@ -696,6 +709,18 @@ static void ipa_validate_build(void)
 	BUILD_BUG_ON(!ipa_aggr_granularity_val(IPA_AGGR_GRANULARITY));
 }
 
+static enum ipa_firmware_loader ipa_firmware_loader(struct device *dev)
+{
+	if (of_property_read_bool(dev->of_node, "modem-init"))
+		return IPA_LOADER_MODEM;
+
+	/* We need Trust Zone to load firmware; make sure it's available */
+	if (qcom_scm_is_available())
+		return IPA_LOADER_SELF;
+
+	return IPA_LOADER_DEFER;
+}
+
 /**
  * ipa_probe() - IPA platform driver probe function
  * @pdev:	Platform device pointer
@@ -722,9 +747,9 @@ static void ipa_validate_build(void)
 static int ipa_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
+	enum ipa_firmware_loader loader;
 	const struct ipa_data *data;
 	struct ipa_power *power;
-	bool modem_init;
 	struct ipa *ipa;
 	int ret;
 
@@ -747,11 +772,9 @@ static int ipa_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	/* If we need Trust Zone, make sure it's available */
-	modem_init = of_property_read_bool(dev->of_node, "modem-init");
-	if (!modem_init)
-		if (!qcom_scm_is_available())
-			return -EPROBE_DEFER;
+	loader = ipa_firmware_loader(dev);
+	if (loader == IPA_LOADER_DEFER)
+		return -EPROBE_DEFER;
 
 	/* The clock and interconnects might not be ready when we're
 	 * probed, so might return -EPROBE_DEFER.
@@ -796,7 +819,7 @@ static int ipa_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_endpoint_exit;
 
-	ret = ipa_smp2p_init(ipa, modem_init);
+	ret = ipa_smp2p_init(ipa, loader == IPA_LOADER_MODEM);
 	if (ret)
 		goto err_table_exit;
 
@@ -815,7 +838,7 @@ static int ipa_probe(struct platform_device *pdev)
 	 * call to ipa_setup() when it has finished.  In that case we're
 	 * done here.
 	 */
-	if (modem_init)
+	if (loader == IPA_LOADER_MODEM)
 		goto done;
 
 	/* Otherwise we need to load the firmware and have Trust Zone validate
-- 
2.34.1

