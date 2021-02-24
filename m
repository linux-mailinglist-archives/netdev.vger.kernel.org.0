Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1FA32473F
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 00:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236101AbhBXXAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 18:00:07 -0500
Received: from smtp-17-i2.italiaonline.it ([213.209.12.17]:46390 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235610AbhBXXAA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 18:00:00 -0500
X-Greylist: delayed 317 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Feb 2021 17:59:58 EST
Received: from passgat-Modern-14-A10M.homenet.telecomitalia.it
 ([87.20.116.197])
        by smtp-17.iol.local with ESMTPA
        id F32VlxCf1lChfF32clf7XU; Wed, 24 Feb 2021 23:53:58 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1614207238; bh=BeCdNoYLzzsSi1xXt/5ym8W0XRYmG2SHNHbV3+iZ/L4=;
        h=From;
        b=B1MMcCGMdfQFRSyojCkxaYPaXa0kU1Y0vqmgFORx9VlTPcYcgtR28hU6jKHqs0lLq
         X8Rgz+NBhX7zLn/SUtu4WQchwQS4/hbt3h0rQWdpGyMzCM/c5fakKn2pxW2F1B7/9F
         wV2eWuU2snv9lO6i6qWpERp5Icoa/bjob3fy0mII3tZLI51688b35vT/KQyvEOuGD3
         JKmx60uGZ37w4q12npuwT9CJ2LvRzLrOvPeTSqCNlTQnPaVWbgIbBtQ9OyjFZLBvbb
         ZtMV8fuAfqogP+x5cnYN7fvFjDzd4R8OUzOt9cgs3zi7m/Jr2OGMpuyHZDU3gK35+T
         rH3WhHJ5tLc6w==
X-CNFS-Analysis: v=2.4 cv=S6McfKgP c=1 sm=1 tr=0 ts=6036d906 cx=a_exe
 a=AVqmXbCQpuNSdJmApS5GbQ==:117 a=AVqmXbCQpuNSdJmApS5GbQ==:17
 a=c_Wuppn-HkOMBcmLVEEA:9 a=ojz-B-aG2JS-tDbb:21 a=Khdy9WjuBuf2oBM2:21
From:   Dario Binacchi <dariobin@libero.it>
To:     linux-kernel@vger.kernel.org
Cc:     Dario Binacchi <dariobin@libero.it>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 5/6] can: c_can: prepare to up the message objects number
Date:   Wed, 24 Feb 2021 23:52:45 +0100
Message-Id: <20210224225246.11346-6-dariobin@libero.it>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210224225246.11346-1-dariobin@libero.it>
References: <20210224225246.11346-1-dariobin@libero.it>
X-CMAE-Envelope: MS4xfGsvJbAciFCjUGaugcCt8RndDS2Bmh1pSI6dw003dyaO0QJ+ba08ESK+hqXJyh0a33nywnbFAsMVxdOEewUalIRz6zKQaj6KJ0K6bT6vfjkHlCgloQjS
 KFxCvUcyQOicpsspdysJuLRtDVRswdsT6bfPKHUrhj1cfHtnRYWUzpcop0l8WMtIF/TMuwvQrRBJa7LuKkWGRYMN0yp9eqf6d9fHksRPlMY8COPgHSEH+s8U
 V9bzbogo3A4+Dm14qrpw7WpM/Fg7iyaFX97Q0z7Z9C30HxdWBgMmqkaFBh96QbcXcMhzTG+4qGt7DuvZorrJiYpRLRI17P2uo9qkt5H5r9zg+CRdJi4YTLav
 ATZ2ni/SYq9S9dSejN0hp+zpiDYXWjzMR2NIp2QjReNLu+8ZjUxiAv77oHI6zfSMBl66PEHrDZwucjZG27hqhS086i+ArCJH4s0z+ADL3E2gMt010fRjfB9r
 yTzuxpoIwWlsZFsAOp4SCtDWprft+WSm36AYjuTxkH9xJrnPa0L6umYZSyh3YSdD3yYvl/aTJby6iRdXWKYAuQpWmtR9XAJn0UJmjTy1b1JvKQru1vocAgn0
 U3wSuj9wSvoJqBmvaNyLuuIi
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As pointed by commit c0a9f4d396c9 ("can: c_can: Reduce register access")
the "driver casts the 16 message objects in stone, which is completely
braindead as contemporary hardware has up to 128 message objects".

