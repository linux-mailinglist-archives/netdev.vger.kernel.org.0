Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0716585AB7
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 16:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234460AbiG3O1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 10:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231472AbiG3O1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 10:27:46 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9BEBF59A;
        Sat, 30 Jul 2022 07:27:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1659191217; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=k7AD4oZfgUgnBoUmRly/rpZx+/u1I/Tk8GB8KMIqPkYwovK96FaVLZxSpp786cdbtJSsElEDh+y3hXJCPbjJyY9jTJVFBgku+dORbwCLt9ZIzyfnB5rORdX2wH7UIZC/UJP7FOv7ileiwIpmGJH5nn5ErIYILt0HD85qfw3D4To=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1659191217; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=T9IjTJcjihkHFFN5KVJgnWvnqo9eLDcviRSrTl9a0H0=; 
        b=Wh/L/Ttv85JP+iYVLAqmsB+SIoy100UJReUlmC08WsIEYbhKmxNCPzm7y7/0wVAxGivvweHf7kUDZiaLvZxb/vJK88d6Iub7wcHfmNUUyDdIXxYf8HPoJHRCnQxPFA4hJtnk+V2iHQNua+xTYMcWCSghsarxyDfMaMHjbQKPiA0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1659191216;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=T9IjTJcjihkHFFN5KVJgnWvnqo9eLDcviRSrTl9a0H0=;
        b=bVPBDKDihVxB7WrRaipJBs/aatUd37kuX5nzPDB+8CZ1J6mQf8w7lYx0SLqWbPBZ
        Tsqe8VAHgGVnEKzir8PRp+mhA6L1fE0uStM2fjQjGHdCUDvp4am+9gQEXdmK+D21F69
        RL+zxtBaMRk/fB+AkHL67tvCQqo6RjKmVNCV+DOo=
Received: from arinc9-PC.lan (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1659191215964410.90340698142415; Sat, 30 Jul 2022 07:26:55 -0700 (PDT)
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
Subject: [PATCH 1/4] dt-bindings: net: dsa: mediatek,mt7530: make trivial changes
Date:   Sat, 30 Jul 2022 17:26:24 +0300
Message-Id: <20220730142627.29028-2-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220730142627.29028-1-arinc.unal@arinc9.com>
References: <20220730142627.29028-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make trivial changes on the binding.

- Update title to include MT7531 switch.
- Add me as a maintainer. List maintainers in alphabetical order by first
name.
- Add description to compatible strings.
- Fix MCM description. mediatek,mcm is not used on MT7623NI.
- Add description for reset-gpios.
- Remove quotes from $ref: "dsa.yaml#".

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 .../bindings/net/dsa/mediatek,mt7530.yaml     | 27 ++++++++++++++-----
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index 17ab6c69ecc7..541984a7d2d4 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -4,12 +4,13 @@
 $id: http://devicetree.org/schemas/net/dsa/mediatek,mt7530.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Mediatek MT7530 Ethernet switch
+title: Mediatek MT7530 and MT7531 Ethernet Switches
 
 maintainers:
-  - Sean Wang <sean.wang@mediatek.com>
+  - Arınç ÜNAL <arinc.unal@arinc9.com>
   - Landen Chao <Landen.Chao@mediatek.com>
   - DENG Qingfang <dqfext@gmail.com>
+  - Sean Wang <sean.wang@mediatek.com>
 
 description: |
   Port 5 of mt7530 and mt7621 switch is muxed between:
@@ -66,6 +67,14 @@ properties:
       - mediatek,mt7531
       - mediatek,mt7621
 
+    description: |
+      mediatek,mt7530:
+        For standalone MT7530 and multi-chip module MT7530 in MT7623AI SoC.
+      mediatek,mt7531:
+        For standalone MT7531.
+      mediatek,mt7621:
+        For multi-chip module MT7530 in MT7621AT, MT7621DAT and MT7621ST SoCs.
+
   reg:
     maxItems: 1
 
@@ -79,7 +88,7 @@ properties:
   gpio-controller:
     type: boolean
     description:
-      if defined, MT7530's LED controller will run on GPIO mode.
+      If defined, MT7530's LED controller will run on GPIO mode.
 
   "#interrupt-cells":
     const: 1
@@ -98,11 +107,15 @@ properties:
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
@@ -148,7 +161,7 @@ required:
   - reg
 
 allOf:
-  - $ref: "dsa.yaml#"
+  - $ref: dsa.yaml#
   - if:
       required:
         - mediatek,mcm
-- 
2.34.1

