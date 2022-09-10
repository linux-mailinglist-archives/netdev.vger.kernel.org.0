Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF275B4386
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 03:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbiIJBLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 21:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbiIJBLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 21:11:39 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E4AFCA3F
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 18:11:38 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id a9so1686853ilh.1
        for <netdev@vger.kernel.org>; Fri, 09 Sep 2022 18:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=/KJRsDXkQlnFmQZPViyIwBLDjtPmSnCqlK5jU9YX2n0=;
        b=lQfqa/l/qX4f9tLNKKXIC1QFajURv47Df3DMvCOq88Z1BF0DcuiIlJzH7X3FkNAwDS
         L9AAXEx1oN911qhjxEsfgiJ7l/XL27k2QUuf+sl7dbpNyyOlzZHlOes6mf7GYBmKoSSW
         rLTRQJ4XzMQMCTKBjCDbn6URJzkFUxsceANAil1kbBGdXttBKck9OvrDkdSL6tk7kqMb
         1N19EcCx/DtZ5Xe/QsxjbOc7HkqWr9rTFfHpnpBDGfprfICFLBjGDRPVM9gnHlwwqKZD
         Yr5XOMWBa1OKwNKR1vAv83KqF1JD70JdeeIAZoCmTpTzEZ+X26dylfAUoSBcwvQBY+CQ
         JtZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=/KJRsDXkQlnFmQZPViyIwBLDjtPmSnCqlK5jU9YX2n0=;
        b=loZL6nNgiL/hp2OBDEB3qE6ca8QLr054nqeWGSOr+lvmsBWlBYBvs82ugc1LqJ+pY+
         Iw2RCFnhuQp+eLyY7vx10QhYgf9T1T1UZKkS7NRPDAlPUCn5OdYpLCuXgBcpPzfKGy3C
         u5ocpKHgIFHMzAnIRXObatXkRGP31UAEpZbVd4FFg7eMtsOrohnjQjgql825Y+kZAsgd
         cY/jswGorD+AnQBjhZSetPVxj6Jk8W66Vpsp67n6PQA3TXKLUZ+Z6WTpwuAjAN0meqI4
         GKnrKeQtnlDPIwMsnxHcN97wo7hfqcxzKbLpXfsTE3Oajk35p0e8pJdt7gzjeEH0SZ+V
         GC/w==
X-Gm-Message-State: ACgBeo2op/+PMNemx97UTh46MUAwoqaJi3KvNajFkP1onaU189Bo7wK4
        kH15wOhyygWGmd+zpGbOLwBkvw==
X-Google-Smtp-Source: AA6agR7t3Jdqc+4WFwfocgHR6svPY/UXN839YEsNqTRzYXeuzZOL69PYSS//B/NtZUS/MK6vWAxN/g==
X-Received: by 2002:a05:6e02:667:b0:2e6:9b52:3426 with SMTP id l7-20020a056e02066700b002e69b523426mr5421635ilt.318.1662772298032;
        Fri, 09 Sep 2022 18:11:38 -0700 (PDT)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id u133-20020a02238b000000b00348e1a6491asm733064jau.137.2022.09.09.18.11.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 18:11:37 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/6] net: ipa: move and redefine ipa_version_valid()
Date:   Fri,  9 Sep 2022 20:11:28 -0500
Message-Id: <20220910011131.1431934-4-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220910011131.1431934-1-elder@linaro.org>
References: <20220910011131.1431934-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the definition of ipa_version_valid(), making it a static
inline function defined together with the enumerated type in
"ipa_version.h".  Define a new count value in the type.

Rename the function to be ipa_version_supported(), and have it
return true only if the IPA version supplied is explicitly supported
by the driver.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_main.c    | 25 ++-----------------------
 drivers/net/ipa/ipa_version.h | 20 ++++++++++++++++++--
 2 files changed, 20 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 32962d885acd5..9dfa7f58a207f 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -616,27 +616,6 @@ static void ipa_validate_build(void)
 			field_max(AGGR_GRANULARITY_FMASK));
 }
 
-static bool ipa_version_valid(enum ipa_version version)
-{
-	switch (version) {
-	case IPA_VERSION_3_0:
-	case IPA_VERSION_3_1:
-	case IPA_VERSION_3_5:
-	case IPA_VERSION_3_5_1:
-	case IPA_VERSION_4_0:
-	case IPA_VERSION_4_1:
-	case IPA_VERSION_4_2:
-	case IPA_VERSION_4_5:
-	case IPA_VERSION_4_7:
-	case IPA_VERSION_4_9:
-	case IPA_VERSION_4_11:
-		return true;
-
-	default:
-		return false;
-	}
-}
-
 /**
  * ipa_probe() - IPA platform driver probe function
  * @pdev:	Platform device pointer
@@ -678,8 +657,8 @@ static int ipa_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	if (!ipa_version_valid(data->version)) {
-		dev_err(dev, "invalid IPA version\n");
+	if (!ipa_version_supported(data->version)) {
+		dev_err(dev, "unsupported IPA version %u\n", data->version);
 		return -EINVAL;
 	}
 
diff --git a/drivers/net/ipa/ipa_version.h b/drivers/net/ipa/ipa_version.h
index 852d6cbc87758..58f7b43b4db3b 100644
--- a/drivers/net/ipa/ipa_version.h
+++ b/drivers/net/ipa/ipa_version.h
@@ -19,10 +19,10 @@
  * @IPA_VERSION_4_7:	IPA version 4.7/GSI version 2.7
  * @IPA_VERSION_4_9:	IPA version 4.9/GSI version 2.9
  * @IPA_VERSION_4_11:	IPA version 4.11/GSI version 2.11 (2.1.1)
+ * @IPA_VERSION_COUNT:	Number of defined IPA versions
  *
  * Defines the version of IPA (and GSI) hardware present on the platform.
- * Please update ipa_version_valid() and ipa_version_string() whenever a
- * new version is added.
+ * Please update ipa_version_string() whenever a new version is added.
  */
 enum ipa_version {
 	IPA_VERSION_3_0,
@@ -36,8 +36,24 @@ enum ipa_version {
 	IPA_VERSION_4_7,
 	IPA_VERSION_4_9,
 	IPA_VERSION_4_11,
+	IPA_VERSION_COUNT,			/* Last; not a version */
 };
 
+static inline bool ipa_version_supported(enum ipa_version version)
+{
+	switch (version) {
+	case IPA_VERSION_3_1:
+	case IPA_VERSION_3_5_1:
+	case IPA_VERSION_4_2:
+	case IPA_VERSION_4_5:
+	case IPA_VERSION_4_9:
+	case IPA_VERSION_4_11:
+		return true;
+	default:
+		return false;
+	}
+}
+
 /* Execution environment IDs */
 enum gsi_ee_id {
 	GSI_EE_AP		= 0x0,
-- 
2.34.1

