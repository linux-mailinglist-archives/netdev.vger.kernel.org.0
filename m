Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD2323F7552
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 14:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240945AbhHYMsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 08:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240915AbhHYMsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 08:48:01 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A67C0613CF;
        Wed, 25 Aug 2021 05:47:15 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id x16so21173127pfh.2;
        Wed, 25 Aug 2021 05:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5LJeSUKrUYXrv15wuA7EAZJbrwJDLvOeKqmFzdUbk/I=;
        b=JGk+VaGW2Rgb8F1fNUJQphreHVU11FTII8bsFMCFlG5y8lYM9LMEcsBxYRVvFWGFwj
         OHfj/Q1f2NrjTdUlWCPZhOPmndd8lDD3GypVOekQd4p95kGqX3B3XEjN0hBGP8eEnxuz
         FwQpqJZie7SQVphPfHMomnr53Cm3oyraUVUBMz4b+KBrVagfSrbP9s4E3EUkZxFAeyE9
         g76BKoIQbjGzcRnf5Mr0hxfmizDeoYY3bvphk8FZOizbq8T4gbkJRUdhlf9gMLWUSVig
         e4pdMTFKrjHWZJGRitPBRoFUEdPS3Lo3sDCJRaKBFTkjOKDHQiw/YnAimrufWpMV1NN3
         3S/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=5LJeSUKrUYXrv15wuA7EAZJbrwJDLvOeKqmFzdUbk/I=;
        b=LvYnee1w37OZsm53zpGZ0J9tM8xKZuIJRCNyA0Dcr22DZgqAwoYSH7ReemRiOHG1sp
         le5powWOLGQjSrNQms0DUi7gLiC9f2jSj0GqMCQgM0uwwYxjPoIEAqiEbjc8JvGtqJbr
         hR6BRzBVzLZldkVljNH4yq5iRsE9yoe/q35SMSPnnErTs8eTr6aCvP/EPrZoZkkticHU
         +GRbUBFYY8QCEcFMWHdmqXru4ZUYKrZdE3lcZND8Za+TbJw40hRuF7ZyPoFnuZUZ2MhL
         2W8oJuY0LaQfR2TcdMPgijaTHSdz1oVuMAEfRMu0Eq03w/r45rU9VfRblTKaez1a2wwd
         Uerw==
X-Gm-Message-State: AOAM531V3yzAUdE5/BPbBFpmUGrCHeG0ebVdFyy5GU1f0kAOQhakGr5Y
        6GK4dOMuiEAEOz5fmu+idmY=
X-Google-Smtp-Source: ABdhPJy6tHjRrFElThDiZH9D02xQSdkeQph028vrhqiRZhtbTwcgcup4Bx5VMnmnTq3MfrcjJtL7Ug==
X-Received: by 2002:a63:2243:: with SMTP id t3mr41347021pgm.114.1629895635138;
        Wed, 25 Aug 2021 05:47:15 -0700 (PDT)
Received: from localhost.localdomain ([45.124.203.15])
        by smtp.gmail.com with ESMTPSA id s16sm21511301pfk.185.2021.08.25.05.47.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 05:47:14 -0700 (PDT)
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
Subject: [PATCH v3 1/2] dt-bindings: net: Add bindings for LiteETH
Date:   Wed, 25 Aug 2021 22:16:54 +0930
Message-Id: <20210825124655.3104348-2-joel@jms.id.au>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210825124655.3104348-1-joel@jms.id.au>
References: <20210825124655.3104348-1-joel@jms.id.au>
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
---
 .../bindings/net/litex,liteeth.yaml           | 100 ++++++++++++++++++
 1 file changed, 100 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/litex,liteeth.yaml

diff --git a/Documentation/devicetree/bindings/net/litex,liteeth.yaml b/Documentation/devicetree/bindings/net/litex,liteeth.yaml
new file mode 100644
index 000000000000..62911b8e913c
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/litex,liteeth.yaml
@@ -0,0 +1,100 @@
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
+    minItems: 3
+    items:
+      - description: MAC registers
+      - description: MDIO registers
+      - description: Packet buffer
+
+  reg-names:
+    minItems: 3
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

