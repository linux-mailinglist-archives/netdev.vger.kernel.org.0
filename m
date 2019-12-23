Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E565129411
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 11:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfLWKOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 05:14:35 -0500
Received: from inva021.nxp.com ([92.121.34.21]:42210 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726890AbfLWKOd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Dec 2019 05:14:33 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id B29DA2007E5;
        Mon, 23 Dec 2019 11:14:31 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id A57E520033C;
        Mon, 23 Dec 2019 11:14:31 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 2CD0D2033F;
        Mon, 23 Dec 2019 11:14:31 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@oss.nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, linux@armlinux.org.uk,
        andrew@lunn.ch
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, shawnguo@kernel.org,
        leoyang.li@nxp.com, devicetree@vger.kernel.org, robh+dt@kernel.org,
        mark.rutland@arm.com, Madalin Bucur <madalin.bucur@nxp.com>
Subject: [PATCH net-next v2 7/7] arm64: dts: ls104xardb: set correct PHY interface mode
Date:   Mon, 23 Dec 2019 12:14:13 +0200
Message-Id: <1577096053-20507-8-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1577096053-20507-1-git-send-email-madalin.bucur@oss.nxp.com>
References: <1577096053-20507-1-git-send-email-madalin.bucur@oss.nxp.com>
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@oss.nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madalin Bucur <madalin.bucur@nxp.com>

The DPAA 1 based LS1043ARDB and LS1046ARDB boards are using
XFI for the 10G interfaces. Since at the moment of the addition
of the first DPAA platforms the only 10G PHY interface type used
was XGMII, although the boards were actually using XFI, they were
wrongly declared as xgmii. This has propagated along the DPAA
family of SoCs, all 10G interfaces being declared wrongly as
XGMII. This patch addresses the problem for the ARM based DPAA
SoCs. After the introduction of XFI PHY interface type we can
address this issue.

Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
---
 arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts | 2 +-
 arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts b/arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts
index 4223a2352d45..8d99dd423720 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts
@@ -139,7 +139,7 @@
 
 	ethernet@f0000 { /* 10GEC1 */
 		phy-handle = <&aqr105_phy>;
-		phy-connection-type = "xgmii";
+		phy-connection-type = "xfi";
 	};
 
 	mdio@fc000 {
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts b/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
index 0c742befb761..e193e2bc2b91 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
@@ -151,12 +151,12 @@
 
 	ethernet@f0000 { /* 10GEC1 */
 		phy-handle = <&aqr106_phy>;
-		phy-connection-type = "xgmii";
+		phy-connection-type = "xfi";
 	};
 
 	ethernet@f2000 { /* 10GEC2 */
 		fixed-link = <0 1 1000 0 0>;
-		phy-connection-type = "xgmii";
+		phy-connection-type = "xfi";
 	};
 
 	mdio@fc000 {
-- 
2.1.0

