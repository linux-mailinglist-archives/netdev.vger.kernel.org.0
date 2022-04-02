Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C03344F049F
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 17:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357515AbiDBP56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Apr 2022 11:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357511AbiDBP55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Apr 2022 11:57:57 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD5A517ABF
        for <netdev@vger.kernel.org>; Sat,  2 Apr 2022 08:56:01 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id qh7so1659155ejb.11
        for <netdev@vger.kernel.org>; Sat, 02 Apr 2022 08:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EuVHQKj00KiyE/jfkOjZYn3vY7PV3FTcEesPbvXU4jo=;
        b=eiKtSHZaOzxi0xEi2h4siGI7VE6mBVjFN6OJR24q1WgvVZ6kSRaOUEDYuBaigafCPm
         zJJwX0s57Try+onBevGkRSMSRmMjtD2jnHEnGMA7LKBMXjK7P3pPp92V5LzK7crnLpka
         gNzmNC+uGs1cNb83fwTIhpyAsCze1i38mKbswtxQVju+eTgpR1OMheczD7S1Lro8XjKd
         F1it+0NbsGC9TPrDGfdKtPmpX5XwS64ATtDTieFE40f87SbPMhMZnflYrRgzPXrgYuYH
         ofePZTxy65EZlp8mPIp02snTHluS3UJDHZ/KiIN4N+GHk4Ab3R8TYdHC3M7KIdx3Z25h
         xSiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EuVHQKj00KiyE/jfkOjZYn3vY7PV3FTcEesPbvXU4jo=;
        b=RpY88TVlS35y7Mn6r8vaUChIsll0rUzDVu0U1MVwbqOfDPlCo4eJeATFUuwrD/0ifN
         oPiekDealJfeUgDxjS4BBZRhtEmfe9lcmdq/kFuGhRiSnSwyCbNStDYMCEWc1pHhEzte
         6BasWVjfmEzP2MycUu1uaQ3rBZOnorR6Evk3XV3T48GtnSRmUwg5JWlI8Hk+9/vHh8X2
         ovIJpwznFTVociP5hKX/wGW5CMOC4yH4b+IU/jC3TEyNyPKKKaGhPRwKGgLVUTHXi35Z
         mCAsOjccM31qIbks1/+2wFQxTZ4AEwZxYy2Cp8NK+CPNVmrt9xicqyzWlIFof9G4mJMp
         t5TQ==
X-Gm-Message-State: AOAM533k6sFXywzy5KnGbqELg31vGbzY2NvLwwX6dmLPuIkP0jfaM6bC
        UdAwdW9PP8j2O5jQv5Mi+OagdQ==
X-Google-Smtp-Source: ABdhPJxfLuqMATYwK9iSwU7NsddkjCUqupSmfKJN4fjzjdy/zsVfgOnyfdOxpAIE3kuLumpuxTC3uA==
X-Received: by 2002:a17:907:1ca8:b0:6df:f192:cf4a with SMTP id nb40-20020a1709071ca800b006dff192cf4amr4469091ejc.620.1648914960455;
        Sat, 02 Apr 2022 08:56:00 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.gmail.com with ESMTPSA id b12-20020a170906038c00b006e4e48969d2sm1479331eja.88.2022.04.02.08.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Apr 2022 08:55:59 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Manivannan Sadhasivam <mani@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Alex Elder <elder@kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 1/2] dt-bindings: mailbox: qcom-ipcc: simplify the example
Date:   Sat,  2 Apr 2022 17:55:50 +0200
Message-Id: <20220402155551.16509-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Consumer examples in the bindings of resource providers are trivial,
useless and duplicating code.  Additionally the incomplete qcom,smp2p
example triggers DT schema warnings.

Cleanup the example by removing the consumer part and fixing the
indentation to DT schema convention.

Reported-by: Rob Herring <robh@kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 .../bindings/mailbox/qcom-ipcc.yaml           | 29 +++++++------------
 1 file changed, 10 insertions(+), 19 deletions(-)

diff --git a/Documentation/devicetree/bindings/mailbox/qcom-ipcc.yaml b/Documentation/devicetree/bindings/mailbox/qcom-ipcc.yaml
index 866efb278813..dfdc72345a2a 100644
--- a/Documentation/devicetree/bindings/mailbox/qcom-ipcc.yaml
+++ b/Documentation/devicetree/bindings/mailbox/qcom-ipcc.yaml
@@ -61,23 +61,14 @@ additionalProperties: false
 
 examples:
   - |
-        #include <dt-bindings/interrupt-controller/arm-gic.h>
-        #include <dt-bindings/mailbox/qcom-ipcc.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/mailbox/qcom-ipcc.h>
 
-        mailbox@408000 {
-                compatible = "qcom,sm8250-ipcc", "qcom,ipcc";
-                reg = <0x408000 0x1000>;
-                interrupts = <GIC_SPI 229 IRQ_TYPE_LEVEL_HIGH>;
-                interrupt-controller;
-                #interrupt-cells = <3>;
-                #mbox-cells = <2>;
-        };
-
-        smp2p-modem {
-                compatible = "qcom,smp2p";
-                interrupts-extended = <&ipcc_mproc IPCC_CLIENT_MPSS
-                                IPCC_MPROC_SIGNAL_SMP2P IRQ_TYPE_EDGE_RISING>;
-                mboxes = <&ipcc_mproc IPCC_CLIENT_MPSS IPCC_MPROC_SIGNAL_SMP2P>;
-
-                /* Other SMP2P fields */
-        };
+    mailbox@408000 {
+        compatible = "qcom,sm8250-ipcc", "qcom,ipcc";
+        reg = <0x408000 0x1000>;
+        interrupts = <GIC_SPI 229 IRQ_TYPE_LEVEL_HIGH>;
+        interrupt-controller;
+        #interrupt-cells = <3>;
+        #mbox-cells = <2>;
+    };
-- 
2.32.0

