Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA28F22C9A
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 09:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730878AbfETHHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 03:07:32 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:40143 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730742AbfETHH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 03:07:26 -0400
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1hScOE-0000N3-JE; Mon, 20 May 2019 09:07:18 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1hScOD-0006Aj-IJ; Mon, 20 May 2019 09:07:17 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, John Crispin <john@phrozen.org>,
        Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Chuanhong Guo <gch981213@gmail.com>,
        info@freifunk-bad-gandersheim.net
Subject: [PATCH v5 1/3] dt-bindings: net: add qca,ar71xx.txt documentation
Date:   Mon, 20 May 2019 09:07:14 +0200
Message-Id: <20190520070716.23668-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190520070716.23668-1-o.rempel@pengutronix.de>
References: <20190520070716.23668-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add binding documentation for Atheros/QCA networking IP core used
in many routers.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 .../devicetree/bindings/net/qca,ar71xx.txt    | 45 +++++++++++++++++++
 1 file changed, 45 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/qca,ar71xx.txt

diff --git a/Documentation/devicetree/bindings/net/qca,ar71xx.txt b/Documentation/devicetree/bindings/net/qca,ar71xx.txt
new file mode 100644
index 000000000000..2a33e71ba72b
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/qca,ar71xx.txt
@@ -0,0 +1,45 @@
+Required properties:
+- compatible:	Should be "qca,<soc>-eth". Currently support compatibles are:
+		qca,ar7100-eth - Atheros AR7100
+		qca,ar7240-eth - Atheros AR7240
+		qca,ar7241-eth - Atheros AR7241
+		qca,ar7242-eth - Atheros AR7242
+		qca,ar9130-eth - Atheros AR9130
+		qca,ar9330-eth - Atheros AR9330
+		qca,ar9340-eth - Atheros AR9340
+		qca,qca9530-eth - Qualcomm Atheros QCA9530
+		qca,qca9550-eth - Qualcomm Atheros QCA9550
+		qca,qca9560-eth - Qualcomm Atheros QCA9560
+
+- reg : Address and length of the register set for the device
+- interrupts : Should contain eth interrupt
+- phy-mode : See ethernet.txt file in the same directory
+- clocks: the clock used by the core
+- clock-names: the names of the clock listed in the clocks property. These are
+	"eth" and "mdio".
+- resets: Should contain phandles to the reset signals
+- reset-names: Should contain the names of reset signal listed in the resets
+		property. These are "mac" and "mdio"
+
+Optional properties:
+- phy-handle : phandle to the PHY device connected to this device.
+- fixed-link : Assume a fixed link. See fixed-link.txt in the same directory.
+  Use instead of phy-handle.
+
+Optional subnodes:
+- mdio : specifies the mdio bus, used as a container for phy nodes
+  according to phy.txt in the same directory
+
+Example:
+
+ethernet@1a000000 {
+	compatible = "qca,ar9330-eth";
+	reg = <0x1a000000 0x200>;
+	interrupts = <5>;
+	resets = <&rst 13>, <&rst 23>;
+	reset-names = "mac", "mdio";
+	clocks = <&pll ATH79_CLK_AHB>, <&pll ATH79_CLK_MDIO>;
+	clock-names = "eth", "mdio";
+
+	phy-mode = "gmii";
+};
-- 
2.20.1

