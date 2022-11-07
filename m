Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF0461EB5B
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 08:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbiKGHJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 02:09:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbiKGHJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 02:09:34 -0500
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C15C45F4C;
        Sun,  6 Nov 2022 23:09:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1667804971; x=1699340971;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sGH7DRL76esxN72YfBedeqVfnpLfcO4S2w4cx00Dbe0=;
  b=QY1XMLRG85R/8yi11mqMrIq0wpBp1SRe/y/NihWOdThU+L/M06iWmXNz
   n5ZKrzbGT9K+DFVK+9lgGiImXuZ/n0bDneoSQhe/IJM2XGhGDsLph/NLC
   CAp9l9O0Nts57/oMnw2tYQ531Ex33yQi9OMb23Yw+BmRy9WfiyAoBfD6C
   M5qx2yogjPfd/3bE0toWDvMtUmcEVKKxgkjqoffgY1W0zNIhUVoho/ODN
   GMnJSaXUE3gWHo3WpxC+3YF/GJUF6z16Y7c6jY6DFlUQujTH65US/rxRp
   hbCPclSSkeusVc9C4w0SwNA7XSVo+DwbQtoZAvx1Lb+uiz9nMO9UdgM0n
   A==;
X-IronPort-AV: E=Sophos;i="5.96,143,1665439200"; 
   d="scan'208";a="27184709"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 07 Nov 2022 08:09:28 +0100
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Mon, 07 Nov 2022 08:09:28 +0100
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Mon, 07 Nov 2022 08:09:28 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1667804968; x=1699340968;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sGH7DRL76esxN72YfBedeqVfnpLfcO4S2w4cx00Dbe0=;
  b=lSyWCP/UXI/M3opyr84oTC5sLlyr7xv8sSGXfrVtGWfT9Wca8XHKLimU
   Y3KHgzVgy3YaEaneYGCDQJmVl/rzMYjACI1WUsX/e1dKpf9lvHSi2XlUC
   Bn63p5iVHYXOy8j1vbPQLjrEy6qwjEgXkLdAz8pNgTTzF1FtFJiwif9Er
   w8cacNS7oFWpsgHOy2tzwTcHu8vEM5r8FPmN55ie1NJ9JiyfQyX1LHdrZ
   53FjFLyTqPJIf1uxKxoWx6znYAvQUoFe4Jcxl/RftZmTDBUe85nBrMN0V
   qBMy2u/4rYQmm/GGxQsIIMwlcmQuKIw+neAwCXy3V9C+L8Kx7tJqdy3qI
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,143,1665439200"; 
   d="scan'208";a="27184708"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 07 Nov 2022 08:09:28 +0100
Received: from steina-w.localnet (unknown [10.123.53.21])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id 0D166280056;
        Mon,  7 Nov 2022 08:09:28 +0100 (CET)
From:   Alexander Stein <alexander.stein@ew.tq-group.com>
To:     virtio-dev@lists.oasis-open.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harald Mommer <Harald.Mommer@opensynergy.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dariusz Stojaczyk <Dariusz.Stojaczyk@opensynergy.com>,
        Harald Mommer <harald.mommer@opensynergy.com>,
        Harald Mommer <Harald.Mommer@opensynergy.com>,
        Damir Shaikhutdinov <Damir.Shaikhutdinov@opensynergy.com>
