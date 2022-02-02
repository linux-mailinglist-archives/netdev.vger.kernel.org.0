Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 346B64A7791
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 19:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346490AbiBBSNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 13:13:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243619AbiBBSNR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 13:13:17 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A200DC061714;
        Wed,  2 Feb 2022 10:13:17 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id a19so13500023pfx.4;
        Wed, 02 Feb 2022 10:13:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pHZD/3m5dxJ6IF3Od83WC30BwhA/YhVb9CJ0r7xBZXQ=;
        b=O70YXkiE34Dc/ztb7BQO0rXKUGQeWGOrKWjJU+YrZKJeBjipCQWIPoUpZFXR1mrQdD
         5TILl6CH5BhxFIhTnNTjH1beHQe+BNeLwHLkbd2pSXSbOwb8vILhkmzbimcLoKEVyl80
         IzwOPMJXMGIIwNaywHkIat+JLnWcgexpdE6MRAHSXsZ9YDhlAjuFTvFGX3e0Ix2ncsHA
         UsHVHH+ydFy8ZK3MuEenGka4JctZY88uG5K55MLRMVHGXiFirPZe9dzmBQOJBW2z3i6z
         7JiDfIx227hhhWoWiLelU73qFKCPFA7kynsErlkO3cC+33UWtGCfJxefWkJU43a+Yg25
         9tOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pHZD/3m5dxJ6IF3Od83WC30BwhA/YhVb9CJ0r7xBZXQ=;
        b=YK0T3GSZxWoJOXy3zzS039b0asgJoJ9I0/5+4h7xfNwk5MmeemWSqli0tQI1cZetKL
         G7wb62i5R+e0+YugZJFmCM4A/oj812jOQkDUiT3gLQ+fAIN4vkL0NABuP9w9qatcOky4
         l+2bQc4ZHeYSdNs+dW27mJRbWCfj6HKHFoJJ5FqPSdZjcbH0wYWrDqP1SV7AO32WMykb
         PwHUUohn57pLuPf7MK71AD2/hsuh2qMVB6awhG+mZquWjxyo+Nt+RoUBZZykcIgdWW+s
         ziQiaBWxLcrmXnxCxJAOlY/NyL8EIr4nk9s7rrJbcMHj07XGG6tv/MVxcUwxALsB80yq
         vVww==
X-Gm-Message-State: AOAM530zRs1H7jrVO463OMKVPmZeTS6Auxx1mz1Pj6vuQh2UySdkRezM
        q+FHDX0Xycf+7/SiT6jGb5k=
X-Google-Smtp-Source: ABdhPJzJNJmZPfs0N47WtDR+83RFhCPwzfXNltg2LDFPAEp/nSP5/Rgr/ZEXnArkXhY72KUqsXT7og==
X-Received: by 2002:a63:1262:: with SMTP id 34mr25214052pgs.194.1643825596972;
        Wed, 02 Feb 2022 10:13:16 -0800 (PST)
Received: from localhost.localdomain (101-137-118-25.mobile.dynamic.aptg.com.tw. [101.137.118.25])
        by smtp.gmail.com with ESMTPSA id 22sm9803716pgf.11.2022.02.02.10.13.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 10:13:16 -0800 (PST)
From:   Joseph CHAMG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        andrew@lunn.ch, leon@kernel.org, Rob Herring <robh@kernel.org>
Subject: [PATCH v17, 1/2] yaml: Add dm9051 SPI network yaml file
Date:   Thu,  3 Feb 2022 02:12:47 +0800
Message-Id: <20220202181248.18344-2-josright123@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220202181248.18344-1-josright123@gmail.com>
References: <20220202181248.18344-1-josright123@gmail.com>
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

