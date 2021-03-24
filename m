Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2AF93479F7
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 14:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235714AbhCXNwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 09:52:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:50514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235459AbhCXNwX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 09:52:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8096E61A01;
        Wed, 24 Mar 2021 13:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616593943;
        bh=cHOHMXVQ+yn3s7ZWXL7fRhJN7XJst2LEeIiATt8XCc8=;
        h=From:To:Cc:Subject:Date:From;
        b=X1I/uyBrMwFF8ZbyYK5TzANtHVt+2KVbbCzAihjbpJvcprSe47vwn6oUDnClOzpEq
         /lTwZL3iompfsgUcWXQ63eNVJ5HICxe/MHMIi02fsPh1DcFCZAJgH0BxCtNiwvrJiU
         CjxsEiIh1ZEMFj0QlUS5WUBdyeXuWslnCYFF1JHZlzSvcSNk8o55vPcFodmaTINsVA
         WZMPHu7EN9mldxabdCcbT0R9ZaL+y+CBaTMBk56FX2agJtuJJj1l1j4xyBkWWFZXEi
         wg7GSpYDkNOWO3FDgBWCgrlh8jPG62rECHHwjcdQiplBmpXBz376qNhutXeva9nSIA
         GCBC5uCoyWLwQ==
From:   Dinh Nguyen <dinguyen@kernel.org>
To:     davem@davemloft.net
Cc:     dinguyen@kernel.org, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: net: micrel-ksz90x1.txt: correct documentation
Date:   Wed, 24 Mar 2021 08:52:19 -0500
Message-Id: <20210324135219.2951959-1-dinguyen@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Correct the Micrel phy documentation for the ksz9021 and ksz9031 phys
for how the phy skews are set.

Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
---
 .../bindings/net/micrel-ksz90x1.txt           | 96 ++++++++++++++++++-
 1 file changed, 94 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/micrel-ksz90x1.txt b/Documentation/devicetree/bindings/net/micrel-ksz90x1.txt
index b921731cd970..df9e844dd6bc 100644
--- a/Documentation/devicetree/bindings/net/micrel-ksz90x1.txt
+++ b/Documentation/devicetree/bindings/net/micrel-ksz90x1.txt
@@ -65,6 +65,71 @@ KSZ9031:
   step is 60ps. The default value is the neutral setting, so setting
   rxc-skew-ps=<0> actually results in -900 picoseconds adjustment.
 
+  The KSZ9031 hardware supports a range of skew values from negative to
+  positive, where the specific range is property dependent. All values
+  specified in the devicetree are offset by the minimum value so they
+  can be represented as positive integers in the devicetree since it's
+  difficult to represent a negative number in the devictree.
+
+  The following 5-bit values table apply to rxc-skew-ps and txc-skew-ps.
+
+  Pad Skew Value	Delay (ps)	Devicetree Value
+  ------------------------------------------------------
+  0_0000		-900ps		0
+  0_0001		-840ps		60
+  0_0010		-780ps		120
+  0_0011		-720ps		180
+  0_0100		-660ps		240
+  0_0101		-600ps		300
+  0_0110		-540ps		360
+  0_0111		-480ps		420
+  0_1000		-420ps		480
+  0_1001		-360ps		540
+  0_1010		-300ps		600
+  0_1011		-240ps		660
+  0_1100		-180ps		720
+  0_1101		-120ps		780
+  0_1110		-60ps		840
+  0_1111		0ps		900
+  1_0000		60ps		960
+  1_0001		120ps		1020
+  1_0010		180ps		1080
+  1_0011		240ps		1140
+  1_0100		300ps		1200
+  1_0101		360ps		1260
+  1_0110		420ps		1320
+  1_0111		480ps		1380
+  1_1000		540ps		1440
+  1_1001		600ps		1500
+  1_1010		660ps		1560
+  1_1011		720ps		1620
+  1_1100		780ps		1680
+  1_1101		840ps		1740
+  1_1110		900ps		1800
+  1_1111		960ps		1860
+
+  The following 4-bit values table apply to the txdX-skew-ps, rxdX-skew-ps
+  data pads, and the rxdv-skew-ps, txen-skew-ps control pads.
+
+  Pad Skew Value	Delay (ps)	Devicetree Value
+  ------------------------------------------------------
+  0000			-420ps		0
+  0001			-360ps		60
+  0010			-300ps		120
+  0011			-240ps		180
+  0100			-180ps		240
+  0101			-120ps		300
+  0110			-60ps		360
+  0111			0ps		420
+  1000			60ps		480
+  1001			120ps		540
+  1010			180ps		600
+  1011			240ps		660
+  1100			300ps		720
+  1101			360ps		780
+  1110			420ps		840
+  1111			480ps		900
+
   Optional properties:
 
     Maximum value of 1860, default value 900:
@@ -120,11 +185,21 @@ KSZ9131:
 
 Examples:
 
+	/* Attach to an Ethernet device with autodetected PHY */
+	&enet {
+		rxc-skew-ps = <1800>;
+		rxdv-skew-ps = <0>;
+		txc-skew-ps = <1800>;
+		txen-skew-ps = <0>;
+		status = "okay";
+	};
+
+	/* Attach to an explicitly-specified PHY */
 	mdio {
 		phy0: ethernet-phy@0 {
-			rxc-skew-ps = <3000>;
+			rxc-skew-ps = <1800>;
 			rxdv-skew-ps = <0>;
-			txc-skew-ps = <3000>;
+			txc-skew-ps = <1800>;
 			txen-skew-ps = <0>;
 			reg = <0>;
 		};
@@ -133,3 +208,20 @@ Examples:
 		phy = <&phy0>;
 		phy-mode = "rgmii-id";
 	};
+
+References
+
+  Micrel ksz9021rl/rn Data Sheet, Revision 1.2. Dated 2/13/2014.
+  http://www.micrel.com/_PDF/Ethernet/datasheets/ksz9021rl-rn_ds.pdf
+
+  Micrel ksz9031rnx Data Sheet, Revision 2.1. Dated 11/20/2014.
+  http://www.micrel.com/_PDF/Ethernet/datasheets/KSZ9031RNX.pdf
+
+Notes:
+
+  Note that a previous version of the Micrel ksz9021rl/rn Data Sheet
+  was missing extended register 106 (transmit data pad skews), and
+  incorrectly specified the ps per step as 200ps/step instead of
+  120ps/step. The latest update to this document reflects the latest
+  revision of the Micrel specification even though usage in the kernel
+  still reflects that incorrect document.
-- 
2.25.1

