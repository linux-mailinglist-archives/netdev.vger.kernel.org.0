Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 042F56D9112
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 10:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235922AbjDFICh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 04:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235913AbjDFIC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 04:02:29 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C3486A5;
        Thu,  6 Apr 2023 01:02:26 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id v6-20020a05600c470600b003f034269c96so13046031wmo.4;
        Thu, 06 Apr 2023 01:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680768144;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RmRk0xNMsCgcrJI+xRy0MzfsEtKexUj93Cn4/6APjX4=;
        b=mPJYOeA/OqyZBFsaE+PJHnSCcxVCH7AsuJcTDA6Kn0cpNisoIlJ53FufnOmcsr5FI+
         GgFkNmFTOFmRJJvdv6zaYXpxWwdSoe8jJPr+X/77ixE0GBzWMGm4uA5lVc8D6lZZE4bA
         OAUMoNbG8sefSz8agTff7mjEdGmwYnHhvvxUx6yHZ2B7RGxVD0ZPusatK/GwRcnIMbmx
         TDDsimNHyUM4HMgCQpBkEw+dmo4UOTOB4tssZZfvO/wXcjqGX0IT/Ge8l4fXPMxlVm9g
         YLfito9EZ96sysUz2LRCXuRj6g0ESA+6HeQUxNHB5wKVtTruB9kjF2DkFYLzfn5Jav2w
         2qRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680768144;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RmRk0xNMsCgcrJI+xRy0MzfsEtKexUj93Cn4/6APjX4=;
        b=y0oB7PowzIpR2o7t3Ug3TpSzFquEPnGB4OlUY1bMy217mvmOxGIt/PJcwJl/9bDo3h
         /HY1rZ9/ZxNT6MbuO3erpk0G1MSbpUDjz8q6VKT30fQaDpfcM4aFiM//WFhWxqRIajul
         tQ8u9x9S8OHQ3fLClQYtyZozahC4ngNzfyV8RRZ26fSaDiCtCTkz+sn+Hkd0QPXLhVOQ
         T1MRVyz6IlB2YkhrfvgP0Yg1qt8CItcBSVwzhSvkAaBz62X6zAnF0kK/HwzeXD7F4spu
         taSqdk0wseP+7kBesJwvDJ5m7iKi/musfvRlmJt8Abgn9wM+yc+f2DeNKJSMhDjA21WP
         zHfQ==
X-Gm-Message-State: AAQBX9cWdiHOWoEMC2ZUlkvDT4RPRvhXB+Z0qMzRzI0kIhKsKVKle5+h
        UdHC2sOCABGB/WrsBMCKaMo=
X-Google-Smtp-Source: AKy350YR8IyuUclg8HySvJg9M4xWTYXQw+ShkQu/tly5qXQdseVIwZ8mZF6V3eJiL+2q4c+B/TqXQA==
X-Received: by 2002:a1c:790c:0:b0:3ee:7022:5eda with SMTP id l12-20020a1c790c000000b003ee70225edamr6859209wme.7.1680768144497;
        Thu, 06 Apr 2023 01:02:24 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id s9-20020a7bc389000000b003ef64affec7sm826993wmj.22.2023.04.06.01.02.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 01:02:23 -0700 (PDT)
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
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 6/7] dt-bindings: net: dsa: mediatek,mt7530: disallow core-supply and io-supply
Date:   Thu,  6 Apr 2023 11:01:40 +0300
Message-Id: <20230406080141.22924-6-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230406080141.22924-1-arinc.unal@arinc9.com>
References: <20230406080141.22924-1-arinc.unal@arinc9.com>
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

The core-supply and io-supply properties are used only on hardware that
uses the mediatek,mt7530 compatible string. Set them to false if the
compatible string is not mediatek,mt7530.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 .../devicetree/bindings/net/dsa/mediatek,mt7530.yaml          | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index 3fd953b1453e..0095b7fcef72 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -299,6 +299,10 @@ allOf:
       required:
         - core-supply
         - io-supply
+    else:
+      properties:
+        core-supply: false
+        io-supply: false
 
   - if:
       properties:
-- 
2.37.2

