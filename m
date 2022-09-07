Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6E9A5B0B1F
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 19:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbiIGRKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 13:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiIGRKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 13:10:00 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407DA7DF41;
        Wed,  7 Sep 2022 10:09:57 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id D0B5E320092A;
        Wed,  7 Sep 2022 13:09:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 07 Sep 2022 13:09:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svenpeter.dev;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1662570594; x=
        1662656994; bh=mQPO/JkIQlhcGyNGHSuGKse2NAHa3zF6V4qeVXZn3pM=; b=Y
        bDRHkXv+wTeiJCioXZkw0owpvglq9ql4AL5vQKRLdghTGZZY260+eSD4CjtRbJEn
        Ul9LIxjAt3LRktI7XKxCVf1vH1EP2zTFrj7oyB/BoH78v8s6v3FPUBpsYbfAFFnQ
        a1H4hEuzh51DKpYfGoiHzZnzo/RTFgJRxHh6Gb2JUWM6ig5xCjC7qfgdTbEs/mem
        NrJ9b+vB1nSM+et7lO5pwCUNn+UmHPtCODCYvfBPYxLU8B5VbL7urZhvZPqSYR4b
        PZQmbjoqK/wZpyJPfmBkLLh67P+V3tvMER+TTUFKQx5/EvuwLICqjSZApSRmPAia
        8FZl3PgpzIV4ZM9ZQI9hQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1662570594; x=1662656994; bh=mQPO/JkIQlhcG
        yNGHSuGKse2NAHa3zF6V4qeVXZn3pM=; b=q73qQ4UJqO387R6XuVQIZr88BLcWl
        YT1Sk71IvtS3qVNVEQsg2ilOcEJ6opu4KfjAIFrkfQ8sCwFfdiTMHx+pTvNOVG7J
        lGV3MQWRXP1ChfZBaQoDKuzW7lvI32eqmBxXVJS/DYTXV4evHuRT6dBDzzWcQM2e
        z+5MGOqanK8aCGHTgFSilYB7baj8GWOMbHefEoBP4EtgsbFLBuggCQhheOJ6kTqG
        G2wXdtRoe3WLoao4eYnL9lWsqT03OxoGeCsL8Tauknq3qkUE+gJ526hs5fcOSSo+
        lQM+jcM718ce7Zyr2v1IrL+b22BWYh7vBTV3+VzQMzQbohbqA8RfpcM+A==
X-ME-Sender: <xms:YtAYY7qDgo-W3T7hLc4w7f3SENffKJ5-XcFCuG0JHaSY1PDnTRuajQ>
    <xme:YtAYY1pOWWAh4kysY4SODOip_iWF70wF0aEjokIDFNMWB10kNu_vOpn_uZtuORV9a
    0ktfuwY6XaJ4T6zbnE>
X-ME-Received: <xmr:YtAYY4OQw4Am9od-_dfd9c0SL_cxW1FmTy2kwQFNyyYlDF-g84ykV_CVDgdvzUvWAccXG1VB3EQX8oRyWN-bg8jp44uTdYO8qcGxP2kVIA9JB6HJwHk8u68>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedttddguddtlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefuvhgv
    nhcurfgvthgvrhcuoehsvhgvnhesshhvvghnphgvthgvrhdruggvvheqnecuggftrfgrth
    htvghrnhephfeufffgffegtdefhfefueejfefghfelkeetuddvffeigeffuedvjeegudel
    ieelnecuffhomhgrihhnpeguvghvihgtvghtrhgvvgdrohhrghenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehsvhgvnhesshhvvghnphgvthgv
    rhdruggvvh
X-ME-Proxy: <xmx:YtAYY-6lwZ4EwP14A53eLjPPD67VW4vKFb-tOzVynAUWOYaZWsoUhw>
    <xmx:YtAYY64-MytbABzHbmNyM681eTeo08phGSxomlnvi2DE0duPuLcWcQ>
    <xmx:YtAYY2igcJzozOtfz67UztFWgDXipWX9KXMzO5HL-tlti_9cIwirSw>
    <xmx:YtAYY2oYhIUZKS9vU0k0IyOKxCTkqucq27zwInHeso3ZW9OumBr4yw>
