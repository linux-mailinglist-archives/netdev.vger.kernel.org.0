Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 316ED1E2964
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 19:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389262AbgEZRs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 13:48:56 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:38344 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389241AbgEZRsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 13:48:53 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04QHmm8P033618;
        Tue, 26 May 2020 12:48:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1590515328;
        bh=G0XjWWJkhcxIyep/pNH32iAS9dR/fyKieQrxEzmRWJA=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=LN6LT48SZe1QBVNo8XIOwt2jYO37wamSO9MQADl4/oyyyeVv4+O3OdNzBOIc43TwX
         +C+YkDrobGS1mG2DIAQ3fhU4J3bOksounTbldV7u7AobKlhMXXpaZUxHP0bWg+MMHi
         ZxvPgJ47X+97Yw+zFcfylkbhKZtcpy0r6tGaXKis=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04QHml6p087941;
        Tue, 26 May 2020 12:48:48 -0500
Received: from DLEE112.ent.ti.com (157.170.170.23) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 26
 May 2020 12:47:18 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 26 May 2020 12:47:18 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04QHlIkS087194;
        Tue, 26 May 2020 12:47:18 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v3 1/4] dt-bindings: net: Add tx and rx internal delays
Date:   Tue, 26 May 2020 12:47:13 -0500
Message-ID: <20200526174716.14116-2-dmurphy@ti.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526174716.14116-1-dmurphy@ti.com>
References: <20200526174716.14116-1-dmurphy@ti.com>
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
 .../bindings/net/ethernet-controller.yaml          | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index ac471b60ed6a..70702a4ef5e8 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -143,6 +143,20 @@ properties:
       Specifies the PHY management type. If auto is set and fixed-link
       is not specified, it uses MDIO for management.
 
+  rx-internal-delay-ps:
+    $ref: /schemas/types.yaml#definitions/uint32
+    description: |
+      RGMII Receive PHY Clock Delay defined in pico seconds.  This is used for
+      PHY's that have configurable RX internal delays.  This property is only
+      used when the phy-mode or phy-connection-type is rgmii-id or rgmii-rxid.
+
+  tx-internal-delay-ps:
+    $ref: /schemas/types.yaml#definitions/uint32
+    description: |
+      RGMII Transmit PHY Clock Delay defined in pico seconds.  This is used for
+      PHY's that have configurable TX internal delays.  This property is only
+      used when the phy-mode or phy-connection-type is rgmii-id or rgmii-txid.
+
   fixed-link:
     allOf:
       - if:
-- 
2.26.2

