Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2495C6E4CE1
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 17:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbjDQPWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 11:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbjDQPWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 11:22:13 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51DE2C65B;
        Mon, 17 Apr 2023 08:21:25 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3f0aabd1040so44214175e9.1;
        Mon, 17 Apr 2023 08:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681744884; x=1684336884;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rV9EcelsXiO5njlxQQAeC/3UMAuEjghxynP/HIeqk7E=;
        b=Xo1Et9VzokF1Un+UBViXcsNEPqexZ3w1hh+5Ne5SfV/nSjtC0VD80dSqt7r8D6kF01
         tlhx2suXoiUoRp3QpQPBAw+u6ZSpF893YWiaMcIASTRxLFaYVJn9TYyYLAozz8127kd7
         8dZz4rltnsJncm167nLsmlNOiCAElrM/o8tAJNqRdZ6HbQkxjS7WTvnfDyDN70y0sk7i
         uMmsOv2tmeAuaUifBkxWvckJ+biyn4S3gAGCT1lpDcb44fVmink6yBF2XzGnuQGFhAwT
         m+e0OFcfiBGd/RLlpRYMo39eOig1+Wf5mx9Rgc9RoLEuar5g0a1RxlMP3qYdFR4BJUi5
         Cmmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681744884; x=1684336884;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rV9EcelsXiO5njlxQQAeC/3UMAuEjghxynP/HIeqk7E=;
        b=e+fV0OkGPgSqyhnvqak0I43z9I7ELZo2OaDzjDzaxXwFgp0bGhy9EbtoYvPeB3pNoR
         GcyBQOQwOBONKLMzDDTYaOwwGLk8a69mE2WBg6DdHMljOnF97GmkylEsO4GWpQsBgX7h
         HC4KGF612bo3onsIQ6+s+n2kWCu/PMKRm4124thRQ94gTq5NgNmYOdB4JZPq8Tp/bSf6
         V1ftWpRtQJiuc2dzbsglCnTktGzfLmGtqJLyS0bda/OOGmek11ajoDs6668fb5+Ktnb4
         4Q04Hq0QR8XYMXi7ri3+tPepq8EvUJACTT1DB7Sv6KxmS8YTAA5WM4WCZf0xJ44GjAto
         lZnw==
X-Gm-Message-State: AAQBX9dv2p6tiIjP9ROfQ7J5SKmVs9Fb9nhbDB6ecMoLYNOa6qoOKRAr
        pmEyn1G0nHGgJAqH58r4PNQ=
X-Google-Smtp-Source: AKy350bxMNBPUgNwgAazK2IDboqf6/FlMetlBFozI9HUlvAID5orG7cGpsyH5XC2K1T8JmHvma6H2g==
X-Received: by 2002:adf:e702:0:b0:2fb:b869:bc08 with SMTP id c2-20020adfe702000000b002fbb869bc08mr683848wrm.23.1681744883644;
        Mon, 17 Apr 2023 08:21:23 -0700 (PDT)
Received: from localhost.localdomain (host-87-7-13-196.retail.telecomitalia.it. [87.7.13.196])
        by smtp.googlemail.com with ESMTPSA id j15-20020a05600c1c0f00b003f173be2ccfsm3501354wms.2.2023.04.17.08.21.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 08:21:22 -0700 (PDT)
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
        Jonathan Corbet <corbet@lwn.net>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org
Subject: [net-next PATCH v7 11/16] dt-bindings: net: dsa: qca8k: add LEDs definition example
Date:   Mon, 17 Apr 2023 17:17:33 +0200
Message-Id: <20230417151738.19426-12-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230417151738.19426-1-ansuelsmth@gmail.com>
References: <20230417151738.19426-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add LEDs definition example for qca8k Switch Family to describe how they
should be defined for a correct usage.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 .../devicetree/bindings/net/dsa/qca8k.yaml    | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
index fe9ebe285938..df64eebebe18 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
@@ -18,6 +18,8 @@ description:
   PHY it is connected to. In this config, an internal mdio-bus is registered and
   the MDIO master is used for communication. Mixed external and internal
   mdio-bus configurations are not supported by the hardware.
+  Each phy has at most 3 LEDs connected and can be declared
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
@@ -226,6 +229,25 @@ examples:
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
+                            default-state = "keep";
+                        };
+
+                        led@1 {
+                            reg = <1>;
+                            color = <LED_COLOR_ID_AMBER>;
+                            function = LED_FUNCTION_LAN;
+                            default-state = "keep";
+                        };
+                    };
                 };
 
                 port@2 {
-- 
2.39.2

