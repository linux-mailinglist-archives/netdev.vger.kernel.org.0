Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2444463FC4
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 22:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343971AbhK3VU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 16:20:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343977AbhK3VUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 16:20:06 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D0AC061574;
        Tue, 30 Nov 2021 13:16:46 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id y12so92438876eda.12;
        Tue, 30 Nov 2021 13:16:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QaKNLcEbd4W+9va6JdgC5Dp/YFctoLABljRpwtI9gAE=;
        b=cAjV81xggRN5tg7ifBrw/dad14U/K7GKgSV7k9z5kbQznek/YKnuhRfAyecWPtKcKa
         y1g1eWL5zNolgtxNS3fIqF3lnFGWlgJL+ps0ZGQ2hBexSvkAsIIctoGI4/M1xf0duZvj
         rpqdYTB4J/SzmLcyAagR02cNsdc7vuORtB8BG0oHQwUZ9upq83x9rMU4PXIauWosQaaq
         AnbGHdMrfFh6o7wlT7jGWYsV6udYrn3WyJ5CjzYBVk3hWWy9CpO41KYr4JHBgz+cIU8e
         52KVomjYpx48knvqI1/OfxyudOBettQ7Kcm8wQoPpOLfUXbUPIK+iirxW9x4ryx07mWO
         i+PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QaKNLcEbd4W+9va6JdgC5Dp/YFctoLABljRpwtI9gAE=;
        b=tnx/DAw/whEYw42ylP2Qo6MgnYOvm9F7A8TgP7oz8HcDm8HxpRJg31S8WdUp0YfHu4
         0z8tTSAE0492frk4hX7hD0ZXaeWXhga7cb/xsGvWpi/FnTuQSWSyFCdFJrft67CZLPZw
         uA/GNr6lNwpwbQQi7WsVSM+eWDraKsYRANFofalTfr9NhfBXUoPE/MaaRsU2DU4slujO
         yMOCPSKy9zb0m6lmXuZAkBUDENVcciMx1qFwhOXdYOKG//Oz+smg0mnBT6CYD2GhgpDJ
         oFStjAKmqXQrs8mhi+3pmCPvDj/3XTGZACO06PWPdFlfMWrMm6obfMRi5owB14Xe/OEl
         vCeg==
X-Gm-Message-State: AOAM530/9yMN2LWunBI8/2mKuIMpXuQrgnKBHwjNGMv6Msnt5n7atIxe
        DC1rK8YkmJlIdJvcZd72V+4U2Koo3h8=
X-Google-Smtp-Source: ABdhPJx9MDQYkX7IUbUNWwWUiXVs9/dGt+kDT/MmEHGywV/IixFMltlNOOnuQFFpD7/T+NTl4mc4ZQ==
X-Received: by 2002:a17:907:7ba8:: with SMTP id ne40mr1845191ejc.391.1638307005099;
        Tue, 30 Nov 2021 13:16:45 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id p13sm12271753eds.38.2021.11.30.13.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 13:16:44 -0800 (PST)
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
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Rob Herring <robh@kernel.org>
Subject: [net-next PATCH v2 1/2] dt-bindings: net: dsa: split generic port definition from dsa.yaml
Date:   Tue, 30 Nov 2021 22:16:24 +0100
Message-Id: <20211130211625.29724-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some switch may require to add additional binding to the node port.
Move DSA generic port definition to a dedicated yaml to permit this.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/net/dsa/dsa-port.yaml | 77 +++++++++++++++++++
 .../devicetree/bindings/net/dsa/dsa.yaml      | 60 +--------------
 2 files changed, 79 insertions(+), 58 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/dsa-port.yaml

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
new file mode 100644
index 000000000000..702df848a71d
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
@@ -0,0 +1,77 @@
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
+allOf:
+  - $ref: "http://devicetree.org/schemas/net/ethernet-controller.yaml#"
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
+  rx-internal-delay-ps: true
+
+  tx-internal-delay-ps: true
+
+required:
+  - reg
+
+additionalProperties: true
+
+...
diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
index 2ad7f79ad371..b9d48e357e77 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -46,65 +46,9 @@ patternProperties:
         type: object
         description: Ethernet switch ports
 
-        allOf:
-          - $ref: "http://devicetree.org/schemas/net/ethernet-controller.yaml#"
+        $ref: dsa-port.yaml#
 
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
-          rx-internal-delay-ps: true
-
-          tx-internal-delay-ps: true
-
-        required:
-          - reg
-
-        additionalProperties: false
+        unevaluatedProperties: false
 
 oneOf:
   - required:
-- 
2.32.0

