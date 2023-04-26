Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69EE46EFA64
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 20:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbjDZSyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 14:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236285AbjDZSyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 14:54:47 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14EE67EEF;
        Wed, 26 Apr 2023 11:54:47 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-63b64a32fd2so9563669b3a.2;
        Wed, 26 Apr 2023 11:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682535286; x=1685127286;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Q784dRdh+8ACGApvx46jbzabaa2j0b2l3E8XdTi/8wo=;
        b=oIYURqv1jVNXT99Qi6fsTFAHY8GIo3cwKtczIegWkLkUAMJkf3GWAHiirPcTvab0TS
         UPoe6a8acjRht8c2ljDwUxK3ERRvYTVYuODe26NXVZlVI9m5zb1ogA5PGzydwJECT9Jz
         csdOHs7eS/6s4g2RgaJzCbHTcwhX7PeD36/MRVzXbzyBhUZ3Hv9N+1fcWr8ECLwz/b/X
         NMoUpMemCWX9yWeDB2wLu3y+QPWiiJm1Iu4lDDutVGPJjf4PYzp9/huF12wPUob7CH7t
         YNjKMDWEYCMLoPnBel+P80wGOxwiNgBGgY9HV3Q9au51N6nBjKj6HaxgZ0CAHfy2UZRO
         PxCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682535286; x=1685127286;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q784dRdh+8ACGApvx46jbzabaa2j0b2l3E8XdTi/8wo=;
        b=hk4TbikIdFayetwunObE6W5ah2i/gAdEeCys3Vf78htPIZI5lP8evh6z5ewR51CcLg
         LlacBoq+tHR6UTmDeuB7S0F2oq13eiODUSrglXGjt4Koelx898QDyTu5h1we/vsKVPW3
         f3WnJQ62Z8h1dwjwdcK8eCRAgfLAUiqsTXJ4J/Yw6TKAi4Q72bwRbprlj++LtfbXlGKr
         0hoAX5CbBNE2GQDXjhQYCMVWJfG3RLf5Vd9mmS1CdxAJKsxsyM94I+aqInSQ+12z6nL6
         lIwX0BRB8EWqjr9ptQhmnUNE5aKbzyUwOTj+Wi5+FoeruPFyIaVXd0KYUSzZuvOftL1v
         Ey3A==
X-Gm-Message-State: AAQBX9ebNaeshyAuTuhrX2RUQckycab22eQKeDGVsWyHl7wQWhCumcLA
        LItY7NOyjYD10OxhbQAs5Kb6tTEteDVNgw==
X-Google-Smtp-Source: AKy350YGk/4ih/AlG+kILS2fTRctjWUttCVdHx5+Kz4oTUR8FKm58UXiWGzU1ccpTQvUB5TkCh3Ltg==
X-Received: by 2002:a05:6a00:15d1:b0:63f:2b56:5e2f with SMTP id o17-20020a056a0015d100b0063f2b565e2fmr22246463pfu.4.1682535286287;
        Wed, 26 Apr 2023 11:54:46 -0700 (PDT)
Received: from stbirv-lnx-2.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y72-20020a62644b000000b006372791d708sm11639254pfb.104.2023.04.26.11.54.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Apr 2023 11:54:45 -0700 (PDT)
From:   Justin Chen <justinpopo6@gmail.com>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        bcm-kernel-feedback-list@broadcom.com
Cc:     justinpopo6@gmail.com, justin.chen@broadcom.com,
        f.fainelli@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, opendmb@gmail.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        richardcochran@gmail.com, sumit.semwal@linaro.org,
        christian.koenig@amd.com
Subject: [PATCH v2 net-next 1/6] dt-bindings: net: brcm,unimac-mdio: Add asp-v2.0
Date:   Wed, 26 Apr 2023 11:54:27 -0700
Message-Id: <1682535272-32249-2-git-send-email-justinpopo6@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1682535272-32249-1-git-send-email-justinpopo6@gmail.com>
References: <1682535272-32249-1-git-send-email-justinpopo6@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ASP 2.0 Ethernet controller uses a brcm unimac.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Justin Chen <justinpopo6@gmail.com>
---
 Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml b/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
index 0be426ee1e44..6684810fcbf0 100644
--- a/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
+++ b/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
@@ -22,6 +22,8 @@ properties:
       - brcm,genet-mdio-v3
       - brcm,genet-mdio-v4
       - brcm,genet-mdio-v5
+      - brcm,asp-v2.0-mdio
+      - brcm,asp-v2.1-mdio
       - brcm,unimac-mdio
 
   reg:
-- 
2.7.4

