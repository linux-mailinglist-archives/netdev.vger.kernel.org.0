Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9896E1420CF
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 00:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729442AbgASXRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 18:17:37 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:49802 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728978AbgASXQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 18:16:32 -0500
Received: by kvm5.telegraphics.com.au (Postfix, from userid 502)
        id F00322996D; Sun, 19 Jan 2020 18:16:30 -0500 (EST)
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Chris Zankel <chris@zankel.net>,
        Laurent Vivier <laurent@vivier.eu>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <a2d5df4cb05eefb0d55e815c1e01d3930b50da77.1579474569.git.fthain@telegraphics.com.au>
In-Reply-To: <cover.1579474569.git.fthain@telegraphics.com.au>
References: <cover.1579474569.git.fthain@telegraphics.com.au>
From:   Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH net 05/19] net/sonic: Remove redundant netif_start_queue()
 call
Date:   Mon, 20 Jan 2020 09:56:09 +1100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tx queue must be running already, otherwise sonic_send_packet()
would not have been called.

Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/net/ethernet/natsemi/sonic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/natsemi/sonic.c b/drivers/net/ethernet/natsemi/sonic.c
index dbbbc8bc72ff..84a30928d4e2 100644
--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -303,7 +303,7 @@ static int sonic_send_packet(struct sk_buff *skb, struct net_device *dev)
 		netif_dbg(lp, tx_queued, dev, "%s: stopping queue\n", __func__);
 		netif_stop_queue(dev);
 		/* after this packet, wait for ISR to free up some TDAs */
-	} else netif_start_queue(dev);
+	}
 
 	netif_dbg(lp, tx_queued, dev, "%s: issuing Tx command\n", __func__);
 
-- 
2.24.1

