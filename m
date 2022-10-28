Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 047FA6113F6
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 16:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbiJ1OFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 10:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbiJ1OEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 10:04:39 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C47CE1208E
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 07:04:34 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id h24so3487226qta.7
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 07:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cNpNkTmx9wSMCE2yxRPuo4r3OHTIwFUuEMSlysf9YpY=;
        b=WuBmfxwO/PNhp6naGatdA4wGiDb9VLdUaYjlO5YO+93daDyNqKvsj/Hsj1L9TUitY/
         Qj63rIAmKsoXqK+0B04JhdU1nCV0xqI6xqdPw9UbA42vEH9k6G7u6weJu3zFYFaFpxhu
         GhuEtbXqgqySc5qoscf7nc1OVPudGeiuU3IzgPfFXnZYz6uE2aswJlyy5JaQkAScsQlX
         rP59t1e91rps5MM1gMo8R9jzn1lXANAVI+gWIbP/rphRv32YMpjLUEhqNLyI7G6r0W7z
         Dd7zLhURwlgjGvYiuRw7a0K2C9mQdsI4LMM1A09GN5sBK07wnnFxugIPHbzkP09xSAp+
         VlCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cNpNkTmx9wSMCE2yxRPuo4r3OHTIwFUuEMSlysf9YpY=;
        b=QsnBHePDu+wEU6cQ1dPOVwFO0ubUU4PN7iDeXkuvADoWlfOVMoLqvBzbItlA4YaH/c
         /XT6afzm2PH5pVrU6uKmuIbhB71VyCs4sS+L2vtmGq6nOOoOG45YpyFzC8iHh0Df94X9
         xa4ZlInmOmDEI6uLC12NgPvT53s9Z6hHFKNFGlTQ8ghuXzjPh84EqvWhcztU2Q4xBXSw
         m9jzRtno8cb3jt/cij/iJWv/x6TGmBj2AFpg2fdfjW6zl/tkPj+EkXvwixnga1xxRjju
         VX3Go1iMCQa5I9kjp2D1ThuV1tIKD14004csUtAdQbSXrbr16QkpXhL4la0odUwOAgsD
         Tt4g==
X-Gm-Message-State: ACrzQf2cQVK1Ffe+6cUKmT5Q7ZVXH5poLYAjacPw+VmNhnMRKoJANLid
        7A6dbK7J10lhdIkp7sExwP8kRw==
X-Google-Smtp-Source: AMsMyM4HYSh+PMt0AhXBcQpS/2IJoKIPL2iwWtiKhP6dKkFOBB6cmVVYmbeet7CoeGHioBF/AD3/+Q==
X-Received: by 2002:a05:622a:4c8:b0:39c:d6d2:32f7 with SMTP id q8-20020a05622a04c800b0039cd6d232f7mr45211372qtx.517.1666965872651;
        Fri, 28 Oct 2022 07:04:32 -0700 (PDT)
Received: from krzk-bin.. ([64.57.193.93])
        by smtp.gmail.com with ESMTPSA id w8-20020a05620a424800b006ed30a8fb21sm3028252qko.76.2022.10.28.07.04.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 07:04:32 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Bjorn Andersson <andersson@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        UNGLinuxDriver@microchip.com, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Jonathan Marek <jonathan@marek.ca>,
        Martin Botka <martin.botka@somainline.org>,
        Taniya Das <tdas@codeaurora.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Stephan Gerhold <stephan@gerhold.net>,
        Shawn Guo <shawn.guo@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        krishna Lanka <quic_vamslank@quicinc.com>,
        Iskren Chernev <iskren.chernev@gmail.com>,
        Del Regno <angelogioacchino.delregno@somainline.org>,
        Robert Foss <robert.foss@linaro.org>,
        Jeffrey Hugo <quic_jhugo@quicinc.com>,
        Govind Singh <govinds@codeaurora.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        linux-arm-msm@vger.kernel.org, linux-clk@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 2/2] dt-bindings: clock: qcom: cleanup
Date:   Fri, 28 Oct 2022 10:03:26 -0400
Message-Id: <20221028140326.43470-3-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221028140326.43470-1-krzysztof.kozlowski@linaro.org>
References: <20221028140326.43470-1-krzysztof.kozlowski@linaro.org>
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

Clean the Qualcomm SoCs clock bindings:
1. Drop redundant "bindings" in title.
2. Correct language grammar "<independent clause without verb>, which
   supports" -> "provides".
3. Use full path to the bindings header, so tools can validate it.
4. Drop quotes where not needed.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 .../bindings/clock/qcom,a53pll.yaml           |  2 +-
 .../devicetree/bindings/clock/qcom,a7pll.yaml |  2 +-
 .../bindings/clock/qcom,aoncc-sm8250.yaml     |  2 +-
 .../bindings/clock/qcom,audiocc-sm8250.yaml   |  2 +-
 .../bindings/clock/qcom,camcc-sm8250.yaml     |  6 ++--
 .../bindings/clock/qcom,dispcc-sm6125.yaml    |  9 +++---
 .../bindings/clock/qcom,dispcc-sm6350.yaml    |  8 ++---
 .../bindings/clock/qcom,dispcc-sm8x50.yaml    | 14 ++++-----
 .../bindings/clock/qcom,gcc-apq8064.yaml      | 18 +++++------
 .../bindings/clock/qcom,gcc-apq8084.yaml      | 10 +++----
 .../bindings/clock/qcom,gcc-ipq8064.yaml      | 18 +++++------
 .../bindings/clock/qcom,gcc-ipq8074.yaml      |  9 +++---
 .../bindings/clock/qcom,gcc-msm8660.yaml      | 12 ++++----
 .../bindings/clock/qcom,gcc-msm8909.yaml      |  9 +++---
 .../bindings/clock/qcom,gcc-msm8916.yaml      | 16 +++++-----
 .../bindings/clock/qcom,gcc-msm8976.yaml      |  9 +++---
 .../bindings/clock/qcom,gcc-msm8994.yaml      |  9 +++---
 .../bindings/clock/qcom,gcc-msm8996.yaml      |  7 ++---
 .../bindings/clock/qcom,gcc-msm8998.yaml      |  9 +++---
 .../bindings/clock/qcom,gcc-other.yaml        | 30 +++++++++----------
 .../bindings/clock/qcom,gcc-qcm2290.yaml      |  9 +++---
 .../bindings/clock/qcom,gcc-qcs404.yaml       |  9 +++---
 .../bindings/clock/qcom,gcc-sc7180.yaml       |  9 +++---
 .../bindings/clock/qcom,gcc-sc7280.yaml       |  9 +++---
 .../bindings/clock/qcom,gcc-sc8180x.yaml      |  9 +++---
 .../bindings/clock/qcom,gcc-sc8280xp.yaml     |  7 ++---
 .../bindings/clock/qcom,gcc-sdm660.yaml       |  8 ++---
 .../bindings/clock/qcom,gcc-sdm845.yaml       |  9 +++---
 .../bindings/clock/qcom,gcc-sdx55.yaml        |  7 ++---
 .../bindings/clock/qcom,gcc-sdx65.yaml        |  9 +++---
 .../bindings/clock/qcom,gcc-sm6115.yaml       |  9 +++---
 .../bindings/clock/qcom,gcc-sm6125.yaml       |  9 +++---
 .../bindings/clock/qcom,gcc-sm6350.yaml       |  9 +++---
 .../bindings/clock/qcom,gcc-sm8150.yaml       |  9 +++---
 .../bindings/clock/qcom,gcc-sm8250.yaml       |  9 +++---
 .../bindings/clock/qcom,gcc-sm8350.yaml       |  9 +++---
 .../bindings/clock/qcom,gcc-sm8450.yaml       |  9 +++---
 .../devicetree/bindings/clock/qcom,gcc.yaml   |  6 ++--
 .../bindings/clock/qcom,gpucc-sdm660.yaml     |  4 +--
 .../bindings/clock/qcom,gpucc-sm8350.yaml     |  9 +++---
 .../devicetree/bindings/clock/qcom,gpucc.yaml | 22 +++++++-------
 .../devicetree/bindings/clock/qcom,mmcc.yaml  |  4 +--
 .../bindings/clock/qcom,msm8998-gpucc.yaml    |  8 ++---
 .../bindings/clock/qcom,q6sstopcc.yaml        |  2 +-
 .../bindings/clock/qcom,qcm2290-dispcc.yaml   |  8 ++---
 .../bindings/clock/qcom,sc7180-camcc.yaml     |  9 +++---
 .../bindings/clock/qcom,sc7180-dispcc.yaml    |  8 ++---
 .../clock/qcom,sc7180-lpasscorecc.yaml        |  9 +++---
 .../bindings/clock/qcom,sc7180-mss.yaml       |  7 ++---
 .../bindings/clock/qcom,sc7280-camcc.yaml     |  6 ++--
 .../bindings/clock/qcom,sc7280-dispcc.yaml    |  8 ++---
 .../bindings/clock/qcom,sc7280-lpasscc.yaml   |  9 +++---
 .../clock/qcom,sc7280-lpasscorecc.yaml        | 12 ++++----
 .../bindings/clock/qcom,sdm845-camcc.yaml     |  8 ++---
 .../bindings/clock/qcom,sdm845-dispcc.yaml    |  8 ++---
 .../bindings/clock/qcom,sm6115-dispcc.yaml    |  7 ++---
 .../bindings/clock/qcom,sm6375-gcc.yaml       |  9 +++---
 .../bindings/clock/qcom,sm8450-camcc.yaml     |  8 ++---
 .../bindings/clock/qcom,sm8450-dispcc.yaml    |  7 ++---
 .../bindings/clock/qcom,videocc.yaml          | 20 ++++++-------
 60 files changed, 258 insertions(+), 289 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/qcom,a53pll.yaml b/Documentation/devicetree/bindings/clock/qcom,a53pll.yaml
