Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC41A5980AE
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 11:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240669AbiHRJSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 05:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239083AbiHRJRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 05:17:50 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6242367CBF;
        Thu, 18 Aug 2022 02:17:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1660814239; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=cBP8geGX2ylyhP3nABk3rAijRIaQY633+iZ8iexA7hNYJHYmjhjiTpXncvaEHR07kDcXyF4wV5YSgmGkJ4dqBCOH/H0jJp/k/pwowDBsjlJG9B3KGnCyvrtVgCZwLQ/6ZbNtGaJqQRRzTswcqDzN1wuRXqGgaAUuKama1ogusuI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1660814239; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=kCoStLRYCDJomu2FK7JWpgJUoeguj2TGBHb8GnavUkA=; 
        b=SLD1IGXgc8fc8/LwY+fh2QF/AjaBszVct5rdFI2YklD28Ziy53vRDMqaqyQMfJaMDF1p6ok4QBkv0r3tanbRD5/yiAC6JnDEz+BGGoLubACZewWSFH7DwK0vC9Qy0y+kMgyWh5C54k6vmOYSEC9V51ax5gzmXLLxRWjsPsrrwgA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1660814239;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=kCoStLRYCDJomu2FK7JWpgJUoeguj2TGBHb8GnavUkA=;
        b=LQTdkQNlPNElQOBLSFSFZTrpMyGq4/uVD34ACdq/L+U94S3C52Xmr6L/zMrOp2QJ
        2YpHDLnYd6n1kUN01D7GPIpR5iQO316B6ib+2mwr7XA1QA5dwYr0hDnZ3QPSlrK2nNv
        PjQKQ8PGogC82WMXmOO3nDYVWpOamGlpxFsJOals=
