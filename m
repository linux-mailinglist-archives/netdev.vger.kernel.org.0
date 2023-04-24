Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B78C6ED57F
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 21:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbjDXTsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 15:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232193AbjDXTsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 15:48:12 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D84575B8C
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 12:48:10 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pr2AT-0005XF-7g
        for netdev@vger.kernel.org; Mon, 24 Apr 2023 21:48:09 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 9B37E1B65D7
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 19:48:08 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 1451D1B65C6;
        Mon, 24 Apr 2023 19:48:04 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 915ffa8e;
        Mon, 24 Apr 2023 19:48:03 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Mikhail Golubev-Ciuchea <Mikhail.Golubev-Ciuchea@opensynergy.com>
Cc:     virtio-dev@lists.oasis-open.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Harald Mommer <harald.mommer@opensynergy.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH] can: virtio-can: cleanups
Date:   Mon, 24 Apr 2023 21:47:58 +0200
Message-Id: <20230424-modular-rebate-e54ac16374c8-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
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

Address the topics raised in

https://lore.kernel.org/20230424-footwear-daily-9339bd0ec428-mkl@pengutronix.de

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/Makefile        |  4 +--
 drivers/net/can/virtio_can.c    | 56 ++++++++++++++-------------------
 include/uapi/linux/virtio_can.h |  4 +--
 3 files changed, 28 insertions(+), 36 deletions(-)

diff --git a/drivers/net/can/Makefile b/drivers/net/can/Makefile
index e409f61d8e93..19314adaff59 100644
--- a/drivers/net/can/Makefile
+++ b/drivers/net/can/Makefile
@@ -17,8 +17,8 @@ obj-$(CONFIG_CAN_AT91)		+= at91_can.o
 obj-$(CONFIG_CAN_BXCAN)		+= bxcan.o
 obj-$(CONFIG_CAN_CAN327)	+= can327.o
 obj-$(CONFIG_CAN_CC770)		+= cc770/
-obj-$(CONFIG_CAN_C_CAN)		+= c_can/
 obj-$(CONFIG_CAN_CTUCANFD)	+= ctucanfd/
+obj-$(CONFIG_CAN_C_CAN)		+= c_can/
 obj-$(CONFIG_CAN_FLEXCAN)	+= flexcan/
 obj-$(CONFIG_CAN_GRCAN)		+= grcan.o
 obj-$(CONFIG_CAN_IFI_CANFD)	+= ifi_canfd/
@@ -30,7 +30,7 @@ obj-$(CONFIG_CAN_PEAK_PCIEFD)	+= peak_canfd/
 obj-$(CONFIG_CAN_SJA1000)	+= sja1000/
 obj-$(CONFIG_CAN_SUN4I)		+= sun4i_can.o
 obj-$(CONFIG_CAN_TI_HECC)	+= ti_hecc.o
-obj-$(CONFIG_CAN_XILINXCAN)	+= xilinx_can.o
 obj-$(CONFIG_CAN_VIRTIO_CAN)	+= virtio_can.o
+obj-$(CONFIG_CAN_XILINXCAN)	+= xilinx_can.o
 
 subdir-ccflags-$(CONFIG_CAN_DEBUG_DEVICES) += -DDEBUG
