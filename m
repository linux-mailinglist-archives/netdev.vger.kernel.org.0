Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E50585A0B58
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 10:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238069AbiHYIYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 04:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239835AbiHYIYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 04:24:12 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC8D5A61D5;
        Thu, 25 Aug 2022 01:24:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1661415812; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=MtJ7qO+Xey0OqUrFcFlQLD/MFV94IDDljpcDonYCDi+xJR7JLP3ZGbJn4HSz1sR09qYKtRUP9jrqtc3z6EpUFGHDG0WRGHgNXkxV1vUT80x5dwmy5rls0dBLAiq5K4cHEZDD1sEGSGzdGqAtjjq8POkFrARtIJTs1I+5YIFY9e8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1661415812; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=I5bq6j8LEU8gFq5ov2kLQDkOrcDe7wXqTnM+mc70qTY=; 
        b=n/Kug+OgPMP+2t7a82U9d0RXGa2v8GMcARaf3Mxa2+VuZ/eBWQvX7rXEAlLDaymfdn7d0iqlYjP9LAxa90RJmLWxm82DaOcDCUE504DAaE3xTAJI+a12Qn6LYqFPlXtCui3HA7zKb/LsPcYvWE6nKKDx+SWvBCQGTcFUvtVEfi4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1661415812;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=I5bq6j8LEU8gFq5ov2kLQDkOrcDe7wXqTnM+mc70qTY=;
        b=A34toTrjpjQZRer5OVay2c+cscs6M5rMuNr1niupaMk5klthplykFKgvtBiqEeEz
        zCDHdPYiYTS5uPif+2znv9Kc2ACXWGUW9VAJSeTKJO60FsM8R++POhlg0OwveZbMaL7
        tSi/lBE7XISI4zroArUjcqLgQoLDK+PpMZFwquPw=
Received: from arinc9-PC.lan (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1661415810501649.5584786900944; Thu, 25 Aug 2022 01:23:30 -0700 (PDT)
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
        Daniel Golle <daniel@makrotopia.org>, erkin.bozoglu@xeront.com,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v6 3/6] dt-bindings: net: dsa: mediatek,mt7530: fix reset lines
Date:   Thu, 25 Aug 2022 11:22:58 +0300
Message-Id: <20220825082301.409450-4-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220825082301.409450-1-arinc.unal@arinc9.com>
References: <20220825082301.409450-1-arinc.unal@arinc9.com>
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

- Add description for reset-gpios.
- Invalidate reset-gpios if mediatek,mcm is used. We cannot use multiple
reset lines at the same time.
- Invalidate mediatek,mcm if the compatible device is mediatek,mt7531.
There is no multi-chip module version of mediatek,mt7531.
- Require mediatek,mcm for mediatek,mt7621 as the compatible string is only
used for the multi-chip module version of MT7530.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 .../bindings/net/dsa/mediatek,mt7530.yaml     | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index 35a3039825bd..16ddda314b5c 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -111,6 +111,11 @@ properties:
       switch is a part of the multi-chip module.
 
   reset-gpios:
+    description:
+      GPIO to reset the switch. Use this if mediatek,mcm is not used.
+      This property is optional because some boards share the reset line with
+      other components which makes it impossible to probe the switch if the
+      reset line is used.
     maxItems: 1
 
   reset-names:
@@ -165,6 +170,9 @@ allOf:
       required:
         - mediatek,mcm
     then:
+      properties:
+        reset-gpios: false
+
       required:
         - resets
         - reset-names
@@ -181,6 +189,22 @@ allOf:
         - core-supply
         - io-supply
 
+  - if:
+      properties:
+        compatible:
+          const: mediatek,mt7531
+    then:
+      properties:
+        mediatek,mcm: false
+
+  - if:
+      properties:
+        compatible:
+          const: mediatek,mt7621
+    then:
+      required:
+        - mediatek,mcm
+
 unevaluatedProperties: false
 
 examples:
-- 
2.34.1

