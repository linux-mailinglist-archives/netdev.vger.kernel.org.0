Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7DE164D44E
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 01:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbiLOABt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 19:01:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbiLOAAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 19:00:39 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B231C5FB9B;
        Wed, 14 Dec 2022 15:56:10 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id f18so1459965wrj.5;
        Wed, 14 Dec 2022 15:56:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nUaYB4mYM1gCXOfo+68xcCeBFVZGQ3PaFqb+K6GJCtg=;
        b=HEkM75XnY1gKLBNPSXMywD87ktVghvhjnMNiIPF3v+daRENgBk5tmBqIZfv6NfsAS+
         crGaojmo67uH4di/kyoTFvSXE9g2U1/YAXwZri37aUh1CfhmjV+W4BqFWrlYBAEprcMY
         v56VIwXrcycWiUTbg/yeKA20NNsX3vVVRYq8RO43cx5iSymYBM71JxvYWLX88uRIQ0UP
         nYee0ET/0g58lSVZK8emyXw3sCx/6MgJywAAa495kgT+NWzNs1N4bXHBrMoBubMJkOwR
         9fXtdMTl4p1eWGiRxu5UvAx/I/hJJIjyCIG8G5r5cOMC1zU0FTv/06ugeJJkYa48RMtj
         d2RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nUaYB4mYM1gCXOfo+68xcCeBFVZGQ3PaFqb+K6GJCtg=;
        b=M95cUJHDMUMlPXYNtDbwVWwhZhECUZis8mWUmrQnxHEpH6m82obF+/iMOvcU9vI8G9
         Jt58BXbA/1jU7ck/kQGCCbjY1khrzJmvCGJkWNrh4JVG18HR1OtbUKGoNbT/RJUGvuB8
         oJaliSK1KR5glcKh/VwJvmV+aXGtNaeI96NCCH2pZykSHAyPRJgHOBY7D1XtcOLp+WNo
         XZZwO1FXnQMby0zcy7vqRYjF2Lzbv51Gk2T1FBV+GfFdhFvSKkeXfdIbMd8EqSapjcr1
         8zlsl3xtJhbWVHYaFu9a3wbpVpufa70Mic2f0Um3wkPVzbFBm8UqoYsw6mOwAbof/1FD
         68eg==
X-Gm-Message-State: ANoB5pmpaiqN30cCWwTSKE5zLhEyEtFGqwMvMCMqKD54TWdsV075uDne
        Am71nDLF41NOupsyYyD4sc4=
X-Google-Smtp-Source: AA0mqf5aeoHs4hzEeRyaOmqpYUikvH6DDBAW6xVPEu0JqDYRI8a+6BmkteGHz5LGP2KZZpxAcuCsxw==
X-Received: by 2002:a5d:5b1d:0:b0:24b:b74d:8012 with SMTP id bx29-20020a5d5b1d000000b0024bb74d8012mr6793734wrb.18.1671062125288;
        Wed, 14 Dec 2022 15:55:25 -0800 (PST)
Received: from localhost.localdomain (93-42-71-18.ip85.fastwebnet.it. [93.42.71.18])
        by smtp.googlemail.com with ESMTPSA id u2-20020adff882000000b00241d21d4652sm4163549wrp.21.2022.12.14.15.55.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 15:55:24 -0800 (PST)
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
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        Christian Marangi <ansuelsmth@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH v7 11/11] dt-bindings: net: dsa: qca8k: add LEDs definition example
Date:   Thu, 15 Dec 2022 00:54:38 +0100
Message-Id: <20221214235438.30271-12-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221214235438.30271-1-ansuelsmth@gmail.com>
References: <20221214235438.30271-1-ansuelsmth@gmail.com>
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
index 978162df51f7..4090cf65c41c 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
@@ -65,6 +65,8 @@ properties:
                  internal mdio access is used.
                  With the legacy mapping the reg corresponding to the internal
                  mdio is the switch reg with an offset of -1.
+                 Each phy have at least 3 LEDs connected and can be declared
+                 using the standard LEDs structure.
 
 patternProperties:
   "^(ethernet-)?ports$":
@@ -202,6 +204,7 @@ examples:
     };
   - |
     #include <dt-bindings/gpio/gpio.h>
+    #include <dt-bindings/leds/common.h>
 
     mdio {
         #address-cells = <1>;
@@ -284,6 +287,27 @@ examples:
 
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
2.37.2

