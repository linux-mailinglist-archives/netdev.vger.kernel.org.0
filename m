Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 571A22D55D4
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 09:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388489AbgLJIz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 03:55:29 -0500
Received: from s2.neomailbox.net ([5.148.176.60]:37461 "EHLO s2.neomailbox.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388284AbgLJIz2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 03:55:28 -0500
From:   Antonio Quartulli <a@unstable.cc>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Antonio Quartulli <a@unstable.cc>
Subject: [PATCH] can: avoid double unlikely() notation when using IS_ERR()
Date:   Thu, 10 Dec 2020 09:53:21 +0100
Message-Id: <20201210085321.18693-1-a@unstable.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The definition of IS_ERR() already applies the unlikely() notation
when checking the error status of the passed pointer. For this
reason there is no need to have the same notation outside of
IS_ERR() itself.

Clean up code by removing redundant notation.

Signed-off-by: Antonio Quartulli <a@unstable.cc>
---
 drivers/net/can/rx-offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/rx-offload.c b/drivers/net/can/rx-offload.c
index 450c5cfcb3fc..3c1912c0430b 100644
--- a/drivers/net/can/rx-offload.c
+++ b/drivers/net/can/rx-offload.c
@@ -157,7 +157,7 @@ can_rx_offload_offload_one(struct can_rx_offload *offload, unsigned int n)
 	/* There was a problem reading the mailbox, propagate
 	 * error value.
 	 */
-	if (unlikely(IS_ERR(skb))) {
+	if (IS_ERR(skb)) {
 		offload->dev->stats.rx_dropped++;
 		offload->dev->stats.rx_fifo_errors++;
 
-- 
2.29.2

