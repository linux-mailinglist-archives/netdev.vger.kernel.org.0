Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9C3A6ABA4F
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 10:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjCFJsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 04:48:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjCFJsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 04:48:30 -0500
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F9ECDCA;
        Mon,  6 Mar 2023 01:48:27 -0800 (PST)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 3269lukv076419;
        Mon, 6 Mar 2023 03:47:56 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1678096076;
        bh=1l5RxV9XXK7LPgaTQnjkhWmfaEwBS91fYlY2tG0yIYE=;
        h=From:To:CC:Subject:Date;
        b=oGeOPZgrr0OgbfFuoDjjjzEOq2ZLK8OI+k9BC/fB4iwMylAV0j+WztoD5+p26q029
         IRvWCod5tLhrgOLFmnHmaadnjdJ5t5HFDCnQKt/mbZVlV3+1BFRNywA12uBBaX7XKn
         pNbCUsYf9B2ifVtPZGNDoK+BzQ8xkya/NpNpeFBo=
Received: from DFLE104.ent.ti.com (dfle104.ent.ti.com [10.64.6.25])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 3269luVJ094158
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 6 Mar 2023 03:47:56 -0600
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Mon, 6
 Mar 2023 03:47:55 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Mon, 6 Mar 2023 03:47:55 -0600
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 3269lpUM019816;
        Mon, 6 Mar 2023 03:47:51 -0600
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
Subject: [PATCH net-next] dt-bindings: net: ti: k3-am654-cpsw-nuss: Document Serdes PHY
Date:   Mon, 6 Mar 2023 15:17:50 +0530
Message-ID: <20230306094750.159657-1-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
Link: https://lore.kernel.org/r/20230104103432.1126403-1-s-vadapalli@ti.com/
This was pointed out at:
https://lore.kernel.org/r/CAMuHMdW5atq-FuLEL3htuE3t2uO86anLL3zeY7n1RqqMP_rH1g@mail.gmail.com/

 .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   | 21 +++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
index 900063411a20..fab7df437dcc 100644
--- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
+++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
@@ -126,8 +126,25 @@ properties:
             description: CPSW port number
 
           phys:
-            maxItems: 1
-            description: phandle on phy-gmii-sel PHY
+            minItems: 1
+            maxItems: 2
+            description:
+              phandle(s) on CPSW MAC's PHY (Required) and the Serdes
+              PHY (Optional). phandle to the Serdes PHY is required
+              when the Serdes has to be configured in Single-Link
+              configuration.
+
+          phy-names:
+            oneOf:
+              - items:
+                  - const: mac-phy
+                  - const: serdes-phy
+              - items:
+                  - const: mac-phy
+            description:
+              Identifiers for the CPSW MAC's PHY and the Serdes PHY.
+              CPSW MAC's PHY is required and therefore "mac-phy" is
+              required, while "serdes-phy" is optional.
 
           label:
             description: label associated with this port
-- 
2.25.1

