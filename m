Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9016B853F
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 23:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbjCMWwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 18:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbjCMWwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 18:52:13 -0400
Received: from post.baikalelectronics.com (post.baikalelectronics.com [213.79.110.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5E10617CF1;
        Mon, 13 Mar 2023 15:51:48 -0700 (PDT)
Received: from post.baikalelectronics.com (localhost.localdomain [127.0.0.1])
        by post.baikalelectronics.com (Proxmox) with ESMTP id 7D222E0EB3;
        Tue, 14 Mar 2023 01:51:09 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        baikalelectronics.ru; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:from:from:in-reply-to:message-id
        :mime-version:references:reply-to:subject:subject:to:to; s=post;
         bh=kthLOnTvdI5B68iXv3NtNVKvPTWVJkrui6RMOnKn7gs=; b=R1LVmsJTQUkR
        epWSuw/HlktHE+Y1XsNC3ZqFoXyCuTD2sBXtPmC6kKs7+v2Qi1OLu/sZk9PZVU8h
        YH7CD27aixfnJrARjyWIMtnu7CuqjJDB6Y1NUH9//5oeSk4zQ12acVxA7uWrln+C
        oeKATIua1dM6JQr4ZWEeD9npu32Xmes=
Received: from mail.baikal.int (mail.baikal.int [192.168.51.25])
        by post.baikalelectronics.com (Proxmox) with ESMTP id 6B321E0E6A;
        Tue, 14 Mar 2023 01:51:09 +0300 (MSK)
Received: from localhost (10.8.30.10) by mail (192.168.51.25) with Microsoft
 SMTP Server (TLS) id 15.0.1395.4; Tue, 14 Mar 2023 01:51:08 +0300
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
        <linux-kernel@vger.kernel.org>, Rob Herring <robh@kernel.org>
Subject: [PATCH net-next 02/16] dt-bindings: net: dwmac: Extend number of PBL values
Date:   Tue, 14 Mar 2023 01:50:49 +0300
Message-ID: <20230313225103.30512-3-Sergey.Semin@baikalelectronics.ru>
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

In accordance with [1] the permitted PBL values can be set as one of [1,
2, 4, 8, 16, 32]. The rest of the values result in undefined behavior. At
the same time some of the permitted values can be also invalid depending
on the controller FIFOs size and the data bus width. Due to having too
many variables all the possible PBL property constraints can't be
implemented in the bindings schema, let's extend the set of permitted PBL
values to be as much as the configuration register supports leaving the
undefined behaviour cases for developers to handle.

[1] DesignWare Cores Ethernet MAC Universal Databook, Revision 3.73a,
    October 2013, p. 380.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Reviewed-by: Rob Herring <robh@kernel.org>

---

Changelog v1:
- Use correct syntax of the JSON pointers, so the later would begin
  with a '/' after the '#'.
---
 Documentation/devicetree/bindings/net/snps,dwmac.yaml | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index a0a0437eb4f0..fb9b8506a48f 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -428,23 +428,26 @@ properties:
 
   snps,pbl:
     description:
-      Programmable Burst Length (tx and rx)
+      Programmable Burst Length (tx and rx). Note some of these values
+      can be still invalid due to HW limitations connected with the data
+      bus width and the FIFOs depth, so a total length of a single DMA
+      burst shouldn't exceed half the FIFO depth.
     $ref: /schemas/types.yaml#/definitions/uint32
-    enum: [2, 4, 8]
+    enum: [1, 2, 4, 8, 16, 32]
 
   snps,txpbl:
     description:
       Tx Programmable Burst Length. If set, DMA tx will use this
       value rather than snps,pbl.
     $ref: /schemas/types.yaml#/definitions/uint32
-    enum: [2, 4, 8]
+    enum: [1, 2, 4, 8, 16, 32]
 
   snps,rxpbl:
     description:
       Rx Programmable Burst Length. If set, DMA rx will use this
       value rather than snps,pbl.
     $ref: /schemas/types.yaml#/definitions/uint32
-    enum: [2, 4, 8]
+    enum: [1, 2, 4, 8, 16, 32]
 
   snps,no-pbl-x8:
     $ref: /schemas/types.yaml#/definitions/flag
-- 
2.39.2


