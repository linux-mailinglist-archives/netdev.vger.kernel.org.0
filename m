Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7CB72B6FDB
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 21:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731725AbgKQUQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 15:16:19 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:51092 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgKQUQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 15:16:16 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0AHKGCch066056;
        Tue, 17 Nov 2020 14:16:12 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1605644172;
        bh=WvkCGz2iuxVOMGMnfv0mX3hEFweRTvsdysXYnm8TVkI=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=ZFQesfAkwr1MZ9oRK+d2g99Z4zi017ts3hAn0P/zCvTJ1KreWib933xGeeR3jSHvd
         t10M4MNfHhM2EgGOf649HseDhMEjd+qm8t8vba0tsqCE40E+vHmL39GTas+FDT1DZ7
         kbq0ve0z20ZpMVG5bC9sY/L+4BUi8IlhLaJtGR48=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0AHKGCvY016165
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Nov 2020 14:16:12 -0600
Received: from DLEE110.ent.ti.com (157.170.170.21) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 17
 Nov 2020 14:16:12 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 17 Nov 2020 14:16:12 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0AHKGBxY096100;
        Tue, 17 Nov 2020 14:16:12 -0600
From:   Dan Murphy <dmurphy@ti.com>
To:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <robh@kernel.org>, <ciorneiioana@gmail.com>
CC:     <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH net-next v4 2/4] dt-bindings: net: Add Rx/Tx output configuration for 10base T1L
Date:   Tue, 17 Nov 2020 14:15:53 -0600
Message-ID: <20201117201555.26723-3-dmurphy@ti.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201117201555.26723-1-dmurphy@ti.com>
References: <20201117201555.26723-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Per the 802.3cg spec the 10base T1L can operate at 2 different
differential voltages 1v p2p and 2.4v p2p. The abiility of the PHY to
drive that output is dependent on the PHY's on board power supply.
This common feature is applicable to all 10base T1L PHYs so this binding
property belongs in a top level ethernet document.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 Documentation/devicetree/bindings/net/ethernet-phy.yaml | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
index 6dd72faebd89..bda1ce51836b 100644
--- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
@@ -174,6 +174,12 @@ properties:
       PHY's that have configurable TX internal delays. If this property is
       present then the PHY applies the TX delay.
 
+  max-tx-rx-p2p-microvolt:
+    description: |
+      Configures the Tx/Rx p2p differential output voltage for 10base-T1L PHYs.
+    enum: [ 1100, 2400 ]
+    default: 2400
+
 required:
   - reg
 
-- 
2.29.2

