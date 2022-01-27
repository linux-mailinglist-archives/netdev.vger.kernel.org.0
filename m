Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B4449D93C
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 04:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235750AbiA0D1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 22:27:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235751AbiA0D12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 22:27:28 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8585DC06161C;
        Wed, 26 Jan 2022 19:27:28 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id d12-20020a17090a628c00b001b4f47e2f51so6214330pjj.3;
        Wed, 26 Jan 2022 19:27:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pHZD/3m5dxJ6IF3Od83WC30BwhA/YhVb9CJ0r7xBZXQ=;
        b=d5cLkRY3fJHXoZNHBFDg3jUBRHFuhUpwfB6wSmLZjgpMiT6/qqaFFsGUgsbrt5eURI
         L6GjSaSad/59tOMUgYB6mkE1HjwtFBmVVdU72b1Del7CBfW9RE1IiFlc7UTlfZfWD7Pr
         qN+wjK3CE+0a5vnKH9gFWRcAmGaR7g7MAsOcvnI8w0nyCywWKezXLB7dgC4OidI51O1Z
         BQqvEquiNo5tMC2K89hCjaT8UbVmUqJHnzT4X8bD6wW1UhVU58ouMcm27c1ZuSrrPOpb
         NOIyXNn8o9eurGHIPwaKYrYkiDo9IbTol4vFCyM1D8EiQoCpxqxdba5XnwXmGQY3fmBG
         MxMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pHZD/3m5dxJ6IF3Od83WC30BwhA/YhVb9CJ0r7xBZXQ=;
        b=FRf4kKO/mdAFXATbn94ESBS+qcnVldQRSbly7vuAQTRVTln3O5wGTuPEnsFRWmhlvU
         F1wm2HD9HpI56d7Ox/qwqlA8Pohl7NbBTU1Wz0SlXUIpCzeQ1x6/pb3kqi9Y86kSYWe9
         lRsEeSt+S98is1hts8ztrWaDqWTNFlKu0vLVvdzutfGwZRpL31+zqbw1Ysfpc0xLRXdR
         Ul+DKXIrrNCZQK/9gczsGSnPxXNUb1vnQKV1FSowY19HX+xwD6Rxk4ha/aeykJUUTXFx
         8c34NhEmkc/pzPl7DpO3ymgHqLzUXRX0a/n5mOECGt+Q2bqKDlbtFBUVLfeAR6qW642A
         AC8g==
X-Gm-Message-State: AOAM531Bi/UMAcTrQ9NIVPBOQU+vgdeMlZro8Fo1X9XUeqSTWC38mShM
        WUEfTTv3tGsIlYDUmoH1VWqzNDDK6q9erQ==
X-Google-Smtp-Source: ABdhPJz03KoG5VCcnAtgjk1L7ohW5h6bRY4Ia7fLGbP2uKNu84w5WaxG6+8OtBYX7LWlNFLpVQ2xMg==
X-Received: by 2002:a17:902:a502:: with SMTP id s2mr1425703plq.130.1643254047930;
        Wed, 26 Jan 2022 19:27:27 -0800 (PST)
Received: from localhost.localdomain (61-231-106-36.dynamic-ip.hinet.net. [61.231.106.36])
        by smtp.gmail.com with ESMTPSA id s6sm634536pjg.22.2022.01.26.19.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 19:27:27 -0800 (PST)
From:   Joseph CHAMG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        andrew@lunn.ch, leon@kernel.org, Rob Herring <robh@kernel.org>
Subject: [PATCH v14, 1/2] yaml: Add dm9051 SPI network yaml file
Date:   Thu, 27 Jan 2022 11:27:00 +0800
Message-Id: <20220127032701.23056-2-josright123@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220127032701.23056-1-josright123@gmail.com>
References: <20220127032701.23056-1-josright123@gmail.com>
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

