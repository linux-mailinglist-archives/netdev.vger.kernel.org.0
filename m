Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31293309C1C
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 13:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbhAaMt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 07:49:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbhAaLA5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 06:00:57 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7045C061573;
        Sun, 31 Jan 2021 02:58:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=jvLgmGTn36fDIOLb0aqSfUlwPhs4FMUwc1fOqmM0Qt4=; b=o6vIBfXIx/eDdGibAooyuPkodY
        0zoaPHyq3oc+fMB1sZUJZIi7xkiWVpH3K50cGO5+Rx5tj7ThnTmXhncCXr8HSdsWxEEzdjwuJFedE
        IRmlAr8IhYf5RcpIIxsUr36Bv+Fo78e9q7VNg8+c07WmcIFCbG4L8A4GYhRrl5ggaJfvRJ4Dqc1dL
        GCD2eCDNEv8sFxXVf1EUnxjerS362Pdu2r5zj8flK5FF6RyGPOio0dvFBDZfHVi7X2YBPymWgrWk3
        moawFv31kgQR4M8cM3zXi3tG5qHRPYHx4ZOTQTFX6JdnGPnCDhKDAIkg6YmSwKvq3vW//5sR3djug
        qDwVQa5A==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:33846 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1l6AQp-0002LU-N2; Sun, 31 Jan 2021 10:58:15 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1l6AQp-00060t-En; Sun, 31 Jan 2021 10:58:15 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH] dt-bindings: ethernet-controller: fix fixed-link
 specification
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1l6AQp-00060t-En@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Sun, 31 Jan 2021 10:58:15 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The original fixed-link.txt allowed a pause property for fixed link.
This has been missed in the conversion to yaml format.

Fixes: 9d3de3c58347 ("dt-bindings: net: Add YAML schemas for the generic Ethernet options")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 .../devicetree/bindings/net/ethernet-controller.yaml         | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index fdf709817218..39147d33e8c7 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -206,6 +206,11 @@ title: Ethernet Controller Generic Binding
                 Indicates that full-duplex is used. When absent, half
                 duplex is assumed.
 
+            pause:
+              $ref: /schemas/types.yaml#definitions/flag
+              description:
+                Indicates that pause should be enabled.
+
             asym-pause:
               $ref: /schemas/types.yaml#definitions/flag
               description:
-- 
2.20.1

