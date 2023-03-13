Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C565F6B8562
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 23:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbjCMWyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 18:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbjCMWxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 18:53:34 -0400
Received: from post.baikalelectronics.com (post.baikalelectronics.com [213.79.110.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 61FC392F30;
        Mon, 13 Mar 2023 15:52:54 -0700 (PDT)
Received: from post.baikalelectronics.com (localhost.localdomain [127.0.0.1])
        by post.baikalelectronics.com (Proxmox) with ESMTP id A5BB5E0EC0;
        Tue, 14 Mar 2023 01:51:29 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        baikalelectronics.ru; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:from:from:in-reply-to:message-id
        :mime-version:references:reply-to:subject:subject:to:to; s=post;
         bh=6xrFxVFBCRoCwxV5M3KY75YLEifw9tZ9oXtCfQTCeVs=; b=KMRYLuxUvxwE
        kwtRfkaJKPlM5KUepPRKyA5TfFU7uP5VUadRQWnfhFfx5HdNeTL2phNG7hF1bIim
        r8XK0Lf2AslW63hVY3Io0uz2uNSzMYvsArsFflyTdipDptWQgujEkPosznPVTHW3
        O/Kk6PLGGD7P4j7yMIf0zAGOhSATCSQ=
Received: from mail.baikal.int (mail.baikal.int [192.168.51.25])
        by post.baikalelectronics.com (Proxmox) with ESMTP id 87853E0E6A;
        Tue, 14 Mar 2023 01:51:29 +0300 (MSK)
Received: from localhost (10.8.30.10) by mail (192.168.51.25) with Microsoft
 SMTP Server (TLS) id 15.0.1395.4; Tue, 14 Mar 2023 01:51:28 +0300
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
CC:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 14/16] dt-bindings: net: dwmac: Use flag definition instead of booleans
Date:   Tue, 14 Mar 2023 01:51:01 +0300
Message-ID: <20230313225103.30512-15-Sergey.Semin@baikalelectronics.ru>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230313225103.30512-1-Sergey.Semin@baikalelectronics.ru>
References: <20230313225103.30512-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.8.30.10]
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently some of the boolean properties defined in the DT-schema are
marked to have the basic boolean type meanwhile the rest referencing the
/schemas/types.yaml#/definitions/flag schema. For the sake of unification
let's convert the first group to referencing the pre-defined flag schema.
Thus bindings will look a bit more coherent and the DT-bindings
maintainers will have a better control over the booleans defined in the
schema (if ever needed).

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 .../devicetree/bindings/net/snps,dwmac.yaml   | 45 ++++++++++++-------
 1 file changed, 30 insertions(+), 15 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 69be39d55403..a863b5860566 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -120,11 +120,13 @@ properties:
         maximum: 12
 
       snps,rx-sched-sp:
-        type: boolean
+        $ref: /schemas/types.yaml#/definitions/flag
         description: Strict priority
+
       snps,rx-sched-wsp:
-        type: boolean
+        $ref: /schemas/types.yaml#/definitions/flag
         description: Weighted Strict priority
+
     allOf:
       - if:
           required:
@@ -144,11 +146,13 @@ properties:
         type: object
         properties:
           snps,dcb-algorithm:
-            type: boolean
+            $ref: /schemas/types.yaml#/definitions/flag
             description: Queue to be enabled as DCB
+
           snps,avb-algorithm:
-            type: boolean
+            $ref: /schemas/types.yaml#/definitions/flag
             description: Queue to be enabled as AVB
+
           snps,map-to-dma-channel:
             $ref: /schemas/types.yaml#/definitions/uint32
             description: DMA channel id to map
@@ -156,20 +160,25 @@ properties:
             maximum: 15
 
           snps,route-avcp:
-            type: boolean
+            $ref: /schemas/types.yaml#/definitions/flag
             description: AV Untagged Control packets
+
           snps,route-ptp:
-            type: boolean
+            $ref: /schemas/types.yaml#/definitions/flag
             description: PTP Packets
+
           snps,route-dcbcp:
-            type: boolean
+            $ref: /schemas/types.yaml#/definitions/flag
             description: DCB Control Packets
+
           snps,route-up:
-            type: boolean
+            $ref: /schemas/types.yaml#/definitions/flag
             description: Untagged Packets
+
           snps,route-multi-broad:
-            type: boolean
+            $ref: /schemas/types.yaml#/definitions/flag
             description: Multicast & Broadcast Packets
+
           snps,priority:
             $ref: /schemas/types.yaml#/definitions/uint32
             description: Bitmask of the tagged frames priorities assigned to the queue
@@ -255,17 +264,21 @@ properties:
         maximum: 16
 
       snps,tx-sched-wrr:
-        type: boolean
+        $ref: /schemas/types.yaml#/definitions/flag
         description: Weighted Round Robin
+
       snps,tx-sched-wfq:
-        type: boolean
+        $ref: /schemas/types.yaml#/definitions/flag
         description: Weighted Fair Queuing
+
       snps,tx-sched-dwrr:
-        type: boolean
+        $ref: /schemas/types.yaml#/definitions/flag
         description: Deficit Weighted Round Robin
+
       snps,tx-sched-sp:
-        type: boolean
+        $ref: /schemas/types.yaml#/definitions/flag
         description: Strict priority
+
     allOf:
       - if:
           required:
@@ -311,14 +324,16 @@ properties:
             maximum: 0x1312D0
 
           snps,dcb-algorithm:
-            type: boolean
+            $ref: /schemas/types.yaml#/definitions/flag
             description: TX queue will be working in DCB
+
           snps,avb-algorithm:
-            type: boolean
+            $ref: /schemas/types.yaml#/definitions/flag
             description:
               TX queue will be working in AVB.
               Queue 0 is reserved for legacy traffic and so no AVB is
               available in this queue.
+
           snps,send_slope:
             $ref: /schemas/types.yaml#/definitions/uint32
             description:
-- 
2.39.2


