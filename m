Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C880F6AFE33
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 06:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjCHFTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 00:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjCHFTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 00:19:04 -0500
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2E199CBD4;
        Tue,  7 Mar 2023 21:19:02 -0800 (PST)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 3285IfWV069225;
        Tue, 7 Mar 2023 23:18:41 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1678252721;
        bh=PY5mklVTecLHb38NjrpaE+bHpYbkoY0Wq3HFNtDN9hU=;
        h=From:To:CC:Subject:Date;
        b=x//5F8VxKkIomwvIXI/LpSo0k7ZR2WgOMvpZRgWxH2nT1xWYRiyZ1QBQcntGn64gu
         fyCuUStWlTPdaCu40wNbu73skQjmZlGnOjYzvRy11/ia547Jy5E5a8AapKZrcyOajB
         OYjWHLWlgmy5DnA4SPoRdyCnsDrHxXu1d0RdScMs=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 3285IfhK104583
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 7 Mar 2023 23:18:41 -0600
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Tue, 7
 Mar 2023 23:18:40 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Tue, 7 Mar 2023 23:18:41 -0600
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 3285IaN3036048;
        Tue, 7 Mar 2023 23:18:37 -0600
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>, <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <nsekhar@ti.com>,
        <rogerq@kernel.org>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH net-next v2] dt-bindings: net: ti: k3-am654-cpsw-nuss: Document Serdes PHY
Date:   Wed, 8 Mar 2023 10:48:35 +0530
Message-ID: <20230308051835.276552-1-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update bindings to include Serdes PHY as an optional PHY, in addition to
the existing CPSW MAC's PHY. The CPSW MAC's PHY is required while the
Serdes PHY is optional. The Serdes PHY handle has to be provided only
when the Serdes is being configured in a Single-Link protocol. Using the
name "serdes-phy" to represent the Serdes PHY handle, the am65-cpsw-nuss
driver can obtain the Serdes PHY and request the Serdes to be
configured.

Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---

Hello,

This patch corresponds to the Serdes PHY bindings that were missed out in
the series at:
https://lore.kernel.org/r/20230104103432.1126403-1-s-vadapalli@ti.com/
This was pointed out at:
https://lore.kernel.org/r/CAMuHMdW5atq-FuLEL3htuE3t2uO86anLL3zeY7n1RqqMP_rH1g@mail.gmail.com/

Changes from v1:
1. Describe phys property with minItems, items and description.
2. Use minItems and items in phy-names.
3. Remove the description in phy-names.

v1:
https://lore.kernel.org/r/20230306094750.159657-1-s-vadapalli@ti.com/

 .../bindings/net/ti,k3-am654-cpsw-nuss.yaml        | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
index 900063411a20..0fb48bb6a041 100644
--- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
+++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
@@ -126,8 +126,18 @@ properties:
             description: CPSW port number
 
           phys:
-            maxItems: 1
-            description: phandle on phy-gmii-sel PHY
+            minItems: 1
+            items:
+              - description: CPSW MAC's PHY.
+              - description: Serdes PHY. Serdes PHY is required only if
+                             the Serdes has to be configured in the
+                             Single-Link configuration.
+
+          phy-names:
+            minItems: 1
+            items:
+              - const: mac-phy
+              - const: serdes-phy
 
           label:
             description: label associated with this port
-- 
2.25.1

