Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 101406661E2
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 18:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235097AbjAKRam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 12:30:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239635AbjAKR2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 12:28:43 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B4C3D5F1
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 09:24:48 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id v13-20020a17090a6b0d00b00219c3be9830so17963456pjj.4
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 09:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=edgeble-ai.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Jbu/rVr6n2Zk27DTmTR5ScWWLUloBxQI7RkPhtXRlII=;
        b=yrD8dxGNg5ZO4IXiMKYPbv93TaG4TWX2OugwLUbr+siHQBJeBxpqrrOM4wt32jCbsb
         NFLH7HvE3rPdiTGDeXEpEu4jprmbdiLqGtoLnGjNz1loktheApWuVEtB4HvLjjlOGW/k
         3i0M1KzDEyv7koyZWtwlkUFl63j8c4Mc8xD83j86VGbXoKfMl9/P/2XGSPpiYZSPN7/f
         Rq7WfexbuEbvPze6dLTZBZ04ACNMMWB59my82UbzsBPUqiRLaEZDzlO0sgy1G5BMnXeY
         pDmZ4K2dJbPdITGUh8rnYBTBwc2AkWTrlMwUAQDt8CwaqQhBmGmDi+hE+qvoPYXWtgJc
         Fz1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jbu/rVr6n2Zk27DTmTR5ScWWLUloBxQI7RkPhtXRlII=;
        b=pEhvmQffACxHVdNP99nLU8ultGadmiyw80pg3wvRWD+G+zvMbbcMFvV4DEcndahi1x
         xwGecHGFrIg0VdS9tXvHB7G5nqodOZ5+ak6i0sW7yij+gitY6yQdJfLVM2tEsyVTOfe5
         N8LmRJkB/XjZqOvojU7bytJkW1ecO9Ch6SsLQCOvn7nQJ5CXqWl0jIwIpwzR9JvMK+w7
         GDR0jQl3OL2cQFDDZjMBUsSEiZqtWwDwxrM1CKjtQWialiLyc4q7aRpNsWSKN/lsnK+z
         XGsrAE1D0PENNK8sC9WDDRMTjf+jpFl5xFu0PNWz/MmLXvoifGWg/HnzFjY6qNBwhpo+
         qM6A==
X-Gm-Message-State: AFqh2koZ9N/k/Xuaov0aYyElfkha2k3ZnQs4bO9uH2VdEs23nRp4Gldj
        pHx42NCLnfi2P+Ue6mYYHyOEww==
X-Google-Smtp-Source: AMrXdXurfUnEXP3w5lWeGVO/1PNLOhoMBmCfXSG1xwJFS2xQEpZyInyfKEQjAm+4z8o35LQvYOtKjA==
X-Received: by 2002:a05:6a21:e307:b0:af:7a88:f752 with SMTP id cb7-20020a056a21e30700b000af7a88f752mr90849296pzc.48.1673457887706;
        Wed, 11 Jan 2023 09:24:47 -0800 (PST)
Received: from archl-hc1b.. ([45.112.3.15])
        by smtp.gmail.com with ESMTPSA id rm14-20020a17090b3ece00b00218fa115f83sm11110722pjb.57.2023.01.11.09.24.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 09:24:46 -0800 (PST)
From:   Anand Moon <anand@edgeble.ai>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        David Wu <david.wu@rock-chips.com>,
        Anand Moon <anand@edgeble.ai>, Jagan Teki <jagan@edgeble.ai>
Cc:     Johan Jonker <jbx6244@gmail.com>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 linux-next 1/4] dt-bindings: net: rockchip-dwmac: fix rv1126 compatible warning
Date:   Wed, 11 Jan 2023 17:24:31 +0000
Message-Id: <20230111172437.5295-1-anand@edgeble.ai>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
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
v5: none
v4: none
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

