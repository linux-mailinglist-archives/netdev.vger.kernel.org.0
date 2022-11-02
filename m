Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E36F616836
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 17:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231578AbiKBQQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 12:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231795AbiKBQOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 12:14:25 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A01362CC81
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 09:12:15 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id i12so12804134qvs.2
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 09:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+k46DBLcoCo3dRtPWgKGi27HQ6890qJkjOHhJG/OTD4=;
        b=lpZHL444MjaOGE7ePEMjfaD14yNrbOlNu054yVz8GPhDIzb+2HJAG8MOD68DWWCWp+
         8W04hunQV6twCx2v1SY+9oBptITK1UBYixs3+5dMZf7ucBlekZGDkIxvwD5sJDtOUNf4
         lDVSQIB3TgRshOBNYE/6f7pONQQVQ7VfyzQU3Ezu68cNplD4sg1bgI3n5iZtnJdAFq1a
         e5ROv6coqDBGKeAferYVuXMGdAExxgqWTxxC7bG5DwbeeRhEgevFKZO1klsVa8hzAxPY
         j9f+B7AMEL9CbNqMlZWQIhmOTJHmt7P6fycs3aDIbhAj1WkoKifDM1XZ4uuefDpLMszu
         LKcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+k46DBLcoCo3dRtPWgKGi27HQ6890qJkjOHhJG/OTD4=;
        b=1Z+6bHRazqk6FU6eisbxxIaUf+7mCaBy53rCkQTeyDY6xNFmbT9QyFOCBs69n5fK58
         f/iJmLKnrTdfA6kJ+A+UGNkQKj+PXh7ApU2sIS7O7JIULZyVmH8GV42pTYYBgSMV7bbX
         7FHopvPu8RUI2eT4D2hfP8qlHNr7C3jjAog3wQsIPmSpoFRO6aTQaaO/GltDGe6ECWI6
         KIdCZqt8M1C4cm+LuoMenFiBnwW4x+m+ydEltpBmxcZOm6O1lp575vHkkL1XhPT/nFT/
         CbFas5javHoyfZ7vTn+uUKiikok0YRhEwJgma1rUN5rl3fS5JVUso1qST22Tv+JnCAg1
         LS4A==
X-Gm-Message-State: ACrzQf3SzidiYBcrkrnP3QOcoAfgjFX9NLjtzGzj7ITybgfmXO/zlma9
        SWUssXvg9CQlN57XZs3xlDecNw==
X-Google-Smtp-Source: AMsMyM6YejYkb7b1cyNSYaRPfUs2k1VtqaMOpYa6/fCXbQyE837qgZ9RjnbvgAnAyXvdQlL9agXLJQ==
X-Received: by 2002:a05:6214:300e:b0:4bb:717e:72a with SMTP id ke14-20020a056214300e00b004bb717e072amr21460970qvb.15.1667405534760;
        Wed, 02 Nov 2022 09:12:14 -0700 (PDT)
Received: from krzk-bin.. ([2601:586:5000:570:28d9:4790:bc16:cc93])
        by smtp.gmail.com with ESMTPSA id s2-20020ac85282000000b0038d9555b580sm6778985qtn.44.2022.11.02.09.12.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 09:12:14 -0700 (PDT)
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
Subject: [PATCH] dt-bindings: net: nxp,sja1105: document spi-cpol
Date:   Wed,  2 Nov 2022 12:12:11 -0400
Message-Id: <20221102161211.51139-1-krzysztof.kozlowski@linaro.org>
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

Some boards use SJA1105 Ethernet Switch with SPI CPOL, so document this
to fix dtbs_check warnings:

  arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3.dtb: ethernet-switch@0: Unevaluated properties are not allowed ('spi-cpol' was unexpected)

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
index 1e26d876d146..a73905a50ee5 100644
--- a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
@@ -36,6 +36,8 @@ properties:
   reg:
     maxItems: 1
 
+  spi-cpol: true
+
   # Optional container node for the 2 internal MDIO buses of the SJA1110
   # (one for the internal 100base-T1 PHYs and the other for the single
   # 100base-TX PHY). The "reg" property does not have physical significance.
-- 
2.34.1

