Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC246BDEE4
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 03:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjCQCeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 22:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbjCQCeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 22:34:01 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7B61732;
        Thu, 16 Mar 2023 19:33:37 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id o7so3191348wrg.5;
        Thu, 16 Mar 2023 19:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679020417;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NdFLu8rYGgfYob/UUJ7xHBPYmBqXvfPClb24ZxTT2Ls=;
        b=DutLKUovGo5Smee1OxymH+55w+jweIRW6b8/LTpEqvWGEybiYS1/mq7Uhli8Ckl++x
         h3SNVQw0nglbYfDxSz1basFNpUIZKemuqyxkuGJQiK3vkVxCsbyt7VZcyFDeKiCUJ1Df
         k8H/tCpTwfqPf8ib877IwGVmDQbMx7hiQjimW5bMfaJF1Buna93ft10bQPtK59YzDmcs
         ONaiS7H/9xJGD3jKeWYfYJAHXKhb8foSZkTvfkZcOnwJ01LY+g+VAFqCbLtSZW0gfLRs
         +T5raXr2+YgW3O3I/i5zNXrpEU+AFmTmm3wj4VrngFKCG37BTJxlmq+cnkGPOfzuwogJ
         a5eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679020417;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NdFLu8rYGgfYob/UUJ7xHBPYmBqXvfPClb24ZxTT2Ls=;
        b=H7zWvxrEL+qLBPe7c8PkxndGHJWnoFNTOVEho/lIelsXEntJdLBrb8Mz+Z2IoF+Y1R
         ZIDdLdxhn80C4y6TctCOI6LyjYEVdb2RYFkK07U34D7H8zMwnpRxmcEQ2jgUyyGhld1p
         +w0niPsH0MdLDW36IVW6LTGZQ7K6dNHlyC2wK87PiYM4WIqYNcejfeJ/U8e8+Yqj6ZV/
         z+slK7qU6zNyw8uWrQ622q868m29NHSm+wwDlx1qVKZSoAkeSuGOoNqj3aZuwZf5eJ78
         hWGXCP+Grsyoyq8I2UkHBv8XEphznYJpP0tX6KBABACPJudty6DSOYqQYdf/LeJHZeCN
         h70Q==
X-Gm-Message-State: AO0yUKW7h5Tka4Yklw/x8JX2uwvKgs/r3v3IfuFO4DsHmtym+bqsJk0j
        J3LWemZFGzpputqyS5pUGPM=
X-Google-Smtp-Source: AK7set9V/3xd8DaULwMWrn7GwNk0kslsUji6r7WhiD/CIbzOoiS/nUbqUuVhyYnTubPVK3JR1op2rg==
X-Received: by 2002:adf:d845:0:b0:2cf:e132:bfbb with SMTP id k5-20020adfd845000000b002cfe132bfbbmr5896016wrl.38.1679020417006;
        Thu, 16 Mar 2023 19:33:37 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id z15-20020a5d44cf000000b002ce9f0e4a8fsm782313wrr.84.2023.03.16.19.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 19:33:36 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: [net-next PATCH v4 13/14] dt-bindings: net: phy: Document support for LEDs node
Date:   Fri, 17 Mar 2023 03:31:24 +0100
Message-Id: <20230317023125.486-14-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230317023125.486-1-ansuelsmth@gmail.com>
References: <20230317023125.486-1-ansuelsmth@gmail.com>
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

Document support for LEDs node in phy and add an example for it.
PHY LED will have to match led pattern and should be treated as a
generic led.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 .../devicetree/bindings/net/ethernet-phy.yaml | 31 +++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
index 1327b81f15a2..84e15cee27c7 100644
--- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
@@ -197,6 +197,22 @@ properties:
       PHY's that have configurable TX internal delays. If this property is
       present then the PHY applies the TX delay.
 
+  leds:
+    type: object
+
+    properties:
+      '#address-cells':
+        const: 1
+
+      '#size-cells':
+        const: 0
+
+    patternProperties:
+      '^led(@[a-f0-9]+)?$':
+        $ref: /schemas/leds/common.yaml#
+
+    additionalProperties: false
+
 required:
   - reg
 
@@ -204,6 +220,8 @@ additionalProperties: true
 
 examples:
   - |
+    #include <dt-bindings/leds/common.h>
+
     ethernet {
         #address-cells = <1>;
         #size-cells = <0>;
@@ -219,5 +237,18 @@ examples:
             reset-gpios = <&gpio1 4 1>;
             reset-assert-us = <1000>;
             reset-deassert-us = <2000>;
+
+            leds {
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                led@0 {
+                    reg = <0>;
+                    color = <LED_COLOR_ID_WHITE>;
+                    function = LED_FUNCTION_LAN;
+                    function-enumerator = <1>;
+                    default-state = "keep";
+                };
+            };
         };
     };
-- 
2.39.2

