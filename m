Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 948D26113EA
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 16:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbiJ1OEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 10:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbiJ1OEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 10:04:32 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF4FFC33
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 07:04:26 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id a27so185156qtw.10
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 07:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=P8oKprLw8ZYm+8GU3x4F5q2ce8H0sbZgjnP+ajJvPJI=;
        b=EvuSFD8XSe837jMobEgQmwLyHBXFuLECBBN7IL8NsbQOeJnK79KcFF6rtBZmKY6SZF
         K61FSKN8/GdEvlerc+ae7dDFs5SVDee9VVYNpkq/QaMgEbR6mUVeKmibKkBFJzwvXax2
         thJ7arKGs7GoZDFjd5c6VHK1xDS1cXAv6sdXUuZXzLh8cxLrm9MtnjVzHQ6/jcNJkulX
         fq+q75OxoYl+/DjM9rWwSYsDxqwakrSUehzQlG5EOTzLg1Mbi28fPRDqEztm8sUsd0B1
         GHuF9xDFErNgdurg6VYlsFqa+7buusI9oCzkgMEaMN4WrjXQaTIZiMPZuv8g83hCwEL7
         KqKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P8oKprLw8ZYm+8GU3x4F5q2ce8H0sbZgjnP+ajJvPJI=;
        b=NRKy1v4LSo8X0FS30WyZMrnkR+patSZEiFrpsP63Wyx7b0XKVGV+gW+YveJPOWG5jI
         R6mFyzYBL1R1Pa4LZMQ6Ggs8wBF9HraGThc0eQRKk/rzW1UFmqhskW/o+7zrPkVYcWLI
         BWn1Fva11RHY7S+MFjuaLniYgVky4dgExyYtRIS6XrIS/jX47bv4VnnJne7PcpXef+c8
         5uh9iUC9OTINopwWPrML6i9Q0kqbHpQCQ4EGOuvKq0bRsAgm1V+OneCerbYJNCIoFDvg
         8lKeFzipDjJynVuhuf+HdRTqa5dc84RF6AOnYSv6/KJ5pyMsIyTml1cqf+9qx5Hmawj2
         JmcA==
X-Gm-Message-State: ACrzQf05h8CzNZ4s2D6j8vGC+9M3iRGNRok2k4tCtmhkRNYIYhsM8bJM
        BP44sp0yxId7pV1Re4FFKzbL7A==
X-Google-Smtp-Source: AMsMyM4UqyN4iexH4H/2B3I0jFyzxPa5AYb4vXnKt17haWEFdfDUuSlvomj6hSMi1DWUp+Amq5UFaw==
X-Received: by 2002:ac8:5854:0:b0:39c:dba4:6fa0 with SMTP id h20-20020ac85854000000b0039cdba46fa0mr46658376qth.175.1666965865720;
        Fri, 28 Oct 2022 07:04:25 -0700 (PDT)
Received: from krzk-bin.. ([64.57.193.93])
        by smtp.gmail.com with ESMTPSA id w8-20020a05620a424800b006ed30a8fb21sm3028252qko.76.2022.10.28.07.04.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 07:04:24 -0700 (PDT)
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
Subject: [PATCH 1/2] dt-bindings: clock: qcom,gcc-ipq8074: use common GCC schema
Date:   Fri, 28 Oct 2022 10:03:24 -0400
Message-Id: <20221028140326.43470-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
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

Reference common Qualcomm GCC schema to remove common pieces.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 .../bindings/clock/qcom,gcc-ipq8074.yaml      | 25 +++----------------
 1 file changed, 4 insertions(+), 21 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-ipq8074.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc-ipq8074.yaml
index 21470f52ce36..ac6711ed01ba 100644
--- a/Documentation/devicetree/bindings/clock/qcom,gcc-ipq8074.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc-ipq8074.yaml
@@ -17,34 +17,17 @@ description: |
   See also:
   - dt-bindings/clock/qcom,gcc-ipq8074.h
 
+allOf:
+  - $ref: qcom,gcc.yaml#
+
 properties:
   compatible:
     const: qcom,gcc-ipq8074
 
-  '#clock-cells':
-    const: 1
-
-  '#power-domain-cells':
-    const: 1
-
-  '#reset-cells':
-    const: 1
-
-  reg:
-    maxItems: 1
-
-  protected-clocks:
-    description:
-      Protected clock specifier list as per common clock binding.
-
 required:
   - compatible
-  - reg
-  - '#clock-cells'
-  - '#power-domain-cells'
-  - '#reset-cells'
 
-additionalProperties: false
+unevaluatedProperties: false
 
 examples:
   - |
-- 
2.34.1

