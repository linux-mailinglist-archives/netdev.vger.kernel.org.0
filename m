Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D36C4619E40
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 18:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbiKDRQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 13:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbiKDRQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 13:16:04 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB3040470
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 10:16:01 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id x15so3401495qtv.9
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 10:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nOs3glUYlVlOGkD+d61vafn3z8WhEZloC5kNYhM2+Ik=;
        b=nZUFy5qS+kcKRgiQerq9t6LWsQUJdfZxNClFWjXBy7+MNVNqdh5yPYzabdmEppfDTD
         abMT22yv+qtHAYFUPLVTem0XhAMmHq96kPDp2rTluaG3S4mgJrbs1DagGbCmTBNy2M/g
         rPqvqrPDyEnXn56ct9+FxhqTdIihgUPUWQbi+W4e/xcguUuLnZH3+drBpnnGC7Uq2H0z
         gO0qwKIRiHA5uw2FLLFHvR6Xxz0meJrJSzEXlM1MyAIOIfGao0KmHKXnq1Kr8f1UQ/pd
         HVT8+aQpBh5+anU8cH28jop/Zy8vaZRpZ42HO2jBKMzAMcDahCaKyDC7ZfWPUlqhAyae
         8XGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nOs3glUYlVlOGkD+d61vafn3z8WhEZloC5kNYhM2+Ik=;
        b=r9nMVDJayVC2tTVMxPEcfhUjnn2VBASnY5h4/rEWjixZmE8TcPGgjmumFqXWIs/W9K
         ZX5grUtaI7oJ7TrvMMACz91GrRMdURZ1HFmm0rvdvJtmoTOuyRkD4iWEkmV8Gi861pyg
         DLPDecdVtkRTQd/w0VItLuZSee5abBwrLGpCA54oZkB61xzVFhufmJlJhHNND87PXb/F
         P9pS14KM1EBxBoGLrKBJ1kyKtms40bblSvAywPdb0AOB8W4BvXIEDv3haOpcg3bURFaG
         qHPH/JFljOVVofE/vlSjhF6+vdWFvvVlIeeAQYatHEwRyJyDZDVzNKuOHayrpHfa2lsg
         ptJA==
X-Gm-Message-State: ACrzQf2jCSwagDXMLagX+BQrb41i2hzVX40gRyClwx9a3eg3rGqimoNt
        aKUt5sjhCSGN3SffgmRBa5clWw==
X-Google-Smtp-Source: AMsMyM7qnw0egP5wylRcXqYCLxbW8DXmsrk4aUPAOGiyXuh95E+RpEdQRtxMus7jOvms6Nx/Rfc0RA==
X-Received: by 2002:ac8:5e50:0:b0:3a5:6a35:f440 with SMTP id i16-20020ac85e50000000b003a56a35f440mr2413122qtx.46.1667582160898;
        Fri, 04 Nov 2022 10:16:00 -0700 (PDT)
Received: from krzk-bin.. ([2601:586:5000:570:aad6:acd8:4ed9:299b])
        by smtp.gmail.com with ESMTPSA id j8-20020a05620a288800b006fa4cac54a4sm3274901qkp.133.2022.11.04.10.15.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 10:16:00 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v3] dt-bindings: net: nxp,sja1105: document spi-cpol/cpha
Date:   Fri,  4 Nov 2022 13:15:57 -0400
Message-Id: <20221104171557.95871-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some boards use SJA1105 Ethernet Switch with SPI CPHA, while ones with
SJA1110 use SPI CPOL, so document this to fix dtbs_check warnings:

  arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3.dtb: ethernet-switch@0: Unevaluated properties are not allowed ('spi-cpol' was unexpected)

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

Changes since v2:
1. Add allOf:if:then, based on feedback from Vladimir.

Changes since v1:
1. Add also cpha
---
 .../bindings/net/dsa/nxp,sja1105.yaml         | 27 ++++++++++++++++---
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
index 1e26d876d146..ac66af3fdd82 100644
--- a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
@@ -12,10 +12,6 @@ description:
   cs_sck_delay of 500ns. Ensuring that this SPI timing requirement is observed
   depends on the SPI bus master driver.
 
-allOf:
-  - $ref: "dsa.yaml#"
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
@@ -109,6 +108,26 @@ $defs:
        1860, 1880, 1900, 1920, 1940, 1960, 1980, 2000, 2020, 2040, 2060, 2080,
        2100, 2120, 2140, 2160, 2180, 2200, 2220, 2240, 2260]
 
+allOf:
+  - $ref: dsa.yaml#
+  - $ref: /schemas/spi/spi-peripheral-props.yaml#
+  - if:
+      properties:
+        compatible:
+          enum:
+            - nxp,sja1105e
+            - nxp,sja1105t
+            - nxp,sja1105p
+            - nxp,sja1105q
+            - nxp,sja1105r
+            - nxp,sja1105s
+    then:
+      properties:
+        spi-cpol: false
+    else:
+      properties:
+        spi-cpha: false
+
 unevaluatedProperties: false
 
 examples:
-- 
2.34.1

