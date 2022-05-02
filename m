Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F330C517362
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 17:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240090AbiEBQDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 12:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386021AbiEBQDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 12:03:08 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2400F6390;
        Mon,  2 May 2022 08:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1651507179; x=1683043179;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qEdagddPd2/wC30NU0xghRyXnR4WflzN1HHFnEPX39M=;
  b=DKnpa2EGuiTkYtJ3KkL2Oix8X5mPnjJerezE6k+m9gdioxKK5D444tIE
   hACVACiI7v6iPCAaBDITVnFlwF06bausEM23o0NTIJ6Vepdk5FPQy6en6
   Q53hcNT6MWS1A35c7JyWAo9mMra0qRUSUpvNsuuVkOwSdUqFoNsGOJ98p
   6SpHa7lYY/0VaIwTww7GIZifoGVDIKw+We8ItaUeQGmhSqWnXMcNGowEO
   9JDSfdmyoGWCA/VrO5Z3Ki5Mj2shKvPZqFeKGslLzZfpvnpMWaEy/tGbI
   7rByKbUr6nnZuyNeY7h4ELC1k3jcANuxnrrQ3xH+ueaBDgNWIj53X72pL
   A==;
X-IronPort-AV: E=Sophos;i="5.91,192,1647327600"; 
   d="scan'208";a="94280193"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 May 2022 08:59:37 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 2 May 2022 08:59:36 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 2 May 2022 08:59:18 -0700
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
        Rob Herring <robh+dt@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Vladimir Oltean" <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Vivien Didelot" <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: [Patch net-next v12 01/13] dt-bindings: net: make internal-delay-ps based on phy-mode
Date:   Mon, 2 May 2022 21:28:36 +0530
Message-ID: <20220502155848.30493-2-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220502155848.30493-1-arun.ramadoss@microchip.com>
References: <20220502155848.30493-1-arun.ramadoss@microchip.com>
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

