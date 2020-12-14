Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 600632D94F0
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 10:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439684AbgLNJSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 04:18:05 -0500
Received: from ns2.baikalelectronics.ru ([94.125.187.42]:46512 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729478AbgLNJRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 04:17:52 -0500
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Rob Herring <robh+dt@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Joao Pinto <jpinto@synopsys.com>,
        Lars Persson <larper@axis.com>
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
Subject: [PATCH 06/25] dt-bindings: net: dwmac: Add Tx/Rx clock sources
Date:   Mon, 14 Dec 2020 12:15:56 +0300
Message-ID: <20201214091616.13545-7-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20201214091616.13545-1-Sergey.Semin@baikalelectronics.ru>
References: <20201214091616.13545-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Generic DW *MAC can be connected to an external Tramit and Receive clock
generators. Add the corresponding clocks description and clock-names to
the generic bindings schema so new DW *MAC-based bindings wouldn't declare
its own names of the same clocks.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 .../devicetree/bindings/net/snps,dwmac.yaml        | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index e1ebe5c8b1da..74820f491346 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -126,6 +126,18 @@ properties:
           MCI, CSR and SMA interfaces run on this clock. If it's omitted,
           the CSR interfaces are considered as synchronous to the system
           clock domain.
+      - description:
+          GMAC Tx clock or so called Transmit clock. The clock is supplied
+          by an external with respect to the DW MAC clock generator.
+          The clock source and its frequency depends on the DW MAC xMII mode.
+          In case if it's supplied by PHY/SerDes this property can be
+          omitted.
+      - description:
+          GMAC Rx clock or so called Receive clock. The clock is supplied
+          by an external with respect to the DW MAC clock generator.
+          The clock source and its frequency depends on the DW MAC xMII mode.
+          In case if it's supplied by PHY/SerDes or it's synchronous to
+          the Tx clock this property can be omitted.
       - description:
           PTP reference clock. This clock is used for programming the
           Timestamp Addend Register. If not passed then the system
@@ -139,6 +151,8 @@ properties:
       enum:
         - stmmaceth
         - pclk
+        - tx
+        - rx
         - ptp_ref
 
   resets:
-- 
2.29.2

