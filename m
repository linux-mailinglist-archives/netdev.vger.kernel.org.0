Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB3E5B0ED9
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 23:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbiIGVHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 17:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiIGVHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 17:07:05 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F31BA152
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 14:07:03 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id l65so15828120pfl.8
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 14:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=edgeble-ai.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=tm5/tm/bOKGw+ZnlX8h2AbJd7n/3kcmAPIwiCqemhIM=;
        b=x7ypNYi2j2uvb8XQ9craSoAh2QNE3532j+e+pZG6ZhxotdgrQgsztR4QwOhk5485Yg
         ZYQ439NwiR04A/2DWciEI4MqLu+Ay2Jt2Izj4I/uzLYqz77oMWjcZZxlr9e+u1dHV96n
         z3Svs0OdnJkfwBaMcdAq8+qT3PqaXmAP1GSOflxkFcsP678j3vlrUN8qMCLVuOugw4rF
         y8z7P1Czucmb1QSWC2a/hb5v0Q5lP3SvANK8TSpbKTw5ao9H68v4Z77W9jI71uqsIUs9
         maT5vsRIJ7F/eDxUr9k0eGGr4msmgmamcpae7Jy3tUE2RViDRHov5J1aVFmsRk3Zwehz
         kMZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=tm5/tm/bOKGw+ZnlX8h2AbJd7n/3kcmAPIwiCqemhIM=;
        b=rEcJVUTXNeqPtBJCD9Kxh+pJQJ3V77mYl0Oyi9qZ//w8kPxPFv85QYF00AMH9SC+ka
         pNDGQxRTbjpFtW8JOoEeuxT2XJMHIsjvI8Ey/UPr4B7t0CJrDV8XIW0Tpk6qof6JnN9k
         a8XLA4XehEHGn1G2vMPcrRIQaLSJ9s8Omeg1BaN/z17YIK7yLYnbASvxGZUywA+FmHYk
         8iWiX+30nelBk0+QRACJYdaTS161aaaOGTMf3lvg6z1JSKmL9aQARxWJWmnOcm5WGIBT
         G0rpN+zZcYvXXRpHWyFE/0WObcbdMofU2GxOwS0OnO29dHhnbdvvKdQFjc5K4VgmsVZL
         fa7Q==
X-Gm-Message-State: ACgBeo0gPzkIhDtDJ26T4dxvQ0wPEmQfDrbYtQm2OnM5kx5BAF+/a5oY
        UFNpPYnF2Cpzqjpm5XClg+/FjQ==
X-Google-Smtp-Source: AA6agR6KR05rx/q/yr2bK+5wDAzujpFCnEW70ybxCculrOSDfSrMK2grU+8l7dxRUgRSY5z/y1pe5g==
X-Received: by 2002:a63:1c2:0:b0:430:710d:4c85 with SMTP id 185-20020a6301c2000000b00430710d4c85mr4980472pgb.12.1662584822610;
        Wed, 07 Sep 2022 14:07:02 -0700 (PDT)
Received: from archl-hc1b.. ([103.51.75.56])
        by smtp.gmail.com with ESMTPSA id c23-20020a63d517000000b0042ba1a95235sm10999198pgg.86.2022.09.07.14.06.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 14:07:02 -0700 (PDT)
From:   Anand Moon <anand@edgeble.ai>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        David Wu <david.wu@rock-chips.com>
Cc:     Anand Moon <anand@edgeble.ai>, Jagan Teki <jagan@edgeble.ai>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [v2 1/2] dt-bindings: net: rockchip-dwmac: add rv1126 compatible
Date:   Wed,  7 Sep 2022 21:06:45 +0000
Message-Id: <20220907210649.12447-1-anand@edgeble.ai>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add compatible string for RV1126 gmac, and constrain it to
be compatible with Synopsys dwmac 4.20a.

Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Jagan Teki <jagan@edgeble.ai>
Signed-off-by: Anand Moon <anand@edgeble.ai>
---
v2: add missing compatible string to property
    added reviewed by Heiko Stuebner.
---
 Documentation/devicetree/bindings/net/rockchip-dwmac.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml b/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
index 083623c8d718..b28bc6774bf0 100644
--- a/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
@@ -26,6 +26,7 @@ select:
           - rockchip,rk3399-gmac
           - rockchip,rk3568-gmac
           - rockchip,rv1108-gmac
+          - rockchip,rv1126-gmac
   required:
     - compatible
 
@@ -47,6 +48,7 @@ properties:
               - rockchip,rk3368-gmac
               - rockchip,rk3399-gmac
               - rockchip,rv1108-gmac
+              - rockchip,rv1126-gmac
       - items:
           - enum:
               - rockchip,rk3568-gmac
-- 
2.37.3

