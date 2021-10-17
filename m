Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B246430C31
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 23:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344631AbhJQVES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 17:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344632AbhJQVEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 17:04:10 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A927C061765
        for <netdev@vger.kernel.org>; Sun, 17 Oct 2021 14:01:58 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mcDI5-0000M9-9q
        for netdev@vger.kernel.org; Sun, 17 Oct 2021 23:01:57 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 3F8F0695F14
        for <netdev@vger.kernel.org>; Sun, 17 Oct 2021 21:01:50 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 00310695EC5;
        Sun, 17 Oct 2021 21:01:45 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 19e53691;
        Sun, 17 Oct 2021 21:01:43 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 11/11] can: peak_usb: pcan_usb_fd_decode_status(): remove unnecessary test on the nullity of a pointer
Date:   Sun, 17 Oct 2021 23:01:42 +0200
Message-Id: <20211017210142.2108610-12-mkl@pengutronix.de>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211017210142.2108610-1-mkl@pengutronix.de>
References: <20211017210142.2108610-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephane Grosjean <s.grosjean@peak-system.com>

Since alloc_can_err_skb() puts NULL in cf in the case when skb cannot
be allocated and can_change_state() handles the case when cf is NULL,
the test on the nullity of skb is now unnecessary.

Link: https://lore.kernel.org/all/20210929142111.55757-2-s.grosjean@peak-system.com
Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
index e206959b3d06..09029a3bad1a 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
@@ -567,8 +567,7 @@ static int pcan_usb_fd_decode_status(struct pcan_usb_fd_if *usb_if,
 
 	/* allocate an skb to store the error frame */
 	skb = alloc_can_err_skb(netdev, &cf);
-	if (skb)
-		can_change_state(netdev, cf, tx_state, rx_state);
+	can_change_state(netdev, cf, tx_state, rx_state);
 
 	/* things must be done even in case of OOM */
 	if (new_state == CAN_STATE_BUS_OFF)
-- 
2.33.0


