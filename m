Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84C52591BA7
	for <lists+netdev@lfdr.de>; Sat, 13 Aug 2022 17:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239855AbiHMPp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Aug 2022 11:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239843AbiHMPpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Aug 2022 11:45:25 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F4124BEC;
        Sat, 13 Aug 2022 08:45:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1660405481; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=f5XP1KzAb9JAcwx5vN+MD6abC72s4JGh3j50rwj8uMx5sdM49vUyN/krozKh0gKKVwbAeLU1WiUvs9yVzDEIBuszV83nd3V7fTB/sv2cRNTpsPstuGZihGrsztQlR0CsXZOTXucDnZe2F7/6xs1FrzA9wYzJ5Jem2IHiHJLYpmU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1660405481; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=yGdam4HCk0JO9lv/W5n08OUCBsZPnrBx9o3iHj6VyIo=; 
        b=AHDc3AXSkFV0X3Qxj2UQUU5QFevfZVoNivZzoUcm8aMuHL8kyVaoEzf6CPEwk7SuR0UMLrFEqSwdYu44Ck9WQNRpbZiJsllthax0KvtdAMat2HBezKQEmssxf1wheIP0ZjNTOfBbZtEi24K5Am8wGZcnzAJ/Ak//Mpd8WNfvsiU=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1660405481;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=yGdam4HCk0JO9lv/W5n08OUCBsZPnrBx9o3iHj6VyIo=;
        b=BkW1p8qBrz8Oi+PA8s3k+IuJ9XXy1f5SzF01ahBDg3ShP0EL0PDhh5aiQivtxwH7
        pr9kRsLAdguHmwJe9qUOpZhfESbGLXZwrXGM63hCJMQ1nV4T2gCv/aiCixtMpd5GXY+
        PguBrPVi0L2wuxR6j9iGdlGQIMjv019hLpstuEXQ=
Received: from arinc9-PC.lan (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 1660405479705512.3045871969838; Sat, 13 Aug 2022 08:44:39 -0700 (PDT)
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
Subject: [PATCH v2 1/7] dt-bindings: net: dsa: mediatek,mt7530: make trivial changes
Date:   Sat, 13 Aug 2022 18:44:09 +0300
Message-Id: <20220813154415.349091-2-arinc.unal@arinc9.com>
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

Make trivial changes on the binding.

- Update title to include MT7531 switch.
- Add me as a maintainer. List maintainers in alphabetical order by first
name.
- Add description to compatible strings.
- Stretch descriptions up to the 80 character limit.
- Remove quotes from $ref: "dsa.yaml#".

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 .../bindings/net/dsa/mediatek,mt7530.yaml     | 36 ++++++++++++-------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index 17ab6c69ecc7..edf48e917173 100644
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
@@ -61,10 +62,21 @@ description: |
 
 properties:
   compatible:
-    enum:
-      - mediatek,mt7530
-      - mediatek,mt7531
-      - mediatek,mt7621
+    oneOf:
+      - description:
+          Standalone MT7530 and multi-chip module MT7530 in MT7623AI SoC
+        items:
+          - const: mediatek,mt7530
+
+      - description:
+          Standalone MT7531
+        items:
+          - const: mediatek,mt7531
+
+      - description:
+          Multi-chip module MT7530 in MT7621AT, MT7621DAT and MT7621ST SoCs
+        items:
+          - const: mediatek,mt7621
 
   reg:
     maxItems: 1
@@ -79,7 +91,7 @@ properties:
   gpio-controller:
     type: boolean
     description:
-      if defined, MT7530's LED controller will run on GPIO mode.
+      If defined, MT7530's LED controller will run on GPIO mode.
 
   "#interrupt-cells":
     const: 1
@@ -92,8 +104,8 @@ properties:
   io-supply:
     description:
       Phandle to the regulator node necessary for the I/O power.
-      See Documentation/devicetree/bindings/regulator/mt6323-regulator.txt
-      for details for the regulator setup on these boards.
+      See Documentation/devicetree/bindings/regulator/mt6323-regulator.txt for
+      details for the regulator setup on these boards.
 
   mediatek,mcm:
     type: boolean
@@ -110,8 +122,8 @@ properties:
 
   resets:
     description:
-      Phandle pointing to the system reset controller with line index for
-      the ethsys.
+      Phandle pointing to the system reset controller with line index for the
+      ethsys.
     maxItems: 1
 
 patternProperties:
@@ -148,7 +160,7 @@ required:
   - reg
 
 allOf:
-  - $ref: "dsa.yaml#"
+  - $ref: dsa.yaml#
   - if:
       required:
         - mediatek,mcm
-- 
2.34.1

