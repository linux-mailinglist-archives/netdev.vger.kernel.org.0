Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC09225F8E
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 14:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729458AbgGTMuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 08:50:55 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:57562 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728508AbgGTMum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 08:50:42 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595249440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kulnhH+Wp4rDHvCAGfQEYy4bp3CPSW8DxLhT13DzSG8=;
        b=dc64ernlezMvJDAwK8mW6wWA+vCj45qSoyLT9B6Y0PCV772IwkeLtH+HQq1bjYGISxfs2a
        2aX0QT+LOw5FRj+SpR7+rSrA45JF+0aQByPCOYPs83qWfaAA0fvjOydyu6i/hD5TxphM31
        ngWfqu6LPskunKe065H62/N9Mo9F1m0tgQxtMT5AjARLoP4C6XQP4KtBMK1OQ/A9R4hPse
        M60A4UkwJ/TEUVCftPUCrKWYAPLQGTlwMHPR1f/7tEWhGgDarf1cAMGob740tl3AIp6wS+
        QmvdhdDDSgUuZ0rMj1h5QdQKOmB7e9iGX5rSEeIkPQntlmKhIdfcyOhtNUI8xg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595249440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kulnhH+Wp4rDHvCAGfQEYy4bp3CPSW8DxLhT13DzSG8=;
        b=eHHyHpMA5gl7o7yItOR2RwjP5eq1tadpR8WUnmbyLLm7MhdOd6n9X4eHx7FUR2aE8hgoVg
        vEVbrQVV/JYV2yDQ==
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v2 2/3] dt-bindings: net: dsa: Let dsa.txt refer to dsa.yaml
Date:   Mon, 20 Jul 2020 14:49:38 +0200
Message-Id: <20200720124939.4359-3-kurt@linutronix.de>
In-Reply-To: <20200720124939.4359-1-kurt@linutronix.de>
References: <20200720124939.4359-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DSA bindings have been converted to YAML. Therefore, the old text style
documentation should refer to that one.

The text file can be removed completely once all the existing DSA switch
bindings have been converted as well.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 .../devicetree/bindings/net/dsa/dsa.txt       | 255 +-----------------
 1 file changed, 1 insertion(+), 254 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.txt b/Documentation/devicetree/bindings/net/dsa/dsa.txt
index f66bb7ecdb82..bf7328aba330 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.txt
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.txt
@@ -1,257 +1,4 @@
 Distributed Switch Architecture Device Tree Bindings
 ----------------------------------------------------
 
