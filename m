Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAEF3FE619
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 20:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbfKOT4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 14:56:55 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:49962 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfKOT4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 14:56:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7naFpllFQ3+7RciL2Lvr1sFHQDInwMFYUeKYOibh0+8=; b=dfdTwFyvfPdEJhR6Dd2wSmgMOr
        gt7jLFDHlTV2+2wxNKmAHGMrJ9e7KTUAb7ZGjShQ+eS49rqJ+JIsimh7RBDD3yv2+rzE4b9nRlwmu
        +6z3xUy/WmIaBbz646yK4r25CbnWdRKmWIGHqS5zT7hOtSYysw6oKus7UNDCrpePA2r6AgoiVZL5O
        ouFksnoBK6WuUgms+ZCUikDrJnZ+ECdVaph/GCep+SFs/SOUoHsKKBL8/xLULGwih/siBrcjCIva+
        Hp798CheNebAff9rCm8rJ6ntF+4sU9+lDoRJXZGHGSHqHwl7Gm6dzMCtZd8Bq/3iE4HAEqz/r4zax
        Y25AU02A==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:33160 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iVhi2-00036l-QY; Fri, 15 Nov 2019 19:56:46 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iVhi2-0007au-2S; Fri, 15 Nov 2019 19:56:46 +0000
In-Reply-To: <20191115195339.GR25745@shell.armlinux.org.uk>
References: <20191115195339.GR25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org
Subject: [PATCH net-next v2 1/3] dt-bindings: net: add ethernet controller and
 phy sfp property
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iVhi2-0007au-2S@rmk-PC.armlinux.org.uk>
Date:   Fri, 15 Nov 2019 19:56:46 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the missing sfp property for ethernet controllers (which
has existed for some time) which is being extended to ethernet PHYs.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 .../devicetree/bindings/net/ethernet-controller.yaml         | 5 +++++
 Documentation/devicetree/bindings/net/ethernet-phy.yaml      | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index 0e7c31794ae6..ac471b60ed6a 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -121,6 +121,11 @@ title: Ethernet Controller Generic Binding
       and is useful for determining certain configuration settings
       such as flow control thresholds.
 
+  sfp:
+    $ref: /schemas/types.yaml#definitions/phandle
+    description:
+      Specifies a reference to a node representing a SFP cage.
+
   tx-fifo-depth:
     $ref: /schemas/types.yaml#definitions/uint32
     description:
diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
index f70f18ff821f..8927941c74bb 100644
--- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
@@ -153,6 +153,11 @@ title: Ethernet PHY Generic Binding
       Delay after the reset was deasserted in microseconds. If
       this property is missing the delay will be skipped.
 
+  sfp:
+    $ref: /schemas/types.yaml#definitions/phandle
+    description:
+      Specifies a reference to a node representing a SFP cage.
+
 required:
   - reg
 
-- 
2.20.1

