Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1E349AFFD
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 10:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1456902AbiAYJWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 04:22:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1455286AbiAYJLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 04:11:42 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B813C05A190;
        Tue, 25 Jan 2022 00:59:19 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id z131so6702590pgz.12;
        Tue, 25 Jan 2022 00:59:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pHZD/3m5dxJ6IF3Od83WC30BwhA/YhVb9CJ0r7xBZXQ=;
        b=Hd4CxyyzKQN+ZKReJIzBiOTmBl/kuzilkh3A+lZ8ikWCeEvfCAVCnlNyhP5nmVyr1E
         8LRnuknqg121MQASx+xw0zBsJezLTm4aiYttV9gFgQX+quVdCjbTSIL4Rf9WJ2P8mv6Q
         cfrWYhOeS5KBXLMpaz/4pE1RhMA8zTlYR3BcNIrCUOixG3IgCvRwBvw2pu+mTyzpRZ4a
         5SK+Z/ejwDZmNX3ms/Nr/T2LGs8r2s1Dv9Vktaf5zvCnYDW8pB3dKi01boStsF5djjxA
         nRGrggcQTNMIdmYHJI4fX1g+aPu4xLvfphM1Gv+uBKnZXOkidDnFndgS7fRBP7MH1LNE
         JaWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pHZD/3m5dxJ6IF3Od83WC30BwhA/YhVb9CJ0r7xBZXQ=;
        b=nbHQjawRcIfj8haClZ5yqQGDol17dB0X7cycCwFlXYEjqVfeWEk57FItlpzzTcKGuK
         rUauC1EJfLGOsv/QKpHhdiB09gy50EBBZs1pRqWScmmy/cdSMIz2Z8X0wHqTm8X5y14W
         OS+BZ52KLAcLjqQSrNq0uB2afdpuoAN7YnyND189TZkHi4iKDXV+QdSST0nDOoOJ/OOe
         cUOxhIzXvE5R5XuDwy8CXZOR3u+xQo2RVfnsHlhAEDsJE6yjzULPMcA+4CaIqllVaIzg
         M+aZCcXuPnIi7ZUdlIIf3Gzm/WpA5+mNOxwJfNwf7R4qfanHd8C9JWirkOAxMQvpBSSq
         BZMw==
X-Gm-Message-State: AOAM532ckLJSeBYELDG5JpT51iV5nn+NX9K3F9C+pfZM89D7X5dY8gmT
        JvVV6m8Rn6iYDUN4+zE30L0=
X-Google-Smtp-Source: ABdhPJyhqluYFQ8iAlNZIqYOwSHfnfVFw8st8hOu5TBTdE4ykh18XBsvYXpxgs7Mfna6A7Gak1B6cg==
X-Received: by 2002:a63:d243:: with SMTP id t3mr14435778pgi.437.1643101158892;
        Tue, 25 Jan 2022 00:59:18 -0800 (PST)
Received: from localhost.localdomain (61-231-119-59.dynamic-ip.hinet.net. [61.231.119.59])
        by smtp.gmail.com with ESMTPSA id lr7sm2154905pjb.42.2022.01.25.00.59.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 00:59:18 -0800 (PST)
From:   Joseph CHAMG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        andrew@lunn.ch, leon@kernel.org, Rob Herring <robh@kernel.org>
Subject: [PATCH v13, 1/2] yaml: Add dm9051 SPI network yaml file
Date:   Tue, 25 Jan 2022 16:58:36 +0800
Message-Id: <20220125085837.10357-2-josright123@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220125085837.10357-1-josright123@gmail.com>
References: <20220125085837.10357-1-josright123@gmail.com>
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

