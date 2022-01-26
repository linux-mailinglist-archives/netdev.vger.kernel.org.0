Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 717F549C409
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 08:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237603AbiAZHH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 02:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237594AbiAZHH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 02:07:57 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 350C0C06161C;
        Tue, 25 Jan 2022 23:07:57 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id b9so12160161lfq.6;
        Tue, 25 Jan 2022 23:07:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xQZEWLVjW3YrjRzePnAkpJ5fQMVb6UDAvzsIkL2SRjE=;
        b=mfSQf867UF/OUBwanRxTRw5HO5INlp0P7eNgiEXHdYpfwaQd9QovmJTUnGByA+CLoY
         ULmZSvg+0nWSRAuc0YlGjhyKq+i7ydEgOKqGlMo53hHvKMQ81VKuV2Dv7xIGjwHabE70
         0ctSI7hCFLbYDOkrdgPJbIycwV7erUloSJJGV/vq7qxR1f2cPx1ONbxeoUyyD1Lz9Ciy
         +mRyYRGQbHOHd+sRGqeiCmZtxWJRodgiSzoe5XMNVnf5pzUim25Nnnnxcsa7wlP7veIP
         vgSNycaudUJVCRuk/kJFCH1Eeyov3qvyt6DILBlDErhMzoSaT4nsrMENw3ivfDSpaPwK
         tvoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xQZEWLVjW3YrjRzePnAkpJ5fQMVb6UDAvzsIkL2SRjE=;
        b=Zsk2xj9eBKpC/wd+Huxy0ZlCGxYQz78nooO4yzpgzN+DJIYKWCP741Fx8OJGGk7wng
         utIHbsVB6NHuUo9Ud955WXOdqtXmwHXKzHuG/G+LHuI6GqH3x87JVIwbNT2/5aEUQy0U
         C9MyNwU7RpAXnLoj4hzFGnUfhMLY8L4NOqWxUtXCOvMfHiB23E/kmXfm8Z1a25FTgrSo
         QdWgC9USQL+/iDf+wCXCrl/+9IIr2NHa7F9bjUHlUWh7B1jPx5y+r1T/fO53UQkMWWs0
         ydEwb6VZFvsh0bIaOcpNEdnxdjTh1lgZwn7CpxzgN31oJebxdpZa4NIQdvo6YKDxGQsH
         ruZA==
X-Gm-Message-State: AOAM533mQh0YkOxO836CNf3RQ523xIq4NIpP9R9EOA3fG5jGoMGSbA+G
        QB4JQzkt5CWSKfUXJIRcfI0=
X-Google-Smtp-Source: ABdhPJzYh58bTg1fZy7W1sPSSAvbXbjS9pFrKpgk3eoYCidLV9/Wf27XOE9qQ/2WZEzSq/MjTCvxyw==
X-Received: by 2002:a19:5047:: with SMTP id z7mr6178840lfj.666.1643180875552;
        Tue, 25 Jan 2022 23:07:55 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id b39sm1465764ljr.88.2022.01.25.23.07.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 23:07:55 -0800 (PST)
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
Subject: [PATCH REBASED 2/2] dt-bindings: nvmem: cells: add MAC address cell
Date:   Wed, 26 Jan 2022 08:07:45 +0100
Message-Id: <20220126070745.32305-2-zajec5@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220126070745.32305-1-zajec5@gmail.com>
References: <20220125180114.12286-1-zajec5@gmail.com>
 <20220126070745.32305-1-zajec5@gmail.com>
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

