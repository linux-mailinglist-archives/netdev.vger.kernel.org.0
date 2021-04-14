Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D86AD35F79A
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 17:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352194AbhDNP1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 11:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352136AbhDNP1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 11:27:30 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E1C8C061574;
        Wed, 14 Apr 2021 08:27:08 -0700 (PDT)
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 7BD1522256;
        Wed, 14 Apr 2021 17:27:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1618414026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ljBbstorYR1PhEMFBo4o7Tzx1N/BNduPatEctwY+WE8=;
        b=NEk7r0PK7md8vHykdrqqzaew64NqU5j3QhiLu867AIqJk0Q1cGlwOnSh4Re41gU7xw+5c1
        WRbzirP7mFv8MwV7mrKxIhEgO6NF5vZZeWQJYD4bP3yf7eaqoCliMF0w8hW3Od5IXsHb0r
        Mvgm34J31vPmxWuWk4+uDRa7/L7ajMc=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Frank Rowand <frowand.list@gmail.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 1/3] dt-bindings: net: add nvmem-mac-address-offset property
Date:   Wed, 14 Apr 2021 17:26:55 +0200
Message-Id: <20210414152657.12097-2-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210414152657.12097-1-michael@walle.cc>
References: <20210414152657.12097-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is already possible to read the MAC address via a NVMEM provider. But
there are boards, esp. with many ports, which only have a base MAC
address stored. Thus we need to have a way to provide an offset per
network device.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 .../devicetree/bindings/net/ethernet-controller.yaml        | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index e8f04687a3e0..1a8517b0e445 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -52,6 +52,12 @@ properties:
   nvmem-cell-names:
     const: mac-address
 
+  nvmem-mac-address-offset:
+    maxItems: 1
+    description:
+      Specifies an offset which will be added to the MAC address when
+      fetched from a nvmem cell.
+
   phy-connection-type:
     description:
       Specifies interface type between the Ethernet device and a physical
-- 
2.20.1

