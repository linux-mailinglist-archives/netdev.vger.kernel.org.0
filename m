Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17D226B854D
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 23:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbjCMWxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 18:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbjCMWwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 18:52:54 -0400
Received: from post.baikalelectronics.com (post.baikalelectronics.com [213.79.110.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 85E938B064;
        Mon, 13 Mar 2023 15:52:15 -0700 (PDT)
Received: from post.baikalelectronics.com (localhost.localdomain [127.0.0.1])
        by post.baikalelectronics.com (Proxmox) with ESMTP id 0903DE0EB7;
        Tue, 14 Mar 2023 01:51:16 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        baikalelectronics.ru; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:from:from:in-reply-to:message-id
        :mime-version:references:reply-to:subject:subject:to:to; s=post;
         bh=oyRmDVoN+2lAomqaOYUxFd6Rs2QRCU3KaCv853AjErI=; b=iNRjn9CHeGAW
        ovD3bq746Zx0qmkDhXjwwClvb6q8j+ts/mn6WBauv2l4//vaxR8YwoXDnoqYDsM/
        kWLtXoKfBn0fZfJXfzzjY0A34xL9wCEV7bGpCavA6gXGsyXh91rOGpHB/Y+NmZcA
        Wmh0L1vlts+pO3pgU4LkvFBZgxUFFIk=
Received: from mail.baikal.int (mail.baikal.int [192.168.51.25])
        by post.baikalelectronics.com (Proxmox) with ESMTP id D28EDE0E6A;
        Tue, 14 Mar 2023 01:51:15 +0300 (MSK)
Received: from localhost (10.8.30.10) by mail (192.168.51.25) with Microsoft
 SMTP Server (TLS) id 15.0.1395.4; Tue, 14 Mar 2023 01:51:15 +0300
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
Subject: [PATCH net-next 06/16] dt-bindings: net: dwmac: Elaborate stmmaceth/pclk clocks description
Date:   Tue, 14 Mar 2023 01:50:53 +0300
Message-ID: <20230313225103.30512-7-Sergey.Semin@baikalelectronics.ru>
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

Current clocks description doesn't provide a comprehensive notion about
what "stmmaceth" and "pclk" actually represent from the IP-core manual
point of view. The bindings file states:
stmmaceth - "GMAC main clock",
apb - "Peripheral registers interface clock".
It isn't that easy to understand what they actually mean especially seeing
the DW *MAC manual operates with clock definitions like Application,
System, Host, CSR, Transmit, Receive, etc clocks. Moreover the clocks
usage in the driver doesn't shade a full light on their essence. What
inferred from there is that the "stmmaceth" name has been assigned to the
common clock, which feeds both system and CSR interfaces. But what about
"apb"? The bindings defines it as the clock for "peripheral registers
interface". So it's close to the CSR clock in the IP-core manual notation.
If so then when "apb" clock is specified aside with the "stmmaceth", it
represents a case when the DW *MAC is synthesized with CSR_SLV_CLK=y
(separate system and CSR clocks). But even though the "apb" clock is
requested in the MAC driver, the driver doesn't actually use it as a
separate CSR clock where the IP-core manual requires. All of that makes me
thinking that the case of separate system and CSR clocks isn't correctly
implemented in the driver.

Let's start with elaborating the clocks description so anyone reading
the DW *MAC bindings file would understand that "stmmaceth" is the
system clock and "pclk" is actually the CSR clock. Indeed in accordance
with sheets depicted in [1]:
system/application clock can be either of: hclk_i, aclk_i, clk_app_i;
CSR clock can be either of: hclk_i, aclk_i, clk_app_i, clk_csr_i.
(Similar definitions present in the others IP-core manuals.) So the CSR
clock can be tied to the application clock considering the later as the
main clock, but not the other way around. In case if there is only
"stmmaceth" clock specified in a DT node, then it will be considered as a
source of clock signal for both application and CSR. But if "pclk" is also
specified in the list of the device clocks, then it will be perceived as
the separate CSR clock.

[1] DesignWare Cores Ethernet MAC Universal Databook, Revision 3.73a,
    October 2013, p. 564.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/net/snps,dwmac.yaml          | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index edef405766e4..3e3fbc1dfafa 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -37,8 +37,16 @@ properties:
     maxItems: 8
     additionalItems: true
     items:
-      - description: GMAC main clock
-      - description: Peripheral registers interface clock
+      - description:
+          GMAC main clock, also called as system/application clock.
+          This clock is used to provide a periodic signal for the DMA/MTL
+          interface and optionally for CSR, if the later isn't separately
+          clocked.
+      - description:
+          Peripheral registers interface clock, also called as CSR clock.
+          MCI, CSR and SMA interfaces run on this clock. If it's omitted,
+          the CSR interfaces are considered as synchronous to the system
+          clock domain.
       - description:
           PTP reference clock. This clock is used for programming the
           Timestamp Addend Register. If not passed then the system
-- 
2.39.2


