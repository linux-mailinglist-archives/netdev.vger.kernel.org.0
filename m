Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5E96BDED0
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 03:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbjCQCeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 22:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjCQCdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 22:33:42 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC2AD503;
        Thu, 16 Mar 2023 19:33:33 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id r18so3199936wrx.1;
        Thu, 16 Mar 2023 19:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679020413;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YxutGMPJva579mmTcYCtLi8ZBTi3DvGd1nN+fb8Tx6U=;
        b=nDOcGQfTe+PWjvaki2Z3MC2j4Gqvodmqm+7lZRZfBxswVyOOJ2Qy3b92wZjiy2VYGa
         gtSBY5HVAYVJi3CdnEbkzurM4dpeyOSGV2SSw9WoAPzkS8HnBMtYRXjHLxnM66NrDbNi
         3dD+IBQ1Bhp5EQAllKXtrSMI2EHiXXeBlcV9LzOdMrnj2acEkrnKOM/8AwPdXi3FhPWN
         sGsfjFpLDRnwjdntBMHxxfK0uale20WI1u0bO8rqvHjYeEV81P5byxamqURLHGCwXN1u
         vV3yMuRujrFvsGqUhTcJ9/jWbnhmxzU2C5AsReTXFZuayWEQR/XMsMIgCiMHdnxOXbey
         7Xhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679020413;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YxutGMPJva579mmTcYCtLi8ZBTi3DvGd1nN+fb8Tx6U=;
        b=1q7S2XSZdd8A3tPmazgqLTCrz0h2jeCgIsORnc4Vglmb5D1jbHTC3obdJaUu7nyDR4
         Cw9xT+szb/662dSAdtPm+8aP0jF46od/pThTXPMeHFlzbSyX9fkvgIIijcr16HskrrQA
         zjLoezWv1OKDoQMkVqUAERQYQ9mUXmjKsWqay31g1thbPNcjB/0vrA2Q/Md27ef27yUp
         lCEhrhi46F0bGUaxOTFqEAZ+zX193q1IHn2b85R8w4v5HgQ8LAbzKbTDv4aXqkB/cYzW
         UGceQocfIAkLfz5Rt59iHF4YSqvDqZOys7BZ0diIcgHpbvzCqwRYAUPFAuQxwlPjVndq
         FhpQ==
X-Gm-Message-State: AO0yUKVTkbADeGbX6RhKyd8oSGrJnllzEPQyx6bA+d6t13lJMXUvSg7j
        VVspVMKu9Q9e/GGcXvLbqRw=
X-Google-Smtp-Source: AK7set/lmxlmdee0c0/2GIyKWe6wn5BrqjcQ6Fkwm0eCSjWuwFM/o7NEv9Aae6aB4mW37+nisd/UFw==
X-Received: by 2002:a5d:510d:0:b0:2c5:540b:886c with SMTP id s13-20020a5d510d000000b002c5540b886cmr1086733wrt.31.1679020413009;
        Thu, 16 Mar 2023 19:33:33 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id z15-20020a5d44cf000000b002ce9f0e4a8fsm782313wrr.84.2023.03.16.19.33.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 19:33:32 -0700 (PDT)
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
Subject: [net-next PATCH v4 10/14] dt-bindings: net: dsa: qca8k: add LEDs definition example
Date:   Fri, 17 Mar 2023 03:31:21 +0100
Message-Id: <20230317023125.486-11-ansuelsmth@gmail.com>
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

