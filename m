Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7B5E186A91
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 13:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730968AbgCPMGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 08:06:07 -0400
Received: from inva021.nxp.com ([92.121.34.21]:54766 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730924AbgCPMGE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 08:06:04 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id A9C912009DF;
        Mon, 16 Mar 2020 13:06:02 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 9DCA02009CD;
        Mon, 16 Mar 2020 13:06:02 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 40EC62039B;
        Mon, 16 Mar 2020 13:06:02 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@oss.nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     devicetree@vger.kernel.org, shawnguo@kernel.org,
        leoyang.li@nxp.com, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-kernel@vger.kernel.org,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Subject: [PATCH net v2 1/3] net: fsl/fman: treat all RGMII modes in memac_adjust_link()
Date:   Mon, 16 Mar 2020 14:05:56 +0200
Message-Id: <1584360358-8092-2-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1584360358-8092-1-git-send-email-madalin.bucur@oss.nxp.com>
References: <1584360358-8092-1-git-send-email-madalin.bucur@oss.nxp.com>
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

v2: used phy_interface_mode_is_rgmii() to identify RGMII

 drivers/net/ethernet/freescale/fman/fman_memac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index e1901874c19f..0d2b4ab01f24 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -782,7 +782,7 @@ int memac_adjust_link(struct fman_mac *memac, u16 speed)
 	/* Set full duplex */
 	tmp &= ~IF_MODE_HD;
 
-	if (memac->phy_if == PHY_INTERFACE_MODE_RGMII) {
+	if (phy_interface_mode_is_rgmii(memac->phy_if)) {
 		/* Configure RGMII in manual mode */
 		tmp &= ~IF_MODE_RGMII_AUTO;
 		tmp &= ~IF_MODE_RGMII_SP_MASK;
-- 
2.1.0

