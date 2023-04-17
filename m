Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 678106E4CE5
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 17:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbjDQPWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 11:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231288AbjDQPWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 11:22:12 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBDC6C649;
        Mon, 17 Apr 2023 08:21:20 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id v3so961272wml.0;
        Mon, 17 Apr 2023 08:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681744879; x=1684336879;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cMovAHVkjGy+uoUm4sFkhEHcZFqfs7jnbrYZOptwaFE=;
        b=GEyCjFMs6FDONVol7pOzUDp+XIe04EwVoxuXi0pS0E7bTDjH8aGGxA1Myzn7vGb+UJ
         V1qlLOh+Bo194NEzxtaZFkoZ0t5HVyAbAcutsaq31GpjfMkzq3bpYEWE7KwxoBDcKQOf
         nML5RiLR9iODUfE191pPUP+Emj8dBrChuRPXkqjzaY45ZfeeRL5NokjC6ROW3GKDOm7b
         MXDTbCWSu0FJmPHbBDBBEZIxOwIKJ1kHnbKpu2GXnqL7HNWMPOSBrIdBkHZRMdZFM2/2
         TwvBPV3+JY0EA3+MQdIcwsZndaDAqZB/KSAuF0xGPBqX6V3enF/6P9fMyKga5COgsOVn
         9A0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681744879; x=1684336879;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cMovAHVkjGy+uoUm4sFkhEHcZFqfs7jnbrYZOptwaFE=;
        b=M0ToPNkIbkiQ6Ns0YHvhd/f3UB5VjqVHv5oRgP62c+JscHtjvfO3Xg6FljAKJJf6Sr
         EhdyrNFcr3AsFT3T1NhnC/37Jm2bc2rs19M7WRQ8/oLzElpRwZNgLPGSxd34XbOVDN2T
         ywSCYxHD9o1ZWfVFL2hFmTWlxTP0jV88Kw8SO4ldO6eD0hxbaXonGzea62EGLamd6rba
         9UJS3PbBAEEk7igiMp/kujcWEyhsPYFlzk76y0w2BkJr6L5/rpAoYC0LnHxOV4Kiv1if
         0VigDaJNrzzgXNDovGit+xwF1G7YJ8Z4EzQKU8Zz9NvsnwlZamq9A2s/xWB4q4rMLDrU
         5peg==
X-Gm-Message-State: AAQBX9ejszUDpLnTWV3g5zn72Y/0J0Dswxs9UrdcVKf93FWuuJSNP2Hf
        oBKEZMLGlM5zQ1LF3DjJkP0=
X-Google-Smtp-Source: AKy350ZIJ+TrDF82kD2yC1FZXavbmN7VsLgQmu6R1Y9UZwTNr/oSShLvVRM30x8ovWzrSNBY8bb06w==
X-Received: by 2002:a7b:c8c9:0:b0:3f1:727d:77a6 with SMTP id f9-20020a7bc8c9000000b003f1727d77a6mr3917296wml.3.1681744878520;
        Mon, 17 Apr 2023 08:21:18 -0700 (PDT)
Received: from localhost.localdomain (host-87-7-13-196.retail.telecomitalia.it. [87.7.13.196])
        by smtp.googlemail.com with ESMTPSA id j15-20020a05600c1c0f00b003f173be2ccfsm3501354wms.2.2023.04.17.08.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 08:21:16 -0700 (PDT)
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
Subject: [net-next PATCH v7 10/16] dt-bindings: net: ethernet-controller: Document support for LEDs node
Date:   Mon, 17 Apr 2023 17:17:32 +0200
Message-Id: <20230417151738.19426-11-ansuelsmth@gmail.com>
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

Document support for LEDs node in ethernet-controller.
Ethernet Controller may support different LEDs that can be configured
for different operation like blinking on traffic event or port link.

Also add some Documentation to describe the difference of these nodes
compared to PHY LEDs, since ethernet-controller LEDs are controllable
by the ethernet controller regs and the possible intergated PHY doesn't
have control on them.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 .../bindings/net/ethernet-controller.yaml     | 35 +++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index 00be387984ac..ebc2646ab5ff 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -222,6 +222,41 @@ properties:
         required:
           - speed
 
+  leds:
+    description:
+      Describes the LEDs associated by Ethernet Controller.
+      These LEDs are not integrated in the PHY and PHY doesn't have any
+      control on them. Ethernet Controller regs are used to control
+      these defined LEDs.
+
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
 dependencies:
   pcs-handle-names: [pcs-handle]
 
-- 
2.39.2

