Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 678E21DB2FF
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 14:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbgETMTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 08:19:08 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:49932 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbgETMTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 08:19:04 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04KCIvIi044180;
        Wed, 20 May 2020 07:18:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1589977137;
        bh=sz1d30oTTh8vMYDylpY9tVGBzny00+8RzK0fIiSFu8Q=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=VMObo72bxw1Enmk2OQyOKaJ3Qpz72S+e2Fd3a9ltCtKiX7bRXypbTbUVLvDfy2Ma1
         rMv/tC6L6Ys75yKOlLD8EoBD8gGFLRl5t4hMdrn7oVfcvFSH8a25Gfd6s9QE+l+ozk
         7FUBDXw9xbhoDWR11kl2ZkxkK2Pzu/2U/QCSfvOw=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04KCIvVa090469
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 07:18:57 -0500
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 20
 May 2020 07:18:56 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 20 May 2020 07:18:56 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04KCIu2c108879;
        Wed, 20 May 2020 07:18:56 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v2 3/4] dt-bindings: net: Add RGMII internal delay for DP83869
Date:   Wed, 20 May 2020 07:18:34 -0500
Message-ID: <20200520121835.31190-4-dmurphy@ti.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200520121835.31190-1-dmurphy@ti.com>
References: <20200520121835.31190-1-dmurphy@ti.com>
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
 .../devicetree/bindings/net/ti,dp83869.yaml    | 16 ++++++++++++++++
 include/dt-bindings/net/ti-dp83869.h           | 18 ++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ti,dp83869.yaml b/Documentation/devicetree/bindings/net/ti,dp83869.yaml
index 5b69ef03bbf7..344015ab9081 100644
--- a/Documentation/devicetree/bindings/net/ti,dp83869.yaml
+++ b/Documentation/devicetree/bindings/net/ti,dp83869.yaml
@@ -64,6 +64,20 @@ properties:
        Operational mode for the PHY.  If this is not set then the operational
        mode is set by the straps. see dt-bindings/net/ti-dp83869.h for values
 
+  ti,rx-internal-delay:
+    $ref: /schemas/types.yaml#definitions/uint32
+    description: |
+      RGMII Receive Clock Delay - see dt-bindings/net/ti-dp83869.h
+      for applicable values. Required only if interface type is
+      PHY_INTERFACE_MODE_RGMII_ID or PHY_INTERFACE_MODE_RGMII_RXID.
+
+  ti,tx-internal-delay:
+    $ref: /schemas/types.yaml#definitions/uint32
+    description: |
+      RGMII Transmit Clock Delay - see dt-bindings/net/ti-dp83869.h
+      for applicable values. Required only if interface type is
+      PHY_INTERFACE_MODE_RGMII_ID or PHY_INTERFACE_MODE_RGMII_TXID.
+
 required:
   - reg
 
@@ -80,5 +94,7 @@ examples:
         ti,op-mode = <DP83869_RGMII_COPPER_ETHERNET>;
         ti,max-output-impedance = "true";
         ti,clk-output-sel = <DP83869_CLK_O_SEL_CHN_A_RCLK>;
+        ti,rx-internal-delay = <DP83869_RGMIIDCTL_2_25_NS>;
+        ti,tx-internal-delay = <DP83869_RGMIIDCTL_2_75_NS>;
       };
     };
diff --git a/include/dt-bindings/net/ti-dp83869.h b/include/dt-bindings/net/ti-dp83869.h
index 218b1a64e975..77d104a40f1f 100644
--- a/include/dt-bindings/net/ti-dp83869.h
+++ b/include/dt-bindings/net/ti-dp83869.h
@@ -16,6 +16,24 @@
 #define DP83869_PHYCR_FIFO_DEPTH_6_B_NIB	0x02
 #define DP83869_PHYCR_FIFO_DEPTH_8_B_NIB	0x03
 
+/* RGMIIDCTL internal delay for rx and tx */
+#define	DP83869_RGMIIDCTL_250_PS	0x0
+#define	DP83869_RGMIIDCTL_500_PS	0x1
+#define	DP83869_RGMIIDCTL_750_PS	0x2
+#define	DP83869_RGMIIDCTL_1_NS		0x3
+#define	DP83869_RGMIIDCTL_1_25_NS	0x4
+#define	DP83869_RGMIIDCTL_1_50_NS	0x5
+#define	DP83869_RGMIIDCTL_1_75_NS	0x6
+#define	DP83869_RGMIIDCTL_2_00_NS	0x7
+#define	DP83869_RGMIIDCTL_2_25_NS	0x8
+#define	DP83869_RGMIIDCTL_2_50_NS	0x9
+#define	DP83869_RGMIIDCTL_2_75_NS	0xa
+#define	DP83869_RGMIIDCTL_3_00_NS	0xb
+#define	DP83869_RGMIIDCTL_3_25_NS	0xc
+#define	DP83869_RGMIIDCTL_3_50_NS	0xd
+#define	DP83869_RGMIIDCTL_3_75_NS	0xe
+#define	DP83869_RGMIIDCTL_4_00_NS	0xf
+
 /* IO_MUX_CFG - Clock output selection */
 #define DP83869_CLK_O_SEL_CHN_A_RCLK		0x0
 #define DP83869_CLK_O_SEL_CHN_B_RCLK		0x1
-- 
2.26.2

