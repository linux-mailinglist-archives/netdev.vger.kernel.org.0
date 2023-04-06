Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 177B46D9104
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 10:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234703AbjDFICP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 04:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233572AbjDFICO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 04:02:14 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F09C93;
        Thu,  6 Apr 2023 01:02:13 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id he13so2523225wmb.2;
        Thu, 06 Apr 2023 01:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680768132;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ICl5yXhMxeO2u+7yTPtP7Jl3u4X7NhJCydXnMv94CdE=;
        b=it8N5epu/hXZbHWuT1hr22stKIGl0pvvUn+gedunaw90tc0hnlroPv6UR0rKExvyi+
         /5HNW3X0Ey7HHnOjoxPAscBmzuT17opVmLbvKHPbxAl711L9R07V1KEsXUGg5vV06HuO
         bZ5kFMF6w8bZZU7YwUoTdeLRR+lD6jPKd+bCJ0Qr9B2qnZCTYFvuKmQuq7v9J6HYVtc8
         qkmBat7UPxpQ5MPXBkDfZJG9DUV0RANmcXSYDpJEtxYvai9w9ZpVQtUP5ezdt5QNVT8x
         JJDinsYCQ0vLm1/73RGpI1qYadaH2rbnLSSsb6axGuq/3jwX5U27iIUFZhCW0uqGJmsL
         jPxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680768132;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ICl5yXhMxeO2u+7yTPtP7Jl3u4X7NhJCydXnMv94CdE=;
        b=MNIwDTlkxwvxD7SGwjUSKxmRuzgkRz46OpsJReivAnBnkG7zCxSZNQ2w1qvQzX2J7s
         NoNCTqE4EXJcLWSvoyK4jcBaSAVo/zEIwwOsl3Cv6isjpHGZmtRJ5276v3j9bFmr87m+
         BohRjbpMbxZnMA14JE9pd2LJIRnJnbo1re+RbXWpfy7fD9Zf1BuPsvM1/aG/uYb92O1r
         uqODYET6lvpgSTHc+f3qHISrSiU7/PUBAR9vpKj5726OEDDq8K3pchm1mc32KNx6jv8b
         dUkGpvG/TTJP9nzdHvWi6eQ2yeqw7dzBaXEwO675mqGz+Xgsa+XvHd/O06rrb4WHQSbO
         Dg0Q==
X-Gm-Message-State: AAQBX9fQSKlox2wJhOQOefK+GmLkluBiiHnYdn0nl/KR4X5BbckU/ugh
        RpSURSuQZdDLXfJhLyiYLks=
X-Google-Smtp-Source: AKy350a/F/lBPdvFizmroFVH3fzHbWGMlo4ft4HctNyHW+b1LaJS8K92j1zaDn1g279tfeuONBh+TA==
X-Received: by 2002:a7b:ca47:0:b0:3ed:1f9c:af12 with SMTP id m7-20020a7bca47000000b003ed1f9caf12mr6967575wml.22.1680768131483;
        Thu, 06 Apr 2023 01:02:11 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id s9-20020a7bc389000000b003ef64affec7sm826993wmj.22.2023.04.06.01.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 01:02:10 -0700 (PDT)
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
Subject: [PATCH 1/7] dt-bindings: net: dsa: mediatek,mt7530: correct brand name
Date:   Thu,  6 Apr 2023 11:01:35 +0300
Message-Id: <20230406080141.22924-1-arinc.unal@arinc9.com>
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

