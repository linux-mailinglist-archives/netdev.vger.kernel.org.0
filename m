Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5BF36D9107
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 10:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235685AbjDFICT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 04:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233572AbjDFICR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 04:02:17 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6E493;
        Thu,  6 Apr 2023 01:02:15 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id n10-20020a05600c4f8a00b003ee93d2c914so24735441wmq.2;
        Thu, 06 Apr 2023 01:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680768134;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qh7/8q6ObYiJ8rFG7u0fNoXDSPJQ6AW2HK/HF1hPhps=;
        b=BnHWav7djfJ0AnrN+7BSjt2yjCiUpxrN2syTjNZ6vdv3213viKA4wHb0Vcqzj5m4Vd
         SwmooCnH0nPxRf8nXu6VPgOH8Vkh3oAiDfMYToZTTX5XC7uF0uvkGCe2xaVHsLHCVT6q
         kgYN5DVuxR0T6LpqVa17kk8lND1sgA48HGPnPdB41B4abfnbrHfpMxCwUBwBLrJmimCT
         kJ/6h8yIFb1oxz7P7VBJnrJfEqRHJibSQGtcMNuAoaKMIG3DHSLhICxP6j0YK216xu4t
         DePFP7rcsrsb8/K5H8jtVrJgcXibo0BUFKvmQMZNQZPsSAVmhC5xyQiE8ePgxaU7MZn6
         tNtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680768134;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qh7/8q6ObYiJ8rFG7u0fNoXDSPJQ6AW2HK/HF1hPhps=;
        b=zncueYby89Chs6shbUogQE2Yi908D+vz17w923qfyuLbMROr1ahaDT/4LVH/1ciHjd
         6MeC9pxGm5bYwdUOoP/9rKbbW39j7tT/24IZ8CkkOy6lAcO2ez4df52uGHo3+t8XI+hQ
         6154refoCaNvbenZcsGEvVtdEQ92B3iuJieP7ZMHrVfhS9d5q4/ed/xtSjMRAds2ENua
         RIdJ/1BECEQ81gDfedYSxmoqlr0iJqnGFe31FAdCrNGzY7GtXm1i5HHnEp4FhsCjny3B
         YRUrFYWjBIWnoFQfqiBmInag0zu5dstsKHzePx2qEPWeqalOXnvw8HbVEv2oHVrfVtQI
         UUfw==
X-Gm-Message-State: AAQBX9c/ibD4z1Kmqgt0Pfqli7wkhNAhm4JzJLYwzji+pRvfqbandf3G
        cjow61HfKWTjfsOgsKQrkzQUovwiPUD/0A==
X-Google-Smtp-Source: AKy350Z8BUntUGgaUZ0JsYY0YWX6eYpdtEuArg2Rn3T2ll8NM3bGUndFU79f26oyoEzymFlcIcppzA==
X-Received: by 2002:a05:600c:2312:b0:3ef:6396:d9c8 with SMTP id 18-20020a05600c231200b003ef6396d9c8mr6317377wmo.5.1680768134079;
        Thu, 06 Apr 2023 01:02:14 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id s9-20020a7bc389000000b003ef64affec7sm826993wmj.22.2023.04.06.01.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 01:02:13 -0700 (PDT)
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
Subject: [PATCH 2/7] dt-bindings: net: dsa: mediatek,mt7530: improve MCM and MT7988 information
Date:   Thu,  6 Apr 2023 11:01:36 +0300
Message-Id: <20230406080141.22924-2-arinc.unal@arinc9.com>
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

Improve the description of the schema.

The MT7620 SoCs described are not part of the multi-chip module but rather
built into the SoC. Mention the MT7530 MMIO driver not supporting them.

Move information for the switch on the MT7988 SoC below MT7531, and improve
it.

List maintainers in alphabetical order by first name.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
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

