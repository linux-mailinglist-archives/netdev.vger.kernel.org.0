Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D36023AB02D
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 11:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbhFQJva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 05:51:30 -0400
Received: from first.geanix.com ([116.203.34.67]:41912 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231847AbhFQJv1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 05:51:27 -0400
Received: from localhost (unknown [185.17.218.86])
        by first.geanix.com (Postfix) with ESMTPSA id 648C64C3292;
        Thu, 17 Jun 2021 09:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1623923358; bh=aDM42wVtbFCJQul8ZRo2dGnWDMYAECSz7+N9SXJwEfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=lPIb+TbAyDUb9X+kTt6qJiqah6OFv1RQPCh2F5hIfntOwc47MbXRhhCAUoT5vVdyB
         tiW2uMcB8lK544FeQpw1P+gLlQhlYMDoOO7sVCWwdaBL2zUqAnbdhFxoyhQHTrwwEp
         pZLEiVDhYmPQMtOqbyI1XU1wDHEJ7f+RY0/KFic5OK4BvNjhfjKMXg4NfCKGPvXYLx
         UfYcca/AfLRc/pm9cHjgn2c2rK+Byo5/G4bEI9hiEdgXtXCkVqWQnA7XqS/4eWTICn
         dByDs3dH8bUWo6ocK8MrF2Imj92TIYy+6vOzxaOnNEqbZLVAUFqCnxc9ujjbCiOORQ
         yj5hG63N7j73A==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 2/6] net: gianfar: Extend statistics counters to 64-bit
Date:   Thu, 17 Jun 2021 11:49:17 +0200
Message-Id: <c4536afc2cef56eec435103dcb303021f1e6f557.1623922686.git.esben@geanix.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1623922686.git.esben@geanix.com>
References: <cover.1623922686.git.esben@geanix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on 93bd6fdb21b5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No reason to wrap counter values at 2^32.  Especially the bytes counters
can wrap pretty fast on Gbit networks.

Signed-off-by: Esben Haabendal <esben@geanix.com>
---
 drivers/net/ethernet/freescale/gianfar.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/gianfar.h b/drivers/net/ethernet/freescale/gianfar.h
index 5ea47df93e5e..d8ae5353e881 100644
--- a/drivers/net/ethernet/freescale/gianfar.h
+++ b/drivers/net/ethernet/freescale/gianfar.h
@@ -913,8 +913,8 @@ enum {
  * Per TX queue stats
  */
 struct tx_q_stats {
-	unsigned long tx_packets;
-	unsigned long tx_bytes;
+	u64 tx_packets;
+	u64 tx_bytes;
 };
 
 /**
@@ -963,9 +963,9 @@ struct gfar_priv_tx_q {
  * Per RX queue stats
  */
 struct rx_q_stats {
-	unsigned long rx_packets;
-	unsigned long rx_bytes;
-	unsigned long rx_dropped;
+	u64 rx_packets;
+	u64 rx_bytes;
+	u64 rx_dropped;
 };
 
 struct gfar_rx_buff {
-- 
2.32.0

