Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1842C121B
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 18:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390387AbgKWRgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 12:36:45 -0500
Received: from inva020.nxp.com ([92.121.34.13]:59488 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730867AbgKWRgo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 12:36:44 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 1B33E1A143D;
        Mon, 23 Nov 2020 18:36:43 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 0ED991A1435;
        Mon, 23 Nov 2020 18:36:43 +0100 (CET)
Received: from fsr-ub1464-019.ea.freescale.net (fsr-ub1464-019.ea.freescale.net [10.171.81.207])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id A3EF82032A;
        Mon, 23 Nov 2020 18:36:42 +0100 (CET)
From:   Camelia Groza <camelia.groza@nxp.com>
To:     kuba@kernel.org, maciej.fijalkowski@intel.com, brouer@redhat.com,
        saeed@kernel.org, davem@davemloft.net
Cc:     madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        netdev@vger.kernel.org, Camelia Groza <camelia.groza@nxp.com>
Subject: [PATCH net-next v4 6/7] dpaa_eth: rename current skb A050385 erratum workaround
Date:   Mon, 23 Nov 2020 19:36:24 +0200
Message-Id: <a022cfd51f6f8010826e07f1b0b0418e1b474cdf.1606150838.git.camelia.groza@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1606150838.git.camelia.groza@nxp.com>
References: <cover.1606150838.git.camelia.groza@nxp.com>
In-Reply-To: <cover.1606150838.git.camelia.groza@nxp.com>
References: <cover.1606150838.git.camelia.groza@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Explicitly point that the current workaround addresses skbs. This change is
in preparation for adding a workaround for XDP scenarios.

Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index a96c994..149b549 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2104,7 +2104,7 @@ static inline int dpaa_xmit(struct dpaa_priv *priv,
 }
 
 #ifdef CONFIG_DPAA_ERRATUM_A050385
-static int dpaa_a050385_wa(struct net_device *net_dev, struct sk_buff **s)
+static int dpaa_a050385_wa_skb(struct net_device *net_dev, struct sk_buff **s)
 {
 	struct dpaa_priv *priv = netdev_priv(net_dev);
 	struct sk_buff *new_skb, *skb = *s;
@@ -2220,7 +2220,7 @@ static int dpaa_a050385_wa(struct net_device *net_dev, struct sk_buff **s)
 
 #ifdef CONFIG_DPAA_ERRATUM_A050385
 	if (unlikely(fman_has_errata_a050385())) {
-		if (dpaa_a050385_wa(net_dev, &skb))
+		if (dpaa_a050385_wa_skb(net_dev, &skb))
 			goto enomem;
 		nonlinear = skb_is_nonlinear(skb);
 	}
-- 
1.9.1

