Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 446D84753BD
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 08:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240597AbhLOHfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 02:35:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240591AbhLOHfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 02:35:53 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0139FC061574;
        Tue, 14 Dec 2021 23:35:53 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id gj24so2672071pjb.0;
        Tue, 14 Dec 2021 23:35:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N1TIu7U68SSDWd40dRF88hsm7OD3NGSdBx7Oj2A8+ig=;
        b=pOEytYPCv6sIiypZTAnAV9+tUYwoXjJmFvayglGQLp+rKSPCw+DrjyVxq710LgyunZ
         zw7dJRiBw728Ka6QpPP6/WtFMi3fnw0c/ZidJCfMLLOtZrV4f5V2wPJbM8NsdSslGq6y
         bSg4xs+7EvuG2hkAL7ixPODRwd6rzKe55bx8iI+TANYVr3gqSDpXQL0gQVKvVVBns1xN
         2DwuttRZi2TSLyGM8fdq2wvniikB4OTr9cE6Ra89hJteuzmZnEahVR647yCTg37L8z7G
         LnI8Qx9wFr2hMMDcqYhci1llAORWsH+V4OmSkI7QoKLmGfRtOe6g2lou8xiG41FiEOzq
         +vfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N1TIu7U68SSDWd40dRF88hsm7OD3NGSdBx7Oj2A8+ig=;
        b=KlFT+/qusqMnHInB7FbkRUaCTl5MYd3Xv1N+fThoEbe8cO5msStN/CdNbZzsGJ6PV8
         zKTA2Z3DnKAhdeIiDay3T+eaS09Nh1vSNENVDoiIVStyfthk0vhM3W8KSxTorrPwh0YA
         0UxXuuzvutkB9xDHrA979qQVRel03B4K40CEpl4TfyFuszqCwBaUpcKrsLfftP8fKf7z
         oSFOV5c2RZA6mNlpoTeA1hZWdg/5J5HDyY81UjsBSTPibgyS4DTI2DcWlvoJXYaQx13y
         lOO6D/RdJllaw8bS/bclHfwkKFAKv7KxutsbZ7e/QjA/OBNYUdqNYtf8s1OKmH2lqzD9
         v8oQ==
X-Gm-Message-State: AOAM532YFQAy8SEkAqxYDVBxgYLtgeRYYd2TCR9bAfiNyV3ig36iphkr
        M1c2V0LXj/wrEsnWHeaIJow=
X-Google-Smtp-Source: ABdhPJxnZPxXUy0W4QoQNIEX8nPdjTFI8cErzojqLaX0WB252ukLzLV9xbCXdFf3yceKH1/kLB0w2g==
X-Received: by 2002:a17:902:e548:b0:141:f4ae:d2bd with SMTP id n8-20020a170902e54800b00141f4aed2bdmr9664732plf.41.1639553752413;
        Tue, 14 Dec 2021 23:35:52 -0800 (PST)
Received: from localhost.localdomain (61-231-67-10.dynamic-ip.hinet.net. [61.231.67.10])
        by smtp.gmail.com with ESMTPSA id y37sm1264160pga.78.2021.12.14.23.35.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 23:35:52 -0800 (PST)
From:   JosephCHANG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5, 1/2] yaml: Add dm9051 SPI network yaml file
Date:   Wed, 15 Dec 2021 15:35:06 +0800
Message-Id: <20211215073507.16776-2-josright123@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211215073507.16776-1-josright123@gmail.com>
References: <20211215073507.16776-1-josright123@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a new yaml base data file for configure davicom dm9051 with
device tree

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

