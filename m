Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14174629907
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 13:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232120AbiKOMjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 07:39:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiKOMjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 07:39:07 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA201FF97;
        Tue, 15 Nov 2022 04:39:05 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id j15so24062818wrq.3;
        Tue, 15 Nov 2022 04:39:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QKEXLyPGXjJRKPyvW3PaMhdvkr3/5SmF5s8yvu+zTKo=;
        b=NmWecbfPc3BUXQz2DWCZAXcNm8nXoinDTs8mMqCsMqBQOS83ucUtmaru3L/0xEFY78
         v5xjfaF1k5d639TGBRJfDsGlo4iqw1cTeIZWY9b2tDG669D9Bnm0USvWmCaW0HzSqyyR
         JX4ZFafXCEVWEc4Np7IQRGttEgNeKUZx9mQZy+dB/ftO2lFfFlZB59QmUD9u3mx1ycZo
         pnuToKBnOu/Bbe9XIBQdJZo0lhreWYN6SEdJVcUK1JGUP6Wz0O5doccRIicJu+1CSR2d
         kgVR21EiXBHrCbsBwoc6bLbn0oTkgYxgyfKss94IhB89FJxOOuMAirjayTIgocruMt68
         kBaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QKEXLyPGXjJRKPyvW3PaMhdvkr3/5SmF5s8yvu+zTKo=;
        b=BWod6FeIRGIhaseV2vmGvSi96Y4I1YzJPZa5HRSKO/nRX+VOjumHwBb5WxTwKnjQ4E
         APUpK0+aslRe/vMvF1B5jZPwG8TmF3IqG55QST8dav0fmzPCSZUmG7MwgB2ydEtia4AG
         ZUnSGfA3wiXq9dNXbX0Q7Ub1BirYw/k5P8thnZehD6BcRzSrGnJzFE5lnBFZXRJlDrYN
         AQ9kKedT2p4WRb1+KUMV9cQinMUn+b1+kflLp0MTfwquYxAJRlWrRY4yAOBqj0oEV5Nr
         YDVwL1M5TD1mbke4BGhb3/DkCAhnwrT1kSS4917J1ZLJm5cd1VzEmjzQvfFnh78itwGm
         yEdw==
X-Gm-Message-State: ANoB5pkOI5j2/xZaOL/ILqMrzpi/9MB/uoo2jwPinh+spbTh9pGlOqv8
        aYEYskGEfMLnQr3mbvsaQUU=
X-Google-Smtp-Source: AA0mqf6tmoz1BJJ0n5zUU8CY0LabZNgtpI2+CtgwsY8wssR/lutYM+mj34Bhl0yB6iOJaiI9THy/Sg==
X-Received: by 2002:a05:6000:1806:b0:241:7277:6aa4 with SMTP id m6-20020a056000180600b0024172776aa4mr10038121wrh.660.1668515944078;
        Tue, 15 Nov 2022 04:39:04 -0800 (PST)
Received: from prasmi.home ([2a00:23c8:2501:c701:d94a:6345:c378:e255])
        by smtp.gmail.com with ESMTPSA id r8-20020a05600c2f0800b003c701c12a17sm20735803wmn.12.2022.11.15.04.39.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 04:39:02 -0800 (PST)
From:   Prabhakar <prabhakar.csengg@gmail.com>
X-Google-Original-From: Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH] dt-bindings: can: renesas,rcar-canfd: Document RZ/Five SoC
Date:   Tue, 15 Nov 2022 12:38:11 +0000
Message-Id: <20221115123811.1182922-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

The CANFD block on the RZ/Five SoC is identical to one found on the
RZ/G2UL SoC. "renesas,r9a07g043-canfd" compatible string will be used
on the RZ/Five SoC so to make this clear, update the comment to include
RZ/Five SoC.

No driver changes are required as generic compatible string
"renesas,rzg2l-canfd" will be used as a fallback on RZ/Five SoC.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 .../devicetree/bindings/net/can/renesas,rcar-canfd.yaml         | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
index 6f71fc96bc4e..8347053a96dc 100644
--- a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
+++ b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
@@ -33,7 +33,7 @@ properties:
 
       - items:
           - enum:
-              - renesas,r9a07g043-canfd    # RZ/G2UL
+              - renesas,r9a07g043-canfd    # RZ/G2UL and RZ/Five
               - renesas,r9a07g044-canfd    # RZ/G2{L,LC}
               - renesas,r9a07g054-canfd    # RZ/V2L
           - const: renesas,rzg2l-canfd     # RZ/G2L family
-- 
2.25.1