Subject: Re: [RFC PATCH v2 1/2] can: virtio: Initial virtio CAN driver.
Date:   Mon, 07 Nov 2022 08:09:23 +0100
Message-ID: <4782632.31r3eYUQgx@steina-w>
Organization: TQ-Systems GmbH
In-Reply-To: <20221104172421.8271-2-Harald.Mommer@opensynergy.com>
References: <20221104172421.8271-1-Harald.Mommer@opensynergy.com> <20221104172421.8271-2-Harald.Mommer@opensynergy.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Freitag, 4. November 2022, 18:24:20 CET schrieb Harald Mommer:
> From: Harald Mommer <harald.mommer@opensynergy.com>
> 
> - CAN Control
> 
>   - "ip link set up can0" starts the virtual CAN controller,
>   - "ip link set up can0" stops the virtual CAN controller
> 
> - CAN RX
> 
>   Receive CAN frames. CAN frames can be standard or extended, classic or
>   CAN FD. Classic CAN RTR frames are supported.
> 
> - CAN TX
> 
>   Send CAN frames. CAN frames can be standard or extended, classic or
>   CAN FD. Classic CAN RTR frames are supported.
> 
> - CAN Event indication (BusOff)
> 
>   The bus off handling is considered code complete but until now bus off
>   handling is largely untested.
> 
> This is version 2 of the driver after having gotten review comments.
> 
> Signed-off-by: Harald Mommer <Harald.Mommer@opensynergy.com>
> Cc: Damir Shaikhutdinov <Damir.Shaikhutdinov@opensynergy.com>
> ---
>  drivers/net/can/Kconfig         |   12 +
>  drivers/net/can/Makefile        |    1 +
>  drivers/net/can/virtio_can.c    | 1110 +++++++++++++++++++++++++++++++
>  include/uapi/linux/virtio_can.h |   69 ++
>  4 files changed, 1192 insertions(+)
>  create mode 100644 drivers/net/can/virtio_can.c
>  create mode 100644 include/uapi/linux/virtio_can.h
> 
> diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
> index 3048ad77edb3..c913a2fb1b9a 100644
> --- a/drivers/net/can/Kconfig
> +++ b/drivers/net/can/Kconfig
> @@ -206,6 +206,18 @@ config PCH_CAN
>  	  is an IOH for x86 embedded processor (Intel Atom E6xx series).
>  	  This driver can access CAN bus.
> 
> +config CAN_VIRTIO_CAN
> +	depends on VIRTIO
> +	tristate "Virtio CAN device support"
> +	default n
> +	help
> +	  Say Y here if you want to support for Virtio CAN.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called virtio-can.
> +
> +	  If unsure, say N.
> +
>  source "drivers/net/can/c_can/Kconfig"
>  source "drivers/net/can/cc770/Kconfig"
>  source "drivers/net/can/ctucanfd/Kconfig"
> diff --git a/drivers/net/can/Makefile b/drivers/net/can/Makefile
> index 61c75ce9d500..22b25a36827f 100644
> --- a/drivers/net/can/Makefile
> +++ b/drivers/net/can/Makefile
> @@ -31,5 +31,6 @@ obj-$(CONFIG_CAN_SUN4I)		+= sun4i_can.o
>  obj-$(CONFIG_CAN_TI_HECC)	+= ti_hecc.o
>  obj-$(CONFIG_CAN_XILINXCAN)	+= xilinx_can.o
>  obj-$(CONFIG_PCH_CAN)		+= pch_can.o
> +obj-$(CONFIG_CAN_VIRTIO_CAN)	+= virtio_can.o
> 
>  subdir-ccflags-$(CONFIG_CAN_DEBUG_DEVICES) += -DDEBUG
> diff --git a/drivers/net/can/virtio_can.c b/drivers/net/can/virtio_can.c
> new file mode 100644
> index 000000000000..43cf1c9e4afd
> --- /dev/null
> +++ b/drivers/net/can/virtio_can.c
> @@ -0,0 +1,1110 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * CAN bus driver for the Virtio CAN controller
> + * Copyright (C) 2021 OpenSynergy GmbH
> + */
> +
> +#include <linux/atomic.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/netdevice.h>
> +#include <linux/stddef.h>
> +#include <linux/can/dev.h>
> +#include <linux/virtio.h>
> +#include <linux/virtio_ring.h>
> +#include <linux/virtio_can.h>
> +
> +/* CAN device queues */
> +#define VIRTIO_CAN_QUEUE_TX 0u /* Driver side view! The device receives
> here */ +#define VIRTIO_CAN_QUEUE_RX 1u /* Driver side view! The device
> transmits here */ +#define VIRTIO_CAN_QUEUE_CONTROL 2u
> +#define VIRTIO_CAN_QUEUE_INDICATION 3u
> +#define VIRTIO_CAN_QUEUE_COUNT 4u
> +
> +#define CAN_KNOWN_FLAGS \
> +	(VIRTIO_CAN_FLAGS_EXTENDED |\
> +	 VIRTIO_CAN_FLAGS_FD |\
> +	 VIRTIO_CAN_FLAGS_RTR)
> +
> +/* CAN TX message priorities (0 = normal priority) */
> +#define VIRTIO_CAN_PRIO_COUNT 1
> +/* Max. nummber of in flight TX messages */
> +#define VIRTIO_CAN_ECHO_SKB_MAX 128u
> +
> +struct virtio_can_tx {
> +	struct list_head list;
> +	int prio; /* Currently always 0 "normal priority" */
> +	int putidx;
> +	struct virtio_can_tx_out tx_out;
> +	struct virtio_can_tx_in tx_in;
> +};
> +
> +/* virtio_can private data structure */
> +struct virtio_can_priv {
> +	struct can_priv can;	/* must be the first member */
> +	/* NAPI for RX messages */
> +	struct napi_struct napi;
> +	/* NAPI for TX messages */
> +	struct napi_struct napi_tx;
> +	/* The network device we're associated with */
> +	struct net_device *dev;
> +	/* The virtio device we're associated with */
> +	struct virtio_device *vdev;
> +	/* The virtqueues */
> +	struct virtqueue *vqs[VIRTIO_CAN_QUEUE_COUNT];
> +	/* I/O callback function pointers for the virtqueues */
> +	vq_callback_t *io_callbacks[VIRTIO_CAN_QUEUE_COUNT];
> +	/* Lock for TX operations */
> +	spinlock_t tx_lock;
> +	/* Control queue lock. Defensive programming, may be not needed */
> +	struct mutex ctrl_lock;
> +	/* Wait for control queue processing without polling */
> +	struct completion ctrl_done;
> +	/* List of virtio CAN TX message */
> +	struct list_head tx_list;
> +	/* Array of receive queue messages */
> +	struct virtio_can_rx rpkt[128u];
> +	/* Those control queue messages cannot live on the stack! */
> +	struct virtio_can_control_out cpkt_out;
> +	struct virtio_can_control_in cpkt_in;
> +	/* Indication queue message */
> +	struct virtio_can_event_ind ipkt[1u];
> +	/* Data to get and maintain the putidx for local TX echo */
> +	struct list_head tx_putidx_free;
> +	struct list_head *tx_putidx_list;
> +	/* In flight TX messages per prio */
> +	atomic_t tx_inflight[VIRTIO_CAN_PRIO_COUNT];
> +	/* Max. In flight TX messages per prio */
> +	u16 tx_limit[VIRTIO_CAN_PRIO_COUNT];
> +	/* BusOff pending. Reset after successful indication to upper layer 
*/
> +	bool busoff_pending;
> +};
> +
> +/* Function copied from virtio_net.c */
> +static void virtqueue_napi_schedule(struct napi_struct *napi,
> +				    struct virtqueue *vq)
> +{
> +	if (napi_schedule_prep(napi)) {
> +		virtqueue_disable_cb(vq);
> +		__napi_schedule(napi);
> +	}
> +}
> +
> +/* Function copied from virtio_net.c */
> +static void virtqueue_napi_complete(struct napi_struct *napi,
> +				    struct virtqueue *vq, int 
processed)
> +{
> +	int opaque;
> +
> +	opaque = virtqueue_enable_cb_prepare(vq);
> +	if (napi_complete_done(napi, processed)) {
> +		if (unlikely(virtqueue_poll(vq, opaque)))
> +			virtqueue_napi_schedule(napi, vq);
> +	} else {
> +		virtqueue_disable_cb(vq);
> +	}
> +}
> +
> +static void virtio_can_free_candev(struct net_device *ndev)
> +{
> +	struct virtio_can_priv *priv = netdev_priv(ndev);
> +
> +	kfree(priv->tx_putidx_list);
> +	free_candev(ndev);
> +}
> +
> +static int virtio_can_alloc_tx_idx(struct virtio_can_priv *priv, int prio)
> +{
> +	struct list_head *entry;
> +
> +	BUG_ON(prio != 0); /* Currently only 1 priority */
> +	BUG_ON(atomic_read(&priv->tx_inflight[0]) >= priv-
>can.echo_skb_max);
> +	atomic_add(1, &priv->tx_inflight[prio]);
> +
> +	if (list_empty(&priv->tx_putidx_free))
> +		return -1; /* Not expected to happen */
> +
> +	entry = priv->tx_putidx_free.next;
> +	list_del(entry);
> +
> +	return entry - priv->tx_putidx_list;
> +}
> +
> +static void virtio_can_free_tx_idx(struct virtio_can_priv *priv, int prio,
> +				   int idx)
> +{
> +	BUG_ON(prio >= VIRTIO_CAN_PRIO_COUNT);
> +	BUG_ON(idx >= priv->can.echo_skb_max);
> +	BUG_ON(atomic_read(&priv->tx_inflight[prio]) == 0);
> +
> +	list_add(&priv->tx_putidx_list[idx], &priv->tx_putidx_free);
> +	atomic_sub(1, &priv->tx_inflight[prio]);
> +}
> +
> +/* Create a scatter-gather list representing our input buffer and put
> + * it in the queue.
> + *
> + * Callers should take appropriate locks.
> + */
> +static int virtio_can_add_inbuf(struct virtqueue *vq, void *buf,
> +				unsigned int size)
> +{
> +	struct scatterlist sg[1];
> +	int ret;
> +
> +	sg_init_one(sg, buf, size);
> +
> +	ret = virtqueue_add_inbuf(vq, sg, 1, buf, GFP_ATOMIC);
> +	virtqueue_kick(vq);
> +	if (ret == 0)
> +		ret = vq->num_free;
> +	return ret;
> +}
> +
> +/* Send a control message with message type either
> + *
> + * - VIRTIO_CAN_SET_CTRL_MODE_START or
> + * - VIRTIO_CAN_SET_CTRL_MODE_STOP.
> + *
> + * Unlike AUTOSAR CAN Driver Can_SetControllerMode() there is no
> requirement + * for this Linux driver to have an asynchronous
> implementation of the mode + * setting function so in order to keep things
> simple the function is + * implemented as synchronous function. Design
> pattern is
> + * virtio_console.c/__send_control_msg() &
> virtio_net.c/virtnet_send_command(). + */
> +static u8 virtio_can_send_ctrl_msg(struct net_device *ndev, u16 msg_type)
> +{
> +	struct virtio_can_priv *priv = netdev_priv(ndev);
> +	struct device *dev = &priv->vdev->dev;
> +	struct virtqueue *vq = priv->vqs[VIRTIO_CAN_QUEUE_CONTROL];
> +	struct scatterlist sg_out[1u];
> +	struct scatterlist sg_in[1u];
> +	struct scatterlist *sgs[2u];
> +	int err;
> +	unsigned int len;
> +
> +	/* The function may be serialized by rtnl lock. Not sure.
> +	 * Better safe than sorry.
> +	 */
> +	mutex_lock(&priv->ctrl_lock);
> +
> +	priv->cpkt_out.msg_type = cpu_to_le16(msg_type);
> +	sg_init_one(&sg_out[0], &priv->cpkt_out, sizeof(priv->cpkt_out));
> +	sg_init_one(&sg_in[0], &priv->cpkt_in, sizeof(priv->cpkt_in));
> +	sgs[0] = sg_out;
> +	sgs[1] = sg_in;
> +
> +	err = virtqueue_add_sgs(vq, sgs, 1u, 1u, priv, GFP_ATOMIC);
> +	if (err != 0) {
> +		/* Not expected to happen */
> +		dev_err(dev, "%s(): virtqueue_add_sgs() failed\n", 
__func__);
> +	}
> +
> +	if (!virtqueue_kick(vq)) {
> +		/* Not expected to happen */
> +		dev_err(dev, "%s(): Kick failed\n", __func__);
> +	}
> +
> +	while (!virtqueue_get_buf(vq, &len) && !virtqueue_is_broken(vq))
> +		wait_for_completion(&priv->ctrl_done);
> +
> +	mutex_unlock(&priv->ctrl_lock);
> +
> +	return priv->cpkt_in.result;
> +}
> +
> +static void virtio_can_start(struct net_device *ndev)
> +{
> +	struct virtio_can_priv *priv = netdev_priv(ndev);
> +	u8 result;
> +
> +	result = virtio_can_send_ctrl_msg(ndev, 
VIRTIO_CAN_SET_CTRL_MODE_START);
> +	if (result != VIRTIO_CAN_RESULT_OK) {
> +		/* Not expected to happen */
> +		netdev_err(ndev, "CAN controller start failed\n");
> +	}
> +
> +	priv->busoff_pending = false;
> +	priv->can.state = CAN_STATE_ERROR_ACTIVE;
> +
> +	/* Switch carrier on if device was not connected to the bus */
> +	if (!netif_carrier_ok(ndev))
> +		netif_carrier_on(ndev);
> +}
> +
> +/* See also m_can.c/m_can_set_mode()
> + *
> + * It is interesting that not only the M-CAN implementation but also all
> other + * implementations I looked into only support CAN_MODE_START.
> + * That CAN_MODE_SLEEP is frequently not found to be supported anywhere did
> not + * come not as surprise but that CAN_MODE_STOP is also never supported
> was one. + * The function is accessible via the method pointer do_set_mode
> in + * struct can_priv. As ususal no documentation there.
> + * May not play any role as grepping through the code did not reveal any
> place + * from where the method is actually called.
> + */
> +static int virtio_can_set_mode(struct net_device *dev, enum can_mode mode)
> +{
> +	switch (mode) {
> +	case CAN_MODE_START:
> +		virtio_can_start(dev);
> +		netif_wake_queue(dev);
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return 0;
> +}
> +
> +/* Called by issuing "ip link set up can0" */
> +static int virtio_can_open(struct net_device *dev)
> +{
> +	/* start the virtio_can controller */
> +	virtio_can_start(dev);
> +
> +	/* RX and TX napi were already enabled in virtio_can_probe() */
> +	netif_start_queue(dev);
> +
> +	return 0;
> +}
> +
> +static void virtio_can_stop(struct net_device *ndev)
> +{
> +	struct virtio_can_priv *priv = netdev_priv(ndev);
> +	struct device *dev = &priv->vdev->dev;
> +	u8 result;
> +
> +	result = virtio_can_send_ctrl_msg(ndev, 
VIRTIO_CAN_SET_CTRL_MODE_STOP);
> +	if (result != VIRTIO_CAN_RESULT_OK)
> +		dev_err(dev, "CAN controller stop failed\n");
> +
> +	priv->busoff_pending = false;
> +	priv->can.state = CAN_STATE_STOPPED;
> +
> +	/* Switch carrier off if device was connected to the bus */
> +	if (netif_carrier_ok(ndev))
> +		netif_carrier_off(ndev);
> +}
> +
> +static int virtio_can_close(struct net_device *dev)
> +{
> +	netif_stop_queue(dev);
> +	/* Keep RX napi active to allow dropping of pending RX CAN messages,
> +	 * keep TX napi active to allow processing of cancelled CAN messages
> +	 */
> +	virtio_can_stop(dev);
> +	close_candev(dev);
> +
> +	return 0;
> +}
> +
> +static netdev_tx_t virtio_can_start_xmit(struct sk_buff *skb,
> +					 struct net_device *dev)
> +{
> +	struct virtio_can_priv *priv = netdev_priv(dev);
> +	struct canfd_frame *cf = (struct canfd_frame *)skb->data;
> +	struct virtio_can_tx *can_tx_msg;
> +	struct virtqueue *vq = priv->vqs[VIRTIO_CAN_QUEUE_TX];
> +	struct scatterlist sg_out[1u];
> +	struct scatterlist sg_in[1u];
> +	struct scatterlist *sgs[2u];
> +	unsigned long flags;
> +	size_t len;
> +	u32 can_flags;
> +	int err;
> +	int prio = 0; /* Priority is always 0 "normal priority" */
> +	netdev_tx_t xmit_ret = NETDEV_TX_OK;
> +	const unsigned int hdr_size = offsetof(struct virtio_can_tx_out, 
sdu);
> +
> +	if (can_dropped_invalid_skb(dev, skb))
> +		goto kick; /* No way to return NET_XMIT_DROP here */
> +
> +	/* Virtio CAN does not support error message frames */
> +	if (cf->can_id & CAN_ERR_FLAG) {
> +		kfree_skb(skb);
> +		dev->stats.tx_dropped++;
> +		goto kick; /* No way to return NET_XMIT_DROP here */
> +	}
> +
> +	/* No local check for CAN_RTR_FLAG or FD frame against negotiated
> +	 * features. The device will reject those anyway if not supported.
> +	 */
> +
> +	can_tx_msg = kzalloc(sizeof(*can_tx_msg), GFP_ATOMIC);
> +	if (!can_tx_msg)
> +		goto kick; /* No way to return NET_XMIT_DROP here */
> +
> +	can_tx_msg->tx_out.msg_type = cpu_to_le16(VIRTIO_CAN_TX);
> +	can_flags = 0u;
> +	if (cf->can_id & CAN_EFF_FLAG)
> +		can_flags |= VIRTIO_CAN_FLAGS_EXTENDED;
> +	if (cf->can_id & CAN_RTR_FLAG)
> +		can_flags |= VIRTIO_CAN_FLAGS_RTR;
> +	if (can_is_canfd_skb(skb))
> +		can_flags |= VIRTIO_CAN_FLAGS_FD;
> +	can_tx_msg->tx_out.flags = cpu_to_le32(can_flags);
> +	can_tx_msg->tx_out.can_id = cpu_to_le32(cf->can_id & CAN_EFF_MASK);
> +	len = cf->len;
> +	if (len > sizeof(cf->data))
> +		len = sizeof(cf->data);
> +	if (len > sizeof(can_tx_msg->tx_out.sdu))
> +		len = sizeof(can_tx_msg->tx_out.sdu);
> +	if (!(can_flags & VIRTIO_CAN_FLAGS_RTR)) {
> +		/* Copy if no RTR frame. RTR frames have a DLC but no 
payload */
> +		memcpy(can_tx_msg->tx_out.sdu, cf->data, len);
> +	}
> +
> +	/* Prepare sending of virtio message */
> +	sg_init_one(&sg_out[0], &can_tx_msg->tx_out, hdr_size + len);
> +	sg_init_one(&sg_in[0], &can_tx_msg->tx_in, sizeof(can_tx_msg-
>tx_in));
> +	sgs[0] = sg_out;
> +	sgs[1] = sg_in;
> +
> +	/* Find free TX priority */
> +	if (atomic_read(&priv->tx_inflight[prio]) >= priv->tx_limit[prio]) {
> +		/* May happen if
> +		 * - tx_limit[prio] > max # of TX queue messages
> +		 */
> +		netif_stop_queue(dev);
> +		kfree(can_tx_msg);
> +		netdev_dbg(dev, "TX: Stop queue, all prios full\n");
> +		xmit_ret = NETDEV_TX_BUSY;
> +		goto kick;
> +	}
> +
> +	/* Normal queue stop when no transmission slots are left */
> +	if (atomic_read(&priv->tx_inflight[prio]) >= priv->tx_limit[prio]) {
> +		netif_stop_queue(dev);
> +		netdev_dbg(dev, "TX: Normal stop queue\n");
> +	}
> +
> +	/* Protect list operations */
> +	spin_lock_irqsave(&priv->tx_lock, flags);
> +	can_tx_msg->putidx = virtio_can_alloc_tx_idx(priv, prio);
> +	list_add_tail(&can_tx_msg->list, &priv->tx_list);
> +	spin_unlock_irqrestore(&priv->tx_lock, flags);
> +
> +	BUG_ON(can_tx_msg->putidx < 0);
> +	can_tx_msg->prio = prio;
> +
> +	/* Push loopback echo. Will be looped back on TX interrupt/TX NAPI 
*/
> +	can_put_echo_skb(skb, dev, can_tx_msg->putidx, 0);
> +
> +	/* Protect queue and list operations */
> +	spin_lock_irqsave(&priv->tx_lock, flags);
> +	err = virtqueue_add_sgs(vq, sgs, 1u, 1u, can_tx_msg, GFP_ATOMIC);
> +	if (err != 0) {
> +		list_del(&can_tx_msg->list);
> +		virtio_can_free_tx_idx(priv, can_tx_msg->prio,
> +				       can_tx_msg->putidx);
> +		spin_unlock_irqrestore(&priv->tx_lock, flags);
> +		netif_stop_queue(dev);
> +		kfree(can_tx_msg);
> +		if (err == -ENOSPC)
> +			netdev_dbg(dev, "TX: Stop queue, no space 
left\n");
> +		else
> +			netdev_warn(dev, "TX: Stop queue, reason = 
%d\n", err);
> +		xmit_ret = NETDEV_TX_BUSY;
> +		goto kick;
> +	}
> +	spin_unlock_irqrestore(&priv->tx_lock, flags);
> +
> +kick:
> +	if (netif_queue_stopped(dev) || !netdev_xmit_more()) {
> +		if (!virtqueue_kick(vq))
> +			netdev_err(dev, "%s(): Kick failed\n", 
__func__);
> +	}
> +
> +	return xmit_ret;
> +}
> +
> +static const struct net_device_ops virtio_can_netdev_ops = {
> +	.ndo_open = virtio_can_open,
> +	.ndo_stop = virtio_can_close,
> +	.ndo_start_xmit = virtio_can_start_xmit,
> +	.ndo_change_mtu = can_change_mtu,
> +};
> +
> +static int register_virtio_can_dev(struct net_device *dev)
> +{
> +	dev->flags |= IFF_ECHO;	/* we support local echo */
> +	dev->netdev_ops = &virtio_can_netdev_ops;
> +
> +	return register_candev(dev);
> +}
> +
> +/* Compare with m_can.c/m_can_echo_tx_event() */
> +static int virtio_can_read_tx_queue(struct virtqueue *vq)
> +{
> +	struct virtio_can_priv *can_priv = vq->vdev->priv;
> +	struct net_device *dev = can_priv->dev;
> +	struct net_device_stats *stats = &dev->stats;
> +	struct virtio_can_tx *can_tx_msg;
> +	unsigned long flags;
> +	unsigned int len;
> +	u8 result;
> +
> +	/* Protect list and virtio queue operations */
> +	spin_lock_irqsave(&can_priv->tx_lock, flags);
> +
> +	can_tx_msg = virtqueue_get_buf(vq, &len);
> +	if (!can_tx_msg) {
> +		spin_unlock_irqrestore(&can_priv->tx_lock, flags);
> +		return 0; /* No more data */
> +	}
> +
> +	if (unlikely(len < sizeof(struct virtio_can_tx_in))) {
> +		netdev_err(dev, "TX ACK: Device sent no result code\n");
> +		result = VIRTIO_CAN_RESULT_NOT_OK; /* Keep things going */
> +	} else {
> +		result = can_tx_msg->tx_in.result;
> +	}
> +
> +	if (can_priv->can.state < CAN_STATE_BUS_OFF) {
> +		/* Here also frames with result != VIRTIO_CAN_RESULT_OK 
are
> +		 * echoed. Intentional to bring a waiting process in an 
upper
> +		 * layer to an end.
> +		 * TODO: Any better means to indicate a problem here?
> +		 */
> +		if (result != VIRTIO_CAN_RESULT_OK)
> +			netdev_warn(dev, "TX ACK: Result = %u\n", 
result);
> +
> +		stats->tx_bytes += can_get_echo_skb(dev, can_tx_msg-
>putidx,
> +						    NULL);
> +		stats->tx_packets++;
> +	} else {
> +		netdev_dbg(dev, "TX ACK: Controller inactive, drop 
echo\n");
> +		can_free_echo_skb(dev, can_tx_msg->putidx, NULL);
> +	}
> +
> +	list_del(&can_tx_msg->list);
> +	virtio_can_free_tx_idx(can_priv, can_tx_msg->prio, can_tx_msg-
>putidx);
> +
> +	spin_unlock_irqrestore(&can_priv->tx_lock, flags);
> +
> +	kfree(can_tx_msg);
> +
> +	/* Flow control */
> +	if (netif_queue_stopped(dev)) {
> +		netdev_dbg(dev, "TX ACK: Wake up stopped queue\n");
> +		netif_wake_queue(dev);
> +	}
> +
> +	return 1; /* Queue was not emtpy so there may be more data */
> +}
> +
> +/* Poll TX used queue for sent CAN messages
> + * See https://wiki.linuxfoundation.org/networking/napi function
> + * int (*poll)(struct napi_struct *napi, int budget);
> + */
> +static int virtio_can_tx_poll(struct napi_struct *napi, int quota)
> +{
> +	struct net_device *dev = napi->dev;
> +	struct virtio_can_priv *priv = netdev_priv(dev);
> +	struct virtqueue *vq = priv->vqs[VIRTIO_CAN_QUEUE_TX];
> +	int work_done = 0;
> +
> +	while (work_done < quota && virtio_can_read_tx_queue(vq) != 0)
> +		work_done++;
> +
> +	if (work_done < quota)
> +		virtqueue_napi_complete(napi, vq, work_done);
> +
> +	return work_done;
> +}
> +
> +static void virtio_can_tx_intr(struct virtqueue *vq)
> +{
> +	struct virtio_can_priv *can_priv = vq->vdev->priv;
> +
> +	virtqueue_disable_cb(vq);
> +	napi_schedule(&can_priv->napi_tx);
> +}
> +
> +/* This function is the NAPI RX poll function and NAPI guarantees that this
> + * function is not invoked simulataneously on multiply processors. + *
> Read a RX message from the used queue and sends it to the upper layer. + *
> (See also m_can.c / m_can_read_fifo()).
> + */
> +static int virtio_can_read_rx_queue(struct virtqueue *vq)
> +{
> +	struct virtio_can_priv *priv = vq->vdev->priv;
> +	struct net_device *dev = priv->dev;
> +	struct net_device_stats *stats = &dev->stats;
> +	struct virtio_can_rx *can_rx;
> +	struct canfd_frame *cf;
> +	struct sk_buff *skb;
> +	unsigned int len;
> +	const unsigned int header_size = offsetof(struct virtio_can_rx, 
sdu);
> +	u16 msg_type;
> +	u32 can_flags;
> +	u32 can_id;
> +
> +	can_rx = virtqueue_get_buf(vq, &len);
> +	if (!can_rx)
> +		return 0; /* No more data */
> +
> +	if (len < header_size) {
> +		netdev_warn(dev, "RX: Message too small\n");
> +		goto putback;
> +	}
> +
> +	if (priv->can.state >= CAN_STATE_ERROR_PASSIVE) {
> +		netdev_dbg(dev, "%s(): Controller not active\n", 
__func__);
> +		goto putback;
> +	}
> +
> +	msg_type = le16_to_cpu(can_rx->msg_type);
> +	if (msg_type != VIRTIO_CAN_RX) {
> +		netdev_warn(dev, "RX: Got unknown msg_type %04x\n", 
msg_type);
> +		goto putback;
> +	}
> +
> +	len -= header_size; /* Payload only now */
> +	can_flags = le32_to_cpu(can_rx->flags);
> +	can_id = le32_to_cpu(can_rx->can_id);
> +
> +	if (can_flags & ~CAN_KNOWN_FLAGS) {
> +		stats->rx_dropped++;
> +		netdev_warn(dev, "RX: CAN Id 0x%08x: Invalid flags 
0x%x\n",
> +			    can_id, can_flags);
> +		goto putback;
> +	}
> +
> +	if (can_flags & VIRTIO_CAN_FLAGS_EXTENDED) {
> +		can_id &= CAN_EFF_MASK;
> +		can_id |= CAN_EFF_FLAG;
> +	} else {
> +		can_id &= CAN_SFF_MASK;
> +	}
> +
> +	if (can_flags & VIRTIO_CAN_FLAGS_RTR) {
> +		if (!virtio_has_feature(vq->vdev, 
VIRTIO_CAN_F_RTR_FRAMES)) {
> +			stats->rx_dropped++;
> +			netdev_warn(dev, "RX: CAN Id 0x%08x: RTR not 
negotiated\n",
> +				    can_id);
> +			goto putback;
> +		}
> +		if (can_flags & VIRTIO_CAN_FLAGS_FD) {
> +			stats->rx_dropped++;
> +			netdev_warn(dev, "RX: CAN Id 0x%08x: RTR with FD 
not possible\n",
> +				    can_id);
> +			goto putback;
> +		}
> +
> +		/* For RTR frames we have determined a len value here from 
a
> +		 * payload length while RTR frames have no payload. Could 
be
> +		 * reason enough to add a dlc field to virtio CAN RX and 
virtio
> +		 * CAN TX messages avoiding to have a dummy payload here.
> +		 */
> +		if (len > 0xF) {
> +			stats->rx_dropped++;
> +			netdev_warn(dev, "RX: CAN Id 0x%08x: RTR with 
len != 0\n",
> +				    can_id);
> +			goto putback;
> +		}
> +
> +		if (len > 0x8)
> +			len = 0x8;
> +
> +		can_id |= CAN_RTR_FLAG;
> +	}
> +
> +	if (can_flags & VIRTIO_CAN_FLAGS_FD) {
> +		if (!virtio_has_feature(vq->vdev, VIRTIO_CAN_F_CAN_FD)) {
> +			stats->rx_dropped++;
> +			netdev_warn(dev, "RX: CAN Id 0x%08x: FD not 
negotiated\n",
> +				    can_id);
> +			goto putback;
> +		}
> +
> +		if (len > CANFD_MAX_DLEN)
> +			len = CANFD_MAX_DLEN;
> +
> +		skb = alloc_canfd_skb(priv->dev, &cf);
> +	} else {
> +		if (!virtio_has_feature(vq->vdev, 
VIRTIO_CAN_F_CAN_CLASSIC)) {
> +			stats->rx_dropped++;
> +			netdev_warn(dev, "RX: CAN Id 0x%08x: classic not 
negotiated\n",
> +				    can_id);
> +			goto putback;
> +		}
> +
> +		if (len > CAN_MAX_DLEN)
> +			len = CAN_MAX_DLEN;
> +
> +		skb = alloc_can_skb(priv->dev, (struct can_frame **)&cf);
> +	}
> +	if (!skb) {
> +		stats->rx_dropped++;
> +		netdev_warn(dev, "RX: No skb available\n");
> +		goto putback;
> +	}
> +
> +	cf->can_id = can_id;
> +	cf->len = len;
> +	if (!(can_flags & VIRTIO_CAN_FLAGS_RTR)) {
> +		/* RTR frames have a DLC but no payload */
> +		memcpy(cf->data, can_rx->sdu, len);
> +	}
> +
> +	if (netif_receive_skb(skb) == NET_RX_SUCCESS) {
> +		stats->rx_packets++;
> +		if (!(can_flags & VIRTIO_CAN_FLAGS_RTR))
> +			stats->rx_bytes += cf->len;
> +	}
> +
> +putback:
> +	/* Put processed RX buffer back into avail queue */
> +	virtio_can_add_inbuf(vq, can_rx, sizeof(struct virtio_can_rx));
> +
> +	return 1; /* Queue was not emtpy so there may be more data */
> +}
> +
> +/* See m_can_poll() / m_can_handle_state_errors()
> m_can_handle_state_change() */ +static int virtio_can_handle_busoff(struct
> net_device *dev)
> +{
> +	struct virtio_can_priv *priv = netdev_priv(dev);
> +	struct net_device_stats *stats = &dev->stats;
> +	struct can_frame *cf;
> +	struct sk_buff *skb;
> +	u8 rx_bytes;
> +
> +	if (!priv->busoff_pending)
> +		return 0;
> +
> +	if (priv->can.state < CAN_STATE_BUS_OFF) {
> +		netdev_dbg(dev, "entered error bus off state\n");
> +
> +		/* bus-off state */
> +		priv->can.state = CAN_STATE_BUS_OFF;
> +		priv->can.can_stats.bus_off++;
> +		can_bus_off(dev);
> +	}
> +
> +	/* propagate the error condition to the CAN stack */
> +	skb = alloc_can_err_skb(dev, &cf);
> +	if (unlikely(!skb))
> +		return 0;
> +
> +	/* bus-off state */
> +	cf->can_id |= CAN_ERR_BUSOFF;
> +	rx_bytes = cf->can_dlc;
> +
> +	/* Ensure that the BusOff indication does not get lost */
> +	if (netif_receive_skb(skb) == NET_RX_SUCCESS)
> +		priv->busoff_pending = false;
> +
> +	stats->rx_packets++;
> +	stats->rx_bytes += rx_bytes;
> +
> +	return 1;
> +}
> +
> +/* Poll RX used queue for received CAN messages
> + * See https://wiki.linuxfoundation.org/networking/napi function
> + * int (*poll)(struct napi_struct *napi, int budget);
> + * Important: "The networking subsystem promises that poll() will not be
> + * invoked simultaneously (for the same napi_struct) on multiple
> processors" + */
> +static int virtio_can_rx_poll(struct napi_struct *napi, int quota)
> +{
> +	struct net_device *dev = napi->dev;
> +	struct virtio_can_priv *priv = netdev_priv(dev);
> +	struct virtqueue *vq = priv->vqs[VIRTIO_CAN_QUEUE_RX];
> +	int work_done = 0;
> +
> +	work_done += virtio_can_handle_busoff(dev);
> +
> +	while (work_done < quota && virtio_can_read_rx_queue(vq) != 0)
> +		work_done++;
> +
> +	if (work_done < quota)
> +		virtqueue_napi_complete(napi, vq, work_done);
> +
> +	return work_done;
> +}
> +
> +static void virtio_can_rx_intr(struct virtqueue *vq)
> +{
> +	struct virtio_can_priv *can_priv = vq->vdev->priv;
> +
> +	virtqueue_disable_cb(vq);
> +	napi_schedule(&can_priv->napi);
> +}
> +
> +static void virtio_can_control_intr(struct virtqueue *vq)
> +{
> +	struct virtio_can_priv *can_priv = vq->vdev->priv;
> +
> +	complete(&can_priv->ctrl_done);
> +}
> +
> +static void virtio_can_evind_intr(struct virtqueue *vq)
> +{
> +	struct virtio_can_priv *can_priv = vq->vdev->priv;
> +	struct net_device *dev = can_priv->dev;
> +	struct virtio_can_event_ind *evind;
> +	unsigned int len;
> +	u16 msg_type;
> +
> +	for (;;) {
> +		/* The interrupt function is not assumed to be interrupted 
by
> +		 * itself so locks should not be needed for queue 
operations.
> +		 */
> +		evind = virtqueue_get_buf(vq, &len);
> +		if (!evind)
> +			return; /* No more messages */
> +
> +		if (len < sizeof(struct virtio_can_event_ind)) {
> +			netdev_warn(dev, "Evind: Message too small\n");
> +			goto putback;
> +		}
> +
> +		msg_type = le16_to_cpu(evind->msg_type);
> +		if (msg_type != VIRTIO_CAN_BUSOFF_IND) {
> +			netdev_warn(dev, "Evind: Got unknown msg_type 
%04x\n",
> +				    msg_type);
> +			goto putback;
> +		}
> +
> +		if (!can_priv->busoff_pending &&
> +		    can_priv->can.state < CAN_STATE_BUS_OFF) {
> +			can_priv->busoff_pending = true;
> +			napi_schedule(&can_priv->napi);
> +		}
> +
> +putback:
> +		/* Put processed event ind buffer back into avail queue */
> +		virtio_can_add_inbuf(vq, evind,
> +				     sizeof(struct 
virtio_can_event_ind));
> +	}
> +}
> +
> +static void virtio_can_populate_vqs(struct virtio_device *vdev)
> +
> +{
> +	struct virtio_can_priv *priv = vdev->priv;
> +	struct virtqueue *vq;
> +	unsigned int idx;
> +	int ret;
> +
> +	// TODO: Think again a moment if here locks already may be needed!
> +
> +	/* Fill RX queue */
> +	vq = priv->vqs[VIRTIO_CAN_QUEUE_RX];
> +	for (idx = 0u; idx < ARRAY_SIZE(priv->rpkt); idx++) {
> +		ret = virtio_can_add_inbuf(vq, &priv->rpkt[idx],
> +					   sizeof(struct 
virtio_can_rx));
> +		if (ret < 0) {
> +			dev_dbg(&vdev->dev, "rpkt fill: ret=%d, 
idx=%u\n",
> +				ret, idx);
> +			break;
> +		}
> +	}
> +	dev_dbg(&vdev->dev, "%u rpkt added\n", idx);
> +
> +	/* Fill event indication queue */
> +	vq = priv->vqs[VIRTIO_CAN_QUEUE_INDICATION];
> +	for (idx = 0u; idx < ARRAY_SIZE(priv->ipkt); idx++) {
> +		ret = virtio_can_add_inbuf(vq, &priv->ipkt[idx],
> +					   sizeof(struct 
virtio_can_event_ind));
> +		if (ret < 0) {
> +			dev_dbg(&vdev->dev, "ipkt fill: ret=%d, 
idx=%u\n",
> +				ret, idx);
> +			break;
> +		}
> +	}
> +	dev_dbg(&vdev->dev, "%u ipkt added\n", idx);
> +}
> +
> +static int virtio_can_find_vqs(struct virtio_can_priv *priv)
> +{
> +	/* The order of RX and TX is exactly the opposite as in console and
> +	 * network. Does not play any role but is a bad trap.
> +	 */
> +	static const char * const io_names[VIRTIO_CAN_QUEUE_COUNT] = {
> +		"can-tx",
> +		"can-rx",
> +		"can-state-ctrl",
> +		"can-event-ind"
> +	};
> +
> +	priv->io_callbacks[VIRTIO_CAN_QUEUE_TX] = virtio_can_tx_intr;
> +	priv->io_callbacks[VIRTIO_CAN_QUEUE_RX] = virtio_can_rx_intr;
> +	priv->io_callbacks[VIRTIO_CAN_QUEUE_CONTROL] = 
virtio_can_control_intr;
> +	priv->io_callbacks[VIRTIO_CAN_QUEUE_INDICATION] = 
virtio_can_evind_intr;
> +
> +	/* Find the queues. */
> +	return virtio_find_vqs(priv->vdev, VIRTIO_CAN_QUEUE_COUNT, priv-
>vqs,
> +			       priv->io_callbacks, io_names, NULL);
> +}
> +
> +/* Function must not be called before virtio_can_find_vqs() has been run */
> +static void virtio_can_del_vq(struct virtio_device *vdev)
> +{
> +	struct virtio_can_priv *priv = vdev->priv;
> +	struct list_head *cursor, *next;
> +	struct virtqueue *vq;
> +
> +	/* Reset the device */
> +	if (vdev->config->reset)
> +		vdev->config->reset(vdev);
> +
> +	/* From here we have dead silence from the device side so no locks
> +	 * are needed to protect against device side events.
> +	 */
> +
> +	vq = priv->vqs[VIRTIO_CAN_QUEUE_INDICATION];
> +	while (virtqueue_detach_unused_buf(vq))
> +		; /* Do nothing, content allocated statically */
> +
> +	vq = priv->vqs[VIRTIO_CAN_QUEUE_CONTROL];
> +	while (virtqueue_detach_unused_buf(vq))
> +		; /* Do nothing, content allocated statically */
> +
> +	vq = priv->vqs[VIRTIO_CAN_QUEUE_RX];
> +	while (virtqueue_detach_unused_buf(vq))
> +		; /* Do nothing, content allocated statically */
> +
> +	vq = priv->vqs[VIRTIO_CAN_QUEUE_TX];
> +	while (virtqueue_detach_unused_buf(vq))
> +		; /* Do nothing, content to be de-allocated separately */
> +
> +	/* Is keeping track of allocated elements by an own linked list
> +	 * really necessary or may this be optimized using only
> +	 * virtqueue_detach_unused_buf()?
> +	 */
> +	list_for_each_safe(cursor, next, &priv->tx_list) {
> +		struct virtio_can_tx *can_tx;
> +
> +		can_tx = list_entry(cursor, struct virtio_can_tx, list);
> +		list_del(cursor);
> +		kfree(can_tx);
> +	}
> +
> +	if (vdev->config->del_vqs)
> +		vdev->config->del_vqs(vdev);
> +}
> +
> +/* See virtio_net.c/virtnet_remove() and also m_can.c/m_can_plat_remove()
> */ +static void virtio_can_remove(struct virtio_device *vdev)
> +{
> +	struct virtio_can_priv *priv = vdev->priv;
> +	struct net_device *dev = priv->dev;
> +
> +	unregister_candev(dev);
> +
> +	/* No calls of netif_napi_del() needed as free_candev() will do this 
*/
> +
> +	virtio_can_del_vq(vdev);
> +
> +	virtio_can_free_candev(dev);
> +}
> +
> +static int virtio_can_validate(struct virtio_device *vdev)
> +{
> +	/* CAN needs always access to the config space.
> +	 * Check that the driver can access the config space
> +	 */
> +	if (!vdev->config->get) {
> +		dev_err(&vdev->dev, "%s failure: config access 
disabled\n",
> +			__func__);
> +		return -EINVAL;
> +	}
> +
> +	if (!virtio_has_feature(vdev, VIRTIO_F_VERSION_1)) {
> +		dev_err(&vdev->dev,
> +			"device does not comply with spec version 
1.x\n");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int virtio_can_probe(struct virtio_device *vdev)
> +{
> +	struct net_device *dev;
> +	struct virtio_can_priv *priv;
> +	int err;
> +	unsigned int echo_skb_max;
> +	unsigned int idx;
> +	u16 lo_tx = VIRTIO_CAN_ECHO_SKB_MAX;
> +
> +	echo_skb_max = lo_tx;
> +	dev = alloc_candev(sizeof(struct virtio_can_priv), echo_skb_max);
> +	if (!dev)
> +		return -ENOMEM;
> +
> +	priv = netdev_priv(dev);
> +
> +	priv->tx_putidx_list =
> +		kcalloc(echo_skb_max, sizeof(struct list_head), 
GFP_KERNEL);
> +	if (!priv->tx_putidx_list) {
> +		free_candev(dev);
> +		return -ENOMEM;
> +	}
> +
> +	INIT_LIST_HEAD(&priv->tx_putidx_free);
> +	for (idx = 0u; idx < echo_skb_max; idx++)
> +		list_add_tail(&priv->tx_putidx_list[idx],
> +			      &priv->tx_putidx_free);
> +
> +	netif_napi_add(dev, &priv->napi, virtio_can_rx_poll);
> +	netif_napi_add(dev, &priv->napi_tx, virtio_can_tx_poll);
> +
> +	SET_NETDEV_DEV(dev, &vdev->dev);
> +
> +	priv->dev = dev;
> +	priv->vdev = vdev;
> +	vdev->priv = priv;
> +
> +	priv->can.do_set_mode = virtio_can_set_mode;
> +	priv->can.state = CAN_STATE_STOPPED;
> +	/* Set Virtio CAN supported operations */
> +	priv->can.ctrlmode_supported = CAN_CTRLMODE_BERR_REPORTING;
> +	if (virtio_has_feature(vdev, VIRTIO_CAN_F_CAN_FD)) {
> +		err = can_set_static_ctrlmode(dev, CAN_CTRLMODE_FD);
> +		if (err != 0)
> +			goto on_failure;
> +	}
> +
> +	/* Initialize virtqueues */
> +	err = virtio_can_find_vqs(priv);
> +	if (err != 0)
> +		goto on_failure;
> +
> +	/* It is possible to consider the number of TX queue places to
> +	 * introduce a stricter TX flow control. Question is if this should
> +	 * be done permanently this way in the Linux virtio CAN driver.
> +	 */
> +	if (true) {
> +		struct virtqueue *vq = priv->vqs[VIRTIO_CAN_QUEUE_TX];
> +		unsigned int tx_slots = vq->num_free;
> +
> +		if (!virtio_has_feature(vdev, 
VIRTIO_RING_F_INDIRECT_DESC))
> +			tx_slots >>= 1;
> +		if (lo_tx > tx_slots)
> +			lo_tx = tx_slots;
> +	}
> +
> +	priv->tx_limit[0] = lo_tx;
> +
> +	INIT_LIST_HEAD(&priv->tx_list);
> +
> +	spin_lock_init(&priv->tx_lock);
> +	mutex_init(&priv->ctrl_lock);
> +
> +	init_completion(&priv->ctrl_done);
> +
> +	virtio_can_populate_vqs(vdev);
> +
> +	register_virtio_can_dev(dev);
> +
> +	napi_enable(&priv->napi);
> +	napi_enable(&priv->napi_tx);
> +
> +	/* Request device going live */
> +	virtio_device_ready(vdev); /* Optionally done by virtio_dev_probe() 
*/
> +
> +	return 0;
> +
> +on_failure:
> +	virtio_can_free_candev(dev);
> +	return err;
> +}
> +
> +#ifdef CONFIG_PM_SLEEP
> +/* Compare with m_can.c/m_can_suspend(), virtio_net.c/virtnet_freeze() and
> + * virtio_card.c/virtsnd_freeze()
> + */
> +static int virtio_can_freeze(struct virtio_device *vdev)
> +{
> +	struct virtio_can_priv *priv = vdev->priv;
> +	struct net_device *ndev = priv->dev;
> +
> +	napi_disable(&priv->napi);
> +	napi_disable(&priv->napi_tx);
> +
> +	if (netif_running(ndev)) {
> +		netif_stop_queue(ndev);
> +		netif_device_detach(ndev);
> +		virtio_can_stop(ndev);
> +	}
> +
> +	priv->can.state = CAN_STATE_SLEEPING;
> +
> +	virtio_can_del_vq(vdev);
> +
> +	return 0;
> +}
> +
> +/* Compare with m_can.c/m_can_resume(), virtio_net.c/virtnet_restore() and
> + * virtio_card.c/virtsnd_restore()
> + */
> +static int virtio_can_restore(struct virtio_device *vdev)
> +{
> +	struct virtio_can_priv *priv = vdev->priv;
> +	struct net_device *ndev = priv->dev;
> +	int err;
> +
> +	err = virtio_can_find_vqs(priv);
> +	if (err != 0)
> +		return err;
> +	virtio_can_populate_vqs(vdev);
> +
> +	priv->can.state = CAN_STATE_ERROR_ACTIVE;
> +
> +	if (netif_running(ndev)) {
> +		virtio_can_start(ndev);
> +		netif_device_attach(ndev);
> +		netif_start_queue(ndev);
> +	}
> +
> +	napi_enable(&priv->napi);
> +	napi_enable(&priv->napi_tx);
> +
> +	return 0;
> +}
> +#endif /* #ifdef CONFIG_PM_SLEEP */
> +
> +static struct virtio_device_id virtio_can_id_table[] = {
> +	{ VIRTIO_ID_CAN, VIRTIO_DEV_ANY_ID },
> +	{ 0 },
> +};
> +
> +static unsigned int features[] = {
> +	VIRTIO_CAN_F_CAN_CLASSIC,
> +	VIRTIO_CAN_F_CAN_FD,
> +	VIRTIO_CAN_F_LATE_TX_ACK,
> +	VIRTIO_CAN_F_RTR_FRAMES,
> +};
> +
> +static struct virtio_driver virtio_can_driver = {
> +	.feature_table = features,
> +	.feature_table_size = ARRAY_SIZE(features),
> +	.feature_table_legacy = NULL,
> +	.feature_table_size_legacy = 0u,
> +	.driver.name =	KBUILD_MODNAME,
> +	.driver.owner =	THIS_MODULE,
> +	.id_table =	virtio_can_id_table,
> +	.validate =	virtio_can_validate,
> +	.probe =	virtio_can_probe,
> +	.remove =	virtio_can_remove,
> +	.config_changed = NULL,
> +#ifdef CONFIG_PM_SLEEP
> +	.freeze =	virtio_can_freeze,
> +	.restore =	virtio_can_restore,
> +#endif
> +};
> +
> +module_virtio_driver(virtio_can_driver);
> +MODULE_DEVICE_TABLE(virtio, virtio_can_id_table);
> +
> +MODULE_AUTHOR("OpenSynergy GmbH");
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("CAN bus driver for Virtio CAN controller");
> diff --git a/include/uapi/linux/virtio_can.h
> b/include/uapi/linux/virtio_can.h new file mode 100644
> index 000000000000..0ca75c7a98ee
> --- /dev/null
> +++ b/include/uapi/linux/virtio_can.h
> @@ -0,0 +1,69 @@
> +/* SPDX-License-Identifier: BSD-3-Clause */
> +/*
> + * Copyright (C) 2021 OpenSynergy GmbH
> + */
> +#ifndef _LINUX_VIRTIO_VIRTIO_CAN_H
> +#define _LINUX_VIRTIO_VIRTIO_CAN_H
> +
> +#include <linux/types.h>
> +#include <linux/virtio_types.h>
> +#include <linux/virtio_ids.h>
> +#include <linux/virtio_config.h>
> +
> +/* Feature bit numbers */
> +#define VIRTIO_CAN_F_CAN_CLASSIC        0u
> +#define VIRTIO_CAN_F_CAN_FD             1u
> +#define VIRTIO_CAN_F_LATE_TX_ACK        2u
> +#define VIRTIO_CAN_F_RTR_FRAMES         3u
> +
> +/* CAN Result Types */
> +#define VIRTIO_CAN_RESULT_OK            0u
> +#define VIRTIO_CAN_RESULT_NOT_OK        1u
> +
> +/* CAN flags to determine type of CAN Id */
> +#define VIRTIO_CAN_FLAGS_EXTENDED       0x8000u
> +#define VIRTIO_CAN_FLAGS_FD             0x4000u
> +#define VIRTIO_CAN_FLAGS_RTR            0x2000u
> +
> +/* TX queue message types */
> +struct virtio_can_tx_out {
> +#define VIRTIO_CAN_TX                   0x0001u
> +	__le16 msg_type;
> +	__le16 reserved;
> +	__le32 flags;
> +	__le32 can_id;
> +	__u8 sdu[64u];

64u is CANFD_MAX_DLEN, right? Is it sensible to use that define instead?
I guess if CAN XL support is to be added at some point, a dedicated struct is 
needed, to fit for CANXL_MAX_DLEN (2048 [1]).

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/
commit/?id=1a3e3034c049503ec6992a4a7d573e7fff31fac4

> +};
> +
> +struct virtio_can_tx_in {
> +	__u8 result;
> +};
> +
> +/* RX queue message types */
> +struct virtio_can_rx {
> +#define VIRTIO_CAN_RX                   0x0101u
> +	__le16 msg_type;
> +	__le16 reserved;
> +	__le32 flags;
> +	__le32 can_id;
> +	__u8 sdu[64u];
> +};

I have no experience with virtio drivers, but is there a need for dedicated 
structs for Tx and Rx? They are identical anyway.

Best regards,
Alexander

> +
> +/* Control queue message types */
> +struct virtio_can_control_out {
> +#define VIRTIO_CAN_SET_CTRL_MODE_START  0x0201u
> +#define VIRTIO_CAN_SET_CTRL_MODE_STOP   0x0202u
> +	__le16 msg_type;
> +};
> +
> +struct virtio_can_control_in {
> +	__u8 result;
> +};
> +
> +/* Indication queue message types */
> +struct virtio_can_event_ind {
> +#define VIRTIO_CAN_BUSOFF_IND           0x0301u
> +	__le16 msg_type;
> +};
> +
> +#endif /* #ifndef _LINUX_VIRTIO_VIRTIO_CAN_H */




