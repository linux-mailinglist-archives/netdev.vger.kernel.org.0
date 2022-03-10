Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 428544D4A7C
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 15:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243538AbiCJObu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 09:31:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343991AbiCJObe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 09:31:34 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28EBEACB1
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 06:29:18 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nSJn2-00060Z-R1
        for netdev@vger.kernel.org; Thu, 10 Mar 2022 15:29:16 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id D988D47DC9
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 14:29:10 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 5F3E947DB6;
        Thu, 10 Mar 2022 14:29:10 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id e4fd2d8e;
        Thu, 10 Mar 2022 14:29:04 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 13/29] can: gs_usb: rewrap error messages
Date:   Thu, 10 Mar 2022 15:28:47 +0100
Message-Id: <20220310142903.341658-14-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310142903.341658-1-mkl@pengutronix.de>
References: <20220310142903.341658-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch rewraps the arguments of netdev_err() to make full use of
the standard line length of 80 characters.

Link: https://lore.kernel.org/all/20220309124132.291861-6-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/gs_usb.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 23dba5c162c6..b99f526fdfcd 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -630,8 +630,7 @@ static int gs_can_open(struct net_device *netdev)
 					netif_device_detach(dev->netdev);
 
 				netdev_err(netdev,
-					   "usb_submit failed (err=%d)\n",
-					   rc);
+					   "usb_submit failed (err=%d)\n", rc);
 
 				usb_unanchor_urb(urb);
 				usb_free_urb(urb);
@@ -941,8 +940,7 @@ static int gs_usb_probe(struct usb_interface *intf,
 	kfree(hconf);
 
 	if (rc < 0) {
-		dev_err(&intf->dev, "Couldn't send data format (err=%d)\n",
-			rc);
+		dev_err(&intf->dev, "Couldn't send data format (err=%d)\n", rc);
 		return rc;
 	}
 
-- 
2.35.1


