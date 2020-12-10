Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 821822D57AA
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 10:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728262AbgLJJ4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 04:56:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727879AbgLJJ4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 04:56:00 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1384C0617A7
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 01:55:17 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1knIfM-0000yW-9w
        for netdev@vger.kernel.org; Thu, 10 Dec 2020 10:55:16 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 3A8F05AA1BD
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 09:55:13 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 250255AA197;
        Thu, 10 Dec 2020 09:55:09 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 89c14679;
        Thu, 10 Dec 2020 09:55:08 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Antonio Quartulli <a@unstable.cc>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 2/7] can: rx-offload: can_rx_offload_offload_one(): avoid double unlikely() notation when using IS_ERR()
Date:   Thu, 10 Dec 2020 10:55:02 +0100
Message-Id: <20201210095507.1551220-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210095507.1551220-1-mkl@pengutronix.de>
References: <20201210095507.1551220-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antonio Quartulli <a@unstable.cc>

The definition of IS_ERR() already applies the unlikely() notation when
checking the error status of the passed pointer. For this reason there is no
need to have the same notation outside of IS_ERR() itself.

Clean up code by removing redundant notation.

Signed-off-by: Antonio Quartulli <a@unstable.cc>
Link: https://lore.kernel.org/r/20201210085321.18693-1-a@unstable.cc
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
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


