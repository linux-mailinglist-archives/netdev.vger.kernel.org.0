Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 752EE56361B
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 16:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbiGAOsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 10:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233472AbiGAOsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 10:48:10 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C895D2E693;
        Fri,  1 Jul 2022 07:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656686879; x=1688222879;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Rf7fW/FCxNnSxG/1HF5J6f4FI/REm839eNlYY1nJDw8=;
  b=C3d/Q6GkA4NhD02YfR+XNWPTB9upU+noTsfEmWKvATpU2/UUGQ3/vZo4
   FyNAD94X1a5NxYnzBLRnYVDEPi510VrH4CsniPPVteeHB5ur9K1JxQIJ+
   YNk8raFbpdiHazQGlPM9acDM/sEjrAVOKQzBJSTqZmjAb7UD8086hPMXx
   E23RY8gYwwLczQfaP0JSIKz9SuwKxqo6ewZFku9oxmlrkkVCyy3EWEnEI
   e7Lj74IFNVs0biBtFufguvreAXlvaUgj8bNH4OHCXhDca/XXUybfPYq6R
   eiB0ES0PMphXRxbswlDgYyfYUyHmvaGItErM5x9iiSL/Gsifzn5l4gC6A
   A==;
X-IronPort-AV: E=Sophos;i="5.92,237,1650956400"; 
   d="scan'208";a="102666208"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Jul 2022 07:47:47 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 1 Jul 2022 07:47:46 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 1 Jul 2022 07:47:25 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Rob Herring" <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Subject: [Patch net-next v15 01/13] dt-bindings: net: make internal-delay-ps based on phy-mode
Date:   Fri, 1 Jul 2022 20:16:40 +0530
Message-ID: <20220701144652.10526-2-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220701144652.10526-1-arun.ramadoss@microchip.com>
References: <20220701144652.10526-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>

*-internal-delay-ps properties would be applicable only for RGMII interface
modes.

It is changed as per the request.

Ran dt_binding_check to confirm nothing is broken.

link: https://lore.kernel.org/netdev/d8e5f6a8-a7e1-dabd-f4b4-ea8ea21d0a1d@gmail.com/
Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Rob Herring <robh@kernel.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../bindings/net/ethernet-controller.yaml     | 35 ++++++++++++-------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index 4f15463611f8..56d9aca8c954 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -133,12 +133,6 @@ properties:
       and is useful for determining certain configuration settings
       such as flow control thresholds.
 
-  rx-internal-delay-ps:
-    description: |
-      RGMII Receive Clock Delay defined in pico seconds.
-      This is used for controllers that have configurable RX internal delays.
-      If this property is present then the MAC applies the RX delay.
-
   sfp:
     $ref: /schemas/types.yaml#/definitions/phandle
     description:
@@ -150,12 +144,6 @@ properties:
       The size of the controller\'s transmit fifo in bytes. This
       is used for components that can have configurable fifo sizes.
 
-  tx-internal-delay-ps:
-    description: |
-      RGMII Transmit Clock Delay defined in pico seconds.
-      This is used for controllers that have configurable TX internal delays.
-      If this property is present then the MAC applies the TX delay.
-
   managed:
     description:
       Specifies the PHY management type. If auto is set and fixed-link
@@ -232,6 +220,29 @@ properties:
           required:
             - speed
 
+allOf:
+  - if:
+      properties:
+        phy-mode:
+          contains:
+            enum:
+              - rgmii
+              - rgmii-rxid
+              - rgmii-txid
+              - rgmii-id
+    then:
+      properties:
+        rx-internal-delay-ps:
+          description:
+            RGMII Receive Clock Delay defined in pico seconds.This is used for
+            controllers that have configurable RX internal delays. If this
+            property is present then the MAC applies the RX delay.
+        tx-internal-delay-ps:
+          description:
+            RGMII Transmit Clock Delay defined in pico seconds.This is used for
+            controllers that have configurable TX internal delays. If this
+            property is present then the MAC applies the TX delay.
+
 additionalProperties: true
 
 ...
-- 
2.36.1

