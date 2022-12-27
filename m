Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5AF656993
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 11:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbiL0KtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 05:49:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbiL0Ks6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 05:48:58 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C05A3A18C
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 02:48:57 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id c8-20020a17090a4d0800b00225c3614161so9773875pjg.5
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 02:48:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=edgeble-ai.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TTKLuzkwLj+Q2/P4X0bnHmkwF9FCPAj0tHenrsB64MU=;
        b=hdFU7UXge7DZPRpCdlZ8nglNVWmcOuTR2FjkeOANwBgCZ3F2DESNTF/GibvEPWTshz
         rCxGwmtIDPTCanOxY+lBsSBOUx55E7Y/Z0ztWDxDr0y+DSaXqDu/ml2lityYuemQ5FMK
         +ELaseW7KSyLBb4l9lagFg3yv+USCXdbjxOJ+iVYPhEFnRSJ5zN2TuodEiaVQVg9qczr
         aF0n4D8xHKdRabMDdMjalIdYSSR3O0nW00ctJqVZa7EJUB9YzrPbbUioz2RdOuC333de
         bz9pbG4v5sDZVTsaRWo/sA2v5kEquJeqzmHaNJb9i99HkNCdua5gOnQxOK+dv1Wf7Jcv
         g/1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TTKLuzkwLj+Q2/P4X0bnHmkwF9FCPAj0tHenrsB64MU=;
        b=SBlNocyI51jiSeYg/It/tirKKn0s+BDSrn9hu+gZt9MWjCWtEd1iM0HY1LJnaCbqEi
         keGNu1IL3MteksZiihSzjbQC1mqoenK8KVBBW+kKsfABaP7/ASW4ro/kC12zQdjQztCX
         +VWh9ogcfmdXP2TIVWq6nMINAjfZccDWPJ/y4O2n4Vb9mt5zcwQpXQjors+CQ80CkqwU
         L7dg77nObR4MxWycdPb16J8gwymoUUi6I/xEWiag7SZIvzgou9HXaGATvRxa0kxLD3CC
         sD6e/QoERNOrevRRbEphaFdnuz3b4fmWKQuCT0eE3fA2XpfYc4TGxsq9yd9F2paUsGuh
         KUug==
X-Gm-Message-State: AFqh2kpheqaOmzv1sb6/JQIgZNpKmr1pgPf0VKfNHAefVeJBRxWYI3hs
        qbiwVyde+n2cle9Cgcut6RiI8Q==
X-Google-Smtp-Source: AMrXdXv1Z/aYGHPnuLv8/usCVi6UgfeoQF9PF5KxPbvZs2FqfHDvdi7G9dC66WbevOL9lCCZDwjOwQ==
X-Received: by 2002:a05:6a20:2a87:b0:b1:dd00:eb05 with SMTP id v7-20020a056a202a8700b000b1dd00eb05mr33626652pzh.26.1672138137218;
        Tue, 27 Dec 2022 02:48:57 -0800 (PST)
Received: from archl-hc1b.. ([45.112.3.26])
        by smtp.gmail.com with ESMTPSA id w18-20020aa79a12000000b00581816425f3sm194809pfj.112.2022.12.27.02.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 02:48:56 -0800 (PST)
From:   Anand Moon <anand@edgeble.ai>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        David Wu <david.wu@rock-chips.com>,
        Jagan Teki <jagan@edgeble.ai>, Anand Moon <anand@edgeble.ai>
Cc:     Johan Jonker <jbx6244@gmail.com>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCHv3 linux-next 1/4] dt-bindings: net: rockchip-dwmac: fix rv1126 compatible warning
Date:   Tue, 27 Dec 2022 10:48:31 +0000
Message-Id: <20221227104837.27208-1-anand@edgeble.ai>
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
$ make CHECK_DTBS=y rv1126-edgeble-neu2-io.dtb
arch/arm/boot/dts/rv1126-edgeble-neu2-io.dtb: ethernet@ffc40000:
		 compatible: 'oneOf' conditional failed, one must be fixed:
        ['rockchip,rv1126-gmac', 'snps,dwmac-4.20a'] is too long
        'rockchip,rv1126-gmac' is not one of ['rockchip,rk3568-gmac', 'rockchip,rk3588-gmac']

Fixes: b36fe2f43662 ("dt-bindings: net: rockchip-dwmac: add rv1126 compatible")
Reviewed-by: Jagan Teki <jagan@edgeble.ai>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Anand Moon <anand@edgeble.ai>
---
v3: added Ack and Rev from Rob and Jagan.
v2: drop SoB of Jagan Teki
    added Fix tags and update the commit message of the warning.
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

