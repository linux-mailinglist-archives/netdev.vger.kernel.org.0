Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C51D025807D
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 20:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729528AbgHaSMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 14:12:54 -0400
Received: from inva020.nxp.com ([92.121.34.13]:41102 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729217AbgHaSMu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 14:12:50 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id B988A1A0A8C;
        Mon, 31 Aug 2020 20:12:48 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id AC3781A0A8A;
        Mon, 31 Aug 2020 20:12:48 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 7F1AE20328;
        Mon, 31 Aug 2020 20:12:48 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 3/3] dpaa2-eth: add a dpaa2_eth_ prefix to all functions in dpaa2-eth-dcb.c
Date:   Mon, 31 Aug 2020 21:12:40 +0300
Message-Id: <20200831181240.21527-4-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200831181240.21527-1-ioana.ciornei@nxp.com>
References: <20200831181240.21527-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some static functions in the dpaa2-eth driver don't have the dpaa2_eth_
prefix and this is becoming an inconvenience when looking at, for
example, a perf top output and trying to determine easily which entries
are dpaa2-eth related. Ammend this by adding the prefix to all the
functions.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-dcb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-dcb.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-dcb.c
index 83dee575c2fa..84de0644168d 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-dcb.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-dcb.c
@@ -17,12 +17,12 @@ static int dpaa2_eth_dcbnl_ieee_getpfc(struct net_device *net_dev,
 	return 0;
 }
 
-static inline bool is_prio_enabled(u8 pfc_en, u8 tc)
+static inline bool dpaa2_eth_is_prio_enabled(u8 pfc_en, u8 tc)
 {
 	return !!(pfc_en & (1 << tc));
 }
 
-static int set_pfc_cn(struct dpaa2_eth_priv *priv, u8 pfc_en)
+static int dpaa2_eth_set_pfc_cn(struct dpaa2_eth_priv *priv, u8 pfc_en)
 {
 	struct dpni_congestion_notification_cfg cfg = {0};
 	int i, err;
@@ -33,7 +33,7 @@ static int set_pfc_cn(struct dpaa2_eth_priv *priv, u8 pfc_en)
 	cfg.message_ctx = 0ULL;
 
 	for (i = 0; i < dpaa2_eth_tc_count(priv); i++) {
-		if (is_prio_enabled(pfc_en, i)) {
+		if (dpaa2_eth_is_prio_enabled(pfc_en, i)) {
 			cfg.threshold_entry = DPAA2_ETH_CN_THRESH_ENTRY(priv);
 			cfg.threshold_exit = DPAA2_ETH_CN_THRESH_EXIT(priv);
 		} else {
@@ -93,7 +93,7 @@ static int dpaa2_eth_dcbnl_ieee_setpfc(struct net_device *net_dev,
 	}
 
 	/* Configure congestion notifications for the enabled priorities */
-	err = set_pfc_cn(priv, pfc->pfc_en);
+	err = dpaa2_eth_set_pfc_cn(priv, pfc->pfc_en);
 	if (err)
 		return err;
 
-- 
2.25.1

