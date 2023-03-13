Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 609F76B8538
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 23:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbjCMWwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 18:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjCMWwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 18:52:08 -0400
Received: from post.baikalelectronics.com (post.baikalelectronics.com [213.79.110.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9772A5BC8D;
        Mon, 13 Mar 2023 15:51:40 -0700 (PDT)
Received: from post.baikalelectronics.com (localhost.localdomain [127.0.0.1])
        by post.baikalelectronics.com (Proxmox) with ESMTP id 9DAA8E0EB1;
        Tue, 14 Mar 2023 01:51:06 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        baikalelectronics.ru; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:from:from:message-id
        :mime-version:reply-to:subject:subject:to:to; s=post; bh=20td581
        5OptUIxR9S+Fsvw+x+FPjDGPbexfUZ0eZGN4=; b=J238E5ZgG1lJC8KVbX/cetX
        PB3W0psKwHbkOGMm+NsqVAEKxbOn8wtoJPFZ+EyC9/u+zqRNfxfLIN3c73zQoR66
        gYcGrus5YY1nVscjhTh//UKP7Jk+Rw0WfGfjJIN4y/8ECF9Ah9Kw7nhRJO7kq2yA
        tNDdSg4fV11DEChBIDrs=
Received: from mail.baikal.int (mail.baikal.int [192.168.51.25])
        by post.baikalelectronics.com (Proxmox) with ESMTP id 8354DE0E6A;
        Tue, 14 Mar 2023 01:51:06 +0300 (MSK)
Received: from localhost (10.8.30.10) by mail (192.168.51.25) with Microsoft
 SMTP Server (TLS) id 15.0.1395.4; Tue, 14 Mar 2023 01:51:05 +0300
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
Subject: [PATCH net-next 00/16] dt-bindings: net: dwmac: Extend clocks, props desc and constraints
Date:   Tue, 14 Mar 2023 01:50:47 +0300
Message-ID: <20230313225103.30512-1-Sergey.Semin@baikalelectronics.ru>
X-Mailer: git-send-email 2.39.2
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

This patchset is the fourth one in the series of updates implemented in
the framework of activity to simplify the DW MAC/STMMAC driver code and
provide Baikal GMAC/X-GMAC support after all:

[1: In-review v1]: net: stmmac: Fixes bundle #1
Link: https://lore.kernel.org/netdev/20230313224237.28757-1-Sergey.Semin@baikalelectronics.ru/
[2: Stalled   v1]: net: stmmac: Fixes bundle #2
Link: ---not submitted yet---
[3: Stalled   v1]: net: stmmac: Fixes bundle #3
Link: ---not submitted yet---
+> [4: In-review v1]: dt-bindings: net: dwmac: Extend clocks, props desc and constraints
+> Link: ---you are looking at it---
[5: Stalled   v1]: dt-bindings: net: dwmac: Fix MTL queues and AXI-bus props
Link: ---not submitted yet---
[6: Stalled   v1]: net: stmmac: Generic platform res, props and DMA cleanups
Link: ---not submitted yet---
[7: Stalled   v1]: net: stmmac: Generic platform rst, phy and clk cleanups
Link: ---not submitted yet---
[8: Stalled   v1]: net: stmmac: Main driver code cleanups bundle #1
Link: ---not submitted yet---
[9: Stalled   v1]: net: stmmac: Main driver code cleanups bundle #2
Link: ---not submitted yet---
[10: Stalled  v1]: net: stmmac: DW MAC HW info init refactoring
Link: ---not submitted yet---
[11: Stalled  v1]: net: stmmac: Convert to using HW capabilities bundle #1
Link: ---not submitted yet---
[12: Stalled  v1]: net: stmmac: Convert to using HW capabilities bundle #2
Link: ---not submitted yet---
[13: Stalled  v1]: net: stmmac: Convert to using HW capabilities bundle #3
Link: ---not submitted yet---
[14: Stalled  v1]: net: stmmac: Convert to using HW capabilities bundle #4
Link: ---not submitted yet---
[15: Stalled  v1]: net: stmmac: Unify/simplify HW-interface
Link: ---not submitted yet---
[16: Stalled  v1]: net: stmmac: Norm/Enh/etc DMA descriptor init fixes
Link: ---not submitted yet---
[17: Stalled  v1]: net: stmmac: Norm/Enh/etc DMA descriptor init cleanups
Link: ---not submitted yet---
[18: Stalled  v1]: net: stmmac: Main driver code cleanups bundle #3
Link: ---not submitted yet---
[..: In-prep] to be continued (IRQ handling refactoring, SW-reset-less config,
                               generic GPIO support, ARP offload support,
                               In-band RGMII link state, etc)
[..: In-prep] to be continued (Baikal-{T,M,L,S} SoCs GMAC, X-GMAC and XPCS
                               support)

Please visit the next link for the detailed justification of the changes
series introduced in the list above:
Link: https://lore.kernel.org/netdev/20230313224237.28757-1-Sergey.Semin@baikalelectronics.ru/

Here is a short summary of what is introduced in this patchset.

The series starts with fixes of the PBL (Programmable DMA Burst length)
DT-property, which is supposed to be defined for each DW *MAC IP-core, but
not only for a Allwinner sun* and Ingenic GMAC and DW xGMAC. The number of
possible PBL values need to be also extended in accordance with the DW
*MAC manual. Then the TSO flag property should be also declared free of
the vendor-specific conditional schema, because the driver expects the
compatible string to have the IP-core version specified anyway and none of
the glue-drivers refer to the property directly. Moreover the original
Allwinner sunXi bindings file didn't have the TSO-related property
declared. So we can freely do that.

Then in order to improve the DT-bindings maintainability we suggest to
split up the generic DT-properties and generic DT-nodes schema leaving the
properties definition in the "snps,dwmac.yaml" file and moving the generic
DW *MAC DT-nodes bindings validation in the dedicated DT-schema
"snps,dwmac-generic.yaml".

We've found out that the DW MAC bindings don't provide a correct description
of the System/CSR clocks and a comprehensive enough description of the
clock-related "snps,clk-csr" property. So in order to have more
descriptive bindings we suggest to add a bit more details about the
App/CSR clocks and CSR-MDC divider property.

Then seeing the any DW MAC IP-core revision can be equipped with an
external Tx/Rx clock sources we suggest to add the "tx"/"rx" clocks
declaration into the generic DW MAC DT-schema.

Afterwards a set of the AXI-bus config property cleanups are introduced.
First we suggest to drop the "snps,axi-config" property description since
it duplicates the stmmac-axi-config sub-node DT-bindings. Second the
unevaluatedProperties property is replaced with additionalProperties as
more suitable for the "stmmac-axi-config" schema. Third the proper
constraints are added to the properties of the "stmmac-axi-config"
sub-node.

Then three patches concerning the MTL Tx/Rx queue configs go, which add
the sub-nodes properties constraints and fix the MTL Tx queue properties
description.

The next patch converts the DW MAC DT-bindings to using the "flag"
definition instead of the native boolean type for relevant properties.
It's done for the sake of the DT-schema unification.

The series is closed with the two patches concerning the MTL queue config
properties dependencies. First one provides a simpler construction for the
MTL queue properties inter-dependencies. The second one adds the
dependencies definition for the MTL Tx queue CBS-algo properties.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc: Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>
Cc: Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>
Cc: Christian Marangi <ansuelsmth@gmail.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Biao Huang <biao.huang@mediatek.com>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Cc: devicetree@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org

Serge Semin (16):
  dt-bindings: net: dwmac: Validate PBL for all IP-cores
  dt-bindings: net: dwmac: Extend number of PBL values
  dt-bindings: net: dwmac: Fix the TSO property declaration
  dt-bindings: net: dwmac: Detach Generic DW MAC bindings
  dt-bindings: net: dwmac: Elaborate snps,clk-csr description
  dt-bindings: net: dwmac: Elaborate stmmaceth/pclk clocks description
  dt-bindings: net: dwmac: Add Tx/Rx clock sources
  dt-bindings: net: dwmac: Drop prop names from snps,axi-config
    description
  dt-bindings: net: dwmac: Prohibit additional props in AXI-config
  dt-bindings: net: dwmac: Add AXI-bus properties constraints
  dt-bindings: net: dwmac: Add MTL Rx Queue properties constraints
  dt-bindings: net: dwmac: Add MTL Tx Queue properties constraints
  dt-bindings: net: dwmac: Fix MTL Tx Queue props description
  dt-bindings: net: dwmac: Use flag definition instead of booleans
  dt-bindings: net: dwmac: Simplify MTL queue props dependencies
  dt-bindings: net: dwmac: Add MTL Tx queue CBS-algo props dependencies

 .../bindings/net/snps,dwmac-generic.yaml      | 155 +++++
 .../devicetree/bindings/net/snps,dwmac.yaml   | 586 +++++++-----------
 MAINTAINERS                                   |   1 +
 3 files changed, 381 insertions(+), 361 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/snps,dwmac-generic.yaml

-- 
2.39.2


