Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A03157F9B4
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 08:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233068AbiGYGz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 02:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232866AbiGYGzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 02:55:04 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ACCC12613
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 23:54:39 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id os14so18861926ejb.4
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 23:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UaPOtdBDZe4x/dJbeCjrVF6QNzv0ZLfNcWq1YThRP0s=;
        b=BLx3Ps5aXOQoYNERMx9mxKMUeJBLJ/g5inPVuzeBuIE9nVD/ihwRY3DvryBbNKbpoY
         z7GIvM3MAFHFl/6WUk9EWMKyqkDvG/HWMOlrGf1edBw8DXJpW30j/PofGAUcxPAb9Jlz
         VHnJnE0616l8W4kqmhmkMBdlc7prSw5ka12sA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UaPOtdBDZe4x/dJbeCjrVF6QNzv0ZLfNcWq1YThRP0s=;
        b=R5zXP36p2ao0pQg6yA5s0PuFe9uW/6G+otMY01/8y7iR83yBRtvu6SCXv5KJLV53ll
         55eAk1ihfbWWIhG2uyVoP0ob6vl6xHm+BbqQK/mGEQzuZQcuJt3x0jCjabNW9kRP/JcK
         TVOBV87k8/19XIssoAAs9iYJeIdezZj2hNzp+3aQMLLzAvRbxb0+cBb+J2cTdsbcUICJ
         +X0ObcchT545jzzbR39G01EeNZSia0AYkwhDe6YANSmJbzDrBxBg6eLb27+aSU5MFnDI
         WNwHeZYbxSF8R/0DeEtXsE8h00MsJNunbRtiKI3vih8I9F9X4TVbBb3Zgc2hTTEXr92G
         0NwA==
X-Gm-Message-State: AJIora/sEFmwFJtD/L7XPF5fKhTVdWanT82WuTZWcdZ0d2IO4Dgbh2NL
        GlgCJ4oV6/zHQUJvnQnPiUAD4w==
X-Google-Smtp-Source: AGRyM1v3m8urn3TQz8UTcb4KI+FAccpxNWpzA2MGf7rKncAGwAd9kI8tU5gfLCoQmY7Gf8NXY1EV2g==
X-Received: by 2002:a17:907:a063:b0:72b:52f7:feea with SMTP id ia3-20020a170907a06300b0072b52f7feeamr9037282ejc.740.1658732068258;
        Sun, 24 Jul 2022 23:54:28 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-87-14-98-67.retail.telecomitalia.it. [87.14.98.67])
        by smtp.gmail.com with ESMTPSA id r2-20020a1709060d4200b00722e57fa051sm4967711ejh.90.2022.07.24.23.54.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jul 2022 23:54:27 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 3/6] can: slcan: change every `slc' occurrence in `slcan'
Date:   Mon, 25 Jul 2022 08:54:16 +0200
Message-Id: <20220725065419.3005015-4-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220725065419.3005015-1-dario.binacchi@amarulasolutions.com>
References: <20220725065419.3005015-1-dario.binacchi@amarulasolutions.com>
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

In the driver there are parts of code where the prefix `slc' is used and
others where the prefix `slcan' is used instead. The patch replaces
every occurrence of `slc' with `slcan', except for the netdev functions
where, to avoid compilation conflicts, it was necessary to replace `slc'
with `slcan_netdev'.

The patch does not make any functional changes.

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
---

(no changes since v1)

 drivers/net/can/slcan/slcan-core.c | 109 +++++++++++++++--------------
 1 file changed, 56 insertions(+), 53 deletions(-)

diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/slcan-core.c
index 2c546f4a7981..09d4abbbd9f4 100644
--- a/drivers/net/can/slcan/slcan-core.c
+++ b/drivers/net/can/slcan/slcan-core.c
@@ -63,16 +63,17 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Oliver Hartkopp <socketcan@hartkopp.net>");
 
 /* maximum rx buffer len: extended CAN frame with timestamp */
