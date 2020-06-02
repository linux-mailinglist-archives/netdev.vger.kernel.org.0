Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE82C1EC055
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 18:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728059AbgFBQpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 12:45:55 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:46258 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbgFBQpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 12:45:50 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 052Gjiqg091816;
        Tue, 2 Jun 2020 11:45:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1591116344;
        bh=eShyx82GLaQ3xsgsj9ve463coidBb5dHGAfrzfcrN0w=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=YAGctkSHORMLLeEN6BSLeDvYhXnIyRg4Gfy4Tg3FPu1Cql5ra1gLh9bWCtp/AU0jE
         C3QImkgfntg4I9CLM5zDG6hQcdCsEocmMT+T6Nx/D+wX+aoafHv8lkuzQJvxohm6DI
         7xeHmYVyv57qAbcHKnfh0c8ppf3lBhitzO3i3iYo=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 052GjirG008481
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 2 Jun 2020 11:45:44 -0500
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 2 Jun
 2020 11:45:44 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 2 Jun 2020 11:45:44 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 052Gji7u012851;
        Tue, 2 Jun 2020 11:45:44 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v5 3/4] dt-bindings: net: Add RGMII internal delay for DP83869
Date:   Tue, 2 Jun 2020 11:45:21 -0500
Message-ID: <20200602164522.3276-4-dmurphy@ti.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200602164522.3276-1-dmurphy@ti.com>
References: <20200602164522.3276-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the internal delay values into the header and update the binding
with the internal delay properties.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 .../devicetree/bindings/net/ti,dp83869.yaml      | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/ti,dp83869.yaml b/Documentation/devicetree/bindings/net/ti,dp83869.yaml
index 5b69ef03bbf7..71e90a3e4652 100644
--- a/Documentation/devicetree/bindings/net/ti,dp83869.yaml
+++ b/Documentation/devicetree/bindings/net/ti,dp83869.yaml
@@ -8,7 +8,7 @@ $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 title: TI DP83869 ethernet PHY
 
 allOf:
-  - $ref: "ethernet-controller.yaml#"
+  - $ref: "ethernet-phy.yaml#"
 
 maintainers:
   - Dan Murphy <dmurphy@ti.com>
@@ -64,6 +64,18 @@ properties:
        Operational mode for the PHY.  If this is not set then the operational
        mode is set by the straps. see dt-bindings/net/ti-dp83869.h for values
 
+  rx-internal-delay-ps:
+    description: Delay is in pico seconds
+    enum: [ 250, 500, 750, 1000, 1250, 1500, 1750, 2000, 2250, 2500, 2750, 3000,
+            3250, 3500, 3750, 4000 ]
+    default: 2000
+
+  tx-internal-delay-ps:
+    description: Delay is in pico seconds
+    enum: [ 250, 500, 750, 1000, 1250, 1500, 1750, 2000, 2250, 2500, 2750, 3000,
+            3250, 3500, 3750, 4000 ]
+    default: 2000
+
 required:
   - reg
 
@@ -80,5 +92,7 @@ examples:
         ti,op-mode = <DP83869_RGMII_COPPER_ETHERNET>;
         ti,max-output-impedance = "true";
         ti,clk-output-sel = <DP83869_CLK_O_SEL_CHN_A_RCLK>;
+        rx-internal-delay-ps = <2000>;
+        tx-internal-delay-ps = <2000>;
       };
     };
-- 
2.26.2

