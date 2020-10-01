Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6046C27FCE5
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 12:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731975AbgJAKK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 06:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731929AbgJAKKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 06:10:22 -0400
Received: from albert.telenet-ops.be (albert.telenet-ops.be [IPv6:2a02:1800:110:4::f00:1a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 524C2C0613AB
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 03:10:21 -0700 (PDT)
Received: from ramsan ([84.195.186.194])
        by albert.telenet-ops.be with bizsmtp
        id aaAA230064C55Sk06aAABl; Thu, 01 Oct 2020 12:10:19 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1kNvXN-0001MV-UK; Thu, 01 Oct 2020 12:10:09 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1kNvXN-0003kY-U9; Thu, 01 Oct 2020 12:10:09 +0200
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
Subject: [PATCH net-next v4 resend 1/5] dt-bindings: net: ethernet-controller: Add internal delay properties
Date:   Thu,  1 Oct 2020 12:10:04 +0200
Message-Id: <20201001101008.14365-2-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201001101008.14365-1-geert+renesas@glider.be>
References: <20201001101008.14365-1-geert+renesas@glider.be>
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

