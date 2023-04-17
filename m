Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4056E4D09
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 17:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbjDQPXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 11:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbjDQPWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 11:22:40 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA286CC12;
        Mon, 17 Apr 2023 08:21:43 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-2f55ffdbaedso990132f8f.2;
        Mon, 17 Apr 2023 08:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681744899; x=1684336899;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uJTkEZZQz1Xm9DGAcdJUpopRWa59pUHGOjNQ9ofW+JI=;
        b=JwvmejdNADdlWH3gz/HGxo/4ta+utT9srnqx+wcn+i9SWy13iXfdE2mS1uFt9bbind
         oE9yDqjIEqBeh/j5aCqFVDmZUcPXMn8tTzrAElS+jqTXOydzepW8dDX3tQ0f59A5rdi0
         FpR3XBLDyOBUBneGa419h8GU3ZTmYTJbspAnM6t7llqvc6mMBV2OCMLLB/xN03NuJtmh
         ZO00L4LN7ckJd4nSRoniYrePij4aDHAZBEimey1FeGqPgJtxOA09iXYe8pfOkcICFhEX
         jnzvsWYMmV56/AbLL7j3xCinsmf0+4T3jUKQqLBwmV3Ef39l/87QKpF29zlph77b2++I
         y46g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681744899; x=1684336899;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uJTkEZZQz1Xm9DGAcdJUpopRWa59pUHGOjNQ9ofW+JI=;
        b=FFBVl1mkceAKUoemUUh55LFkK9DgWh5YYbwzFtA/KoiGmZTCZRTleo+JGe7MS5JSSg
         t/8o8GUbxllRcxj72BiP9ZY3WAyTkXkO5j19jneglQsToL3JhqK9eKrxmo4x3fmNmuKO
         JPL/CdO6Ib9JjmiBc6Ec3OW3rvMo3XfFTMdJTRoFfJaFjyzmy7mnhmz6aFQuzbHWCOaj
         YkI1oMUUS2KdJlc8ILq4bl76oIAqVLuqoTItWoxzcKeKPY3R4maWDgxx5mhZjO5QnvgB
         d1Wu6Si/Xem8OHn5oi6isCERenxulvkUqCWfODOLxmHKHyTQ5O3x3iv9l5i8U8cuDwf2
         c1UA==
X-Gm-Message-State: AAQBX9ftLNh+vMU8Ap/MceqWoipARl0XDc6V/2bsq0U88u62prbFdCAl
        fZaaQEJxHX2JVBItPJ89/0Q=
X-Google-Smtp-Source: AKy350Z1iK+OSaFxPXE4V00SsLukB621IdcQfbrYZMVMsjihtpFkTemQ9mgTw5xgzHNxbAIPf9drtA==
X-Received: by 2002:adf:f089:0:b0:2cf:e422:e28c with SMTP id n9-20020adff089000000b002cfe422e28cmr5443129wro.42.1681744898817;
        Mon, 17 Apr 2023 08:21:38 -0700 (PDT)
Received: from localhost.localdomain (host-87-7-13-196.retail.telecomitalia.it. [87.7.13.196])
        by smtp.googlemail.com with ESMTPSA id j15-20020a05600c1c0f00b003f173be2ccfsm3501354wms.2.2023.04.17.08.21.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 08:21:37 -0700 (PDT)
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
Subject: [net-next PATCH v7 14/16] dt-bindings: net: phy: Document support for LEDs node
Date:   Mon, 17 Apr 2023 17:17:36 +0200
Message-Id: <20230417151738.19426-15-ansuelsmth@gmail.com>
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

Document support for LEDs node in phy and add an example for it.
PHY LED will have to match led pattern and should be treated as a
generic led.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 .../devicetree/bindings/net/ethernet-phy.yaml | 43 +++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
index ac04f8efa35c..4f574532ee13 100644
--- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
@@ -197,6 +197,35 @@ properties:
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
+      '^led@[a-f0-9]+$':
+        $ref: /schemas/leds/common.yaml#
+
+        properties:
+          reg:
+            maxItems: 1
+            description:
+              This define the LED index in the PHY or the MAC. It's really
+              driver dependent and required for ports that define multiple
+              LED for the same port.
+
+        required:
+          - reg
+
+        unevaluatedProperties: false
+
+    additionalProperties: false
+
 required:
   - reg
 
@@ -204,6 +233,8 @@ additionalProperties: true
 
 examples:
   - |
+    #include <dt-bindings/leds/common.h>
+
     ethernet {
         #address-cells = <1>;
         #size-cells = <0>;
@@ -219,5 +250,17 @@ examples:
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
+                    default-state = "keep";
+                };
+            };
         };
     };
-- 
2.39.2

