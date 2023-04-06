Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD7046D9111
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 10:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236042AbjDFICd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 04:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235826AbjDFIC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 04:02:27 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC0D7EC0;
        Thu,  6 Apr 2023 01:02:23 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id d11-20020a05600c3acb00b003ef6e6754c5so19624591wms.5;
        Thu, 06 Apr 2023 01:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680768142;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WPfB86t+nbjtQNmGqonvhYdyRwayc+B/NfmEAcnxhaY=;
        b=gDOU9qcSBn5YF586j9L2PcoNM2JnU+QiRJv01Cf+abyOI5XBvMdDVBl/RXCleLpqD8
         +p4uNaXMHKa17Vz6kOTtHzHCu0Fli6Yo/pVJDwRWKMlz+NYcRcXqd/ACtkw/4hcQ2qPp
         rI0ZNsmjuF5EtZ1h90CjejIlK7o2t8TQczn2gAUsKMNXQS1MxkiPIaz7CABkIkMoUGWV
         v3r7njOe720uKsZjHEbz+Cr13leaPJGg8R+izEAlmtKUofV2Ldy+8ovA+hQCXYlwlmi2
         4Cbs6OelciOyWR9iO/zEAgPCZrXhiBJYD4z4acnXBPcFKlZy2222fGH0GR3YRhSaJfJZ
         7KAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680768142;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WPfB86t+nbjtQNmGqonvhYdyRwayc+B/NfmEAcnxhaY=;
        b=c6vBoG+Ur5Cm2djlqFcDwlUMJs5kBmVS/07M7Vf3NFPwI92hyHI9tC9S6j3km2a+wU
         f1QyPrqr7PZgbWNLNL4+jp7ZXYrgGAE0PBCi/O7kxnA9m2RmOP5qQtMvVIyiXZpxT9JO
         CXSoDW4zRlY4YuZo/0+cwk48S3kO4S/YnOpqqi/KQL2nyZmW8d3a/vyG8kZwQCmGuu/g
         dezzF1soWQp69PenrQcTHx7ikuUjI9rGTwpFtDAXdjEBv7hCdeUlSOlyHiw8SfM+S/Yl
         8O1yfxjp+AtYTP4kZnSbAYYzKIj8KHnlzN4XPH4YR6cDRVlRpQUqCWb+o/0Qpi+hs/Sn
         7eCw==
X-Gm-Message-State: AAQBX9c0PuavIYRnq1I0g6tRDrsAHgKKiccVtbXGevTcbrSGg2+m886S
        tmoBtmMB0Rd3MNk0Wrw3law=
X-Google-Smtp-Source: AKy350b4aoIYcpf6jCSqmpCE9htfsTH/GIbFV9cCyChDpC1YQ8GkUjnVJ8aijJvGqy4Ee0cnZKxxMg==
X-Received: by 2002:a1c:790b:0:b0:3ed:2b49:1571 with SMTP id l11-20020a1c790b000000b003ed2b491571mr6195603wme.20.1680768141695;
        Thu, 06 Apr 2023 01:02:21 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id s9-20020a7bc389000000b003ef64affec7sm826993wmj.22.2023.04.06.01.02.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 01:02:20 -0700 (PDT)
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
Subject: [PATCH 5/7] dt-bindings: net: dsa: mediatek,mt7530: disallow reset without mediatek,mcm
Date:   Thu,  6 Apr 2023 11:01:39 +0300
Message-Id: <20230406080141.22924-5-arinc.unal@arinc9.com>
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

The resets and reset-names properties are used only if mediatek,mcm is
used. Set them to false if mediatek,mcm is not used.

Remove now unnecessary 'reset-names: false' from MT7988.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 .../devicetree/bindings/net/dsa/mediatek,mt7530.yaml         | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index 9d99f7303453..3fd953b1453e 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -282,6 +282,10 @@ allOf:
       required:
         - resets
         - reset-names
+    else:
+      properties:
+        resets: false
+        reset-names: false
 
   - dependencies:
       interrupt-controller: [ interrupts ]
@@ -324,7 +328,6 @@ allOf:
       properties:
         gpio-controller: false
         mediatek,mcm: false
-        reset-names: false
 
 unevaluatedProperties: false
 
-- 
2.37.2

