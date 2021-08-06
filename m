Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFA43E230A
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 07:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243311AbhHFFuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 01:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243079AbhHFFtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 01:49:50 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3D8C06179B;
        Thu,  5 Aug 2021 22:49:34 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id m10-20020a17090a34cab0290176b52c60ddso15449818pjf.4;
        Thu, 05 Aug 2021 22:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hD8la+uQht470Z79A1A0VyiqMXVtxSlHKEsCD9ytGxY=;
        b=g8CYSTwEJigiAEwta2YaRM2kHqI7Qsz8dmHhg97XYpevCmoOTzJeHfS9Nw6+7i3lQK
         pccMDuIt9413IfkhYTDPkzKCfYpTNoXyChdrqb4bWfd0ElBuefTuuND73w+/8JWNGISi
         7eYW3q7AtuC4fKP/bzxoirIR0EpD+vz4hxujgb/ubjysPLzS5DBVXvScki0bZ/LQKJJA
         ZpoQ9KWCLf98xLUKZe8PaFuWqlXZLBxix2v+fTtC9y29aBT0gOg12FXLc4qsqMUgU1aB
         TkhvC4ivxiLIF+XGgEoKZ0gveTuaNj6d/wqSb2TjWMN3Zlz+KOsjR8MmIg8Lh8+w7FH5
         Rz8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=hD8la+uQht470Z79A1A0VyiqMXVtxSlHKEsCD9ytGxY=;
        b=NUz0HXMqMPbvKjMmsfZYYw7pQrWyGwVKSDNNigcqkOaYZZ80BtKXAoGSEg4AGu1Pww
         Lhi9o3mdTn5aVU4qXIx4xZnfjaBweT7MeFTx7oD8JU8duDL8EdSuG748foz8Un8VpnY6
         uxPo8LWU51oecRlivzHE1VwTg6HC5rtZVHmKpFmotWFoabRGTwaB+crqEwjfXAKlnAXS
         UM+vt94jgNr/9ia1MY5zJA0DBxkKAcxq8UhcHk2aqrWk73BRavx+5u0wJSd8/J2OdmZ/
         s1Qpd2a+GtLOOApkvWkF5gHTdH1dwzqUh3Hc5zrIhSIcWQpvXzQRtvvjSvr89QpWHmq8
         CiBg==
X-Gm-Message-State: AOAM5332BXVw0a2S0Lj6avvxOJg7ilRcq3LfebCkTkQVpM9lFaqwGllP
        qjS6O8fDziGIunA8wPwugdA=
X-Google-Smtp-Source: ABdhPJxDSrKuont5VakZtWdqOVBFXK3oiVuU0xp4fJdTlKlcnsB1vTfgxwiv36/MFxr83F+lk6FybA==
X-Received: by 2002:a17:90a:a103:: with SMTP id s3mr8522363pjp.121.1628228974137;
        Thu, 05 Aug 2021 22:49:34 -0700 (PDT)
Received: from voyager.lan ([45.124.203.15])
        by smtp.gmail.com with ESMTPSA id z2sm10902205pgz.43.2021.08.05.22.49.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 22:49:33 -0700 (PDT)
Sender: "joel.stan@gmail.com" <joel.stan@gmail.com>
From:   Joel Stanley <joel@jms.id.au>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Stafford Horne <shorne@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@ozlabs.org>,
        Gabriel Somlo <gsomlo@gmail.com>, David Shah <dave@ds0.me>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] dt-bindings: net: Add bindings for LiteETH
Date:   Fri,  6 Aug 2021 15:19:03 +0930
Message-Id: <20210806054904.534315-2-joel@jms.id.au>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806054904.534315-1-joel@jms.id.au>
References: <20210806054904.534315-1-joel@jms.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LiteETH is a small footprint and configurable Ethernet core for FPGA
based system on chips.

Signed-off-by: Joel Stanley <joel@jms.id.au>
---
 .../bindings/net/litex,liteeth.yaml           | 62 +++++++++++++++++++
 1 file changed, 62 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/litex,liteeth.yaml

diff --git a/Documentation/devicetree/bindings/net/litex,liteeth.yaml b/Documentation/devicetree/bindings/net/litex,liteeth.yaml
new file mode 100644
index 000000000000..e2a837dbfdaa
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/litex,liteeth.yaml
@@ -0,0 +1,62 @@
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
+  interrupts:
+    maxItems: 1
+
+  rx-fifo-depth:
+    description: Receive FIFO size, in units of 2048 bytes
+
+  tx-fifo-depth:
+    description: Transmit FIFO size, in units of 2048 bytes
+
+  mac-address:
+    description: MAC address to use
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
+        reg = <0x8021000 0x100
+               0x8020800 0x100
+               0x8030000 0x2000>;
+        rx-fifo-depth = <2>;
+        tx-fifo-depth = <2>;
+        interrupts = <0x11 0x1>;
+    };
+...
+
+#  vim: set ts=2 sw=2 sts=2 tw=80 et cc=80 ft=yaml :
-- 
2.32.0

