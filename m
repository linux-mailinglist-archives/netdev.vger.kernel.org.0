Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 111A55852B7
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 17:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237660AbiG2PeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 11:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237632AbiG2PeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 11:34:09 -0400
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [IPv6:2001:4b98:dc4:8::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F806FA0C;
        Fri, 29 Jul 2022 08:34:07 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E4B50240007;
        Fri, 29 Jul 2022 15:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1659108846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b1+fH/dZ1tnR5QXn2BQ9vetfDWKD27lvivWptBDwiIg=;
        b=eXsuuKW5dWl/It+qNLgrbCYZr8kgBHrU9Y4r8cti0Xf4Rp4w0/eJy9CXe/U42jZgpfTtDg
        9udPUjuGGXDdeLIgqPVcRdTLqwbJ7ZUsgWQIWUWH3W54I75nUkLRg7DDio09SF0CYPRcFB
        atI7haYwyn8SfbySHmS0e3kTrkMTMud3nExSYtmPlflzcwPrRfszjgtnb0+zEvDysoGLBu
        HN6MjbDFuT2j2TiBH1obflG63WWb9uodW1SiztuO+/w8UUXkFnZW2mNkbiC6zqIo2A+uCf
        QFHfD+OjRFkYWx0mXMT4IHjHcv19jc6RUOSz737txYb0RPadWFuiUjmM10jUZg==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Richard Cochran <richardcochran@gmail.com>,
        Horatiu.Vultur@microchip.com, Allan.Nielsen@microchip.com,
        UNGLinuxDriver@microchip.com, Rob Herring <robh@kernel.org>
Subject: [PATCH net-next v3 2/4] dt-bindings: net: ethernet-controller: add QUSGMII mode
Date:   Fri, 29 Jul 2022 17:33:54 +0200
Message-Id: <20220729153356.581444-3-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220729153356.581444-1-maxime.chevallier@bootlin.com>
References: <20220729153356.581444-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new QUSGMII mode, standing for "Quad Universal Serial Gigabit
Media Independent Interface", a derivative of USGMII which, similarly to
QSGMII, allows to multiplex 4 1Gbps links to a Quad-PHY.

The main difference with QSGMII is that QUSGMII can include an extension
instead of the standard 7bytes ethernet preamble, allowing to convey
arbitrary data such as Timestamps.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Acked-by: Rob Herring <robh@kernel.org>
---
V1->V2 : Added Rob's acked-by
V2->V3 : No changes

 Documentation/devicetree/bindings/net/ethernet-controller.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index c138a1022879..4b3c590fcebf 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -67,6 +67,7 @@ properties:
       - gmii
       - sgmii
       - qsgmii
+      - qusgmii
       - tbi
       - rev-mii
       - rmii
-- 
2.37.1

