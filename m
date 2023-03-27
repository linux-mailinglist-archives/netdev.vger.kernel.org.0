Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D29A6CA72B
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 16:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233037AbjC0ON2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 10:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232734AbjC0OMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 10:12:43 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A2FD61B9;
        Mon, 27 Mar 2023 07:11:28 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id h17so8936487wrt.8;
        Mon, 27 Mar 2023 07:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679926284;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LZH9Sk2pJzkh23T3pvC9mL7PUp+XT9d2pmz+5Sv6HfU=;
        b=hiQgcTNbjTwyK1DtXN7v9cBM9rutp52Kssl34K2jFzAy52at99qRhQjWzRb9BOYKV1
         EFtjwAhl02g8g5F1CVaa8N0oLKCQjT6jyOVeg6mJtSo/Yclp9SCLDpZj+ApT9VG2o9Dc
         JCL7/91K1ZOL868IwehOslNdkUkiCL9+oTl1XmAwQ3BSp+D+lGCUuNChW51bCfjlgynZ
         80cFtL3QSEDmq1cdH+1xi4HdXSVPdO0JwjjVD9P7wLQ7QGQD/Q3Pa3TGB37a3Ot+5rTG
         VMAYLJS8+ePGHI2CUW20iY0Po68kEOMn5RNTVnpYIeo15slk28a/WfOU3Fi4/PmFy7jl
         3UuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679926284;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LZH9Sk2pJzkh23T3pvC9mL7PUp+XT9d2pmz+5Sv6HfU=;
        b=iYLJzcTROVlaSg8pTBOArpbWZ5wOLXMMA7HkDggN7ZmBWG3FkUjt0WafCwP5roPdPm
         MeelYgmIpbDCiw/DYc724y/1FzuRj0x7O9Kdw2iBUkk2QlSYBgBjYkpb9MJIFOx7IaBE
         4GE3kQhH2UgpRbDgR4Dgmir+mZl7vqg1+RquA7hcYnDQat+r9HUpYYrukovWapmXmsj6
         hcPzO5UfbUqVaZpfiy4pwJ3utljefP98nWdmNYOiJPevE9cPpenGlo6Fs8u15K6vIRB4
         RW4DtgMT+YkDlJQnfk+BggFLtuYAb6EeuISU4/Q5lhvwpuGw+FZ2DSvTnXtJZxeyDJQv
         rKNw==
X-Gm-Message-State: AAQBX9dI+Af4RLUtsjPUCZdf5Oam4/WamlCt8o64pKl8KEZfLz/2p2hL
        IaPzMVPpjHm62p+BiyOI0Vs=
X-Google-Smtp-Source: AKy350ap8WEcIEwqf1NKkbwttXDksoZm51gt2ulaJeHLKNmELEgpREhPCxomUPPtrVKdy+ge6NggLA==
X-Received: by 2002:adf:ea91:0:b0:2c5:9ef9:9bab with SMTP id s17-20020adfea91000000b002c59ef99babmr9424322wrm.43.1679926283679;
        Mon, 27 Mar 2023 07:11:23 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id p17-20020adfcc91000000b002c71dd1109fsm25307591wrj.47.2023.03.27.07.11.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 07:11:23 -0700 (PDT)
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
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: [net-next PATCH v6 15/16] dt-bindings: net: phy: Document support for LEDs node
Date:   Mon, 27 Mar 2023 16:10:30 +0200
Message-Id: <20230327141031.11904-16-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230327141031.11904-1-ansuelsmth@gmail.com>
References: <20230327141031.11904-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
 .../devicetree/bindings/net/ethernet-phy.yaml | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
index 1327b81f15a2..1e55e028c918 100644
--- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
@@ -197,6 +197,10 @@ properties:
       PHY's that have configurable TX internal delays. If this property is
       present then the PHY applies the TX delay.
 
+  leds:
+    allOf:
+      - $ref: /schemas/leds/leds-ethernet.yaml#
+
 required:
   - reg
 
@@ -204,6 +208,8 @@ additionalProperties: true
 
 examples:
   - |
+    #include <dt-bindings/leds/common.h>
+
     ethernet {
         #address-cells = <1>;
         #size-cells = <0>;
@@ -219,5 +225,18 @@ examples:
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

