Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0308C6AF8D6
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 23:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbjCGWeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 17:34:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbjCGWdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 17:33:53 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D6AA02A9;
        Tue,  7 Mar 2023 14:33:37 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id k37so8794636wms.0;
        Tue, 07 Mar 2023 14:33:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678228416;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1wDcE5BTiRUWu5IpXdTXJGaa7mTD/67d24QZlEDxG4g=;
        b=WDoaAo6JIUdl2kw+jFWE8rMH0sejm6rC1azuVDxCr7JZJh+7YHIGproCgk3ja9SsG8
         ahK/Z9tGQ0hexAtbKI8a2mIcpca1UlAe6E3GWIc5+HIKMds9jsQGnSJDLvHG0Da/HLVs
         3r43uj8OwxIV80rQYuayBkTjeZoPyE1jycr/p12/fS8dQfVrKQObz5V5jEKGHiv36wU5
         9OnWJtGNlS1+NqUJArkJHVP+vdCFbttDjbF7RgAyUvVqy10g0i7DL7NytX6fXq4mzxmw
         /Jir8tDLcLDkMsC7PHJvb3CA7b6+r20eWcos5CIaR7/MhYtwlOK3idxCVcXwWvAX2XCe
         bJhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678228416;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1wDcE5BTiRUWu5IpXdTXJGaa7mTD/67d24QZlEDxG4g=;
        b=wjuuCHE5OXFDxoi0HAXfr3kAC38R+f83ThPk8jzPqNqp1EuBMSyLXGVI+A9TWvyh0/
         jSdPkB2jV7rjaOPFeYl1qxA77qtgGG/SLfG9Q3NPO7H/9k3O+C3i9HbqI5DfL4OkX44X
         yrSxxhg3/2ij0HLBEtkHN+QOfNE1UAMvJQ9ljzoP76tT4LDbW5s7uhPnAyrzY2luxBt+
         oub4itDSn//bM1I9YEcP24wdr+NbvmTojv2Mh/ZCIobBE8NUpF1p3a32U02wR8UeBY/z
         m4bsxaiw5WHYKFqkPjXMLvJpMxijpJ5bHIHk3UJ13aI5TxzSmIznS+uXUDgZX/Catgbs
         u2pw==
X-Gm-Message-State: AO0yUKUZjz2nO3p93oMeFcrz96FE296kE8qwfRsEa+JmtEy40A9G3iTt
        JnJz0nv69ls8QIDD0SUHHaw=
X-Google-Smtp-Source: AK7set9EOVxcyvegEO7ejYzIPAKVwZEurXyg6nlBBeD5DcYnJSdy+NEcRP8/INlTGVJM9bCUJkXtug==
X-Received: by 2002:a05:600c:198e:b0:3eb:2b79:a40 with SMTP id t14-20020a05600c198e00b003eb2b790a40mr13176424wmq.20.1678228415951;
        Tue, 07 Mar 2023 14:33:35 -0800 (PST)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id q11-20020a05600c46cb00b003dc1d668866sm19233101wmo.10.2023.03.07.14.33.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 14:33:35 -0800 (PST)
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
Subject: [net-next PATCH 09/11] dt-bindings: net: dsa: qca8k: add LEDs definition example
Date:   Tue,  7 Mar 2023 18:00:44 +0100
Message-Id: <20230307170046.28917-10-ansuelsmth@gmail.com>
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

Add LEDs definition example for qca8k Switch Family to describe how they
should be defined for a correct usage.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 .../devicetree/bindings/net/dsa/qca8k.yaml    | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
index 389892592aac..866b3cc73216 100644
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
@@ -226,6 +229,27 @@ examples:
                     label = "lan1";
                     phy-mode = "internal";
                     phy-handle = <&internal_phy_port1>;
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
+                            default-state = "keep";
+                        };
+
+                        led@1 {
+                            reg = <1>;
+                            color = <LED_COLOR_ID_AMBER>;
+                            function = LED_FUNCTION_LAN;
+                            function-enumerator = <1>;
+                            default-state = "keep";
+                        };
+                    };
                 };
 
                 port@2 {
-- 
2.39.2