index fe6ca4f68bbe..525ebaa93c85 100644
--- a/Documentation/devicetree/bindings/clock/qcom,a53pll.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,a53pll.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/qcom,a53pll.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm A53 PLL Binding
+title: Qualcomm A53 PLL clock
 
 maintainers:
   - Bjorn Andersson <andersson@kernel.org>
diff --git a/Documentation/devicetree/bindings/clock/qcom,a7pll.yaml b/Documentation/devicetree/bindings/clock/qcom,a7pll.yaml
index 0e96f693b050..809c34eb7d5a 100644
--- a/Documentation/devicetree/bindings/clock/qcom,a7pll.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,a7pll.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/qcom,a7pll.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm A7 PLL Binding
+title: Qualcomm A7 PLL clock
 
 maintainers:
   - Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
diff --git a/Documentation/devicetree/bindings/clock/qcom,aoncc-sm8250.yaml b/Documentation/devicetree/bindings/clock/qcom,aoncc-sm8250.yaml
index c40a74b5d672..4ee2d5a29e23 100644
--- a/Documentation/devicetree/bindings/clock/qcom,aoncc-sm8250.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,aoncc-sm8250.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/qcom,aoncc-sm8250.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Clock bindings for LPASS Always ON Clock Controller on SM8250 SoCs
+title: LPASS Always ON Clock Controller on SM8250 SoCs
 
 maintainers:
   - Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
diff --git a/Documentation/devicetree/bindings/clock/qcom,audiocc-sm8250.yaml b/Documentation/devicetree/bindings/clock/qcom,audiocc-sm8250.yaml
index 915d76206ad0..acf37fb633f7 100644
--- a/Documentation/devicetree/bindings/clock/qcom,audiocc-sm8250.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,audiocc-sm8250.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/qcom,audiocc-sm8250.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Clock bindings for LPASS Audio Clock Controller on SM8250 SoCs
+title: LPASS Audio Clock Controller on SM8250 SoCs
 
 maintainers:
   - Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
diff --git a/Documentation/devicetree/bindings/clock/qcom,camcc-sm8250.yaml b/Documentation/devicetree/bindings/clock/qcom,camcc-sm8250.yaml
index 9f239c3960d1..93ec1f598e6e 100644
--- a/Documentation/devicetree/bindings/clock/qcom,camcc-sm8250.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,camcc-sm8250.yaml
@@ -4,16 +4,16 @@
 $id: http://devicetree.org/schemas/clock/qcom,camcc-sm8250.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Camera Clock & Reset Controller Binding for SM8250
+title: Qualcomm Camera Clock & Reset Controller on SM8250
 
 maintainers:
   - Jonathan Marek <jonathan@marek.ca>
 
 description: |
-  Qualcomm camera clock control module which supports the clocks, resets and
+  Qualcomm camera clock control module provides the clocks, resets and
   power domains on SM8250.
 
-  See also dt-bindings/clock/qcom,camcc-sm8250.h
+  See also:: include/dt-bindings/clock/qcom,camcc-sm8250.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,dispcc-sm6125.yaml b/Documentation/devicetree/bindings/clock/qcom,dispcc-sm6125.yaml
index 7a03ef19c947..8a210c4c5f82 100644
--- a/Documentation/devicetree/bindings/clock/qcom,dispcc-sm6125.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,dispcc-sm6125.yaml
@@ -4,17 +4,16 @@
 $id: http://devicetree.org/schemas/clock/qcom,dispcc-sm6125.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Display Clock Controller Binding for SM6125
+title: Qualcomm Display Clock Controller on SM6125
 
 maintainers:
   - Martin Botka <martin.botka@somainline.org>
 
 description: |
-  Qualcomm display clock control module which supports the clocks and
-  power domains on SM6125.
+  Qualcomm display clock control module provides the clocks and power domains
+  on SM6125.
 
-  See also:
-    dt-bindings/clock/qcom,dispcc-sm6125.h
+  See also:: include/dt-bindings/clock/qcom,dispcc-sm6125.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,dispcc-sm6350.yaml b/Documentation/devicetree/bindings/clock/qcom,dispcc-sm6350.yaml
index e706678b353a..8efac3fb159f 100644
--- a/Documentation/devicetree/bindings/clock/qcom,dispcc-sm6350.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,dispcc-sm6350.yaml
@@ -4,16 +4,16 @@
 $id: http://devicetree.org/schemas/clock/qcom,dispcc-sm6350.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Display Clock & Reset Controller Binding for SM6350
+title: Qualcomm Display Clock & Reset Controller on SM6350
 
 maintainers:
   - Konrad Dybcio <konrad.dybcio@somainline.org>
 
 description: |
-  Qualcomm display clock control module which supports the clocks, resets and
-  power domains on SM6350.
+  Qualcomm display clock control module provides the clocks, resets and power
+  domains on SM6350.
 
-  See also dt-bindings/clock/qcom,dispcc-sm6350.h.
+  See also:: include/dt-bindings/clock/qcom,dispcc-sm6350.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,dispcc-sm8x50.yaml b/Documentation/devicetree/bindings/clock/qcom,dispcc-sm8x50.yaml
index 7a8d375e055e..d6774db257f0 100644
--- a/Documentation/devicetree/bindings/clock/qcom,dispcc-sm8x50.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,dispcc-sm8x50.yaml
@@ -4,19 +4,19 @@
 $id: http://devicetree.org/schemas/clock/qcom,dispcc-sm8x50.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Display Clock & Reset Controller Binding for SM8150/SM8250/SM8350
+title: Qualcomm Display Clock & Reset Controller on SM8150/SM8250/SM8350
 
 maintainers:
   - Jonathan Marek <jonathan@marek.ca>
 
 description: |
-  Qualcomm display clock control module which supports the clocks, resets and
-  power domains on SM8150/SM8250/SM8350.
+  Qualcomm display clock control module provides the clocks, resets and power
+  domains on SM8150/SM8250/SM8350.
 
-  See also:
-    dt-bindings/clock/qcom,dispcc-sm8150.h
-    dt-bindings/clock/qcom,dispcc-sm8250.h
-    dt-bindings/clock/qcom,dispcc-sm8350.h
+  See also::
+    include/dt-bindings/clock/qcom,dispcc-sm8150.h
+    include/dt-bindings/clock/qcom,dispcc-sm8250.h
+    include/dt-bindings/clock/qcom,dispcc-sm8350.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-apq8064.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc-apq8064.yaml
index 6b4efd64c154..09cd7a786871 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc-apq8064.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc-apq8064.yaml
@@ -4,22 +4,22 @@
 $id: http://devicetree.org/schemas/clock/qcom,gcc-apq8064.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Global Clock & Reset Controller Binding for APQ8064/MSM8960
-
-allOf:
-  - $ref: qcom,gcc.yaml#
+title: Qualcomm Global Clock & Reset Controller on APQ8064/MSM8960
 
 maintainers:
   - Stephen Boyd <sboyd@kernel.org>
   - Taniya Das <tdas@codeaurora.org>
 
 description: |
-  Qualcomm global clock control module which supports the clocks, resets and
-  power domains on APQ8064.
+  Qualcomm global clock control module provides the clocks, resets and power
+  domains on APQ8064.
 
