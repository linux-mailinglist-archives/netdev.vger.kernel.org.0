Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEA89570210
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 14:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbiGKMax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 08:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiGKMau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 08:30:50 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB7ED4E630
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 05:30:48 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id h23so8512076ejj.12
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 05:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3SasMWyrhlBVoSPa/+DazZ+0uAy40h1yJmXYnejMTE8=;
        b=N4yE70WYcr4oloa6HIttGo0wZVN+ExaRyrNGxu+F2x71xPMEROMnfM7ZtJjPpNJWzQ
         9qblc5lYP2gIStYvRC+cov9MgXUnrouDI6+o066Gu604Wucr4asA9bt8BLpR+Qt6ueEJ
         sKjSbHNzRaUjJuQqt2wU32S1EYuCA4jGY4jyA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3SasMWyrhlBVoSPa/+DazZ+0uAy40h1yJmXYnejMTE8=;
        b=Nvdy6uNezH0wcHiVi0OGhEiLioTJds5g2Ro32gglKj9m4OX8FgVAZSNgsItMNC1M1z
         xH+FUDAzlzwRn1ToMaM7JniBFVRLeNmHt8G6Xq8SJnMKcfiVZBZ81dDE+qZdfbmqKDSa
         jFXmeSokCTTF1ul/NvoP/iOiG8x50rYi25WqKOLzMu9OfliUx+xG3+QIdGjhLIFHN16w
         qCblQ2CdjOV8Y9DxToKLZELr7vMgMI3wFwkplBxpOaA5M8qlwnLuOWfnIoAt8JWMizke
         rOngaa4N/QERtwoGIOqk5fnatVlFGkWQ1qfuhEoDbfEv3GmrYfFvLSHRyaZny00L/EAK
         sdWA==
X-Gm-Message-State: AJIora86PpvPcDcn2Rg3J5MGQDuXjEOhmeF2S3ZzdLU1ylHGTEkm+7Ux
        StLW73b8gtquty7upg2C7eZdjQ==
X-Google-Smtp-Source: AGRyM1u6G7PtoLInurzT8QC8Y4AYygm9vrlxOrdABf14TxRcMzn9o5xuJC09+CDE9V+GJSfbDKXfaA==
X-Received: by 2002:a17:907:2c47:b0:6d7:31b0:e821 with SMTP id hf7-20020a1709072c4700b006d731b0e821mr17675287ejc.334.1657542647462;
        Mon, 11 Jul 2022 05:30:47 -0700 (PDT)
Received: from localhost.localdomain (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id g1-20020a17090604c100b0072b16a57cdcsm738785eja.118.2022.07.11.05.30.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 05:30:47 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        van Spriel <arend@broadcom.com>
Cc:     Ahmad Fatoum <a.fatoum@pengutronix.de>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Subject: [PATCH 1/2] dt-bindings: bcm4329-fmac: add optional brcm,ccode-map-trivial
Date:   Mon, 11 Jul 2022 14:30:03 +0200
Message-Id: <20220711123005.3055300-2-alvin@pqrs.dk>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711123005.3055300-1-alvin@pqrs.dk>
References: <20220711123005.3055300-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

The bindings already offer a brcm,ccode-map property to describe the
mapping between the kernel's ISO3166 alpha 2 country code string and the
firmware's country code string and revision number. This is a
board-specific property and determined by the CLM blob firmware provided
by the hardware vendor.

However, in some cases the firmware will also use ISO3166 country codes
internally, and the revision will always be zero. This implies a trivial
mapping: cc -> { cc, 0 }.

For such cases, add an optional property brcm,ccode-map-trivial which
obviates the need to describe every trivial country code mapping in the
device tree with the existing brcm,ccode-map property. The new property
is subordinate to the more explicit brcm,ccode-map property.

Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
 .../bindings/net/wireless/brcm,bcm4329-fmac.yaml       | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml b/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
index c11f23b20c4c..53b4153d9bfc 100644
--- a/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
@@ -75,6 +75,16 @@ properties:
     items:
       pattern: '^[A-Z][A-Z]-[A-Z][0-9A-Z]-[0-9]+$'
 
+  brcm,ccode-map-trivial:
+    description: |
+      Use a trivial mapping of ISO3166 country codes to brcmfmac firmware
+      country code and revision: cc -> { cc, 0 }. In other words, assume that
+      the CLM blob firmware uses ISO3166 country codes as well, and that all
+      revisions are zero. This property is mutually exclusive with
+      brcm,ccode-map. If both properties are specified, then brcm,ccode-map
+      takes precedence.
+    type: boolean
+
 required:
   - compatible
   - reg
-- 
2.37.0

