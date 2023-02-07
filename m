Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3865068DEB4
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 18:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbjBGRQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 12:16:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232465AbjBGRPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 12:15:50 -0500
Received: from mxout1.routing.net (mxout1.routing.net [IPv6:2a03:2900:1:a::a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D82BD3F281;
        Tue,  7 Feb 2023 09:15:20 -0800 (PST)
Received: from mxbox4.masterlogin.de (unknown [192.168.10.79])
        by mxout1.routing.net (Postfix) with ESMTP id E42B441A6D;
        Tue,  7 Feb 2023 17:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailerdienst.de;
        s=20200217; t=1675790119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=JLrL4iWympNnVNwAETpNE1kjBqSNjCEjKLn1CYJsz9g=;
        b=s8/mNx/3hM5Z1BYZzXx5/GGPmL6fAfaQZV9DpVzN3oIYNqzMtl75EC9k/1Y8y/zd0bRaWX
        CgAB6WfedG3wqUIB5pJxKlSjm4keFwfeeYJvkRapmLtnr8O7fbAGOEpFdmDoag7+LkCu4U
        obWTm6EXVkSvv9RzF0AUXySe+yJj6g4=
Received: from frank-G5.. (fttx-pool-217.61.159.155.bambit.de [217.61.159.155])
        by mxbox4.masterlogin.de (Postfix) with ESMTPSA id 8A269802E7;
        Tue,  7 Feb 2023 17:15:17 +0000 (UTC)
From:   Frank Wunderlich <linux@fw-web.de>
To:     linux-mediatek@lists.infradead.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: mt76: allow up to 4 interrupts for mt7986
Date:   Tue,  7 Feb 2023 18:15:12 +0100
Message-Id: <20230207171512.35425-1-linux@fw-web.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Mail-ID: 335c7e56-e374-4379-9b78-55056f0c79f6
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Frank Wunderlich <frank-w@public-files.de>

Mt7986 needs 4 interrupts which are already defined in mt7986a.dtsi.
Update binding to reflect it

This fixes this error in dtbs_check (here only bpi-r3 example):

arch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3.dtb: wifi@18000000:
interrupts: [[0, 213, 4], [0, 214, 4], [0, 215, 4], [0, 216, 4]] is too long
	From schema: Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
arch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3.dtb: wifi@18000000:
Unevaluated properties are not allowed ('interrupts' was unexpected)
	From schema: Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml

Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
---
 .../devicetree/bindings/net/wireless/mediatek,mt76.yaml      | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
index 212508672979..222b657fe4ea 100644
--- a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
@@ -38,7 +38,10 @@ properties:
       MT7986 should contain 3 regions consys, dcm, and sku, in this order.
 
   interrupts:
-    maxItems: 1
+    minItems: 1
+    maxItems: 4
+    description:
+      MT7986 should contain 4 items.
 
   power-domains:
     maxItems: 1
-- 
2.34.1

