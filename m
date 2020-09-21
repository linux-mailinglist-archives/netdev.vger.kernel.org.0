Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8D40272C3C
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 18:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbgIUQ27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 12:28:59 -0400
Received: from inva021.nxp.com ([92.121.34.21]:36646 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727237AbgIUQ26 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 12:28:58 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 248FB200A47;
        Mon, 21 Sep 2020 18:20:42 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 189A22009DF;
        Mon, 21 Sep 2020 18:20:42 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id C3567202B6;
        Mon, 21 Sep 2020 18:20:41 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, linux@armlinux.org.uk,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 1/3] net: pcs-lynx: add support for 10GBASER
Date:   Mon, 21 Sep 2020 19:20:29 +0300
Message-Id: <20200921162031.12921-2-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200921162031.12921-1-ioana.ciornei@nxp.com>
References: <20200921162031.12921-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support in the Lynx PCS module for the 10GBASE-R mode which is only
used to get the link state, since it offers a single fixed speed.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/pcs/pcs-lynx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/pcs/pcs-lynx.c b/drivers/net/pcs/pcs-lynx.c
index c43d97682083..62bb9272dcb2 100644
--- a/drivers/net/pcs/pcs-lynx.c
+++ b/drivers/net/pcs/pcs-lynx.c
@@ -93,6 +93,9 @@ static void lynx_pcs_get_state(struct phylink_pcs *pcs,
 	case PHY_INTERFACE_MODE_USXGMII:
 		lynx_pcs_get_state_usxgmii(lynx->mdio, state);
 		break;
+	case PHY_INTERFACE_MODE_10GBASER:
+		phylink_mii_c45_pcs_get_state(lynx->mdio, state);
+		break;
 	default:
 		break;
 	}
@@ -172,6 +175,9 @@ static int lynx_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 		break;
 	case PHY_INTERFACE_MODE_USXGMII:
 		return lynx_pcs_config_usxgmii(lynx->mdio, mode, advertising);
+	case PHY_INTERFACE_MODE_10GBASER:
+		/* Nothing to do here for 10GBASER */
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.25.1