-  See also:
-  - dt-bindings/clock/qcom,gcc-msm8960.h
-  - dt-bindings/reset/qcom,gcc-msm8960.h
+  See also::
+    include/dt-bindings/clock/qcom,gcc-msm8960.h
+    include/dt-bindings/reset/qcom,gcc-msm8960.h
+
+allOf:
+  - $ref: qcom,gcc.yaml#
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-apq8084.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc-apq8084.yaml
index 397fb918e032..8ade176c24f4 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc-apq8084.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc-apq8084.yaml
@@ -4,19 +4,19 @@
 $id: http://devicetree.org/schemas/clock/qcom,gcc-apq8084.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Global Clock & Reset Controller Binding for APQ8084
+title: Qualcomm Global Clock & Reset Controller on APQ8084
 
 maintainers:
   - Stephen Boyd <sboyd@kernel.org>
   - Taniya Das <quic_tdas@quicinc.com>
 
 description: |
-  Qualcomm global clock control module which supports the clocks, resets and
-  power domains on APQ8084.
+  Qualcomm global clock control module provides the clocks, resets and power
+  domains on APQ8084.
 
   See also::
-  - dt-bindings/clock/qcom,gcc-apq8084.h
-  - dt-bindings/reset/qcom,gcc-apq8084.h
+    include/dt-bindings/clock/qcom,gcc-apq8084.h
+    include/dt-bindings/reset/qcom,gcc-apq8084.h
 
 allOf:
   - $ref: qcom,gcc.yaml#
diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-ipq8064.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc-ipq8064.yaml
index 9eb91dd22557..f6b28061d2ab 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc-ipq8064.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc-ipq8064.yaml
@@ -4,21 +4,21 @@
 $id: http://devicetree.org/schemas/clock/qcom,gcc-ipq8064.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Global Clock & Reset Controller Binding for IPQ8064
-
-allOf:
-  - $ref: qcom,gcc.yaml#
+title: Qualcomm Global Clock & Reset Controller on IPQ8064
 
 maintainers:
   - Ansuel Smith <ansuelsmth@gmail.com>
 
 description: |
-  Qualcomm global clock control module which supports the clocks, resets and
-  power domains on IPQ8064.
+  Qualcomm global clock control module provides the clocks, resets and power
+  domains on IPQ8064.
 
-  See also:
-  - dt-bindings/clock/qcom,gcc-ipq806x.h (qcom,gcc-ipq8064)
-  - dt-bindings/reset/qcom,gcc-ipq806x.h (qcom,gcc-ipq8064)
+  See also::
+    include/dt-bindings/clock/qcom,gcc-ipq806x.h (qcom,gcc-ipq8064)
+    include/dt-bindings/reset/qcom,gcc-ipq806x.h (qcom,gcc-ipq8064)
+
+allOf:
+  - $ref: qcom,gcc.yaml#
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-ipq8074.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc-ipq8074.yaml
index ac6711ed01ba..27a0aa263afe 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc-ipq8074.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc-ipq8074.yaml
@@ -4,18 +4,17 @@
 $id: http://devicetree.org/schemas/clock/qcom,gcc-ipq8074.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Global Clock & Reset Controller Bindingfor IPQ8074
+title: Qualcomm Global Clock & Reset Controller on IPQ8074
 
 maintainers:
   - Stephen Boyd <sboyd@kernel.org>
   - Taniya Das <tdas@codeaurora.org>
 
 description: |
-  Qualcomm global clock control module which supports the clocks, resets and
-  power domains on IPQ8074.
+  Qualcomm global clock control module provides the clocks, resets and power
+  domains on IPQ8074.
 
-  See also:
-  - dt-bindings/clock/qcom,gcc-ipq8074.h
+  See also:: include/dt-bindings/clock/qcom,gcc-ipq8074.h
 
 allOf:
   - $ref: qcom,gcc.yaml#
diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-msm8660.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc-msm8660.yaml
index 09b2ea60d356..c9e985548621 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc-msm8660.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc-msm8660.yaml
@@ -4,22 +4,22 @@
 $id: http://devicetree.org/schemas/clock/qcom,gcc-msm8660.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Global Clock & Reset Controller Binding for MSM8660
+title: Qualcomm Global Clock & Reset Controller on MSM8660
 
 maintainers:
   - Stephen Boyd <sboyd@kernel.org>
   - Taniya Das <quic_tdas@quicinc.com>
 
 description: |
-  Qualcomm global clock control module which supports the clocks and resets on
+  Qualcomm global clock control module provides the clocks and resets on
   MSM8660
 
-  See also:
-  - dt-bindings/clock/qcom,gcc-msm8660.h
-  - dt-bindings/reset/qcom,gcc-msm8660.h
+  See also::
+    include/dt-bindings/clock/qcom,gcc-msm8660.h
+    include/dt-bindings/reset/qcom,gcc-msm8660.h
 
 allOf:
-  - $ref: "qcom,gcc.yaml#"
+  - $ref: qcom,gcc.yaml#
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-msm8909.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc-msm8909.yaml
index 2272ea5f78d0..6279a59c2e20 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc-msm8909.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc-msm8909.yaml
@@ -4,17 +4,16 @@
 $id: http://devicetree.org/schemas/clock/qcom,gcc-msm8909.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Global Clock & Reset Controller Binding for MSM8909
+title: Qualcomm Global Clock & Reset Controller on MSM8909
 
 maintainers:
   - Stephan Gerhold <stephan@gerhold.net>
 
 description: |
-  Qualcomm global clock control module which supports the clocks, resets and
-  power domains on MSM8909.
+  Qualcomm global clock control module provides the clocks, resets and power
+  domains on MSM8909.
 
-  See also:
-  - dt-bindings/clock/qcom,gcc-msm8909.h
+  See also:: include/dt-bindings/clock/qcom,gcc-msm8909.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-msm8916.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc-msm8916.yaml
index 2ceb1e501ef9..ad84c0f7680b 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc-msm8916.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc-msm8916.yaml
@@ -4,21 +4,21 @@
 $id: http://devicetree.org/schemas/clock/qcom,gcc-msm8916.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Global Clock & Reset Controller Binding for MSM8916 and MSM8939
+title: Qualcomm Global Clock & Reset Controller on MSM8916 and MSM8939
 
 maintainers:
   - Stephen Boyd <sboyd@kernel.org>
   - Taniya Das <quic_tdas@quicinc.com>
 
 description: |
-  Qualcomm global clock control module which supports the clocks, resets and
-  power domains on MSM8916 or MSM8939.
+  Qualcomm global clock control module provides the clocks, resets and power
+  domains on MSM8916 or MSM8939.
 
-  See also:
-  - dt-bindings/clock/qcom,gcc-msm8916.h
-  - dt-bindings/clock/qcom,gcc-msm8939.h
-  - dt-bindings/reset/qcom,gcc-msm8916.h
-  - dt-bindings/reset/qcom,gcc-msm8939.h
+  See also::
+    include/dt-bindings/clock/qcom,gcc-msm8916.h
+    include/dt-bindings/clock/qcom,gcc-msm8939.h
+    include/dt-bindings/reset/qcom,gcc-msm8916.h
+    include/dt-bindings/reset/qcom,gcc-msm8939.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-msm8976.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc-msm8976.yaml
index 4b7d69518371..d2186e25f55f 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc-msm8976.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc-msm8976.yaml
@@ -4,18 +4,17 @@
 $id: http://devicetree.org/schemas/clock/qcom,gcc-msm8976.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Global Clock & Reset Controller Binding for MSM8976
+title: Qualcomm Global Clock & Reset Controller on MSM8976
 
 maintainers:
   - Stephen Boyd <sboyd@kernel.org>
   - Taniya Das <tdas@codeaurora.org>
 
 description: |
-  Qualcomm global clock control module which supports the clocks, resets and
-  power domains on MSM8976.
+  Qualcomm global clock control module provides the clocks, resets and power
+  domains on MSM8976.
 
-  See also:
-  - dt-bindings/clock/qcom,gcc-msm8976.h
+  See also:: include/dt-bindings/clock/qcom,gcc-msm8976.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-msm8994.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc-msm8994.yaml
index 7b9fef6d9b23..8f0f20c1442a 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc-msm8994.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc-msm8994.yaml
@@ -4,17 +4,16 @@
 $id: http://devicetree.org/schemas/clock/qcom,gcc-msm8994.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Global Clock & Reset Controller Binding for MSM8994
