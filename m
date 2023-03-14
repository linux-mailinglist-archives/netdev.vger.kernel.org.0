Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5A816B9B2A
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbjCNQTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbjCNQSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:18:05 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78674AD02C;
        Tue, 14 Mar 2023 09:17:41 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id r18so14896217wrx.1;
        Tue, 14 Mar 2023 09:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678810660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NdFLu8rYGgfYob/UUJ7xHBPYmBqXvfPClb24ZxTT2Ls=;
        b=JpZqQwUTPJ6+0dPKdp8pkWBnmAkBQRmDmeBLG1R5hScuNBgurXqhg6f9CS9tJM6dcf
         dbtEHCmoY7084ytJfNPyb3VNFwrqwO8JGzbzZVkaVTU+5K0KIL2W2KZi4oJhWaOKXyTV
         nysBTo0B5Nniouc6/cdENQyg7XmeF5tHrfiwcNmr2D3HoskORuAVYQFSHAlYqpxD0I1A
         mj1in4u/WLib6EWCjAjDkn/8WDPuTpggfA4YwQcGWCmrckfVXvh+oNp4fTzTfRO8AgLP
         pTG5CRyGfZLAKACSx6iWnn8/UPyofP5yWu5Qt+h2bYJbwQb48UqqDwF5tuZH155Yr/Qg
         8VBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678810660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NdFLu8rYGgfYob/UUJ7xHBPYmBqXvfPClb24ZxTT2Ls=;
        b=bHRBI0F+RBpzpZE82La0CNfqVBX22arAPE9thCx74GLnwH5MfYz2fzyFC8zQF14hEz
         ZbmGBQHMSybaelZQFtxKA0Pe4WNz6bNyU9AFAdQqisMPdJf3VZjxApk0CoWb0ZauOopK
         REf2c5sYRANOFHP0XzMhvpfrqa2PJYl2uOKtw6hcDDJEpKDSqkmhXH0jBUjLL5lbOODt
         irW7m7cD5snsM8+2W3QHG+PIWooDp5A7TT27JxcseKrGUh2snsGk70LhIPVPk7P29640
         asNTMBiP2bVtb66zMNq54vsCPLD3u8UbYFMREkBu1Sk6VVljM6lSEU0cPsL7nWd1Javi
         tZDw==
X-Gm-Message-State: AO0yUKVHKr7+VYoG2GVKQkQ5qRX4p13Azn1U8IHJhFi7E5Hy8vOsS7NO
        BBZJeozOHUUVrtWvzIhy45A=
X-Google-Smtp-Source: AK7set8Picyqs6bN985CzCJP1jG1yy0KAX7/1lzUL7SerOixkP84/5d9uY2xHWjsVb4VTm2ObkfR1g==
X-Received: by 2002:a5d:48cb:0:b0:2cf:ea5d:f607 with SMTP id p11-20020a5d48cb000000b002cfea5df607mr1917592wrs.17.1678810659677;
        Tue, 14 Mar 2023 09:17:39 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id a16-20020a5d4570000000b002c5539171d1sm2426821wrc.41.2023.03.14.09.17.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 09:17:39 -0700 (PDT)
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
Subject: [net-next PATCH v3 13/14] dt-bindings: net: phy: Document support for LEDs node
Date:   Tue, 14 Mar 2023 11:15:15 +0100
Message-Id: <20230314101516.20427-14-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314101516.20427-1-ansuelsmth@gmail.com>
References: <20230314101516.20427-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
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

