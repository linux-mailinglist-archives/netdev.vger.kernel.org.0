Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2FF6ADAEC
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 10:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbjCGJu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 04:50:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbjCGJuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 04:50:52 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42254488;
        Tue,  7 Mar 2023 01:50:18 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id p23-20020a05600c1d9700b003ead4835046so628303wms.0;
        Tue, 07 Mar 2023 01:50:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678182617;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yl2mpHuveUP7tQhvAv3v7QFO0cT2TOycTTxsdGGCBaU=;
        b=DO0/ionGVI+UCkpAP0wJ0Ky4zV5JZ4ipAfi4ou5qX9KaKgTXlOUNeMIgPkPYsBxbOe
         SSPbbBpHSWxw3H61cawOk/3Rwl/9yI2a9bKwMwMCkCME5LBo4v8O5l5GRX+vCsf28I9K
         uPtXvVhfmyyRqIO9AlF8RyoIEQqd1SttVIyCAIl8yAuOVsLHymKx55pNRaenW4JK83Ot
         rmvILk6HMWy0cuAptYPwIeFc94YchYKy8pCZHgydZSA4ok0PyccCb23MN/QaSyWz6nMP
         dyElaKAXnPTDZKYZaEfBJiXFyX1y4kLF/1N3zYP6hT3vgDdOxLw8AO7mdXTDspYE8coj
         tw0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678182617;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yl2mpHuveUP7tQhvAv3v7QFO0cT2TOycTTxsdGGCBaU=;
        b=k8GWY0bMignN7OoxT5RGG0BUjOo/Usrdi+cbA/nwjVNWSsW9V/IFRYoKiri6mpcppm
         3TZiMCQPL+f/mI5kKjslj5gU41gEDvf+ygUl9IOEDioo20yKsbQW5YxYgZKfRnMV9tF9
         jCHs65s/Pq4l+f08ryeYlr5VjnLmdQ8LcQIgQKv6aYP+s3KwPhFaRucE5BZiNZ2sUWvk
         yv4CkX/CZjwMoaSYOQ0/3Zq5VkuLObtjb9hqlh+VPV3m3lhGj6u6+m+/yvEpV2VKn4L+
         tWlO9rAlf0SRXrVefpAOA+eyrUbgjKfOgFdybzF37YZ6ZszoN7kzjBLB3RRHJTHr+ZWT
         i1kg==
X-Gm-Message-State: AO0yUKWzCFH/CDKEKbndckqyM7b/QIeqK8xsOOsrNscf6WvfCzST3DOa
        CRVo8et7A/iTr2Z+8f/HZAw=
X-Google-Smtp-Source: AK7set/ppE7inaeTkWIv4ddlbRUVSqik1YeZrdxSZaUZnn15JQHNkAkVC05c0k8FepeErWjWwG5+ew==
X-Received: by 2002:a05:600c:a01:b0:3eb:29fe:70ec with SMTP id z1-20020a05600c0a0100b003eb29fe70ecmr13133009wmp.27.1678182616641;
        Tue, 07 Mar 2023 01:50:16 -0800 (PST)
Received: from arinc9-PC.lan ([212.68.60.226])
        by smtp.gmail.com with ESMTPSA id o6-20020a5d6706000000b002c573778432sm11841451wru.102.2023.03.07.01.50.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 01:50:16 -0800 (PST)
From:   "=?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?=" <arinc9.unal@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
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
Subject: [PATCH] dt-bindings: net: dsa: mediatek,mt7530: change some descriptions to literal
Date:   Tue,  7 Mar 2023 12:49:48 +0300
Message-Id: <20230307094947.12450-1-arinc.unal@arinc9.com>
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

The line endings must be preserved on gpio-controller, io-supply, and
reset-gpios properties to look proper when the YAML file is parsed.

Currently it's interpreted as a single line when parsed. Change the style
of the description of these properties to literal style to preserve the
line endings.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Acked-by: Rob Herring <robh@kernel.org>
---

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

