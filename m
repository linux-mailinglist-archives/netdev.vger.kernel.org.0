Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0796C0440
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 20:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbjCSTT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 15:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbjCSTTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 15:19:07 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A21A1043A;
        Sun, 19 Mar 2023 12:18:50 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id y14so8526268wrq.4;
        Sun, 19 Mar 2023 12:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679253530;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YxutGMPJva579mmTcYCtLi8ZBTi3DvGd1nN+fb8Tx6U=;
        b=p3mBsuZvjZMXgwDpGGw/4MbO61frU/GyEoTAu0FDPtAGWvwoeH9eUqr8R8sG3a77nk
         RuqhxoI6e+Z0Lp2CXWEQvV7EMs90OGkWMFAzDRax0GRDIYKhrx85GsTTZOc/xbAJpa9G
         QPXiHx4vnsIBU/uqO57dnshQugHdTuKQf0BExYsGCFgDZqCtrNVGPUXSDxJGXXrc73mk
         opzl52m5u8p1Qp5XC9iaFaoqAdbpQ7OuueNuZP9NTqN8y+hMytTyF2uMfvSqr6eqpWi3
         rpJglIxoi2UhURWX8MuXmnj0SkF3hadNXLvCpYmEkQLtXTI4HXEwGodc7+U1rru7+tSA
         /tBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679253530;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YxutGMPJva579mmTcYCtLi8ZBTi3DvGd1nN+fb8Tx6U=;
        b=W+KK4bkk6xl5VZV1ijqVw+L77oXFToSp/9/gRPDVooAZx8qSa8gpO+fGg5O61J3Gma
         iEWeUEf8AJpDT8fWo+4tS702Xmbooyo/jhWgOt7+YK9WIi5a9PFnt1rp1QPNsp8AOJzy
         nohN3r3P2ZBgPSlcxmGziiSlDCRsLxhfvA+IhdcDDsvAGu/ERkueLa98zGkr54Atjf21
         rtLYN2l2snbxi49gV0lYHFLDAFgwzBdrJ+xQ5uO+N4uB/cMXh/BhMj8AsJQh6n3vQsQg
         Fl6XojOqxqfMZcFDO1HNFakpBS3JeNGAgE5JDzmkB5k0fxUJeHa0CQ/SyV59/RHkEIRE
         O2RQ==
X-Gm-Message-State: AO0yUKW5t0ANWnVLlFZTVRbglwDxQ6irovqSlsmVHqA6J8cqBW2P5KVW
        3GoMeUqp2gzjKGuWoGOfmQw=
X-Google-Smtp-Source: AK7set/4ZnF4OzN9iVPJ5qe8XpAvveOG8nFo53xUXQ8NMaEoU+3vSSErDTGBqm0xGmpE3MgweETkRA==
X-Received: by 2002:adf:e406:0:b0:2d6:405f:8b16 with SMTP id g6-20020adfe406000000b002d6405f8b16mr2037658wrm.66.1679253530078;
        Sun, 19 Mar 2023 12:18:50 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id b7-20020a5d4b87000000b002cfe0ab1246sm7165167wrt.20.2023.03.19.12.18.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 12:18:49 -0700 (PDT)
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
Subject: [net-next PATCH v5 11/15] dt-bindings: net: dsa: qca8k: add LEDs definition example
Date:   Sun, 19 Mar 2023 20:18:10 +0100
Message-Id: <20230319191814.22067-12-ansuelsmth@gmail.com>
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

Add LEDs definition example for qca8k Switch Family to describe how they
should be defined for a correct usage.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 .../devicetree/bindings/net/dsa/qca8k.yaml    | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
index 389892592aac..2e9c14af0223 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
@@ -18,6 +18,8 @@ description:
   PHY it is connected to. In this config, an internal mdio-bus is registered and
   the MDIO master is used for communication. Mixed external and internal
   mdio-bus configurations are not supported by the hardware.
+  Each phy has at least 3 LEDs connected and can be declared
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

