Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59DD06DACC7
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 14:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240684AbjDGMus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 08:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240535AbjDGMuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 08:50:35 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48366AF35;
        Fri,  7 Apr 2023 05:50:29 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id v20-20020a05600c471400b003ed8826253aso4577060wmo.0;
        Fri, 07 Apr 2023 05:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680871827;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Ur5gBAQUU5sWkYwoSsgIt09ft/hZck63dNnALmT94k=;
        b=jmvLvlSuptupcp8j/tpJaul5eWm4fGvzbfGMuWKm2lEUq8411XoYEJK5VMyg+S5FFt
         TjuZGCLe30zV4PkL/yCQzNQmmN00nSbINDsnQPOaTcjBK0B5/AAogmRdiJLjfiPbv9o+
         WVO9o3NyW9h+lmQlzw4eeTi/XPEHlEgMemwsoq+TKAOuSXYt/5kqjaTPCqCfsXCewN/z
         TN8n2RJF3V3q1Igjm0oaaau5wMgYwqps7laLiP3Ym+UhDtkuaVgy3FNneYVtAXTQB4HA
         7KTTsKztjnVlXvdu/6ZvDUARAo5qW+HL6UtjpR2wRNyHXzx9ttq5S6qgiDm4Ec/YrNWb
         APnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680871827;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8Ur5gBAQUU5sWkYwoSsgIt09ft/hZck63dNnALmT94k=;
        b=ZC3g0A5lJ/O+3xjPBpz5BM4ZxkJ7tQx0pMkVQojIlLZWkqML35XPIVUjVT2yvu3b9X
         xBxL1X7ff6pfXfWDwuSMDfBNNGVNt8hLRQ8Iuc505Sa7evn7XzQszYo0vpwym2kffP5J
         +yhszRku13RZZFXX9cAOAh/ji0Ep6bD44z1TzQOhybrxMbIUaKEoAQoKcTX9VN4MWnwY
         b3sSQzsCMI+CFZHftjHEQDSQRdex2ax0cy/KgK+tmH8CXr65W3WNnnnOz3jLoahrYSu6
         lpG86/w8LE1b/69cQ9min3p79oyVnOBAZCQDgJXPBS9Spur4GCSwTPbiJOOh4ItCqhRJ
         S5vg==
X-Gm-Message-State: AAQBX9e8UyRLjCeyE10iPXk9E49ZXxh2VjC685Y+2iI5FnGW+nJRLmPI
        r+xFhlDvWnR2Hl305z/sllJaTcUCKdZlQA==
X-Google-Smtp-Source: AKy350Z1cjauAcBYmc41Vrlz4XKvFh5rNTJy7A3QvYqcUzeBpe3Yy0sjgBW5eKKQw0VJPdb3knNE6g==
X-Received: by 2002:a1c:f609:0:b0:3ed:316d:668d with SMTP id w9-20020a1cf609000000b003ed316d668dmr1176048wmc.5.1680871827427;
        Fri, 07 Apr 2023 05:50:27 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id n37-20020a05600c3ba500b003f0652084b8sm8176596wms.20.2023.04.07.05.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 05:50:27 -0700 (PDT)
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
Subject: [PATCH v2 5/7] dt-bindings: net: dsa: mediatek,mt7530: disallow reset without mediatek,mcm
Date:   Fri,  7 Apr 2023 15:50:07 +0300
Message-Id: <20230407125008.42474-5-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230407125008.42474-1-arinc.unal@arinc9.com>
References: <20230407125008.42474-1-arinc.unal@arinc9.com>
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

The resets and reset-names properties are used only if mediatek,mcm is
used. Set them to false if mediatek,mcm is not used.

Remove now unnecessary 'reset-names: false' from MT7988.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Acked-by: Daniel Golle <daniel@makrotopia.org>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 .../devicetree/bindings/net/dsa/mediatek,mt7530.yaml         | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index 79ddd16e530b..b5db0f50aa59 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -274,6 +274,10 @@ allOf:
       required:
         - resets
         - reset-names
+    else:
+      properties:
+        resets: false
+        reset-names: false
 
   - dependencies:
       interrupt-controller: [ interrupts ]
@@ -316,7 +320,6 @@ allOf:
       properties:
         gpio-controller: false
         mediatek,mcm: false
-        reset-names: false
 
 unevaluatedProperties: false
 
-- 
2.37.2

