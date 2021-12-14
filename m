Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDB65474E9D
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 00:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238263AbhLNXeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 18:34:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235236AbhLNXen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 18:34:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81070C061574;
        Tue, 14 Dec 2021 15:34:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D698B81DC8;
        Tue, 14 Dec 2021 23:34:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2AF0C34605;
        Tue, 14 Dec 2021 23:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639524881;
        bh=F9c6TqEtJNBAy48jwMwJKWur2ITtODBYI89zx7MFjgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YRj/z3iQr74eRpqmQnsNL4rZUrf3Y+SwYbqaHxUtaGPB7OfXQ97mAni/3sa+TRvTE
         OHdp9JM7nJSRaM1KeoUbYEG1zbnobPSsweHIWDSdOwzCix1v5kOBH68QuA5/hKvsRx
         DngRiPiRAy2KzQ+6oBaGNyMScLwHLOjG+780tcY2jK+85hEaJaBPun5EGIph1rCvB0
         CYSgf2Y+F07OpvhQQtn7CGbtLr0rkWxix2O2x36DMmJasYjVPob1/dbwHgOBijZIFp
         MFJfGbJ3CSNVFOjA30jcclJP85IbepID6HinXhESIjjvkL630FsQmjDY9G9B8XDTIG
         XzOvwgq77YM6A==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Holger Brunck <holger.brunck@hitachienergy.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-phy@lists.infradead.org, Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH devicetree 1/2] dt-bindings: phy: Convert generic PHY provider binding to YAML
Date:   Wed, 15 Dec 2021 00:34:31 +0100
Message-Id: <20211214233432.22580-2-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211214233432.22580-1-kabel@kernel.org>
References: <20211214233432.22580-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert phy-bindings.txt to YAML. This creates binding only for PHY
provider, since PHY consumer binding is in dtschema. Consumer binding
example is provided.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 .../devicetree/bindings/phy/phy-bindings.txt  | 73 +------------------
 .../devicetree/bindings/phy/phy.yaml          | 59 +++++++++++++++
 2 files changed, 60 insertions(+), 72 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/phy.yaml

diff --git a/Documentation/devicetree/bindings/phy/phy-bindings.txt b/Documentation/devicetree/bindings/phy/phy-bindings.txt
index c4eb38902533..ded3cf18352d 100644
--- a/Documentation/devicetree/bindings/phy/phy-bindings.txt
+++ b/Documentation/devicetree/bindings/phy/phy-bindings.txt
@@ -1,72 +1 @@
-This document explains only the device tree data binding. For general
-information about PHY subsystem refer to Documentation/driver-api/phy/phy.rst
-
-PHY device node
-===============
-
-Required Properties:
-#phy-cells:	Number of cells in a PHY specifier;  The meaning of all those
-		cells is defined by the binding for the phy node. The PHY
-		provider can use the values in cells to find the appropriate
-		PHY.
-
-Optional Properties:
-phy-supply:	Phandle to a regulator that provides power to the PHY. This
-		regulator will be managed during the PHY power on/off sequence.
-
-For example:
-
-phys: phy {
-    compatible = "xxx";
-    reg = <...>;
-    .
-    .
-    #phy-cells = <1>;
-    .
-    .
-};
-
-That node describes an IP block (PHY provider) that implements 2 different PHYs.
-In order to differentiate between these 2 PHYs, an additional specifier should be
-given while trying to get a reference to it.
-
-PHY user node
-=============
-
-Required Properties:
-phys : the phandle for the PHY device (used by the PHY subsystem; not to be
-       confused with the Ethernet specific 'phy' and 'phy-handle' properties,
-       see Documentation/devicetree/bindings/net/ethernet.txt for these)
-phy-names : the names of the PHY corresponding to the PHYs present in the
-	    *phys* phandle
-
-Example 1:
-usb1: usb_otg_ss@xxx {
-    compatible = "xxx";
-    reg = <xxx>;
-    .
-    .
-    phys = <&usb2_phy>, <&usb3_phy>;
-    phy-names = "usb2phy", "usb3phy";
-    .
-    .
-};
-
-This node represents a controller that uses two PHYs, one for usb2 and one for
-usb3.
-
-Example 2:
-usb2: usb_otg_ss@xxx {
-    compatible = "xxx";
-    reg = <xxx>;
-    .
-    .
-    phys = <&phys 1>;
-    phy-names = "usbphy";
-    .
-    .
-};
-
-This node represents a controller that uses one of the PHYs of the PHY provider
-device defined previously. Note that the phy handle has an additional specifier
-"1" to differentiate between the two PHYs.
+This file has moved to ./phy.yaml.
diff --git a/Documentation/devicetree/bindings/phy/phy.yaml b/Documentation/devicetree/bindings/phy/phy.yaml
new file mode 100644
index 000000000000..a5b6b04cff5b
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/phy.yaml
@@ -0,0 +1,59 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/phy/phy.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Common PHY Provider Generic Binding
+
+description:
+  This is the generic binding for common PHYs providers.
+
+maintainers:
+  - Kishon Vijay Abraham I <kishon@ti.com>
+  - Vinod Koul <vkoul@kernel.org>
+
+select:
+  required:
+    - '#phy-cells'
+
+properties:
+  '#phy-cells':
+    $ref: '/schemas/types.yaml#/definitions/uint32'
+    description:
+      Number of cells in a PHY specifier. The meaning of all those cells is
+      defined by the binding for the PHY node. The PHY provider can use the
+      values in cells to find the appropriate PHY.
+    maximum: 16
+
+  phy-supply:
+    description:
+      Phandle to a regulator that provides power to the PHY. This regulator
+      will be managed during the PHY power on/off sequence.
+
+required:
+  - '#phy-cells'
+
+additionalProperties: true
+
+examples:
+  - |
+    phy_regulator: regulator {
+      compatible = "regulator-fixed";
+      regulator-name = "phy-regulator";
+    };
+
+    phy: phy {
+      #phy-cells = <1>;
+      phy-supply = <&phy_regulator>;
+    };
+
+    ethernet-controller {
+      phys = <&phy 0>;
+      phy-names = "ethphy";
+    };
+
+    usb {
+      phys = <&phy 1>, <&phy 2>;
+      phy-names = "usb2phy", "usb3phy";
+    };
-- 
2.32.0

