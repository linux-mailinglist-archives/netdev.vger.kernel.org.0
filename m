Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEA481EE318
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 13:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726639AbgFDLOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 07:14:21 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:52576 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbgFDLOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 07:14:21 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 054BECKf039104;
        Thu, 4 Jun 2020 06:14:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1591269252;
        bh=d2l1dqoA+WuWH2aDyP2yMJJdpOhLFGs8/DCw1NoxlsU=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=Tt92b+maqplCMOabRSrj9Qlzcq+6mh5h+2T0Sip46V7kfduWS1wYcXDhq5H+FnKbm
         HLEsLvS8MCnVj2JAk1GVzHPOCojJUhbh4gWNCX6kmI1wbLAZ27JkjWC3QMEGF3mGmF
         QJ9eaTsEM0OERG2JsNk+Jdf7h/l99IhvruMLLWRQ=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 054BECim055714
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 4 Jun 2020 06:14:12 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 4 Jun
 2020 06:14:12 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 4 Jun 2020 06:14:12 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 054BECop130244;
        Thu, 4 Jun 2020 06:14:12 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v6 1/4] dt-bindings: net: Add tx and rx internal delays
Date:   Thu, 4 Jun 2020 06:14:07 -0500
Message-ID: <20200604111410.17918-2-dmurphy@ti.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200604111410.17918-1-dmurphy@ti.com>
References: <20200604111410.17918-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tx-internal-delays and rx-internal-delays are a common setting for RGMII
capable devices.

These properties are used when the phy-mode or phy-controller is set to
rgmii-id, rgmii-rxid or rgmii-txid.  These modes indicate to the
controller that the PHY will add the internal delay for the connection.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 .../devicetree/bindings/net/ethernet-phy.yaml       | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
index 9b1f1147ca36..edd0245d132b 100644
--- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
@@ -162,6 +162,19 @@ properties:
     description:
       Specifies a reference to a node representing a SFP cage.
 
+
+  rx-internal-delay-ps:
+    $ref: /schemas/types.yaml#definitions/uint32
+    description: |
+      RGMII Receive PHY Clock Delay defined in pico seconds.  This is used for
+      PHY's that have configurable RX internal delays.
+
+  tx-internal-delay-ps:
+    $ref: /schemas/types.yaml#definitions/uint32
+    description: |
+      RGMII Transmit PHY Clock Delay defined in pico seconds.  This is used for
+      PHY's that have configurable TX internal delays.
+
 required:
   - reg
 
-- 
2.26.2

