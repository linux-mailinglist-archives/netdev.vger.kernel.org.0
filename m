Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F39248D327
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 08:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232763AbiAMHqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 02:46:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232734AbiAMHqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 02:46:31 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279D2C06173F;
        Wed, 12 Jan 2022 23:46:31 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id i6so8520439pla.0;
        Wed, 12 Jan 2022 23:46:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kWhzX1h+DjsuszNRy/vwgKgHsfUFC6fkjXjULeCnFHI=;
        b=jtU1YjpgdWILxYJaHNcgQbPLDmLj9cvdCYXM7hhMN6qtnI5M5K7ywOl23BntKgMKi+
         84mcVCOQT0kcbCZ/OOimmatzBwunL98QvSdUSDwpHgSFb/7JjbfY1WtiCEG65KS0bYDB
         5huuClRMw+1f1HQjngjG4ClMbcdkrgmbfT8OCw9l9gOq6li/MAol6Rxl+s3/fNdZN1nS
         WhLjYxZgTNf86L5jqdJZpA+HXtCdo5icLTmIH02flywqcE1GJ9PN58pi717S+99z4uAK
         JpHWnpUtVbcsQI9QcBMdiGM0tVpvbp7qBQAOTpBOxRtOWSGlsjaFEeEYtxTYkHO9CLsi
         Tebw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kWhzX1h+DjsuszNRy/vwgKgHsfUFC6fkjXjULeCnFHI=;
        b=rsoLPJh8Gkzs0sUxbSZ/GYaWKCOFUovhzLv5IUQLG8fkdSHp2zIyl+KcjfstjtsBBJ
         ctpXxWZfTtXxck0SEPc+OKknKBYTibQpd/N/B/j/O42DqH93LpCdNEFr3vUHMWKeysA0
         fyHSC8nDQW4XJSNTMf3cZuqInDmau4RQTRpSbXLg6jl3yfmlp2wVzcxUBi09DoiYmWjB
         0Z+y31y7N9xUbvklENxQrxe0nkaVrlE23uyCTHXPhzbKuB7l2wl+eq/rQjCKwkIYd52Z
         SV5o83xMXVftrXpNlQK7z5rqhr6Vk6Xrv1fM4vHyMgTdIC9u5+I1hnLsZWrC/F2PoeMB
         5XLw==
X-Gm-Message-State: AOAM531imR2CDjz+9BLBBRtCwmQYnYcFhhISyEgGqbIVSL25yHaM95+1
        GGTcQSdtNWLmwF8y8baFIYXLCYufzTTpdQ==
X-Google-Smtp-Source: ABdhPJzaHipJdQfmXZqT6HwyLDziEMFfShlrqWCBIdW9IV/pcEt2hiFG5gOzKd4m0j3Mu3jtn0Ngkg==
X-Received: by 2002:a17:903:1209:b0:149:a428:19ef with SMTP id l9-20020a170903120900b00149a42819efmr3129943plh.47.1642059990560;
        Wed, 12 Jan 2022 23:46:30 -0800 (PST)
Received: from localhost.localdomain (61-231-99-230.dynamic-ip.hinet.net. [61.231.99.230])
        by smtp.gmail.com with ESMTPSA id d2sm1864602pfu.76.2022.01.12.23.46.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 23:46:30 -0800 (PST)
From:   Joseph CHAMG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh@kernel.org>
Subject: [PATCH v11, 1/2] yaml: Add dm9051 SPI network yaml file
Date:   Thu, 13 Jan 2022 15:46:13 +0800
Message-Id: <20220113074614.407-2-josright123@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220113074614.407-1-josright123@gmail.com>
References: <20220113074614.407-1-josright123@gmail.com>
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