Received: from arinc9-PC.lan (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1660814237710308.04653731142696; Thu, 18 Aug 2022 02:17:17 -0700 (PDT)
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
Subject: [PATCH v3 6/6] dt-bindings: net: dsa: mediatek,mt7530: update binding description
Date:   Thu, 18 Aug 2022 12:16:27 +0300
Message-Id: <20220818091627.51878-7-arinc.unal@arinc9.com>
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

Update the description of the binding.

- Describe the switches, which SoCs they are in, or if they are standalone.
- Explain the various ways of configuring MT7530's port 5.
- Remove phy-mode = "rgmii-txid" from description. Same code path is
followed for delayed rgmii and rgmii phy-mode on mtk_eth_soc.c.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 .../bindings/net/dsa/mediatek,mt7530.yaml     | 97 ++++++++++++-------
 1 file changed, 62 insertions(+), 35 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index b36497c4636e..caecdf224e2b 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -13,41 +13,68 @@ maintainers:
   - Sean Wang <sean.wang@mediatek.com>
 
 description: |
-  Port 5 of mt7530 and mt7621 switch is muxed between:
-  1. GMAC5: GMAC5 can interface with another external MAC or PHY.
-  2. PHY of port 0 or port 4: PHY interfaces with an external MAC like 2nd GMAC
-     of the SOC. Used in many setups where port 0/4 becomes the WAN port.
-     Note: On a MT7621 SOC with integrated switch: 2nd GMAC can only connected to
-       GMAC5 when the gpios for RGMII2 (GPIO 22-33) are not used and not
-       connected to external component!
-
-  Port 5 modes/configurations:
-  1. Port 5 is disabled and isolated: An external phy can interface to the 2nd
-     GMAC of the SOC.
-     In the case of a build-in MT7530 switch, port 5 shares the RGMII bus with 2nd
-     GMAC and an optional external phy. Mind the GPIO/pinctl settings of the SOC!
-  2. Port 5 is muxed to PHY of port 0/4: Port 0/4 interfaces with 2nd GMAC.
-     It is a simple MAC to PHY interface, port 5 needs to be setup for xMII mode
-     and RGMII delay.
-  3. Port 5 is muxed to GMAC5 and can interface to an external phy.
-     Port 5 becomes an extra switch port.
-     Only works on platform where external phy TX<->RX lines are swapped.
-     Like in the Ubiquiti ER-X-SFP.
-  4. Port 5 is muxed to GMAC5 and interfaces with the 2nd GAMC as 2nd CPU port.
-     Currently a 2nd CPU port is not supported by DSA code.
-
-  Depending on how the external PHY is wired:
-  1. normal: The PHY can only connect to 2nd GMAC but not to the switch
-  2. swapped: RGMII TX, RX are swapped; external phy interface with the switch as
-     a ethernet port. But can't interface to the 2nd GMAC.
-
-    Based on the DT the port 5 mode is configured.
-
-  Driver tries to lookup the phy-handle of the 2nd GMAC of the master device.
-  When phy-handle matches PHY of port 0 or 4 then port 5 set-up as mode 2.
-  phy-mode must be set, see also example 2 below!
-  * mt7621: phy-mode = "rgmii-txid";
-  * mt7623: phy-mode = "rgmii";
+  There are two versions of MT7530, standalone and in a multi-chip module.
+
+  MT7530 is a part of the multi-chip module in MT7620AN, MT7620DA, MT7620DAN,
+  MT7620NN, MT7621AT, MT7621DAT, MT7621ST and MT7623AI SoCs.
+
+  MT7530 in MT7620AN, MT7620DA, MT7620DAN and MT7620NN SoCs has got 10/100 PHYs
+  and the switch registers are directly mapped into SoC's memory map rather than
+  using MDIO. The DSA driver currently doesn't support this.
+
+  There is only the standalone version of MT7531.
+
+  Port 5 on MT7530 has got various ways of configuration.
+
+  For standalone MT7530:
+
+    - Port 5 can be used as a CPU port.
+
+    - PHY 0 or 4 of the switch can be muxed to connect to the gmac of the SoC
+      which port 5 is wired to. Usually used for connecting the wan port
+      directly to the CPU to achieve 2 Gbps routing in total.
+
+      The driver looks up the reg on the ethernet-phy node which the phy-handle
+      property refers to on the gmac node to mux the specified phy.
+
+      The driver requires the gmac of the SoC to have "mediatek,eth-mac" as the
+      compatible string and the reg must be 1. So, for now, only gmac1 of an
+      MediaTek SoC can benefit this. Banana Pi BPI-R2 suits this.
+      Check out example 5 for a similar configuration.
+
+    - Port 5 can be wired to an external phy. Port 5 becomes a DSA slave.
+      Check out example 7 for a similar configuration.
+
+  For multi-chip module MT7530:
+
+    - Port 5 can be used as a CPU port.
+
+    - PHY 0 or 4 of the switch can be muxed to connect to gmac1 of the SoC.
+      Usually used for connecting the wan port directly to the CPU to achieve 2
+      Gbps routing in total.
+
+      The driver looks up the reg on the ethernet-phy node which the phy-handle
+      property refers to on the gmac node to mux the specified phy.
+
+      For the MT7621 SoCs, rgmii2 group must be claimed with rgmii2 function.
+      Check out example 5.
+
+    - In case of an external phy wired to gmac1 of the SoC, port 5 must not be
+      enabled.
+
+      In case of muxing PHY 0 or 4, the external phy must not be enabled.
+
+      For the MT7621 SoCs, rgmii2 group must be claimed with rgmii2 function.
+      Check out example 6.
+
+    - Port 5 can be muxed to an external phy. Port 5 becomes a DSA slave.
+      The external phy must be wired TX to TX to gmac1 of the SoC for this to
+      work. Ubiquiti EdgeRouter X SFP is wired this way.
+
+      Muxing PHY 0 or 4 won't work when the external phy is connected TX to TX.
+
+      For the MT7621 SoCs, rgmii2 group must be claimed with gpio function.
+      Check out example 7.
 
 properties:
   compatible:
-- 
2.34.1

