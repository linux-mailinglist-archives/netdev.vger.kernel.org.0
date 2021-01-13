Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8612F4E0A
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 16:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbhAMPAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 10:00:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726837AbhAMPA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 10:00:28 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E15C06179F;
        Wed, 13 Jan 2021 06:59:47 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id q25so2110753otn.10;
        Wed, 13 Jan 2021 06:59:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dxs0NJvJmBAu/+s8TLnC3MeVApUdCV36QEczfzjAyAs=;
        b=Etc7CczaK+zRgqYlHy0I9d278nKUDa+LXjO9jeA+hc2GVdmN0dd0thOwl5mU3aMJei
         H5aquTe14HHr4jMdVqzthnK8bajy7K++KIClGCPFsx86hXh4tN3szIFh+hVksyVlL3H3
         sbCGwfogWD7hrLbCxqV4QGQEQOnZs7pLk9XileMuYpC7njfbFJtqLJl3SfsiktCuq6UP
         TfhzvnlXS0cUfKsOeJkDelRV7pXt+X/Bx9w3FQcOYlNh74ijnyU+XjSRXHIfiJxPAzu7
         w+i3uOnXfvMEFEQG0W+AsFzty3btlBPSW/YyBEcRNAyPRD4foVqjr6QBAf6G5qG7ELJL
         QnPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dxs0NJvJmBAu/+s8TLnC3MeVApUdCV36QEczfzjAyAs=;
        b=JUX741tDTC3qM6cGrTdUL5WCoUDc6kFt6M/yhqTMc4N/tRI0JBAHo8AWAZzyEK7qPA
         HJpgE933E8bHvdbVntVwAHu04Ef6Wth1twg821Q8aGvh+rHDTHDT96rcQKl9GPpC4H9D
         sAdMv9vos00ezlMwGRxzqnWHyYe+rVTpbFDi3oVzNRBv3mJ01XXxzjUvvXLL3N0Im5Av
         fEgRZecEI8/2OKAHg3h7A6kJe0DdT6VTM2D7TCQhidhb6B4P8/BZzDXmEnf46nni+gzZ
         XWWqbxL6UoeH+/jK1400imhQq+yDQHjnRdZo07uSyfjndfPSO/KpJuGKYjH4HT7accbS
         5YsQ==
X-Gm-Message-State: AOAM532aaOKL4XpNr5ID1U7ZceNnq+9zP43EYAhXMgtbVZ2fiDZ/QITh
        zkNp8kI5hFIrj7bkO+HZmA==
X-Google-Smtp-Source: ABdhPJzGT6yX+sn3TY+N84dyQvctxdfCn1JZx6Aona/JcuNQbnwrmB2JQqU5qDNxdRtlsGapD1us1Q==
X-Received: by 2002:a9d:5c8b:: with SMTP id a11mr1477351oti.126.1610549986945;
        Wed, 13 Jan 2021 06:59:46 -0800 (PST)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id f25sm440719oou.39.2021.01.13.06.59.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Jan 2021 06:59:45 -0800 (PST)
From:   George McCollister <george.mccollister@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Rob Herring <robh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net-next v4 3/3] dt-bindings: net: dsa: add bindings for xrs700x switches
Date:   Wed, 13 Jan 2021 08:59:22 -0600
Message-Id: <20210113145922.92848-4-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210113145922.92848-1-george.mccollister@gmail.com>
References: <20210113145922.92848-1-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation and an example for Arrow SpeedChips XRS7000 Series
single chip Ethernet switches.

Signed-off-by: George McCollister <george.mccollister@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../devicetree/bindings/net/dsa/arrow,xrs700x.yaml | 73 ++++++++++++++++++++++
 1 file changed, 73 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml

diff --git a/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
new file mode 100644
index 000000000000..3f01b65f3b22
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
@@ -0,0 +1,73 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/dsa/arrow,xrs700x.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Arrow SpeedChips XRS7000 Series Switch Device Tree Bindings
+
+allOf:
+  - $ref: dsa.yaml#
+
+maintainers:
+  - George McCollister <george.mccollister@gmail.com>
+
+description:
+  The Arrow SpeedChips XRS7000 Series of single chip gigabit Ethernet switches
+  are designed for critical networking applications. They have up to three
+  RGMII ports and one RMII port and are managed via i2c or mdio.
+
+properties:
+  compatible:
+    oneOf:
+      - enum:
+          - arrow,xrs7003e
+          - arrow,xrs7003f
+          - arrow,xrs7004e
+          - arrow,xrs7004f
+
+  reg:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    i2c {
+        #address-cells = <1>;
+        #size-cells = <0>;
+        switch@8 {
+            compatible = "arrow,xrs7004e";
+            reg = <0x8>;
+
+            ethernet-ports {
+                #address-cells = <1>;
+                #size-cells = <0>;
+                ethernet-port@1 {
+                    reg = <1>;
+                    label = "lan0";
+                    phy-handle = <&swphy0>;
+                    phy-mode = "rgmii-id";
+                };
+                ethernet-port@2 {
+                    reg = <2>;
+                    label = "lan1";
+                    phy-handle = <&swphy1>;
+                    phy-mode = "rgmii-id";
+                };
+                ethernet-port@3 {
+                    reg = <3>;
+                    label = "cpu";
+                    ethernet = <&fec1>;
+                    fixed-link {
+                        speed = <1000>;
+                        full-duplex;
+                    };
+                };
+            };
+        };
+    };
-- 
2.11.0

