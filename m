Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDABD46B043
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 02:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240215AbhLGB7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 20:59:13 -0500
Received: from mailgw01.mediatek.com ([60.244.123.138]:47538 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S238979AbhLGB6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 20:58:54 -0500
X-UUID: 5e7e27bd378c4351b497202667073be9-20211207
X-UUID: 5e7e27bd378c4351b497202667073be9-20211207
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 347944715; Tue, 07 Dec 2021 09:55:20 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Tue, 7 Dec 2021 09:55:18 +0800
Received: from mhfsdcap04.gcn.mediatek.inc (10.17.3.154) by
 mtkcas10.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Tue, 7 Dec 2021 09:55:17 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
CC:     Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <srv_heupstream@mediatek.com>, <macpaul.lin@mediatek.com>,
        <angelogioacchino.delregno@collabora.com>, <dkirjanov@suse.de>
Subject: [PATCH v5 0/7] MediaTek Ethernet Patches on MT8195
Date:   Tue, 7 Dec 2021 09:54:58 +0800
Message-ID: <20211207015505.16746-1-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes in v5:
1. remove useless inclusion in dwmac-mediatek.c as Angelo's comments.
2. add acked-by in "net-next: stmmac: dwmac-mediatek: add support for
   mt8195" patch

Changes in v4:
1. add changes in commit message in "net-next: dt-bindings: dwmac:
   Convert mediatek-dwmac to DT schema" patch.
2. remove ethernet-controller.yaml since snps,dwmac.yaml already include it.

Changes in v3:
1. Add prefix "net-next" to support new IC as Denis's suggestion.
2. Split dt-bindings to two patches, one for conversion, and the other for
   new IC.
3. add a new patch to update device node in mt2712-evb.dts to accommodate to
   changes in driver.
4. remove unnecessary wrapper as Angelo's suggestion.
5. Add acked-by in "net-next: stmmac: dwmac-mediatek: Reuse more common
   features" patch.

Changes in v2:
1. fix errors/warnings in mediatek-dwmac.yaml with upgraded dtschema tools

This series include 5 patches:
1. add platform level clocks management for dwmac-mediatek
2. resue more common features defined in stmmac_platform.c
3. add ethernet entry for mt8195
4. convert mediatek-dwmac.txt to mediatek-dwmac.yaml

Biao Huang (7):
  net-next: stmmac: dwmac-mediatek: add platform level clocks management
  net-next: stmmac: dwmac-mediatek: Reuse more common features
  arm64: dts: mt2712: update ethernet device node
  net-next: dt-bindings: dwmac: Convert mediatek-dwmac to DT schema
  net-next: stmmac: dwmac-mediatek: add support for mt8195
  arm64: dts: mt8195: add ethernet device node
  net-next: dt-bindings: dwmac: add support for mt8195

 .../bindings/net/mediatek-dwmac.txt           |  91 ------
 .../bindings/net/mediatek-dwmac.yaml          | 210 ++++++++++++
 arch/arm64/boot/dts/mediatek/mt2712-evb.dts   |   1 +
 arch/arm64/boot/dts/mediatek/mt2712e.dtsi     |  14 +-
 arch/arm64/boot/dts/mediatek/mt8195-evb.dts   |  92 ++++++
 arch/arm64/boot/dts/mediatek/mt8195.dtsi      |  70 ++++
 .../ethernet/stmicro/stmmac/dwmac-mediatek.c  | 306 ++++++++++++++++--
 7 files changed, 665 insertions(+), 119 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/mediatek-dwmac.txt
 create mode 100644 Documentation/devicetree/bindings/net/mediatek-dwmac.yaml


