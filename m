Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97074278B22
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 16:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729114AbgIYOom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 10:44:42 -0400
Received: from inva021.nxp.com ([92.121.34.21]:46768 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728731AbgIYOok (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 10:44:40 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 994202005EE;
        Fri, 25 Sep 2020 16:44:38 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 8D731200604;
        Fri, 25 Sep 2020 16:44:38 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 588E32030E;
        Fri, 25 Sep 2020 16:44:38 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 1/3] dpaa2-mac: do not check for both child and parent DTS nodes
Date:   Fri, 25 Sep 2020 17:44:19 +0300
Message-Id: <20200925144421.7811-2-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200925144421.7811-1-ioana.ciornei@nxp.com>
References: <20200925144421.7811-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no need to check if both the MDIO controller node and its
child node, the PCS device, are available since there is no chance that
the child node would be enabled when the parent it's not.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 6ff64dd1cf27..cdd1acd0117e 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -267,8 +267,7 @@ static int dpaa2_pcs_create(struct dpaa2_mac *mac,
 		return 0;
 	}
 
-	if (!of_device_is_available(node) ||
-	    !of_device_is_available(node->parent)) {
+	if (!of_device_is_available(node)) {
 		netdev_err(mac->net_dev, "pcs-handle node not available\n");
 		return -ENODEV;
 	}
-- 
2.25.1