+title: Qualcomm Global Clock & Reset Controller on MSM8994
 
 maintainers:
   - Konrad Dybcio <konrad.dybcio@somainline.org>
 
 description: |
-  Qualcomm global clock control module which supports the clocks, resets and
-  power domains on MSM8994 and MSM8992.
+  Qualcomm global clock control module provides the clocks, resets and power
+  domains on MSM8994 and MSM8992.
 
-  See also:
-  - dt-bindings/clock/qcom,gcc-msm8994.h
+  See also:: include/dt-bindings/clock/qcom,gcc-msm8994.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-msm8996.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc-msm8996.yaml
index dfc5165db9f1..f77036ace31b 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc-msm8996.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc-msm8996.yaml
@@ -4,18 +4,17 @@
 $id: http://devicetree.org/schemas/clock/qcom,gcc-msm8996.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Global Clock & Reset Controller Binding for MSM8996
+title: Qualcomm Global Clock & Reset Controller on MSM8996
 
 maintainers:
   - Stephen Boyd <sboyd@kernel.org>
   - Taniya Das <tdas@codeaurora.org>
 
 description: |
-  Qualcomm global clock control module which supports the clocks, resets and
+  Qualcomm global clock control module which provides the clocks, resets and
   power domains on MSM8996.
 
-  See also:
-  - dt-bindings/clock/qcom,gcc-msm8996.h
+  See also:: include/dt-bindings/clock/qcom,gcc-msm8996.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-msm8998.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc-msm8998.yaml
index 544a2335cf05..2d5355cf9def 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc-msm8998.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc-msm8998.yaml
@@ -4,18 +4,17 @@
 $id: http://devicetree.org/schemas/clock/qcom,gcc-msm8998.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Global Clock & Reset Controller Binding for MSM8998
+title: Qualcomm Global Clock & Reset Controller on MSM8998
 
 maintainers:
   - Stephen Boyd <sboyd@kernel.org>
   - Taniya Das <tdas@codeaurora.org>
 
 description: |
-  Qualcomm global clock control module which supports the clocks, resets and
-  power domains on MSM8998.
+  Qualcomm global clock control module provides the clocks, resets and power
+  domains on MSM8998.
 
-  See also:
-  - dt-bindings/clock/qcom,gcc-msm8998.h
+  See also:: include/dt-bindings/clock/qcom,gcc-msm8998.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-other.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc-other.yaml
index 35fc22a19000..a76c21a242d8 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc-other.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc-other.yaml
@@ -4,29 +4,29 @@
 $id: http://devicetree.org/schemas/clock/qcom,gcc-other.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Global Clock & Reset Controller Binding
+title: Qualcomm Global Clock & Reset Controller
 
 maintainers:
   - Stephen Boyd <sboyd@kernel.org>
   - Taniya Das <tdas@codeaurora.org>
 
 description: |
-  Qualcomm global clock control module which supports the clocks, resets and
-  power domains.
-
-  See also:
-  - dt-bindings/clock/qcom,gcc-ipq4019.h
-  - dt-bindings/clock/qcom,gcc-ipq6018.h
-  - dt-bindings/reset/qcom,gcc-ipq6018.h
-  - dt-bindings/clock/qcom,gcc-msm8953.h
-  - dt-bindings/clock/qcom,gcc-msm8974.h (qcom,gcc-msm8226 and qcom,gcc-msm8974)
-  - dt-bindings/reset/qcom,gcc-msm8974.h (qcom,gcc-msm8226 and qcom,gcc-msm8974)
-  - dt-bindings/clock/qcom,gcc-mdm9607.h
-  - dt-bindings/clock/qcom,gcc-mdm9615.h
-  - dt-bindings/reset/qcom,gcc-mdm9615.h
+  Qualcomm global clock control module provides the clocks, resets and power
+  domains.
+
+  See also::
+    include/dt-bindings/clock/qcom,gcc-ipq4019.h
+    include/dt-bindings/clock/qcom,gcc-ipq6018.h
+    include/dt-bindings/reset/qcom,gcc-ipq6018.h
+    include/dt-bindings/clock/qcom,gcc-msm8953.h
+    include/dt-bindings/clock/qcom,gcc-msm8974.h (qcom,gcc-msm8226 and qcom,gcc-msm8974)
+    include/dt-bindings/reset/qcom,gcc-msm8974.h (qcom,gcc-msm8226 and qcom,gcc-msm8974)
+    include/dt-bindings/clock/qcom,gcc-mdm9607.h
+    include/dt-bindings/clock/qcom,gcc-mdm9615.h
+    include/dt-bindings/reset/qcom,gcc-mdm9615.h
 
 allOf:
-  - $ref: "qcom,gcc.yaml#"
+  - $ref: qcom,gcc.yaml#
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-qcm2290.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc-qcm2290.yaml
index aec37e3f5e30..c9bec4656f6e 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc-qcm2290.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc-qcm2290.yaml
@@ -4,17 +4,16 @@
 $id: http://devicetree.org/schemas/clock/qcom,gcc-qcm2290.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Global Clock & Reset Controller Binding for QCM2290
+title: Qualcomm Global Clock & Reset Controller on QCM2290
 
 maintainers:
   - Shawn Guo <shawn.guo@linaro.org>
 
 description: |
-  Qualcomm global clock control module which supports the clocks, resets
-  and power domains on QCM2290.
+  Qualcomm global clock control module provides the clocks, resets and power
+  domains on QCM2290.
 
-  See also:
-  - dt-bindings/clock/qcom,gcc-qcm2290.h
+  See also:: include/dt-bindings/clock/qcom,gcc-qcm2290.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-qcs404.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc-qcs404.yaml
index ce06f3f8c3e3..dca5775f79a4 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc-qcs404.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc-qcs404.yaml
@@ -4,18 +4,17 @@
 $id: http://devicetree.org/schemas/clock/qcom,gcc-qcs404.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Global Clock & Reset Controller Bindingfor QCS404
+title: Qualcomm Global Clock & Reset Controller on QCS404
 
 maintainers:
   - Stephen Boyd <sboyd@kernel.org>
   - Taniya Das <tdas@codeaurora.org>
 
 description: |
-  Qualcomm global clock control module which supports the clocks, resets and
-  power domains on QCS404.
+  Qualcomm global clock control module provides the clocks, resets and power
+  domains on QCS404.
 
-  See also:
-  - dt-bindings/clock/qcom,gcc-qcs404.h
+  See also:: include/dt-bindings/clock/qcom,gcc-qcs404.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-sc7180.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc-sc7180.yaml
index e4d490e65d14..06dce0c6b7d0 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc-sc7180.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc-sc7180.yaml
@@ -4,18 +4,17 @@
 $id: http://devicetree.org/schemas/clock/qcom,gcc-sc7180.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Global Clock & Reset Controller Binding for SC7180
+title: Qualcomm Global Clock & Reset Controller on SC7180
 
 maintainers:
   - Stephen Boyd <sboyd@kernel.org>
   - Taniya Das <tdas@codeaurora.org>
 
 description: |
-  Qualcomm global clock control module which supports the clocks, resets and
-  power domains on SC7180.
+  Qualcomm global clock control module provides the clocks, resets and power
+  domains on SC7180.
 
-  See also:
-  - dt-bindings/clock/qcom,gcc-sc7180.h
+  See also:: include/dt-bindings/clock/qcom,gcc-sc7180.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-sc7280.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc-sc7280.yaml
index ea61367e5abc..947b47168cec 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc-sc7280.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc-sc7280.yaml
@@ -4,17 +4,16 @@
 $id: http://devicetree.org/schemas/clock/qcom,gcc-sc7280.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Global Clock & Reset Controller Binding for SC7280
+title: Qualcomm Global Clock & Reset Controller on SC7280
 
 maintainers:
   - Taniya Das <tdas@codeaurora.org>
 
 description: |
-  Qualcomm global clock control module which supports the clocks, resets and
-  power domains on SC7280.
+  Qualcomm global clock control module provides the clocks, resets and power
+  domains on SC7280.
 
-  See also:
-  - dt-bindings/clock/qcom,gcc-sc7280.h
+  See also:: include/dt-bindings/clock/qcom,gcc-sc7280.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-sc8180x.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc-sc8180x.yaml
index 30b5d1215fa8..6c4846b34e4b 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc-sc8180x.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc-sc8180x.yaml
@@ -4,17 +4,16 @@
 $id: http://devicetree.org/schemas/clock/qcom,gcc-sc8180x.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Global Clock & Reset Controller Binding for SC8180x
+title: Qualcomm Global Clock & Reset Controller on SC8180x
 
 maintainers:
   - Bjorn Andersson <bjorn.andersson@linaro.org>
 
 description: |
