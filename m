Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8F12F5F2E
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 11:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728759AbhANKqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 05:46:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726503AbhANKqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 05:46:43 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27C95C061573;
        Thu, 14 Jan 2021 02:45:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Wk5/sb/fL2MyxV1+Kkce07R78QjZ6vTFi28curroww8=; b=M9PFO+rSeod13g7IvIUr5eS4rh
        Rcc0fMwYaD9KSx6NDETc9YyknTEDkZiTb7nI2zzg721AYxEohJcUaDrKyjVLVQWxcTyfn6/F8MmGj
        1JUE6rQOjJlgBypxotPYpvXqwSsZk+HP1Z4MSBTFsGXYngGTdu8yLHcnm6Qg0dHqn7Q8fDK4XXtI8
        g338BXSKsjbkEFlMEKMtBKsZrxeMbHShN37+gBKRMsjikY+/mBKkJQRgDk1Yy4cRw1u04ctOdazzS
        s+JxixpI24kzeY/XLZcnBXUA4GTYUB1qefdkeZ2RW1juW+chkfz3xFL0OeMHZ/Ax81hzG06Kl76dH
        /J14EsEQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:55644 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1l008O-0002KM-So; Thu, 14 Jan 2021 10:45:44 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1l008O-0004tG-MA; Thu, 14 Jan 2021 10:45:44 +0000
In-Reply-To: <20210114104455.GP1551@shell.armlinux.org.uk>
References: <20210114104455.GP1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Jon Nettleton <jon@solid-run.com>
Subject: [PATCH net-next 1/2] dt: ar803x: document SmartEEE properties
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1l008O-0004tG-MA@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 14 Jan 2021 10:45:44 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The SmartEEE feature of Atheros AR803x PHYs can cause the link to
bounce. Add DT properties to allow SmartEEE to be disabled, and to
allow the Tw parameters for 100M and 1G links to be configured.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 .../devicetree/bindings/net/qca,ar803x.yaml      | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/qca,ar803x.yaml b/Documentation/devicetree/bindings/net/qca,ar803x.yaml
index 64b3357ade8a..b3d4013b7ca6 100644
--- a/Documentation/devicetree/bindings/net/qca,ar803x.yaml
+++ b/Documentation/devicetree/bindings/net/qca,ar803x.yaml
@@ -28,6 +28,10 @@ description: |
     $ref: /schemas/types.yaml#/definitions/uint32
     enum: [0, 1, 2]
 
+  qca,disable-smarteee:
+    description: Disable Atheros SmartEEE feature.
+    type: boolean
+
   qca,keep-pll-enabled:
     description: |
       If set, keep the PLL enabled even if there is no link. Useful if you
@@ -36,6 +40,18 @@ description: |
       Only supported on the AR8031.
     type: boolean
 
+  qca,smarteee-tw-us-100m:
+    description: EEE Tw parameter for 100M links.
+    $ref: /schemas/types.yaml#/definitions/uint32
+    minimum: 1
+    maximum: 255
+
+  qca,smarteee-tw-us-1g:
+    description: EEE Tw parameter for gigabit links.
+    $ref: /schemas/types.yaml#/definitions/uint32
+    minimum: 1
+    maximum: 255
+
   vddio-supply:
     description: |
       RGMII I/O voltage regulator (see regulator/regulator.yaml).
-- 
2.20.1

