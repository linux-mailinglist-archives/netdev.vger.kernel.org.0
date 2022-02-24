Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E98484C260F
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 09:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232070AbiBXI3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 03:29:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231881AbiBXI3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 03:29:19 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF9E027792F
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 00:28:49 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nN9UV-00044H-VA
        for netdev@vger.kernel.org; Thu, 24 Feb 2022 09:28:48 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 63EF33C2A3
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 08:27:29 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id DD4EB3C22C;
        Thu, 24 Feb 2022 08:27:28 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id a352f5ec;
        Thu, 24 Feb 2022 08:27:28 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>, CGEL ZTE <cgel.zte@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 11/36] can: softing: softing_netdev_open(): remove redundant ret variable
Date:   Thu, 24 Feb 2022 09:27:01 +0100
Message-Id: <20220224082726.3000007-12-mkl@pengutronix.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220224082726.3000007-1-mkl@pengutronix.de>
References: <20220224082726.3000007-1-mkl@pengutronix.de>
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

From: Minghao Chi <chi.minghao@zte.com.cn>

Return value from softing_startstop() directly instead of taking this
in another redundant variable.

Link: https://lore.kernel.org/all/20220112080629.667191-1-chi.minghao@zte.com.cn
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/softing/softing_main.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/can/softing/softing_main.c b/drivers/net/can/softing/softing_main.c
index d74e895bddf7..8d27ac66ca7f 100644
--- a/drivers/net/can/softing/softing_main.c
+++ b/drivers/net/can/softing/softing_main.c
@@ -392,13 +392,10 @@ static int softing_netdev_open(struct net_device *ndev)
 
 static int softing_netdev_stop(struct net_device *ndev)
 {
-	int ret;
-
 	netif_stop_queue(ndev);
 
 	/* softing cycle does close_candev() */
-	ret = softing_startstop(ndev, 0);
-	return ret;
+	return softing_startstop(ndev, 0);
 }
 
 static int softing_candev_set_mode(struct net_device *ndev, enum can_mode mode)
-- 
2.34.1


