Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7065458679F
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 12:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbiHAKj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 06:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbiHAKjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 06:39:53 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 428A037F97;
        Mon,  1 Aug 2022 03:39:52 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id A0AAA5C012A;
        Mon,  1 Aug 2022 06:39:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 01 Aug 2022 06:39:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svenpeter.dev;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1659350391; x=
        1659436791; bh=yLEITPbjWt/A+Iiihaaicca+6oF5HSWu2mCsCGmcH8o=; b=m
        UISXNLDqHM3e+5BQVkBPfFpW4fZ/n/lOtf4URyhHvABo9kkMAyg9P7oUJtx4DY8t
        zJldZjZtWXXGXFebCIh5tUS3U4hiWs0nQ177MVr3NQdV2UsU2D7yKT7qgp4p59m2
        UKENjFpKpjs5wo0jXcLbRfDYpZTKLiekmaQlq5I2br9e7/igyZgfmBngPiBlGh0t
        GqMxcfXdvOpADw2TYjp6FX2YoziZIrbB57jMi1YCB88X8Bv+B/zYTDSa0z9jmpdN
        a01cpOqRquaH+dYnPVg88liRxy9wAC0Rl13M/AhMZHHUnVxB+4H4IZ1uN/DCMXHs
        ImvXWiYHx+B4DyCklFQyw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1659350391; x=1659436791; bh=yLEITPbjWt/A+
        Iiihaaicca+6oF5HSWu2mCsCGmcH8o=; b=K8FmSir98NW6EM2h8KQs92IIbzOtg
        A9WskitIZml2UceaAO7RCda8FjpfzZRwMojU281AbsyJhXawR+YG35Qyw4BrIBT2
        tfKz3xW1XehhTLQJT0oTXOodFqC/TrI5GaNmpArT9dYrsNFBDNrNzPQyhkaoyoHJ
        d0oi+BxWL5Eb/7WfEQ5h71Ka0XktpmESmHfFmEgDLKHgg1nNGExZBmhSiHcf+JsL
        eSoIPPNHTICjmBGB6IwlI8yNup4U5F4821DoD379Bs9j1tYYFq/fQkmaGChY7uZf
        qQpSPjUFvHpzSHimgFJw/+nRQ0pxKTIEua4+sQYeFuhoqPPauiInHTPnQ==
X-ME-Sender: <xms:d63nYieUHlw7klpS8GW_aay-EUcVF5i_5wh9plnkTu1FFY60wkt2Gg>
    <xme:d63nYsM6CmCebp_bwcHET__L3JfaZRU9aaU7AtWZuhoQrmraUDVTW881Z_NxbIG9z
    Ow2-hxke_L_EgOBcFo>
X-ME-Received: <xmr:d63nYjiPSlIhAbaHyRcbxDAbZsRvrcn_3Qnb48zAa_Us49KCiDATMw4Gx9sOTBzodxHA7bpVo2fMkZJ9djHplUXD_Pqz6vYcYfAnNhuQu92gmaA2LvKIKHM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvddvfedgfedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufhvvghn
    ucfrvghtvghruceoshhvvghnsehsvhgvnhhpvghtvghrrdguvghvqeenucggtffrrghtth
    gvrhhnpefhueffgfffgedtfefhfeeujeefgffhleekteduvdffieegffeuvdejgeduleei
    leenucffohhmrghinhepuggvvhhitggvthhrvggvrdhorhhgnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepshhvvghnsehsvhgvnhhpvghtvghr
    rdguvghv
X-ME-Proxy: <xmx:d63nYv-27uKu3WR2EHo_0nMoEdPMkkZMuq-t-iONg4A4tLNvC3XwJw>
    <xmx:d63nYuvIZClMIY7F7RZtFaxN4wmllnGwt3MAXs8IL0DI9K9aBigL0g>
    <xmx:d63nYmFK969EJ30amP40bSG2HvgMLaBcC-RwYj-f7WkQ_zuof2Axiw>
    <xmx:d63nYv8X25YYkD7kuh8Imzn9gd-AsIjAKlp0axT_rpsqPDXxsfN-vA>
Feedback-ID: i51094778:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 1 Aug 2022 06:39:49 -0400 (EDT)
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
Subject: [PATCH 2/5] dt-bindings: net: Add Broadcom BCM4377 family PCI Bluetooth
Date:   Mon,  1 Aug 2022 12:36:30 +0200
Message-Id: <20220801103633.27772-3-sven@svenpeter.dev>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220801103633.27772-1-sven@svenpeter.dev>
References: <20220801103633.27772-1-sven@svenpeter.dev>
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
 .../bindings/net/brcm,bcm4377-bluetooth.yaml  | 77 +++++++++++++++++++
 MAINTAINERS                                   |  1 +
 2 files changed, 78 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/brcm,bcm4377-bluetooth.yaml

diff --git a/Documentation/devicetree/bindings/net/brcm,bcm4377-bluetooth.yaml b/Documentation/devicetree/bindings/net/brcm,bcm4377-bluetooth.yaml
new file mode 100644
index 000000000000..afe6ecebd939
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/brcm,bcm4377-bluetooth.yaml
@@ -0,0 +1,77 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/brcm,bcm4377-bluetooth.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Broadcom BCM4377 family PCI Bluetooth Chips
+
+allOf:
+  - $ref: bluetooth-controller.yaml#
+
+maintainers:
+  - Sven Peter <sven@svenpeter.dev>
+
+description:
+  This binding describes Broadcom BCM4377 family PCI-attached bluetooth chips
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
+    pci0 {
+      #address-cells = <3>;
+      #size-cells = <2>;
+
+      bluetooth@0,1 {
+        compatible = "pci14e4,5f69";
+        reg = <0x10100 0x0 0x0 0x0 0x0>;
+        brcm,board-type = "apple,honshu";
+        /* To be filled by the bootloader */
+        local-bd-address = [00 00 00 00 00 00];
+      };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index a6d3bd9d2a8d..8965556bace8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1837,6 +1837,7 @@ F:	Documentation/devicetree/bindings/interrupt-controller/apple,*
 F:	Documentation/devicetree/bindings/iommu/apple,dart.yaml
 F:	Documentation/devicetree/bindings/iommu/apple,sart.yaml
 F:	Documentation/devicetree/bindings/mailbox/apple,mailbox.yaml
+F:	Documentation/devicetree/bindings/net/brcm,bcm4377-bluetooth.yaml
 F:	Documentation/devicetree/bindings/nvme/apple,nvme-ans.yaml
 F:	Documentation/devicetree/bindings/nvmem/apple,efuses.yaml
 F:	Documentation/devicetree/bindings/pci/apple,pcie.yaml
-- 
2.25.1

