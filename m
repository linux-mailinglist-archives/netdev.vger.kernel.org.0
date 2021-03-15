Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B53933C044
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 16:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbhCOPpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 11:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbhCOPpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 11:45:33 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CDF1C06174A;
        Mon, 15 Mar 2021 08:45:33 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id n11-20020a05600c4f8bb029010e5cf86347so2507516wmq.1;
        Mon, 15 Mar 2021 08:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Q48Kr2C9+BKeH4JyyNeiqwD6LM9nmEPtsEljOxsP/m0=;
        b=ugxYRSqq20KLoYUR2M+9u/aCaZ/FfXD3vNr3PMoOcEyYxFh2uoi2auHVKSRaiu2kOR
         EfQz/GMacUeudhzycHC81AJB3AcM+hJiIaGFQDaDXX1DKrXLVIddiCrYpouhi4Icu2mU
         9cVZTVPgVhAXu1Nel03iFc01kIF7DrwmOQv9FZdjUW2KIaKUNBgijyFHiNh+8bFuGD9w
         QlCXI3a1958oxdyXwCB40PhAgvyK4LcKM8+5VpzaVrHHpTYaqTzZPxYFvvR2lKG4ta2B
         eG1GBwP2GtYJzDQTRZaX0fXi9UuhhmGEn01nbEK8NEddH3Lplq/+MnmuNM8s8y+9Dda/
         Syjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q48Kr2C9+BKeH4JyyNeiqwD6LM9nmEPtsEljOxsP/m0=;
        b=C6LC13HU0ilwlu2j/Ab8DclV3ElTO1c7RLbyp+48+j32b4kQQRjmdiLPFWCsLQalFU
         PSyCcK9ioqRZOBlblOx3Ow1W2Lz6tiqnZWw9Jnh5yTcSkEOFIZ/wRGztxOIolkoW1BhQ
         ucv6CIyl5ewOb8AFypQce7lPQ5yVBLE7dW2WML3Be/FYBoT0Zyvoi5DSzcmlRxKHbyJ+
         CRYWymEuKN7LGEOTbJXXY9mpwkzFX5bjTlsx0nwoa2haviTErc+ZUb8aUn5KBgtgup6I
         an14Hwh6JK55bUfDixDIx3QIsuUqx2NAgtBUami70di3tIwj/2VBE8hfv06Viexqf7kd
         1/uQ==
X-Gm-Message-State: AOAM533u+2v6ltl9DU0O/GsqNAQRIs4PFxR67jlbognfbyTQeMVS9Jek
        LD1qCJkIyAzWg+mreFRd7TzhYQc74rlaQkCc
X-Google-Smtp-Source: ABdhPJx7YS0y2cEAcymDcVaYBGk64yPGj02JJ3HUaIhsWrRI8m7LaBYpTRfO1tiqnN67YO9wXxzx9A==
X-Received: by 2002:a7b:cd15:: with SMTP id f21mr288529wmj.43.1615823131689;
        Mon, 15 Mar 2021 08:45:31 -0700 (PDT)
Received: from skynet.lan ([80.31.204.166])
        by smtp.gmail.com with ESMTPSA id i10sm18043507wrs.11.2021.03.15.08.45.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 08:45:31 -0700 (PDT)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     jonas.gorski@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        =?UTF-8?q?Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 1/2] dt-bindings: net: Add bcm6368-mdio-mux bindings
Date:   Mon, 15 Mar 2021 16:45:27 +0100
Message-Id: <20210315154528.30212-2-noltari@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210315154528.30212-1-noltari@gmail.com>
References: <20210315154528.30212-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentations for bcm6368 mdio mux driver.

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
---
 v2: remove unneeded clocks property

 .../bindings/net/brcm,bcm6368-mdio-mux.yaml   | 76 +++++++++++++++++++
 1 file changed, 76 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/brcm,bcm6368-mdio-mux.yaml

diff --git a/Documentation/devicetree/bindings/net/brcm,bcm6368-mdio-mux.yaml b/Documentation/devicetree/bindings/net/brcm,bcm6368-mdio-mux.yaml
new file mode 100644
index 000000000000..2f34fda55fd0
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/brcm,bcm6368-mdio-mux.yaml
@@ -0,0 +1,76 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/brcm,bcm6368-mdio-mux.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Broadcom BCM6368 MDIO bus multiplexer
+
+maintainers:
+  - Álvaro Fernández Rojas <noltari@gmail.com>
+
+description:
+  This MDIO bus multiplexer defines buses that could be internal as well as
+  external to SoCs. When child bus is selected, one needs to select these two
+  properties as well to generate desired MDIO transaction on appropriate bus.
+
+allOf:
+  - $ref: "mdio.yaml#"
+
+properties:
+  compatible:
+    const: brcm,bcm6368-mdio-mux
+
+  "#address-cells":
+    const: 1
+
+  "#size-cells":
+    const: 0
+
+  reg:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+
+patternProperties:
+  '^mdio@[0-1]$':
+    type: object
+    properties:
+      reg:
+        maxItems: 1
+
+      "#address-cells":
+        const: 1
+
+      "#size-cells":
+        const: 0
+
+    required:
+      - reg
+      - "#address-cells"
+      - "#size-cells"
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    mdio0: mdio@10e000b0 {
+      #address-cells = <1>;
+      #size-cells = <0>;
+      compatible = "brcm,bcm6368-mdio-mux";
+      reg = <0x10e000b0 0x6>;
+
+      mdio_int: mdio@0 {
+        #address-cells = <1>;
+        #size-cells = <0>;
+        reg = <0>;
+      };
+
+      mdio_ext: mdio@1 {
+        #address-cells = <1>;
+        #size-cells = <0>;
+        reg = <1>;
+      };
+    };
-- 
2.20.1

