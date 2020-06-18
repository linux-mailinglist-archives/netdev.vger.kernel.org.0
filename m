Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB5FE1FFD3B
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 23:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731087AbgFRVKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 17:10:41 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:53348 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730989AbgFRVKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 17:10:38 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 05ILAXJV068355;
        Thu, 18 Jun 2020 16:10:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1592514633;
        bh=eShyx82GLaQ3xsgsj9ve463coidBb5dHGAfrzfcrN0w=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=sXY5TAz+WB6YGm1xb8wVwCxA4cRSYw0sOGinb5VFzMQBRIzlCs72qWjH49Rj/9V/M
         LAUHY0Wk4Q+OTvgzGTVSs/RJmVSKrX9Fhck1f3mCdJad4vZfhNDmZd51ziAmE0H/nO
         hD/hWBJNUjGoLn3GPgz8rYytBpmwBylLMvoXxSlo=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 05ILAX0U021855
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 18 Jun 2020 16:10:33 -0500
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 18
 Jun 2020 16:10:33 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 18 Jun 2020 16:10:33 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05ILAX0T065829;
        Thu, 18 Jun 2020 16:10:33 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v8 3/5] dt-bindings: net: Add RGMII internal delay for DP83869
Date:   Thu, 18 Jun 2020 16:10:09 -0500
Message-ID: <20200618211011.28837-4-dmurphy@ti.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200618211011.28837-1-dmurphy@ti.com>
References: <20200618211011.28837-1-dmurphy@ti.com>
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

