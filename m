Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5C9117356
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 19:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbfLISCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 13:02:01 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:57968 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbfLISB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 13:01:59 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id xB9I1s2R064516;
        Mon, 9 Dec 2019 12:01:54 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1575914514;
        bh=r1x+K9BBhHJjUmtI42e6rQHLTAqUvvujoQEGWOph+/4=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=v0eXCYonH74/2VVsw1SFbu1UR3W+0COpFoMxyMttI+NaUjX2BAf4NdAJvrQKxOpsM
         FcEkTumKzW+9rjIEatkLE9HDrBBBTRed3YE9CzO9SwjkfZO7pZpbaaztSkG/4USsJO
         4FlBG2/oEiqjeybiekSFuEB1zFHNRs2DFJXWc82g=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id xB9I1slb024438;
        Mon, 9 Dec 2019 12:01:54 -0600
Received: from DFLE114.ent.ti.com (10.64.6.35) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Mon, 9 Dec
 2019 12:01:52 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Mon, 9 Dec 2019 12:01:52 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id xB9I1qdD057952;
        Mon, 9 Dec 2019 12:01:52 -0600
From:   Dan Murphy <dmurphy@ti.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <bunk@kernel.org>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <grygorii.strashko@ti.com>,
        Dan Murphy <dmurphy@ti.com>, Rob Herring <robh@kernel.org>
Subject: [PATCH net-next v2 1/2] dt-bindings: dp83867: Convert fifo-depth to common fifo-depth and make optional
Date:   Mon, 9 Dec 2019 11:59:42 -0600
Message-ID: <20191209175943.23110-2-dmurphy@ti.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191209175943.23110-1-dmurphy@ti.com>
References: <20191209175943.23110-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the ti,fifo-depth from a TI specific property to the common
tx-fifo-depth property.  Also add support for the rx-fifo-depth.

These are optional properties for this device and if these are not
available then the fifo depths are set to device default values.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
Reported-by: Adrian Bunk <bunk@kernel.org>
CC: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/net/ti,dp83867.txt | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/ti,dp83867.txt b/Documentation/devicetree/bindings/net/ti,dp83867.txt
index 388ff48f53ae..44e2a4fab29e 100644
--- a/Documentation/devicetree/bindings/net/ti,dp83867.txt
+++ b/Documentation/devicetree/bindings/net/ti,dp83867.txt
@@ -8,8 +8,6 @@ Required properties:
 	- ti,tx-internal-delay - RGMII Transmit Clock Delay - see dt-bindings/net/ti-dp83867.h
 		for applicable values. Required only if interface type is
 		PHY_INTERFACE_MODE_RGMII_ID or PHY_INTERFACE_MODE_RGMII_TXID
-	- ti,fifo-depth - Transmitt FIFO depth- see dt-bindings/net/ti-dp83867.h
-		for applicable values
 
 Note: If the interface type is PHY_INTERFACE_MODE_RGMII the TX/RX clock delays
       will be left at their default values, as set by the PHY's pin strapping.
@@ -42,6 +40,14 @@ Optional property:
 				    Some MACs work with differential SGMII clock.
 				    See data manual for details.
 
+	- ti,fifo-depth - Transmitt FIFO depth- see dt-bindings/net/ti-dp83867.h
+		for applicable values (deprecated)
+
+	-tx-fifo-depth - As defined in the ethernet-controller.yaml.  Values for
+			 the depth can be found in dt-bindings/net/ti-dp83867.h
+	-rx-fifo-depth - As defined in the ethernet-controller.yaml.  Values for
+			 the depth can be found in dt-bindings/net/ti-dp83867.h
+
 Note: ti,min-output-impedance and ti,max-output-impedance are mutually
       exclusive. When both properties are present ti,max-output-impedance
       takes precedence.
@@ -55,7 +61,7 @@ Example:
 		reg = <0>;
 		ti,rx-internal-delay = <DP83867_RGMIIDCTL_2_25_NS>;
 		ti,tx-internal-delay = <DP83867_RGMIIDCTL_2_75_NS>;
-		ti,fifo-depth = <DP83867_PHYCR_FIFO_DEPTH_4_B_NIB>;
+		tx-fifo-depth = <DP83867_PHYCR_FIFO_DEPTH_4_B_NIB>;
 	};
 
 Datasheet can be found:
-- 
2.23.0

