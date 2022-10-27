Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBE4860FB44
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 17:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236047AbiJ0PJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 11:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235991AbiJ0PIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 11:08:45 -0400
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9069618F247;
        Thu, 27 Oct 2022 08:08:44 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id CBA39320094A;
        Thu, 27 Oct 2022 11:08:42 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 27 Oct 2022 11:08:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svenpeter.dev;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1666883322; x=
        1666969722; bh=7hTRJUbc0mXpmE+XscfGSeRmmeMAJ2mNf4rMDCdGLeA=; b=H
        6M/QY4AJ6FD9hk8sNv6u1fx6saodbMQd9yuetA/4x1YkEeF+mVZs/xeGXVoQhfOl
        PZlGd0zG+liaB7GpHUceLPhXeKGnnE+c+L59GHjlO8HfFV2mKCSSLc4QZwvf85yh
        cn/wWTAMhjAzjG3xyP4xXzPWkcpJWiwUttIn7mQiG1js9F+mlziq4roRidZQ2r4k
        DhQa/YeivzptizBW54jICrw/01swl/EClvhPH0dHs3B/67h8s46W/KTbigMV0bm5
        yCdsc/nK6X+HNHclMEFOqaa0yPwn37V8T1jWlkHNQrtE+RwfiLdA/YoLbym+vRwM
        ffH+xa8MQR0LQNw+0ZoEw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1666883322; x=1666969722; bh=7hTRJUbc0mXpm
        E+XscfGSeRmmeMAJ2mNf4rMDCdGLeA=; b=nm1vhYWpwpx14TzKIFieQAEHpg3K3
        vLWS85FLGz9487o7zlDr6+rnAHRZKhaQfM+kAkWG/p4klp+k2k7qY9vP3cv4CvZg
        hWqoE8tnJoMJ9FvhImjxZIn4ySPNvq6XcaAg1Boex0P5BuaDqejXQfbrQqvZ7F6O
        FIpDtGYzAVv68opc2WXKFnkQNFdSIB4BYSU5iCYofzui9n3cJy7c9ti51msgKmuC
        KR5QPlpreRDGVb1A6DIgD7SyZNjdXXTJLNOfQCQ23kJYav8lGJhKeh3cOupuv2Zc
        XKoaZDXmg6lIywpTyxIuAXyWSo7SVbUBG8axXYSiypW2/jEjfgDoU3qlw==
X-ME-Sender: <xms:-p5aYwwpmbwC8efATp67goDE5fsilSK8b_n_Chu33lGWb479CJOmNg>
    <xme:-p5aY0ReHW_57CxKWm4-y2xNtVK9iE1Zb7QjxleYZbPsQQvni4wGo18Ash5QfUDDt
    DyJQvssCsnNbMkkvK8>
X-ME-Received: <xmr:-p5aYyWTQojd_GJj7__NfoWvD7ZuA3dt5uZYiZgpZ8gHk_PCCaZ-EVImsnfyX_g3ApaSeVBPUqh4fxwOmXucvpMSrkYtWGW2uNhWSOSpJpDxXkdXiej9GPQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrtdeggdekfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefuvhgvnhcu
    rfgvthgvrhcuoehsvhgvnhesshhvvghnphgvthgvrhdruggvvheqnecuggftrfgrthhtvg
    hrnhephfeufffgffegtdefhfefueejfefghfelkeetuddvffeigeffuedvjeegudelieel
    necuffhomhgrihhnpeguvghvihgtvghtrhgvvgdrohhrghenucevlhhushhtvghrufhiii
    gvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehsvhgvnhesshhvvghnphgvthgvrhdr
    uggvvh
X-ME-Proxy: <xmx:-p5aY-hQi9UDoqOCslkWB2nJPyDKS_VUDGNKudlynBXdHhzrG4ftWQ>
    <xmx:-p5aYyCnJRk8kOBq5_sJRvX0mE5L0TA8tg6st1m9TBwtpCaL04zeug>
    <xmx:-p5aY_KEldsUFvqjySL3YplYs8T23x938-_ybQyxApLLbdmbEQ74Yw>
    <xmx:-p5aY62BnsNRet642LOhE83w-jmpP4A6TBg9OBJCp0X-lJsttQvKhA>
Feedback-ID: i51094778:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Oct 2022 11:08:39 -0400 (EDT)
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
Subject: [PATCH v4 2/7] dt-bindings: net: Add Broadcom BCM4377 family PCIe Bluetooth
Date:   Thu, 27 Oct 2022 17:08:17 +0200
Message-Id: <20221027150822.26120-3-sven@svenpeter.dev>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20221027150822.26120-1-sven@svenpeter.dev>
References: <20221027150822.26120-1-sven@svenpeter.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

