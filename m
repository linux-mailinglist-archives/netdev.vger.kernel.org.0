Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99493105A3D
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 20:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbfKUTPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 14:15:54 -0500
Received: from inva020.nxp.com ([92.121.34.13]:43656 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726881AbfKUTPx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 14:15:53 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 6F89B1A0654;
        Thu, 21 Nov 2019 20:15:52 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 63B3E1A0354;
        Thu, 21 Nov 2019 20:15:52 +0100 (CET)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 1DBA3203CE;
        Thu, 21 Nov 2019 20:15:52 +0100 (CET)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     linux@armlinux.org.uk, andrew@lunn.ch,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 3/3] dpaa2-eth: return all supported link modes in PHY_INTERFACE_MODE_NA
Date:   Thu, 21 Nov 2019 21:15:27 +0200
Message-Id: <1574363727-5437-4-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1574363727-5437-1-git-send-email-ioana.ciornei@nxp.com>
References: <1574363727-5437-1-git-send-email-ioana.ciornei@nxp.com>
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The include/linux/phylink.h states:
 * When @state->interface is %PHY_INTERFACE_MODE_NA, phylink expects
 * MAC driver to return all supported link modes.

Make the necessary adjustment to meet the requirements.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index efc587515661..d93d71724e5a 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -95,6 +95,7 @@ static void dpaa2_mac_validate(struct phylink_config *config,
 	phylink_set(mask, Asym_Pause);
 
 	switch (state->interface) {
+	case PHY_INTERFACE_MODE_NA:
 	case PHY_INTERFACE_MODE_RGMII:
 	case PHY_INTERFACE_MODE_RGMII_ID:
 	case PHY_INTERFACE_MODE_RGMII_RXID:
-- 
1.9.1