The patch prepares the module to extend the number of message objects
beyond the 32 currently managed. This was achieved by transforming the
constants used to manage RX/TX messages into variables without changing
the driver policy.

Signed-off-by: Dario Binacchi <dariobin@libero.it>
---

 drivers/net/can/c_can/c_can.c          | 56 +++++++++++++++++---------
 drivers/net/can/c_can/c_can.h          | 23 +++++------
 drivers/net/can/c_can/c_can_platform.c |  2 +-
 3 files changed, 48 insertions(+), 33 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 7081cfaf62e2..772b26685fea 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -173,9 +173,6 @@
 /* Wait for ~1 sec for INIT bit */
 #define INIT_WAIT_MS		1000
 
-/* napi related */
-#define C_CAN_NAPI_WEIGHT	C_CAN_MSG_OBJ_RX_NUM
-
 /* c_can lec values */
 enum c_can_lec_type {
 	LEC_NO_ERROR = 0,
@@ -325,7 +322,7 @@ static void c_can_setup_tx_object(struct net_device *dev, int iface,
 	 * first, i.e. clear the MSGVAL flag in the arbiter.
 	 */
 	if (rtr != (bool)test_bit(idx, &priv->tx_dir)) {
-		u32 obj = idx + C_CAN_MSG_OBJ_TX_FIRST;
+		u32 obj = idx + priv->msg_obj_tx_first;
 
 		c_can_inval_msg_object(dev, iface, obj);
 		change_bit(idx, &priv->tx_dir);
@@ -463,10 +460,10 @@ static netdev_tx_t c_can_start_xmit(struct sk_buff *skb,
 	 * prioritized. The lowest buffer number wins.
 	 */
 	idx = fls(atomic_read(&priv->tx_active));
-	obj = idx + C_CAN_MSG_OBJ_TX_FIRST;
+	obj = idx + priv->msg_obj_tx_first;
 
 	/* If this is the last buffer, stop the xmit queue */
-	if (idx == C_CAN_MSG_OBJ_TX_NUM - 1)
+	if (idx == priv->msg_obj_tx_num - 1)
 		netif_stop_queue(dev);
 	/*
 	 * Store the message in the interface so we can call
@@ -549,17 +546,18 @@ static int c_can_set_bittiming(struct net_device *dev)
  */
 static void c_can_configure_msg_objects(struct net_device *dev)
 {
+	struct c_can_priv *priv = netdev_priv(dev);
 	int i;
 
 	/* first invalidate all message objects */
-	for (i = C_CAN_MSG_OBJ_RX_FIRST; i <= C_CAN_NO_OF_OBJECTS; i++)
+	for (i = priv->msg_obj_rx_first; i <= priv->msg_obj_num; i++)
 		c_can_inval_msg_object(dev, IF_RX, i);
 
 	/* setup receive message objects */
-	for (i = C_CAN_MSG_OBJ_RX_FIRST; i < C_CAN_MSG_OBJ_RX_LAST; i++)
+	for (i = priv->msg_obj_rx_first; i < priv->msg_obj_rx_last; i++)
 		c_can_setup_receive_object(dev, IF_RX, i, 0, 0, IF_MCONT_RCV);
 
-	c_can_setup_receive_object(dev, IF_RX, C_CAN_MSG_OBJ_RX_LAST, 0, 0,
+	c_can_setup_receive_object(dev, IF_RX, priv->msg_obj_rx_last, 0, 0,
 				   IF_MCONT_RCV_EOB);
 }
 
@@ -730,7 +728,7 @@ static void c_can_do_tx(struct net_device *dev)
 	while ((idx = ffs(pend))) {
 		idx--;
 		pend &= ~(1 << idx);
-		obj = idx + C_CAN_MSG_OBJ_TX_FIRST;
+		obj = idx + priv->msg_obj_tx_first;
 		c_can_inval_tx_object(dev, IF_TX, obj);
 		can_get_echo_skb(dev, idx, NULL);
 		bytes += priv->dlc[idx];
@@ -740,7 +738,7 @@ static void c_can_do_tx(struct net_device *dev)
 	/* Clear the bits in the tx_active mask */
 	atomic_sub(clr, &priv->tx_active);
 
-	if (clr & (1 << (C_CAN_MSG_OBJ_TX_NUM - 1)))
+	if (clr & (1 << (priv->msg_obj_tx_num - 1)))
 		netif_wake_queue(dev);
 
 	if (pkts) {
@@ -755,11 +753,11 @@ static void c_can_do_tx(struct net_device *dev)
  * raced with the hardware or failed to readout all upper
  * objects in the last run due to quota limit.
  */
-static u32 c_can_adjust_pending(u32 pend)
+static u32 c_can_adjust_pending(u32 pend, u32 rx_mask)
 {
 	u32 weight, lasts;
 
-	if (pend == RECEIVE_OBJECT_BITS)
+	if (pend == rx_mask)
 		return pend;
 
 	/*
@@ -862,8 +860,7 @@ static int c_can_do_rx_poll(struct net_device *dev, int quota)
 	 * It is faster to read only one 16bit register. This is only possible
 	 * for a maximum number of 16 objects.
 	 */
-	BUILD_BUG_ON_MSG(C_CAN_MSG_OBJ_RX_LAST > 16,
-			"Implementation does not support more message objects than 16");
+	WARN_ON(priv->msg_obj_rx_last > 16);
 
 	while (quota > 0) {
 		if (!pend) {
@@ -874,7 +871,8 @@ static int c_can_do_rx_poll(struct net_device *dev, int quota)
 			 * If the pending field has a gap, handle the
 			 * bits above the gap first.
 			 */
-			toread = c_can_adjust_pending(pend);
+			toread = c_can_adjust_pending(pend,
+						      priv->msg_obj_rx_mask);
 		} else {
 			toread = pend;
 		}
@@ -1205,17 +1203,36 @@ static int c_can_close(struct net_device *dev)
 	return 0;
 }
 
-struct net_device *alloc_c_can_dev(void)
+struct net_device *alloc_c_can_dev(int msg_obj_num)
 {
 	struct net_device *dev;
 	struct c_can_priv *priv;
+	int msg_obj_tx_num = msg_obj_num / 2;
 
-	dev = alloc_candev(sizeof(struct c_can_priv), C_CAN_MSG_OBJ_TX_NUM);
+	dev = alloc_candev(sizeof(struct c_can_priv), msg_obj_tx_num);
 	if (!dev)
 		return NULL;
 
 	priv = netdev_priv(dev);
-	netif_napi_add(dev, &priv->napi, c_can_poll, C_CAN_NAPI_WEIGHT);
+	priv->msg_obj_num = msg_obj_num;
+	priv->msg_obj_rx_num = msg_obj_num - msg_obj_tx_num;
+	priv->msg_obj_rx_first = 1;
+	priv->msg_obj_rx_last =
+		priv->msg_obj_rx_first + priv->msg_obj_rx_num - 1;
+	priv->msg_obj_rx_mask = ((u64)1 << priv->msg_obj_rx_num) - 1;
+
+	priv->msg_obj_tx_num = msg_obj_tx_num;
+	priv->msg_obj_tx_first = priv->msg_obj_rx_last + 1;
+	priv->msg_obj_tx_last =
+		priv->msg_obj_tx_first + priv->msg_obj_tx_num - 1;
+
+	priv->dlc = kcalloc(msg_obj_tx_num, sizeof(*priv->dlc), GFP_KERNEL);
+	if (!priv->dlc) {
+		free_candev(dev);
+		return NULL;
+	}
+
+	netif_napi_add(dev, &priv->napi, c_can_poll, priv->msg_obj_rx_num);
 
 	priv->dev = dev;
 	priv->can.bittiming_const = &c_can_bittiming_const;
@@ -1320,6 +1337,7 @@ void free_c_can_dev(struct net_device *dev)
 	struct c_can_priv *priv = netdev_priv(dev);
 
 	netif_napi_del(&priv->napi);
+	kfree(priv->dlc);
 	free_candev(dev);
 }
 EXPORT_SYMBOL_GPL(free_c_can_dev);
diff --git a/drivers/net/can/c_can/c_can.h b/drivers/net/can/c_can/c_can.h
index 90d3d2e7a086..1dbe777320f5 100644
--- a/drivers/net/can/c_can/c_can.h
+++ b/drivers/net/can/c_can/c_can.h
@@ -22,18 +22,7 @@
 #ifndef C_CAN_H
 #define C_CAN_H
 
-/* message object split */
 #define C_CAN_NO_OF_OBJECTS	32
-#define C_CAN_MSG_OBJ_RX_NUM	16
-#define C_CAN_MSG_OBJ_TX_NUM	16
-
-#define C_CAN_MSG_OBJ_RX_FIRST	1
-#define C_CAN_MSG_OBJ_RX_LAST	(C_CAN_MSG_OBJ_RX_FIRST + \
-				C_CAN_MSG_OBJ_RX_NUM - 1)
-
-#define C_CAN_MSG_OBJ_TX_FIRST	(C_CAN_MSG_OBJ_RX_LAST + 1)
-
-#define RECEIVE_OBJECT_BITS	0x0000ffff
 
 enum reg {
 	C_CAN_CTRL_REG = 0,
@@ -193,6 +182,14 @@ struct c_can_priv {
 	struct napi_struct napi;
 	struct net_device *dev;
 	struct device *device;
+	int msg_obj_num;
+	int msg_obj_rx_num;
+	int msg_obj_tx_num;
+	int msg_obj_rx_first;
+	int msg_obj_rx_last;
+	int msg_obj_tx_first;
+	int msg_obj_tx_last;
+	u32 msg_obj_rx_mask;
 	atomic_t tx_active;
 	atomic_t sie_pending;
 	unsigned long tx_dir;
@@ -209,10 +206,10 @@ struct c_can_priv {
 	void (*raminit) (const struct c_can_priv *priv, bool enable);
 	u32 comm_rcv_high;
 	u32 rxmasked;
-	u32 dlc[C_CAN_MSG_OBJ_TX_NUM];
+	u32 *dlc;
 };
 
-struct net_device *alloc_c_can_dev(void);
+struct net_device *alloc_c_can_dev(int msg_obj_num);
 void free_c_can_dev(struct net_device *dev);
 int register_c_can_dev(struct net_device *dev);
 void unregister_c_can_dev(struct net_device *dev);
diff --git a/drivers/net/can/c_can/c_can_platform.c b/drivers/net/can/c_can/c_can_platform.c
index 05f425ceb53a..a5b9b1a93702 100644
--- a/drivers/net/can/c_can/c_can_platform.c
+++ b/drivers/net/can/c_can/c_can_platform.c
@@ -293,7 +293,7 @@ static int c_can_plat_probe(struct platform_device *pdev)
 	}
 
 	/* allocate the c_can device */
-	dev = alloc_c_can_dev();
+	dev = alloc_c_can_dev(C_CAN_NO_OF_OBJECTS);
 	if (!dev) {
 		ret = -ENOMEM;
 		goto exit;
-- 
2.17.1

