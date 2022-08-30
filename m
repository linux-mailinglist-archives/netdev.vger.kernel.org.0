Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEAA5A67A6
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 17:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiH3PqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 11:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbiH3PqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 11:46:13 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D4F67CBC;
        Tue, 30 Aug 2022 08:46:09 -0700 (PDT)
Received: from jupiter.universe (dyndsl-091-096-062-005.ewe-ip-backbone.de [91.96.62.5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sre)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id E24906601D85;
        Tue, 30 Aug 2022 16:46:07 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1661874368;
        bh=1G+3bB/tW0uo95ySNz7kpnmQxHlFCdwniLi2dIfbO8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XVoWS72x7ccta7tvrHQgffDwStGPkois+sknq1dZA2PYlZAWM+3djuSM9+M62Hvtl
         OaEU0mLIeaaB8ZsmhQbOjaNiTwRb9Buy6mAO/zA8zj/mXtPNpLLOESeu0skPx84qVj
         35k88U6N47RKry6B+qFxdPmmRai91UZ8u4eVYQG3yvN2oxwJJvueZVjBn/6LBCLV5C
         CKJ7auZ21NPZfZKl7xFmHPg6Tg60rV3QIFa4L0hXvLqkG7o9H+bbhKOZwSLJdAsstN
         rgaq+NZ1yMMd9dG6Dj+B4sDzaLaIXV3syiS/XQjaH8WkbWR3eTUDGkGV0smn7eUmun
         6lc6kt7wqbTfg==
Received: by jupiter.universe (Postfix, from userid 1000)
        id 0F96C4805C2; Tue, 30 Aug 2022 17:46:06 +0200 (CEST)
From:   Sebastian Reichel <sebastian.reichel@collabora.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        kernel@collabora.com,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCHv3 2/2] dt-bindings: net: rockchip-dwmac: add rk3588 gmac compatible
Date:   Tue, 30 Aug 2022 17:45:59 +0200
Message-Id: <20220830154559.61506-3-sebastian.reichel@collabora.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830154559.61506-1-sebastian.reichel@collabora.com>
References: <20220830154559.61506-1-sebastian.reichel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add compatible string for RK3588 gmac, which is similar to the RK3568
one, but needs another syscon device for clock selection.

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
---
 Documentation/devicetree/bindings/net/rockchip-dwmac.yaml | 7 +++++++
 Documentation/devicetree/bindings/net/snps,dwmac.yaml     | 1 +
 2 files changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml b/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
index 083623c8d718..3c8c3a907181 100644
--- a/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
@@ -25,6 +25,7 @@ select:
           - rockchip,rk3368-gmac
           - rockchip,rk3399-gmac
           - rockchip,rk3568-gmac
+          - rockchip,rk3588-gmac
           - rockchip,rv1108-gmac
   required:
     - compatible
@@ -50,6 +51,7 @@ properties:
       - items:
           - enum:
               - rockchip,rk3568-gmac
+              - rockchip,rk3588-gmac
           - const: snps,dwmac-4.20a
 
   clocks:
@@ -81,6 +83,11 @@ properties:
     description: The phandle of the syscon node for the general register file.
     $ref: /schemas/types.yaml#/definitions/phandle
 
+  rockchip,php-grf:
+    description:
+      The phandle of the syscon node for the peripheral general register file.
+    $ref: /schemas/types.yaml#/definitions/phandle
+
   tx_delay:
     description: Delay value for TXD timing. Range value is 0~0x7F, 0x30 as default.
     $ref: /schemas/types.yaml#/definitions/uint32
diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 491597c02edf..2f909ffe2fe8 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -74,6 +74,7 @@ properties:
         - rockchip,rk3328-gmac
         - rockchip,rk3366-gmac
         - rockchip,rk3368-gmac
+        - rockchip,rk3588-gmac
         - rockchip,rk3399-gmac
         - rockchip,rv1108-gmac
         - snps,dwmac
-- 
2.35.1

