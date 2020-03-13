Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7435018466A
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 13:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgCMMEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 08:04:34 -0400
Received: from inva020.nxp.com ([92.121.34.13]:51990 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726216AbgCMMEe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 08:04:34 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id D720F1A1428;
        Fri, 13 Mar 2020 13:04:32 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id CB5FE1A1419;
        Fri, 13 Mar 2020 13:04:32 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 6431A203CE;
        Fri, 13 Mar 2020 13:04:32 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@oss.nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     devicetree@vger.kernel.org, shawnguo@kernel.org,
        leoyang.li@nxp.com, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-kernel@vger.kernel.org,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Subject: [PATCH net 1/3] net: fsl/fman: treat all RGMII modes in memac_adjust_link()
Date:   Fri, 13 Mar 2020 14:04:23 +0200
Message-Id: <1584101065-3482-2-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1584101065-3482-1-git-send-email-madalin.bucur@oss.nxp.com>
References: <1584101065-3482-1-git-send-email-madalin.bucur@oss.nxp.com>
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@oss.nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Treat all internal delay variants the same as RGMII.

Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
---
 drivers/net/ethernet/freescale/fman/fman_memac.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index e1901874c19f..0fc98584974a 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -782,7 +782,10 @@ int memac_adjust_link(struct fman_mac *memac, u16 speed)
 	/* Set full duplex */
 	tmp &= ~IF_MODE_HD;
 
-	if (memac->phy_if == PHY_INTERFACE_MODE_RGMII) {
+	if (memac->phy_if == PHY_INTERFACE_MODE_RGMII ||
+	    memac->phy_if == PHY_INTERFACE_MODE_RGMII_ID ||
+	    memac->phy_if == PHY_INTERFACE_MODE_RGMII_RXID ||
+	    memac->phy_if == PHY_INTERFACE_MODE_RGMII_TXID) {
 		/* Configure RGMII in manual mode */
 		tmp &= ~IF_MODE_RGMII_AUTO;
 		tmp &= ~IF_MODE_RGMII_SP_MASK;
-- 
2.1.0

