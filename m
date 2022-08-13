Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27AA3591BAC
	for <lists+netdev@lfdr.de>; Sat, 13 Aug 2022 17:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239963AbiHMPqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Aug 2022 11:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239925AbiHMPqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Aug 2022 11:46:01 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35BDF2FFF8;
        Sat, 13 Aug 2022 08:45:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1660405515; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=LHguKks0lv7vA3ueibE2h19pXiUvWhpnLecebJ4kCqKf2zVTSqc/EHbKKjX5JkIZ4uyQVRICg94O19OOVjtZ2PVvKU0d6PbQMMMyTaW7//Iz2TJCRKAlEvPRsAbv3/1OxRAFY5QmzbEkHbNhJYMLoYE1foUj4bJ1s7jlkpaR1O8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1660405515; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=zy98iC9XC2eVhC07Cr4RMR8a0qJzk56OXu8sNv2CeM4=; 
        b=fWIYkNz00lm8ELkSMUHDxH9I2bix0PwYEFNozFALqewJ1pa/gAwh32H5lhjyJKkqMIOrcBqlcTZvbci4JVtB55uOuNrdlQaD+lv0zzThsl9SZIwQOZHGfy9nOpiaZ/xqlNYbv+g5+tovavL1aQP5EZwXeqUJTJvMZj5L/jh09R8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1660405515;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=zy98iC9XC2eVhC07Cr4RMR8a0qJzk56OXu8sNv2CeM4=;
        b=Nv6cdOYAB97QZBR9N8itpcTzpPm/s3tG9Vy6oynKxXEs9XrJ92P9RBLpPspqNqvv
        0IvCWV8eK1SFVihhPhCnHsrAHC3rp862bJM96iWbXKrgkPXfRUh/PL/77KRyfyPWWWl
        9EfbgNjs3GhvEfq3eH8bpriH26tLjTYDwLVsip0I=
Received: from arinc9-PC.lan (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 166040551423871.94615740500126; Sat, 13 Aug 2022 08:45:14 -0700 (PDT)
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
Subject: [PATCH v2 6/7] dt-bindings: net: dsa: mediatek,mt7530: define phy-mode for each compatible
Date:   Sat, 13 Aug 2022 18:44:14 +0300
Message-Id: <20220813154415.349091-7-arinc.unal@arinc9.com>
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

Define acceptable phy-mode values for CPU port of each compatible device.
Remove relevant information from the description of the binding.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 .../bindings/net/dsa/mediatek,mt7530.yaml     | 103 ++++++++++++++++--
 1 file changed, 92 insertions(+), 11 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index a27cb4fa490f..530ef5a75a2f 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -49,17 +49,6 @@ description: |
   * mt7621: phy-mode = "rgmii-txid";
   * mt7623: phy-mode = "rgmii";
 
-  CPU-Ports need a phy-mode property:
-    Allowed values on mt7530 and mt7621:
-      - "rgmii"
-      - "trgmii"
-    On mt7531:
-      - "1000base-x"
-      - "2500base-x"
-      - "rgmii"
-      - "sgmii"
-
-
 properties:
   compatible:
     oneOf:
@@ -177,6 +166,36 @@ allOf:
                         items:
                           - const: cpu
                   then:
+                    allOf:
+                      - if:
+                          properties:
+                            reg:
+                              const: 5
+                        then:
+                          properties:
+                            phy-mode:
+                              enum:
+                                - gmii
+                                - mii
+                                - rgmii
+
+                      - if:
+                          properties:
+                            reg:
+                              const: 6
+                        then:
+                          properties:
+                            phy-mode:
+                              enum:
+                                - rgmii
+                                - trgmii
+
+                    properties:
+                      reg:
+                        enum:
+                          - 5
+                          - 6
+
                     required:
                       - phy-mode
 
@@ -206,6 +225,38 @@ allOf:
                         items:
                           - const: cpu
                   then:
+                    allOf:
+                      - if:
+                          properties:
+                            reg:
+                              const: 5
+                        then:
+                          properties:
+                            phy-mode:
+                              enum:
+                                - 1000base-x
+                                - 2500base-x
+                                - rgmii
+                                - sgmii
+
+                      - if:
+                          properties:
+                            reg:
+                              const: 6
+                        then:
+                          properties:
+                            phy-mode:
+                              enum:
+                                - 1000base-x
+                                - 2500base-x
+                                - sgmii
+
+                    properties:
+                      reg:
+                        enum:
+                          - 5
+                          - 6
+
                     required:
                       - phy-mode
 
@@ -235,6 +286,36 @@ allOf:
                         items:
                           - const: cpu
                   then:
+                    allOf:
+                      - if:
+                          properties:
+                            reg:
+                              const: 5
+                        then:
+                          properties:
+                            phy-mode:
+                              enum:
+                                - gmii
+                                - mii
+                                - rgmii
+
+                      - if:
+                          properties:
+                            reg:
+                              const: 6
+                        then:
+                          properties:
+                            phy-mode:
+                              enum:
+                                - rgmii
+                                - trgmii
+
+                    properties:
+                      reg:
+                        enum:
+                          - 5
+                          - 6
+
                     required:
                       - phy-mode
 
-- 
2.34.1