-  Qualcomm global clock control module which supports the clocks, resets and
-  power domains on SC8180x.
+  Qualcomm global clock control module provides the clocks, resets and power
+  domains on SC8180x.
 
-  See also:
-  - dt-bindings/clock/qcom,gcc-sc8180x.h
+  See also:: include/dt-bindings/clock/qcom,gcc-sc8180x.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-sc8280xp.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc-sc8280xp.yaml
index b1bf768530a3..c9d8e436d73a 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc-sc8280xp.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc-sc8280xp.yaml
@@ -4,17 +4,16 @@
 $id: http://devicetree.org/schemas/clock/qcom,gcc-sc8280xp.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Global Clock & Reset Controller Binding for SC8280xp
+title: Qualcomm Global Clock & Reset Controller on SC8280xp
 
 maintainers:
   - Bjorn Andersson <bjorn.andersson@linaro.org>
 
 description: |
-  Qualcomm global clock control module which supports the clocks, resets and
+  Qualcomm global clock control module provides the clocks, resets and
   power domains on SC8280xp.
 
-  See also:
-  - include/dt-bindings/clock/qcom,gcc-sc8280xp.h
+  See also:: include/dt-bindings/clock/qcom,gcc-sc8280xp.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-sdm660.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc-sdm660.yaml
index 68f47174b1b7..52e7412aace5 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc-sdm660.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc-sdm660.yaml
@@ -11,11 +11,11 @@ maintainers:
   - Taniya Das <quic_tdas@quicinc.com>
 
 description: |
-  Qualcomm global clock control module which supports the clocks, resets and
-  power domains on SDM630, SDM636 and SDM660
+  Qualcomm global clock control module provides the clocks, resets and power
+  domains on SDM630, SDM636 and SDM660
 
-  See also:
-  - dt-bindings/clock/qcom,gcc-sdm660.h  (qcom,gcc-sdm630 and qcom,gcc-sdm660)
+  See also::
+    include/dt-bindings/clock/qcom,gcc-sdm660.h  (qcom,gcc-sdm630 and qcom,gcc-sdm660)
 
 $ref: qcom,gcc.yaml#
 
diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-sdm845.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc-sdm845.yaml
index e169d46c78f8..68e1b7822fe0 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc-sdm845.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc-sdm845.yaml
@@ -4,18 +4,17 @@
 $id: http://devicetree.org/schemas/clock/qcom,gcc-sdm845.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Global Clock & Reset Controller Binding
+title: Qualcomm Global Clock & Reset Controller on SDM670 and SDM845
 
 maintainers:
   - Stephen Boyd <sboyd@kernel.org>
   - Taniya Das <tdas@codeaurora.org>
 
 description: |
-  Qualcomm global clock control module which supports the clocks, resets and
-  power domains on SDM845
+  Qualcomm global clock control module provides the clocks, resets and power
+  domains on SDM670 and SDM845
 
-  See also:
-  - dt-bindings/clock/qcom,gcc-sdm845.h
+  See also:: include/dt-bindings/clock/qcom,gcc-sdm845.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-sdx55.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc-sdx55.yaml
index 13ffa16e0833..68d3099c96ae 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc-sdx55.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc-sdx55.yaml
@@ -4,18 +4,17 @@
 $id: http://devicetree.org/schemas/clock/qcom,gcc-sdx55.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Global Clock & Reset Controller Binding for SDX55
+title: Qualcomm Global Clock & Reset Controller on SDX55
 
 maintainers:
   - Vinod Koul <vkoul@kernel.org>
   - Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
 
 description: |
-  Qualcomm global clock control module which supports the clocks, resets and
+  Qualcomm global clock control module provides the clocks, resets and
   power domains on SDX55
 
-  See also:
-  - dt-bindings/clock/qcom,gcc-sdx55.h
+  See also:: include/dt-bindings/clock/qcom,gcc-sdx55.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-sdx65.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc-sdx65.yaml
index 8a1419c4d465..ba62baab916c 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc-sdx65.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc-sdx65.yaml
@@ -4,17 +4,16 @@
 $id: http://devicetree.org/schemas/clock/qcom,gcc-sdx65.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Global Clock & Reset Controller Binding for SDX65
+title: Qualcomm Global Clock & Reset Controller on SDX65
 
 maintainers:
   - Vamsi krishna Lanka <quic_vamslank@quicinc.com>
 
 description: |
-  Qualcomm global clock control module which supports the clocks, resets and
-  power domains on SDX65
+  Qualcomm global clock control module provides the clocks, resets and power
+  domains on SDX65
 
-  See also:
-  - dt-bindings/clock/qcom,gcc-sdx65.h
+  See also:: include/dt-bindings/clock/qcom,gcc-sdx65.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-sm6115.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc-sm6115.yaml
index bb81a27a1b16..a5ad0a3da397 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc-sm6115.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc-sm6115.yaml
@@ -4,17 +4,16 @@
 $id: http://devicetree.org/schemas/clock/qcom,gcc-sm6115.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Global Clock & Reset Controller Binding for SM6115 and SM4250
+title: Qualcomm Global Clock & Reset Controller on SM6115 and SM4250
 
 maintainers:
   - Iskren Chernev <iskren.chernev@gmail.com>
 
 description: |
-  Qualcomm global clock control module which supports the clocks, resets and
-  power domains on SM4250/6115.
+  Qualcomm global clock control module provides the clocks, resets and power
+  domains on SM4250/6115.
 
-  See also:
-  - dt-bindings/clock/qcom,gcc-sm6115.h
+  See also:: include/dt-bindings/clock/qcom,gcc-sm6115.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-sm6125.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc-sm6125.yaml
index 03e84e15815c..8e37623788bd 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc-sm6125.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc-sm6125.yaml
@@ -4,17 +4,16 @@
 $id: http://devicetree.org/schemas/clock/qcom,gcc-sm6125.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Global Clock & Reset Controller Binding for SM6125
+title: Qualcomm Global Clock & Reset Controller on SM6125
 
 maintainers:
   - Konrad Dybcio <konrad.dybcio@somainline.org>
 
 description: |
-  Qualcomm global clock control module which supports the clocks, resets and
-  power domains on SM6125.
+  Qualcomm global clock control module provides the clocks, resets and power
+  domains on SM6125.
 
-  See also:
-  - dt-bindings/clock/qcom,gcc-sm6125.h
+  See also:: include/dt-bindings/clock/qcom,gcc-sm6125.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-sm6350.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc-sm6350.yaml
index cbe98c01c085..d1b26ab48eaf 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc-sm6350.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc-sm6350.yaml
@@ -4,17 +4,16 @@
 $id: http://devicetree.org/schemas/clock/qcom,gcc-sm6350.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Global Clock & Reset Controller Binding for SM6350
+title: Qualcomm Global Clock & Reset Controller on SM6350
 
 maintainers:
   - Konrad Dybcio <konrad.dybcio@somainline.org>
 
 description: |
-  Qualcomm global clock control module which supports the clocks, resets and
-  power domains on SM6350.
+  Qualcomm global clock control module provides the clocks, resets and power
+  domains on SM6350.
 
-  See also:
-  - dt-bindings/clock/qcom,gcc-sm6350.h
+  See also:: include/dt-bindings/clock/qcom,gcc-sm6350.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-sm8150.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc-sm8150.yaml
index 0333ccb07d8d..3ea0ff37a4cb 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc-sm8150.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc-sm8150.yaml
@@ -4,18 +4,17 @@
 $id: http://devicetree.org/schemas/clock/qcom,gcc-sm8150.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Global Clock & Reset Controller Binding for SM8150
+title: Qualcomm Global Clock & Reset Controller on SM8150
 
 maintainers:
   - Stephen Boyd <sboyd@kernel.org>
   - Taniya Das <tdas@codeaurora.org>
 
 description: |
-  Qualcomm global clock control module which supports the clocks, resets and
-  power domains on SM8150.
+  Qualcomm global clock control module provides the clocks, resets and power
+  domains on SM8150.
 
-  See also:
-  - dt-bindings/clock/qcom,gcc-sm8150.h
+  See also:: include/dt-bindings/clock/qcom,gcc-sm8150.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-sm8250.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc-sm8250.yaml
index 4e2a9cac0a91..b752542ee20c 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc-sm8250.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc-sm8250.yaml
@@ -4,18 +4,17 @@
 $id: http://devicetree.org/schemas/clock/qcom,gcc-sm8250.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Global Clock & Reset Controller Binding for SM8250