diff --git a/drivers/net/can/virtio_can.c b/drivers/net/can/virtio_can.c
index 23f9c1b6446d..c11a652613d0 100644
--- a/drivers/net/can/virtio_can.c
+++ b/drivers/net/can/virtio_can.c
@@ -312,13 +312,12 @@ static netdev_tx_t virtio_can_start_xmit(struct sk_buff *skb,
 	struct scatterlist sg_in[1];
 	struct scatterlist *sgs[2];
 	unsigned long flags;
-	size_t len;
 	u32 can_flags;
 	int err;
 	netdev_tx_t xmit_ret = NETDEV_TX_OK;
 	const unsigned int hdr_size = offsetof(struct virtio_can_tx_out, sdu);
 
-	if (can_dropped_invalid_skb(dev, skb))
+	if (can_dev_dropped_skb(dev, skb))
 		goto kick; /* No way to return NET_XMIT_DROP here */
 
 	/* Virtio CAN does not support error message frames */
@@ -338,27 +337,25 @@ static netdev_tx_t virtio_can_start_xmit(struct sk_buff *skb,
 
 	can_tx_msg->tx_out.msg_type = cpu_to_le16(VIRTIO_CAN_TX);
 	can_flags = 0;
-	if (cf->can_id & CAN_EFF_FLAG)
+
+	if (cf->can_id & CAN_EFF_FLAG) {
 		can_flags |= VIRTIO_CAN_FLAGS_EXTENDED;
+		can_tx_msg->tx_out.can_id = cpu_to_le32(cf->can_id & CAN_EFF_MASK);
+	} else {
+		can_tx_msg->tx_out.can_id = cpu_to_le32(cf->can_id & CAN_SFF_MASK);
+	}
 	if (cf->can_id & CAN_RTR_FLAG)
 		can_flags |= VIRTIO_CAN_FLAGS_RTR;
+	else
+		memcpy(can_tx_msg->tx_out.sdu, cf->data, cf->len);
 	if (can_is_canfd_skb(skb))
 		can_flags |= VIRTIO_CAN_FLAGS_FD;
+
 	can_tx_msg->tx_out.flags = cpu_to_le32(can_flags);
-	can_tx_msg->tx_out.can_id = cpu_to_le32(cf->can_id & CAN_EFF_MASK);
-	len = cf->len;
-	can_tx_msg->tx_out.length = len;
-	if (len > sizeof(cf->data))
-		len = sizeof(cf->data);
-	if (len > sizeof(can_tx_msg->tx_out.sdu))
-		len = sizeof(can_tx_msg->tx_out.sdu);
-	if (!(can_flags & VIRTIO_CAN_FLAGS_RTR)) {
-		/* Copy if not a RTR frame. RTR frames have a DLC but no payload */
-		memcpy(can_tx_msg->tx_out.sdu, cf->data, len);
-	}
+	can_tx_msg->tx_out.length = cpu_to_le16(cf->len);
 
 	/* Prepare sending of virtio message */
-	sg_init_one(&sg_out[0], &can_tx_msg->tx_out, hdr_size + len);
+	sg_init_one(&sg_out[0], &can_tx_msg->tx_out, hdr_size + cf->len);
 	sg_init_one(&sg_in[0], &can_tx_msg->tx_in, sizeof(can_tx_msg->tx_in));
 	sgs[0] = sg_out;
 	sgs[1] = sg_in;
@@ -895,8 +892,8 @@ static int virtio_can_probe(struct virtio_device *vdev)
 	priv->tx_putidx_list =
 		kcalloc(echo_skb_max, sizeof(struct list_head), GFP_KERNEL);
 	if (!priv->tx_putidx_list) {
-		free_candev(dev);
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto on_failure;
 	}
 
 	INIT_LIST_HEAD(&priv->tx_putidx_free);
@@ -914,7 +911,6 @@ static int virtio_can_probe(struct virtio_device *vdev)
 	vdev->priv = priv;
 
 	priv->can.do_set_mode = virtio_can_set_mode;
-	priv->can.state = CAN_STATE_STOPPED;
 	/* Set Virtio CAN supported operations */
 	priv->can.ctrlmode_supported = CAN_CTRLMODE_BERR_REPORTING;
 	if (virtio_has_feature(vdev, VIRTIO_CAN_F_CAN_FD)) {
@@ -968,11 +964,10 @@ static int virtio_can_probe(struct virtio_device *vdev)
 	return err;
 }
 
-#ifdef CONFIG_PM_SLEEP
 /* Compare with m_can.c/m_can_suspend(), virtio_net.c/virtnet_freeze() and
  * virtio_card.c/virtsnd_freeze()
  */
-static int virtio_can_freeze(struct virtio_device *vdev)
+static int __maybe_unused virtio_can_freeze(struct virtio_device *vdev)
 {
 	struct virtio_can_priv *priv = vdev->priv;
 	struct net_device *ndev = priv->dev;
@@ -996,7 +991,7 @@ static int virtio_can_freeze(struct virtio_device *vdev)
 /* Compare with m_can.c/m_can_resume(), virtio_net.c/virtnet_restore() and
  * virtio_card.c/virtsnd_restore()
  */
-static int virtio_can_restore(struct virtio_device *vdev)
+static int __maybe_unused virtio_can_restore(struct virtio_device *vdev)
 {
 	struct virtio_can_priv *priv = vdev->priv;
 	struct net_device *ndev = priv->dev;
@@ -1020,7 +1015,6 @@ static int virtio_can_restore(struct virtio_device *vdev)
 
 	return 0;
 }
-#endif /* #ifdef CONFIG_PM_SLEEP */
 
 static struct virtio_device_id virtio_can_id_table[] = {
 	{ VIRTIO_ID_CAN, VIRTIO_DEV_ANY_ID },
@@ -1037,18 +1031,16 @@ static unsigned int features[] = {
 static struct virtio_driver virtio_can_driver = {
 	.feature_table = features,
 	.feature_table_size = ARRAY_SIZE(features),
-	.feature_table_legacy = NULL,
-	.feature_table_size_legacy = 0,
-	.driver.name =	KBUILD_MODNAME,
-	.driver.owner =	THIS_MODULE,
-	.id_table =	virtio_can_id_table,
-	.validate =	virtio_can_validate,
-	.probe =	virtio_can_probe,
-	.remove =	virtio_can_remove,
+	.driver.name = KBUILD_MODNAME,
+	.driver.owner = THIS_MODULE,
+	.id_table = virtio_can_id_table,
+	.validate = virtio_can_validate,
+	.probe = virtio_can_probe,
+	.remove = virtio_can_remove,
 	.config_changed = virtio_can_config_changed,
 #ifdef CONFIG_PM_SLEEP
-	.freeze =	virtio_can_freeze,
-	.restore =	virtio_can_restore,
+	.freeze = virtio_can_freeze,
+	.restore = virtio_can_restore,
 #endif
 };
 
diff --git a/include/uapi/linux/virtio_can.h b/include/uapi/linux/virtio_can.h
index de85918aa7dc..f59a2ca6ebd1 100644
--- a/include/uapi/linux/virtio_can.h
+++ b/include/uapi/linux/virtio_can.h
@@ -35,7 +35,7 @@ struct virtio_can_config {
 struct virtio_can_tx_out {
 #define VIRTIO_CAN_TX                   0x0001
 	__le16 msg_type;
-	__le16 length; /* 0..8 CC, 0..64 CAN­FD, 0..2048 CAN­XL, 12 bits */
+	__le16 length; /* 0..8 CC, 0..64 CAN-FD, 0..2048 CAN-XL, 12 bits */
 	__le32 reserved; /* May be needed in part for CAN XL priority */
 	__le32 flags;
 	__le32 can_id;
@@ -50,7 +50,7 @@ struct virtio_can_tx_in {
 struct virtio_can_rx {
 #define VIRTIO_CAN_RX                   0x0101
 	__le16 msg_type;
-	__le16 length; /* 0..8 CC, 0..64 CAN­FD, 0..2048 CAN­XL, 12 bits */
+	__le16 length; /* 0..8 CC, 0..64 CAN-FD, 0..2048 CAN-XL, 12 bits */
 	__le32 reserved; /* May be needed in part for CAN XL priority */
 	__le32 flags;
 	__le32 can_id;
-- 
2.39.2


