Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A01962B3F3
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 08:33:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232750AbiKPHdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 02:33:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232546AbiKPHdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 02:33:05 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54CB82EF
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 23:33:04 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id t4so11269757wmj.5
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 23:33:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iPPeUQlF89WuMuKsE4L6h0ih48TI+X2n9tqxiV2tD4Q=;
        b=ImY4GLY1t/Rm4yER2CBeMhVxYLKVOewt7gDiUzCuRDac1mKXRnEUWXCfS1gwlytz7I
         VDfuGN4n7HXiRl/9Zbc6+zM84UufF2LthkeMQHDmuG+tSfpe1WJFzuzAizwDjnTxUCNf
         Ymfx4+iAlaYQu36is8mVx7V2LtE2lYkJotNVGb6+bR75g9/YFyXxD4AeoJfa2RK0j2a/
         HbgSrIi1RSTXYlD1h7hl32fv4HPw1h/notcrUL1W0yXX9c0Dol0K3kURGIjr9mKZLLxO
         CS+CtPWcItnQ+nBh0pRZ9Ok7Mwvz165GboELNavCxm/no/pptFlJBCdJNawb4mN5Z8MF
         47BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iPPeUQlF89WuMuKsE4L6h0ih48TI+X2n9tqxiV2tD4Q=;
        b=t8zg//6hBv+R2YPKuSncQZPctnlWQvaK11FLAfbSahxYov2tF5rzGAqRt9KNIDD+KZ
         0UQ1AtLg8r5bDgG4afnvfSZs8KKy6U1hfZXJ913eID372jH3TQN2Wt2+YExQy5F1zxjJ
         u3PXRgPt+6f6Euc4esos1eExxaHOmVSnoI84YjbgLN8kue+Um0l3YHk/hmctgEolIIs8
         BIOxPyxyLOgBlfUlXMvPWM39Vg1HFCfxsnnLnR1WKmHwMu2btGiE9mTIRqEb8XgfBpfr
         xo5enhur7xRBULFzCh1ye4hu1ytDEJiCKHr0NkvJ+s9xEd4e07EonxbIYq+arAUCM97a
         FKxA==
X-Gm-Message-State: ANoB5pkVn7Keg6jBajQg2SaFfdd6YhdjMc61Y9ksAlkq3aNvqqfLGrBr
        CGY3MubJS2gQSazGT+Y+/zC6Tg==
X-Google-Smtp-Source: AA0mqf61rSZif5wCcHsiohgfj7pbnGS/nsbqaryTioIkwNHJgCdkyYmo/qVHdZu7ODJRNJ2O/KmieQ==
X-Received: by 2002:a05:600c:3046:b0:3cf:cb16:f242 with SMTP id n6-20020a05600c304600b003cfcb16f242mr1205354wmh.82.1668583982753;
        Tue, 15 Nov 2022 23:33:02 -0800 (PST)
Received: from zoltan.localdomain ([167.98.215.174])
        by smtp.gmail.com with ESMTPSA id g34-20020a05600c4ca200b003cfd4e6400csm1058823wmp.19.2022.11.15.23.33.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 23:33:01 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     andersson@kernel.org, konrad.dybcio@linaro.org, agross@kernel.org,
        elder@kernel.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH net-next v3 1/5] dt-bindings: net: qcom,ipa: deprecate modem-init
Date:   Wed, 16 Nov 2022 01:32:52 -0600
Message-Id: <20221116073257.34010-2-elder@linaro.org>
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

GSI firmware for IPA must be loaded during initialization, either by
the AP or by the modem.  The loader is currently specified based on
whether the Boolean modem-init property is present.

Instead, use a new property with an enumerated value to indicate
explicitly how GSI firmware gets loaded.  With this in place, a
third approach can be added in an upcoming patch.

The new qcom,gsi-loader property has two defined values:
  - self:   The AP loads GSI firmware
  - modem:  The modem loads GSI firmware
The modem-init property must still be supported, but is now marked
deprecated.

Update the example so it represents the SC7180 SoC, and provide
examples for the qcom,gsi-loader, memory-region, and firmware-name
properties.

Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
v3:  Added Krzysztof's reviewed-by tag.
v2:  Updated description, switched example completely to SC7180.

 .../devicetree/bindings/net/qcom,ipa.yaml     | 76 ++++++++++++++-----
 1 file changed, 55 insertions(+), 21 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
