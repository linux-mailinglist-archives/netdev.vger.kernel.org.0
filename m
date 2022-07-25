Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E17A257F9BC
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 08:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232960AbiGYGzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 02:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232766AbiGYGzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 02:55:02 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BEF713D1C
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 23:54:33 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id ss3so18743028ejc.11
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 23:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oX2R4w1wEhycH7uORVP6P9jgeQIkVPnZpKFdAOjlClo=;
        b=Vw/fuY3uxKeFT9XJweaa4y3ssNWKFXMSTzo19UK6mErE8WZl9oe3hSx+74wuNhvLxi
         gGlK8rAnRHgWHKE/f7SyYC09YY8bcvQ0vyNyIk3xVy63mm8hb+oF9dvkLB6OmLiyBRQj
         /ZP96I1RGDJC7e7UMmm8mDcVYEdKA9QP9kw3I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oX2R4w1wEhycH7uORVP6P9jgeQIkVPnZpKFdAOjlClo=;
        b=gYuEkNKLk2B1QVWPoC0ZIZQ45WC3wGWE1j2sEMaEG2lFrjf0t3TyG++yO4g6ZmLQpf
         Z8kHrZ28bAUkguWBLQYqqNfxwCXPgZ/sc4VwIUb1IyNSSN0f7OXdIREUZE/jXh1OYErv
         GoA5MOmPi3R0q3nCZ+0KQDI6lZghXosW/3Dpcv+bzYXc60PH+5sEBDJIe7phyNk46lTC
         Sxb3BNDywZ5PRNmZECC6ZKXcWi7GDEQ7AUyPAigAuo+XeT8pNeyoShpL8tEkb7pJWAfz
         /IXTgrCc0zLoCrBvPskFn1iYUjlSRXImoqrnh8FG+oguMG+K3sGveC13CjQiyHpxgHa5
         6zfA==
X-Gm-Message-State: AJIora8saFIr1MBEx6nJcFygOKfd6Yo+IUtCc1at5spEFgC4BeWJtio2
        RUUKFi8MRgVz2dMpBdMj5US61fzqSWrSjg==
X-Google-Smtp-Source: AGRyM1sJTYNR7Pc05e7bg9LTtAtAOkdEg1+yTQ7i3OCjAp34DtDl0lrtrvS73wXr9Gex+ulELJ6BYA==
X-Received: by 2002:a17:906:58c9:b0:72f:4646:1f6f with SMTP id e9-20020a17090658c900b0072f46461f6fmr9049659ejs.181.1658732066866;
        Sun, 24 Jul 2022 23:54:26 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-87-14-98-67.retail.telecomitalia.it. [87.14.98.67])
        by smtp.gmail.com with ESMTPSA id r2-20020a1709060d4200b00722e57fa051sm4967711ejh.90.2022.07.24.23.54.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jul 2022 23:54:26 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Max Staudt <max@enpas.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 2/6] can: slcan: remove legacy infrastructure
Date:   Mon, 25 Jul 2022 08:54:15 +0200
Message-Id: <20220725065419.3005015-3-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220725065419.3005015-1-dario.binacchi@amarulasolutions.com>
References: <20220725065419.3005015-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Taking inspiration from the drivers/net/can/can327.c driver and at the
suggestion of its author Max Staudt, I removed legacy stuff like
`SLCAN_MAGIC' and `slcan_devs' resulting in simplification of the code
and its maintainability.

The use of slcan_devs is derived from a very old kernel, since slip.c
is about 30 years old, so today's kernel allows us to remove it.

The .hangup() ldisc function, which only called the ldisc .close(), has
been removed since the ldisc layer calls .close() in a good place
anyway.

The old slcanX name has been dropped in order to use the standard canX
interface naming. It has been assumed that this change does not break
the user space as the slcan driver provides an ioctl to resolve from tty
fd to netdev name.

