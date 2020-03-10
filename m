Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF4BB17F8D4
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 13:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728900AbgCJMv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 08:51:28 -0400
Received: from inva020.nxp.com ([92.121.34.13]:54842 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728903AbgCJMv1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 08:51:27 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id A9F5B1A0546;
        Tue, 10 Mar 2020 13:51:25 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 9E46F1A0568;
        Tue, 10 Mar 2020 13:51:25 +0100 (CET)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 5F8132036B;
        Tue, 10 Mar 2020 13:51:25 +0100 (CET)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "Y . b . Lu" <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH net-next 1/4] enetc: Drop redundant device node check
Date:   Tue, 10 Mar 2020 14:51:21 +0200
Message-Id: <1583844684-28202-2-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1583844684-28202-1-git-send-email-claudiu.manoil@nxp.com>
References: <1583844684-28202-1-git-send-email-claudiu.manoil@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The existence of the DT port node is the first thing checked
at probe time, and probing won't reach this point if the node
is missing.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 545a344bce00..4e4a49179f0b 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -797,11 +797,6 @@ static int enetc_of_get_phy(struct enetc_ndev_priv *priv)
 	struct device_node *mdio_np;
 	int err;
 
-	if (!np) {
-		dev_err(priv->dev, "missing ENETC port node\n");
-		return -ENODEV;
-	}
-
 	priv->phy_node = of_parse_phandle(np, "phy-handle", 0);
 	if (!priv->phy_node) {
 		if (!of_phy_is_fixed_link(np)) {
-- 
2.17.1

