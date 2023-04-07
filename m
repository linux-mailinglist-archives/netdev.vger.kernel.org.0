Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 651A66DACC3
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 14:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240587AbjDGMug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 08:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240351AbjDGMu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 08:50:28 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9446E95;
        Fri,  7 Apr 2023 05:50:26 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id j11so2556210wrd.2;
        Fri, 07 Apr 2023 05:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680871825;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d2Jx75BdmM1DRIeZU7e7TBMUNuXWgIzSc84P6AFM0gY=;
        b=hZcWa0HFwLeUOYBlBloUEX+Gaq7fM3R9AG4Q0VV839B/i1zN0VBj9/LLXSiAe7Wm8i
         NlJLovn8esr+YA3r2p9QBzTDZtCpCjvoxkZAuTQRdZ8dW/uk+VMvskWOFBr61bGMOf+C
         P+cEpbWt17E14Uda2Tz9uIryMW0StfE31q0EfhYGG94gCqvDvBlAW5/kXQitzd9k1pA0
         9WwvCys+4g6nr42u+6sOjSZeJkQSbp1HLQmBg3vBus5sP2Msozdnt8/nK21NCHdsdEhR
         NZL98Qxy6kkxsaSBHbzQPQhHVC+sQJVlgKAoqVsGHAWLpUQ2lMa99neOIniVOwKFRJ5M
         CsBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680871825;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d2Jx75BdmM1DRIeZU7e7TBMUNuXWgIzSc84P6AFM0gY=;
        b=Myf3VIzoYwsqqzaTmzSSuOWFQxYVe40sncT5FfarGcau0WArRylfT8qehEWT0KN0ss
         +XAnB/VsFC9pDsfHfVnQhaIsQOTmoRA5SKo4aJuIMgLJIQXbuxcsXw0tHmBC9rq9avTQ
         jf49RXb7cYp57JflFggQRIGzrHBBRWyvrkRSjfwnNthBuer2UFPLWRJIsNOp+ro9Ygan
         XyVO/sw08zEqhrNkmAEIv7tGWwuuTjO2QusHXKXkFVds/ezZgWsaK8BfbZ2hFQ/VukDw
         19TeSHunBtZOE8Lr+52dLWubzaIFBRy2EX31lNquqeQ5oBE/VIkGvlQgu4wRTD/e26cR
         fBBg==
X-Gm-Message-State: AAQBX9enqKnDYzercUvMK9ACIOWWRm7jlB+i5+ND7P94z/x7VFlgvdhH
        Kmtk2bBwiU/3xjmC0AShxPI=
X-Google-Smtp-Source: AKy350aDOnsG7tp548bKfnKmtM6qwQHsjisCGHW0Ku6OVLIOs5Mlcs/gY2OHF8QTarpzU8KyH0pYng==
X-Received: by 2002:a5d:5383:0:b0:2d8:82f9:9dbd with SMTP id d3-20020a5d5383000000b002d882f99dbdmr1320495wrv.11.1680871825298;
        Fri, 07 Apr 2023 05:50:25 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id n37-20020a05600c3ba500b003f0652084b8sm8176596wms.20.2023.04.07.05.50.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 05:50:25 -0700 (PDT)
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
Subject: [PATCH v2 4/7] dt-bindings: net: dsa: mediatek,mt7530: allow delayed rgmii phy-modes
Date:   Fri,  7 Apr 2023 15:50:06 +0300
Message-Id: <20230407125008.42474-4-arinc.unal@arinc9.com>
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

According to mt7530_mac_port_get_caps() and mt7531_mac_port_get_caps(), all
rgmii phy-modes on port 5 are supported. Add the remaining to
mt7530-dsa-ports and mt7531-dsa-ports definitions.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Acked-by: Daniel Golle <daniel@makrotopia.org>
---
 .../devicetree/bindings/net/dsa/mediatek,mt7530.yaml        | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index 922865a2aabf..79ddd16e530b 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -188,6 +188,9 @@ $defs:
                       - gmii
                       - mii
                       - rgmii
+                      - rgmii-id
+                      - rgmii-rxid
+                      - rgmii-txid
               else:
                 properties:
                   phy-mode:
@@ -226,6 +229,9 @@ $defs:
                       - 1000base-x
                       - 2500base-x
                       - rgmii
+                      - rgmii-id
+                      - rgmii-rxid
+                      - rgmii-txid
                       - sgmii
               else:
                 properties:
-- 
2.37.2

