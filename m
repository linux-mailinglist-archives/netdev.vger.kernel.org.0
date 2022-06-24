Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34692559C72
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 16:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233205AbiFXOnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 10:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233221AbiFXOl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 10:41:56 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE1767E7C;
        Fri, 24 Jun 2022 07:41:53 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 2302BE000B;
        Fri, 24 Jun 2022 14:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1656081712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MRhI3o9vUV9HJ/akGG/sCFg0WByQ0Yk8Z88IwMeWHwE=;
        b=LszXZicJAiBCHt9/JAja5rir+52fZo1vXbIWrM7+P92fDGbiljLyGdFkf1uEBRZu4Zoi/V
        CyIBXwvvZd3GFACoF3OqAFgPpT32AT9C+PcSYWr3MkEA11Hs4gmcEBw+0dX3B05WHE3FCA
        OCV58WMfhXwSO8fWLSYHAG8mnK0uVtuR31J4nxqgqDOKeVJmI6OOVi3Fl9d09xwzwgrAGQ
        qZdy/vanNvGWjvLr2VPaIl3FrGZqKzbFxSJTVYqWAHg5StSPFuYs78mwgluQRG+v1WAiS6
        ecF+Ah9sZB46iqv5jOnkWv2mQ9CdJ8Fa77MCSALn6ZIW9iBolLaSTZD6wpQu4g==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next v9 10/16] dt-bindings: net: snps,dwmac: add "power-domains" property
Date:   Fri, 24 Jun 2022 16:39:55 +0200
Message-Id: <20220624144001.95518-11-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220624144001.95518-1-clement.leger@bootlin.com>
References: <20220624144001.95518-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the stmmac driver already uses pm_runtime*() functions, describe
"power-domains" property in the binding.

Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Clément Léger <clement.leger@bootlin.com>
Acked-by: Rob Herring <robh@kernel.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/devicetree/bindings/net/snps,dwmac.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 36c85eb3dc0d..09f97fb5596d 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -135,6 +135,9 @@ properties:
   reset-names:
     const: stmmaceth
 
+  power-domains:
+    maxItems: 1
+
   mac-mode:
     $ref: ethernet-controller.yaml#/properties/phy-connection-type
     description:
-- 
2.36.1

