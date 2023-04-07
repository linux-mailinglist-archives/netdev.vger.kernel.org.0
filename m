Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7709A6DACBF
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 14:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239298AbjDGMu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 08:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235110AbjDGMuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 08:50:24 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5CA061B2;
        Fri,  7 Apr 2023 05:50:22 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id eo6-20020a05600c82c600b003ee5157346cso778150wmb.1;
        Fri, 07 Apr 2023 05:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680871821;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BhBtxDtSz4bH7TbpHPVA9FnwXJmNesfBIN2Sp8mydaA=;
        b=VMxkrT7qvXhqqRG7V6RDlV9gwWNBpUI1gCouk5IpwxbSAW+6uZ1cJ6dPxDZ2jxheeE
         Mck1FjSAyxcAvRrlJ4g5Q7r7dcmikNMbMrh5aBIkOqx8bmhlgzC111MBUk4ts6luURtN
         WCXvuUvPaTpuWLXaPmhn3kddiwrLbpcKkbS2iKnHWvKVu648mhC9/3yGfPr8VSJ9oca3
         WeIrXuPN1gcH65YSjv5JQ43Q9ZdxNvq0H8I3fRMGmAsb+ZkvOmhT04vegdUZLR6OyuuZ
         HtDNlBGkp6oZHk+dNPXrNnNplkWeQrCF83aZejrFayq2EztMgyXjuDQnOwa2+H4/PHO9
         aA/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680871821;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BhBtxDtSz4bH7TbpHPVA9FnwXJmNesfBIN2Sp8mydaA=;
        b=vdEJEukpb4JLhWBLroJX9RXXw/IDilbHIHpD/r9xB8azyt57vWfs6L+m+j3pQaXUJg
         lvNOIbxeapnJ7m4TLPGFTOTUC2YPY67fb+nCPuOCwwJFXKInxZ6BQwq8DBGCTwXuMBzT
         yupCbTteTm62y/K/ZwLsytGFdKwVO7O/n2XORr7rc8rh39G+ljPh+DYKjuLjhEAhAVpz
         QJrC3wVFpknK3HOX+Tjgq+vgChg0vA2FGpRP09oooOcn3MNbb+C5q8PqQGaoCL5gY8nt
         G4BENEVuo+cKsMmKXWSEuuazjCrbyBIaZ205xlCYJC31ywsnE1pYWNCPPCFPAjUyo5qA
         IYWg==
X-Gm-Message-State: AAQBX9fCrIHy7DAAd7LgqCxwqR/c7eOm/SydnTA9bA4Sego9KxlfEEov
        U3IH6rUrDNIA9BMslXfKmcc=
X-Google-Smtp-Source: AKy350aP+Zz+P6Ae0/eMi3ClAC6lpFOkTb8pPG5GtRkLI+FW+xHkQ4WoadPWcXIdrsg760lMm4uQIA==
X-Received: by 2002:a7b:c04b:0:b0:3eb:3104:efec with SMTP id u11-20020a7bc04b000000b003eb3104efecmr1160754wmc.16.1680871821214;
        Fri, 07 Apr 2023 05:50:21 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id n37-20020a05600c3ba500b003f0652084b8sm8176596wms.20.2023.04.07.05.50.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 05:50:20 -0700 (PDT)
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
Subject: [PATCH v2 2/7] dt-bindings: net: dsa: mediatek,mt7530: improve MCM and MT7988 information
Date:   Fri,  7 Apr 2023 15:50:04 +0300
Message-Id: <20230407125008.42474-2-arinc.unal@arinc9.com>
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

Improve the description of the schema.

The MT7620 SoCs described are not part of the multi-chip module but rather
built into the SoC. Mention the MT7530 MMIO driver not supporting them.

Move information for the switch on the MT7988 SoC below MT7531, and improve
it.

List maintainers in alphabetical order by first name.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Acked-by: Daniel Golle <daniel@makrotopia.org>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 .../bindings/net/dsa/mediatek,mt7530.yaml     | 25 ++++++++++---------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index 6df995478275..7045a98d9593 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -8,29 +8,30 @@ title: MediaTek MT7530 and MT7531 Ethernet Switches
 
 maintainers:
   - Arınç ÜNAL <arinc.unal@arinc9.com>
+  - Daniel Golle <daniel@makrotopia.org>
   - Landen Chao <Landen.Chao@mediatek.com>
   - DENG Qingfang <dqfext@gmail.com>
   - Sean Wang <sean.wang@mediatek.com>
-  - Daniel Golle <daniel@makrotopia.org>
 
 description: |
-  There are three versions of MT7530, standalone, in a multi-chip module and
-  built-into a SoC.
+  There are three versions of MT7530, standalone, in a multi-chip module, and
+  built into an SoC.
 
-  MT7530 is a part of the multi-chip module in MT7620AN, MT7620DA, MT7620DAN,
-  MT7620NN, MT7621AT, MT7621DAT, MT7621ST and MT7623AI SoCs.
-
-  The MT7988 SoC comes with a built-in switch similar to MT7531 as well as four
-  Gigabit Ethernet PHYs. The switch registers are directly mapped into the SoC's
-  memory map rather than using MDIO. The switch got an internally connected 10G
-  CPU port and 4 user ports connected to the built-in Gigabit Ethernet PHYs.
+  MT7530 is a part of the multi-chip module in MT7621AT, MT7621DAT, MT7621ST and
+  MT7623AI SoCs.
 
   MT7530 in MT7620AN, MT7620DA, MT7620DAN and MT7620NN SoCs has got 10/100 PHYs
-  and the switch registers are directly mapped into SoC's memory map rather than
-  using MDIO. The DSA driver currently doesn't support MT7620 variants.
+  and the switch registers are directly mapped into the SoC's memory map rather
+  than using MDIO. The MT7530 MMIO driver currently doesn't support these SoCs.
 
   There is only the standalone version of MT7531.
 
+  The MT7988 SoC comes with a built-in switch with four Gigabit Ethernet PHYs.
+  The characteristics of the switch is similar to MT7531. The switch registers
+  are directly mapped into the SoC's memory map rather than using MDIO. The
+  switch has got an internally connected 10G CPU port and 4 user ports connected
+  to the built-in Gigabit Ethernet PHYs.
+
   Port 5 on MT7530 has got various ways of configuration:
 
     - Port 5 can be used as a CPU port.
-- 
2.37.2

