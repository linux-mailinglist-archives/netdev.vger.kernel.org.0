Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 379DA557FCD
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 18:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbiFWQ3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 12:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232249AbiFWQ26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 12:28:58 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8868F3EA93;
        Thu, 23 Jun 2022 09:28:57 -0700 (PDT)
Received: from jupiter.universe (unknown [95.33.159.255])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: sre)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id AF31166017E4;
        Thu, 23 Jun 2022 17:28:55 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1656001736;
        bh=NR9TyHKc60OYnxwLzxpQ1c2wItafR5D/uWReeMDiZLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C4UNF7lZTqD5LepVh7lPXHlQ4Cg/MEBb0h35zYH+X8dGc8Eu0ai5PQMPD5IarZXf2
         e7h0C7YgJ4TWpOj/Za/hPe9A0p0X8iJGdbcD5X1quHJvT0PDTGWJQ7CVzXh5zjle+4
         p0ilh6svW6dAG/2XvlSuUcgpTSHIgSMb+nQNRD1qSksgEWCxSo94pTUHP9lYZIVT/4
         aTHqXJemhYdox00n8txpy56Q3zYYT2idzOwicN9pAHjQek1Zz/6BlLlTi9u/mIyC74
         aH6GFfmUNOh9oWw3igFheTNgflmESEipeFusus4ddL8mBHfKfB5g+6e1UNzhg7YPYo
         +qDY/tzxGJmBg==
Received: by jupiter.universe (Postfix, from userid 1000)
        id 4A59D480591; Thu, 23 Jun 2022 18:28:53 +0200 (CEST)
From:   Sebastian Reichel <sebastian.reichel@collabora.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        netdev@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        kernel@collabora.com
Subject: [PATCH 3/3] dt-bindings: net: rockchip-dwmac: add rk3588 gmac compatible
Date:   Thu, 23 Jun 2022 18:28:50 +0200
Message-Id: <20220623162850.245608-4-sebastian.reichel@collabora.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220623162850.245608-1-sebastian.reichel@collabora.com>
References: <20220623162850.245608-1-sebastian.reichel@collabora.com>
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

Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
---
 Documentation/devicetree/bindings/net/rockchip-dwmac.yaml | 6 ++++++
 Documentation/devicetree/bindings/net/snps,dwmac.yaml     | 1 +
 2 files changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml b/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
index 083623c8d718..c42f5a74a92e 100644
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
@@ -81,6 +83,10 @@ properties:
     description: The phandle of the syscon node for the general register file.
     $ref: /schemas/types.yaml#/definitions/phandle
 
+  rockchip,php_grf:
+    description: The phandle of the syscon node for the peripheral general register file.
+    $ref: /schemas/types.yaml#/definitions/phandle
+
   tx_delay:
     description: Delay value for TXD timing. Range value is 0~0x7F, 0x30 as default.
     $ref: /schemas/types.yaml#/definitions/uint32
diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 36c85eb3dc0d..b5aba399ca5d 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -72,6 +72,7 @@ properties:
         - rockchip,rk3328-gmac
         - rockchip,rk3366-gmac
         - rockchip,rk3368-gmac
+        - rockchip,rk3588-gmac
         - rockchip,rk3399-gmac
         - rockchip,rv1108-gmac
         - snps,dwmac
-- 
2.35.1

