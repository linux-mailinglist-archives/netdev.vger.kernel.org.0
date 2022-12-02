Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E87BC640908
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 16:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233745AbiLBPMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 10:12:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232896AbiLBPMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 10:12:15 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4859BA1C33;
        Fri,  2 Dec 2022 07:12:14 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id DC9B51CFE;
        Fri,  2 Dec 2022 16:12:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1669993932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5ErHOuVqamJL2o6/BgNVZJv/e995LbZA3fygdjVBqeQ=;
        b=U4yUfxr9BHbC0c7O4RX6etC7VMhKySIHMUC4Wiiy+SLwU1pF0eDBcm9yx3aaaO7nJBvuc4
        Xw+cg0poEHQXHKEueCmTKhPJ3iX52pebY3BQ8VPkbdS2jQnfmkzK3DFZ/3Q4l1lp+/UrWA
        46MGCRzj5GWC0Ne1EyjAmps8Z7i5aF4+u0aCpZeyqWdp4Fbq88CEjfr0OXXWvhhQZIrBcy
        ojSnCUqRJtwHEbx0Z+KV6U9GFEJ1Xe0GZ2jlWsKI1OYO/lGFXUStN0A6kidA0UJqt8MOVk
        7wYu/YUn2yY8kmEI49iUdosARxQxqiQ2EKTwVaWKUR3rLWm09wAn/HseYANzRQ==
From:   Michael Walle <michael@walle.cc>
To:     Xu Liang <lxu@maxlinear.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v1 3/4] dt-bindings: net: phy: add MaxLinear GPY2xx bindings
Date:   Fri,  2 Dec 2022 16:12:03 +0100
Message-Id: <20221202151204.3318592-4-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221202151204.3318592-1-michael@walle.cc>
References: <20221202151204.3318592-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the device tree bindings for the MaxLinear GPY2xx PHYs.

Signed-off-by: Michael Walle <michael@walle.cc>
---

Is the filename ok? I was unsure because that flag is only for the GPY215
for now. But it might also apply to others. Also there is no compatible
string, so..

 .../bindings/net/maxlinear,gpy2xx.yaml        | 47 +++++++++++++++++++
 1 file changed, 47 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/maxlinear,gpy2xx.yaml

diff --git a/Documentation/devicetree/bindings/net/maxlinear,gpy2xx.yaml b/Documentation/devicetree/bindings/net/maxlinear,gpy2xx.yaml
new file mode 100644
index 000000000000..d71fa9de2b64
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/maxlinear,gpy2xx.yaml
@@ -0,0 +1,47 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/maxlinear,gpy2xx.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: MaxLinear GPY2xx PHY
+
+maintainers:
+  - Andrew Lunn <andrew@lunn.ch>
+  - Michael Walle <michael@walle.cc>
+
+allOf:
+  - $ref: ethernet-phy.yaml#
+
+properties:
+  maxlinear,use-broken-interrupts:
+    description: |
+      Interrupts are broken on some GPY2xx PHYs in that they keep the
+      interrupt line asserted even after the interrupt status register is
+      cleared. Thus it is blocking the interrupt line which is usually bad
+      for shared lines. By default interrupts are disabled for this PHY and
+      polling mode is used. If one can live with the consequences, this
+      property can be used to enable interrupt handling.
+
+      Affected PHYs (as far as known) are GPY215B and GPY215C.
+    type: boolean
+
+dependencies:
+  maxlinear,use-broken-interrupts: [ interrupts ]
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    ethernet {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        ethernet-phy@0 {
+            reg = <0>;
+            interrupts-extended = <&intc 0>;
+            maxlinear,use-broken-interrupts;
+        };
+    };
+
+...
-- 
2.30.2

