Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5116C6651BC
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 03:26:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235427AbjAKC0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 21:26:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235314AbjAKC0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 21:26:39 -0500
Received: from mx.socionext.com (mx.socionext.com [202.248.49.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 605DD63A1;
        Tue, 10 Jan 2023 18:26:37 -0800 (PST)
Received: from unknown (HELO iyokan2-ex.css.socionext.com) ([172.31.9.54])
  by mx.socionext.com with ESMTP; 11 Jan 2023 11:26:36 +0900
Received: from mail.mfilter.local (m-filter-1 [10.213.24.61])
        by iyokan2-ex.css.socionext.com (Postfix) with ESMTP id 220E82058B4F;
        Wed, 11 Jan 2023 11:26:36 +0900 (JST)
Received: from 172.31.9.51 (172.31.9.51) by m-FILTER with ESMTP; Wed, 11 Jan 2023 11:26:36 +0900
Received: from plum.e01.socionext.com (unknown [10.212.243.119])
        by kinkan2.css.socionext.com (Postfix) with ESMTP id 91CFC3D58;
        Wed, 11 Jan 2023 11:26:35 +0900 (JST)
From:   Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Marek Vasut <marex@denx.de>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Subject: [PATCH net] dt-bindings: net: snps,stmmac: Fix inconsistencies in some properties belonging to stmmac-axi-config
Date:   Wed, 11 Jan 2023 11:26:22 +0900
Message-Id: <20230111022622.6779-1-hayashi.kunihiko@socionext.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The description of some properties in stmmac-axi-config don't match the
behavior of the corresponding driver. Fix the inconsistencies by fixing
the dt-schema.

Fixes: 5361660af6d3 ("dt-bindings: net: snps,dwmac: Document stmmac-axi-config subnode")
Fixes: afea03656add ("stmmac: rework DMA bus setting and introduce new platform AXI structure")
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
---
 .../devicetree/bindings/net/snps,dwmac.yaml      | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

In this patch the definition of the corresponding driver is applied.
If applying the definition of the devicetree, we need to change the driver
instead of this patch.

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index e88a86623fce..2332bf7cfcd4 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -158,11 +158,11 @@ properties:
         * snps,xit_frm, unlock on WoL
         * snps,wr_osr_lmt, max write outstanding req. limit
         * snps,rd_osr_lmt, max read outstanding req. limit
-        * snps,kbbe, do not cross 1KiB boundary.
+        * snps,axi_kbbe, do not cross 1KiB boundary.
         * snps,blen, this is a vector of supported burst length.
-        * snps,fb, fixed-burst
-        * snps,mb, mixed-burst
-        * snps,rb, rebuild INCRx Burst
+        * snps,axi_fb, fixed-burst
+        * snps,axi_mb, mixed-burst
+        * snps,axi_rb, rebuild INCRx Burst
 
   snps,mtl-rx-config:
     $ref: /schemas/types.yaml#/definitions/phandle
@@ -516,7 +516,7 @@ properties:
         description:
           max read outstanding req. limit
 
-      snps,kbbe:
+      snps,axi_kbbe:
         $ref: /schemas/types.yaml#/definitions/uint32
         description:
           do not cross 1KiB boundary.
@@ -528,17 +528,17 @@ properties:
         minItems: 7
         maxItems: 7
 
-      snps,fb:
+      snps,axi_fb:
         $ref: /schemas/types.yaml#/definitions/flag
         description:
           fixed-burst
 
-      snps,mb:
+      snps,axi_mb:
         $ref: /schemas/types.yaml#/definitions/flag
         description:
           mixed-burst
 
-      snps,rb:
+      snps,axi_rb:
         $ref: /schemas/types.yaml#/definitions/flag
         description:
           rebuild INCRx Burst
-- 
2.25.1

