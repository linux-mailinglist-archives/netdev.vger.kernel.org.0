Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA1435A3DC3
	for <lists+netdev@lfdr.de>; Sun, 28 Aug 2022 15:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbiH1Ndn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Aug 2022 09:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiH1Ndm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Aug 2022 09:33:42 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859A124BFD
        for <netdev@vger.kernel.org>; Sun, 28 Aug 2022 06:33:40 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id bj12so10944589ejb.13
        for <netdev@vger.kernel.org>; Sun, 28 Aug 2022 06:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=b/btFehREFVzIjnfwZ0fR/od68XSqMjGfHOju/rQyoU=;
        b=mGwOSs8uRwcBFikc4fKzn6cA61x5ln2dvWQFrU+kdsYkjmEo0WaZUZjIKRHNRtRRN3
         qcsD1gSixY0iR9W98/wSTVXkGDCpFsEbjWbU4VEyJjLtkoiKZ+op4cWQt+B5zgbLJKuA
         uAI962pJ3qTQHXcE0S/0MG238FDGTgRiIpm+g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=b/btFehREFVzIjnfwZ0fR/od68XSqMjGfHOju/rQyoU=;
        b=l0DXiqTq4sbxi9+Q9Ra/0yb8M7B4cYPy4Nk6V38dnaC82OPZYXgoeLAZYvGIBMcL/u
         /Ct9k7AQwRcfXntK6llYE3EP+05DJe1dajtK7icBrFu+cD6b0pg9xk90IAlLQHQ1NsOT
         cEnNcpuDyx+8q83hZtjOI8E4BNrcQ6s1VXHcNCyAm4vALLZEJJGxfCfv+aEFhmj6wjKZ
         g6+X0Dl2iQzEyHnhXUYAfA70+1hlWp0oG0vLBV70sKAadV+SecandqfRDqHg7q/lUelv
         mE1rt7O1s2+mcP39Md4Gi/SDqy5DWZ07Mmed+Yl7cWVH07uzFRB1vT408fwm8sBhKBHQ
         fDKQ==
X-Gm-Message-State: ACgBeo1vG65ZgmXJ+99aKX3dOr6w6BaE1mGw42WF4SShGjNR7oTmp34C
        ZQ4jocX+abOaomk0+UltlnnMew==
X-Google-Smtp-Source: AA6agR4bOIGmsAhChMVhMNdemmW9m88gH6GVC5wHtB5s/IJcxN+33iJUWoFivYFrRrVDuzRxW+6wmA==
X-Received: by 2002:a17:906:eec7:b0:733:189f:b07a with SMTP id wu7-20020a170906eec700b00733189fb07amr10600791ejb.230.1661693619043;
        Sun, 28 Aug 2022 06:33:39 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-79-31-31-9.retail.telecomitalia.it. [79.31.31.9])
        by smtp.gmail.com with ESMTPSA id u26-20020a1709064ada00b007313a25e56esm3247669ejt.29.2022.08.28.06.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Aug 2022 06:33:38 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh@kernel.org>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
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
Subject: [RFC PATCH v3 1/4] dt-bindings: net: can: add STM32 bxcan DT bindings
Date:   Sun, 28 Aug 2022 15:33:26 +0200
Message-Id: <20220828133329.793324-2-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220828133329.793324-1-dario.binacchi@amarulasolutions.com>
References: <20220828133329.793324-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation of device tree bindings for the STM32 basic extended
CAN (bxcan) controller.

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>

---

Changes in v3:
- Remove 'Dario Binacchi <dariobin@libero.it>' SOB.
- Add description to the parent of the two child nodes.
- Move "patterProperties:" after "properties: in top level before "required".
- Add "clocks" to the "required:" list of the child nodes.

Changes in v2:
- Change the file name into 'st,stm32-bxcan-core.yaml'.
- Rename compatibles:
  - st,stm32-bxcan-core -> st,stm32f4-bxcan-core
  - st,stm32-bxcan -> st,stm32f4-bxcan
- Rename master property to st,can-master.
- Remove the status property from the example.
- Put the node child properties as required.

 .../bindings/net/can/st,stm32-bxcan.yaml      | 142 ++++++++++++++++++
 1 file changed, 142 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml

diff --git a/Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml b/Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml
new file mode 100644
index 000000000000..3278c724e6f5
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml
@@ -0,0 +1,142 @@
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
+    description:
+      It manages the access to the 512-bytes SRAM memory shared by the
+      two bxCAN cells (CAN1 master and CAN2 slave) in dual CAN peripheral
+      configuration.
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
+      - clocks
+
+required:
+  - compatible
+  - reg
+  - resets
+  - clocks
+  - '#address-cells'
+  - '#size-cells'
+
+additionalProperties: false
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
+            clocks = <&rcc 0 STM32F4_APB1_CLOCK(CAN1)>;
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

