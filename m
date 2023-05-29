Return-Path: <netdev+bounces-6019-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1218471461A
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 10:09:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C79BC280D41
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 08:09:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 997934437;
	Mon, 29 May 2023 08:08:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880744422
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 08:08:52 +0000 (UTC)
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3B5ADBB;
	Mon, 29 May 2023 01:08:50 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="6.00,200,1681138800"; 
   d="scan'208";a="161242008"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 29 May 2023 17:08:49 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
	by relmlir5.idc.renesas.com (Postfix) with ESMTP id 8E52C400C741;
	Mon, 29 May 2023 17:08:49 +0900 (JST)
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To: s.shtylyov@omp.ru,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	robh+dt@kernel.org,
	krzysztof.kozlowski+dt@linaro.org,
	conor+dt@kernel.org,
	geert+renesas@glider.be,
	magnus.damm@gmail.com
Cc: netdev@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH net-next 1/5] dt-bindings: net: r8a779f0-ether-switch: Add ACLK
Date: Mon, 29 May 2023 17:08:36 +0900
Message-Id: <20230529080840.1156458-2-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230529080840.1156458-1-yoshihiro.shimoda.uh@renesas.com>
References: <20230529080840.1156458-1-yoshihiro.shimoda.uh@renesas.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add ACLK of GWCA which needs to calculate registers' values for
rate limiter feature.

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 .../bindings/net/renesas,r8a779f0-ether-switch.yaml    | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/renesas,r8a779f0-ether-switch.yaml b/Documentation/devicetree/bindings/net/renesas,r8a779f0-ether-switch.yaml
index e933a1e48d67..cbe05fdcadaf 100644
--- a/Documentation/devicetree/bindings/net/renesas,r8a779f0-ether-switch.yaml
+++ b/Documentation/devicetree/bindings/net/renesas,r8a779f0-ether-switch.yaml
@@ -75,7 +75,12 @@ properties:
       - const: rmac2_phy
 
   clocks:
-    maxItems: 1
+    maxItems: 2
+
+  clock-names:
+    items:
+      - const: fck
+      - const: aclk
 
   resets:
     maxItems: 1
@@ -221,7 +226,8 @@ examples:
                           "rmac2_mdio",
                           "rmac0_phy", "rmac1_phy",
                           "rmac2_phy";
-        clocks = <&cpg CPG_MOD 1505>;
+        clocks = <&cpg CPG_MOD 1505>, <&cpg CPG_CORE R8A779F0_CLK_S0D2_HSC>;
+        clock-names = "fck", "aclk";
         power-domains = <&sysc R8A779F0_PD_ALWAYS_ON>;
         resets = <&cpg 1505>;
 
-- 
2.25.1


