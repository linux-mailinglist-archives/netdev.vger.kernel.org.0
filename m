Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA1F05E951B
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 19:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232864AbiIYRw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 13:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232731AbiIYRwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 13:52:24 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E931F63F
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 10:52:21 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id e18so6302663edj.3
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 10:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=5r8NMkE9LIMyGMHe+fW9/TCXkKWGgaySDbokWa2bTfs=;
        b=rE09vLhfcm+sMnfs8ULMTr6/bK3MwQf8oC8Fq7LT7nP+wuqLg7j0ntTZbTZ49cTkxX
         EI/g2BAl5hK8sX2efLmfukXezr4h99verFq/YuK85FS98GuvmXF4Hnoh1FaXza4v6ebJ
         LGcX0Bcq2Os/oAegAaORzrQLhTy+cW8Y5RbRw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=5r8NMkE9LIMyGMHe+fW9/TCXkKWGgaySDbokWa2bTfs=;
        b=2PjVuHjCx5xDmZtSQZGLrN87EtKGtEsaxt9DHXxNnwQQgzuuEvywMcvU/e2m1pS29b
         lC9Zog5SouHFogKEKNbMIHJPQ5REnD1LT/nWp4zKvdCEho0N36MqS48b/nf1LJ9QOP5c
         454z5C40VkcppxHsLJkfTUxJkaZ3dcDBj+L8Hr0olnhpCuNoWR9KMlJ5gPGFNepRw4AH
         U8It1P62L3ABw0hMa8DRe9Mlz96iS5ADnaqnw8rD880wvDPph/E6dF63h9RtecxDB6ih
         37XYvR4QeaojBuaThTfUbhUtSoMk4Hky/+p8uU006hCDjN1G18fPT6KI30cpwWFhOGgB
         lb/g==
X-Gm-Message-State: ACrzQf1jNY1fDQo9qW/p6Xpoxt6odhVJj1bbBFki8WNwhb8BH8+lsc/Z
        +6LUt9msROW+RTy2LEzIOKpa3Q==
X-Google-Smtp-Source: AMsMyM7M8IOm9TRe2kiiUfrClOrR7IxylHsjWCiilZF9WlzBJ34pM/8zM/KudiMcTLPbSPXiwk1Mjg==
X-Received: by 2002:a05:6402:2994:b0:453:4c5c:d31c with SMTP id eq20-20020a056402299400b004534c5cd31cmr18498376edb.412.1664128339645;
        Sun, 25 Sep 2022 10:52:19 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-95-232-92-192.retail.telecomitalia.it. [95.232.92.192])
        by smtp.gmail.com with ESMTPSA id f23-20020a056402161700b0045703d699b9sm3252594edv.78.2022.09.25.10.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Sep 2022 10:52:19 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
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
Subject: [RFC PATCH v4 2/5] dt-bindings: net: can: add STM32 bxcan DT bindings
Date:   Sun, 25 Sep 2022 19:52:06 +0200
Message-Id: <20220925175209.1528960-3-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220925175209.1528960-1-dario.binacchi@amarulasolutions.com>
References: <20220925175209.1528960-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation of device tree bindings for the STM32 basic extended
CAN (bxcan) controller.

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>

---

Changes in v4:
- Remove "st,stm32f4-bxcan-core" compatible. In this way the can nodes
 (compatible "st,stm32f4-bxcan") are no longer children of a parent
  node with compatible "st,stm32f4-bxcan-core".
- Add the "st,gcan" property (global can memory) to can nodes which
  references a "syscon" node containing the shared clock and memory
  addresses.

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

 .../bindings/net/can/st,stm32-bxcan.yaml      | 83 +++++++++++++++++++
 1 file changed, 83 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml

diff --git a/Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml b/Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml
new file mode 100644
index 000000000000..c9194345d202
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml
@@ -0,0 +1,83 @@
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
+      - st,stm32f4-bxcan
+
+  st,can-master:
+    description:
+      Master and slave mode of the bxCAN peripheral is only relevant
+      if the chip has two CAN peripherals. In that case they share
+      some of the required logic.
+    type: boolean
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    items:
+      - description: transmit interrupt
+      - description: FIFO 0 receive interrupt
+      - description: FIFO 1 receive interrupt
+      - description: status change error interrupt
+
+  interrupt-names:
+    items:
+      - const: tx
+      - const: rx0
+      - const: rx1
+      - const: sce
+
+  resets:
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+
+  st,gcan:
+    $ref: "/schemas/types.yaml#/definitions/phandle-array"
+    description:
+      The phandle to the gcan node which allows to access the 512-bytes
+      SRAM memory shared by the two bxCAN cells (CAN1 master and CAN2
+      slave) in dual CAN peripheral configuration.
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - resets
+  - clocks
+  - st,gcan
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/stm32fx-clock.h>
+    #include <dt-bindings/mfd/stm32f4-rcc.h>
+
+    can1: can@40006400 {
+        compatible = "st,stm32f4-bxcan";
+        reg = <0x40006400 0x200>;
+        interrupts = <19>, <20>, <21>, <22>;
+        interrupt-names = "tx", "rx0", "rx1", "sce";
+        resets = <&rcc STM32F4_APB1_RESET(CAN1)>;
+        clocks = <&rcc 0 STM32F4_APB1_CLOCK(CAN1)>;
+        st,can-master;
+        st,gcan = <&gcan>;
+    };
-- 
2.32.0

