Return-Path: <netdev+bounces-2534-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2C1C70264B
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 09:45:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 753C4280EC5
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 07:45:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C63388474;
	Mon, 15 May 2023 07:45:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83628469
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 07:45:31 +0000 (UTC)
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78321E59
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 00:45:29 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-96652cb7673so1481952466b.0
        for <netdev@vger.kernel.org>; Mon, 15 May 2023 00:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684136728; x=1686728728;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UttESFrrEvMiKCOSwouud9SxE7+ngY8bUQ++ZBjcYWc=;
        b=yxob4yxIb4Bg201PdiV7Z3bXOEbeK3d0tu/MOIMdAWdEUFoasKRTU9/SOZajKCOYYX
         xYDF1Y2FwdYatQGEsYdo1y0oYKLEAGg3YFF5YjqYAdZSY42KhkOQAibJmOAbJH7Ix60H
         Qpzt4sAbZyJkWQONK7RkcZKcM3cFjAoBpGF+uIZTmnwWyfMLaBASahRtW4D+zb/dh+Yh
         qLZZJNttxlMs6VfjFD0ji6JjL9QpX98LaOO7SvC1toCU6l5W5j1rsfJ9Gh6iS1EaToWk
         s0oZ6I2/2Qob9ejoYzm0zqIPsdheXhIFIYAKHoWjXgUUZDnJpUuhDgXMZey8wWVLS31O
         +uGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684136728; x=1686728728;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UttESFrrEvMiKCOSwouud9SxE7+ngY8bUQ++ZBjcYWc=;
        b=bh3c1lbWugospYntCzU+lWYcr7E2RcxFSV+j800VRhEvuYg4/2xh66D85NKib6ijbZ
         WH5kBwfhTln0+g7BmFbd3H0DZawG2vrD4pnBFsCYp6mcz6V64748hiB4PIYwy6jrgfWA
         ckaXnknOOfygkkdoPe5nuh0mmVsI+ob1aKCJKQ/vEfyXRlIOLgGsLHgiLk/FznFKnv7S
         p8ALF+sEiWk+otjwWWGezwaqvsE8VX4kLqncniyBgsMRQyuDtrycqHziKAwL0mljvsph
         mXDdDoCf+mXNJckbu0TbRK1o15aOrMwSThYP4hYWYZV0ZW3ezf5EcAUkMxBn1qhkAEmN
         XSSA==
X-Gm-Message-State: AC+VfDw/t742bwc41Y5d/h2d6vYZMyqUf2FPkPmYhsUMWcpI+UvLp4hC
	QwdjWsdgbUO4NHaSOqRfgUmCiA==
X-Google-Smtp-Source: ACHHUZ4YIDCunPW0x2OethflXGWsooFhVmk1Dpl8XCOnCvTtegAd8A3kDg9WRT19l8ogMoVhx4oqCg==
X-Received: by 2002:a17:907:74c:b0:966:265d:edc7 with SMTP id xc12-20020a170907074c00b00966265dedc7mr25335288ejb.69.1684136727800;
        Mon, 15 May 2023 00:45:27 -0700 (PDT)
Received: from krzk-bin.. ([2a02:810d:15c0:828:6470:25b8:7c2d:1992])
        by smtp.gmail.com with ESMTPSA id gv28-20020a1709072bdc00b00965cfc209d5sm9163515ejc.8.2023.05.15.00.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 May 2023 00:45:27 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To: Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	netdev@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH v5] dt-bindings: net: nxp,sja1105: document spi-cpol/cpha
Date: Mon, 15 May 2023 09:45:25 +0200
Message-Id: <20230515074525.53592-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Some boards use SJA1105 Ethernet Switch with SPI CPHA, while ones with
SJA1110 use SPI CPOL, so document this to fix dtbs_check warnings:

  arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3.dtb: ethernet-switch@0: Unevaluated properties are not allowed ('spi-cpol' was unexpected)

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

---

Changes since v4:
1. Order compatibles.
2. Add tag.

Changes since v3:
1. Rebase.
2. Require cpha/cpol properties on respective variants (thus update
   example).

Changes since v2:
1. Add allOf:if:then, based on feedback from Vladimir.

Changes since v1:
1. Add also cpha.
---
 .../bindings/net/dsa/nxp,sja1105.yaml         | 32 ++++++++++++++++---
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
index 9a64ed658745..4d5f5cc6d031 100644
--- a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
@@ -12,10 +12,6 @@ description:
   cs_sck_delay of 500ns. Ensuring that this SPI timing requirement is observed
   depends on the SPI bus master driver.
 
-allOf:
-  - $ref: dsa.yaml#/$defs/ethernet-ports
-  - $ref: /schemas/spi/spi-peripheral-props.yaml#
-
 maintainers:
   - Vladimir Oltean <vladimir.oltean@nxp.com>
 
@@ -36,6 +32,9 @@ properties:
   reg:
     maxItems: 1
 
+  spi-cpha: true
+  spi-cpol: true
+
   # Optional container node for the 2 internal MDIO buses of the SJA1110
   # (one for the internal 100base-T1 PHYs and the other for the single
   # 100base-TX PHY). The "reg" property does not have physical significance.
@@ -109,6 +108,30 @@ $defs:
        1860, 1880, 1900, 1920, 1940, 1960, 1980, 2000, 2020, 2040, 2060, 2080,
        2100, 2120, 2140, 2160, 2180, 2200, 2220, 2240, 2260]
 
+allOf:
+  - $ref: dsa.yaml#/$defs/ethernet-ports
+  - $ref: /schemas/spi/spi-peripheral-props.yaml#
+  - if:
+      properties:
+        compatible:
+          enum:
+            - nxp,sja1105e
+            - nxp,sja1105p
+            - nxp,sja1105q
+            - nxp,sja1105r
+            - nxp,sja1105s
+            - nxp,sja1105t
+    then:
+      properties:
+        spi-cpol: false
+      required:
+        - spi-cpha
+    else:
+      properties:
+        spi-cpha: false
+      required:
+        - spi-cpol
+
 unevaluatedProperties: false
 
 examples:
@@ -120,6 +143,7 @@ examples:
             ethernet-switch@1 {
                     reg = <0x1>;
                     compatible = "nxp,sja1105t";
+                    spi-cpha;
 
                     ethernet-ports {
                             #address-cells = <1>;
-- 
2.34.1


