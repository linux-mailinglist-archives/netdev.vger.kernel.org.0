Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99A426CB835
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 09:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbjC1HeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 03:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbjC1Hdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 03:33:52 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4690D40F5
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 00:33:48 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id y4so45877578edo.2
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 00:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google; t=1679988826;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=81V4WG2Py2oEHuOAf8mFt9n+MMzcYuintrA4k96hyCk=;
        b=fHuz3/JvHKFJl4aHOKVNqY0NVKXvM7/HcN8CMEL37x76Sg/gNZjWYcr8NzHQVIUyXv
         KH63ag8K8zkQrBFuY7R7nzt7zWFZv9TkG+dSrsYEXs/8x5EizacWfAX9BBM5Vgp76Igf
         wWewKdW6o6gmEOfftPj0hWrFVWypYG/ptgvZA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679988826;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=81V4WG2Py2oEHuOAf8mFt9n+MMzcYuintrA4k96hyCk=;
        b=id7o9VWGlansa2qi3Hkn00Q5s3Iozw1iceG5a7lqAGpZgX+qOsMOHAAfojXbQiPfLs
         WGGN0MQlcdToyxFVShVPKG6oXY8eMokHmXSOp0WZIij8VSKOdCC0E1vK/RcLjjky5Pk/
         ksvPOgKvRLYq+wpvWijb8M8Ixibo6WrPbiFrkoriyVFjj7q22zIS2wHGGBDXL2XnqsRn
         ztKL0uqrcChW/TXOEFRTlHMCVfIaqTR13T9i6zkknMjchuWzKnY1eHYSK0oDpXr7yW1O
         rq3s8/aDbRWGGW/OyCilZugwBXmZDCF9JxCZA2GrFJbgvU/UDfiOag+T/tlUdOlOeImb
         f3ng==
X-Gm-Message-State: AAQBX9efG0EqsioLOejrpj/S37tDFSuy4hJ2NrSGjyR0TihAnud7zfkW
        w3DK6Y2zz8HNZtSQd9yaZ/2xnw==
X-Google-Smtp-Source: AKy350YMHRUUI0sIzpaRdaU598Pj9B9QeJ9n+ysjS/JhiTsW+ZBhBX5+DEXzztk/si+Uj0rohAL2KA==
X-Received: by 2002:a05:6402:712:b0:502:20f0:3ee1 with SMTP id w18-20020a056402071200b0050220f03ee1mr14140124edx.31.1679988826415;
        Tue, 28 Mar 2023 00:33:46 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-87-0-102-254.retail.telecomitalia.it. [87.0.102.254])
        by smtp.gmail.com with ESMTPSA id 15-20020a508e4f000000b004fa99a22c3bsm15478850edx.61.2023.03.28.00.33.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 00:33:46 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Rob Herring <robh@kernel.org>,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
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
Subject: [PATCH v10 2/5] dt-bindings: net: can: add STM32 bxcan DT bindings
Date:   Tue, 28 Mar 2023 09:33:25 +0200
Message-Id: <20230328073328.3949796-3-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20230328073328.3949796-1-dario.binacchi@amarulasolutions.com>
References: <20230328073328.3949796-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation of device tree bindings for the STM32 basic extended
CAN (bxcan) controller.

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Reviewed-by: Rob Herring <robh@kernel.org>

---

Changes in v10:
- Fix errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'.
  Fix the "st,can-primary" description removing the "Note:" word that
  caused the failure.

Changes in v9:
- Replace master/slave terms with primary/secondary.

Changes in v5:
- Add Rob Herring's Reviewed-by tag.

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

 .../bindings/net/can/st,stm32-bxcan.yaml      | 85 +++++++++++++++++++
 1 file changed, 85 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml

diff --git a/Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml b/Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml
new file mode 100644
index 000000000000..2bfac2089964
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml
@@ -0,0 +1,85 @@
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
+  st,can-primary:
+    description:
+      Primary and secondary mode of the bxCAN peripheral is only relevant
+      if the chip has two CAN peripherals. In that case they share some
+      of the required logic.
+      To avoid misunderstandings, it should be noted that ST documentation
+      uses the terms master/slave instead of primary/secondary.
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
+      SRAM memory shared by the two bxCAN cells (CAN1 primary and CAN2
+      secondary) in dual CAN peripheral configuration.
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
+        st,can-primary;
+        st,gcan = <&gcan>;
+    };
-- 
2.32.0

