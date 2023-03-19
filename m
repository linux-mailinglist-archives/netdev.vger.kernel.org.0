Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2AAF6C044F
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 20:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbjCSTUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 15:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbjCSTT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 15:19:28 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A430615161;
        Sun, 19 Mar 2023 12:18:56 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id o7so8528636wrg.5;
        Sun, 19 Mar 2023 12:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679253534;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NdFLu8rYGgfYob/UUJ7xHBPYmBqXvfPClb24ZxTT2Ls=;
        b=Y66KPWA5vwHugBdTXrY7CbixTqvqjjH7vT61EExGPAvQRGNeJNyQoafpa1X3zexgtC
         SwiR7QybF7NLHUNAGaDn2E3ZT2YRT8vGI3AXgIWL1wnnQDtKUrX5V5ESdNKC1zQOm7r/
         8q5zm9oNoAC+FcUGuaJjsZbWpCC/wzdK0VS6ogdK6CxOSLOqR1P1yEEM6IGB9I/DuEZC
         gk1h6lf/IljiB3orML6t4l5G5x06pfqdBLq2Dw3f55HkJiIhfBDKEE+gQxwP2HlRhEr4
         hNe2uCvwwIo9Pi8FH4a1DZZJQQVbXxvdlFRFlNNuS06pNPhaMITN3QzskZxfhbapK/iJ
         0lhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679253534;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NdFLu8rYGgfYob/UUJ7xHBPYmBqXvfPClb24ZxTT2Ls=;
        b=aEfE/T2Cv7KwLNOHzIqqZzgzylQGCqnSsvkGUAqHDddvUsYR0AQwY6ssC6ujLAxIM2
         NpAslFVkTsOj1TWLXXfRZb5zpUtBQeN/oU0futsgqTl7ACntweMpKAQeFlr5p2zjYUid
         aZKNZVtGNgjTJx08Er2Wfd+nAV/dSAd+I1OHfqqFNPuQuyj9o1u4ZuwnXY4HOarBCS+s
         8o6eretUZmCEebncv7kcMNQKwWJ32isGlz9aChoCVW3kt1+kf+AXf9LlH0zGMqR0IGzg
         9rtbjq781GCoAwlPh2Xclp8BfxRXlEHeTR5nOl/BmL0FHtZ7IQkYunR0GVdStKleoBLG
         Jufw==
X-Gm-Message-State: AO0yUKUGZKLgx0KePsfdzqeknVT8xuW8tadpVYWq8jrquaDL15DpHYd1
        AB6M5tVGqXExRXim1mM6NVk=
X-Google-Smtp-Source: AK7set+g4djahWrxlbAtNWVp0F2JcTlFwac90ayuwSosW7HTFtGReZoUT/EVNakWZkSBm/GoZfBXKA==
X-Received: by 2002:a5d:4dd1:0:b0:2ce:a250:df68 with SMTP id f17-20020a5d4dd1000000b002cea250df68mr12280592wru.28.1679253534443;
        Sun, 19 Mar 2023 12:18:54 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id b7-20020a5d4b87000000b002cfe0ab1246sm7165167wrt.20.2023.03.19.12.18.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 12:18:54 -0700 (PDT)
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
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org
Subject: [net-next PATCH v5 14/15] dt-bindings: net: phy: Document support for LEDs node
Date:   Sun, 19 Mar 2023 20:18:13 +0100
Message-Id: <20230319191814.22067-15-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230319191814.22067-1-ansuelsmth@gmail.com>
References: <20230319191814.22067-1-ansuelsmth@gmail.com>
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

