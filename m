Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE84C225F88
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 14:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729446AbgGTMup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 08:50:45 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:57552 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728224AbgGTMum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 08:50:42 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595249439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XtACNWaES3mQkzXBC/9ErRbnkcOL4Ew5cJ2sE4iNn5c=;
        b=WFQuZkPE2H9fQkb5/v965EaPTDp/+mgQl4NQe6Hwnqn5eXfWc78BIRTibJtfQyMTZwsjmK
        iSPIdcKhy2DLqOJqkXq6de1SJTgo7HFcQM3gpVulpvbui8bRQeo1ysksV5lJiacPgdAv04
        WrXHYeaOhBMHIn7Iu8nElg/MB/vrnsjkP0Bj6w8TZRntBm3Lr5hMa2rw2Co2+cbI4YqQxI
        JdU/6QN6eVD4sHVY48Swrf3Cx3/3LkhXWwz3ZBgS7PxUNIODAfJmIl+a3JLZDP/dcSgJ9R
        6AGDKcEJSzTxzftyZyj5mDV0Kt8/UhJFKq1rHD07Ue0zRZy0ZAJgtE6VJ8ZRaQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595249439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XtACNWaES3mQkzXBC/9ErRbnkcOL4Ew5cJ2sE4iNn5c=;
        b=EFfpGgATyBWGJzqk6zoIu46xm35nIKtCx8dhfve4sVqdJVUhFBcj5Q6g9lawVgZPD4hyQf
        SmymE3/9beZVlfDA==
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v2 1/3] dt-bindings: net: dsa: Add DSA yaml binding
Date:   Mon, 20 Jul 2020 14:49:37 +0200
Message-Id: <20200720124939.4359-2-kurt@linutronix.de>
In-Reply-To: <20200720124939.4359-1-kurt@linutronix.de>
References: <20200720124939.4359-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For future DSA drivers it makes sense to add a generic DSA yaml binding which
can be used then. This was created using the properties from dsa.txt. It
includes the ports and the dsa,member property.

Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 .../devicetree/bindings/net/dsa/dsa.yaml      | 92 +++++++++++++++++++
 1 file changed, 92 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/dsa.yaml

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
new file mode 100644
index 000000000000..faea214339ca
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -0,0 +1,92 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/dsa/dsa.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Ethernet Switch Device Tree Bindings
+
+maintainers:
+  - Andrew Lunn <andrew@lunn.ch>
+  - Florian Fainelli <f.fainelli@gmail.com>
+  - Vivien Didelot <vivien.didelot@gmail.com>
+
+description:
+  This binding represents Ethernet Switches which have a dedicated CPU
+  port. That port is usually connected to an Ethernet Controller of the
+  SoC. Such setups are typical for embedded devices.
+
+select: false
+
+properties:
+  $nodename:
+    pattern: "^switch(@.*)?$"
+
+  dsa,member:
+    minItems: 2
+    maxItems: 2
+    description:
+      A two element list indicates which DSA cluster, and position within the
+      cluster a switch takes. <0 0> is cluster 0, switch 0. <0 1> is cluster 0,
+      switch 1. <1 0> is cluster 1, switch 0. A switch not part of any cluster
+      (single device hanging off a CPU port) must not specify this property
+    $ref: /schemas/types.yaml#/definitions/uint32-array
+
+patternProperties:
+  "^(ethernet-)?ports$":
+    type: object
+    properties:
+      '#address-cells':
+        const: 1
+      '#size-cells':
+        const: 0
+
+    patternProperties:
+      "^(ethernet-)?port@[0-9]+$":
+        type: object
+        description: Ethernet switch ports
+
+        properties:
+          reg:
+            description: Port number
+
+          label:
+            description:
+              Describes the label associated with this port, which will become
+              the netdev name
+            $ref: /schemas/types.yaml#definitions/string
+
+          link:
+            description:
+              Should be a list of phandles to other switch's DSA port. This
+              port is used as the outgoing port towards the phandle ports. The
+              full routing information must be given, not just the one hop
+              routes to neighbouring switches
+            $ref: /schemas/types.yaml#definitions/phandle-array
+
+          ethernet:
+            description:
+              Should be a phandle to a valid Ethernet device node.  This host
+              device is what the switch port is connected to
+            $ref: /schemas/types.yaml#definitions/phandle
+
+          phy-handle: true
+
+          phy-mode: true
+
+          fixed-link: true
+
+          mac-address: true
+
+        required:
+          - reg
+
+        additionalProperties: false
+
+oneOf:
+  - required:
+    - ports
+  - required:
+    - ethernet-ports
+
+...
-- 
2.20.1