+title: Qualcomm Global Clock & Reset Controller on SM8250
 
 maintainers:
   - Stephen Boyd <sboyd@kernel.org>
   - Taniya Das <tdas@codeaurora.org>
 
 description: |
-  Qualcomm global clock control module which supports the clocks, resets and
-  power domains on SM8250.
+  Qualcomm global clock control module provides the clocks, resets and power
+  domains on SM8250.
 
-  See also:
-  - dt-bindings/clock/qcom,gcc-sm8250.h
+  See also:: include/dt-bindings/clock/qcom,gcc-sm8250.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-sm8350.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc-sm8350.yaml
index 3edbeca70a9c..703d9e075247 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc-sm8350.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc-sm8350.yaml
@@ -4,17 +4,16 @@
 $id: http://devicetree.org/schemas/clock/qcom,gcc-sm8350.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Global Clock & Reset Controller Binding for SM8350
+title: Qualcomm Global Clock & Reset Controller on SM8350
 
 maintainers:
   - Vinod Koul <vkoul@kernel.org>
 
 description: |
-  Qualcomm global clock control module which supports the clocks, resets and
-  power domains on SM8350.
+  Qualcomm global clock control module provides the clocks, resets and power
+  domains on SM8350.
 
-  See also:
-  - dt-bindings/clock/qcom,gcc-sm8350.h
+  See also:: include/dt-bindings/clock/qcom,gcc-sm8350.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-sm8450.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc-sm8450.yaml
index 102ce6862e24..9a31981fbeb2 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc-sm8450.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc-sm8450.yaml
@@ -4,17 +4,16 @@
 $id: http://devicetree.org/schemas/clock/qcom,gcc-sm8450.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Global Clock & Reset Controller Binding for SM8450
+title: Qualcomm Global Clock & Reset Controller on SM8450
 
 maintainers:
   - Vinod Koul <vkoul@kernel.org>
 
 description: |
-  Qualcomm global clock control module which supports the clocks, resets and
-  power domains on SM8450
+  Qualcomm global clock control module provides the clocks, resets and power
+  domains on SM8450
 
-  See also:
-  - dt-bindings/clock/qcom,gcc-sm8450.h
+  See also:: include/dt-bindings/clock/qcom,gcc-sm8450.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc.yaml
index 2ed27a2ef445..1ab416c83c8d 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc.yaml
@@ -4,15 +4,15 @@
 $id: http://devicetree.org/schemas/clock/qcom,gcc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Global Clock & Reset Controller Binding Common Bindings
+title: Qualcomm Global Clock & Reset Controller Common Bindings
 
 maintainers:
   - Stephen Boyd <sboyd@kernel.org>
   - Taniya Das <tdas@codeaurora.org>
 
 description: |
-  Common bindings for Qualcomm global clock control module which supports
-  the clocks, resets and power domains.
+  Common bindings for Qualcomm global clock control module providing the
+  clocks, resets and power domains.
 
 properties:
   '#clock-cells':
diff --git a/Documentation/devicetree/bindings/clock/qcom,gpucc-sdm660.yaml b/Documentation/devicetree/bindings/clock/qcom,gpucc-sdm660.yaml
index 3f70eb59aae3..0518ea963cdd 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gpucc-sdm660.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gpucc-sdm660.yaml
@@ -4,13 +4,13 @@
 $id: http://devicetree.org/schemas/clock/qcom,gpucc-sdm660.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Graphics Clock & Reset Controller Binding for SDM630 and SDM660
+title: Qualcomm Graphics Clock & Reset Controller on SDM630 and SDM660
 
 maintainers:
   - AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
 
 description: |
-  Qualcomm graphics clock control module which supports the clocks, resets and
+  Qualcomm graphics clock control module provides the clocks, resets and
   power domains on SDM630 and SDM660.
 
   See also dt-bindings/clock/qcom,gpucc-sdm660.h.
diff --git a/Documentation/devicetree/bindings/clock/qcom,gpucc-sm8350.yaml b/Documentation/devicetree/bindings/clock/qcom,gpucc-sm8350.yaml
index 0a0546c079a9..fb7ae3d18503 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gpucc-sm8350.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gpucc-sm8350.yaml
@@ -4,17 +4,16 @@
 $id: http://devicetree.org/schemas/clock/qcom,gpucc-sm8350.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Graphics Clock & Reset Controller Binding
+title: Qualcomm Graphics Clock & Reset Controller on SM8350
 
 maintainers:
   - Robert Foss <robert.foss@linaro.org>
 
 description: |
-  Qualcomm graphics clock control module which supports the clocks, resets and
-  power domains on Qualcomm SoCs.
+  Qualcomm graphics clock control module provides the clocks, resets and power
+  domains on Qualcomm SoCs.
 
-  See also:
-    dt-bindings/clock/qcom,gpucc-sm8350.h
+  See also:: include/dt-bindings/clock/qcom,gpucc-sm8350.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,gpucc.yaml b/Documentation/devicetree/bindings/clock/qcom,gpucc.yaml
index a7d0af1bd9e0..7256c438a4cf 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gpucc.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gpucc.yaml
@@ -4,23 +4,23 @@
 $id: http://devicetree.org/schemas/clock/qcom,gpucc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Graphics Clock & Reset Controller Binding
+title: Qualcomm Graphics Clock & Reset Controller
 
 maintainers:
   - Taniya Das <tdas@codeaurora.org>
 
 description: |
-  Qualcomm graphics clock control module which supports the clocks, resets and
-  power domains on Qualcomm SoCs.
+  Qualcomm graphics clock control module provides the clocks, resets and power
+  domains on Qualcomm SoCs.
 
-  See also:
-    dt-bindings/clock/qcom,gpucc-sdm845.h
-    dt-bindings/clock/qcom,gpucc-sc7180.h
-    dt-bindings/clock/qcom,gpucc-sc7280.h
-    dt-bindings/clock/qcom,gpucc-sc8280xp.h
-    dt-bindings/clock/qcom,gpucc-sm6350.h
-    dt-bindings/clock/qcom,gpucc-sm8150.h
-    dt-bindings/clock/qcom,gpucc-sm8250.h
+  See also::
+    include/dt-bindings/clock/qcom,gpucc-sdm845.h
+    include/dt-bindings/clock/qcom,gpucc-sc7180.h
+    include/dt-bindings/clock/qcom,gpucc-sc7280.h
+    include/dt-bindings/clock/qcom,gpucc-sc8280xp.h
+    include/dt-bindings/clock/qcom,gpucc-sm6350.h
+    include/dt-bindings/clock/qcom,gpucc-sm8150.h
+    include/dt-bindings/clock/qcom,gpucc-sm8250.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,mmcc.yaml b/Documentation/devicetree/bindings/clock/qcom,mmcc.yaml
index 03faab5b6a41..7d034aeec804 100644
--- a/Documentation/devicetree/bindings/clock/qcom,mmcc.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,mmcc.yaml
@@ -4,14 +4,14 @@
 $id: http://devicetree.org/schemas/clock/qcom,mmcc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Multimedia Clock & Reset Controller Binding
+title: Qualcomm Multimedia Clock & Reset Controller
 
 maintainers:
   - Jeffrey Hugo <quic_jhugo@quicinc.com>
   - Taniya Das <tdas@codeaurora.org>
 
 description: |
-  Qualcomm multimedia clock control module which supports the clocks, resets and
+  Qualcomm multimedia clock control module provides the clocks, resets and
   power domains.
 
 properties:
diff --git a/Documentation/devicetree/bindings/clock/qcom,msm8998-gpucc.yaml b/Documentation/devicetree/bindings/clock/qcom,msm8998-gpucc.yaml
index d747bb58f0a7..2d8897991663 100644
--- a/Documentation/devicetree/bindings/clock/qcom,msm8998-gpucc.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,msm8998-gpucc.yaml
@@ -4,16 +4,16 @@
 $id: http://devicetree.org/schemas/clock/qcom,msm8998-gpucc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Graphics Clock & Reset Controller Binding for MSM8998
+title: Qualcomm Graphics Clock & Reset Controller on MSM8998
 
 maintainers:
   - Taniya Das <tdas@codeaurora.org>
 
 description: |
-  Qualcomm graphics clock control module which supports the clocks, resets and
-  power domains on MSM8998.
+  Qualcomm graphics clock control module provides the clocks, resets and power
+  domains on MSM8998.
 
