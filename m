Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 298EC6ECA10
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 12:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbjDXKUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 06:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbjDXKUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 06:20:40 -0400
X-Greylist: delayed 1516 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 24 Apr 2023 03:20:37 PDT
Received: from forward501c.mail.yandex.net (forward501c.mail.yandex.net [IPv6:2a02:6b8:c03:500:1:45:d181:d501])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4722010DF;
        Mon, 24 Apr 2023 03:20:37 -0700 (PDT)
Received: from mail-nwsmtp-smtp-production-main-39.myt.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-39.myt.yp-c.yandex.net [IPv6:2a02:6b8:c12:261e:0:640:2e3d:0])
        by forward501c.mail.yandex.net (Yandex) with ESMTP id 7DE0C5EE97;
        Mon, 24 Apr 2023 12:35:51 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-39.myt.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id JZBb1pbWwKo0-71ti2XdL;
        Mon, 24 Apr 2023 12:35:51 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maquefel.me; s=mail; t=1682328951;
        bh=9OWyaTijH8WZgd/u9wb0Try8woOOARXYqCsnpX6d1qM=;
        h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
        b=nBWGWBMiM9Od+YnfT7BAtTGa5YQ2BdqzrkqVqtMVbSvilPeSrljQzo0e40adGGbAt
         VZ/hKmw+vqOkRC0+6yP4k5wVL5MvARibL+ByuJg+cR3DG3Pb6B7vT7wlu5OtzXYVJZ
         ZKVDu9N7Z/18CSukw+SRwoBx1iquZpX99c0PACbk=
Authentication-Results: mail-nwsmtp-smtp-production-main-39.myt.yp-c.yandex.net; dkim=pass header.i=@maquefel.me
From:   Nikita Shubin <nikita.shubin@maquefel.me>
Cc:     Arnd Bergmann <arnd@kernel.org>, Linus Walleij <linusw@kernel.org>,
        Alexander Sverdlin <alexander.sverdlin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 18/43] dt-bindings: net: Add DT bindings ep93xx eth
Date:   Mon, 24 Apr 2023 15:34:34 +0300
Message-Id: <20230424123522.18302-19-nikita.shubin@maquefel.me>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230424123522.18302-1-nikita.shubin@maquefel.me>
References: <20230424123522.18302-1-nikita.shubin@maquefel.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add YAML bindings for ep93xx SoC.

Signed-off-by: Nikita Shubin <nikita.shubin@maquefel.me>
---
 .../bindings/net/cirrus,ep93xx_eth.yaml       | 51 +++++++++++++++++++
 1 file changed, 51 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/cirrus,ep93xx_eth.yaml

diff --git a/Documentation/devicetree/bindings/net/cirrus,ep93xx_eth.yaml b/Documentation/devicetree/bindings/net/cirrus,ep93xx_eth.yaml
new file mode 100644
index 000000000000..7e73cf0ddde9
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/cirrus,ep93xx_eth.yaml
@@ -0,0 +1,51 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/cirrus,ep93xx_eth.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: The ethernet hardware included in EP93xx CPUs module Device Tree Bindings
+
+maintainers:
+  - Hartley Sweeten <hsweeten@visionengravers.com>
+
+properties:
+  compatible:
+    const: cirrus,ep9301-eth
+
+  reg:
+    items:
+      - description: The physical base address and size of IO range
+
+  interrupts:
+    items:
+      - description: Combined signal for various interrupt events
+
+  copy_addr:
+    type: boolean
+    description:
+      Flag indicating that the MAC address should be copied
+      from the IndAd registers (as programmed by the bootloader)
+
+  phy_id:
+    description: MII phy_id to use
+
+required:
+  - compatible
+  - reg
+  - interrupts
+
+additionalProperties: false
+
+examples:
+  - |
+    eth0: eth@80010000 {
+        compatible = "cirrus,ep9301-eth";
+        reg = <0x80010000 0x10000>;
+        interrupt-parent = <&vic1>;
+        interrupts = <7>;
+        copy_addr;
+        phy_id = < 1 >;
+    };
+
+...
-- 
2.39.2

