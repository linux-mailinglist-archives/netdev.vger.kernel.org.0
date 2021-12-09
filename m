Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3106C46E640
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 11:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232661AbhLIKLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 05:11:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232646AbhLIKLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 05:11:10 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F8EC061746;
        Thu,  9 Dec 2021 02:07:37 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id cq22-20020a17090af99600b001a9550a17a5so6517823pjb.2;
        Thu, 09 Dec 2021 02:07:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VcAHuBYGLrQbdvYyRkGkQZWOfReJ2sPBkzv3JT4ntoM=;
        b=qjJGdoUF1Kq57xWTJgUbUUUSpTp7dEqAD48U1VOZHu9nAz76hAJjjz2ibA/DDQJK4L
         7ol27QuxMd42GCkW9xMfgmYP9Q1bXBnQZn+14503xg/WvlG/whKEYrg9c6ihOdXuGe0v
         iuMg9ztnZRwnTc6lnkbttz/EtznCC4e9SUzj5qa7G0UEC8s9zSc2Sfi+nGqqQYXpJosA
         oJxVhyFoKw/1Pgvbm3jsHRHEWzvPf+FFK5Co3UufZZE/wy95uXNsm4+qtbTfMpyUra20
         0qOdJ+9rZjcViowChrBHEoCBQPoI1zthtVFdGZxxtXrt8ENnpQ+kLv0ODpweVU135Uge
         tEUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VcAHuBYGLrQbdvYyRkGkQZWOfReJ2sPBkzv3JT4ntoM=;
        b=zalx5JS7gnPWxrNiwZd3RjOYS5oMfqQb8KLBmAQX6VDW1HNOBTPtzUjFfcTz6Ad8QY
         G9uwnVSj+s+ZWtL2c36nO4g1ZtqR13HQfVkjw4FeWhkXy3roFjRnOcWt1I1pbMoNARGa
         WxlAfCdBHqf7sfDDSPGYujEQRp2LnyCaeKECp3Fi3NBTTVs8kU3wOLBn+UHB8/wH2lSB
         R0i0PbiEsk20iO0xdpCqZsRhN2PzElumPZyd9lfrUe7O089vimTBgGA9EhwltrOMTKmH
         o8DWp8T3p+DSaAFFToE3XAfdcGSudt4p3Ko8ytrUEana/YcyIjLnPbLNtOjwIN6174De
         FVAA==
X-Gm-Message-State: AOAM530lY3ae/ptaf4qr9SCiJNJ/AluSoqF/yJrgBZfzwA6PCtVz4Dsg
        tWaxZBchk9yCm5bCLNj71vqcCOt2NLwkZg==
X-Google-Smtp-Source: ABdhPJyqGlMI9rPOvWyqNfYeeXnNe+c6uGDb4cJyws+SZ0LyhkkN1fw45gWsdPd7r5h0tIahpq5UqA==
X-Received: by 2002:a17:902:ce8f:b0:141:f85a:e0de with SMTP id f15-20020a170902ce8f00b00141f85ae0demr66135724plg.69.1639044456808;
        Thu, 09 Dec 2021 02:07:36 -0800 (PST)
Received: from localhost.localdomain (61-231-106-143.dynamic-ip.hinet.net. [61.231.106.143])
        by smtp.gmail.com with ESMTPSA id i2sm6932409pfg.90.2021.12.09.02.07.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 02:07:36 -0800 (PST)
From:   JosephCHANG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2, 1/2] yaml: Add dm9051 SPI network yaml file
Date:   Thu,  9 Dec 2021 18:07:01 +0800
Message-Id: <20211209100702.5609-2-josright123@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211209100702.5609-1-josright123@gmail.com>
References: <20211209100702.5609-1-josright123@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For support davicom dm9051 device tree config

Signed-off-by: JosephCHANG <josright123@gmail.com>
---
 .../bindings/net/davicom,dm9051.yaml          | 62 +++++++++++++++++++
 1 file changed, 62 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/davicom,dm9051.yaml

diff --git a/Documentation/devicetree/bindings/net/davicom,dm9051.yaml b/Documentation/devicetree/bindings/net/davicom,dm9051.yaml
new file mode 100644
index 000000000000..5e9ce2920bd3
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
+required:
+  - compatible
+  - reg
+  - spi-max-frequency
+  - interrupts
+
+additionalProperties: false
+
+examples:
+  - |
+    /* for Raspberry Pi with pin control stuff for GPIO irq */
+    spi {
+        #address-cells = <1>;
+        #size-cells = <0>;
+        dm9051@0 {
+            compatible = "davicom,dm9051";
+            reg = <0>; /* spi chip select */
+            pinctrl-names = "default";
+            pinctrl-0 = <&eth_int_pins>;
+            interrupt-parent = <&gpio>;
+            interrupts = <26 IRQ_TYPE_LEVEL_LOW>;
+            spi-max-frequency = <31200000>;
+        };
+    };
+    gpio {
+        eth_int_pins {
+            brcm,pins = <26>;
+            brcm,function = <0>; /* in */
+            brcm,pull = <0>; /* none */
+        };
+    };
-- 
2.20.1

