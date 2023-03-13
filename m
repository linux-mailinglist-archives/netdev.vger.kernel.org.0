Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82E586B855E
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 23:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbjCMWyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 18:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbjCMWxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 18:53:33 -0400
Received: from post.baikalelectronics.com (post.baikalelectronics.com [213.79.110.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DF39592F2C;
        Mon, 13 Mar 2023 15:52:53 -0700 (PDT)
Received: from post.baikalelectronics.com (localhost.localdomain [127.0.0.1])
        by post.baikalelectronics.com (Proxmox) with ESMTP id 50FC9E0EBF;
        Tue, 14 Mar 2023 01:51:28 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        baikalelectronics.ru; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:from:from:in-reply-to:message-id
        :mime-version:references:reply-to:subject:subject:to:to; s=post;
         bh=KQsws9NtBO6QlsruSY3+0FhvjbX+2h0WTEcfdAMql2o=; b=rsHkLLEACOd4
        MLMrh1uCsrIY/0keomOkDe34risa0j+VGgK0mFNltJnIQ2RNaDlyf3jHNG1GxRWV
        5Is6De4IdjTJkSxBjP4OuW1NdPtcpiBer0uz6ngIRdKEY9ypUW1D1LIAYIxXgh9S
        voPHE4s6yX7qOx+EheLu5ZNtdKtBNJo=
Received: from mail.baikal.int (mail.baikal.int [192.168.51.25])
        by post.baikalelectronics.com (Proxmox) with ESMTP id 0FADBE0E6A;
        Tue, 14 Mar 2023 01:51:28 +0300 (MSK)
Received: from localhost (10.8.30.10) by mail (192.168.51.25) with Microsoft
 SMTP Server (TLS) id 15.0.1395.4; Tue, 14 Mar 2023 01:51:27 +0300
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
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>
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
Subject: [PATCH net-next 13/16] dt-bindings: net: dwmac: Fix MTL Tx Queue props description
Date:   Tue, 14 Mar 2023 01:51:00 +0300
Message-ID: <20230313225103.30512-14-Sergey.Semin@baikalelectronics.ru>
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

Invalid MTL Tx Queues DT-properties description was added right at the
initial DCB/AVB features patch. Most likely due to copy-paste mistake the
text currently matches to what is specified for the AXI-bus config
properties. Let's fix that by providing correct descriptions for MTL Tx
Queue DT-properties utilized for the AVB feature (CBS algorithm) tuning.

Fixes: 19d918731797 ("net: stmmac: configuration of CBS in case of a TX AVB queue")
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 .../devicetree/bindings/net/snps,dwmac.yaml   | 20 +++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 2ebf7995426b..69be39d55403 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -321,25 +321,37 @@ properties:
               available in this queue.
           snps,send_slope:
             $ref: /schemas/types.yaml#/definitions/uint32
-            description: enable Low Power Interface
+            description:
+              Send-Slope credit value subtracted from the accumulated credit
+              in the Queue for the Audio/Video bridging traffic. This is the
+              rate of the credit change in bits per cycle (40 ns, 8 ns and
+              3.2 ns for 100 Mbps, 1000 Mbps and 2.5/10 Gbps respectively).
             minimum: 0
             maximum: 0x3FFF
 
           snps,idle_slope:
             $ref: /schemas/types.yaml#/definitions/uint32
-            description: unlock on WoL
+            description:
+              Idle-Slope credit value added to the accumulated credit in the
+              Queue with the Audio/Video bridging enabled. This is the
+              rate of the credit change in bits per cycle (40 ns, 8 ns and
+              3.2 ns for 100 Mbps, 1000 Mbps and 2.5/10 Gbps respectively).
             minimum: 0
             maximum: 0x8000
 
           snps,high_credit:
             $ref: /schemas/types.yaml#/definitions/uint32
-            description: max write outstanding req. limit
+            description:
+              Maximum value accumulated in the credit parameter for the
+              Audio/Video bridging feature (specified in bits scaled by 1,024).
             minimum: 0
             maximum: 0x1FFFFFFF
 
           snps,low_credit:
             $ref: /schemas/types.yaml#/definitions/uint32
-            description: max read outstanding req. limit
+            description:
+              Minimum value accumulated in the credit parameter for the
+              Audio/Video bridging feature (specified in bits scaled by 1,024).
             minimum: 0
             maximum: 0x1FFFFFFF
 
-- 
2.39.2


