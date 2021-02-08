Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 936003134DC
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 15:19:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232948AbhBHOSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 09:18:09 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:57558 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231458AbhBHOJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 09:09:09 -0500
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Rob Herring <robh+dt@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/16] dt-bindings: net: dwmac: Add DW GMAC GPIOs properties
Date:   Mon, 8 Feb 2021 17:08:05 +0300
Message-ID: <20210208140820.10410-2-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20210208140820.10410-1-Sergey.Semin@baikalelectronics.ru>
References: <20210208140820.10410-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Synopsys DesignWare Ethernet controllers can be synthesized with
General-Purpose IOs support. GPIOs can work either as inputs or as outputs
thus belong to the gpi_i and gpo_o ports respectively. The ports width
(number of possible inputs/outputs) and the configuration registers layout
depend on the IP-core version. For instance, DW GMAC can have from 0 to 4
GPIs and from 0 to 4 GPOs, while DW xGMAC have a wider ports width up to
16 pins of each one.

So the DW MAC DT-node can be equipped with "ngpios" property, which can't
have a value greater than 32, standard GPIO-related properties like
"gpio-controller" and "#gpio-cells", and, if GPIs are supposed to be
detected, IRQ-controller related properties.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 .../devicetree/bindings/net/snps,dwmac.yaml     | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index bdc437b14878..fcca23d3727e 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -110,6 +110,23 @@ properties:
   reset-names:
     const: stmmaceth
 
+  ngpios:
+    description:
+      Total number of GPIOs the MAC supports. The property shall include both
+      the GPI and GPO ports width.
+    minimum: 1
+    maximum: 32
+
+  gpio-controller: true
+
+  "#gpio-cells":
+    const: 2
+
+  interrupt-controller: true
+
+  "#interrupt-cells":
+    const: 2
+
   mac-mode:
     $ref: ethernet-controller.yaml#/properties/phy-connection-type
     description:
-- 
2.29.2

