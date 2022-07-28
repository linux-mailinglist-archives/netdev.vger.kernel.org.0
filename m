Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C56B1583928
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 09:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234579AbiG1HDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 03:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234513AbiG1HDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 03:03:12 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBDF75E33B
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 00:03:08 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id bp15so1566419ejb.6
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 00:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RIwpnqXVkEPVC9y6D6imEtiW45Xx5sUlsaiN9YQ/yrc=;
        b=pFlhC11P+9uiFlyNzrHGPV/aV30iTr/DUcA90eJo/dj6jfyO5QrMNkoy9lNWdM1tom
         5up+gSEmgC7Bk3c3U3oZQeRFE2gwzUnLponlYZGK2MISv9+ylsXdtskKpVDAAkpqQQl8
         Z/TbLryMtLlNK8iIMMp5h2p+9NG9xo6CqZlqQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RIwpnqXVkEPVC9y6D6imEtiW45Xx5sUlsaiN9YQ/yrc=;
        b=fdHnkKX6qb69fT2If8/j8VT6RzT1viWWugM1CNQZk1ICwZee+gnn5Vvu/ovy7VZo1P
         pJOR8P64EFk9masWcYwDdLVylmbTk6zGUrKILtklDu8luuht6hxYpHUqm/Meyaqbfgdj
         TQIDHaD35fnsTJcZ9paL0qfeldbQsn4JcjcGjge+i3uAI+j3t16CM00M3VJg2/UGerTV
         4LFsKhDv+S7saEwYehYedw+HZBnUbvz5BCEP9L0Q7Hkd8Gsb60XyjUVmrQtI9rlYyrgy
         kYg6ZEeHrYZ0U2xLF9rgvR74y2Ife345sOs0zDx3T7XYxRZocdt8lgONoJleHM0TS1DE
         1FLg==
X-Gm-Message-State: AJIora9OqU7Eg+iO9W8prNeRgZrTtdoCDb8cmHn8GB+m041ScGLBmHsv
        ZC8rioa2MazMRGenJ2S0Oyvr3A==
X-Google-Smtp-Source: AGRyM1tfsjR+sjcPtbIaDhoesXXJJ+zVu/yzXPPN8NgJOkt4U2iF9Qjmb5iDVH1YU2wgxhMfjN71xg==
X-Received: by 2002:a17:907:8690:b0:72b:552e:67c0 with SMTP id qa16-20020a170907869000b0072b552e67c0mr20012840ejc.600.1658991787258;
        Thu, 28 Jul 2022 00:03:07 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-79-31-31-9.retail.telecomitalia.it. [79.31.31.9])
        by smtp.gmail.com with ESMTPSA id r18-20020aa7d152000000b0042de3d661d2sm154742edo.1.2022.07.28.00.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 00:03:06 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Max Staudt <max@enpas.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>, netdev@vger.kernel.org
Subject: [PATCH v4 3/7] can: slcan: remove legacy infrastructure
Date:   Thu, 28 Jul 2022 09:02:50 +0200
Message-Id: <20220728070254.267974-4-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220728070254.267974-1-dario.binacchi@amarulasolutions.com>
References: <20220728070254.267974-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
interface naming. The ioctl SIOCGIFNAME can be used to query the name of
the created interface. Furthermore, there are several ways to get stable
interfaces names in user space, e.g. udev or systemd-networkd.

The `maxdev' module parameter has also been removed.

CC: Max Staudt <max@enpas.org>
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Reviewed-by: Max Staudt <max@enpas.org>

---

Changes in v4:
- Add Max Staudt's `Reviewed-by' tag.

Changes in v3:
- Update the commit message.
- Use 1 space in front of the =.

Changes in v2:
- Update the commit description.
- Drop the old "slcan" name to use the standard canX interface naming.

 drivers/net/can/slcan/slcan-core.c | 318 ++++++-----------------------
 1 file changed, 63 insertions(+), 255 deletions(-)

diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/slcan-core.c
index ca383c43167d..0d309d0636df 100644
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
@@ -38,7 +41,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
-#include <linux/moduleparam.h>
 
 #include <linux/uaccess.h>
 #include <linux/bitops.h>
@@ -48,7 +50,6 @@
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
 #include <linux/rtnetlink.h>
-#include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/workqueue.h>
@@ -63,15 +64,6 @@ MODULE_DESCRIPTION("serial line CAN interface");
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
 
