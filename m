Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30B4529AC6
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 17:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389891AbfEXPPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 11:15:21 -0400
Received: from inva020.nxp.com ([92.121.34.13]:57796 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389680AbfEXPPU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 11:15:20 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 2D8D61A04AF;
        Fri, 24 May 2019 17:15:19 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 219091A04A9;
        Fri, 24 May 2019 17:15:19 +0200 (CEST)
Received: from fsr-ub1664-019.ea.freescale.net (fsr-ub1664-019.ea.freescale.net [10.171.71.230])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id B9829205EF;
        Fri, 24 May 2019 17:15:18 +0200 (CEST)
From:   Ioana Radulescu <ruxandra.radulescu@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     ioana.ciornei@nxp.com
Subject: [PATCH net 2/3] dpaa2-eth: Use PTR_ERR_OR_ZERO where appropriate
Date:   Fri, 24 May 2019 18:15:16 +0300
Message-Id: <1558710917-4555-3-git-send-email-ruxandra.radulescu@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558710917-4555-1-git-send-email-ruxandra.radulescu@nxp.com>
References: <1558710917-4555-1-git-send-email-ruxandra.radulescu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use PTR_ERR_OR_ZERO instead of PTR_ERR in cases where
zero is a valid input. Reported by smatch.

Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 28a6faa..753957e 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1972,7 +1972,7 @@ alloc_channel(struct dpaa2_eth_priv *priv)
 
 	channel->dpcon = setup_dpcon(priv);
 	if (IS_ERR_OR_NULL(channel->dpcon)) {
-		err = PTR_ERR(channel->dpcon);
+		err = PTR_ERR_OR_ZERO(channel->dpcon);
 		goto err_setup;
 	}
 
@@ -2028,7 +2028,7 @@ static int setup_dpio(struct dpaa2_eth_priv *priv)
 		/* Try to allocate a channel */
 		channel = alloc_channel(priv);
 		if (IS_ERR_OR_NULL(channel)) {
-			err = PTR_ERR(channel);
+			err = PTR_ERR_OR_ZERO(channel);
 			if (err != -EPROBE_DEFER)
 				dev_info(dev,
 					 "No affine channel for cpu %d and above\n", i);
-- 
2.7.4

