Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 986A8CE0A9
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 13:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbfJGLin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 07:38:43 -0400
Received: from inva021.nxp.com ([92.121.34.21]:44760 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727691AbfJGLim (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 07:38:42 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 05029200686;
        Mon,  7 Oct 2019 13:38:41 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id ED3A72007DD;
        Mon,  7 Oct 2019 13:38:40 +0200 (CEST)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id A28652060A;
        Mon,  7 Oct 2019 13:38:40 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 2/3] dpaa2-eth: Fix minor bug in ethtool stats reporting
Date:   Mon,  7 Oct 2019 14:38:27 +0300
Message-Id: <1570448308-16248-3-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1570448308-16248-1-git-send-email-ioana.ciornei@nxp.com>
References: <1570448308-16248-1-git-send-email-ioana.ciornei@nxp.com>
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Radulescu <ruxandra.radulescu@nxp.com>

Don't print error message for a successful return value.

Fixes: d84c3a4ded96 ("dpaa2-eth: Add new DPNI statistics counters")

Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - none

 drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index 0aa1c34019bb..dc9a6c36cac0 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -216,7 +216,7 @@ static void dpaa2_eth_get_ethtool_stats(struct net_device *net_dev,
 		if (err == -EINVAL)
 			/* Older firmware versions don't support all pages */
 			memset(&dpni_stats, 0, sizeof(dpni_stats));
-		else
+		else if (err)
 			netdev_warn(net_dev, "dpni_get_stats(%d) failed\n", j);
 
 		num_cnt = dpni_stats_page_size[j] / sizeof(u64);
-- 
1.9.1