@@ -85,7 +77,6 @@ MODULE_PARM_DESC(maxdev, "Maximum number of slcan interfaces");
 				   SLC_STATE_BE_TXCNT_LEN)
 struct slcan {
 	struct can_priv         can;
-	int			magic;
 
 	/* Various fields. */
 	struct tty_struct	*tty;		/* ptr to TTY structure	     */
@@ -101,17 +92,14 @@ struct slcan {
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
@@ -555,9 +543,8 @@ static void slcan_transmit(struct work_struct *work)
 
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
@@ -592,13 +579,9 @@ static void slcan_transmit(struct work_struct *work)
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
@@ -669,25 +652,21 @@ static int slc_close(struct net_device *dev)
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
@@ -703,9 +682,6 @@ static int slc_open(struct net_device *dev)
 	unsigned char cmd[SLC_MTU];
 	int err, s;
 
-	if (!sl->tty)
-		return -ENODEV;
-
 	/* The baud rate is not set with the command
 	 * `ip link set <iface> type can bitrate <baud>' and therefore
 	 * can.bittiming.bitrate is CAN_BITRATE_UNSET (0), causing
@@ -720,8 +696,6 @@ static int slc_open(struct net_device *dev)
 		return err;
 	}
 
-	sl->flags &= BIT(SLF_INUSE);
-
 	if (sl->can.bittiming.bitrate != CAN_BITRATE_UNKNOWN) {
 		for (s = 0; s < ARRAY_SIZE(slcan_bitrate_const); s++) {
 			if (sl->can.bittiming.bitrate == slcan_bitrate_const[s])
@@ -765,14 +739,6 @@ static int slc_open(struct net_device *dev)
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
@@ -802,7 +768,7 @@ static void slcan_receive_buf(struct tty_struct *tty,
 {
 	struct slcan *sl = (struct slcan *)tty->disc_data;
 
-	if (!sl || sl->magic != SLCAN_MAGIC || !netif_running(sl->dev))
+	if (!netif_running(sl->dev))
 		return;
 
 	/* Read the characters out of the buffer */
@@ -817,80 +783,15 @@ static void slcan_receive_buf(struct tty_struct *tty,
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
-	snprintf(dev->name, sizeof(dev->name), KBUILD_MODNAME "%d", i);
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
 
@@ -900,72 +801,49 @@ static int slcan_open(struct tty_struct *tty)
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
+	sl->rcount = 0;
+	sl->xleft = 0;
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
-			pr_err("can't register candev\n");
-			goto err_free_chan;
-		}
-	} else {
-		rtnl_unlock();
+	err = register_candev(dev);
+	if (err) {
+		free_candev(dev);
+		pr_err("can't register candev\n");
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
@@ -973,28 +851,20 @@ static void slcan_close(struct tty_struct *tty)
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
@@ -1004,10 +874,6 @@ static int slcan_ioctl(struct tty_struct *tty, unsigned int cmd,
 	struct slcan *sl = (struct slcan *)tty->disc_data;
 	unsigned int tmp;
 
-	/* First make sure we're connected. */
-	if (!sl || sl->magic != SLCAN_MAGIC)
-		return -EINVAL;
-
 	switch (cmd) {
 	case SIOCGIFNAME:
 		tmp = strlen(sl->dev->name) + 1;
@@ -1029,7 +895,6 @@ static struct tty_ldisc_ops slc_ldisc = {
 	.name		= KBUILD_MODNAME,
 	.open		= slcan_open,
 	.close		= slcan_close,
-	.hangup		= slcan_hangup,
 	.ioctl		= slcan_ioctl,
 	.receive_buf	= slcan_receive_buf,
 	.write_wakeup	= slcan_write_wakeup,
@@ -1039,78 +904,21 @@ static int __init slcan_init(void)
 {
 	int status;
 
-	if (maxdev < 4)
-		maxdev = 4; /* Sanity */
-
 	pr_info("serial line CAN interface driver\n");
-	pr_info("%d dynamic interface channels.\n", maxdev);
-
-	slcan_devs = kcalloc(maxdev, sizeof(struct net_device *), GFP_KERNEL);
-	if (!slcan_devs)
-		return -ENOMEM;
 
 	/* Fill in our line protocol discipline, and register it */
 	status = tty_register_ldisc(&slc_ldisc);
-	if (status)  {
+	if (status)
 		pr_err("can't register line discipline\n");
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