The `maxdev' module parameter has also been removed.

CC: Max Staudt <max@enpas.org>
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>

---

Changes in v2:
- Update the commit description.
- Drop the old "slcan" name to use the standard canX interface naming.

 drivers/net/can/slcan/slcan-core.c | 318 ++++++-----------------------
 1 file changed, 63 insertions(+), 255 deletions(-)

diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/slcan-core.c
index c3dd7468a066..2c546f4a7981 100644
--- a/drivers/net/can/slcan/slcan-core.c
+++ b/drivers/net/can/slcan/slcan-core.c
@@ -1,11 +1,14 @@
 /*
  * slcan.c - serial line CAN interface driver (using tty line discipline)
  *
- * This file is derived from linux/drivers/net/slip/slip.c
+ * This file is derived from linux/drivers/net/slip/slip.c and got
+ * inspiration from linux/drivers/net/can/can327.c for the rework made
+ * on the line discipline code.
  *
  * slip.c Authors  : Laurence Culhane <loz@holmes.demon.co.uk>
  *                   Fred N. van Kempen <waltje@uwalt.nl.mugnet.org>
  * slcan.c Author  : Oliver Hartkopp <socketcan@hartkopp.net>
+ * can327.c Author : Max Staudt <max-linux@enpas.org>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
@@ -36,7 +39,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/moduleparam.h>
 
 #include <linux/uaccess.h>
 #include <linux/bitops.h>
@@ -46,7 +48,6 @@
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
 #include <linux/rtnetlink.h>
-#include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/workqueue.h>
@@ -61,15 +62,6 @@ MODULE_DESCRIPTION("serial line CAN interface");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Oliver Hartkopp <socketcan@hartkopp.net>");
 
-#define SLCAN_MAGIC 0x53CA
-
-static int maxdev = 10;		/* MAX number of SLCAN channels;
-				 * This can be overridden with
-				 * insmod slcan.ko maxdev=nnn
-				 */
-module_param(maxdev, int, 0);
-MODULE_PARM_DESC(maxdev, "Maximum number of slcan interfaces");
-
 /* maximum rx buffer len: extended CAN frame with timestamp */
 #define SLC_MTU (sizeof("T1111222281122334455667788EA5F\r") + 1)
 
@@ -83,7 +75,6 @@ MODULE_PARM_DESC(maxdev, "Maximum number of slcan interfaces");
 				   SLC_STATE_BE_TXCNT_LEN)
 struct slcan {
 	struct can_priv         can;
-	int			magic;
 
 	/* Various fields. */
 	struct tty_struct	*tty;		/* ptr to TTY structure	     */
@@ -99,17 +90,14 @@ struct slcan {
 	int			xleft;          /* bytes left in XMIT queue  */
 
 	unsigned long		flags;		/* Flag values/ mode etc     */
-#define SLF_INUSE		0		/* Channel in use            */
-#define SLF_ERROR		1               /* Parity, etc. error        */
-#define SLF_XCMD		2               /* Command transmission      */
+#define SLF_ERROR		0               /* Parity, etc. error        */
+#define SLF_XCMD		1               /* Command transmission      */
 	unsigned long           cmd_flags;      /* Command flags             */
 #define CF_ERR_RST		0               /* Reset errors on open      */
 	wait_queue_head_t       xcmd_wait;      /* Wait queue for commands   */
 						/* transmission              */
 };
 
-static struct net_device **slcan_devs;
-
 static const u32 slcan_bitrate_const[] = {
 	10000, 20000, 50000, 100000, 125000,
 	250000, 500000, 800000, 1000000
@@ -553,9 +541,8 @@ static void slcan_transmit(struct work_struct *work)
 
 	spin_lock_bh(&sl->lock);
 	/* First make sure we're connected. */
-	if (!sl->tty || sl->magic != SLCAN_MAGIC ||
-	    (unlikely(!netif_running(sl->dev)) &&
-	     likely(!test_bit(SLF_XCMD, &sl->flags)))) {
+	if (unlikely(!netif_running(sl->dev)) &&
+	    likely(!test_bit(SLF_XCMD, &sl->flags))) {
 		spin_unlock_bh(&sl->lock);
 		return;
 	}
@@ -590,13 +577,9 @@ static void slcan_transmit(struct work_struct *work)
  */
 static void slcan_write_wakeup(struct tty_struct *tty)
 {
-	struct slcan *sl;
+	struct slcan *sl = (struct slcan *)tty->disc_data;
 
-	rcu_read_lock();
-	sl = rcu_dereference(tty->disc_data);
-	if (sl)
-		schedule_work(&sl->tx_work);
-	rcu_read_unlock();
+	schedule_work(&sl->tx_work);
 }
 
 /* Send a can_frame to a TTY queue. */
@@ -667,25 +650,21 @@ static int slc_close(struct net_device *dev)
 	struct slcan *sl = netdev_priv(dev);
 	int err;
 
-	spin_lock_bh(&sl->lock);
-	if (sl->tty) {
-		if (sl->can.bittiming.bitrate &&
-		    sl->can.bittiming.bitrate != CAN_BITRATE_UNKNOWN) {
-			spin_unlock_bh(&sl->lock);
-			err = slcan_transmit_cmd(sl, "C\r");
-			spin_lock_bh(&sl->lock);
-			if (err)
-				netdev_warn(dev,
-					    "failed to send close command 'C\\r'\n");
-		}
-
-		/* TTY discipline is running. */
-		clear_bit(TTY_DO_WRITE_WAKEUP, &sl->tty->flags);
+	if (sl->can.bittiming.bitrate &&
+	    sl->can.bittiming.bitrate != CAN_BITRATE_UNKNOWN) {
+		err = slcan_transmit_cmd(sl, "C\r");
+		if (err)
+			netdev_warn(dev,
+				    "failed to send close command 'C\\r'\n");
 	}
+
+	/* TTY discipline is running. */
+	clear_bit(TTY_DO_WRITE_WAKEUP, &sl->tty->flags);
+	flush_work(&sl->tx_work);
+
 	netif_stop_queue(dev);
 	sl->rcount   = 0;
 	sl->xleft    = 0;
-	spin_unlock_bh(&sl->lock);
 	close_candev(dev);
 	sl->can.state = CAN_STATE_STOPPED;
 	if (sl->can.bittiming.bitrate == CAN_BITRATE_UNKNOWN)
@@ -701,9 +680,6 @@ static int slc_open(struct net_device *dev)
 	unsigned char cmd[SLC_MTU];
 	int err, s;
 
-	if (!sl->tty)
-		return -ENODEV;
-
 	/* The baud rate is not set with the command
 	 * `ip link set <iface> type can bitrate <baud>' and therefore
 	 * can.bittiming.bitrate is CAN_BITRATE_UNSET (0), causing
