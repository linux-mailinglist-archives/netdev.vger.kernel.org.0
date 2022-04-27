Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 272725124BB
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 23:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237479AbiD0Vrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 17:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234208AbiD0Vr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 17:47:29 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 595EC90CF7;
        Wed, 27 Apr 2022 14:44:17 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 3DA102224D;
        Wed, 27 Apr 2022 23:44:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1651095855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YO9EFQDucDo1VWldP4g0N6rBdXJCQA5jDizvOGknGSg=;
        b=JUUb83+Yyp3Y3KXHg8z1Wn8GMfDOK2Ualufpvo4Uju+P0uFoOXZ/3gx1e4ympLnck1RaTF
        FRLmbI4zDPmQCtJcLhWRDwUFB1R47IIOUabRRfTkR2OXzNBFevLh8f0YmAGuogdEfuUaGX
        HmZRo75j9KQho6ykTOU2WOmb+R5OQoQ=
From:   Michael Walle <michael@walle.cc>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v1 1/3] dt-bindings: net: micrel: add coma-mode-gpios property
Date:   Wed, 27 Apr 2022 23:44:04 +0200
Message-Id: <20220427214406.1348872-2-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220427214406.1348872-1-michael@walle.cc>
References: <20220427214406.1348872-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The LAN8814 has a coma mode pin which is used to put the PHY into
isolate and power-down mode. Usually strapped to be asserted by default.
A GPIO is then used to take the PHY out of this mode.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 Documentation/devicetree/bindings/net/micrel.txt | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/micrel.txt b/Documentation/devicetree/bindings/net/micrel.txt
index 8d157f0295a5..a9ed691ffb03 100644
--- a/Documentation/devicetree/bindings/net/micrel.txt
+++ b/Documentation/devicetree/bindings/net/micrel.txt
@@ -45,3 +45,12 @@ Optional properties:
 
 	In fiber mode, auto-negotiation is disabled and the PHY can only work in
 	100base-fx (full and half duplex) modes.
+
+ - coma-mode-gpios: If present the given gpio will be deasserted when the
+		    PHY is probed.
+
+	Some PHYs have a COMA mode input pin which puts the PHY into
+	isolate and power-down mode. On some boards this input is connected
+	to a GPIO of the SoC.
+
+	Supported on the LAN8814.
-- 
2.30.2

