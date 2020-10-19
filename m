Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D57E292CD4
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 19:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727663AbgJSRb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 13:31:27 -0400
Received: from mailout06.rmx.de ([94.199.90.92]:34599 "EHLO mailout06.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726354AbgJSRb1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 13:31:27 -0400
X-Greylist: delayed 315 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Oct 2020 13:31:25 EDT
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout06.rmx.de (Postfix) with ESMTPS id 4CFP1k0xchz9tny;
        Mon, 19 Oct 2020 19:31:22 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4CFP0B75hxz2xKS;
        Mon, 19 Oct 2020 19:30:02 +0200 (CEST)
Received: from N95HX1G2.wgnetz.xx (192.168.54.91) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Mon, 19 Oct
 2020 19:27:03 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
CC:     Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        "Microchip Linux Driver Support" <UNGLinuxDriver@microchip.com>,
        Christian Eggers <ceggers@arri.de>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH net-next 4/9] dt-bindings: net: dsa: microchip,ksz: add interrupt property
Date:   Mon, 19 Oct 2020 19:24:30 +0200
Message-ID: <20201019172435.4416-5-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201019172435.4416-1-ceggers@arri.de>
References: <20201019172435.4416-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.91]
X-RMX-ID: 20201019-193007-4CFP0B75hxz2xKS-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The devices have an optional interrupt line.

Signed-off-by: Christian Eggers <ceggers@arri.de>
---
 .../devicetree/bindings/net/dsa/microchip,ksz.yaml        | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
index f93c3bdd0b83..be927a3a370b 100644
--- a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
@@ -32,6 +32,11 @@ properties:
       Should be a gpio specifier for a reset line.
     maxItems: 1
 
+  interrupts:
+    description:
+      Interrupt specifier for the INTRP_N line from the device.
+    maxItems: 1
+
   microchip,synclko-125:
     $ref: /schemas/types.yaml#/definitions/flag
     description:
@@ -44,6 +49,7 @@ required:
 examples:
   - |
     #include <dt-bindings/gpio/gpio.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
 
     // Ethernet switch connected via SPI to the host, CPU port wired to eth0:
     eth0 {
@@ -65,6 +71,8 @@ examples:
             compatible = "microchip,ksz9477";
             reg = <0>;
             reset-gpios = <&gpio5 0 GPIO_ACTIVE_LOW>;
+            interrupt-parent = <&gpio5>;
+            interrupts = <1 IRQ_TYPE_LEVEL_LOW>;  /* INTRP_N line */
 
             spi-max-frequency = <44000000>;
             spi-cpha;
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