-#define SLC_MTU (sizeof("T1111222281122334455667788EA5F\r") + 1)
-
-#define SLC_CMD_LEN 1
-#define SLC_SFF_ID_LEN 3
-#define SLC_EFF_ID_LEN 8
-#define SLC_STATE_LEN 1
-#define SLC_STATE_BE_RXCNT_LEN 3
-#define SLC_STATE_BE_TXCNT_LEN 3
-#define SLC_STATE_FRAME_LEN       (1 + SLC_CMD_LEN + SLC_STATE_BE_RXCNT_LEN + \
-				   SLC_STATE_BE_TXCNT_LEN)
+#define SLCAN_MTU (sizeof("T1111222281122334455667788EA5F\r") + 1)
+
+#define SLCAN_CMD_LEN 1
+#define SLCAN_SFF_ID_LEN 3
+#define SLCAN_EFF_ID_LEN 8
+#define SLCAN_STATE_LEN 1
+#define SLCAN_STATE_BE_RXCNT_LEN 3
+#define SLCAN_STATE_BE_TXCNT_LEN 3
+#define SLCAN_STATE_FRAME_LEN       (1 + SLCAN_CMD_LEN + \
+				     SLCAN_STATE_BE_RXCNT_LEN + \
+				     SLCAN_STATE_BE_TXCNT_LEN)
 struct slcan {
 	struct can_priv         can;
 
@@ -83,9 +84,9 @@ struct slcan {
 	struct work_struct	tx_work;	/* Flushes transmit buffer   */
 
 	/* These are pointers to the malloc()ed frame buffers. */
-	unsigned char		rbuff[SLC_MTU];	/* receiver buffer	     */
+	unsigned char		rbuff[SLCAN_MTU];	/* receiver buffer   */
 	int			rcount;         /* received chars counter    */
-	unsigned char		xbuff[SLC_MTU];	/* transmitter buffer	     */
+	unsigned char		xbuff[SLCAN_MTU];	/* transmitter buffer*/
 	unsigned char		*xhead;         /* pointer to next XMIT byte */
 	int			xleft;          /* bytes left in XMIT queue  */
 
@@ -164,7 +165,7 @@ int slcan_enable_err_rst_on_open(struct net_device *ndev, bool on)
  *************************************************************************/
 
 /* Send one completely decapsulated can_frame to the network layer */
-static void slc_bump_frame(struct slcan *sl)
+static void slcan_bump_frame(struct slcan *sl)
 {
 	struct sk_buff *skb;
 	struct can_frame *cf;
@@ -184,10 +185,10 @@ static void slc_bump_frame(struct slcan *sl)
 		fallthrough;
 	case 't':
 		/* store dlc ASCII value and terminate SFF CAN ID string */
-		cf->len = sl->rbuff[SLC_CMD_LEN + SLC_SFF_ID_LEN];
-		sl->rbuff[SLC_CMD_LEN + SLC_SFF_ID_LEN] = 0;
+		cf->len = sl->rbuff[SLCAN_CMD_LEN + SLCAN_SFF_ID_LEN];
+		sl->rbuff[SLCAN_CMD_LEN + SLCAN_SFF_ID_LEN] = 0;
 		/* point to payload data behind the dlc */
-		cmd += SLC_CMD_LEN + SLC_SFF_ID_LEN + 1;
+		cmd += SLCAN_CMD_LEN + SLCAN_SFF_ID_LEN + 1;
 		break;
 	case 'R':
 		cf->can_id = CAN_RTR_FLAG;
@@ -195,16 +196,16 @@ static void slc_bump_frame(struct slcan *sl)
 	case 'T':
 		cf->can_id |= CAN_EFF_FLAG;
 		/* store dlc ASCII value and terminate EFF CAN ID string */
-		cf->len = sl->rbuff[SLC_CMD_LEN + SLC_EFF_ID_LEN];
-		sl->rbuff[SLC_CMD_LEN + SLC_EFF_ID_LEN] = 0;
+		cf->len = sl->rbuff[SLCAN_CMD_LEN + SLCAN_EFF_ID_LEN];
+		sl->rbuff[SLCAN_CMD_LEN + SLCAN_EFF_ID_LEN] = 0;
 		/* point to payload data behind the dlc */
-		cmd += SLC_CMD_LEN + SLC_EFF_ID_LEN + 1;
+		cmd += SLCAN_CMD_LEN + SLCAN_EFF_ID_LEN + 1;
 		break;
 	default:
 		goto decode_failed;
 	}
 
-	if (kstrtou32(sl->rbuff + SLC_CMD_LEN, 16, &tmpid))
+	if (kstrtou32(sl->rbuff + SLCAN_CMD_LEN, 16, &tmpid))
 		goto decode_failed;
 
 	cf->can_id |= tmpid;
@@ -251,7 +252,7 @@ static void slc_bump_frame(struct slcan *sl)
  * sb256256 : state bus-off: rx counter 256, tx counter 256
  * sa057033 : state active, rx counter 57, tx counter 33
  */
-static void slc_bump_state(struct slcan *sl)
+static void slcan_bump_state(struct slcan *sl)
 {
 	struct net_device *dev = sl->dev;
 	struct sk_buff *skb;
@@ -277,16 +278,16 @@ static void slc_bump_state(struct slcan *sl)
 		return;
 	}
 
-	if (state == sl->can.state || sl->rcount < SLC_STATE_FRAME_LEN)
+	if (state == sl->can.state || sl->rcount < SLCAN_STATE_FRAME_LEN)
 		return;
 
-	cmd += SLC_STATE_BE_RXCNT_LEN + SLC_CMD_LEN + 1;
-	cmd[SLC_STATE_BE_TXCNT_LEN] = 0;
+	cmd += SLCAN_STATE_BE_RXCNT_LEN + SLCAN_CMD_LEN + 1;
+	cmd[SLCAN_STATE_BE_TXCNT_LEN] = 0;
 	if (kstrtou32(cmd, 10, &txerr))
 		return;
 
 	*cmd = 0;
-	cmd -= SLC_STATE_BE_RXCNT_LEN;
+	cmd -= SLCAN_STATE_BE_RXCNT_LEN;
 	if (kstrtou32(cmd, 10, &rxerr))
 		return;
 
@@ -314,7 +315,7 @@ static void slc_bump_state(struct slcan *sl)
  * e1a : len 1, errors: ACK error
  * e3bcO: len 3, errors: Bit0 error, CRC error, Tx overrun error
  */
-static void slc_bump_err(struct slcan *sl)
+static void slcan_bump_err(struct slcan *sl)
 {
 	struct net_device *dev = sl->dev;
 	struct sk_buff *skb;
@@ -330,7 +331,7 @@ static void slc_bump_err(struct slcan *sl)
 	else
 		return;
 
-	if ((len + SLC_CMD_LEN + 1) > sl->rcount)
+	if ((len + SLCAN_CMD_LEN + 1) > sl->rcount)
 		return;
 
 	skb = alloc_can_err_skb(dev, &cf);
@@ -338,7 +339,7 @@ static void slc_bump_err(struct slcan *sl)
 	if (skb)
 		cf->can_id |= CAN_ERR_PROT | CAN_ERR_BUSERROR;
 
-	cmd += SLC_CMD_LEN + 1;
+	cmd += SLCAN_CMD_LEN + 1;
 	for (i = 0; i < len; i++, cmd++) {
 		switch (*cmd) {
 		case 'a':
@@ -427,7 +428,7 @@ static void slc_bump_err(struct slcan *sl)
 		netif_rx(skb);
 }
 
-static void slc_bump(struct slcan *sl)
+static void slcan_bump(struct slcan *sl)
 {
 	switch (sl->rbuff[0]) {
 	case 'r':
@@ -437,11 +438,11 @@ static void slc_bump(struct slcan *sl)
 	case 'R':
 		fallthrough;
 	case 'T':
-		return slc_bump_frame(sl);
+		return slcan_bump_frame(sl);
 	case 'e':
-		return slc_bump_err(sl);
+		return slcan_bump_err(sl);
 	case 's':
-		return slc_bump_state(sl);
+		return slcan_bump_state(sl);
 	default:
 		return;
 	}
@@ -453,12 +454,12 @@ static void slcan_unesc(struct slcan *sl, unsigned char s)
 	if ((s == '\r') || (s == '\a')) { /* CR or BEL ends the pdu */
 		if (!test_and_clear_bit(SLF_ERROR, &sl->flags) &&
 		    sl->rcount > 4)
-			slc_bump(sl);
+			slcan_bump(sl);
 
 		sl->rcount = 0;
 	} else {
 		if (!test_bit(SLF_ERROR, &sl->flags))  {
-			if (sl->rcount < SLC_MTU)  {
+			if (sl->rcount < SLCAN_MTU)  {
 				sl->rbuff[sl->rcount++] = s;
 				return;
 			}
@@ -474,7 +475,7 @@ static void slcan_unesc(struct slcan *sl, unsigned char s)
  *************************************************************************/
 
 /* Encapsulate one can_frame and stuff into a TTY queue. */
-static void slc_encaps(struct slcan *sl, struct can_frame *cf)
+static void slcan_encaps(struct slcan *sl, struct can_frame *cf)
 {
 	int actual, i;
 	unsigned char *pos;
@@ -491,11 +492,11 @@ static void slc_encaps(struct slcan *sl, struct can_frame *cf)
 	/* determine number of chars for the CAN-identifier */
 	if (cf->can_id & CAN_EFF_FLAG) {
 		id &= CAN_EFF_MASK;
-		endpos = pos + SLC_EFF_ID_LEN;
+		endpos = pos + SLCAN_EFF_ID_LEN;
 	} else {
 		*pos |= 0x20; /* convert R/T to lower case for SFF */
 		id &= CAN_SFF_MASK;
-		endpos = pos + SLC_SFF_ID_LEN;
+		endpos = pos + SLCAN_SFF_ID_LEN;
 	}
 
 	/* build 3 (SFF) or 8 (EFF) digit CAN identifier */
@@ -505,7 +506,8 @@ static void slc_encaps(struct slcan *sl, struct can_frame *cf)
 		id >>= 4;
 	}
 
-	pos += (cf->can_id & CAN_EFF_FLAG) ? SLC_EFF_ID_LEN : SLC_SFF_ID_LEN;
+	pos += (cf->can_id & CAN_EFF_FLAG) ?
+		SLCAN_EFF_ID_LEN : SLCAN_SFF_ID_LEN;
 
 	*pos++ = cf->len + '0';
 
@@ -583,7 +585,8 @@ static void slcan_write_wakeup(struct tty_struct *tty)
 }
 
 /* Send a can_frame to a TTY queue. */
-static netdev_tx_t slc_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t slcan_netdev_xmit(struct sk_buff *skb,
+				     struct net_device *dev)
 {
 	struct slcan *sl = netdev_priv(dev);
 
@@ -602,7 +605,7 @@ static netdev_tx_t slc_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	netif_stop_queue(sl->dev);
-	slc_encaps(sl, (struct can_frame *)skb->data); /* encaps & send */
+	slcan_encaps(sl, (struct can_frame *)skb->data); /* encaps & send */
 	spin_unlock(&sl->lock);
 
 out:
@@ -645,7 +648,7 @@ static int slcan_transmit_cmd(struct slcan *sl, const unsigned char *cmd)
 }
 
 /* Netdevice UP -> DOWN routine */
-static int slc_close(struct net_device *dev)
+static int slcan_netdev_close(struct net_device *dev)
 {
 	struct slcan *sl = netdev_priv(dev);
 	int err;
@@ -674,10 +677,10 @@ static int slc_close(struct net_device *dev)
 }
 
 /* Netdevice DOWN -> UP routine */
-static int slc_open(struct net_device *dev)
+static int slcan_netdev_open(struct net_device *dev)
 {
 	struct slcan *sl = netdev_priv(dev);
-	unsigned char cmd[SLC_MTU];
+	unsigned char cmd[SLCAN_MTU];
 	int err, s;
 
 	/* The baud rate is not set with the command
@@ -737,16 +740,16 @@ static int slc_open(struct net_device *dev)
 	return err;
 }
 
-static int slcan_change_mtu(struct net_device *dev, int new_mtu)
+static int slcan_netdev_change_mtu(struct net_device *dev, int new_mtu)
 {
 	return -EINVAL;
 }
 
-static const struct net_device_ops slc_netdev_ops = {
-	.ndo_open               = slc_open,
-	.ndo_stop               = slc_close,
-	.ndo_start_xmit         = slc_xmit,
-	.ndo_change_mtu         = slcan_change_mtu,
+static const struct net_device_ops slcan_netdev_ops = {
+	.ndo_open               = slcan_netdev_open,
+	.ndo_stop               = slcan_netdev_close,
+	.ndo_start_xmit         = slcan_netdev_xmit,
+	.ndo_change_mtu         = slcan_netdev_change_mtu,
 };
 
 /******************************************
@@ -819,7 +822,7 @@ static int slcan_open(struct tty_struct *tty)
 
 	/* Configure netdev interface */
 	sl->dev	= dev;
-	dev->netdev_ops = &slc_netdev_ops;
+	dev->netdev_ops = &slcan_netdev_ops;
 	slcan_set_ethtool_ops(dev);
 
 	/* Mark ldisc channel as alive */
@@ -887,7 +890,7 @@ static int slcan_ioctl(struct tty_struct *tty, unsigned int cmd,
 	}
 }
 
-static struct tty_ldisc_ops slc_ldisc = {
+static struct tty_ldisc_ops slcan_ldisc = {
 	.owner		= THIS_MODULE,
 	.num		= N_SLCAN,
 	.name		= "slcan",
@@ -905,7 +908,7 @@ static int __init slcan_init(void)
 	pr_info("slcan: serial line CAN interface driver\n");
 
 	/* Fill in our line protocol discipline, and register it */
-	status = tty_register_ldisc(&slc_ldisc);
+	status = tty_register_ldisc(&slcan_ldisc);
 	if (status)
 		pr_err("slcan: can't register line discipline\n");
 
@@ -917,7 +920,7 @@ static void __exit slcan_exit(void)
 	/* This will only be called when all channels have been closed by
 	 * userspace - tty_ldisc.c takes care of the module's refcount.
 	 */
-	tty_unregister_ldisc(&slc_ldisc);
+	tty_unregister_ldisc(&slcan_ldisc);
 }
 
 module_init(slcan_init);
-- 
2.32.0

