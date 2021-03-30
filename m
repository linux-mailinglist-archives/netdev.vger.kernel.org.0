Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7E0034E6C8
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 13:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbhC3Lri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 07:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232025AbhC3Lqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 07:46:48 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67333C0613D9
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 04:46:48 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lRCpa-0006ZN-Up
        for netdev@vger.kernel.org; Tue, 30 Mar 2021 13:46:47 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 92D5B603EE5
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 11:46:31 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id A1554603E49;
        Tue, 30 Mar 2021 11:46:14 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 16114e01;
        Tue, 30 Mar 2021 11:46:01 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 32/39] can: c_can: replace double assignments by two single ones
Date:   Tue, 30 Mar 2021 13:45:52 +0200
Message-Id: <20210330114559.1114855-33-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330114559.1114855-1-mkl@pengutronix.de>
References: <20210330114559.1114855-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch replaces the double assignments by two single ones, to make
checkpatch happy.

Link: https://lore.kernel.org/r/20210304154240.2747987-6-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/c_can/c_can.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index cd98d30dd083..7d63b227275d 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -703,7 +703,8 @@ static void c_can_do_tx(struct net_device *dev)
 	struct net_device_stats *stats = &dev->stats;
 	u32 idx, obj, pkts = 0, bytes = 0, pend, clr;
 
-	clr = pend = priv->read_reg(priv, C_CAN_INTPND2_REG);
+	pend = priv->read_reg(priv, C_CAN_INTPND2_REG);
+	clr = pend;
 
 	while ((idx = ffs(pend))) {
 		idx--;
@@ -1029,7 +1030,8 @@ static int c_can_poll(struct napi_struct *napi, int quota)
 
 	/* Only read the status register if a status interrupt was pending */
 	if (atomic_xchg(&priv->sie_pending, 0)) {
-		priv->last_status = curr = priv->read_reg(priv, C_CAN_STS_REG);
+		priv->last_status = priv->read_reg(priv, C_CAN_STS_REG);
+		curr = priv->last_status;
 		/* Ack status on C_CAN. D_CAN is self clearing */
 		if (priv->type != BOSCH_D_CAN)
 			priv->write_reg(priv, C_CAN_STS_REG, LEC_UNUSED);
-- 
2.30.2


