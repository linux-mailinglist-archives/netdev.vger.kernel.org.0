Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7CE9626B7B
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 21:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235037AbiKLUHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 15:07:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235006AbiKLUHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 15:07:31 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80110165A1
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 12:07:30 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id l6so4033766ilq.3
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 12:07:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=umpLk1dbP5jy5ZPV4Q21UM7cr1nZKFjsXDStFsdzpxA=;
        b=Ut/gqy52LOxFagWry8zJuDnyu69bte+omzwmYqNJjdvDmQX60UlPpo692bej4Zhl9C
         tiH32C6p562bFsgNQA8qY2bXfS9xVCJDURVWy9Axdoe4EDtoH3XEqI0TZ2T7qjHfcFJB
         PaY2LK/FfpGEuv0LrqIoWWh6tWDsbtR+x8kK1rs4TBR9zzW2uRrVBikuYPEPu/LI/3vX
         BRKu2HCJ9gP608jB7pEpv+zCebScrj1VyC87MTS0v8ueM5/5I6Ilt3hRJUlw1su3zUAf
         wkjT+etQqpiHzS1wCY+eYesaBbyEXYjEPwEMwYfygSVfg68S6NMNma9zaalqmkK3WA77
         QdPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=umpLk1dbP5jy5ZPV4Q21UM7cr1nZKFjsXDStFsdzpxA=;
        b=jfrPOPoC5REN0+AW2eQztAFoGa4YLZoE7uSJe4yef42yiC3hyMAxDM3y2ZS60gWo/o
         3k73NvqD5u/b9gzfuSuRvjzumw1KWp7TxQsY8KAVG/g2qfpE8iluMyholXPyS3wnS/gC
         8232+aw/A0iNqPlY2xgq4PybZYEbgS2VXGbDsfcX8kjSlVwXL4Y1Ntdk+02ti63QlpYN
         hlqpOg4BADv5aAcjaT52FY5qMApl7lGSL2UQh2Frhh9t/ax0+KX7S1qmUsICSEydKoRO
         1cyMSHMIrVc7wsGSMmqxv8B5DNqbuNDgqaGcsmgmCpL+DARif0KjGMnr0NBP3KR5GUwM
         ji1g==
X-Gm-Message-State: ANoB5pkelyS2hEocpewXKRMfzSRixjc+rrugkJWbNPyodhOv1SEkRRW6
        zAEXWJw6bZnWVfgypFGxyk+PrQ==
X-Google-Smtp-Source: AA0mqf6wJzsiyKserLnxFT3qmoxPiw6AwBOUHizEn6i/Wpy285f3kTXAf8dscv0fIstCOJQ0uE9myA==
X-Received: by 2002:a92:da45:0:b0:302:568e:b493 with SMTP id p5-20020a92da45000000b00302568eb493mr210216ilq.183.1668283649429;
        Sat, 12 Nov 2022 12:07:29 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id j28-20020a02cb1c000000b00363dee286edsm2036870jap.60.2022.11.12.12.07.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Nov 2022 12:07:28 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     andersson@kernel.org, konrad.dybcio@linaro.org, agross@kernel.org,
        elder@kernel.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/5] net: ipa: permit GSI firmware loading to be skipped
Date:   Sat, 12 Nov 2022 14:07:17 -0600
Message-Id: <20221112200717.1533622-6-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221112200717.1533622-1-elder@linaro.org>
References: <20221112200717.1533622-1-elder@linaro.org>
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

Define a new value "skip" for the "qcom,gsi-loader" Device Tree
property.  If used, it indicates that neither the AP nor the modem
need to load GSI firmware (because it has already been loaded--for
example by the boot loader).

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_main.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 214e524dce795..8f20825675a1a 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -87,12 +87,14 @@
  * @IPA_LOADER_DEFER:		System not ready; try again later
  * @IPA_LOADER_SELF:		AP loads GSI firmware
  * @IPA_LOADER_MODEM:		Modem loads GSI firmware, signals when done
+ * @IPA_LOADER_SKIP:		Neither AP nor modem need to load GSI firmware
  * @IPA_LOADER_INVALID:	GSI firmware loader specification is invalid
  */
 enum ipa_firmware_loader {
 	IPA_LOADER_DEFER,
 	IPA_LOADER_SELF,
 	IPA_LOADER_MODEM,
+	IPA_LOADER_SKIP,
 	IPA_LOADER_INVALID,
 };
 
@@ -740,6 +742,10 @@ static enum ipa_firmware_loader ipa_firmware_loader(struct device *dev)
 	if (!strcmp(str, "modem"))
 		return IPA_LOADER_MODEM;
 
+	/* No GSI firmware load is needed for "skip" */
+	if (!strcmp(str, "skip"))
+		return IPA_LOADER_SKIP;
+
 	/* Any value other than "self" is an error */
 	if (strcmp(str, "self"))
 		return IPA_LOADER_INVALID;
@@ -872,10 +878,12 @@ static int ipa_probe(struct platform_device *pdev)
 	if (loader == IPA_LOADER_MODEM)
 		goto done;
 
-	/* The AP is loading GSI firmware; do so now */
-	ret = ipa_firmware_load(dev);
-	if (ret)
-		goto err_deconfig;
+	if (loader == IPA_LOADER_SELF) {
+		/* The AP is loading GSI firmware; do so now */
+		ret = ipa_firmware_load(dev);
+		if (ret)
+			goto err_deconfig;
+	} /* Otherwise loader == IPA_LOADER_SKIP */
 
 	/* GSI firmware is loaded; proceed to setup */
 	ret = ipa_setup(ipa);
-- 
2.34.1

