Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E06A86CA70F
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 16:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbjC0OMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 10:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232698AbjC0OL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 10:11:57 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1DF524C;
        Mon, 27 Mar 2023 07:11:16 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id l12so8926941wrm.10;
        Mon, 27 Mar 2023 07:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679926275;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nAbMbzGoAUXhien3wP1TBou62FlRCxoeRd6GPGyBVkY=;
        b=CcaljGgqjESmV23PIrcxN9126f60ZABls3i6N2zF/oRUFiympEC3g88iZyVjpMsu03
         w2tP4bc6lNH1cv1kp19qwmOnKbaJbd34R5xdwHITjKvaFw1TUuuQVrr6Lf58OO+z3iKz
         VtlazM4dVBahjRyWYbN9I9tSKwwsmLP6Qh4OW+I/Tf/FNE/kfxfc4ZhkjZ13hMxt9vBb
         WMoWQoXSEMM4yd1PJGb7bFaYnWFG1lAXm95k4POCK1YtDe/y6lcvCCQwagWghcMFdB7c
         v+YtmhPYh2KMUensbuSy5TcZSmtDLNV/n/KHg7Qe+lHtwFsNGI9GQNkJdS1iS3IHV/ZR
         yMaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679926275;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nAbMbzGoAUXhien3wP1TBou62FlRCxoeRd6GPGyBVkY=;
        b=nqwZvjDd1KlV6oKsQcBsxuYratFiXS6dizr1USUs2nRnK5ZNIQfK8DOY68IuHxU3R4
         Mymb4/LMiTkVIAZg3YHwy6oLz2/b7/xCYJCu8GhNJAAsVpRtpPNZIrlRv8778lLN52i6
         aGvaIUYEWbPJ1G/JgREbw+ySjXg9f7A4QApGgWmpBHAjh9Ux57O+pe0YN/TArJZEppLS
         PM1KT0JBHzpEEPzkH2MYWIboskOcX2ph2lgxMNktKUbSqveuru+dx6UtOqQTkv4wSpoi
         GZO8uPLb4kBd6e2x1FMbMYEu8vjDhJvAUrwYlcNTQ4EDu41criSRmgJVBkZChaVdoEDD
         0feg==
X-Gm-Message-State: AAQBX9dlsCohcaBMp/Z93hUmRw9P9hYV3MzCAL4BPNUF4X05mQ+k9H1+
        OUqHMLKYPkmCIcEBzmJ/cJc=
X-Google-Smtp-Source: AKy350bKV5lGWwBGNkMaHLc7SyYG/WoW7N03Ge8CF1La1u+XwwO/i2jc6VgPrccjRLx/oBueA20aHQ==
X-Received: by 2002:adf:dd87:0:b0:2ce:aa62:ff79 with SMTP id x7-20020adfdd87000000b002ceaa62ff79mr9994473wrl.40.1679926274843;
        Mon, 27 Mar 2023 07:11:14 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id p17-20020adfcc91000000b002c71dd1109fsm25307591wrj.47.2023.03.27.07.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 07:11:14 -0700 (PDT)
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
Subject: [net-next PATCH v6 10/16] dt-bindings: leds: Document support for generic ethernet LEDs
Date:   Mon, 27 Mar 2023 16:10:25 +0200
Message-Id: <20230327141031.11904-11-ansuelsmth@gmail.com>
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

Add documentation for support of generic ethernet LEDs.
These LEDs are ethernet port LED and are controllable by the ethernet
controller or the ethernet PHY.

A port may expose multiple LEDs and reg is used to provide an index to
differentiate them.
Ethernet port LEDs follow generic LED implementation.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 .../bindings/leds/leds-ethernet.yaml          | 76 +++++++++++++++++++
 1 file changed, 76 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/leds/leds-ethernet.yaml

diff --git a/Documentation/devicetree/bindings/leds/leds-ethernet.yaml b/Documentation/devicetree/bindings/leds/leds-ethernet.yaml
new file mode 100644
index 000000000000..0a03d65beea0
--- /dev/null
+++ b/Documentation/devicetree/bindings/leds/leds-ethernet.yaml
@@ -0,0 +1,76 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/leds/leds-ethernet.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Common properties for the ethernet port LED.
+
+maintainers:
+  - Christian Marangi <ansuelsmth@gmail.com>
+
+description:
+  Bindings for the LEDs present in ethernet port and controllable by
+  the ethernet controller or the ethernet PHY regs.
+
+  These LEDs provide the same feature of a normal LED and follow
+  the same LED definitions.
+
+  An ethernet port may expose multiple LEDs, reg binding is used to
+  differentiate them.
+
+properties:
+  '#address-cells':
+    const: 1
+
+  '#size-cells':
+    const: 0
+
+patternProperties:
+  '^led@[a-f0-9]+$':
+    $ref: /schemas/leds/common.yaml#
+
+    properties:
+      reg:
+        maxItems: 1
+        description:
+          This define the LED index in the PHY or the MAC. It's really
+          driver dependent and required for ports that define multiple
+          LED for the same port.
+
+    required:
+      - reg
+
+    unevaluatedProperties: false
+
+required:
+  - '#address-cells'
+  - '#size-cells'
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/leds/common.h>
+
+    leds {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        led@0 {
+            reg = <0>;
+            color = <LED_COLOR_ID_WHITE>;
+            function = LED_FUNCTION_LAN;
+            function-enumerator = <1>;
+            default-state = "keep";
+        };
+
+        led@1 {
+            reg = <1>;
+            color = <LED_COLOR_ID_AMBER>;
+            function = LED_FUNCTION_LAN;
+            function-enumerator = <1>;
+            default-state = "keep";
+        };
+    };
+...
-- 
2.39.2