-  See also dt-bindings/clock/qcom,gpucc-msm8998.h.
+  See also:: include/dt-bindings/clock/qcom,gpucc-msm8998.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,q6sstopcc.yaml b/Documentation/devicetree/bindings/clock/qcom,q6sstopcc.yaml
index bbaaf1e2a203..03fa30fe9253 100644
--- a/Documentation/devicetree/bindings/clock/qcom,q6sstopcc.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,q6sstopcc.yaml
@@ -11,7 +11,7 @@ maintainers:
 
 properties:
   compatible:
-    const: "qcom,qcs404-q6sstopcc"
+    const: qcom,qcs404-q6sstopcc
 
   reg:
     items:
diff --git a/Documentation/devicetree/bindings/clock/qcom,qcm2290-dispcc.yaml b/Documentation/devicetree/bindings/clock/qcom,qcm2290-dispcc.yaml
index 973e408c6268..4a00f2d41684 100644
--- a/Documentation/devicetree/bindings/clock/qcom,qcm2290-dispcc.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,qcm2290-dispcc.yaml
@@ -4,16 +4,16 @@
 $id: http://devicetree.org/schemas/clock/qcom,qcm2290-dispcc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Display Clock & Reset Controller Binding for qcm2290
+title: Qualcomm Display Clock & Reset Controller on QCM2290
 
 maintainers:
   - Loic Poulain <loic.poulain@linaro.org>
 
 description: |
-  Qualcomm display clock control module which supports the clocks, resets and
-  power domains on qcm2290.
+  Qualcomm display clock control module provides the clocks, resets and power
+  domains on qcm2290.
 
-  See also dt-bindings/clock/qcom,dispcc-qcm2290.h.
+  See also:: include/dt-bindings/clock/qcom,dispcc-qcm2290.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,sc7180-camcc.yaml b/Documentation/devicetree/bindings/clock/qcom,sc7180-camcc.yaml
index f49027edfc44..098c8acf4bad 100644
--- a/Documentation/devicetree/bindings/clock/qcom,sc7180-camcc.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,sc7180-camcc.yaml
@@ -4,17 +4,16 @@
 $id: http://devicetree.org/schemas/clock/qcom,sc7180-camcc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Camera Clock & Reset Controller Binding for SC7180
+title: Qualcomm Camera Clock & Reset Controller on SC7180
 
 maintainers:
   - Taniya Das <tdas@codeaurora.org>
 
 description: |
-  Qualcomm camera clock control module which supports the clocks, resets and
-  power domains on SC7180.
+  Qualcomm camera clock control module provides the clocks, resets and power
+  domains on SC7180.
 
-  See also:
-  - dt-bindings/clock/qcom,camcc-sc7180.h
+  See also:: include/dt-bindings/clock/qcom,camcc-sc7180.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,sc7180-dispcc.yaml b/Documentation/devicetree/bindings/clock/qcom,sc7180-dispcc.yaml
index e94847f92770..95ad16d0abc3 100644
--- a/Documentation/devicetree/bindings/clock/qcom,sc7180-dispcc.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,sc7180-dispcc.yaml
@@ -4,16 +4,16 @@
 $id: http://devicetree.org/schemas/clock/qcom,sc7180-dispcc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Display Clock & Reset Controller Binding for SC7180
+title: Qualcomm Display Clock & Reset Controller on SC7180
 
 maintainers:
   - Taniya Das <tdas@codeaurora.org>
 
 description: |
-  Qualcomm display clock control module which supports the clocks, resets and
-  power domains on SC7180.
+  Qualcomm display clock control module provides the clocks, resets and power
+  domains on SC7180.
 
-  See also dt-bindings/clock/qcom,dispcc-sc7180.h.
+  See also:: include/dt-bindings/clock/qcom,dispcc-sc7180.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,sc7180-lpasscorecc.yaml b/Documentation/devicetree/bindings/clock/qcom,sc7180-lpasscorecc.yaml
index c54172fbf29f..f297694ef8b8 100644
--- a/Documentation/devicetree/bindings/clock/qcom,sc7180-lpasscorecc.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,sc7180-lpasscorecc.yaml
@@ -4,17 +4,16 @@
 $id: http://devicetree.org/schemas/clock/qcom,sc7180-lpasscorecc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm LPASS Core Clock Controller Binding for SC7180
+title: Qualcomm LPASS Core Clock Controller on SC7180
 
 maintainers:
   - Taniya Das <tdas@codeaurora.org>
 
 description: |
-  Qualcomm LPASS core clock control module which supports the clocks and
-  power domains on SC7180.
+  Qualcomm LPASS core clock control module provides the clocks and power
+  domains on SC7180.
 
-  See also:
-  - dt-bindings/clock/qcom,lpasscorecc-sc7180.h
+  See also:: include/dt-bindings/clock/qcom,lpasscorecc-sc7180.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,sc7180-mss.yaml b/Documentation/devicetree/bindings/clock/qcom,sc7180-mss.yaml
index 970030986a86..1e856a8a996e 100644
--- a/Documentation/devicetree/bindings/clock/qcom,sc7180-mss.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,sc7180-mss.yaml
@@ -4,16 +4,15 @@
 $id: http://devicetree.org/schemas/clock/qcom,sc7180-mss.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Modem Clock Controller Binding for SC7180
+title: Qualcomm Modem Clock Controller on SC7180
 
 maintainers:
   - Taniya Das <tdas@codeaurora.org>
 
 description: |
-  Qualcomm modem clock control module which supports the clocks on SC7180.
+  Qualcomm modem clock control module provides the clocks on SC7180.
 
-  See also:
-  - dt-bindings/clock/qcom,mss-sc7180.h
+  See also:: include/dt-bindings/clock/qcom,mss-sc7180.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,sc7280-camcc.yaml b/Documentation/devicetree/bindings/clock/qcom,sc7280-camcc.yaml
index f27ca6f03ffa..b60adbad4590 100644
--- a/Documentation/devicetree/bindings/clock/qcom,sc7280-camcc.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,sc7280-camcc.yaml
@@ -4,16 +4,16 @@
 $id: http://devicetree.org/schemas/clock/qcom,sc7280-camcc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Camera Clock & Reset Controller Binding for SC7280
+title: Qualcomm Camera Clock & Reset Controller on SC7280
 
 maintainers:
   - Taniya Das <tdas@codeaurora.org>
 
 description: |
-  Qualcomm camera clock control module which supports the clocks, resets and
+  Qualcomm camera clock control module provides the clocks, resets and
   power domains on SC7280.
 
-  See also dt-bindings/clock/qcom,camcc-sc7280.h
+  See also:: include/dt-bindings/clock/qcom,camcc-sc7280.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,sc7280-dispcc.yaml b/Documentation/devicetree/bindings/clock/qcom,sc7280-dispcc.yaml
index 2178666fb697..cfe6594a0a6b 100644
--- a/Documentation/devicetree/bindings/clock/qcom,sc7280-dispcc.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,sc7280-dispcc.yaml
@@ -4,16 +4,16 @@
 $id: http://devicetree.org/schemas/clock/qcom,sc7280-dispcc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Display Clock & Reset Controller Binding for SC7280
+title: Qualcomm Display Clock & Reset Controller on SC7280
 
 maintainers:
   - Taniya Das <tdas@codeaurora.org>
 
 description: |
-  Qualcomm display clock control module which supports the clocks, resets and
-  power domains on SC7280.
+  Qualcomm display clock control module provides the clocks, resets and power
+  domains on SC7280.
 
-  See also dt-bindings/clock/qcom,dispcc-sc7280.h.
+  See also:: include/dt-bindings/clock/qcom,dispcc-sc7280.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,sc7280-lpasscc.yaml b/Documentation/devicetree/bindings/clock/qcom,sc7280-lpasscc.yaml
index 633887dc2f8a..6151fdebbff8 100644
--- a/Documentation/devicetree/bindings/clock/qcom,sc7280-lpasscc.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,sc7280-lpasscc.yaml
@@ -4,17 +4,16 @@
 $id: http://devicetree.org/schemas/clock/qcom,sc7280-lpasscc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm LPASS Core Clock Controller Binding for SC7280
+title: Qualcomm LPASS Core Clock Controller on SC7280
 
 maintainers:
   - Taniya Das <tdas@codeaurora.org>
 
 description: |
-  Qualcomm LPASS core clock control module which supports the clocks and
-  power domains on SC7280.
+  Qualcomm LPASS core clock control module provides the clocks and power
+  domains on SC7280.
 
