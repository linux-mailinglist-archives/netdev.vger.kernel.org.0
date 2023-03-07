Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6E6F6ADB30
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 10:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbjCGJ4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 04:56:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbjCGJ4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 04:56:30 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 874E33C02;
        Tue,  7 Mar 2023 01:56:29 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id t15so11497381wrz.7;
        Tue, 07 Mar 2023 01:56:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678182988;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=84FgM/FVnZP1rWfRH7Rix7KO0TYKL81ghGqMfAMNH9w=;
        b=eFq2KyyTn/QGbH4BM+M5/FmPPuIzwcnCVqRLo0zYV0sSvg0+tGAXHazl9KWmkCiEk7
         WLxBQGPM1bsojnZFEfY05aoyYIowBdtL7gvKFGicwSButTOpEAtuuHkrMFeD+eD8Klan
         NdqhQg/D2dRkKMgFlznZJKJGQ5CoqGW4LT6C1ba5BWTb4BJIzK9UgtkM9SnCWanWSvFj
         rMaJv4lgSFarm8UCE75p7YU+VSaqMYX2LuauciLfGmDju/NpFRuYbs8kp+P7A0T8vRMV
         WfS7+i5w/B2y/xdSTIk5fueA0qAtWpB/CXyMNhx9agQR91DnsS0d2j7fqbU0wNX0zqn7
         Oo7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678182988;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=84FgM/FVnZP1rWfRH7Rix7KO0TYKL81ghGqMfAMNH9w=;
        b=3Ao/+ax9fShSOn67S9rvWXqi9IOb66lZOQJbvd7sEzWA4QyE5YHzG8J3/NaQDj+jmH
         1vofvahgVPFL0uFoms2McJ9oJkaj/i7ihSMJusHy6auR32CuwoUl+8BRPhjXjDOaE+/O
         xqDewZQh5MAGcCwhwIsJRhtRYAEACx70j022K+mwhWJHCB8vLKyCNvVCZprt/IufFK+p
         yxp++V4cJv1+L6IAgXIIT867M0FORH6og57BdN4Avkp4hXRG5Ad0cRRoBni0I3sM+bZd
         bIo889jYSM3diw77xRj4tFhb06L8LkqlXPVRGpoDHii2+tjptwLmlpBZ/cY1+vsNRuXG
         4TVw==
X-Gm-Message-State: AO0yUKXW4qAH7W74T6nXbOMDCA0lJ3VdAOkjUdsEEbXWr+mOkIjLP1al
        ETqTeCP8rigy0FMDTT+VGxo=
X-Google-Smtp-Source: AK7set+2oqnqS/Vy/l7T728/Cs+NBndVQPWOONRki7dYNYfEOCQKVhTw2lodMf9LsijyuBXftEBKqw==
X-Received: by 2002:adf:f58b:0:b0:2cc:4dac:fe3e with SMTP id f11-20020adff58b000000b002cc4dacfe3emr9457600wro.62.1678182987854;
        Tue, 07 Mar 2023 01:56:27 -0800 (PST)
Received: from arinc9-PC.lan ([212.68.60.226])
        by smtp.gmail.com with ESMTPSA id s10-20020adfea8a000000b002c7e1a39adcsm12257203wrm.23.2023.03.07.01.56.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 01:56:27 -0800 (PST)
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
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>
Cc:     =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Rob Herring <robh@kernel.org>, erkin.bozoglu@xeront.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH v2] dt-bindings: net: dsa: mediatek,mt7530: change some descriptions to literal
Date:   Tue,  7 Mar 2023 12:56:19 +0300
Message-Id: <20230307095619.13403-1-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arınç ÜNAL <arinc.unal@arinc9.com>

The line endings must be preserved on gpio-controller, io-supply, and
reset-gpios properties to look proper when the YAML file is parsed.

Currently it's interpreted as a single line when parsed. Change the style
of the description of these properties to literal style to preserve the
line endings.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Acked-by: Rob Herring <robh@kernel.org>
---

v2: git send-email doesn't like --from "Name <mail@mail>" but --from
mail@mail, got it. I also got to fix wrong submitter name for my gmail
address on patchwork, sorry for the noise.

Sending again now that net-next is open.

Arınç

---
 .../devicetree/bindings/net/dsa/mediatek,mt7530.yaml        | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index 449ee0735012..5ae9cd8f99a2 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -93,7 +93,7 @@ properties:
 
   gpio-controller:
     type: boolean
-    description:
+    description: |
       If defined, LED controller of the MT7530 switch will run on GPIO mode.
 
       There are 15 controllable pins.
@@ -112,7 +112,7 @@ properties:
     maxItems: 1
 
   io-supply:
-    description:
+    description: |
       Phandle to the regulator node necessary for the I/O power.
       See Documentation/devicetree/bindings/regulator/mt6323-regulator.txt for
       details for the regulator setup on these boards.
@@ -124,7 +124,7 @@ properties:
       switch is a part of the multi-chip module.
 
   reset-gpios:
-    description:
+    description: |
       GPIO to reset the switch. Use this if mediatek,mcm is not used.
       This property is optional because some boards share the reset line with
       other components which makes it impossible to probe the switch if the
-- 
2.37.2

