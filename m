Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEFDD21B202
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 11:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbgGJJHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 05:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726288AbgGJJHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 05:07:08 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27037C08C5CE;
        Fri, 10 Jul 2020 02:07:08 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1594372025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wMQmhd6Fe9xnnGisd+9Bp/JqC2PYsEleUByPZLFwnxs=;
        b=JHoyDoI4CpI+ckSGskrfyw8uTI0r9abY1t5aspQzMtK4+SNY2eYFbnR/XS4PmiDW9OcaER
        vz3+HxglvrAHTkQd92JvX5pzuRGb/X77nSeJeBeNgXx2mQZPLTRdlwSkpz0148mIeC3tT1
        TKuiS5ogbdaCxIVGDGARZtxveBaY6qfSaAuijHF3a6Z47vX25v17w3jmy/HNbvLqqCBbu0
        k9Iufy5nevdnoIZaAs3Qb5+yoPFwJq7YaQIsu7+iHpk8tW5i2ezc6Q1pq2Bni/zzJUnHD6
        aosPAQQORrm+kZF9EVwIRHtZ/LkmFTus4PF+nFaDDIADOzLu8BPp17Al4tpVoQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1594372025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wMQmhd6Fe9xnnGisd+9Bp/JqC2PYsEleUByPZLFwnxs=;
        b=KIXo9qwVj4674IauAIxi8bBQJt91/RkKdKAjAECN0tCpbZuqteOgifnUIoXb8hzc8opt8I
        daZD6cyIQgUCP9CA==
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v1 1/1] dt-bindings: net: dsa: Add DSA yaml binding
Date:   Fri, 10 Jul 2020 11:06:18 +0200
Message-Id: <20200710090618.28945-2-kurt@linutronix.de>
In-Reply-To: <20200710090618.28945-1-kurt@linutronix.de>
References: <20200710090618.28945-1-kurt@linutronix.de>
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
 .../devicetree/bindings/net/dsa/dsa.yaml      | 80 +++++++++++++++++++
 1 file changed, 80 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/dsa.yaml

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
new file mode 100644
index 000000000000..bec257231bf8
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -0,0 +1,80 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/dsa/dsa.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Distributed Switch Architecture Device Tree Bindings
+
+maintainers:
+  - Andrew Lunn <andrew@lunn.ch>
+  - Florian Fainelli <f.fainelli@gmail.com>
+  - Vivien Didelot <vivien.didelot@gmail.com>
+
+description:
+  Switches are true Linux devices and can be probed by any means. Once probed,
+  they register to the DSA framework, passing a node pointer. This node is
+  expected to fulfil the following binding, and may contain additional
+  properties as required by the device it is embedded within.
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
+  ports:
+    type: object
+    properties:
+      '#address-cells':
+        const: 1
+      '#size-cells':
+        const: 0
+
+    patternProperties:
+      "^port@[0-9]+$":
+          type: object
+          description: DSA switch ports
+
+          allOf:
+            - $ref: ../ethernet-controller.yaml#
+
+          properties:
+            reg:
+              description: Port number
+
+            label:
+              description:
+                Describes the label associated with this port, which will become
+                the netdev name
+              $ref: /schemas/types.yaml#definitions/string
+
+            link:
+              description:
+                Should be a list of phandles to other switch's DSA port. This
+                port is used as the outgoing port towards the phandle ports. The
+                full routing information must be given, not just the one hop
+                routes to neighbouring switches
+              $ref: /schemas/types.yaml#definitions/phandle-array
+
+            ethernet:
+              description:
+                Should be a phandle to a valid Ethernet device node.  This host
+                device is what the switch port is connected to
+              $ref: /schemas/types.yaml#definitions/phandle
+
+          required:
+            - reg
+
+required:
+  - ports
+
+...
-- 
2.20.1

