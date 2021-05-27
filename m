Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D87073929F3
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 10:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235649AbhE0IuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 04:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235630AbhE0Itz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 04:49:55 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D64C061349
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 01:48:20 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lmBgh-000244-7a
        for netdev@vger.kernel.org; Thu, 27 May 2021 10:48:19 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 7008962D4AF
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 08:45:45 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 6ADEC62D410;
        Thu, 27 May 2021 08:45:37 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id cdee3d72;
        Thu, 27 May 2021 08:45:34 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Dario Binacchi <dariobin@libero.it>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 16/21] can: c_can: remove unused variable struct c_can_priv::rxmasked
Date:   Thu, 27 May 2021 10:45:27 +0200
Message-Id: <20210527084532.1384031-17-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210527084532.1384031-1-mkl@pengutronix.de>
References: <20210527084532.1384031-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dario Binacchi <dariobin@libero.it>

The member rxmasked of struct c_can_priv is initialized by
c_can_chip_config(), but's it's never used, so remove it.

Link: https://lore.kernel.org/r/20210509124309.30024-2-dariobin@libero.it
Signed-off-by: Dario Binacchi <dariobin@libero.it>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/c_can/c_can.c | 1 -
 drivers/net/can/c_can/c_can.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 313793f6922d..1fa47968c2ec 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -599,7 +599,6 @@ static int c_can_chip_config(struct net_device *dev)
 
 	/* Clear all internal status */
 	atomic_set(&priv->tx_active, 0);
-	priv->rxmasked = 0;
 	priv->tx_dir = 0;
 
 	/* set bittiming params */
diff --git a/drivers/net/can/c_can/c_can.h b/drivers/net/can/c_can/c_can.h
index 06045f610f0e..517845c4571e 100644
--- a/drivers/net/can/c_can/c_can.h
+++ b/drivers/net/can/c_can/c_can.h
@@ -205,7 +205,6 @@ struct c_can_priv {
 	struct c_can_raminit raminit_sys;	/* RAMINIT via syscon regmap */
 	void (*raminit)(const struct c_can_priv *priv, bool enable);
 	u32 comm_rcv_high;
-	u32 rxmasked;
 	u32 dlc[];
 };
 
-- 
2.30.2


