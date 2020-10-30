Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7442A0CC4
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 18:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbgJ3Rrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 13:47:32 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:18243 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727099AbgJ3Rrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 13:47:31 -0400
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 09UHl9pQ020669;
        Fri, 30 Oct 2020 10:47:27 -0700
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Rohit Maheshwari <rohitm@chelsio.com>
Subject: [net v3 04/10] ch_ktls: incorrect use of GFP_KERNEL
Date:   Fri, 30 Oct 2020 23:17:02 +0530
Message-Id: <20201030174708.9578-5-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201030174708.9578-1-rohitm@chelsio.com>
References: <20201030174708.9578-1-rohitm@chelsio.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use of GFP_KERNEL under lock is not correct. Replacing it
with GFP_ATOMIC.

Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index a1448a1b38fd..379d4d1220b1 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -1675,7 +1675,7 @@ static int chcr_end_part_handler(struct chcr_ktls_info *tx_info,
 	} else {
 		dev_kfree_skb_any(skb);
 
-		nskb = alloc_skb(0, GFP_KERNEL);
+		nskb = alloc_skb(0, GFP_ATOMIC);
 		if (!nskb)
 			return NETDEV_TX_BUSY;
 		/* copy complete record in skb */
-- 
2.18.1

