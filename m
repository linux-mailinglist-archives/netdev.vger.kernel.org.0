Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C38B591B9F
	for <lists+netdev@lfdr.de>; Sat, 13 Aug 2022 17:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239859AbiHMPp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Aug 2022 11:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239845AbiHMPpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Aug 2022 11:45:25 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 103432AE38;
        Sat, 13 Aug 2022 08:45:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1660405487; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=MOtjIfr3lBKlwNsilG+bg0DCAzHQcyUHp/+z2mPnOaIS2vlZKhnT3TXgXX1g6SWVAFtm+Rg6vzG6jUnmJO1rCbk6Qb8kp77uT/s48y9ZZ0dEkkxJwE2UasYboGNsqYGaqC805ao00z3xs6rXT9kBU9cicQSLvmlkOlCOZfmC81g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1660405487; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=QNV0gWhZJF/IPokV0kiDV9FDuQzarKvTyBPl2WTKlk4=; 
        b=dwQMeLCBlwoN7Q2EKTJcNGV539v0IS1wAxjMYgU8Iu3VjJScJO3PWj+xJEAqT4EK60QU2tOk4XGPKVWf0FhPj4G8+eaOaDGBifBRcyUz+JLmvYzAPdpwUlL6A74CbWWTIo1QQDL4MuMJqgOsCQoMDTB5EqCiuLGkXQLcsAfC5EU=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1660405487;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=QNV0gWhZJF/IPokV0kiDV9FDuQzarKvTyBPl2WTKlk4=;
        b=GQoUAq1ej10sAsMAehYwiNxXon7NBe3r8M/KCrDNKfOYjkROWIiJ2pzPUwKTutVf
        rP9LcZIsbOaD03ufVq9m3b01Intt7zY/YZ/XQOUXrw4+f4g44Vrd3ZBqEz+kSZ9Yd8F
        nrjErHOn4jgTINlbqz8pxRt7VfUnxRNi4S28R4NY=
Received: from arinc9-PC.lan (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 1660405486581113.96185653513157; Sat, 13 Aug 2022 08:44:46 -0700 (PDT)
From:   =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Sander Vanheule <sander@svanheule.net>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Daniel Golle <daniel@makrotopia.org>, erkin.bozoglu@xeront.com,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
Subject: [PATCH v2 2/7] dt-bindings: net: dsa: mediatek,mt7530: fix reset lines
Date:   Sat, 13 Aug 2022 18:44:10 +0300
Message-Id: <20220813154415.349091-3-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220813154415.349091-1-arinc.unal@arinc9.com>
References: <20220813154415.349091-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- Fix description of mediatek,mcm. mediatek,mcm is not used on MT7623NI.
- Add description for reset-gpios.
- Invalidate reset-gpios if mediatek,mcm is used.
- Invalidate mediatek,mcm if the compatible device is mediatek,mt7531.
- Require mediatek,mcm for the described MT7621 SoCs as the compatible
string is only used for MT7530 which is a part of the multi-chip module.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 .../bindings/net/dsa/mediatek,mt7530.yaml     | 31 +++++++++++++++++--
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index edf48e917173..4c99266ce82a 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -110,11 +110,15 @@ properties:
   mediatek,mcm:
     type: boolean
     description:
-      if defined, indicates that either MT7530 is the part on multi-chip
-      module belong to MT7623A has or the remotely standalone chip as the
-      function MT7623N reference board provided for.
+      Used for MT7621AT, MT7621DAT, MT7621ST and MT7623AI SoCs which the MT7530
+      switch is a part of the multi-chip module.
 
   reset-gpios:
+    description:
+      GPIO to reset the switch. Use this if mediatek,mcm is not used.
+      This property is optional because some boards share the reset line with
+      other components which makes it impossible to probe the switch if the
+      reset line is used.
     maxItems: 1
 
   reset-names:
@@ -165,6 +169,9 @@ allOf:
       required:
         - mediatek,mcm
     then:
+      properties:
+        reset-gpios: false
+
       required:
         - resets
         - reset-names
@@ -182,6 +189,24 @@ allOf:
         - core-supply
         - io-supply
 
+  - if:
+      properties:
+        compatible:
+          items:
+            - const: mediatek,mt7531
+    then:
+      properties:
+        mediatek,mcm: false
+
+  - if:
+      properties:
+        compatible:
+          items:
+            - const: mediatek,mt7621
+    then:
+      required:
+        - mediatek,mcm
+
 unevaluatedProperties: false
 
 examples:
-- 
2.34.1

