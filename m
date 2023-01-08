Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D81A661688
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 17:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233495AbjAHQ0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 11:26:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233293AbjAHQ0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 11:26:04 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 682D5388C
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 08:26:03 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id c17so9166784edj.13
        for <netdev@vger.kernel.org>; Sun, 08 Jan 2023 08:26:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D8/Md0NYJHUSKcz4MJWTxhKaskWW/ctRpyjjxqRRhnc=;
        b=KZUi81UE7xYmzIHGfoEd+UN6IMAb9alIo+8JuTlJqRAManBoFzaJWQNhDG1wTsczz8
         M3TYyhCIy4tTBraIwZPIIHpLba/IzWnYlBnClJKiZQDp62dcsIbGYFx9T8j2xrXOJr3t
         KH5USQgKslaBFd6DfxvlUkXx5WjJoTMXe0Jew=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D8/Md0NYJHUSKcz4MJWTxhKaskWW/ctRpyjjxqRRhnc=;
        b=67Id2PhqCJ8OxRpGfn5zK6H/r6PjIBzbpZ1Wry8Xv7ujm28wOXk17XXNTXLfVlyAh0
         zC7Nj+tiRtaJp+4n3Jmrt/Seg69i2ux/xlo+CJesD7Dtax+uryXBPGuN1ipX6A778kHa
         HpOGMnfH7eWoyJEYVWdjPKhjGLllqv/Z7FvpV4opN3SfM5aMCAOHxd7g0NxxSPrWkwnR
         Bhz/DjKw/8i+dZJWBUuiWxdxodAqrzTocalAZnNxisCenU1TRCMd5yQ3gml9WGU1eGl5
         92xvwIVyNvRhPjT1dGtV39u89r2aoTUkY1JLQY3qosLqVbMPuo5CaxV1VBVkidbB1Dua
         sOPw==
X-Gm-Message-State: AFqh2kqNHUXQGf4jCaJ/+KSkBVz0kEwtYIR+GN2kGCkzMfr3gQZ006Mm
        3Mml5jMMAqjkdWNHePSE8d0l5g==
X-Google-Smtp-Source: AMrXdXtfl+IHY/BqQz5jF8NRDduwkkFhDpZVXnsBT6Igcp4Yth9sgN3RtdqeK9HdRehKHU2oawaYoA==
X-Received: by 2002:aa7:d61a:0:b0:499:376e:6b2d with SMTP id c26-20020aa7d61a000000b00499376e6b2dmr3505449edr.0.1673195162009;
        Sun, 08 Jan 2023 08:26:02 -0800 (PST)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-80-180-23-57.pool80180.interbusiness.it. [80.180.23.57])
        by smtp.gmail.com with ESMTPSA id n3-20020aa7c443000000b00486074b4ce4sm2659614edr.68.2023.01.08.08.26.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Jan 2023 08:26:01 -0800 (PST)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh@kernel.org>, michael@amarulasolutions.com,
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
Subject: [RESEND RFC PATCH v5 2/5] dt-bindings: net: can: add STM32 bxcan DT bindings
Date:   Sun,  8 Jan 2023 17:25:51 +0100
Message-Id: <20230108162554.8375-3-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20230108162554.8375-1-dario.binacchi@amarulasolutions.com>
References: <20230108162554.8375-1-dario.binacchi@amarulasolutions.com>
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
Reviewed-by: Rob Herring <robh@kernel.org>

---

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

