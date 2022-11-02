Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B197616D34
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 19:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbiKBSwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 14:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbiKBSwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 14:52:37 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 048DD2AC4D
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 11:52:36 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id n18so13091147qvt.11
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 11:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XY2P6DWTOMi8nIXSylwfx8faCY5gykzO71qEAStGHFM=;
        b=yAqMdJPrNsEmbfN+mOl6g9ycWDlQ/yIO59XvIUZPXnq3Uun4s2DZ7q+NSoJfCZENRt
         8bhKEjU0tx7e6VqUoWIQyOyIAmKzqjbIowDZDxLfqXSLBE4KQt4nostkH051DJWkaMry
         6zpvOt4ZlLT03dWICdlk/KHhI69Sq+PUqelBf265zcRIKWF0OyGHPH8FTjwgegoww0oz
         tSveV/FKqIKcGNB/qjHqZ4jFE7hfiSXRvTeKdeKFTtVQ4wiNnWVj+8IINkI22F4Btk+K
         KqB0V1CW+yV6koc9PrckEgPVRWjv5ih6Qa1WKdU0jvPXWH1jvZCbfLCevjUjyW4dRFUC
         MQTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XY2P6DWTOMi8nIXSylwfx8faCY5gykzO71qEAStGHFM=;
        b=4y+nQ/ymwXGUb1T7LB3m7q6cmsrzXxEQYXnIN0mAe7liWkBfj6uAOVYHGwvqSJYSEm
         hxhPN6bln34EyOSCZ8rkC5klzpKSAseUIxbKq2oyRP6PWUTNlC5mTgeqyJGxhy7YkIwf
         AFkB0Fly7HMtxB7pieYRcmgiR0J1bsHfgC2hyB5HnlwHJr8AcGseC4nSvSCcFCBYUc9E
         xMEW+TakmNfFUWtmIrPo0mkGUEpMFsaDbrxKLhMgmbTeVlcCe9nRn4+G025O0RpRAI6Y
         yt2IrNQcepud9xOU9mCXTrHcY8V8kcUDzoGXDH6uWhO8p6D24fJ88shdFy5/rVj2NztP
         8uUQ==
X-Gm-Message-State: ACrzQf2WJ86CNLBhvrgaSIq+lvxGMSBvnUyy1D6z0F4hNb7uT52FMrOs
        W/ICJ6A0lD5Rd94h4L+AvdQr5A==
X-Google-Smtp-Source: AMsMyM7pcVwfat6ksB892Xu4HqXUDRlO14UcENtNGt8n6qoBpoyXNhP9AeIz4tPGc86ESKUm1a1fBg==
X-Received: by 2002:a05:6214:27ef:b0:4bb:f5db:39d5 with SMTP id jt15-20020a05621427ef00b004bbf5db39d5mr16664293qvb.43.1667415155208;
        Wed, 02 Nov 2022 11:52:35 -0700 (PDT)
Received: from krzk-bin.. ([2601:586:5000:570:28d9:4790:bc16:cc93])
        by smtp.gmail.com with ESMTPSA id ay7-20020a05620a178700b006cfc1d827cbsm8874387qkb.9.2022.11.02.11.52.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 11:52:34 -0700 (PDT)
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
Subject: [PATCH v2] dt-bindings: net: nxp,sja1105: document spi-cpol/cpha
Date:   Wed,  2 Nov 2022 14:52:32 -0400
Message-Id: <20221102185232.131168-1-krzysztof.kozlowski@linaro.org>
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

Some boards use SJA1105 Ethernet Switch with SPI CPOL and CPHA, so
document this to fix dtbs_check warnings:

  arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3.dtb: ethernet-switch@0: Unevaluated properties are not allowed ('spi-cpol' was unexpected)

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

Changes since v1:
1. Add also cpha
---
 Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
index 1e26d876d146..3debbf0f3789 100644
--- a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
@@ -36,6 +36,9 @@ properties:
   reg:
     maxItems: 1
 
+  spi-cpha: true
+  spi-cpol: true
+
   # Optional container node for the 2 internal MDIO buses of the SJA1110
   # (one for the internal 100base-T1 PHYs and the other for the single
   # 100base-TX PHY). The "reg" property does not have physical significance.
-- 
2.34.1

