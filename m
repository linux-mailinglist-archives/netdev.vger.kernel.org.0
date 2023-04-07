Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98F116DACCD
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 14:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240768AbjDGMvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 08:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240351AbjDGMus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 08:50:48 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC557AF03;
        Fri,  7 Apr 2023 05:50:33 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id gw11-20020a05600c850b00b003f07d305b32so389054wmb.4;
        Fri, 07 Apr 2023 05:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680871832;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dLHvO2FfplQIRzVomYcprC2rvpDUKXpOVap/nUAtaf4=;
        b=XQt55Q3+7ebyW5LUhFMC4lVpV49B6vOtP6SDdNgq+QoR4bIsNLEE0/us9p504H8vt1
         6avl8+8a1S3mTOdAkKbRBIPD/FO7E8HGngWPeKV3/x71qGasONJNQeeUL8mtqqNFRkCp
         SyKTTFgOaaZC20DTNFiltuszp2fZnmNtrFYUxS8aesPH7tP5F16h++VQxtxNKyb6Xcel
         RcsKQh+n+03VWbtQGKzzQNyCVZJQmd7garR9MEju6xX/51d4pF7fJfPPQkhmILDv8TFO
         8GZQPNQnICnpTK5bWFhs0oXkzvJX6aeGljhXaC2MygC45km4gKlUEJuEeKTx0q/Ynw/F
         KPcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680871832;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dLHvO2FfplQIRzVomYcprC2rvpDUKXpOVap/nUAtaf4=;
        b=sl6HcYomfv51KkyZLr/tC04lgv0jg8TQw9ZfX3P53ZmARUioI7hP0uz3gz5o0WSSOG
         orDT9DV9mw5lkFF2pLU5mrVjxOVt6dpcefO1JOFBt5bgJjnbKXuidd7BvUcBWGRsgSNh
         rA6WvLya9GPRHhpZ13ZMVu6FTXNjL9hhd9IUPYa/+lOgOBTLG6/xvjBlGLqs5zjEyqkp
         ryeRPz9t702+5B70nn7wcH7WrDlEdSaXS3/xy6h9BBMBKb8vu3P7q2TnHexGJXi1Z6Va
         uIQrqxoE10qQA5uHEyUvGgHnwXNoh1CBLSWeaY29i3NdzIKwZA57nF5IcsAhE4NafvqH
         IP+g==
X-Gm-Message-State: AAQBX9e1ZvCZFui9ammEZnOC6j28OrTUgWHMpwsA02XlVDxloMGjgbzN
        P4JUrJa9EAJa5JPiJXu+9AA=
X-Google-Smtp-Source: AKy350YtsYxuyrbQ3Bd05zHmURZtqmHFghRDkFAgzc2WJ+jhxRWD4RZIe1RArSGHTemJx6ZplJl6SQ==
X-Received: by 2002:a1c:6a1a:0:b0:3eb:383c:1870 with SMTP id f26-20020a1c6a1a000000b003eb383c1870mr1353860wmc.11.1680871831686;
        Fri, 07 Apr 2023 05:50:31 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id n37-20020a05600c3ba500b003f0652084b8sm8176596wms.20.2023.04.07.05.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 05:50:31 -0700 (PDT)
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
Subject: [PATCH v2 7/7] dt-bindings: net: dsa: mediatek,mt7530: allow mediatek,mcm on MT7531
Date:   Fri,  7 Apr 2023 15:50:09 +0300
Message-Id: <20230407125008.42474-7-arinc.unal@arinc9.com>
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

Allow mediatek,mcm on MT7531. There's code specific to MT7531 that checks
if the switch is part of an MCM.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Acked-by: Daniel Golle <daniel@makrotopia.org>
---
 Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index 3b85063d5b5a..71ae431c61d1 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -304,7 +304,6 @@ allOf:
       $ref: "#/$defs/mt7531-dsa-port"
       properties:
         gpio-controller: false
-        mediatek,mcm: false
 
   - if:
       properties:
-- 
2.37.2

