Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 943B15BD27C
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 18:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbiISQty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 12:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbiISQtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 12:49:41 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8992B2DC4;
        Mon, 19 Sep 2022 09:49:37 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 7ACD05C0402;
        Mon, 19 Sep 2022 12:49:36 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 19 Sep 2022 12:49:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svenpeter.dev;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1663606176; x=
        1663692576; bh=AmcPpL+YdlnNYyjYJ3VxXFyfHrEQ8EiR8TRALxe0DkA=; b=u
        7KZtU7ZHza237+I29eDNRdipYUgLqHnGTrpI2ULpqTgljGIEH2/YIUqq4fr+ojf3
        JpMiCo9cAcVyypPuXe5uHfCn9r0CS1Ntf5VB63iOfykP4e6RXt7DkIVqhKTY7B0p
        9h4e3Ll5iE1pygcvOnuiY+Jljm7BAW/JbrkLc4I+4x7qBC8VL6cdI71tPkga2cUh
        5r7bjBTgzmERsDkUnU5F8wAzTt+zc8EQiZr1tLbloHeiW/37NLIkCmaQebJBF2+U
        BJRzTnZ+fnTC0Vl0X0H09KafFqdu4TFlpEAGh57tmpU7tl0hHeHuWdYHotYPhbMM
        EEuLDN/pOJ1h/OV/UPQVQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1663606176; x=1663692576; bh=AmcPpL+YdlnNY
        yjYJ3VxXFyfHrEQ8EiR8TRALxe0DkA=; b=PojaSPq1463dksscJWobpuezbbgCB
        oVECiPL3EUDpirp05Nes2cERUa4XgCEOKdP12aNiYsMWB+SKX3mUW29PObuTUm8N
        wb5dHDkZBdIlAN5HqQgKuwIsPaG9LudSdF4a+hNIUrj8AuLu88fhAyTejvQnfMKQ
        jeAOP4PSGTZXnJI2CoWQBFGYPlUA7pyakIIkw6YHMjc4l7j36M7rlDg5/L47DT49
        rRixKo2B1A3eaIT9c/31CRcGvsWLeDH1p1esMo6pKGa00WzbvEeT2bfE+v7QkHaW
        V9f4KhDxX3wAHG+DY+vLv1kE10++jiprJJRlIMSjEKNvIjWZ1bw32cNRw==
X-ME-Sender: <xms:oJ0oY8m7Gu-192Sib3mz7BqI0LLL2bya-hPNzW6xUnaJqSWh_ZJiMg>
    <xme:oJ0oY72mWoYjpu32U2BiMgM2GlVBeaWOrRTs90HxGm2tU5ygub4kQ6RIUPflajtl2
    0Je5Ij8uFl_WVeEkFM>
X-ME-Received: <xmr:oJ0oY6okAzpeuRhLahUrT8bh9r9wGcCCUT6VL-1qKUTa96UzvNdHMoTx7Ac7R_HGxKFZ8C6T1pzN22ulSU_9Rq4dEN3Qx9qAYcI0gleXzYhwOb5-e9oldAY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedvjedguddtkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefuvhgv
    nhcurfgvthgvrhcuoehsvhgvnhesshhvvghnphgvthgvrhdruggvvheqnecuggftrfgrth
    htvghrnhephfeufffgffegtdefhfefueejfefghfelkeetuddvffeigeffuedvjeegudel
    ieelnecuffhomhgrihhnpeguvghvihgtvghtrhgvvgdrohhrghenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehsvhgvnhesshhvvghnphgvthgv
    rhdruggvvh
X-ME-Proxy: <xmx:oJ0oY4nE4gNHYdWP3U_54h0nsSmQhZAbQFYRi0NYVye2gISIiXSWQA>
    <xmx:oJ0oY62IsJzT9C-0pnIMDOWKAQMX4xSTo0flJss_J2ZzWMYmhDCDvA>
    <xmx:oJ0oY_s7WNhDUv671o6Z5_PccJF8GfU3RmCcLk_kw8RSfnKvZfma7A>
    <xmx:oJ0oYzH6gTrc491PTFTkpxRTW4PQVEAGRfkpAglyNj1Pc_H-QIH1Jg>
Feedback-ID: i51094778:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Sep 2022 12:49:34 -0400 (EDT)
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
Subject: [PATCH v3 2/7] dt-bindings: net: Add Broadcom BCM4377 family PCIe Bluetooth
Date:   Mon, 19 Sep 2022 18:48:29 +0200
Message-Id: <20220919164834.62739-3-sven@svenpeter.dev>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220919164834.62739-1-sven@svenpeter.dev>
References: <20220919164834.62739-1-sven@svenpeter.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
changes from v2:
  - extended example to include parent pcie node to make
    node name validation work
  - moved to bluetooth/ subdirectory
  - added maxItems to reg and dropped description
  - moved bluetooth-controller.yaml reference after description

changes from v1:
  - added apple,* pattern to brcm,board-type
  - s/PCI/PCIe/
  - fixed 1st reg cell inside the example to not contain the bus number

 .../net/bluetooth/brcm,bcm4377-bluetooth.yaml | 81 +++++++++++++++++++
 MAINTAINERS                                   |  1 +
 2 files changed, 82 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth/brcm,bcm4377-bluetooth.yaml

diff --git a/Documentation/devicetree/bindings/net/bluetooth/brcm,bcm4377-bluetooth.yaml b/Documentation/devicetree/bindings/net/bluetooth/brcm,bcm4377-bluetooth.yaml
new file mode 100644
index 000000000000..37cb39a3a62e
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/bluetooth/brcm,bcm4377-bluetooth.yaml
@@ -0,0 +1,81 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/bluetooth/brcm,bcm4377-bluetooth.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Broadcom BCM4377 family PCIe Bluetooth Chips
+
+maintainers:
+  - Sven Peter <sven@svenpeter.dev>
+
+description:
+  This binding describes Broadcom BCM4377 family PCIe-attached bluetooth chips
+  usually found in Apple machines. The Wi-Fi part of the chip is described in
+  bindings/net/wireless/brcm,bcm4329-fmac.yaml.
+
+allOf:
+  - $ref: bluetooth-controller.yaml#
+
+properties:
+  compatible:
+    enum:
+      - pci14e4,5fa0 # BCM4377
+      - pci14e4,5f69 # BCM4378
+      - pci14e4,5f71 # BCM4387
+
+  reg:
+    maxItems: 1
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
+    pcie@a0000000 {
+      #address-cells = <3>;
+      #size-cells = <2>;
+      reg = <0xa0000000 0x1000000>;
+      device_type = "pci";
+      ranges = <0x43000000 0x6 0xa0000000 0xa0000000 0x0 0x20000000>;
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
index 9ae989b32ebb..74463bc5e1cb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1875,6 +1875,7 @@ F:	Documentation/devicetree/bindings/interrupt-controller/apple,*
 F:	Documentation/devicetree/bindings/iommu/apple,dart.yaml
 F:	Documentation/devicetree/bindings/iommu/apple,sart.yaml
 F:	Documentation/devicetree/bindings/mailbox/apple,mailbox.yaml
+F:	Documentation/devicetree/bindings/net/bluetooth/brcm,bcm4377-bluetooth.yaml
 F:	Documentation/devicetree/bindings/nvme/apple,nvme-ans.yaml
 F:	Documentation/devicetree/bindings/nvmem/apple,efuses.yaml
 F:	Documentation/devicetree/bindings/pci/apple,pcie.yaml
-- 
2.25.1

