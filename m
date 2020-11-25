Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2442C45FC
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 17:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732536AbgKYQxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 11:53:51 -0500
Received: from inva021.nxp.com ([92.121.34.21]:33228 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732524AbgKYQxu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 11:53:50 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id BD7A5200A53;
        Wed, 25 Nov 2020 17:53:48 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id B002E2009E6;
        Wed, 25 Nov 2020 17:53:48 +0100 (CET)
Received: from fsr-ub1464-019.ea.freescale.net (fsr-ub1464-019.ea.freescale.net [10.171.81.207])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 5497B2030D;
        Wed, 25 Nov 2020 17:53:48 +0100 (CET)
From:   Camelia Groza <camelia.groza@nxp.com>
To:     kuba@kernel.org, maciej.fijalkowski@intel.com, brouer@redhat.com,
        saeed@kernel.org, davem@davemloft.net
Cc:     madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        netdev@vger.kernel.org, Camelia Groza <camelia.groza@nxp.com>
Subject: [PATCH net-next v5 6/7] dpaa_eth: rename current skb A050385 erratum workaround
Date:   Wed, 25 Nov 2020 18:53:35 +0200
Message-Id: <f591f463b9f098dc17607662caa12d7b7b1f87bb.1606322126.git.camelia.groza@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1606322126.git.camelia.groza@nxp.com>
References: <cover.1606322126.git.camelia.groza@nxp.com>
In-Reply-To: <cover.1606322126.git.camelia.groza@nxp.com>
References: <cover.1606322126.git.camelia.groza@nxp.com>
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
index dd08c46..c63f5fe 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2105,7 +2105,7 @@ static inline int dpaa_xmit(struct dpaa_priv *priv,
 }
 
 #ifdef CONFIG_DPAA_ERRATUM_A050385
-static int dpaa_a050385_wa(struct net_device *net_dev, struct sk_buff **s)
+static int dpaa_a050385_wa_skb(struct net_device *net_dev, struct sk_buff **s)
 {
 	struct dpaa_priv *priv = netdev_priv(net_dev);
 	struct sk_buff *new_skb, *skb = *s;
@@ -2221,7 +2221,7 @@ static int dpaa_a050385_wa(struct net_device *net_dev, struct sk_buff **s)
 
 #ifdef CONFIG_DPAA_ERRATUM_A050385
 	if (unlikely(fman_has_errata_a050385())) {
-		if (dpaa_a050385_wa(net_dev, &skb))
+		if (dpaa_a050385_wa_skb(net_dev, &skb))
 			goto enomem;
 		nonlinear = skb_is_nonlinear(skb);
 	}
-- 
1.9.1

