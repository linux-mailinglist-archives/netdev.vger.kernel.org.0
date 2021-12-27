Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE13647FBB5
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 11:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233333AbhL0KDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 05:03:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233293AbhL0KDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 05:03:06 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 160B1C06173E;
        Mon, 27 Dec 2021 02:03:06 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so14000586pjp.0;
        Mon, 27 Dec 2021 02:03:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kWhzX1h+DjsuszNRy/vwgKgHsfUFC6fkjXjULeCnFHI=;
        b=K6k7ymdW8NG6DGTqh6HgXL11+att6IE2SflSap21/cR4U0ZxGxai8h2ZtjBd2Dg9Vc
         fH8SUrn0ij7W/Yp2jiMvbOTD5a4mlcvvw6pZ7lDk9ThdhbqCeMZ/amy9ouLOpKYfSdis
         NIyXfld6LopwnkMtLzDkpZL+XCkOYp6FySwo/SCrsq9niiUyGFU4Yd5USSGIeHcCiLHE
         ozbaIDGM9oXkHmEbATxujkktMeJTHRjMjoYGWYxiq4N1/sYCOObXBF7hnkoHgn44tIZY
         dl0ZQtF3PutavcgE+9GTo2pR5Tk+V2Wv01+thD3M8wd3+OTq/g6pkOx6O3E3NXjXQoaA
         WWJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kWhzX1h+DjsuszNRy/vwgKgHsfUFC6fkjXjULeCnFHI=;
        b=g0qu/tv3z1qpGwqUqeTRUWZ+R2Vc1LRbFJTZZnH2LmxzDv9JlECw5I+YaBL1DYlEZ5
         5fiaOT2iMhtg57GDTph86Naie9MvU4zormAq8gyRmxdKhhv04fiVdOls7UXgY1fPR5Es
         yjOMDSD9fGdsTBdl2fs5IiXkUygJCkJR3cQkWP43gxnOPf0oj+ZVKtK5HSRh7xV+bQVy
         atLL1GtHImsC5GZEvaIi9vfRd+qA3bx2N905sGxOpyIjUdymD+AS31HeMqLdGQ4KSDgC
         c3aZ5a9OKzESqMJInrTyO3FkEhtCO99nDsU1bMStpaMK6faoH47QAWq2IM580I6M7xx3
         5Z/g==
X-Gm-Message-State: AOAM533IoMUCGFAAjxEfmbzCnJdxUjlld+kKOqSqsYOfe4UjMS7cr4JS
        NWZfD9xZKVaM5iRRs6h8w5U=
X-Google-Smtp-Source: ABdhPJwQe2uAZERKrc+W/muDcX7Qh6uG5PAQiQhDqKaT8Ho5A3flQW8o4ec4CsSroUho2fCMvdOqRw==
X-Received: by 2002:a17:903:244a:b0:149:14a4:fd36 with SMTP id l10-20020a170903244a00b0014914a4fd36mr16625299pls.107.1640599385483;
        Mon, 27 Dec 2021 02:03:05 -0800 (PST)
Received: from localhost.localdomain (61-231-124-66.dynamic-ip.hinet.net. [61.231.124.66])
        by smtp.gmail.com with ESMTPSA id k6sm17533671pff.106.2021.12.27.02.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Dec 2021 02:03:05 -0800 (PST)
From:   Joseph CHAMG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh@kernel.org>
Subject: [PATCH v9, 1/2] yaml: Add dm9051 SPI network yaml file
Date:   Mon, 27 Dec 2021 18:02:32 +0800
Message-Id: <20211227100233.8037-2-josright123@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211227100233.8037-1-josright123@gmail.com>
References: <20211227100233.8037-1-josright123@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: JosephCHANG <josright123@gmail.com>

This is a new yaml base data file for configure davicom dm9051 with
device tree

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

