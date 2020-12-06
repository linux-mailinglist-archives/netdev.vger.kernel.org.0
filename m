Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93B572D059C
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 16:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgLFPPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 10:15:32 -0500
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:27349 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726043AbgLFPPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Dec 2020 10:15:32 -0500
Received: from localhost.localdomain ([93.22.38.146])
        by mwinf5d72 with ME
        id 13Df2400H39BigV033Dgka; Sun, 06 Dec 2020 16:13:47 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 06 Dec 2020 16:13:47 +0100
X-ME-IP: 93.22.38.146
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     ioana.ciornei@nxp.com, ruxandra.radulescu@nxp.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] dpaa2-mac: Add a missing of_node_put after of_device_is_available
Date:   Sun,  6 Dec 2020 16:13:39 +0100
Message-Id: <20201206151339.44306-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an 'of_node_put()' call when a tested device node is not available.

Fixes:94ae899b2096 ("dpaa2-mac: add PCS support through the Lynx module")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 90cd243070d7..828c177df03d 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -269,6 +269,7 @@ static int dpaa2_pcs_create(struct dpaa2_mac *mac,
 
 	if (!of_device_is_available(node)) {
 		netdev_err(mac->net_dev, "pcs-handle node not available\n");
+		of_node_put(node);
 		return -ENODEV;
 	}
 
-- 
2.27.0

