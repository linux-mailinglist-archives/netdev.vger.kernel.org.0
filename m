Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BAA76271C8
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 19:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235558AbiKMSrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 13:47:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbiKMSrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 13:47:37 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF6E1FCED;
        Sun, 13 Nov 2022 10:47:35 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id a5so14345290edb.11;
        Sun, 13 Nov 2022 10:47:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SPSCT7mL2Daw8RWymsIQzf971Rn84ofq1ETgmc/Yrg4=;
        b=UR/aoMRfLNPHf+oe//1gZcDiKrj20/dQroVVC3bELi920m6tVVK50Ixl4Y6q7+JjUu
         CJNoMzuRfdPpex8t1vmM9AEn5zMf1TkWwPqivZpx6gJwfYXy2A1l23klBmagqjvae7BA
         MuYzxg1feIxkm+qn6Xb+dfR1LJy/wUxWAfKycFMBiPtpmyaR4Pn0KLSKZ42rujr1bd/w
         8rHvlPf+9W6sWOY5NxgRzpuHoDr/ZxtzY+BwGorJZte+DWTUaG0PGJ3rZCEDx1FJhjn7
         INMSvfAB56s2hsnAutpTBoSEC6qe593TtZujeLLyr8c47ZwjNTJROR4wLzr/Uqab0HpV
         iLaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SPSCT7mL2Daw8RWymsIQzf971Rn84ofq1ETgmc/Yrg4=;
        b=fVG6B4CE+te3kSwINqgWkGF7M4xvs2EjDIlkzWWC/Z3hqWRn2QMJh81vfF9KBgwB0r
         9rQ1DGHkdAF43y4+9oRFQX5Z+cCbtIWQBh/NVI2uR2P5l5+NiifrrDvAtpMx9dgaQLRq
         ay9xuwXzVXoyyWRPwsRocIzM2qXYLFDfP7/LG+jS5QMVk/idJJb0T48IPAxkVint9uUF
         AM8VYvMWARlM0XOfQkARBhZdRV1qfY/v+enljXbn+sX57gXzbgjT191Ra6IjvmIm5BYY
         FeAO+jPcJAcij0Syg3osbi+GRma+46IOlZbcpyxpMTi9UeskiNiKCR53CDRjqGlch+H2
         PxCQ==
X-Gm-Message-State: ANoB5plvNqC7K8V6larXDyxHLhorlOu0dLRddr4XIMjG+j/TnTdcyPD+
        NNLsv0gqFIXzYGtDgFK0lCM=
X-Google-Smtp-Source: AA0mqf4h2dzpwsq0qL4eAdnL7K+BPsUaMF+jTK9E4MPEuBmLv4EwxVFmCmlCzPBUlL5Lo73X2XKA+g==
X-Received: by 2002:a05:6402:1750:b0:467:d741:f359 with SMTP id v16-20020a056402175000b00467d741f359mr1680827edx.100.1668365254274;
        Sun, 13 Nov 2022 10:47:34 -0800 (PST)
Received: from fedora.. (dh207-97-48.xnet.hr. [88.207.97.48])
        by smtp.googlemail.com with ESMTPSA id a2-20020aa7d742000000b004623028c594sm3760050eds.49.2022.11.13.10.47.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Nov 2022 10:47:33 -0800 (PST)
From:   Robert Marko <robimarko@gmail.com>
To:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Robert Marko <robimarko@gmail.com>
Subject: [PATCH 3/5] dt-bindings: net: ipq4019-mdio: require and validate clocks
Date:   Sun, 13 Nov 2022 19:47:25 +0100
Message-Id: <20221113184727.44923-3-robimarko@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221113184727.44923-1-robimarko@gmail.com>
References: <20221113184727.44923-1-robimarko@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we can match the platforms requiring clocks by compatible start
using those to allow clocks per compatible and make them required.

Signed-off-by: Robert Marko <robimarko@gmail.com>
---
 .../bindings/net/qcom,ipq4019-mdio.yaml       | 28 +++++++++++++------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml b/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
index 2c85ae43d27d..b34955b0b827 100644
--- a/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
@@ -9,9 +9,6 @@ title: Qualcomm IPQ40xx MDIO Controller
 maintainers:
   - Robert Marko <robert.marko@sartura.hr>
 
-allOf:
-  - $ref: "mdio.yaml#"
-
 properties:
   compatible:
     oneOf:
@@ -40,18 +37,31 @@ properties:
       the second Address and length of the register for ethernet LDO, this second
       address range is only required by the platform IPQ50xx.
 
-  clocks:
-    maxItems: 1
-    description: |
-      MDIO clock source frequency fixed to 100MHZ, this clock should be specified
-      by the platform IPQ807x, IPQ60xx and IPQ50xx.
-
 required:
   - compatible
   - reg
   - "#address-cells"
   - "#size-cells"
 
+allOf:
+  - $ref: "mdio.yaml#"
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - qcom,ipq5018-mdio
+              - qcom,ipq6018-mdio
+              - qcom,ipq8074-mdio
+    then:
+      properties:
+        clocks:
+          items:
+            - description: MDIO clock source frequency fixed to 100MHZ
+      required:
+        - clocks
+
 unevaluatedProperties: false
 
 examples:
-- 
2.38.1