index e752b76192df0..d0f34763b9383 100644
--- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
@@ -124,19 +124,29 @@ properties:
       - const: ipa-clock-enabled-valid
       - const: ipa-clock-enabled
 
+  qcom,gsi-loader:
+    enum:
+      - self
+      - modem
+    description:
+      Indicates how GSI firmware should be loaded.  If the AP loads
+      and validates GSI firmware, this property has value "self".
+      If the modem does this, this property has value "modem".
+
   modem-init:
+    deprecated: true
     type: boolean
     description:
-      If present, it indicates that the modem is responsible for
-      performing early IPA initialization, including loading and
-      validating firwmare used by the GSI.
+      This is the older (deprecated) way of indicating how GSI firmware
+      should be loaded.  If present, the modem loads GSI firmware; if
+      absent, the AP loads GSI firmware.
 
   memory-region:
     maxItems: 1
     description:
       If present, a phandle for a reserved memory area that holds
       the firmware passed to Trust Zone for authentication.  Required
-      when Trust Zone (not the modem) performs early initialization.
+      when the AP (not the modem) performs early initialization.
 
   firmware-name:
     $ref: /schemas/types.yaml#/definitions/string
@@ -155,15 +165,36 @@ required:
   - interconnects
   - qcom,smem-states
 
-# If modem-init is not present, the AP loads GSI firmware, and
-# memory-region must be specified
-if:
-  not:
-    required:
-      - modem-init
-then:
-  required:
-    - memory-region
+allOf:
+  # If qcom,gsi-loader is present, modem-init must not be present
+  - if:
+      required:
+        - qcom,gsi-loader
+    then:
+      properties:
+        modem-init: false
+
+      # If qcom,gsi-loader is "self", the AP loads GSI firmware, and
+      # memory-region must be specified
+      if:
+        properties:
+          qcom,gsi-loader:
+            contains:
+              const: self
+      then:
+        required:
+          - memory-region
+    else:
+      # If qcom,gsi-loader is not present, we use deprecated behavior.
+      # If modem-init is not present, the AP loads GSI firmware, and
+      # memory-region must be specified.
+      if:
+        not:
+          required:
+            - modem-init
+      then:
+        required:
+          - memory-region
 
 additionalProperties: false
 
@@ -194,14 +225,17 @@ examples:
         };
 
         ipa@1e40000 {
-                compatible = "qcom,sdm845-ipa";
+                compatible = "qcom,sc7180-ipa";
 
-                modem-init;
+                qcom,gsi-loader = "self";
+                memory-region = <&ipa_fw_mem>;
+                firmware-name = "qcom/sc7180-trogdor/modem/modem.mdt";
 
-                iommus = <&apps_smmu 0x720 0x3>;
+                iommus = <&apps_smmu 0x440 0x0>,
+                         <&apps_smmu 0x442 0x0>;
                 reg = <0x1e40000 0x7000>,
-                        <0x1e47000 0x2000>,
-                        <0x1e04000 0x2c000>;
+                      <0x1e47000 0x2000>,
+                      <0x1e04000 0x2c000>;
                 reg-names = "ipa-reg",
                             "ipa-shared",
                             "gsi";
@@ -219,9 +253,9 @@ examples:
                 clock-names = "core";
 
                 interconnects =
-                        <&rsc_hlos MASTER_IPA &rsc_hlos SLAVE_EBI1>,
-                        <&rsc_hlos MASTER_IPA &rsc_hlos SLAVE_IMEM>,
-                        <&rsc_hlos MASTER_APPSS_PROC &rsc_hlos SLAVE_IPA_CFG>;
+                        <&aggre2_noc MASTER_IPA 0 &mc_virt SLAVE_EBI1 0>,
+                        <&aggre2_noc MASTER_IPA 0 &system_noc SLAVE_IMEM 0>,
+                        <&gem_noc MASTER_APPSS_PROC 0 &config_noc SLAVE_IPA_CFG 0>;
                 interconnect-names = "memory",
                                      "imem",
                                      "config";
-- 
2.34.1

