Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 577D46AF8D9
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 23:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbjCGWeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 17:34:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbjCGWdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 17:33:53 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F399E648;
        Tue,  7 Mar 2023 14:33:38 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id j19-20020a05600c191300b003eb3e1eb0caso98581wmq.1;
        Tue, 07 Mar 2023 14:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678228417;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mgeBlw3VjdW/ldP+cajTBrUisBQA46tb0yJFn1SOwVk=;
        b=fitLZbSPSJM75E9+zI7CdJ7TUfah6PtmiyFM5bzoV6sl7dCbP274l7oarusXWlTqUY
         YEp9EXKKOzyQgmX7aZ0L4NpsrwPklYjGsiGedsZbvFz550iw9lBr3AfB7dY+xh39hKbu
         ke37ECxuqyxp5o6QeFFVbY7zdd7cSxVm55IhSiwRj0wihkDpLU2BrKReBA9YjZ6CwbyS
         SR9W5JElaNYn5JJ8X2U0yshj8b/nKSSnBmDdrcXlnb4JlsPnDTE235oqbxgVaCo6q/lz
         GYjB/I+uM/A8O+z1zdYKgrHiFPuu9MXCkANG3sqwrJ3ASstOL3rmaUOeMsFkeSNwXrw1
         RjAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678228417;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mgeBlw3VjdW/ldP+cajTBrUisBQA46tb0yJFn1SOwVk=;
        b=3FhCzfZacI9rj700vNsZ9aS328a/55XZrRJUhTE0CRupTt6ymqapLvRUM8JBeLhNFU
         LySDzDqJOVj7UW3wFJAYU46oeBkrRBXn91+xQkXdvx7Xkunk11TU6CIOfJZjNaNnTBEw
         f7lq0ww3fgpbvLrA7hBou9NxfIqmenj+9+YMn2w2s4rn3nSHhHmS6dFWuv6WiuuyAER8
         e3ElT3pu49NyjIMUf31QQ7dNel3Yjcjjjs0FVaz+gflBdnPgW+7hFBszXV0JwgAdZf8z
         NFSeVDVtUpWlU0jn3ImvVDIDLoQtkx0PiwdAbYKP/BGozsbD4Jjqufj6WuZq6PGWxrsP
         PwpA==
X-Gm-Message-State: AO0yUKVRkXeVOyzNDA2Jlw0DnXJWyItcm7XApO2D10QBrETwoth7zFrP
        DQHFp9HycY4bzK1H7k91UhE=
X-Google-Smtp-Source: AK7set+d0cJ+BvJcd//rk9RtVWY2LDBHuVBYbi3zKsAXhcdNZJ+R5K6OG0r3lX/vDFrVVxmJcPt5eA==
X-Received: by 2002:a05:600c:4750:b0:3eb:395b:8b62 with SMTP id w16-20020a05600c475000b003eb395b8b62mr14710572wmo.39.1678228417182;
        Tue, 07 Mar 2023 14:33:37 -0800 (PST)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id q11-20020a05600c46cb00b003dc1d668866sm19233101wmo.10.2023.03.07.14.33.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 14:33:36 -0800 (PST)
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
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: [net-next PATCH 10/11] dt-bindings: net: phy: Document support for LEDs node
Date:   Tue,  7 Mar 2023 18:00:45 +0100
Message-Id: <20230307170046.28917-11-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170046.28917-1-ansuelsmth@gmail.com>
References: <20230307170046.28917-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
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
---
 .../devicetree/bindings/net/ethernet-phy.yaml | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
index 1327b81f15a2..0ec8ef6b0d8a 100644
--- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
@@ -197,6 +197,13 @@ properties:
       PHY's that have configurable TX internal delays. If this property is
       present then the PHY applies the TX delay.
 
+  leds:
+    type: object
+
+    patternProperties:
+      '^led(@[a-f0-9]+)?$':
+        $ref: /schemas/leds/common.yaml#
+
 required:
   - reg
 
@@ -204,6 +211,8 @@ additionalProperties: true
 
 examples:
   - |
+    #include <dt-bindings/leds/common.h>
+
     ethernet {
         #address-cells = <1>;
         #size-cells = <0>;
@@ -219,5 +228,18 @@ examples:
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

