Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD4AABA7D
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 16:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394104AbfIFOPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 10:15:50 -0400
Received: from inva020.nxp.com ([92.121.34.13]:48564 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394081AbfIFOPs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Sep 2019 10:15:48 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 783FD1A0C07;
        Fri,  6 Sep 2019 16:15:46 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 6C7F01A0C05;
        Fri,  6 Sep 2019 16:15:46 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 34B412061D;
        Fri,  6 Sep 2019 16:15:46 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     alexandru.marginean@nxp.com, netdev@vger.kernel.org
Subject: [PATCH net-next 4/5] enetc: Drop redundant device node check
Date:   Fri,  6 Sep 2019 17:15:43 +0300
Message-Id: <1567779344-30965-5-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1567779344-30965-1-git-send-email-claudiu.manoil@nxp.com>
References: <1567779344-30965-1-git-send-email-claudiu.manoil@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The existence of the DT port node is the first thing checked
at probe time, and probing won't continue if the node is missing.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 9e9bb6b97c41..ebf2996ebe69 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -754,11 +754,6 @@ static int enetc_of_get_phy(struct enetc_ndev_priv *priv)
 	int phy_mode;
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

