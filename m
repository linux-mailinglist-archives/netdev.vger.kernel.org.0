Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 677926B8549
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 23:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbjCMWxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 18:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbjCMWwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 18:52:53 -0400
Received: from post.baikalelectronics.com (post.baikalelectronics.com [213.79.110.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 872208C0DA;
        Mon, 13 Mar 2023 15:52:15 -0700 (PDT)
Received: from post.baikalelectronics.com (localhost.localdomain [127.0.0.1])
        by post.baikalelectronics.com (Proxmox) with ESMTP id 79972E0EB6;
        Tue, 14 Mar 2023 01:51:14 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        baikalelectronics.ru; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:from:from:in-reply-to:message-id
        :mime-version:references:reply-to:subject:subject:to:to; s=post;
         bh=kB5Ypu9uI3/FVnScRsT5+ZCB/6/xGkijVX1+bsbiHl8=; b=AEiiwI5J1GW3
        D/CidPHbAkj76a8RRcOgx654EoNK2OStvsjMtS4MEDlWxcM8AZMYkpHGHJ26Jleb
        5WRkgKgzT+IEOYdGquZxV0kmd/1GbW/hVCKvLrBwTDIRFXbVpulymvcCiMjCF3DP
        LQeGU7zYIPNRS5PWZ1Qo2az1Js2YFX0=
Received: from mail.baikal.int (mail.baikal.int [192.168.51.25])
        by post.baikalelectronics.com (Proxmox) with ESMTP id 63DCDE0E6A;
        Tue, 14 Mar 2023 01:51:14 +0300 (MSK)
Received: from localhost (10.8.30.10) by mail (192.168.51.25) with Microsoft
 SMTP Server (TLS) id 15.0.1395.4; Tue, 14 Mar 2023 01:51:13 +0300
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
Subject: [PATCH net-next 05/16] dt-bindings: net: dwmac: Elaborate snps,clk-csr description
Date:   Tue, 14 Mar 2023 01:50:52 +0300
Message-ID: <20230313225103.30512-6-Sergey.Semin@baikalelectronics.ru>
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

The property is utilized to set the CSR-MDC clock selector in the STMMAC
driver. The specified value is used instead of auto-detecting the
CSR/application clocks divider based on the reference clock rate. Let's
add a more detailed description to clarify the property purpose and
permitted values. In the later case the constraints are specified based on
the DW *MAC CR registers permitted values.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 Documentation/devicetree/bindings/net/snps,dwmac.yaml | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 224f8f70db85..edef405766e4 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -427,7 +427,15 @@ properties:
   snps,clk-csr:
     $ref: /schemas/types.yaml#/definitions/uint32
     description:
-      Frequency division factor for MDC clock.
+      CSR-MDC clock selector. It sets up a divider of the CSR/application
+      clock to create an MDC signal with desired frequency. Note the
+      property value doesn't specify the divider itself by encodes the
+      corresponding divider value specific to the IP-core.
+      DW GMAC 0 - 42, 1 - 62, 2 - 16, 3 - 26, 4 - 102, 5 - 124, 8 - 4,
+              9 - 6, 10 - 8, 11 - 10, 12 - 12, 13 - 14, 14 - 16, 15 - 18.
+      DW xGMAC 0 - 62, 1 - 102, 2 - 122, 3 - 142, 4 - 162, 5 - 202.
+    minimum: 0
+    maximum: 15
 
   mdio:
     $ref: mdio.yaml#
-- 
2.39.2


