Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C16C318A1
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 02:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfFAAIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 20:08:31 -0400
Received: from mailgw02.mediatek.com ([216.200.240.185]:33667 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbfFAAI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 20:08:29 -0400
X-UUID: 5af83b4fed8f44c7b71ee22a7101d49e-20190531
X-UUID: 5af83b4fed8f44c7b71ee22a7101d49e-20190531
Received: from mtkcas67.mediatek.inc [(172.29.193.45)] by mailgw02.mediatek.com
        (envelope-from <sean.wang@mediatek.com>)
        (musrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 734761380; Fri, 31 May 2019 16:03:24 -0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 MTKMBS62N1.mediatek.inc (172.29.193.41) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 31 May 2019 17:03:23 -0700
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Sat, 1 Jun 2019 08:03:21 +0800
From:   <sean.wang@mediatek.com>
To:     <john@phrozen.org>, <davem@davemloft.net>
CC:     <nbd@openwrt.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH net-next v1 2/6] dt-bindings: net: mediatek: Add support for MediaTek MT7629 SoC
Date:   Sat, 1 Jun 2019 08:03:11 +0800
Message-ID: <1559347395-14058-3-git-send-email-sean.wang@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1559347395-14058-1-git-send-email-sean.wang@mediatek.com>
References: <1559347395-14058-1-git-send-email-sean.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

Add binding document for the ethernet on MT7629 SoC.

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
---
 .../devicetree/bindings/net/mediatek-net.txt       | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/mediatek-net.txt b/Documentation/devicetree/bindings/net/mediatek-net.txt
index 503f2b9194e2..770ff98d4524 100644
--- a/Documentation/devicetree/bindings/net/mediatek-net.txt
+++ b/Documentation/devicetree/bindings/net/mediatek-net.txt
@@ -11,6 +11,7 @@ Required properties:
 		"mediatek,mt2701-eth": for MT2701 SoC
 		"mediatek,mt7623-eth", "mediatek,mt2701-eth": for MT7623 SoC
 		"mediatek,mt7622-eth": for MT7622 SoC
+		"mediatek,mt7629-eth": for MT7629 SoC
 - reg: Address and length of the register set for the device
 - interrupts: Should contain the three frame engines interrupts in numeric
 	order. These are fe_int0, fe_int1 and fe_int2.
@@ -19,14 +20,23 @@ Required properties:
 	"ethif", "esw", "gp2", "gp1" : For MT2701 and MT7623 SoC
         "ethif", "esw", "gp0", "gp1", "gp2", "sgmii_tx250m", "sgmii_rx250m",
 	"sgmii_cdr_ref", "sgmii_cdr_fb", "sgmii_ck", "eth2pll" : For MT7622 SoC
+	"ethif", "sgmiitop", "esw", "gp0", "gp1", "gp2", "fe", "sgmii_tx250m",
+	"sgmii_rx250m", "sgmii_cdr_ref", "sgmii_cdr_fb", "sgmii2_tx250m",
+	"sgmii2_rx250m", "sgmii2_cdr_ref", "sgmii2_cdr_fb", "sgmii_ck",
+	"eth2pll" : For MT7629 SoC.
 - power-domains: phandle to the power domain that the ethernet is part of
 - resets: Should contain phandles to the ethsys reset signals
 - reset-names: Should contain the names of reset signal listed in the resets
 		property
 		These are "fe", "gmac" and "ppe"
 - mediatek,ethsys: phandle to the syscon node that handles the port setup
-- mediatek,sgmiisys: phandle to the syscon node that handles the SGMII setup
-	which is required for those SoCs equipped with SGMII such as MT7622 SoC.
+- mediatek,infracfg: phandle to the syscon node that handles the path from
+	GMAC to PHY variants, which is required for MT7629 SoC.
+- mediatek,sgmiisys: a list of phandles to the syscon node that handles the
+	SGMII setup which is required for those SoCs equipped with SGMII such
+	as MT7622 and MT7629 SoC. And MT7622 have only one set of SGMII shared
+	by GMAC1 and GMAC2; MT7629 have two independent sets of SGMII directed
+	to GMAC1 and GMAC2, respectively.
 - mediatek,pctl: phandle to the syscon node that handles the ports slew rate
 	and driver current: only for MT2701 and MT7623 SoC
 
-- 
2.17.1

