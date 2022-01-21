Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9D64958D8
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 05:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234228AbiAUEPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 23:15:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234086AbiAUEPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 23:15:02 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9581CC061574;
        Thu, 20 Jan 2022 20:15:01 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id f13so7331779plg.0;
        Thu, 20 Jan 2022 20:15:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A8kWH+ewEXjZaQjKsO8iegW9r51xWiAVEoWbEaAysSE=;
        b=LFTcrxYxkSa/tnVNpK4Mj7AIxqROIPX/fcTR+B6+MS+vJCeBZ3x8xDgxiSs9JovXiO
         K/16/eMBzP6emNOHho1m9LCfe6zBJvGjFbYAzRazRvVOGb8AFR4WLHr8RpxX86FZH7hn
         I5NHZDDiInuTu/FDIFZEBacrLKuf3yhZBNEVMGXbGInX5MPbOehOkVJUBHs6vSgxAlPj
         KFwvnSSYRU4nW5iHa1sGEKarkdiRSxGnz3ySX0Ly+dTNeX2jzMuqhOVdc7PUjjiSLPIY
         O0JK9mAM/p0yBL9w6I4dAazuWZ5uu8R9ROEcgCiVi9sYMM6Hvqzh+qBvJGREPzPbqp2A
         dS2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A8kWH+ewEXjZaQjKsO8iegW9r51xWiAVEoWbEaAysSE=;
        b=VsgCMH/qn01cw/hRM+Ym0iI/LfyPGLdpMDmNbyEFZCjd0d/czWZSbbmqb5yM2aICmD
         zXhroY7h+cmnc/pyRTe7ktEd0H/MrZZXZsr8NXDrZh/YzosOzSa08+1BdyTd3TmB0mF2
         xzVr+IpWJOA0N9mYC2qnqlmyj4JAJYmMUCyEfjSz/kpvc44j1Urz/EAThwauPn6VKafG
         AeE7i/h89L1VT4cZ7AdcpkUwYEb9v8SC9yw7U+eB5y9guQa5WBk+uqFlbHpf45VC3h+o
         V/55aOOxjfPBZC8fWyaamUIzYjZmlLnj/cCzu9Uf2oKbM4ucnRjdEIxWf7L1XFKMaQa7
         6W6A==
X-Gm-Message-State: AOAM532k93zbsAmYUMAUMknlrRGPkut3Huym+YgVtly+olpmTnPeAaFP
        0CkyuMKdRvwY4ZPu76zuXZaJRYb3pr9Zxg==
X-Google-Smtp-Source: ABdhPJxYa4qKjH9DFOVVw/yDDIWOOpxZxySSF06pQn+9DDARsWAFSqycdXgZFcSKu1tIp8/miR3c7g==
X-Received: by 2002:a17:90a:4089:: with SMTP id l9mr2706930pjg.14.1642738500935;
        Thu, 20 Jan 2022 20:15:00 -0800 (PST)
Received: from localhost.localdomain (61-231-118-42.dynamic-ip.hinet.net. [61.231.118.42])
        by smtp.gmail.com with ESMTPSA id j1sm4937614pfu.4.2022.01.20.20.14.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 20:15:00 -0800 (PST)
From:   Joseph CHAMG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        andrew@lunn.ch, Rob Herring <robh@kernel.org>
Subject: [PATCH v12, 1/2] yaml: Add dm9051 SPI network yaml file
Date:   Fri, 21 Jan 2022 12:14:27 +0800
Message-Id: <20220121041428.6437-2-josright123@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220121041428.6437-1-josright123@gmail.com>
References: <20220121041428.6437-1-josright123@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: JosephCHANG <josright123@gmail.com>

This is a new yaml base data file for configure davicom dm9051 with
device tree

Cc: Rob Herring <robh@kernel.org>
Signed-off-by: JosephCHANG <josright123@gmail.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 .../bindings/net/davicom,dm9051.yaml          | 62 +++++++++++++++++++
 1 file changed, 62 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/davicom,dm9051.yaml

diff --git a/Documentation/devicetree/bindings/net/davicom,dm9051.yaml b/Documentation/devicetree/bindings/net/davicom,dm9051.yaml
new file mode 100644
index 000000000000..52e852fef753
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/davicom,dm9051.yaml
@@ -0,0 +1,62 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/davicom,dm9051.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Davicom DM9051 SPI Ethernet Controller
+
+maintainers:
+  - Joseph CHANG <josright123@gmail.com>
+
+description: |
+  The DM9051 is a fully integrated and cost-effective low pin count single
+  chip Fast Ethernet controller with a Serial Peripheral Interface (SPI).
+
+allOf:
+  - $ref: ethernet-controller.yaml#
+
+properties:
+  compatible:
+    const: davicom,dm9051
+
+  reg:
+    maxItems: 1
+
+  spi-max-frequency:
+    maximum: 45000000
+
+  interrupts:
+    maxItems: 1
+
+  local-mac-address: true
+
+  mac-address: true
+
+required:
+  - compatible
+  - reg
+  - spi-max-frequency
+  - interrupts
+
+additionalProperties: false
+
+examples:
+  # Raspberry Pi platform
+  - |
+    /* for Raspberry Pi with pin control stuff for GPIO irq */
+    #include <dt-bindings/interrupt-controller/irq.h>
+    #include <dt-bindings/gpio/gpio.h>
+    spi {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        ethernet@0 {
+            compatible = "davicom,dm9051";
+            reg = <0>; /* spi chip select */
+            local-mac-address = [00 00 00 00 00 00];
+            interrupt-parent = <&gpio>;
+            interrupts = <26 IRQ_TYPE_LEVEL_LOW>;
+            spi-max-frequency = <31200000>;
+        };
+    };
-- 
2.20.1

