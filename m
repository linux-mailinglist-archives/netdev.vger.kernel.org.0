Return-Path: <netdev+bounces-3237-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 76D9B7062B9
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 10:26:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E5272812BF
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 08:26:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A06C0154A7;
	Wed, 17 May 2023 08:26:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854511549F
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 08:26:09 +0000 (UTC)
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD40B3C03
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 01:26:06 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-965cc5170bdso66519166b.2
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 01:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684311965; x=1686903965;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8QwJPbsCiubRopdCVM5kCKFh6TVjVElRMpwR6zQywvo=;
        b=G5tkD6wGgIwau1lSRFnz7DxyhfTZ1eESBdix3QYwj4fx8RApOtmUozN1dsS5vXNVFg
         VPNAcr9l0/3KL4HBA52tmIpGCCUkanjMdCdP3CxUDKxbBwDwzeTKLxgtqppcxppyHdyf
         f4gVN6v90bi6svEiiUJqK3PIqnCrUXNtL/MWKDUheab4R3Ix/3v19COg7ArQojR7FpkX
         FbVA6W1rpBiRVOtVsBAtvgJ6WvKJwFtdy/mUY3s7EykV15Vq3QRtSoW5ePx9QRLi9hpx
         KOLVrMebhhTowb//qZZPWGLnEdLKUSy1qRWH+TYH26wCT58SK8fMpqYP+CxcB7xMATuc
         tMzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684311965; x=1686903965;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8QwJPbsCiubRopdCVM5kCKFh6TVjVElRMpwR6zQywvo=;
        b=WcRJ/hCcvXBbqsBvhPZZeeLWf9TbBYSsRd7yyOSbaxUQ8Y2/tQkmiMnKnGEZbEFSb/
         FO13fK1tlEVVS/JLPUtW8Gv6UmXXgyzDvLkySAVAG8LFXxv5Hmcs6/gPZHRNdINqQqNX
         Zm8ppH3J5GwGQXIdfUTRFc7ff1o/YV2Qa8yp8zPeHwaLT4BAlJQhvwVjGGUNXhn4y90t
         RGT74i7q/869HhmDDmGCb4trpDiX0FMuNzUYTRTMJydOTUXarGTPRLn4i7rts1jqWEMf
         mvTzSWAQ96Lzvr4BJzqPwWTcjrPhEPmu1kfNRHt6IzDqiJsPNKMrNxWhtsJh3TkmvObQ
         KStg==
X-Gm-Message-State: AC+VfDyMjXukq4D+nkYvBeuf3v9qk8Xaj+WcO9YqSvMTlr1+v0+Uko9w
	5b1xmTL+i7kCXhFncqffj0Tkyg==
X-Google-Smtp-Source: ACHHUZ4sEeX6uDuilxC3hCrD7MOQznbPTZ7eILTHFgPHP0LkCGMMRLYX4OBTaaVPvuoa+ykp+W/+lQ==
X-Received: by 2002:a17:907:a44:b0:966:530c:3c90 with SMTP id be4-20020a1709070a4400b00966530c3c90mr29081869ejc.13.1684311965314;
        Wed, 17 May 2023 01:26:05 -0700 (PDT)
Received: from krzk-bin.. ([2a02:810d:15c0:828:c9ff:4c84:dd21:568d])
        by smtp.gmail.com with ESMTPSA id n10-20020a17090673ca00b0096a6be0b66dsm8574468ejl.208.2023.05.17.01.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 01:26:04 -0700 (PDT)
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
	Conor Dooley <conor.dooley@microchip.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RESEND PATCH net-next v5] dt-bindings: net: nxp,sja1105: document spi-cpol/cpha
Date: Wed, 17 May 2023 10:26:02 +0200
Message-Id: <20230517082602.14387-1-krzysztof.kozlowski@linaro.org>
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
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Some boards use SJA1105 Ethernet Switch with SPI CPHA, while ones with
SJA1110 use SPI CPOL, so document this to fix dtbs_check warnings:

  arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3.dtb: ethernet-switch@0: Unevaluated properties are not allowed ('spi-cpol' was unexpected)

Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

Resend with proper net-next and Vladimir's tag.

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