-  See also:
-  - dt-bindings/clock/qcom,lpass-sc7280.h
+  See also:: include/dt-bindings/clock/qcom,lpass-sc7280.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,sc7280-lpasscorecc.yaml b/Documentation/devicetree/bindings/clock/qcom,sc7280-lpasscorecc.yaml
index f50e284e5f46..447cdc447a0c 100644
--- a/Documentation/devicetree/bindings/clock/qcom,sc7280-lpasscorecc.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,sc7280-lpasscorecc.yaml
@@ -4,18 +4,18 @@
 $id: http://devicetree.org/schemas/clock/qcom,sc7280-lpasscorecc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm LPASS Core & Audio Clock Controller Binding for SC7280
+title: Qualcomm LPASS Core & Audio Clock Controller on SC7280
 
 maintainers:
   - Taniya Das <tdas@codeaurora.org>
 
 description: |
-  Qualcomm LPASS core and audio clock control module which supports the
-  clocks and power domains on SC7280.
+  Qualcomm LPASS core and audio clock control module provides the clocks and
+  power domains on SC7280.
 
-  See also:
-  - dt-bindings/clock/qcom,lpasscorecc-sc7280.h
-  - dt-bindings/clock/qcom,lpassaudiocc-sc7280.h
+  See also::
+    include/dt-bindings/clock/qcom,lpasscorecc-sc7280.h
+    include/dt-bindings/clock/qcom,lpassaudiocc-sc7280.h
 
 properties:
   clocks: true
diff --git a/Documentation/devicetree/bindings/clock/qcom,sdm845-camcc.yaml b/Documentation/devicetree/bindings/clock/qcom,sdm845-camcc.yaml
index d4239ccae917..91d1f7918037 100644
--- a/Documentation/devicetree/bindings/clock/qcom,sdm845-camcc.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,sdm845-camcc.yaml
@@ -4,16 +4,16 @@
 $id: http://devicetree.org/schemas/clock/qcom,sdm845-camcc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Camera Clock & Reset Controller Binding for SDM845
+title: Qualcomm Camera Clock & Reset Controller on SDM845
 
 maintainers:
   - Bjorn Andersson <bjorn.andersson@linaro.org>
 
 description: |
-  Qualcomm camera clock control module which supports the clocks, resets and
-  power domains on SDM845.
+  Qualcomm camera clock control module provides the clocks, resets and power
+  domains on SDM845.
 
-  See also dt-bindings/clock/qcom,camcc-sm845.h
+  See also:: include/dt-bindings/clock/qcom,camcc-sm845.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,sdm845-dispcc.yaml b/Documentation/devicetree/bindings/clock/qcom,sdm845-dispcc.yaml
index 4a3be733d042..76b53ce64e40 100644
--- a/Documentation/devicetree/bindings/clock/qcom,sdm845-dispcc.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,sdm845-dispcc.yaml
@@ -4,16 +4,16 @@
 $id: http://devicetree.org/schemas/clock/qcom,sdm845-dispcc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Display Clock & Reset Controller Binding for SDM845
+title: Qualcomm Display Clock & Reset Controller on SDM845
 
 maintainers:
   - Taniya Das <tdas@codeaurora.org>
 
 description: |
-  Qualcomm display clock control module which supports the clocks, resets and
-  power domains on SDM845.
+  Qualcomm display clock control module provides the clocks, resets and power
+  domains on SDM845.
 
-  See also dt-bindings/clock/qcom,dispcc-sdm845.h.
+  See also:: include/dt-bindings/clock/qcom,dispcc-sdm845.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,sm6115-dispcc.yaml b/Documentation/devicetree/bindings/clock/qcom,sm6115-dispcc.yaml
index 6660ff16ad1b..f802a2e7f818 100644
--- a/Documentation/devicetree/bindings/clock/qcom,sm6115-dispcc.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,sm6115-dispcc.yaml
@@ -10,11 +10,10 @@ maintainers:
   - Bjorn Andersson <andersson@kernel.org>
 
 description: |
-  Qualcomm display clock control module which supports the clocks and
-  power domains on SM6115.
+  Qualcomm display clock control module provides the clocks and power domains
+  on SM6115.
 
-  See also:
-    include/dt-bindings/clock/qcom,sm6115-dispcc.h
+  See also:: include/dt-bindings/clock/qcom,sm6115-dispcc.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,sm6375-gcc.yaml b/Documentation/devicetree/bindings/clock/qcom,sm6375-gcc.yaml
index 3c573e1a1257..295d4bb1a966 100644
--- a/Documentation/devicetree/bindings/clock/qcom,sm6375-gcc.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,sm6375-gcc.yaml
@@ -4,17 +4,16 @@
 $id: http://devicetree.org/schemas/clock/qcom,sm6375-gcc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Global Clock & Reset Controller Binding for SM6375
+title: Qualcomm Global Clock & Reset Controller on SM6375
 
 maintainers:
   - Konrad Dybcio <konrad.dybcio@somainline.org>
 
 description: |
-  Qualcomm global clock control module which supports the clocks, resets and
-  power domains on SM6375
+  Qualcomm global clock control module provides the clocks, resets and power
+  domains on SM6375
 
-  See also:
-  - dt-bindings/clock/qcom,sm6375-gcc.h
+  See also:: include/dt-bindings/clock/qcom,sm6375-gcc.h
 
 allOf:
   - $ref: qcom,gcc.yaml#
diff --git a/Documentation/devicetree/bindings/clock/qcom,sm8450-camcc.yaml b/Documentation/devicetree/bindings/clock/qcom,sm8450-camcc.yaml
index 268f4c6ae0ee..a52a83fe2831 100644
--- a/Documentation/devicetree/bindings/clock/qcom,sm8450-camcc.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,sm8450-camcc.yaml
@@ -4,16 +4,16 @@
 $id: http://devicetree.org/schemas/clock/qcom,sm8450-camcc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Camera Clock & Reset Controller Binding for SM8450
+title: Qualcomm Camera Clock & Reset Controller on SM8450
 
 maintainers:
   - Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
 
 description: |
-  Qualcomm camera clock control module which supports the clocks, resets and
-  power domains on SM8450.
+  Qualcomm camera clock control module provides the clocks, resets and power
+  domains on SM8450.
 
-  See also include/dt-bindings/clock/qcom,sm8450-camcc.h
+  See also:: include/dt-bindings/clock/qcom,sm8450-camcc.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,sm8450-dispcc.yaml b/Documentation/devicetree/bindings/clock/qcom,sm8450-dispcc.yaml
index 1cc2457f8208..1dd1f696dcd3 100644
--- a/Documentation/devicetree/bindings/clock/qcom,sm8450-dispcc.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,sm8450-dispcc.yaml
@@ -10,11 +10,10 @@ maintainers:
   - Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
 
 description: |
-  Qualcomm display clock control module which supports the clocks, resets and
-  power domains on SM8450.
+  Qualcomm display clock control module provides the clocks, resets and power
+  domains on SM8450.
 
-  See also:
-    include/dt-bindings/clock/qcom,sm8450-dispcc.h
+  See also:: include/dt-bindings/clock/qcom,sm8450-dispcc.h
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/clock/qcom,videocc.yaml b/Documentation/devicetree/bindings/clock/qcom,videocc.yaml
index 3cdbcebdc1a1..e221985e743f 100644
--- a/Documentation/devicetree/bindings/clock/qcom,videocc.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,videocc.yaml
@@ -4,21 +4,21 @@
 $id: http://devicetree.org/schemas/clock/qcom,videocc.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Video Clock & Reset Controller Binding
+title: Qualcomm Video Clock & Reset Controller
 
 maintainers:
   - Taniya Das <tdas@codeaurora.org>
 
 description: |
-  Qualcomm video clock control module which supports the clocks, resets and
-  power domains on Qualcomm SoCs.
-
-  See also:
-    dt-bindings/clock/qcom,videocc-sc7180.h
-    dt-bindings/clock/qcom,videocc-sc7280.h
-    dt-bindings/clock/qcom,videocc-sdm845.h
-    dt-bindings/clock/qcom,videocc-sm8150.h
-    dt-bindings/clock/qcom,videocc-sm8250.h
+  Qualcomm video clock control module provides the clocks, resets and power
+  domains on Qualcomm SoCs.
+
+  See also::
+    include/dt-bindings/clock/qcom,videocc-sc7180.h
+    include/dt-bindings/clock/qcom,videocc-sc7280.h
+    include/dt-bindings/clock/qcom,videocc-sdm845.h
+    include/dt-bindings/clock/qcom,videocc-sm8150.h
+    include/dt-bindings/clock/qcom,videocc-sm8250.h
 
 properties:
   compatible:
-- 
2.34.1

