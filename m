Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5592F4B21F1
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 10:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348613AbiBKJ2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 04:28:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348612AbiBKJ22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 04:28:28 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D36CE9;
        Fri, 11 Feb 2022 01:28:25 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id l9so2594906plg.0;
        Fri, 11 Feb 2022 01:28:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u72dfCKcBsI5HUFp5Jc/vwPolSfcg3sgGPIgUu/1wC4=;
        b=OIISz+qoSJ0hQpsCmely2cqOCrJuba9QlwKihkITR6qSCd+C2nLvMtfDi3C7mg7H2c
         FhtgRQNNpUGZvEdhmwhslXi7HLsL/hBPJaz0dX2s7GvnBOh9ErZfEiBazHFx73T7Cg0Z
         jOy7YCa91DCTlG0I5xfd17HafKWGXvcNsfdKnrRgVs6qbrGl4+BMjQ52R2rqOzwqwOEU
         kB/DSbUL+2hWp9XtHzq626J0IcSWHKXRfUS9Xkt/0dBUN4OlKSL+H1+kJT4ZpksNb/cq
         ILfZ7OU4vJmgRcG1gQv15c8Z2Wu5aAkjEtS01wgOogPUMESH4bbFABOb3zi9W9Py2oS/
         UH3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u72dfCKcBsI5HUFp5Jc/vwPolSfcg3sgGPIgUu/1wC4=;
        b=LPpM2BY7WjCHAhLzp9sYfXJ+WEkWInFhxX8GRYnDd9ZsFCqwO6sHK9sOFDCzKWWGFS
         InuOiLp9eaSG2tKSFlsnRue8PgWIvu6JF1LoGKub9ldX9xsMsfPqd2sSO1LjVQwLLWV5
         GDFTBbYJsxHj7myNeG5D5QZFI8kbOxLIOIRJmhTIV8CbnfRAwbG0rXtpR0Fmg2KJ0AY+
         QCCWhjvz5Jvq4Cj+VlBoB1L9devajLvEgrKYYd+xazlB5f1lh0TnW7Tfs7kvS04lquU6
         RCaHZb/kRtMbdEcSz3PgfD4HaPXmsuin/U9Lv1jd2aVk3EbR5CtEaDH7a/yUwApi8YDr
         TCVQ==
X-Gm-Message-State: AOAM533e+mcobPr46jlpkkFApDO5VQmRoTqePdWN/kp6DHlWdtyseHeS
        l7VLYVo0l7huBtxubh2hoQGhzUJSJH1Z+Q==
X-Google-Smtp-Source: ABdhPJx3/KUiSLGY81sUEfgWl50vcRouYyeszas9Zm5ydA5/vhp0vbaqsR4K+wCbXH7UYzKoFQ80jw==
X-Received: by 2002:a17:902:ccce:: with SMTP id z14mr751786ple.119.1644571705003;
        Fri, 11 Feb 2022 01:28:25 -0800 (PST)
Received: from localhost.localdomain (61-231-111-88.dynamic-ip.hinet.net. [61.231.111.88])
        by smtp.gmail.com with ESMTPSA id 13sm25704040pfm.161.2022.02.11.01.28.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 01:28:24 -0800 (PST)
From:   Joseph CHAMG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        andrew@lunn.ch, leon@kernel.org, Rob Herring <robh@kernel.org>
Subject: [PATCH v20, 1/2] dt-bindings: net: Add Davicom dm9051 SPI ethernet controller
Date:   Fri, 11 Feb 2022 17:27:55 +0800
Message-Id: <20220211092756.27274-2-josright123@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220211092756.27274-1-josright123@gmail.com>
References: <20220211092756.27274-1-josright123@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a new yaml base data file for configure davicom dm9051 with
device tree

Signed-off-by: Joseph CHAMG <josright123@gmail.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---
Cc: Rob Herring <robh@kernel.org>
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

