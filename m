Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4619E6550F8
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 14:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234990AbiLWNZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 08:25:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiLWNZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 08:25:49 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 201DD65C7
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 05:25:47 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id n10-20020a17090a73ca00b00225cbc4dfaeso522930pjk.3
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 05:25:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=edgeble-ai.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wundbcH2g9xN6/PVxd6vNLcmcPbSkSP9WqIdH+1twe8=;
        b=3YYEJ6fsDDNLI6BSPUn9UAVpJ3cm8A8yF4bM3GKpdiztut/6kkMEIugr9asK8oqPwb
         7col/iMpBEqJSKt1RV5xgrw3gOOwdqKXQtzhOngDvel74k9wZsQy+GIf2LNHMTlZuBZd
         W1e7SvML5sc7KGk7DhlhvdenKHckc8FWOIP+hSbcb7zAYvzLJw2NDAHf94/UuZAqcxZv
         YbAAevXIsrWLjuQ+YIbIqZwXqjY636/jjUSKwYaB42cLTgLa3SgAaJGXWx7YRmAkRGfC
         SnYmpbQUXDkrX55LIpOKGX/mCUuPXDk0loPoKSkPDQkDwXSzocet1Qz1rosrrnbqnEVK
         TwGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wundbcH2g9xN6/PVxd6vNLcmcPbSkSP9WqIdH+1twe8=;
        b=gWTYFAj/doaRYU0yN9gu+fsvYh9XRdSYJFjaO/8c4rrPiejmmneplHTYwvnUcgtS+7
         xpntVecpgn4C7XRN+zZcAd8Q/sJ0Itm2o/dwBjLC74Ej6I66Ut/IfFJMuEkqBVg5gJK3
         CLIFRjHVCUbnCB33+23F37V/PEpPTMCEp8nC54EXlsbk8YBTJDq2DHwGxhKx48ayocpw
         HM/8hOM0MBROCaXXLV6XzF2PLUBg4VuxA5KCeJ3f4O1TEJgjwfkU7BX5R3ni5PpizUoI
         S4r3XKfJUu1QaX+je2NRVzeOyksHSthwz2o2AoxRgqMv1csIeq0wnB9bbabE6CnaPd00
         CLAw==
X-Gm-Message-State: AFqh2kp7Rjq2sKMnflvLP3oY655uKqXLSqRTzi9xP1cfUaWUjDCG6zaC
        Dulaj3Lc1dGQ6dnbxalBrnn6oA==
X-Google-Smtp-Source: AMrXdXupbRVLFT1bwpmjESvCYz8d60hQsjaf+PgnNKc51oTZ642XvF1P0pE3Ipqp5xf+VO1u+RWjnA==
X-Received: by 2002:a05:6a21:6da2:b0:b2:56ba:63ee with SMTP id wl34-20020a056a216da200b000b256ba63eemr14967634pzb.24.1671801946506;
        Fri, 23 Dec 2022 05:25:46 -0800 (PST)
Received: from archl-hc1b.. ([45.112.3.26])
        by smtp.gmail.com with ESMTPSA id m3-20020a635803000000b0047681fa88d1sm1308587pgb.53.2022.12.23.05.25.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Dec 2022 05:25:46 -0800 (PST)
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
Subject: [PATCHv1 linux-next 1/4] dt-bindings: net: rockchip-dwmac: fix rv1126 compatible warning
Date:   Fri, 23 Dec 2022 13:22:30 +0000
Message-Id: <20221223132235.16149-1-anand@edgeble.ai>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix compatible string for RV1126 gmac, and constrain it to
be compatible with Synopsys dwmac 4.20a.

fix below warning
arch/arm/boot/dts/rv1126-edgeble-neu2-io.dtb: ethernet@ffc40000:
		 compatible: 'oneOf' conditional failed, one must be fixed:
        ['rockchip,rv1126-gmac', 'snps,dwmac-4.20a'] is too long
        'rockchip,rv1126-gmac' is not one of ['rockchip,rk3568-gmac', 'rockchip,rk3588-gmac']

Signed-off-by: Anand Moon <anand@edgeble.ai>
Signed-off-by: Jagan Teki <jagan@edgeble.ai>
---
 Documentation/devicetree/bindings/net/rockchip-dwmac.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml b/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
index 42fb72b6909d..04936632fcbb 100644
--- a/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
@@ -49,11 +49,11 @@ properties:
               - rockchip,rk3368-gmac
               - rockchip,rk3399-gmac
               - rockchip,rv1108-gmac
-              - rockchip,rv1126-gmac
       - items:
           - enum:
               - rockchip,rk3568-gmac
               - rockchip,rk3588-gmac
+              - rockchip,rv1126-gmac
           - const: snps,dwmac-4.20a
 
   clocks:
-- 
2.39.0

