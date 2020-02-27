Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF4A3171465
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 10:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbgB0Jwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 04:52:46 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34886 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728454AbgB0Jwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 04:52:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dfDOS8M/h/5R66JW8YhaCe/EtnNvHeTQ5r1lVZWQiwQ=; b=yBlaHRGsDFtSmTVYu8yFJsIllT
        ahvp4g81kEkx5qvwHCvfjV02/sm9DljMGyrxhgFlLekTrMuAN9L9dFcP/bBG5zKifRqGui6P8pHrV
        AFdDbtAMLzBwcuCObiUrGUNSfmu81fweAubNtdwMjzksu/apuz+Vs2/GfksgeK4Pbts6O4eLdJB24
        zE/m2073WPfSq9YhG5DNLzWhemLdATIxY4iVwjFw+gQevEQrF0Dq8PCrfoVO8YYDxhaT93ATK/yBa
        kaxyD/Z7awREl6rpSWvolkSCYAjBypugbInwnZjTezq6UjqmoyCny0olwEwpC0qu+0QUeBHiwObFB
        4DY4dzRQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:45374 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j7FqP-0004k4-H8; Thu, 27 Feb 2020 09:52:37 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j7FqO-0003sv-Ho; Thu, 27 Feb 2020 09:52:36 +0000
In-Reply-To: <20200227095159.GJ25745@shell.armlinux.org.uk>
References: <20200227095159.GJ25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: [PATCH net-next 1/3] dt-bindings: net: add dt bindings for marvell10g
 driver
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j7FqO-0003sv-Ho@rmk-PC.armlinux.org.uk>
Date:   Thu, 27 Feb 2020 09:52:36 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a DT bindings document for the Marvell 10G driver, which will
augment the generic ethernet PHY binding by having LED mode
configuration.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 .../devicetree/bindings/net/marvell,10g.yaml  | 31 +++++++++++++++++++
 1 file changed, 31 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/marvell,10g.yaml

diff --git a/Documentation/devicetree/bindings/net/marvell,10g.yaml b/Documentation/devicetree/bindings/net/marvell,10g.yaml
new file mode 100644
index 000000000000..da597fc5314d
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/marvell,10g.yaml
@@ -0,0 +1,31 @@
+# SPDX-License-Identifier: GPL-2.0+
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/marvell,10g.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Marvell Alaska X family Ethernet PHYs
+
+maintainers:
+  - Russell King <rmk+kernel@armlinux.org.uk>
+
+allOf:
+  - $ref: ethernet-phy.yaml#
+
+properties:
+  marvell,led-mode:
+    description: |
+      An array of one to four 16-bit integers to write to the PHY LED
+      configuration registers.
+    allOf:
+      - $ref: /schemas/types.yaml#/definitions/uint16-array
+      - minItems: 1
+        maxItems: 4
+
+examples:
+  - |
+    ethernet-phy@0 {
+        reg = <0>;
+        compatible = "ethernet-phy-ieee802.3-c45";
+        marvell,led-mode = /bits/ 16 <0x0129 0x095d 0x0855>;
+    };
-- 
2.20.1

