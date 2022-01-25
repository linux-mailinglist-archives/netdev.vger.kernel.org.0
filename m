Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF01649BAE9
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 19:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385854AbiAYSEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 13:04:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387438AbiAYSCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 13:02:47 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2FBC061401;
        Tue, 25 Jan 2022 10:02:43 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id b9so9247272lfq.6;
        Tue, 25 Jan 2022 10:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xQZEWLVjW3YrjRzePnAkpJ5fQMVb6UDAvzsIkL2SRjE=;
        b=SuNbqnWPzFlOJ670/rx6ivjeSBcGvnu+a5DfiEsSE7uFv8zJvo207gFnL0JipeAI/Q
         zqDyZHdVYvs/YDd6xNv5AqpcRcDF4+ulX8seHrzLdNt0NzGgcAKZ3zaVedkG1604kHah
         flXTgZ1tObxwKfmdg5YstW2xWQ2goSI6G5WD8Go/5bUQOTQ4nOfCE39ZhgVs3yUxr/EE
         t/dmUknXbkKuKSRrt6/w4cEeZZDG88ShgMXOxgxBMU2jtyfuPVAV1pXDeHk8iJfKgD/Y
         bPJS/fM8IVeKqwBduETRbseg/zkjIW+wMBtzFLXJvNR8qbUSTGDYxvP/h/+/nSUbHDU/
         YOgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xQZEWLVjW3YrjRzePnAkpJ5fQMVb6UDAvzsIkL2SRjE=;
        b=g7mOjk6ZAcAvTfUadp63UyriCmE2RPWe6ixT82kFdYyu72S8GVYYKk6YlGpdWRNlnx
         DmKsJkDcPR6PWDMgt7bnO8jeyBva034A0u/LxdzkLEC0e7M2N5XHfGI/f7OwyVVfelHj
         nd3xG0r2bsCg9VDdEEQzDqBzaT7Po+1afRXG76/qPsN5qZYuvEy2SVAvywFdYJ5l58M3
         jNKu5MZqcUw4K6yGaf5SNBA69BqGtEtS75zNo2WmwZCm/O5XPZYBIT3SfL6eshWrgkuq
         ARl4/UHtnLCB3Augz71FDm4NOSrfdsArbo0mwlwImbILkSRxh5pU5gnHepj6cLW7/0Kw
         Jxcw==
X-Gm-Message-State: AOAM531vaAIVh8zVe9yyvyvDBR5VpbppVbw/93IZL9OYzBoVeHcPu0Rl
        VTmj2IyYW5uEaqM60NRJRec=
X-Google-Smtp-Source: ABdhPJzXQHBy23+18Vv7UseStSyjXEJqrlfYdu2UOaAlwGO+9xA/n9sx3s2ZN2JcmPTM8PtQ6/q1Zg==
X-Received: by 2002:a05:6512:11e2:: with SMTP id p2mr17974341lfs.580.1643133761576;
        Tue, 25 Jan 2022 10:02:41 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id z24sm1149121lfb.206.2022.01.25.10.02.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 10:02:41 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Michael Walle <michael@walle.cc>
Cc:     linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 2/2] dt-bindings: nvmem: cells: add MAC address cell
Date:   Tue, 25 Jan 2022 19:01:14 +0100
Message-Id: <20220125180114.12286-3-zajec5@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220125180114.12286-1-zajec5@gmail.com>
References: <20220125180114.12286-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

This adds support for describing details of NVMEM cell containing MAC
address. Those are often device specific and could be nicely stored in
DT.

Initial documentation includes support for describing:
1. Cell data format (e.g. Broadcom's NVRAM uses ASCII to store MAC)
2. Reversed bytes flash (required for i.MX6/i.MX7 OCOTP support)
3. Source for multiple addresses (very common in home routers)

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 .../bindings/nvmem/cells/mac-address.yaml     | 94 +++++++++++++++++++
 1 file changed, 94 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/nvmem/cells/mac-address.yaml

diff --git a/Documentation/devicetree/bindings/nvmem/cells/mac-address.yaml b/Documentation/devicetree/bindings/nvmem/cells/mac-address.yaml
new file mode 100644
index 000000000000..f8d19e87cdf0
--- /dev/null
+++ b/Documentation/devicetree/bindings/nvmem/cells/mac-address.yaml
@@ -0,0 +1,94 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/nvmem/cells/mac-address.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: NVMEM cell containing a MAC address
+
+maintainers:
+  - Rafał Miłecki <rafal@milecki.pl>
+
+properties:
+  compatible:
+    const: mac-address
+
+  format:
+    description: |
+      Some NVMEM cells contain MAC in a non-binary format.
+
+      ASCII should be specified if MAC is string formatted like:
+      - "01:23:45:67:89:AB" (30 31 3a 32 33 3a 34 35 3a 36 37 3a 38 39 3a 41 42)
+      - "01-23-45-67-89-AB"
+      - "0123456789AB"
+    enum:
+      - ascii
+
+  reversed-bytes:
+    type: boolean
+    description: |
+      MAC is stored in reversed bytes order. Example:
+      Stored value: AB 89 67 45 23 01
+      Actual MAC: 01 23 45 67 89 AB
+
+  base-address:
+    type: boolean
+    description: |
+      Marks NVMEM cell as provider of multiple addresses that are relative to
+      the one actually stored physically. Respective addresses can be requested
+      by specifying cell index of NVMEM cell.
+
+allOf:
+  - $ref: cell.yaml#
+  - if:
+      required:
+        - base-address
+    then:
+      properties:
+        "#nvmem-cell-cells":
+          const: 1
+      required:
+        - "#nvmem-cell-cells"
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    partitions {
+        compatible = "fixed-partitions";
+        #address-cells = <1>;
+        #size-cells = <1>;
+
+        partition@f00000 {
+            compatible = "nvmem-cells";
+            label = "calibration";
+            reg = <0xf00000 0x100000>;
+            ranges = <0 0xf00000 0x100000>;
+            #address-cells = <1>;
+            #size-cells = <1>;
+
+            mac@100 {
+                compatible = "mac-address";
+                reg = <0x100 0x6>;
+            };
+
+            mac@200 {
+                compatible = "mac-address";
+                reg = <0x200 0x6>;
+                reversed-bytes;
+            };
+
+            mac@300 {
+                compatible = "mac-address";
+                reg = <0x300 0x11>;
+                format = "ascii";
+            };
+
+            mac@400 {
+                compatible = "mac-address";
+                reg = <0x400 0x6>;
+                base-address;
+                #nvmem-cell-cells = <1>;
+            };
+        };
+    };
-- 
2.31.1

