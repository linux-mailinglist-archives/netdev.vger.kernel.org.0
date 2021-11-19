Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDDDE457938
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 23:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234495AbhKSXCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 18:02:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232286AbhKSXCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 18:02:14 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEAC4C061574
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 14:59:11 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id n29so20562323wra.11
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 14:59:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l2FpiwDAO7pOnyKxr+YDaiFc0qgRv1B+JuygwRA5rXg=;
        b=QqLY+k6X0me6Sdqwfwa3p9tgIGv57CyXHvRkQh0UyvfIFH7hoZdNnfqsD+Sr6Vc3VW
         FGa/r9TBL8S2F3S64cLLRHssKCab9lk+KC0SRcHpqZJysCOwlcEcsqKztvNgQEXww9Fp
         KuAe3xcw+zQBi7ursPhWY/KKQHbvr741KKUxsMGO5jHsULAMjfuvE9d5c4oHFBQnaWqg
         VsXe4h+5IEJLhfEYPVG1fSRQXS2FUPuFMIsI+zsFoA+DF6ZGUcM5/NSqLXzS6WWpJyzU
         He+RdX86rhtU7OfEXI0eotZqcsMIjMqmfq1w7hGfgUIk4YSAmecSxRyfmlEpriYxT1od
         +0Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l2FpiwDAO7pOnyKxr+YDaiFc0qgRv1B+JuygwRA5rXg=;
        b=Xy+uUE3HFmN3GX10pR1pBplZ/tUnnSfks2kpERP1cYkHGCGKoUVjtYT6qSMAfzPUzY
         nlQaFbqunu0Epm4V8rx/CVsGK818/aVKXLgSUU4MwUwsLOR9L3zLm29Lh7bvsWLcnA84
         +vInaBBjRZzx/g974QihmpsY+0Oq0NTBs0Wz+2Jkr6n1WQgXan/C6kymojDuwaSZ4TRE
         ypIcCwUcaoO01wUmQNfwkvSLES6PeT76rG0Vz6ajFxNMh3yzuv6AMVbcGDmEeswrE19P
         J7GS4Sx8K+iOrbg7unLSC/SVi1fMPyofPAh3ZJMP5lVddUXjND1pURGH1CQl7vcpqAKE
         2roQ==
X-Gm-Message-State: AOAM531cLw54pCGe4wy7KkZuyeYelsfXhFb5LDdHAPs4hKVt4jUo7B8M
        mvDc9oioH3/055X8HR4Nsh6yLw==
X-Google-Smtp-Source: ABdhPJwNDuXky/RB34lEMrYgTSq5FRnDCFsGZce2uL7YojAvogFzNOW7IrnBuHNOai0VshwcEG91tQ==
X-Received: by 2002:a05:6000:1788:: with SMTP id e8mr12366353wrg.45.1637362750393;
        Fri, 19 Nov 2021 14:59:10 -0800 (PST)
Received: from hornet.engleder.at (dynamic-2ent3hb60johxrmi81-pd01.res.v6.highway.a1.net. [2001:871:23a:8366:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id n32sm17637377wms.1.2021.11.19.14.59.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 14:59:10 -0800 (PST)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next v6 2/3] dt-bindings: net: Add tsnep Ethernet controller
Date:   Fri, 19 Nov 2021 23:58:25 +0100
Message-Id: <20211119225826.19617-3-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211119225826.19617-1-gerhard@engleder-embedded.com>
References: <20211119225826.19617-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TSN endpoint Ethernet MAC is a FPGA based network device for
real-time communication.

It is integrated as normal Ethernet controller with
ethernet-controller.yaml and mdio.yaml.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 .../bindings/net/engleder,tsnep.yaml          | 79 +++++++++++++++++++
 1 file changed, 79 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/engleder,tsnep.yaml

diff --git a/Documentation/devicetree/bindings/net/engleder,tsnep.yaml b/Documentation/devicetree/bindings/net/engleder,tsnep.yaml
new file mode 100644
index 000000000000..d0e1476e15b5
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/engleder,tsnep.yaml
@@ -0,0 +1,79 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/engleder,tsnep.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: TSN endpoint Ethernet MAC binding
+
+maintainers:
+  - Gerhard Engleder <gerhard@engleder-embedded.com>
+
+allOf:
+  - $ref: ethernet-controller.yaml#
+
+properties:
+  compatible:
+    const: engleder,tsnep
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  local-mac-address: true
+
+  mac-address: true
+
+  nvmem-cells: true
+
+  nvmem-cells-names: true
+
+  phy-connection-type:
+    enum:
+      - mii
+      - gmii
+      - rgmii
+      - rgmii-id
+
+  phy-mode: true
+
+  phy-handle: true
+
+  mdio:
+    type: object
+    $ref: "mdio.yaml#"
+    description: optional node for embedded MDIO controller
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
+    axi {
+        #address-cells = <2>;
+        #size-cells = <2>;
+        tnsep0: ethernet@a0000000 {
+            compatible = "engleder,tsnep";
+            reg = <0x0 0xa0000000 0x0 0x10000>;
+            interrupts = <0 89 1>;
+            interrupt-parent = <&gic>;
+            local-mac-address = [00 00 00 00 00 00];
+            phy-mode = "rgmii";
+            phy-handle = <&phy0>;
+            mdio {
+                #address-cells = <1>;
+                #size-cells = <0>;
+                suppress-preamble;
+                phy0: ethernet-phy@1 {
+                    reg = <1>;
+                    rxc-skew-ps = <1080>;
+                };
+            };
+        };
+    };
-- 
2.20.1

