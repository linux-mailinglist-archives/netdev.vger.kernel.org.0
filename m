Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7EF7698A1D
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 02:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbjBPBhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 20:37:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjBPBhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 20:37:25 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEDC7460B5;
        Wed, 15 Feb 2023 17:36:34 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id s13-20020a05600c45cd00b003ddca7a2bcbso436629wmo.3;
        Wed, 15 Feb 2023 17:36:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uTcoFKmrwtKXbMa5FAugHsIQ8yhWeFxvv6LPTwygdbQ=;
        b=XSoEXiByeWPpHfIqJQlbE7w36QGh178vjtpkbhJUGtG84VWiJSLVhHp0hDDS5AnzTj
         Obq7ppupjEKKAr+SUuLzJaoAYEJEAX7e1Qu+JpBZ/CmdqdD1meX05ECu9D+fNHCIdFAB
         MLW44RF+XOS8MV/F24zqNyNyoBxmTXLqdlWAdla6ObXgkBbyXbCz2kJs3wLnCSBOx8DQ
         jSV/6iPIe+y1fcKdeIzBF3cVSKn3+IKr/gvWmpOAUmQhPkeRL1529XVaQasaRobyddsO
         RBhclyq0NfdSDS6qLzEHQZvyQn59w71JafsaAlUsdK+TmryrU46Sk4KF4OGa93eT2EbC
         YdtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uTcoFKmrwtKXbMa5FAugHsIQ8yhWeFxvv6LPTwygdbQ=;
        b=cWyjq1jL8UcCeZNczAvoB+M8Q2K94duGvTbUeoM/+yy1JvCcJHDrgd4pMociH6+Rem
         C5o/KJfgJHVZ9ufiVj7Pfwsxxo6rK9aJQK0ANEoOPbi65zC3DcaXyTOgjufz5FU7vg2p
         zSscV49Mxr/auo+0alkruoUSUpWpA9ueyguRJctNEyhaONc9rFGF3ZVv8X5DOxKykFJV
         st2IDOwKOvVjQ/SEV3TNN9MJs+Vn1bPFRZ+4qKrjclb7/lLQ2L5vogk2RcQ3Z3mMvOXv
         USFwddYcJjUL3tTi7qJh3H2cMHs5IpHxiprfXiDDjuTtyHRjYSg7TxBz3BA7VQlf1xuu
         SEeA==
X-Gm-Message-State: AO0yUKV5LU17XpgsoHx34VQQUmXjisXKtmWk1qkTDXg3mrDgHt+ooH54
        NCpbGgwgqHqCZVNZsGuJ1gk=
X-Google-Smtp-Source: AK7set/E1wkZ6srvhP22ltPxKprRdznZm5iP1MIP1So73+Ob+qVd4T38CJycWkjRYNZCtvR/vZGQLg==
X-Received: by 2002:a05:600c:4d97:b0:3e2:6c8:65b with SMTP id v23-20020a05600c4d9700b003e206c8065bmr2187995wmp.25.1676511393145;
        Wed, 15 Feb 2023 17:36:33 -0800 (PST)
Received: from localhost.localdomain (93-34-91-73.ip49.fastwebnet.it. [93.34.91.73])
        by smtp.googlemail.com with ESMTPSA id v15-20020a05600c214f00b003e1fb31fc2bsm64189wml.37.2023.02.15.17.36.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 17:36:32 -0800 (PST)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        Christian Marangi <ansuelsmth@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Arun.Ramadoss@microchip.com
Subject: [PATCH v8 12/13] dt-bindings: net: phy: Document support for leds node
Date:   Thu, 16 Feb 2023 02:32:29 +0100
Message-Id: <20230216013230.22978-13-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230216013230.22978-1-ansuelsmth@gmail.com>
References: <20230216013230.22978-1-ansuelsmth@gmail.com>
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

Document support for leds node in phy and add an example for it.
Phy led will have to match led-phy pattern and should be treated as a
generic led.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 .../devicetree/bindings/net/ethernet-phy.yaml | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
index 1327b81f15a2..34a5a688c13b 100644
--- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
@@ -197,6 +197,13 @@ properties:
       PHY's that have configurable TX internal delays. If this property is
       present then the PHY applies the TX delay.
 
+  leds:
+    type: object
+
+    patternProperties:
+      '^led-phy(@[a-f0-9]+)?$':
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
+                led-phy@0 {
+                    reg = <0>;
+                    color = <LED_COLOR_ID_WHITE>;
+                    function = LED_FUNCTION_LAN;
+                    function-enumerator = <1>;
+                    linux,default-trigger = "netdev";
+                };
+            };
         };
     };
-- 
2.38.1

