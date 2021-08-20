Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44FF83F27D7
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 09:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238964AbhHTHsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 03:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238976AbhHTHsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 03:48:19 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF547C06175F;
        Fri, 20 Aug 2021 00:47:41 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id n13-20020a17090a4e0d00b0017946980d8dso13196906pjh.5;
        Fri, 20 Aug 2021 00:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u7Ude5dFki3jUL7JYHXiZ7WfcjuEcLEkwl0KWT++wrs=;
        b=NPHuVhlYnZiPD6FZgjftCsWzmLxFCES2pi+OMGWEnBY072zR8hER1FqHj/GCsCElsI
         EMuAXK8yPKRUQ0S7Z9hDjMJ9yxnELIoG75NyGOs3m9iIO/JF4Hd9QqiPHzm6N/d3Mw7f
         ZUqrg4KP9pcnJkKAISw+VgLpWI3Lr5F9T+BMmpH9JFrJDQUoiA4xLSvParUtQD3+QaS3
         gbyxZV/2zLL/R5qF58xqJIHeuqj/yDoU+mPfoPXaWGSX4d+XPXJ52YX0WxhGvd4t0jbJ
         g93Q3afrpJrXYxzPX5+oI16JLCrBVRg/sVkwCk1sQDRtb1PpKXNptxmPIzeBj7y42Tm1
         d+8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=u7Ude5dFki3jUL7JYHXiZ7WfcjuEcLEkwl0KWT++wrs=;
        b=sahimv9vJ3pUjn8BKLWDdDmti1URxxRhoHgGApvXQFhJemCVfvdnnZypGVL1BmmuCL
         HbK48XRBd7r3Lg4ZYw+Xd8fWpE4/71ejvvVXSrEiPji0vpdn5iHEFHn5MHLdjDsvumas
         xKakIkIKtIXnzfV5jxYmFlHXlhXR54+/jEfottOhZCbawCJFgoej3C9GK2c2gSBVrSc/
         oB3VI3m52Z93D4zo0YWTHzwW0+RHEUDl/rbxuiBn3wnf2KJZqTHyv7C3KRicZbBA1aCZ
         J5JCsmSVJawWScjBKI1dzT8j6ONIJCIBfSCbGVvRVrMt+f/i0Tl7mhW5Q7Hm7yg9vISP
         5mWw==
X-Gm-Message-State: AOAM531VZQ2gbeMLS/6rrDeHvefAYwOLaCkcsMeuQZhIo86ugYMblDBH
        tXoEebryatrDBlRe3DZSKgk=
X-Google-Smtp-Source: ABdhPJxdF1dR8GNSjST0CUxpxC+g3v1ZLTu/edBquj1WwM7itDbYS2oPaVN7xSxFUUqUuECyH27IlQ==
X-Received: by 2002:a17:902:ea02:b0:12f:65d7:47eb with SMTP id s2-20020a170902ea0200b0012f65d747ebmr9593790plg.3.1629445661157;
        Fri, 20 Aug 2021 00:47:41 -0700 (PDT)
Received: from localhost.localdomain ([45.124.203.15])
        by smtp.gmail.com with ESMTPSA id o11sm5937534pfd.124.2021.08.20.00.47.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 00:47:40 -0700 (PDT)
Sender: "joel.stan@gmail.com" <joel.stan@gmail.com>
From:   Joel Stanley <joel@jms.id.au>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] dt-bindings: net: Add bindings for LiteETH
Date:   Fri, 20 Aug 2021 17:17:25 +0930
Message-Id: <20210820074726.2860425-2-joel@jms.id.au>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210820074726.2860425-1-joel@jms.id.au>
References: <20210820074726.2860425-1-joel@jms.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LiteETH is a small footprint and configurable Ethernet core for FPGA
based system on chips.

Signed-off-by: Joel Stanley <joel@jms.id.au>
---
v2:
 - Fix dtschema check warning relating to registers
 - Add names to the registers to make it easier to distinguish which is
   what region
 - Add mdio description
 - Includ ethernet-controller parent description

 .../bindings/net/litex,liteeth.yaml           | 79 +++++++++++++++++++
 1 file changed, 79 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/litex,liteeth.yaml

diff --git a/Documentation/devicetree/bindings/net/litex,liteeth.yaml b/Documentation/devicetree/bindings/net/litex,liteeth.yaml
new file mode 100644
index 000000000000..30f8f8b0b657
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/litex,liteeth.yaml
@@ -0,0 +1,79 @@
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
+
+  interrupts:
+    maxItems: 1
+
+  rx-fifo-depth: true
+  tx-fifo-depth: true
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
+        rx-fifo-depth = <1024>;
+        tx-fifo-depth = <1024>;
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
2.32.0