@@ -718,8 +694,6 @@ static int slc_open(struct net_device *dev)
 		return err;
 	}
 
-	sl->flags &= BIT(SLF_INUSE);
-
 	if (sl->can.bittiming.bitrate != CAN_BITRATE_UNKNOWN) {
 		for (s = 0; s < ARRAY_SIZE(slcan_bitrate_const); s++) {
 			if (sl->can.bittiming.bitrate == slcan_bitrate_const[s])
@@ -763,14 +737,6 @@ static int slc_open(struct net_device *dev)
 	return err;
 }
 
-static void slc_dealloc(struct slcan *sl)
-{
-	int i = sl->dev->base_addr;
-
-	free_candev(sl->dev);
-	slcan_devs[i] = NULL;
-}
-
 static int slcan_change_mtu(struct net_device *dev, int new_mtu)
 {
 	return -EINVAL;
@@ -800,7 +766,7 @@ static void slcan_receive_buf(struct tty_struct *tty,
 {
 	struct slcan *sl = (struct slcan *)tty->disc_data;
 
-	if (!sl || sl->magic != SLCAN_MAGIC || !netif_running(sl->dev))
+	if (!netif_running(sl->dev))
 		return;
 
 	/* Read the characters out of the buffer */
@@ -815,80 +781,15 @@ static void slcan_receive_buf(struct tty_struct *tty,
 	}
 }
 
-/************************************
- *  slcan_open helper routines.
- ************************************/
-
-/* Collect hanged up channels */
-static void slc_sync(void)
-{
-	int i;
-	struct net_device *dev;
-	struct slcan	  *sl;
-
-	for (i = 0; i < maxdev; i++) {
-		dev = slcan_devs[i];
-		if (!dev)
-			break;
-
-		sl = netdev_priv(dev);
-		if (sl->tty)
-			continue;
-		if (dev->flags & IFF_UP)
-			dev_close(dev);
-	}
-}
-
-/* Find a free SLCAN channel, and link in this `tty' line. */
-static struct slcan *slc_alloc(void)
-{
-	int i;
-	struct net_device *dev = NULL;
-	struct slcan       *sl;
-
-	for (i = 0; i < maxdev; i++) {
-		dev = slcan_devs[i];
-		if (!dev)
-			break;
-	}
-
-	/* Sorry, too many, all slots in use */
-	if (i >= maxdev)
-		return NULL;
-
-	dev = alloc_candev(sizeof(*sl), 1);
-	if (!dev)
-		return NULL;
-
-	snprintf(dev->name, sizeof(dev->name), "slcan%d", i);
-	dev->netdev_ops = &slc_netdev_ops;
-	dev->base_addr  = i;
-	slcan_set_ethtool_ops(dev);
-	sl = netdev_priv(dev);
-
-	/* Initialize channel control data */
-	sl->magic = SLCAN_MAGIC;
-	sl->dev	= dev;
-	sl->can.bitrate_const = slcan_bitrate_const;
-	sl->can.bitrate_const_cnt = ARRAY_SIZE(slcan_bitrate_const);
-	spin_lock_init(&sl->lock);
-	INIT_WORK(&sl->tx_work, slcan_transmit);
-	init_waitqueue_head(&sl->xcmd_wait);
-	slcan_devs[i] = dev;
-
-	return sl;
-}
-
 /* Open the high-level part of the SLCAN channel.
  * This function is called by the TTY module when the
- * SLCAN line discipline is called for.  Because we are
- * sure the tty line exists, we only have to link it to
- * a free SLCAN channel...
+ * SLCAN line discipline is called for.
  *
  * Called in process context serialized from other ldisc calls.
  */
 static int slcan_open(struct tty_struct *tty)
 {
+	struct net_device *dev;
 	struct slcan *sl;
 	int err;
 
@@ -898,72 +799,49 @@ static int slcan_open(struct tty_struct *tty)
 	if (!tty->ops->write)
 		return -EOPNOTSUPP;
 
-	/* RTnetlink lock is misused here to serialize concurrent
-	 * opens of slcan channels. There are better ways, but it is
-	 * the simplest one.
-	 */
-	rtnl_lock();
+	dev = alloc_candev(sizeof(*sl), 1);
+	if (!dev)
+		return -ENFILE;
 
-	/* Collect hanged up channels. */
-	slc_sync();
+	sl = netdev_priv(dev);
 
-	sl = tty->disc_data;
+	/* Configure TTY interface */
+	tty->receive_room = 65536; /* We don't flow control */
+	sl->rcount   = 0;
+	sl->xleft    = 0;
+	spin_lock_init(&sl->lock);
+	INIT_WORK(&sl->tx_work, slcan_transmit);
+	init_waitqueue_head(&sl->xcmd_wait);
 
-	err = -EEXIST;
-	/* First make sure we're not already connected. */
-	if (sl && sl->magic == SLCAN_MAGIC)
-		goto err_exit;
+	/* Configure CAN metadata */
+	sl->can.bitrate_const = slcan_bitrate_const;
+	sl->can.bitrate_const_cnt = ARRAY_SIZE(slcan_bitrate_const);
 
-	/* OK.  Find a free SLCAN channel to use. */
-	err = -ENFILE;
-	sl = slc_alloc();
-	if (!sl)
-		goto err_exit;
+	/* Configure netdev interface */
+	sl->dev	= dev;
+	dev->netdev_ops = &slc_netdev_ops;
+	slcan_set_ethtool_ops(dev);
 
+	/* Mark ldisc channel as alive */
 	sl->tty = tty;
 	tty->disc_data = sl;
 
-	if (!test_bit(SLF_INUSE, &sl->flags)) {
-		/* Perform the low-level SLCAN initialization. */
-		sl->rcount   = 0;
-		sl->xleft    = 0;
-
-		set_bit(SLF_INUSE, &sl->flags);
-
-		rtnl_unlock();
-		err = register_candev(sl->dev);
-		if (err) {
-			pr_err("slcan: can't register candev\n");
-			goto err_free_chan;
-		}
-	} else {
-		rtnl_unlock();
+	err = register_candev(dev);
+	if (err) {
+		free_candev(dev);
+		pr_err("slcan: can't register candev\n");
+		return err;
 	}
 
-	tty->receive_room = 65536;	/* We don't flow control */
-
+	netdev_info(dev, "slcan on %s.\n", tty->name);
 	/* TTY layer expects 0 on success */
 	return 0;
-
-err_free_chan:
-	rtnl_lock();
-	sl->tty = NULL;
-	tty->disc_data = NULL;
-	clear_bit(SLF_INUSE, &sl->flags);
-	slc_dealloc(sl);
-	rtnl_unlock();
-	return err;
-
-err_exit:
-	rtnl_unlock();
-
-	/* Count references from TTY module */
-	return err;
 }
 
 /* Close down a SLCAN channel.
  * This means flushing out any pending queues, and then returning. This
  * call is serialized against other ldisc functions.
+ * Once this is called, no other ldisc function of ours is entered.
  *
  * We also use this method for a hangup event.
  */
@@ -971,28 +849,20 @@ static void slcan_close(struct tty_struct *tty)
 {
 	struct slcan *sl = (struct slcan *)tty->disc_data;
 
-	/* First make sure we're connected. */
-	if (!sl || sl->magic != SLCAN_MAGIC || sl->tty != tty)
-		return;
+	/* unregister_netdev() calls .ndo_stop() so we don't have to.
+	 * Our .ndo_stop() also flushes the TTY write wakeup handler,
+	 * so we can safely set sl->tty = NULL after this.
+	 */
+	unregister_candev(sl->dev);
 
+	/* Mark channel as dead */
 	spin_lock_bh(&sl->lock);
-	rcu_assign_pointer(tty->disc_data, NULL);
+	tty->disc_data = NULL;
 	sl->tty = NULL;
 	spin_unlock_bh(&sl->lock);
 
-	synchronize_rcu();
-	flush_work(&sl->tx_work);
-
-	slc_close(sl->dev);
-	unregister_candev(sl->dev);
-	rtnl_lock();
-	slc_dealloc(sl);
-	rtnl_unlock();
-}
-
-static void slcan_hangup(struct tty_struct *tty)
-{
-	slcan_close(tty);
+	netdev_info(sl->dev, "slcan off %s.\n", tty->name);
+	free_candev(sl->dev);
 }
 
 /* Perform I/O control on an active SLCAN channel. */
@@ -1002,10 +872,6 @@ static int slcan_ioctl(struct tty_struct *tty, unsigned int cmd,
 	struct slcan *sl = (struct slcan *)tty->disc_data;
 	unsigned int tmp;
 
-	/* First make sure we're connected. */
-	if (!sl || sl->magic != SLCAN_MAGIC)
-		return -EINVAL;
-
 	switch (cmd) {
 	case SIOCGIFNAME:
 		tmp = strlen(sl->dev->name) + 1;
@@ -1027,7 +893,6 @@ static struct tty_ldisc_ops slc_ldisc = {
 	.name		= "slcan",
 	.open		= slcan_open,
 	.close		= slcan_close,
-	.hangup		= slcan_hangup,
 	.ioctl		= slcan_ioctl,
 	.receive_buf	= slcan_receive_buf,
 	.write_wakeup	= slcan_write_wakeup,
@@ -1037,78 +902,21 @@ static int __init slcan_init(void)
 {
 	int status;
 
-	if (maxdev < 4)
-		maxdev = 4; /* Sanity */
-
 	pr_info("slcan: serial line CAN interface driver\n");
-	pr_info("slcan: %d dynamic interface channels.\n", maxdev);
-
-	slcan_devs = kcalloc(maxdev, sizeof(struct net_device *), GFP_KERNEL);
-	if (!slcan_devs)
-		return -ENOMEM;
 
 	/* Fill in our line protocol discipline, and register it */
 	status = tty_register_ldisc(&slc_ldisc);
-	if (status)  {
+	if (status)
 		pr_err("slcan: can't register line discipline\n");
-		kfree(slcan_devs);
-	}
+
 	return status;
 }
 
 static void __exit slcan_exit(void)
 {
-	int i;
-	struct net_device *dev;
-	struct slcan *sl;
-	unsigned long timeout = jiffies + HZ;
-	int busy = 0;
-
-	if (!slcan_devs)
-		return;
-
-	/* First of all: check for active disciplines and hangup them.
-	 */
-	do {
-		if (busy)
-			msleep_interruptible(100);
-
-		busy = 0;
-		for (i = 0; i < maxdev; i++) {
-			dev = slcan_devs[i];
-			if (!dev)
-				continue;
-			sl = netdev_priv(dev);
-			spin_lock_bh(&sl->lock);
-			if (sl->tty) {
-				busy++;
-				tty_hangup(sl->tty);
-			}
-			spin_unlock_bh(&sl->lock);
-		}
-	} while (busy && time_before(jiffies, timeout));
-
-	/* FIXME: hangup is async so we should wait when doing this second
-	 * phase
+	/* This will only be called when all channels have been closed by
+	 * userspace - tty_ldisc.c takes care of the module's refcount.
 	 */
-
-	for (i = 0; i < maxdev; i++) {
-		dev = slcan_devs[i];
-		if (!dev)
-			continue;
-
-		sl = netdev_priv(dev);
-		if (sl->tty)
-			netdev_err(dev, "tty discipline still running\n");
-
-		slc_close(dev);
-		unregister_candev(dev);
-		slc_dealloc(sl);
-	}
-
-	kfree(slcan_devs);
-	slcan_devs = NULL;
-
 	tty_unregister_ldisc(&slc_ldisc);
 }
 
-- 
2.32.0

