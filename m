Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0439C44EBB0
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 17:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235440AbhKLRA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 12:00:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235142AbhKLRA5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 12:00:57 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A89C061766;
        Fri, 12 Nov 2021 08:58:06 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id z10so13799657edc.11;
        Fri, 12 Nov 2021 08:58:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eyqg6p4AjDBrrt4XArlO33nk2XTZ9oXkihOY6hJrEj0=;
        b=gEdvnuBEEGlM92bprmggmxutdAgR4dd/MJWVmlbuB0pKm8EoYlYc4qvcBmZR9ZKgGN
         w7zymYQK6DiQZXsTjhO/ipRjVAaUMPJ93O9oekonBn1GFVKNulwmKZqU7cFNaW8IAdv8
         YJvn26wzLJpV0OImAXeDwRrmqqSVIm+GaByR+tMvdmUu3oyYCM63wfgmHX3VOl1DPdBq
         1ghLzpyPr8lbzjyJsNypqPfVy5xgmvUEpZS2l1Be4+/J+OLHCeyH0KuXCmijkOANbbuX
         a1vBDf1+hURUQ9huuviS0GBs9OCWJNp2Qos6cPO3XSha9vfHY9FHtuBAIVv0EaMVl2V3
         fXMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eyqg6p4AjDBrrt4XArlO33nk2XTZ9oXkihOY6hJrEj0=;
        b=ViCaJ11bAiTAuGQsbgkXZDI6uwHwyknzHJf+DPYVxvV+1lGMcQuOFcYZY/DaqQo9bv
         L9P1/IHilDdX1SVPP5K1j3lxZqCTRzAje4u6Ki+xMergygCtSIlyolMY7/+IdjwKO5HR
         jYU42MZEyq7JH4BsyjhjqRe1Q74pJhZWrLtY+sDUm43HE2+8G9ZBH9eJnEMQuyVyRThO
         qwZVvdtDF03AAthODxVlcyfUAPv+pzi8ewzcGMEDJpuqjYC8R3+QmXrx7vyQh9mpr+ij
         iMiF/908rgYvCXzgbdhRUQYxwfzBeguURne1RDDILtCOvTH3C0nnq7ThDNipOGNAcR9T
         T2lw==
X-Gm-Message-State: AOAM532AaJuCWFBw/ZEDNyyda5DNAAm46DxCqgsf9aUaosybidPDteHT
        v6TpTD9gvvpjitNKdwq2CsU=
X-Google-Smtp-Source: ABdhPJz0iD4PTo+VPXmRIq40jiq2OOdvPGNDwwivMYeMZ+/+R8NxV5aKrKw5lewJaEDMGCAC3Pajww==
X-Received: by 2002:aa7:da09:: with SMTP id r9mr4806793eds.71.1636736285200;
        Fri, 12 Nov 2021 08:58:05 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id bo20sm3409492edb.31.2021.11.12.08.58.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 08:58:04 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [PATCH 1/2] dt-bindings: net: dsa: split generic port definition from dsa.yaml
Date:   Fri, 12 Nov 2021 17:57:51 +0100
Message-Id: <20211112165752.1704-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some switch may require to add additional binding to the node port.
Move DSA generic port definition to a dedicated yaml to permit this.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 .../devicetree/bindings/net/dsa/dsa-port.yaml | 70 +++++++++++++++++++
 .../devicetree/bindings/net/dsa/dsa.yaml      | 54 +-------------
 2 files changed, 72 insertions(+), 52 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/dsa-port.yaml

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
new file mode 100644
index 000000000000..258df41c9133
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
@@ -0,0 +1,70 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/dsa/dsa-port.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Ethernet Switch port Device Tree Bindings
+
+maintainers:
+  - Andrew Lunn <andrew@lunn.ch>
+  - Florian Fainelli <f.fainelli@gmail.com>
+  - Vivien Didelot <vivien.didelot@gmail.com>
+
+description:
+  Ethernet switch port Description
+
+properties:
+  reg:
+    description: Port number
+
+  label:
+    description:
+      Describes the label associated with this port, which will become
+      the netdev name
+    $ref: /schemas/types.yaml#/definitions/string
+
+  link:
+    description:
+      Should be a list of phandles to other switch's DSA port. This
+      port is used as the outgoing port towards the phandle ports. The
+      full routing information must be given, not just the one hop
+      routes to neighbouring switches
+    $ref: /schemas/types.yaml#/definitions/phandle-array
+
+  ethernet:
+    description:
+      Should be a phandle to a valid Ethernet device node.  This host
+      device is what the switch port is connected to
+    $ref: /schemas/types.yaml#/definitions/phandle
+
+  dsa-tag-protocol:
+    description:
+      Instead of the default, the switch will use this tag protocol if
+      possible. Useful when a device supports multiple protocols and
+      the default is incompatible with the Ethernet device.
+    enum:
+      - dsa
+      - edsa
+      - ocelot
+      - ocelot-8021q
+      - seville
+
+  phy-handle: true
+
+  phy-mode: true
+
+  fixed-link: true
+
+  mac-address: true
+
+  sfp: true
+
+  managed: true
+
+required:
+  - reg
+
+additionalProperties: true
+
+...
diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
index 224cfa45de9a..15ea9ef3def9 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -46,58 +46,8 @@ patternProperties:
         type: object
         description: Ethernet switch ports
 
-        properties:
-          reg:
-            description: Port number
-
-          label:
-            description:
-              Describes the label associated with this port, which will become
-              the netdev name
-            $ref: /schemas/types.yaml#/definitions/string
-
-          link:
-            description:
-              Should be a list of phandles to other switch's DSA port. This
-              port is used as the outgoing port towards the phandle ports. The
-              full routing information must be given, not just the one hop
-              routes to neighbouring switches
-            $ref: /schemas/types.yaml#/definitions/phandle-array
-
-          ethernet:
-            description:
-              Should be a phandle to a valid Ethernet device node.  This host
-              device is what the switch port is connected to
-            $ref: /schemas/types.yaml#/definitions/phandle
-
-          dsa-tag-protocol:
-            description:
-              Instead of the default, the switch will use this tag protocol if
-              possible. Useful when a device supports multiple protocols and
-              the default is incompatible with the Ethernet device.
-            enum:
-              - dsa
-              - edsa
-              - ocelot
-              - ocelot-8021q
-              - seville
-
-          phy-handle: true
-
-          phy-mode: true
-
-          fixed-link: true
-
-          mac-address: true
-
-          sfp: true
-
-          managed: true
-
-        required:
-          - reg
-
-        additionalProperties: false
+        allOf:
+          - $ref: dsa-port.yaml#
 
 oneOf:
   - required:
-- 
2.32.0

