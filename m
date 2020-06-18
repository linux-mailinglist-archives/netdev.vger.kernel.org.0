Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C56EE1FEB99
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 08:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgFRGlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 02:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727937AbgFRGkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 02:40:49 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C09C06174E;
        Wed, 17 Jun 2020 23:40:48 -0700 (PDT)
Received: from p5b06d650.dip0.t-ipconnect.de ([91.6.214.80] helo=localhost.localdomain)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <kurt@linutronix.de>)
        id 1jloE9-0000xD-Gg; Thu, 18 Jun 2020 08:40:45 +0200
From:   Kurt Kanzenbach <kurt@linutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [RFC PATCH 9/9] dt-bindings: net: dsa: Add documentation for Hellcreek switches
Date:   Thu, 18 Jun 2020 08:40:29 +0200
Message-Id: <20200618064029.32168-10-kurt@linutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200618064029.32168-1-kurt@linutronix.de>
References: <20200618064029.32168-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add basic documentation and example.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 .../devicetree/bindings/net/dsa/hellcreek.txt | 72 +++++++++++++++++++
 1 file changed, 72 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/hellcreek.txt

diff --git a/Documentation/devicetree/bindings/net/dsa/hellcreek.txt b/Documentation/devicetree/bindings/net/dsa/hellcreek.txt
new file mode 100644
index 000000000000..9ea6494dc554
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/hellcreek.txt
@@ -0,0 +1,72 @@
+Hirschmann hellcreek switch driver
+==================================
+
+Required properties:
+
+- compatible:
+	Must be one of:
+	- "hirschmann,hellcreek"
+
+See Documentation/devicetree/bindings/net/dsa/dsa.txt for the list of standard
+DSA required and optional properties.
+
+Example
+-------
+
+Ethernet switch connected memory mapped to the host, CPU port wired to gmac0:
+
+soc {
+        switch0: switch@0xff240000 {
+                compatible = "hirschmann,hellcreek";
+                status = "okay";
+                reg = <0xff240000 0x1000   /* TSN base */
+                       0xff250000 0x1000>; /* PTP base */
+                dsa,member = <0 0>;
+
+                ports {
+                        #address-cells = <1>;
+                        #size-cells = <0>;
+
+                        port@0 {
+                                reg = <0>;
+                                label = "cpu";
+                                ethernet = <&gmac0>;
+                        };
+
+                        port@2 {
+                                reg = <2>;
+                                label = "lan0";
+                                phy-handle = <&phy1>;
+                        };
+
+                        port@3 {
+                                reg = <3>;
+                                label = "lan1";
+                                phy-handle = <&phy2>;
+                        };
+                };
+        };
+};
+
+&gmac0 {
+        status = "okay";
+        phy-mode = "mii";
+
+        fixed-link {
+                speed = <100>;
+                full-duplex;
+        };
+
+        mdio {
+                #address-cells = <1>;
+                #size-cells = <0>;
+                compatible = "snps,dwmac-mdio";
+
+                phy1: ethernet-phy@1 {
+                        reg = <1>;
+                };
+                phy2: ethernet-phy@2 {
+                        reg = <2>;
+                };
+        };
+};
-- 
2.20.1