Feedback-ID: i51094778:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 7 Sep 2022 13:09:51 -0400 (EDT)
From:   Sven Peter <sven@svenpeter.dev>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Sven Peter <sven@svenpeter.dev>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hector Martin <marcan@marcan.st>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        asahi@lists.linux.dev, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/5] dt-bindings: net: Add Broadcom BCM4377 family PCIe Bluetooth
Date:   Wed,  7 Sep 2022 19:09:32 +0200
Message-Id: <20220907170935.11757-3-sven@svenpeter.dev>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220907170935.11757-1-sven@svenpeter.dev>
References: <20220907170935.11757-1-sven@svenpeter.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These chips are combined Wi-Fi/Bluetooth radios which expose a
PCI subfunction for the Bluetooth part.
They are found in Apple machines such as the x86 models with the T2
chip or the arm64 models with the M1 or M2 chips.

Signed-off-by: Sven Peter <sven@svenpeter.dev>
---
changes from v1:
  - added apple,* pattern to brcm,board-type
  - s/PCI/PCIe/
  - fixed 1st reg cell inside the example to not contain the bus number

.../bindings/net/brcm,bcm4377-bluetooth.yaml  | 78 +++++++++++++++++++
 MAINTAINERS                                   |  1 +
 2 files changed, 79 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/brcm,bcm4377-bluetooth.yaml

diff --git a/Documentation/devicetree/bindings/net/brcm,bcm4377-bluetooth.yaml b/Documentation/devicetree/bindings/net/brcm,bcm4377-bluetooth.yaml
new file mode 100644
index 000000000000..fb851f8e6bcb
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/brcm,bcm4377-bluetooth.yaml
@@ -0,0 +1,78 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/brcm,bcm4377-bluetooth.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Broadcom BCM4377 family PCIe Bluetooth Chips
+
+allOf:
+  - $ref: bluetooth-controller.yaml#
+
+maintainers:
+  - Sven Peter <sven@svenpeter.dev>
+
+description:
+  This binding describes Broadcom BCM4377 family PCIe-attached bluetooth chips
+  usually found in Apple machines. The Wi-Fi part of the chip is described in
+  bindings/net/wireless/brcm,bcm4329-fmac.yaml.
+
+properties:
+  compatible:
+    enum:
+      - pci14e4,5fa0 # BCM4377
+      - pci14e4,5f69 # BCM4378
+      - pci14e4,5f71 # BCM4387
+
+  reg:
+    description: PCI device identifier.
+
+  brcm,board-type:
+    $ref: /schemas/types.yaml#/definitions/string
+    description: Board type of the Bluetooth chip. This is used to decouple
+      the overall system board from the Bluetooth module and used to construct
+      firmware and calibration data filenames.
+      On Apple platforms, this should be the Apple module-instance codename
+      prefixed by "apple,", e.g. "apple,atlantisb".
+    pattern: '^apple,.*'
+
+  brcm,taurus-cal-blob:
+    $ref: /schemas/types.yaml#/definitions/uint8-array
+    description: A per-device calibration blob for the Bluetooth radio. This
+      should be filled in by the bootloader from platform configuration
+      data, if necessary, and will be uploaded to the device.
+      This blob is used if the chip stepping of the Bluetooth module does not
+      support beamforming.
+
+  brcm,taurus-bf-cal-blob:
+    $ref: /schemas/types.yaml#/definitions/uint8-array
+    description: A per-device calibration blob for the Bluetooth radio. This
+      should be filled in by the bootloader from platform configuration
+      data, if necessary, and will be uploaded to the device.
+      This blob is used if the chip stepping of the Bluetooth module supports
+      beamforming.
+
+  local-bd-address: true
+
+required:
+  - compatible
+  - reg
+  - local-bd-address
+  - brcm,board-type
+
+additionalProperties: false
+
+examples:
+  - |
+    pcie {
+      #address-cells = <3>;
+      #size-cells = <2>;
+
+      bluetooth@0,1 {
+        compatible = "pci14e4,5f69";
+        reg = <0x100 0x0 0x0 0x0 0x0>;
+        brcm,board-type = "apple,honshu";
+        /* To be filled by the bootloader */
+        local-bd-address = [00 00 00 00 00 00];
+      };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index 8a5012ba6ff9..5cc9c2da1140 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1875,6 +1875,7 @@ F:	Documentation/devicetree/bindings/interrupt-controller/apple,*
 F:	Documentation/devicetree/bindings/iommu/apple,dart.yaml
 F:	Documentation/devicetree/bindings/iommu/apple,sart.yaml
 F:	Documentation/devicetree/bindings/mailbox/apple,mailbox.yaml
+F:	Documentation/devicetree/bindings/net/brcm,bcm4377-bluetooth.yaml
 F:	Documentation/devicetree/bindings/nvme/apple,nvme-ans.yaml
 F:	Documentation/devicetree/bindings/nvmem/apple,efuses.yaml
 F:	Documentation/devicetree/bindings/pci/apple,pcie.yaml
-- 
2.25.1

