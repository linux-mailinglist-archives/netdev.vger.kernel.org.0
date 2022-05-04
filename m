Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88A9051A3A0
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 17:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352176AbiEDPWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 11:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352152AbiEDPWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 11:22:33 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 557F0443CC;
        Wed,  4 May 2022 08:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1651677523; x=1683213523;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PxwtsjHsy51+9qRrnsU6tV5yWEvTGmhz6m5GLFoZHAM=;
  b=b7V4Syzzh1XW7jP7QEbXNkgvsRntA7vDVdySWilAYBxUowb4M+l+ANLC
   +ijKzem6E+8Lk4AroDL2CihW7Jvxhag3mjrBFbP9a5fro3PcY5nLt1hE4
   /I5iQGOwWPNo7XZ+I0g0jTf0Ca1ojSCjlJ9P2LFzdLYsVF7SEAjSofzWy
   UBwarHwDCRaLUD6kJnxhH7MALbM1uUm9QpsO7aBcte9xlpNnPmzqysV0u
   9ZIl7TmYhMTno3LmDQmQaFxVTeItLFSJjz4GZUGCt7NHEsxGE44KgGzgj
   eTJ3y5Qm0zUnYUAQ4VTSop3Zcf/4q21hv758LsHMZIwayWb/4gNm5IdaJ
   w==;
X-IronPort-AV: E=Sophos;i="5.91,198,1647327600"; 
   d="scan'208";a="157794707"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 May 2022 08:18:39 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 4 May 2022 08:18:31 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 4 May 2022 08:18:18 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     KP Singh <kpsingh@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        "Martin KaFai Lau" <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Vladimir Oltean" <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, Rob Herring <robh@kernel.org>
Subject: [Patch net-next v13 01/13] dt-bindings: net: make internal-delay-ps based on phy-mode
Date:   Wed, 4 May 2022 20:47:43 +0530
Message-ID: <20220504151755.11737-2-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220504151755.11737-1-arun.ramadoss@microchip.com>
References: <20220504151755.11737-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

It is changed as per the request,
https://lore.kernel.org/netdev/d8e5f6a8-a7e1-dabd-f4b4-ea8ea21d0a1d@gmail.com/

Ran dt_binding_check to confirm nothing is broken.

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
2.33.0

