Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D46316DACBB
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 14:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbjDGMuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 08:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbjDGMuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 08:50:21 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA3E61B2;
        Fri,  7 Apr 2023 05:50:20 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id m6-20020a05600c3b0600b003ee6e324b19so25165946wms.1;
        Fri, 07 Apr 2023 05:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680871819;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PvJDsmC2qYd1pgQ85lBs960eVGMLB3x0B1T+4QHFB/Q=;
        b=or7WakKRtDQDG/fo28VWWqQ07MrMmoabczFnS36b+Yv6/y2tULbns4a+2N+gTqVBXc
         BGw/C7SSv9esONmfQEAH8t8CiBBHYzU/725u/zfpeIqD87qN7w8FOkQsyamZbQC2Q8Ay
         p0Hb+asWzOzTdnTxhTwIZGsEJs3HcInQzDFJd5bvel6mc0MswbuKG7n8D1LiTG/a4wj9
         rGbbl81d393pX3y/1rZCSUmO3dQEfCWywNUlW0eZNf1jEwYZHlOn5oi+h4pEvMNoGcy3
         kZNc1koD34agwDKSTG2GqqzB7w+9KKdjRB+lO5fJcjkk0PcgcxtC3/wNv0kHf90ixWcg
         cP2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680871819;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PvJDsmC2qYd1pgQ85lBs960eVGMLB3x0B1T+4QHFB/Q=;
        b=4Giqpm5qatGYrl5eH4aNYotwMC6HxmfzPCF53fkosQTQ3t7iEbUf/5qeL0t1jUaD2D
         MUxBgi/mgDhUh4fbgrB9ZNpO5hRcoRGWXyAea6TlqFqmnMUV5uXEx+FAJaUQ7HFxjSV5
         ZSMqLJk3bf37wEWMFoayUmhoDFLQzer6jrM+WoQnPZjD2EJavn5U3ZA5dhZGPeBz/J0c
         W1nLgdpkxK4fcMaX3AJFPngC8DRrLPXp2UUvYqFpeh1Bw+/KUKpwMX759PJrlySmuktx
         1dZbYDFBTXR7f9OTuRkP5c1NaK++SzKTLpwO/YNI9uPsJ9FbNXBZXhjgSkhUhckkreux
         JOFg==
X-Gm-Message-State: AAQBX9fnP+kY28GxioG2xIKUgO5aTUZrRndtBxWmMQ+kr2CdiaoqBJex
        Nbe0LRyXQFaU4uC8PT96v0S2vG/UYjVMEw==
X-Google-Smtp-Source: AKy350Y38LWAG0Pi4Cy7ceE+yBoIdK/XagcUtp+HxL2q1jU0J/A1wR05OD7xPN4j1W40G6jbzPlkQg==
X-Received: by 2002:a05:600c:2296:b0:3ed:358e:c1c2 with SMTP id 22-20020a05600c229600b003ed358ec1c2mr1164737wmf.18.1680871819058;
        Fri, 07 Apr 2023 05:50:19 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id n37-20020a05600c3ba500b003f0652084b8sm8176596wms.20.2023.04.07.05.50.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 05:50:18 -0700 (PDT)
From:   arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>
Cc:     =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH v2 1/7] dt-bindings: net: dsa: mediatek,mt7530: correct brand name
Date:   Fri,  7 Apr 2023 15:50:03 +0300
Message-Id: <20230407125008.42474-1-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arınç ÜNAL <arinc.unal@arinc9.com>

The brand name is MediaTek, change it to that.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Acked-by: Daniel Golle <daniel@makrotopia.org>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index e532c6b795f4..6df995478275 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/net/dsa/mediatek,mt7530.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Mediatek MT7530 and MT7531 Ethernet Switches
+title: MediaTek MT7530 and MT7531 Ethernet Switches
 
 maintainers:
   - Arınç ÜNAL <arinc.unal@arinc9.com>
-- 
2.37.2