-Switches are true Linux devices and can be probed by any means. Once
-probed, they register to the DSA framework, passing a node
-pointer. This node is expected to fulfil the following binding, and
-may contain additional properties as required by the device it is
-embedded within.
-
-Required properties:
-
-- ports		: A container for child nodes representing switch ports.
-
-Optional properties:
-
-- dsa,member	: A two element list indicates which DSA cluster, and position
-		  within the cluster a switch takes. <0 0> is cluster 0,
-		  switch 0. <0 1> is cluster 0, switch 1. <1 0> is cluster 1,
-		  switch 0. A switch not part of any cluster (single device
-		  hanging off a CPU port) must not specify this property
-
-The ports container has the following properties
-
-Required properties:
-
-- #address-cells	: Must be 1
-- #size-cells		: Must be 0
-
-Each port children node must have the following mandatory properties:
-- reg			: Describes the port address in the switch
-
-An uplink/downlink port between switches in the cluster has the following
-mandatory property:
-
-- link			: Should be a list of phandles to other switch's DSA
-			  port. This port is used as the outgoing port
-			  towards the phandle ports. The full routing
-			  information must be given, not just the one hop
-			  routes to neighbouring switches.
-
-A CPU port has the following mandatory property:
-
-- ethernet		: Should be a phandle to a valid Ethernet device node.
-                          This host device is what the switch port is
-			  connected to.
-
-A user port has the following optional property:
-
-- label			: Describes the label associated with this port, which
-                          will become the netdev name.
-
-Port child nodes may also contain the following optional standardised
-properties, described in binding documents:
-
-- phy-handle		: Phandle to a PHY on an MDIO bus. See
-			  Documentation/devicetree/bindings/net/ethernet.txt
-			  for details.
-
-- phy-mode		: See
-			  Documentation/devicetree/bindings/net/ethernet.txt
-			  for details.
-
-- fixed-link		: Fixed-link subnode describing a link to a non-MDIO
-			  managed entity. See
-			  Documentation/devicetree/bindings/net/fixed-link.txt
-			  for details.
-
-The MAC address will be determined using the optional properties
-defined in ethernet.txt.
-
-Example
-
-The following example shows three switches on three MDIO busses,
-linked into one DSA cluster.
-
-&mdio1 {
-	#address-cells = <1>;
-	#size-cells = <0>;
-
-	switch0: switch0@0 {
-		compatible = "marvell,mv88e6085";
-		reg = <0>;
-
-		dsa,member = <0 0>;
-
-		ports {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			port@0 {
-				reg = <0>;
-				label = "lan0";
-			};
-
-			port@1 {
-				reg = <1>;
-				label = "lan1";
-				local-mac-address = [00 00 00 00 00 00];
-			};
-
-			port@2 {
-				reg = <2>;
-				label = "lan2";
-			};
-
-			switch0port5: port@5 {
-				reg = <5>;
-				phy-mode = "rgmii-txid";
-				link = <&switch1port6
-					&switch2port9>;
-				fixed-link {
-					speed = <1000>;
-					full-duplex;
-				};
-			};
-
-			port@6 {
-				reg = <6>;
-				ethernet = <&fec1>;
-				fixed-link {
-					speed = <100>;
-					full-duplex;
-				};
-			};
-		};
-	};
-};
-
-&mdio2 {
-	#address-cells = <1>;
-	#size-cells = <0>;
-
-	switch1: switch1@0 {
-		compatible = "marvell,mv88e6085";
-		reg = <0>;
-
-		dsa,member = <0 1>;
-
-		ports {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			port@0 {
-				reg = <0>;
-				label = "lan3";
-				phy-handle = <&switch1phy0>;
-			};
-
-			port@1 {
-				reg = <1>;
-				label = "lan4";
-				phy-handle = <&switch1phy1>;
-			};
-
-			port@2 {
-				reg = <2>;
-				label = "lan5";
-				phy-handle = <&switch1phy2>;
-			};
-
-			switch1port5: port@5 {
-				reg = <5>;
-				link = <&switch2port9>;
-				phy-mode = "rgmii-txid";
-				fixed-link {
-					speed = <1000>;
-					full-duplex;
-				};
-			};
-
-			switch1port6: port@6 {
-				reg = <6>;
-				phy-mode = "rgmii-txid";
-				link = <&switch0port5>;
-				fixed-link {
-					speed = <1000>;
-					full-duplex;
-				};
-			};
-		};
-		mdio-bus {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			switch1phy0: switch1phy0@0 {
-				reg = <0>;
-			};
-			switch1phy1: switch1phy0@1 {
-				reg = <1>;
-			};
-			switch1phy2: switch1phy0@2 {
-				reg = <2>;
-			};
-		};
-	 };
-};
-
-&mdio4 {
-	#address-cells = <1>;
-	#size-cells = <0>;
-
-	switch2: switch2@0 {
-		compatible = "marvell,mv88e6085";
-		reg = <0>;
-
-		dsa,member = <0 2>;
-
-		ports {
-			#address-cells = <1>;
-			#size-cells = <0>;
-			port@0 {
-				reg = <0>;
-				label = "lan6";
-			};
-
-			port@1 {
-				reg = <1>;
-				label = "lan7";
-			};
-
-			port@2 {
-				reg = <2>;
-				label = "lan8";
-			};
-
-			port@3 {
-				reg = <3>;
-				label = "optical3";
-				fixed-link {
-					speed = <1000>;
-					full-duplex;
-					link-gpios = <&gpio6 2
-					      GPIO_ACTIVE_HIGH>;
-				};
-			};
-
-			port@4 {
-				reg = <4>;
-				label = "optical4";
-				fixed-link {
-					speed = <1000>;
-					full-duplex;
-					link-gpios = <&gpio6 3
-					      GPIO_ACTIVE_HIGH>;
-				};
-			};
-
-			switch2port9: port@9 {
-				reg = <9>;
-				phy-mode = "rgmii-txid";
-				link = <&switch1port5
-					&switch0port5>;
-				fixed-link {
-					speed = <1000>;
-					full-duplex;
-				};
-			};
-		};
-	};
-};
+See Documentation/devicetree/bindings/net/dsa/dsa.yaml for the documenation.
-- 
2.20.1

