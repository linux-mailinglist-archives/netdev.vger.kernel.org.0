Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3E4E3F7E53
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 00:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbhHYWWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 18:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232718AbhHYWWO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 18:22:14 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D8E0C06179A;
        Wed, 25 Aug 2021 15:21:26 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id c4so433436plh.7;
        Wed, 25 Aug 2021 15:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QoJgSL4P/50e8d1qyRlkjXL/xWvFyxNHJu1MeShhwG4=;
        b=Z7T7L1BQlCVqXuDAeBmRXzgJxUFxP0i2XRNTAo5ad9NIqLP0mtlikU5wEfDQNUwb9Z
         FDt2H1u5rqWhRD/OZqYNMxm9AFf5pbmUpb1j9SnleNoJ0mrrwdZZCvzoZ5mXEEFxlZoy
         4ptGwoDNoJuGFjMQaM+/W+FnYuRcAV/o2s53iU0RUM32THHA6UCs6p1wJ9rvqhpQ71ad
         RSfNxsakWT3Y5faSD4i1cT9zfPnIRZEaiuTIPl5K6W5VEMwMbxG1/uLhkULEjB0Idr93
         XMJDXqAATWR9u3lEJDFgckIuajgeSFySd9Htfj62gFf5NqNqmLMaW3O8DDoMQbqGdjDN
         C3uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=QoJgSL4P/50e8d1qyRlkjXL/xWvFyxNHJu1MeShhwG4=;
        b=SpbQ/TzARun3rXFSwwYriiYjp1n1sTbiG8FByIIOfriwMHc/0YK2kdli0AIFIOvfAp
         tGZF1F1A9bU830wtJFTkuV3QVo4T+e6hMAk03/GzhewLFMCs4elF1vRqlHNKWgV3sYZL
         7il/6FsuEu4q2EKmQ6QBzt4OESwFZHYKuaRgzrmmYeJRVqImEHUOBZ205yf9DnhhBc/j
         f9YFx5AJXnbFvd3IH/lWkIC01qJEgnS1gsvGWgBk1djwwg6q48nlJL9kKjjlHJfDB+IM
         MhC55eS47OYX6dCSwlhprc6GKeSIfmpN7SSIcOvuesvbLy0e8uPM+jCDHTWT6pRXl75D
         +qAw==
X-Gm-Message-State: AOAM5305nQS69uQLbFTsybb1sbYEfxL+mjvUhuqd3poa5FOS5dC+XSP4
        FNSUq6KX2LJ+rSeulC16j9NouK+dtlI=
X-Google-Smtp-Source: ABdhPJz8fuAdFDU0Dl0rXOyQ5auptj7oNG5WKSdVgq5uKeuPYMKB+mLe2f4klzEstP2vydyouF1SGw==
X-Received: by 2002:a17:90a:ab94:: with SMTP id n20mr13090592pjq.146.1629930085424;
        Wed, 25 Aug 2021 15:21:25 -0700 (PDT)
Received: from localhost.localdomain ([45.124.203.15])
        by smtp.gmail.com with ESMTPSA id t18sm616227pfg.111.2021.08.25.15.21.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 15:21:24 -0700 (PDT)
Sender: "joel.stan@gmail.com" <joel.stan@gmail.com>
From:   Joel Stanley <joel@jms.id.au>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        devicetree@vger.kernel.org,
        Florent Kermarrec <florent@enjoy-digital.fr>,
        "Gabriel L . Somlo" <gsomlo@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/2] dt-bindings: net: Add bindings for LiteETH
Date:   Thu, 26 Aug 2021 07:51:05 +0930
Message-Id: <20210825222106.3113287-2-joel@jms.id.au>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210825222106.3113287-1-joel@jms.id.au>
References: <20210825222106.3113287-1-joel@jms.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LiteETH is a small footprint and configurable Ethernet core for FPGA
based system on chips.

The hardware is parametrised by the size and number of the slots in it's
receive and send buffers. These are described as properties, with the
commonly used values set as the default.

Signed-off-by: Joel Stanley <joel@jms.id.au>
---
v2:
 - Fix dtschema check warning relating to registers
 - Add names to the registers to make it easier to distinguish which is
   what region
 - Add mdio description
 - Include ethernet-controller parent description
v3:
 - Define names for reg-names
 - update example to match common case
 - describe the hardware using slots and slot sizes. This is how the
   hardware is pramaterised, and it makes more sense than trying to use
   the rx/tx-fifo-size properties
v4:
 - Don't need minItems if it is equal to 'items' length.
 - Add Rob's r-b
---
 .../bindings/net/litex,liteeth.yaml           | 98 +++++++++++++++++++
 1 file changed, 98 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/litex,liteeth.yaml

diff --git a/Documentation/devicetree/bindings/net/litex,liteeth.yaml b/Documentation/devicetree/bindings/net/litex,liteeth.yaml
new file mode 100644
index 000000000000..76c164a8199a
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/litex,liteeth.yaml
@@ -0,0 +1,98 @@
+# SPDX-License-Identifier: GPL-2.0-or-later OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/litex,liteeth.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: LiteX LiteETH ethernet device
+
+maintainers:
+  - Joel Stanley <joel@jms.id.au>
+
+description: |
+  LiteETH is a small footprint and configurable Ethernet core for FPGA based
+  system on chips.
+
+  The hardware source is Open Source and can be found on at
+  https://github.com/enjoy-digital/liteeth/.
+
+allOf:
+  - $ref: ethernet-controller.yaml#
+
+properties:
+  compatible:
+    const: litex,liteeth
+
+  reg:
+    items:
+      - description: MAC registers
+      - description: MDIO registers
+      - description: Packet buffer
+
+  reg-names:
+    items:
+      - const: mac
+      - const: mdio
+      - const: buffer
+
+  interrupts:
+    maxItems: 1
+
+  litex,rx-slots:
+    description: Number of slots in the receive buffer
+    $ref: /schemas/types.yaml#/definitions/uint32
+    minimum: 1
+    default: 2
+
+  litex,tx-slots:
+    description: Number of slots in the transmit buffer
+    $ref: /schemas/types.yaml#/definitions/uint32
+    minimum: 1
+    default: 2
+
+  litex,slot-size:
+    description: Size in bytes of a slot in the tx/rx buffer
+    $ref: /schemas/types.yaml#/definitions/uint32
+    minimum: 0x800
+    default: 0x800
+
+  mac-address: true
+  local-mac-address: true
+  phy-handle: true
+
+  mdio:
+    $ref: mdio.yaml#
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
+    mac: ethernet@8020000 {
+        compatible = "litex,liteeth";
+        reg = <0x8021000 0x100>,
+              <0x8020800 0x100>,
+              <0x8030000 0x2000>;
+        reg-names = "mac", "mdio", "buffer";
+        litex,rx-slots = <2>;
+        litex,tx-slots = <2>;
+        litex,slot-size = <0x800>;
+        interrupts = <0x11 0x1>;
+        phy-handle = <&eth_phy>;
+
+        mdio {
+          #address-cells = <1>;
+          #size-cells = <0>;
+
+          eth_phy: ethernet-phy@0 {
+            reg = <0>;
+          };
+        };
+    };
+...
+
+#  vim: set ts=2 sw=2 sts=2 tw=80 et cc=80 ft=yaml :
-- 
2.33.0

