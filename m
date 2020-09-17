Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2351E26DDDD
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 16:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbgIQOPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 10:15:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727207AbgIQN5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 09:57:53 -0400
Received: from michel.telenet-ops.be (michel.telenet-ops.be [IPv6:2a02:1800:110:4::f00:18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00B60C061220
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 06:57:26 -0700 (PDT)
Received: from ramsan ([84.195.186.194])
        by michel.telenet-ops.be with bizsmtp
        id V1xD230034C55Sk061xDYE; Thu, 17 Sep 2020 15:57:22 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1kIuPQ-0001Ka-Vy; Thu, 17 Sep 2020 15:57:12 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1kIuPQ-0003HV-Ud; Thu, 17 Sep 2020 15:57:12 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Dan Murphy <dmurphy@ti.com>,
        Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Magnus Damm <magnus.damm@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH net-next v4 1/5] dt-bindings: net: ethernet-controller: Add internal delay properties
Date:   Thu, 17 Sep 2020 15:57:03 +0200
Message-Id: <20200917135707.12563-2-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200917135707.12563-1-geert+renesas@glider.be>
References: <20200917135707.12563-1-geert+renesas@glider.be>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Internal Receive and Transmit Clock Delays are a common setting for
RGMII capable devices.

While these delays are typically applied by the PHY, some MACs support
configuring internal clock delay settings, too.  Hence add standardized
properties to configure this.

This is the MAC counterpart of commit 9150069bf5fc0e86 ("dt-bindings:
net: Add tx and rx internal delays"), which applies to the PHY.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Rob Herring <robh@kernel.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v4:
  - Add Reviewed-by,

v3:
  - Add Reviewed-by,

v2:
  - New.
---
 .../bindings/net/ethernet-controller.yaml          | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index 1c4474036d46a9dc..e9bb386066540676 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -119,6 +119,13 @@ properties:
       and is useful for determining certain configuration settings
       such as flow control thresholds.
 
+  rx-internal-delay-ps:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description: |
+      RGMII Receive Clock Delay defined in pico seconds.
+      This is used for controllers that have configurable RX internal delays.
+      If this property is present then the MAC applies the RX delay.
+
   sfp:
     $ref: /schemas/types.yaml#definitions/phandle
     description:
@@ -130,6 +137,13 @@ properties:
       The size of the controller\'s transmit fifo in bytes. This
       is used for components that can have configurable fifo sizes.
 
+  tx-internal-delay-ps:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description: |
+      RGMII Transmit Clock Delay defined in pico seconds.
+      This is used for controllers that have configurable TX internal delays.
+      If this property is present then the MAC applies the TX delay.
+
   managed:
     description:
       Specifies the PHY management type. If auto is set and fixed-link
-- 
2.17.1

