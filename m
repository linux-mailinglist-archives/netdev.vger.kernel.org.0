Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40AC45980B3
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 11:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235140AbiHRJRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 05:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiHRJRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 05:17:31 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480D867447;
        Thu, 18 Aug 2022 02:17:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1660814211; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=iSK5aEHEz2NKsaTUHblmGN+Z5pVtKSH8OgDzOFj90fAKga+dH50mWMB9+qQ7wUeS8p5Aaq1L93RomIW68+f1aO3raNjWOiQiXvxud03HAW7x9MVD8IoJ/7J35hBQAEVQwMBf6rpDYsrXyuZ280X98RTlrbEdO0URdGE4oQdtIbw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1660814211; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=tUPXDCTkwC2zhPMuq078yFzwDdf8nbUXFo0CgcNnnAg=; 
        b=SiwuLfHgKVmz2KSkESTYCsRYuMieBJ3R2/dW6MpFew/z5WE2kcRKBFDiLZko/l27wovFFuW95VJ0jv72wPPShWaRb/+kNwNlDBgcwND4epKAlS8H6IxvFYx1QgeIBNHnlXgQ/S/wItwFP1lxDhrKGhI7BN0q4uR6UUdFMiNUhWg=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1660814211;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=tUPXDCTkwC2zhPMuq078yFzwDdf8nbUXFo0CgcNnnAg=;
        b=CVZZLg4CvcouhU8MKyUBZAC4OlA5yIlRgBNdecIalutTdo3sCj8ZJvJl/8dGyI+r
        mcWNof2dn8s2LNljHEV+1TkQ2dEI/9P/g7BoQIlo01pD1aKImlKckIoufMANtE48z6H
        AcHdkPNQwyAtj4j6EqtOvjzFFREpnqUjNH2Dwu/Q=
Received: from arinc9-PC.lan (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1660814210407956.4809054082643; Thu, 18 Aug 2022 02:16:50 -0700 (PDT)
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
Subject: [PATCH v3 2/6] dt-bindings: net: dsa: mediatek,mt7530: fix reset lines
Date:   Thu, 18 Aug 2022 12:16:23 +0300
Message-Id: <20220818091627.51878-3-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220818091627.51878-1-arinc.unal@arinc9.com>
References: <20220818091627.51878-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- Fix description of mediatek,mcm. mediatek,mcm is not used on MT7623NI.
- Add description for reset-gpios.
- Invalidate reset-gpios if mediatek,mcm is used. We cannot use multiple
reset lines at the same time.
- Invalidate mediatek,mcm if the compatible device is mediatek,mt7531.
There is no multi-chip module version of mediatek,mt7531.
- Require mediatek,mcm for mediatek,mt7621 as the compatible string is only
used for the multi-chip module version of MT7530.

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

