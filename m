Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92F92698A23
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 02:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbjBPBiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 20:38:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbjBPBh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 20:37:29 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C86F945F70;
        Wed, 15 Feb 2023 17:36:43 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id y1so453699wru.2;
        Wed, 15 Feb 2023 17:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+hZ4FOjKbPsdT5yxQsZyvCeHCblBaNw+opiskrre9LM=;
        b=Yzxas/XGAd0Vjd5xG2zHPk0/D0Hqne4JUyQ7KRQRg8tNWAXYVRsMePCDehMzhoAkS6
         8Ul/yMSUhyVWmtdD+SzVGafo6NCDiZYWVD+BNFHNBvw6gIDuun04iBt6hyyD1vIYB0e8
         4P81uWP50PllM0TETSnQmswhQeKQSLFV89NkjUD5h6EZ7xfMd+rtypMB0HJDkKwvV6WB
         iidWN59UyrS+sxjq0cZNthJMKmGTWV2I2kzGRW85e7g2MnHVv/BRIO4opKcXmwlGjwd9
         7SLG/OJWtVNB6VNnE5sNMOJUpHoSZIhQ9rrpH67e/2/ujkv9cQm13nvXU4+y7ARgKm0e
         YFuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+hZ4FOjKbPsdT5yxQsZyvCeHCblBaNw+opiskrre9LM=;
        b=1rkQrUGL4rpW56tIFnAVxrOoIzcG4F+JY07hVrqhmM0DXB3I4ee1xHCNk9+gBCIfBF
         i6Cp89Ds103wWqyBADAqcguLrGOXzTOGmflf9HaHCkmIDnSHV6d7qR/dEkuPsMkYD5fo
         Ww+rsMkgdbqzz8jEuXqW7+XHNUcoYB28XavcXyxSxv6xTUZFl7aN6c2of0L7wEdDXghl
         FnO05EMZJgMyOIIOHYL1NozNo8pttLrs5+6QN4fPT/il6MkDDlQyhh+bXWn1NDhsj8vD
         Adglu03DfslEeF0RtQvO3qyap6w3cg2nLKaGLhRFzJ6D3/j0uQ8Q9czRr+bECLEoGfAK
         4vxA==
X-Gm-Message-State: AO0yUKW3McdwoFpiyx9Rrb+r2+IJ3JfP1FS0klfkElvvh+UnkwB/GE32
        WnXvpDoFUfEoSsoGPM+P2VM=
X-Google-Smtp-Source: AK7set9cbwieqzJnsPgi/x1zFPNxp18QtOCEuGPVY3+sNpAUi4rY3xICSmOKfVUyElsilvF1C2mM/g==
X-Received: by 2002:adf:fa4d:0:b0:2c5:4ffa:ba62 with SMTP id y13-20020adffa4d000000b002c54ffaba62mr2990533wrr.17.1676511394561;
        Wed, 15 Feb 2023 17:36:34 -0800 (PST)
Received: from localhost.localdomain (93-34-91-73.ip49.fastwebnet.it. [93.34.91.73])
        by smtp.googlemail.com with ESMTPSA id v15-20020a05600c214f00b003e1fb31fc2bsm64189wml.37.2023.02.15.17.36.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 17:36:34 -0800 (PST)
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
Subject: [PATCH v8 13/13] dt-bindings: net: dsa: qca8k: add LEDs definition example
Date:   Thu, 16 Feb 2023 02:32:30 +0100
Message-Id: <20230216013230.22978-14-ansuelsmth@gmail.com>
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

Add LEDs definition example for qca8k using the offload trigger as the
default trigger and add all the supported offload triggers by the
switch.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 .../devicetree/bindings/net/dsa/qca8k.yaml    | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
index 389892592aac..ba3821364039 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
@@ -18,6 +18,8 @@ description:
   PHY it is connected to. In this config, an internal mdio-bus is registered and
   the MDIO master is used for communication. Mixed external and internal
   mdio-bus configurations are not supported by the hardware.
+  Each phy have at least 3 LEDs connected and can be declared
+  using the standard LEDs structure.
 
 properties:
   compatible:
@@ -117,6 +119,7 @@ unevaluatedProperties: false
 examples:
   - |
     #include <dt-bindings/gpio/gpio.h>
+    #include <dt-bindings/leds/common.h>
 
     mdio {
         #address-cells = <1>;
@@ -276,6 +279,27 @@ examples:
 
                 internal_phy_port1: ethernet-phy@0 {
                     reg = <0>;
+
+                    leds {
+                        #address-cells = <1>;
+                        #size-cells = <0>;
+
+                        led@0 {
+                            reg = <0>;
+                            color = <LED_COLOR_ID_WHITE>;
+                            function = LED_FUNCTION_LAN;
+                            function-enumerator = <1>;
+                            linux,default-trigger = "netdev";
+                        };
+
+                        led@1 {
+                            reg = <1>;
+                            color = <LED_COLOR_ID_AMBER>;
+                            function = LED_FUNCTION_LAN;
+                            function-enumerator = <1>;
+                            linux,default-trigger = "netdev";
+                        };
+                    };
                 };
 
                 internal_phy_port2: ethernet-phy@1 {
-- 
2.38.1

