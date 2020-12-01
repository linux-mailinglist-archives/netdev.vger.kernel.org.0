Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFF02CA7D2
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 17:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392115AbgLAQLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 11:11:01 -0500
Received: from mailout11.rmx.de ([94.199.88.76]:54355 "EHLO mailout11.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392108AbgLAQLB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 11:11:01 -0500
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout11.rmx.de (Postfix) with ESMTPS id 4ClnBJ0VKBz40kQ;
        Tue,  1 Dec 2020 17:10:16 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4Cln8l17gzz2xCD;
        Tue,  1 Dec 2020 17:08:55 +0100 (CET)
Received: from N95HX1G2.wgnetz.xx (192.168.54.19) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Tue, 1 Dec
 2020 17:07:30 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        "Rob Herring" <robh+dt@kernel.org>
CC:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Christian Eggers <ceggers@arri.de>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v4 2/9] dt-bindings: net: dsa: microchip,ksz: add interrupt property
Date:   Tue, 1 Dec 2020 17:06:04 +0100
Message-ID: <20201201160611.22129-3-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201201160611.22129-1-ceggers@arri.de>
References: <20201201160611.22129-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.19]
X-RMX-ID: 20201201-170859-4Cln8l17gzz2xCD-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The devices have an optional interrupt line.

Signed-off-by: Christian Eggers <ceggers@arri.de>
---
 .../devicetree/bindings/net/dsa/microchip,ksz.yaml         | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
index 9f7d131bbcef..c3235110156a 100644
--- a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
@@ -35,6 +35,11 @@ properties:
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
@@ -49,6 +54,7 @@ unevaluatedProperties: false
 examples:
   - |
     #include <dt-bindings/gpio/gpio.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
 
     // Ethernet switch connected via SPI to the host, CPU port wired to eth0:
     eth0 {
@@ -70,6 +76,7 @@ examples:
             compatible = "microchip,ksz9477";
             reg = <0>;
             reset-gpios = <&gpio5 0 GPIO_ACTIVE_LOW>;
+            interrupts-extended = <&gpio5 1 IRQ_TYPE_LEVEL_LOW>;  /* INTRP_N line */
 
             spi-max-frequency = <44000000>;
 
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

