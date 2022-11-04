Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37AD961A302
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 22:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbiKDVNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 17:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbiKDVNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 17:13:31 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 454392700;
        Fri,  4 Nov 2022 14:13:28 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 7A6753200583;
        Fri,  4 Nov 2022 17:13:26 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Fri, 04 Nov 2022 17:13:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svenpeter.dev;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1667596406; x=
        1667682806; bh=7hTRJUbc0mXpmE+XscfGSeRmmeMAJ2mNf4rMDCdGLeA=; b=P
        KQmW1CaPCIaJhaHRra0KrLzvoZOaAXo32DJ7lYiWDjc77iaQNM5L2UlMlnQ0Ruel
        JefTNl/s/9+UO8Of1GCCS5vSjxU9ZiHBybpWgw3l9Ja+MKedDdaatNbk/ddI0jC6
        zceNd7VkuEDGwPSVx7pHYsEpnzFmVmA85A+zy1gL3/fg3clrtSuV4o89rLVMXWxs
        Xz7ddMmvlVH5n/857cb+6QE2gcdZoY/84bMVw0RpT7MCuh+/pkxASq+GlkluWjIP
        R3YQaXTyFLB21TsgpcCWUcz226BaOBZp1pRSSp9pAUxFMC713AzRhvXyY5zkrh/i
        6gWEQIj1dPkn1GjCoyr+A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1667596406; x=1667682806; bh=7hTRJUbc0mXpm
        E+XscfGSeRmmeMAJ2mNf4rMDCdGLeA=; b=Qopvg2IxtQvm4zu/tPyLLJSfN8BuZ
        X+ihdjbYDtd4vz1j37mT66eptfAF1QspgSCTyOGl6xwTUihQZU/M9OjvEdQiJOfZ
        Qp24wI/Me/hhHMf24zMNLWvll6UWXveaF23MVGlLX2GuhBdjyBME+YjQDb24/RNm
        BjnErAiKU14dsrYhxdy/aCxwg3Z+ReJ5bkPqTyEDSwrG9TY25r8tLoOTBFksF38v
        hM+hj9+HgpizSRGcDrgXcdcvX5UP8TkdQMEdVFUzvs6pFgaRf2Fn/rCyztBYcXMW
        sy8bJE1xefq4qN/io/CxFwUfZjg2/MQ4LWOUXfnEXkJgnZiwjWBSe+rMg==
X-ME-Sender: <xms:dYBlY0aX3MmybkB0tfEfjx2crvuW7ws_y0MQgiNMnF0Xtb8pcxxX0Q>
    <xme:dYBlY_ZoU5NaCuSLHRxaGR1zMPkh8leYVyA9XUiC7pTBq5UBsKI_ufhadfuyfTPEG
    JC-z6LwFC1ctBOjmHo>
X-ME-Received: <xmr:dYBlY-8M-bgEMPp4AvNMsLxKXXo6D_6TghRyocKYtGw-cDsbrblzUU4EsMat1KxV7DIeb0Jgm371HUAdQE9g8f20vwK_bpEr7aLsu8O-5CuWe3u5D0HSmOqOTsq4nA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrvddugddugeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufhvvghn
    ucfrvghtvghruceoshhvvghnsehsvhgvnhhpvghtvghrrdguvghvqeenucggtffrrghtth
    gvrhhnpefhueffgfffgedtfefhfeeujeefgffhleekteduvdffieegffeuvdejgeduleei
    leenucffohhmrghinhepuggvvhhitggvthhrvggvrdhorhhgnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepshhvvghnsehsvhgvnhhpvghtvghr
    rdguvghv
X-ME-Proxy: <xmx:dYBlY-qn4PZpBVmjATjylfWbNFEnWJVLLOyhkHQ2SM8XqbIUaAeOVw>
    <xmx:dYBlY_p-f-gVPumFuBZYSKKV4qVmE_vWMMTC1nTjpialHDFEuSSRKQ>
    <xmx:dYBlY8RIvOUhyydDx_fl7MsPkoeiIjXDUcyfyxqCexoqbqJDEXMRog>
    <xmx:doBlY2_L4gFdW1RhSZ_15d8pbks-py-9dXQurvM0tH6Mx50P4D_h0g>
Feedback-ID: i51094778:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 4 Nov 2022 17:13:22 -0400 (EDT)
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
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v5 2/7] dt-bindings: net: Add Broadcom BCM4377 family PCIe Bluetooth
Date:   Fri,  4 Nov 2022 22:12:58 +0100
Message-Id: <20221104211303.70222-3-sven@svenpeter.dev>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20221104211303.70222-1-sven@svenpeter.dev>
References: <20221104211303.70222-1-sven@svenpeter.dev>
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
Reviewed-by: Rob Herring <robh@kernel.org>
---
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
index cf0f18502372..ca45551220f5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1903,6 +1903,7 @@ F:	Documentation/devicetree/bindings/interrupt-controller/apple,*
 F:	Documentation/devicetree/bindings/iommu/apple,dart.yaml
 F:	Documentation/devicetree/bindings/iommu/apple,sart.yaml
 F:	Documentation/devicetree/bindings/mailbox/apple,mailbox.yaml
+F:	Documentation/devicetree/bindings/net/bluetooth/brcm,bcm4377-bluetooth.yaml
 F:	Documentation/devicetree/bindings/nvme/apple,nvme-ans.yaml
 F:	Documentation/devicetree/bindings/nvmem/apple,efuses.yaml
 F:	Documentation/devicetree/bindings/pci/apple,pcie.yaml
-- 
2.25.1

