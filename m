Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F324959AC9D
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 10:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344170AbiHTIaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 04:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245008AbiHTIaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 04:30:10 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA002BC80A
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 01:30:07 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id h22so2369776ejk.4
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 01:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=HLh67C/o4C2BwENLXIMxr20ywGIxfeZ/JS1OF1ffbiQ=;
        b=Got7h1ZKfDUESy2e1P4v1odWn0gRNpD298bKZwk4I2438GlURZNLLbUT3g33Wdes5k
         qdxWKBnCzq8T43p8Dr6HPBAle7iszHXY7pkVlja/zpGGJgpB2evAfQjlssvuAG+/X+Gk
         FTdxuSZekcTPI8IbnYyxVWb6t76MfgDjVvK0U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=HLh67C/o4C2BwENLXIMxr20ywGIxfeZ/JS1OF1ffbiQ=;
        b=lI9OPww/7LcLRW3/CAfYpqG8k55YEMtQe/cY2yZ7vF/fx4RW2mqnRnRa8ScTnbcLX1
         w5P4QzUu2115QE7xchOiQKD57Q+6oSyoKrbB5F/Zlbbza6gc9dC3TjcvQWqdS3/Sahds
         PD/OANECR+irP7S2oec6lg+KbwgsC9EsOwNaWYO4BC4nzbs6jy/+FM20EB47EXJ1Dsz0
         /gZezSN7lW+b8RMs0579OEHvlhQWtluqdYfWPZVIvGERBw/+MaiYdgfM1Qr8+00ND25c
         bdrki9W/5xb1T8Datr7L/jWlVDttgxCPmI0kXcOY09popLSm5trF1iH47KoIetd3u4/s
         sg8Q==
X-Gm-Message-State: ACgBeo1MT6BInXl2MwoEDZO07qfVh1J+5QH10YkH568YjvkHiC/TboxK
        Mb708RkvKVQLaqaqt6pxplUsvw==
X-Google-Smtp-Source: AA6agR7J/eXfs3hdUgESd/tx1X0k/lOEzd5dY2aCf6mu5lT6lH0X1oBlNH6N9tRXNvPgDSVgWlYiUA==
X-Received: by 2002:a17:907:c18:b0:731:65f6:1f29 with SMTP id ga24-20020a1709070c1800b0073165f61f29mr6965935ejc.577.1660984206468;
        Sat, 20 Aug 2022 01:30:06 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-79-31-31-9.retail.telecomitalia.it. [79.31.31.9])
        by smtp.gmail.com with ESMTPSA id gx14-20020a1709068a4e00b0072b33e91f96sm3336112ejc.190.2022.08.20.01.30.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Aug 2022 01:30:05 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        michael@amarulasolutions.com,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Dario Binacchi <dariobin@libero.it>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-can@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, netdev@vger.kernel.org
Subject: [RFC PATCH v2 1/4] dt-bindings: net: can: add STM32 bxcan DT bindings
Date:   Sat, 20 Aug 2022 10:29:33 +0200
Message-Id: <20220820082936.686924-2-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220820082936.686924-1-dario.binacchi@amarulasolutions.com>
References: <20220820082936.686924-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation of device tree bindings for the STM32 basic extended
CAN (bxcan) controller.

Signed-off-by: Dario Binacchi <dariobin@libero.it>
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>

---

Changes in v2:
- Change the file name into 'st,stm32-bxcan-core.yaml'.
- Rename compatibles:
  - st,stm32-bxcan-core -> st,stm32f4-bxcan-core
  - st,stm32-bxcan -> st,stm32f4-bxcan
- Rename master property to st,can-master.
- Remove the status property from the example.
- Put the node child properties as required.

 .../bindings/net/can/st,stm32-bxcan.yaml      | 136 ++++++++++++++++++
 1 file changed, 136 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml

diff --git a/Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml b/Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml
new file mode 100644
index 000000000000..288631b5556d
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml
@@ -0,0 +1,136 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/can/st,stm32-bxcan.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: STMicroelectronics bxCAN controller
+
+description: STMicroelectronics BxCAN controller for CAN bus
+
+maintainers:
+  - Dario Binacchi <dario.binacchi@amarulasolutions.com>
+
+allOf:
+  - $ref: can-controller.yaml#
+
+properties:
+  compatible:
+    enum:
+      - st,stm32f4-bxcan-core
+
+  reg:
+    maxItems: 1
+
+  resets:
+    maxItems: 1
+
+  clocks:
+    description:
+      Input clock for registers access
+    maxItems: 1
+
+  '#address-cells':
+    const: 1
+
+  '#size-cells':
+    const: 0
+
+additionalProperties: false
+
+required:
+  - compatible
+  - reg
+  - resets
+  - clocks
+  - '#address-cells'
+  - '#size-cells'
+
+patternProperties:
+  "^can@[0-9]+$":
+    type: object
+    description:
+      A CAN block node contains two subnodes, representing each one a CAN
+      instance available on the machine.
+
+    properties:
+      compatible:
+        enum:
+          - st,stm32f4-bxcan
+
+      st,can-master:
+        description:
+          Master and slave mode of the bxCAN peripheral is only relevant
+          if the chip has two CAN peripherals. In that case they share
+          some of the required logic, and that means you cannot use the
+          slave CAN without the master CAN.
+        type: boolean
+
+      reg:
+        description: |
+          Offset of CAN instance in CAN block. Valid values are:
+            - 0x0:   CAN1
+            - 0x400: CAN2
+        maxItems: 1
+
+      interrupts:
+        items:
+          - description: transmit interrupt
+          - description: FIFO 0 receive interrupt
+          - description: FIFO 1 receive interrupt
+          - description: status change error interrupt
+
+      interrupt-names:
+        items:
+          - const: tx
+          - const: rx0
+          - const: rx1
+          - const: sce
+
+      resets:
+        maxItems: 1
+
+      clocks:
+        description:
+          Input clock for registers access
+        maxItems: 1
+
+    additionalProperties: false
+
+    required:
+      - compatible
+      - reg
+      - interrupts
+      - resets
+
+examples:
+  - |
+    #include <dt-bindings/clock/stm32fx-clock.h>
+    #include <dt-bindings/mfd/stm32f4-rcc.h>
+
+    can: can@40006400 {
+        compatible = "st,stm32f4-bxcan-core";
+        reg = <0x40006400 0x800>;
+        resets = <&rcc STM32F4_APB1_RESET(CAN1)>;
+        clocks = <&rcc 0 STM32F4_APB1_CLOCK(CAN1)>;
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        can1: can@0 {
+            compatible = "st,stm32f4-bxcan";
+            reg = <0x0>;
+            interrupts = <19>, <20>, <21>, <22>;
+            interrupt-names = "tx", "rx0", "rx1", "sce";
+            resets = <&rcc STM32F4_APB1_RESET(CAN1)>;
+            st,can-master;
+        };
+
+        can2: can@400 {
+            compatible = "st,stm32f4-bxcan";
+            reg = <0x400>;
+            interrupts = <63>, <64>, <65>, <66>;
+            interrupt-names = "tx", "rx0", "rx1", "sce";
+            resets = <&rcc STM32F4_APB1_RESET(CAN2)>;
+            clocks = <&rcc 0 STM32F4_APB1_CLOCK(CAN2)>;
+        };
+    };
-- 
2.32.0

