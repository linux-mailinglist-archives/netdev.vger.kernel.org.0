Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88C205860D6
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 21:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238175AbiGaTVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 15:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238138AbiGaTUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 15:20:47 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F06DFA4
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 12:20:44 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oIEUU-0007IZ-6G
        for netdev@vger.kernel.org; Sun, 31 Jul 2022 21:20:42 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id E16BEBEC75
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 19:20:36 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 4104BBEC59;
        Sun, 31 Jul 2022 19:20:36 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 4502cc1b;
        Sun, 31 Jul 2022 19:20:30 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 14/36] can: slcan: use KBUILD_MODNAME and define pr_fmt to replace hardcoded names
Date:   Sun, 31 Jul 2022 21:20:07 +0200
Message-Id: <20220731192029.746751-15-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220731192029.746751-1-mkl@pengutronix.de>
References: <20220731192029.746751-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

The driver uses the string "slcan" to populate
tty_ldisc_ops::name. KBUILD_MODNAME also evaluates to "slcan". Use
KBUILD_MODNAME to get rid on the hardcoded string names.

Similarly, the pr_info() and pr_err() hardcoded the "slcan"
prefix. Define pr_fmt so that the "slcan" prefix gets automatically
added.

CC: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Link: https://lore.kernel.org/all/20220728070254.267974-2-dario.binacchi@amarulasolutions.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/slcan/slcan-core.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/slcan-core.c
index 6162e6132ea4..3b1f39d69e6e 100644
--- a/drivers/net/can/slcan/slcan-core.c
+++ b/drivers/net/can/slcan/slcan-core.c
@@ -35,6 +35,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 
@@ -864,7 +866,7 @@ static struct slcan *slc_alloc(void)
 	if (!dev)
 		return NULL;
 
-	snprintf(dev->name, sizeof(dev->name), "slcan%d", i);
+	snprintf(dev->name, sizeof(dev->name), KBUILD_MODNAME "%d", i);
 	dev->netdev_ops = &slc_netdev_ops;
 	dev->ethtool_ops = &slcan_ethtool_ops;
 	dev->base_addr  = i;
@@ -937,7 +939,7 @@ static int slcan_open(struct tty_struct *tty)
 		rtnl_unlock();
 		err = register_candev(sl->dev);
 		if (err) {
-			pr_err("slcan: can't register candev\n");
+			pr_err("can't register candev\n");
 			goto err_free_chan;
 		}
 	} else {
@@ -1028,7 +1030,7 @@ static int slcan_ioctl(struct tty_struct *tty, unsigned int cmd,
 static struct tty_ldisc_ops slc_ldisc = {
 	.owner		= THIS_MODULE,
 	.num		= N_SLCAN,
-	.name		= "slcan",
+	.name		= KBUILD_MODNAME,
 	.open		= slcan_open,
 	.close		= slcan_close,
 	.hangup		= slcan_hangup,
@@ -1044,8 +1046,8 @@ static int __init slcan_init(void)
 	if (maxdev < 4)
 		maxdev = 4; /* Sanity */
 
-	pr_info("slcan: serial line CAN interface driver\n");
-	pr_info("slcan: %d dynamic interface channels.\n", maxdev);
+	pr_info("serial line CAN interface driver\n");
+	pr_info("%d dynamic interface channels.\n", maxdev);
 
 	slcan_devs = kcalloc(maxdev, sizeof(struct net_device *), GFP_KERNEL);
 	if (!slcan_devs)
@@ -1054,7 +1056,7 @@ static int __init slcan_init(void)
 	/* Fill in our line protocol discipline, and register it */
 	status = tty_register_ldisc(&slc_ldisc);
 	if (status)  {
-		pr_err("slcan: can't register line discipline\n");
+		pr_err("can't register line discipline\n");
 		kfree(slcan_devs);
 	}
 	return status;
-- 
2.35.1


