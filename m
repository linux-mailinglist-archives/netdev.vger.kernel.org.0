Return-Path: <netdev+bounces-2104-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 618E270044B
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 11:54:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C62F281705
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 09:54:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4F71BE6E;
	Fri, 12 May 2023 09:54:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC39A8F6E
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 09:54:10 +0000 (UTC)
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E59659A;
	Fri, 12 May 2023 02:54:06 -0700 (PDT)
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6439df6c268so6197653b3a.0;
        Fri, 12 May 2023 02:54:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683885245; x=1686477245;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=leclAGNLbun9veCF2Z/1yYZTDDkRba38n2oKBjXxAJg=;
        b=dfF7apKrlanbiQqhR3FbtAo/+0eD1kzyZgImUIR6VfAUdEd21XbCtWzPTdbrt9sROL
         c65Le/6oNs8k27dAhy3xvmStIBI/7TDkhQjOIqOIkY9aqNktoGRpgWV+ORZtylrSarG8
         Sh9ywOvvOFuuaj84AcJhgtWL5E72wQmZqUPiKzgkc2i3YYiI1VZf1o8x7LRsaNYrXYjs
         OVtMQoyx811ywnNHm6ulk7wjJa8tz4KlgghIJM0hQb6RIGyYZR8N+o0gauZht3XMteey
         Ad2ZNpvPG0KCqrGzscOowejoitK9iCCukm2AQGCkW4qnTWWVxPHhgMo9ktcdd9gocFd2
         Ep/A==
X-Gm-Message-State: AC+VfDyXjh9gjw355WQsUEA2YES4qcSf3avonOJNz91/HXDqrIte7sba
	UI9COhdjJrORrMN6eZIoFmsChXR2Qy2t7y8ypDU=
X-Google-Smtp-Source: ACHHUZ6IBU8zU6l4BFAcoH4Aqom3fHSyuu80jt4uLt2QiLAVEVZTBiLfm8EVyHIg2NWQ+UOflbKP7OzCu661PPc2TuQ=
X-Received: by 2002:a05:6a00:2d12:b0:624:2e60:f21e with SMTP id
 fa18-20020a056a002d1200b006242e60f21emr34617668pfb.29.1683885244921; Fri, 12
 May 2023 02:54:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230511151444.162882-1-Mikhail.Golubev-Ciuchea@opensynergy.com>
In-Reply-To: <20230511151444.162882-1-Mikhail.Golubev-Ciuchea@opensynergy.com>
From: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date: Fri, 12 May 2023 18:53:53 +0900
Message-ID: <CAMZ6RqJbjoApwZbiivbvJRYQyBWfWXG4azmwuXGaicrMq0Lozg@mail.gmail.com>
Subject: Re: [RFC PATCH v3] can: virtio: Initial virtio CAN driver.
To: Mikhail Golubev-Ciuchea <Mikhail.Golubev-Ciuchea@opensynergy.com>
Cc: virtio-dev@lists.oasis-open.org, linux-can@vger.kernel.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, 
	Wolfgang Grandegger <wg@grandegger.com>, Marc Kleine-Budde <mkl@pengutronix.de>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Damir Shaikhutdinov <Damir.Shaikhutdinov@opensynergy.com>, 
	Harald Mommer <harald.mommer@opensynergy.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Mikhail,

Thanks for your patch. Do you have any plans for CAN error reporting
aside from the bus off? (e.g. can error-active, can error-passive, bit
errors...)

On Fri. 12 May 2023 at 00:18, Mikhail Golubev-Ciuchea
<Mikhail.Golubev-Ciuchea@opensynergy.com> wrote:
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
> - CAN BusOff indication
>
>   CAN BusOff is handled by a bit in the configuration space.
>
> Signed-off-by: Harald Mommer <Harald.Mommer@opensynergy.com>
> Signed-off-by: Mikhail Golubev-Ciuchea <Mikhail.Golubev-Ciuchea@opensynergy.com>
> Co-developed-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Cc: Damir Shaikhutdinov <Damir.Shaikhutdinov@opensynergy.com>
> ---
>
> V3:
> * Incorporate patch "[PATCH] can: virtio-can: cleanups" from
>   https://lore.kernel.org/all/20230424-footwear-daily-9339bd0ec428-mkl@pengutronix.de/
> * Add missing can_free_echo_skb()
> * Replace home-brewed ID allocator with the standard one from kernel
> * Simplify flow control
> * Tested with https://github.com/OpenSynergy/qemu/tree/virtio-can-spec-rfc-v3
>
> V2:
> * Remove the event indication queue and use the config space instead, to
>   indicate a bus off condition
> * Rework RX and TX messages having a length field and some more fields for CAN
>   EXT
> * Fix CAN_EFF_MASK comparison
> * Remove MISRA style code (e.g. '! = 0u')
> * Remove priorities leftovers
> * Remove BUGONs
> * Based on virtio can spec RFCv3
> * Tested with https://github.com/OpenSynergy/qemu/tree/virtio-can-spec-rfc-v3
>
>  MAINTAINERS                     |    7 +
>  drivers/net/can/Kconfig         |   12 +
>  drivers/net/can/Makefile        |    3 +-
>  drivers/net/can/virtio_can.c    | 1000 +++++++++++++++++++++++++++++++
>  include/uapi/linux/virtio_can.h |   71 +++
>  5 files changed, 1092 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/net/can/virtio_can.c
>  create mode 100644 include/uapi/linux/virtio_can.h
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7e0b87d5aa2e..ca45950c8364 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22246,6 +22246,13 @@ F:     drivers/vhost/scsi.c
>  F:     include/uapi/linux/virtio_blk.h
>  F:     include/uapi/linux/virtio_scsi.h
>
> +VIRTIO CAN DRIVER
> +M:     "Harald Mommer" <harald.mommer@opensynergy.com>
> +L:     linux-can@vger.kernel.org
> +S:     Maintained
> +F:     drivers/net/can/virtio_can.c
> +F:     include/uapi/linux/virtio_can.h
> +
>  VIRTIO CONSOLE DRIVER
>  M:     Amit Shah <amit@kernel.org>
>  L:     virtualization@lists.linux-foundation.org
> diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
> index 3ceccafd701b..ee47fdff2252 100644
> --- a/drivers/net/can/Kconfig
> +++ b/drivers/net/can/Kconfig
> @@ -210,6 +210,18 @@ config CAN_XILINXCAN
>           Xilinx CAN driver. This driver supports both soft AXI CAN IP and
>           Zynq CANPS IP.
>
> +config CAN_VIRTIO_CAN
> +       depends on VIRTIO
> +       tristate "Virtio CAN device support"
> +       default n
> +       help
> +         Say Y here if you want to support for Virtio CAN.

Broken grammar.

Do either

         Say Y here if you want to add support for Virtio CAN.

or:

         Say Y here if you want to support Virtio CAN devices.

> +
> +         To compile this driver as a module, choose M here: the
> +         module will be called virtio-can.
> +
> +         If unsure, say N.
> +
>  source "drivers/net/can/c_can/Kconfig"
>  source "drivers/net/can/cc770/Kconfig"
>  source "drivers/net/can/ctucanfd/Kconfig"
> diff --git a/drivers/net/can/Makefile b/drivers/net/can/Makefile
> index ff8f76295d13..19314adaff59 100644
> --- a/drivers/net/can/Makefile
> +++ b/drivers/net/can/Makefile
> @@ -17,8 +17,8 @@ obj-$(CONFIG_CAN_AT91)                += at91_can.o
>  obj-$(CONFIG_CAN_BXCAN)                += bxcan.o
>  obj-$(CONFIG_CAN_CAN327)       += can327.o
>  obj-$(CONFIG_CAN_CC770)                += cc770/
> -obj-$(CONFIG_CAN_C_CAN)                += c_can/
>  obj-$(CONFIG_CAN_CTUCANFD)     += ctucanfd/
> +obj-$(CONFIG_CAN_C_CAN)                += c_can/

This reordering is unrelated to this patch goal. Please send it as a
separate patch.

>  obj-$(CONFIG_CAN_FLEXCAN)      += flexcan/
>  obj-$(CONFIG_CAN_GRCAN)                += grcan.o
>  obj-$(CONFIG_CAN_IFI_CANFD)    += ifi_canfd/
> @@ -30,6 +30,7 @@ obj-$(CONFIG_CAN_PEAK_PCIEFD) += peak_canfd/
>  obj-$(CONFIG_CAN_SJA1000)      += sja1000/
>  obj-$(CONFIG_CAN_SUN4I)                += sun4i_can.o
>  obj-$(CONFIG_CAN_TI_HECC)      += ti_hecc.o
> +obj-$(CONFIG_CAN_VIRTIO_CAN)   += virtio_can.o
>  obj-$(CONFIG_CAN_XILINXCAN)    += xilinx_can.o
>
>  subdir-ccflags-$(CONFIG_CAN_DEBUG_DEVICES) += -DDEBUG
> diff --git a/drivers/net/can/virtio_can.c b/drivers/net/can/virtio_can.c
> new file mode 100644
> index 000000000000..ebc3394276d6
> --- /dev/null
> +++ b/drivers/net/can/virtio_can.c
> @@ -0,0 +1,1000 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * CAN bus driver for the Virtio CAN controller
> + * Copyright (C) 2021-2023 OpenSynergy GmbH
> + */
> +
> +#include <linux/atomic.h>
> +#include <linux/idr.h>
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
> +#define VIRTIO_CAN_QUEUE_TX 0 /* Driver side view! The device receives here */
> +#define VIRTIO_CAN_QUEUE_RX 1 /* Driver side view! The device transmits here */
> +#define VIRTIO_CAN_QUEUE_CONTROL 2
> +#define VIRTIO_CAN_QUEUE_COUNT 3
> +
> +#define CAN_KNOWN_FLAGS \
> +       (VIRTIO_CAN_FLAGS_EXTENDED |\
> +        VIRTIO_CAN_FLAGS_FD |\
> +        VIRTIO_CAN_FLAGS_RTR)
> +
> +/* Max. number of in flight TX messages */
> +#define VIRTIO_CAN_ECHO_SKB_MAX 128
> +
> +struct virtio_can_tx {
> +       struct list_head list;
> +       unsigned int putidx;
> +       struct virtio_can_tx_out tx_out;
> +       struct virtio_can_tx_in tx_in;

I am still waiting for your answer on my previous comment here:

  https://lore.kernel.org/linux-can/CAMZ6Rq+RjOHaGx-7GLsj-PNAcHd=nGd=JERddqw4FWbNN3sAXA@mail.gmail.com/

> +};
> +
> +/* virtio_can private data structure */
> +struct virtio_can_priv {
> +       struct can_priv can;    /* must be the first member */
> +       /* NAPI for RX messages */
> +       struct napi_struct napi;
> +       /* NAPI for TX messages */
> +       struct napi_struct napi_tx;
> +       /* The network device we're associated with */
> +       struct net_device *dev;
> +       /* The virtio device we're associated with */
> +       struct virtio_device *vdev;
> +       /* The virtqueues */
> +       struct virtqueue *vqs[VIRTIO_CAN_QUEUE_COUNT];
> +       /* I/O callback function pointers for the virtqueues */
> +       vq_callback_t *io_callbacks[VIRTIO_CAN_QUEUE_COUNT];
> +       /* Lock for TX operations */
> +       spinlock_t tx_lock;
> +       /* Control queue lock. Defensive programming, may be not needed */
> +       struct mutex ctrl_lock;
> +       /* Wait for control queue processing without polling */
> +       struct completion ctrl_done;
> +       /* List of virtio CAN TX message */
> +       struct list_head tx_list;
> +       /* Array of receive queue messages */
> +       struct virtio_can_rx rpkt[128];
> +       /* Those control queue messages cannot live on the stack! */
> +       struct virtio_can_control_out cpkt_out;
> +       struct virtio_can_control_in cpkt_in;
> +       /* Data to get and maintain the putidx for local TX echo */
> +       struct ida tx_putidx_ida;
> +       /* In flight TX messages */
> +       atomic_t tx_inflight;
> +       /* BusOff pending. Reset after successful indication to upper layer */
> +       bool busoff_pending;
> +};
> +
> +/* Function copied from virtio_net.c */
> +static void virtqueue_napi_schedule(struct napi_struct *napi,
> +                                   struct virtqueue *vq)
> +{
> +       if (napi_schedule_prep(napi)) {
> +               virtqueue_disable_cb(vq);
> +               __napi_schedule(napi);
> +       }
> +}
> +
> +/* Function copied from virtio_net.c */
> +static void virtqueue_napi_complete(struct napi_struct *napi,
> +                                   struct virtqueue *vq, int processed)
> +{
> +       int opaque;
> +
> +       opaque = virtqueue_enable_cb_prepare(vq);
> +       if (napi_complete_done(napi, processed)) {
> +               if (unlikely(virtqueue_poll(vq, opaque)))
> +                       virtqueue_napi_schedule(napi, vq);
> +       } else {
> +               virtqueue_disable_cb(vq);
> +       }
> +}
> +
> +static void virtio_can_free_candev(struct net_device *ndev)
> +{
> +       struct virtio_can_priv *priv = netdev_priv(ndev);
> +
> +       ida_destroy(&priv->tx_putidx_ida);
> +       free_candev(ndev);
> +}
> +
> +static int virtio_can_alloc_tx_idx(struct virtio_can_priv *priv)
> +{
> +       int tx_idx;
> +
> +       tx_idx = ida_alloc_range(&priv->tx_putidx_ida, 0,
> +                                priv->can.echo_skb_max - 1, GFP_KERNEL);
> +       if (tx_idx >= 0)
> +               atomic_add(1, &priv->tx_inflight);
> +
> +       return tx_idx;
> +}
> +
> +static void virtio_can_free_tx_idx(struct virtio_can_priv *priv,
> +                                  unsigned int idx)
> +{
> +       ida_free(&priv->tx_putidx_ida, idx);
> +       atomic_sub(1, &priv->tx_inflight);
> +}
> +
> +/* Create a scatter-gather list representing our input buffer and put
> + * it in the queue.
> + *
> + * Callers should take appropriate locks.
> + */
> +static int virtio_can_add_inbuf(struct virtqueue *vq, void *buf,
> +                               unsigned int size)
> +{
> +       struct scatterlist sg[1];
> +       int ret;
> +
> +       sg_init_one(sg, buf, size);
> +
> +       ret = virtqueue_add_inbuf(vq, sg, 1, buf, GFP_ATOMIC);
> +       virtqueue_kick(vq);
> +       if (ret == 0)
> +               ret = vq->num_free;
> +       return ret;
> +}
> +
> +/* Send a control message with message type either
> + *
> + * - VIRTIO_CAN_SET_CTRL_MODE_START or
> + * - VIRTIO_CAN_SET_CTRL_MODE_STOP.
> + *
> + * Unlike AUTOSAR CAN Driver Can_SetControllerMode() there is no requirement
> + * for this Linux driver to have an asynchronous implementation of the mode
> + * setting function so in order to keep things simple the function is
> + * implemented as synchronous function. Design pattern is
> + * virtio_console.c/__send_control_msg() & virtio_net.c/virtnet_send_command().
> + */
> +static u8 virtio_can_send_ctrl_msg(struct net_device *ndev, u16 msg_type)
> +{
> +       struct virtio_can_priv *priv = netdev_priv(ndev);
> +       struct device *dev = &priv->vdev->dev;
> +       struct virtqueue *vq = priv->vqs[VIRTIO_CAN_QUEUE_CONTROL];
> +       struct scatterlist sg_out[1];
> +       struct scatterlist sg_in[1];
> +       struct scatterlist *sgs[2];
> +       int err;
> +       unsigned int len;
> +
> +       /* The function may be serialized by rtnl lock. Not sure.
> +        * Better safe than sorry.
> +        */
> +       mutex_lock(&priv->ctrl_lock);
> +
> +       priv->cpkt_out.msg_type = cpu_to_le16(msg_type);
> +       sg_init_one(&sg_out[0], &priv->cpkt_out, sizeof(priv->cpkt_out));
> +       sg_init_one(&sg_in[0], &priv->cpkt_in, sizeof(priv->cpkt_in));
> +       sgs[0] = sg_out;
> +       sgs[1] = sg_in;
> +
> +       err = virtqueue_add_sgs(vq, sgs, 1u, 1u, priv, GFP_ATOMIC);
> +       if (err != 0) {

          if (err) {

> +               /* Not expected to happen */
> +               dev_err(dev, "%s(): virtqueue_add_sgs() failed\n", __func__);
> +       }
> +
> +       if (!virtqueue_kick(vq)) {
> +               /* Not expected to happen */
> +               dev_err(dev, "%s(): Kick failed\n", __func__);
> +       }
> +
> +       while (!virtqueue_get_buf(vq, &len) && !virtqueue_is_broken(vq))
> +               wait_for_completion(&priv->ctrl_done);
> +
> +       mutex_unlock(&priv->ctrl_lock);
> +
> +       return priv->cpkt_in.result;
> +}
> +
> +static void virtio_can_start(struct net_device *ndev)
> +{
> +       struct virtio_can_priv *priv = netdev_priv(ndev);
> +       u8 result;
> +
> +       result = virtio_can_send_ctrl_msg(ndev, VIRTIO_CAN_SET_CTRL_MODE_START);
> +       if (result != VIRTIO_CAN_RESULT_OK) {
> +               /* Not expected to happen */
> +               netdev_err(ndev, "CAN controller start failed\n");
> +       }
> +
> +       priv->busoff_pending = false;
> +       priv->can.state = CAN_STATE_ERROR_ACTIVE;
> +
> +       /* Switch carrier on if device was not connected to the bus */
> +       if (!netif_carrier_ok(ndev))
> +               netif_carrier_on(ndev);
> +}
> +
> +/* See also m_can.c/m_can_set_mode()
> + *
> + * It is interesting that not only the M-CAN implementation but also all other
> + * implementations I looked into only support CAN_MODE_START.
> + * That CAN_MODE_SLEEP is frequently not found to be supported anywhere did not
> + * come not as surprise but that CAN_MODE_STOP is also never supported was one.
> + * The function is accessible via the method pointer do_set_mode in
> + * struct can_priv. As usual no documentation there.
> + * May not play any role as grepping through the code did not reveal any place
> + * from where the method is actually called.
> + */
> +static int virtio_can_set_mode(struct net_device *dev, enum can_mode mode)
> +{
> +       switch (mode) {
> +       case CAN_MODE_START:
> +               virtio_can_start(dev);
> +               netif_wake_queue(dev);
> +               break;
> +       default:
> +               return -EOPNOTSUPP;
> +       }
> +
> +       return 0;
> +}
> +
> +/* Called by issuing "ip link set up can0" */
> +static int virtio_can_open(struct net_device *dev)
> +{
> +       /* start the virtio_can controller */
> +       virtio_can_start(dev);
> +
> +       /* RX and TX napi were already enabled in virtio_can_probe() */
> +       netif_start_queue(dev);
> +
> +       return 0;
> +}
> +
> +static void virtio_can_stop(struct net_device *ndev)
> +{
> +       struct virtio_can_priv *priv = netdev_priv(ndev);
> +       struct device *dev = &priv->vdev->dev;
> +       u8 result;
> +
> +       result = virtio_can_send_ctrl_msg(ndev, VIRTIO_CAN_SET_CTRL_MODE_STOP);
> +       if (result != VIRTIO_CAN_RESULT_OK)
> +               dev_err(dev, "CAN controller stop failed\n");
> +
> +       priv->busoff_pending = false;
> +       priv->can.state = CAN_STATE_STOPPED;
> +
> +       /* Switch carrier off if device was connected to the bus */
> +       if (netif_carrier_ok(ndev))
> +               netif_carrier_off(ndev);
> +}
> +
> +static int virtio_can_close(struct net_device *dev)
> +{
> +       netif_stop_queue(dev);
> +       /* Keep RX napi active to allow dropping of pending RX CAN messages,
> +        * keep TX napi active to allow processing of cancelled CAN messages
> +        */
> +       virtio_can_stop(dev);
> +       close_candev(dev);
> +
> +       return 0;
> +}
> +
> +static netdev_tx_t virtio_can_start_xmit(struct sk_buff *skb,
> +                                        struct net_device *dev)
> +{
> +       struct virtio_can_priv *priv = netdev_priv(dev);
> +       struct canfd_frame *cf = (struct canfd_frame *)skb->data;
> +       struct virtio_can_tx *can_tx_msg;
> +       struct virtqueue *vq = priv->vqs[VIRTIO_CAN_QUEUE_TX];
> +       struct scatterlist sg_out[1];
> +       struct scatterlist sg_in[1];
> +       struct scatterlist *sgs[2];

Instead declaring two times an array of 1, can we do:

        struct scatterlist sgs[2];

and then use sgs[0] for out and sgs[1] for in?

Or, if you really want to keep sg_out and sg_in, at least do:

          struct scatterlist sg_out, sg_in;
          struct scatterlist *sgs[] = {&sg_out, &sg_in};

N.B. The same comment also applies to the other places where you are
doing some sg[1] declarations.

> +       unsigned long flags;
> +       u32 can_flags;
> +       int err;
> +       int putidx;
> +       netdev_tx_t xmit_ret = NETDEV_TX_OK;
> +       const unsigned int hdr_size = offsetof(struct virtio_can_tx_out, sdu);
> +
> +       if (can_dev_dropped_skb(dev, skb))
> +               goto kick; /* No way to return NET_XMIT_DROP here */
> +
> +       /* No local check for CAN_RTR_FLAG or FD frame against negotiated
> +        * features. The device will reject those anyway if not supported.
> +        */
> +
> +       can_tx_msg = kzalloc(sizeof(*can_tx_msg), GFP_ATOMIC);
> +       if (!can_tx_msg)
> +               goto kick; /* No way to return NET_XMIT_DROP here */
> +
> +       can_tx_msg->tx_out.msg_type = cpu_to_le16(VIRTIO_CAN_TX);
> +       can_flags = 0;
> +
> +       if (cf->can_id & CAN_EFF_FLAG) {
> +               can_flags |= VIRTIO_CAN_FLAGS_EXTENDED;
> +               can_tx_msg->tx_out.can_id = cpu_to_le32(cf->can_id & CAN_EFF_MASK);
> +       } else {
> +               can_tx_msg->tx_out.can_id = cpu_to_le32(cf->can_id & CAN_SFF_MASK);
> +       }
> +       if (cf->can_id & CAN_RTR_FLAG)
> +               can_flags |= VIRTIO_CAN_FLAGS_RTR;
> +       else
> +               memcpy(can_tx_msg->tx_out.sdu, cf->data, cf->len);
> +       if (can_is_canfd_skb(skb))
> +               can_flags |= VIRTIO_CAN_FLAGS_FD;
> +
> +       can_tx_msg->tx_out.flags = cpu_to_le32(can_flags);
> +       can_tx_msg->tx_out.length = cpu_to_le16(cf->len);
> +
> +       /* Prepare sending of virtio message */
> +       sg_init_one(&sg_out[0], &can_tx_msg->tx_out, hdr_size + cf->len);
> +       sg_init_one(&sg_in[0], &can_tx_msg->tx_in, sizeof(can_tx_msg->tx_in));
> +       sgs[0] = sg_out;
> +       sgs[1] = sg_in;
> +
> +       putidx = virtio_can_alloc_tx_idx(priv);
> +
> +       if (unlikely(putidx < 0)) {
> +               netif_stop_queue(dev);
> +               kfree(can_tx_msg);
> +               netdev_warn(dev, "TX: Stop queue, no putidx available\n");

ida_alloc_range() can also return -ENOMEM. So the error is not
necessarily because of no putidx available. Maybe better to print the
error message (with %pe to show the mnemotechnic).

> +               xmit_ret = NETDEV_TX_BUSY;
> +               goto kick;
> +       }
> +
> +       can_tx_msg->putidx = (unsigned int)putidx;
> +
> +       /* Protect list operation */
> +       spin_lock_irqsave(&priv->tx_lock, flags);
> +       list_add_tail(&can_tx_msg->list, &priv->tx_list);
> +       spin_unlock_irqrestore(&priv->tx_lock, flags);
> +
> +       /* Push loopback echo. Will be looped back on TX interrupt/TX NAPI */
> +       can_put_echo_skb(skb, dev, can_tx_msg->putidx, 0);
> +
> +       /* Protect queue and list operations */
> +       spin_lock_irqsave(&priv->tx_lock, flags);
> +       err = virtqueue_add_sgs(vq, sgs, 1u, 1u, can_tx_msg, GFP_ATOMIC);
> +       if (err != 0) { /* unlikely when vq->num_free was considered */
> +               list_del(&can_tx_msg->list);
> +               can_free_echo_skb(dev, can_tx_msg->putidx, NULL);
> +               virtio_can_free_tx_idx(priv, can_tx_msg->putidx);
> +               spin_unlock_irqrestore(&priv->tx_lock, flags);
> +               netif_stop_queue(dev);
> +               kfree(can_tx_msg);
> +               if (err == -ENOSPC)
> +                       netdev_dbg(dev, "TX: Stop queue, no space left\n");
> +               else
> +                       netdev_warn(dev, "TX: Stop queue, reason = %d\n", err);
> +               xmit_ret = NETDEV_TX_BUSY;
> +               goto kick;
> +       }
> +
> +       /* Normal queue stop when no transmission slots are left */
> +       if (atomic_read(&priv->tx_inflight) >= priv->can.echo_skb_max ||
> +           vq->num_free == 0 || (vq->num_free < 2 &&

Replace the Magic number 2 with a #define.

> +           !virtio_has_feature(vq->vdev, VIRTIO_RING_F_INDIRECT_DESC))) {
> +               netif_stop_queue(dev);
> +               netdev_dbg(dev, "TX: Normal stop queue\n");
> +       }
> +
> +       spin_unlock_irqrestore(&priv->tx_lock, flags);
> +
> +kick:
> +       if (netif_queue_stopped(dev) || !netdev_xmit_more()) {
> +               if (!virtqueue_kick(vq))
> +                       netdev_err(dev, "%s(): Kick failed\n", __func__);
> +       }
> +
> +       return xmit_ret;
> +}
> +
> +static const struct net_device_ops virtio_can_netdev_ops = {
> +       .ndo_open = virtio_can_open,
> +       .ndo_stop = virtio_can_close,
> +       .ndo_start_xmit = virtio_can_start_xmit,
> +       .ndo_change_mtu = can_change_mtu,
> +};
> +
> +static int register_virtio_can_dev(struct net_device *dev)
> +{
> +       dev->flags |= IFF_ECHO; /* we support local echo */
> +       dev->netdev_ops = &virtio_can_netdev_ops;
> +
> +       return register_candev(dev);
> +}
> +
> +/* Compare with m_can.c/m_can_echo_tx_event() */
> +static int virtio_can_read_tx_queue(struct virtqueue *vq)
> +{
> +       struct virtio_can_priv *can_priv = vq->vdev->priv;
> +       struct net_device *dev = can_priv->dev;
> +       struct net_device_stats *stats = &dev->stats;
> +       struct virtio_can_tx *can_tx_msg;
> +       unsigned long flags;
> +       unsigned int len;
> +       u8 result;
> +
> +       /* Protect list and virtio queue operations */
> +       spin_lock_irqsave(&can_priv->tx_lock, flags);
> +
> +       can_tx_msg = virtqueue_get_buf(vq, &len);
> +       if (!can_tx_msg) {
> +               spin_unlock_irqrestore(&can_priv->tx_lock, flags);
> +               return 0; /* No more data */
> +       }
> +
> +       if (unlikely(len < sizeof(struct virtio_can_tx_in))) {
> +               netdev_err(dev, "TX ACK: Device sent no result code\n");
> +               result = VIRTIO_CAN_RESULT_NOT_OK; /* Keep things going */
> +       } else {
> +               result = can_tx_msg->tx_in.result;
> +       }
> +
> +       if (can_priv->can.state < CAN_STATE_BUS_OFF) {
> +               /* Here also frames with result != VIRTIO_CAN_RESULT_OK are
> +                * echoed. Intentional to bring a waiting process in an upper
> +                * layer to an end.
> +                * TODO: Any better means to indicate a problem here?
> +                */
> +               if (result != VIRTIO_CAN_RESULT_OK)
> +                       netdev_warn(dev, "TX ACK: Result = %u\n", result);
> +
> +               stats->tx_bytes += can_get_echo_skb(dev, can_tx_msg->putidx,
> +                                                   NULL);
> +               stats->tx_packets++;
> +       } else {
> +               netdev_dbg(dev, "TX ACK: Controller inactive, drop echo\n");
> +               can_free_echo_skb(dev, can_tx_msg->putidx, NULL);
> +       }
> +
> +       list_del(&can_tx_msg->list);
> +       virtio_can_free_tx_idx(can_priv, can_tx_msg->putidx);
> +
> +       spin_unlock_irqrestore(&can_priv->tx_lock, flags);
> +
> +       kfree(can_tx_msg);
> +
> +       /* Flow control */
> +       if (netif_queue_stopped(dev)) {
> +               netdev_dbg(dev, "TX ACK: Wake up stopped queue\n");
> +               netif_wake_queue(dev);
> +       }
> +
> +       return 1; /* Queue was not empty so there may be more data */
> +}
> +
> +/* Poll TX used queue for sent CAN messages
> + * See https://wiki.linuxfoundation.org/networking/napi function
> + * int (*poll)(struct napi_struct *napi, int budget);
> + */
> +static int virtio_can_tx_poll(struct napi_struct *napi, int quota)
> +{
> +       struct net_device *dev = napi->dev;
> +       struct virtio_can_priv *priv = netdev_priv(dev);
> +       struct virtqueue *vq = priv->vqs[VIRTIO_CAN_QUEUE_TX];
> +       int work_done = 0;
> +
> +       while (work_done < quota && virtio_can_read_tx_queue(vq) != 0)
> +               work_done++;
> +
> +       if (work_done < quota)
> +               virtqueue_napi_complete(napi, vq, work_done);
> +
> +       return work_done;
> +}
> +
> +static void virtio_can_tx_intr(struct virtqueue *vq)
> +{
> +       struct virtio_can_priv *can_priv = vq->vdev->priv;
> +
> +       virtqueue_disable_cb(vq);
> +       napi_schedule(&can_priv->napi_tx);
> +}
> +
> +/* This function is the NAPI RX poll function and NAPI guarantees that this
> + * function is not invoked simultaneously on multiple processors.
> + * Read a RX message from the used queue and sends it to the upper layer.
> + * (See also m_can.c / m_can_read_fifo()).
> + */
> +static int virtio_can_read_rx_queue(struct virtqueue *vq)
> +{
> +       struct virtio_can_priv *priv = vq->vdev->priv;
> +       struct net_device *dev = priv->dev;
> +       struct net_device_stats *stats = &dev->stats;
> +       struct virtio_can_rx *can_rx;
> +       struct canfd_frame *cf;
> +       struct sk_buff *skb;
> +       unsigned int transport_len;
> +       unsigned int len;
> +       const unsigned int header_size = offsetof(struct virtio_can_rx, sdu);
> +       u16 msg_type;
> +       u32 can_flags;
> +       u32 can_id;
> +
> +       can_rx = virtqueue_get_buf(vq, &transport_len);
> +       if (!can_rx)
> +               return 0; /* No more data */
> +
> +       if (transport_len < header_size) {
> +               netdev_warn(dev, "RX: Message too small\n");
> +               goto putback;
> +       }
> +
> +       if (priv->can.state >= CAN_STATE_ERROR_PASSIVE) {
> +               netdev_dbg(dev, "%s(): Controller not active\n", __func__);
> +               goto putback;
> +       }
> +
> +       msg_type = le16_to_cpu(can_rx->msg_type);
> +       if (msg_type != VIRTIO_CAN_RX) {
> +               netdev_warn(dev, "RX: Got unknown msg_type %04x\n", msg_type);
> +               goto putback;
> +       }
> +
> +       len = le16_to_cpu(can_rx->length);
> +       can_flags = le32_to_cpu(can_rx->flags);
> +       can_id = le32_to_cpu(can_rx->can_id);
> +
> +       if (can_flags & ~CAN_KNOWN_FLAGS) {
> +               stats->rx_dropped++;
> +               netdev_warn(dev, "RX: CAN Id 0x%08x: Invalid flags 0x%x\n",
> +                           can_id, can_flags);
> +               goto putback;
> +       }
> +
> +       if (can_flags & VIRTIO_CAN_FLAGS_EXTENDED) {
> +               can_id &= CAN_EFF_MASK;
> +               can_id |= CAN_EFF_FLAG;
> +       } else {
> +               can_id &= CAN_SFF_MASK;
> +       }
> +
> +       if (can_flags & VIRTIO_CAN_FLAGS_RTR) {
> +               if (!virtio_has_feature(vq->vdev, VIRTIO_CAN_F_RTR_FRAMES)) {
> +                       stats->rx_dropped++;
> +                       netdev_warn(dev, "RX: CAN Id 0x%08x: RTR not negotiated\n",
> +                                   can_id);
> +                       goto putback;
> +               }
> +               if (can_flags & VIRTIO_CAN_FLAGS_FD) {
> +                       stats->rx_dropped++;
> +                       netdev_warn(dev, "RX: CAN Id 0x%08x: RTR with FD not possible\n",
> +                                   can_id);
> +                       goto putback;
> +               }
> +
> +               if (len > 0xF) {
> +                       stats->rx_dropped++;
> +                       netdev_warn(dev, "RX: CAN Id 0x%08x: RTR with DLC > 0xF\n",
> +                                   can_id);
> +                       goto putback;
> +               }
> +
> +               if (len > 0x8)
> +                       len = 0x8;
> +
> +               can_id |= CAN_RTR_FLAG;
> +       }
> +
> +       if (transport_len < header_size + len) {
> +               netdev_warn(dev, "RX: Message too small for payload\n");
> +               goto putback;
> +       }
> +
> +       if (can_flags & VIRTIO_CAN_FLAGS_FD) {
> +               if (!virtio_has_feature(vq->vdev, VIRTIO_CAN_F_CAN_FD)) {
> +                       stats->rx_dropped++;
> +                       netdev_warn(dev, "RX: CAN Id 0x%08x: FD not negotiated\n",
> +                                   can_id);
> +                       goto putback;
> +               }
> +
> +               if (len > CANFD_MAX_DLEN)
> +                       len = CANFD_MAX_DLEN;
> +
> +               skb = alloc_canfd_skb(priv->dev, &cf);
> +       } else {
> +               if (!virtio_has_feature(vq->vdev, VIRTIO_CAN_F_CAN_CLASSIC)) {
> +                       stats->rx_dropped++;
> +                       netdev_warn(dev, "RX: CAN Id 0x%08x: classic not negotiated\n",
> +                                   can_id);
> +                       goto putback;
> +               }
> +
> +               if (len > CAN_MAX_DLEN)
> +                       len = CAN_MAX_DLEN;
> +
> +               skb = alloc_can_skb(priv->dev, (struct can_frame **)&cf);
> +       }
> +       if (!skb) {
> +               stats->rx_dropped++;
> +               netdev_warn(dev, "RX: No skb available\n");
> +               goto putback;
> +       }
> +
> +       cf->can_id = can_id;
> +       cf->len = len;
> +       if (!(can_flags & VIRTIO_CAN_FLAGS_RTR)) {
> +               /* RTR frames have a DLC but no payload */
> +               memcpy(cf->data, can_rx->sdu, len);
> +       }
> +
> +       if (netif_receive_skb(skb) == NET_RX_SUCCESS) {
> +               stats->rx_packets++;
> +               if (!(can_flags & VIRTIO_CAN_FLAGS_RTR))
> +                       stats->rx_bytes += cf->len;
> +       }
> +
> +putback:
> +       /* Put processed RX buffer back into avail queue */
> +       virtio_can_add_inbuf(vq, can_rx, sizeof(struct virtio_can_rx));
> +
> +       return 1; /* Queue was not empty so there may be more data */
> +}
> +
> +/* See m_can_poll() / m_can_handle_state_errors() m_can_handle_state_change() */
> +static int virtio_can_handle_busoff(struct net_device *dev)
> +{
> +       struct virtio_can_priv *priv = netdev_priv(dev);
> +       struct can_frame *cf;
> +       struct sk_buff *skb;
> +
> +       if (!priv->busoff_pending)
> +               return 0;
> +
> +       if (priv->can.state < CAN_STATE_BUS_OFF) {
> +               netdev_dbg(dev, "entered error bus off state\n");
> +
> +               /* bus-off state */
> +               priv->can.state = CAN_STATE_BUS_OFF;
> +               priv->can.can_stats.bus_off++;
> +               can_bus_off(dev);
> +       }
> +
> +       /* propagate the error condition to the CAN stack */
> +       skb = alloc_can_err_skb(dev, &cf);
> +       if (unlikely(!skb))
> +               return 0;
> +
> +       /* bus-off state */
> +       cf->can_id |= CAN_ERR_BUSOFF;
> +
> +       /* Ensure that the BusOff indication does not get lost */
> +       if (netif_receive_skb(skb) == NET_RX_SUCCESS)
> +               priv->busoff_pending = false;
> +
> +       return 1;
> +}
> +
> +/* Poll RX used queue for received CAN messages
> + * See https://wiki.linuxfoundation.org/networking/napi function
> + * int (*poll)(struct napi_struct *napi, int budget);
> + * Important: "The networking subsystem promises that poll() will not be
> + * invoked simultaneously (for the same napi_struct) on multiple processors"
> + */
> +static int virtio_can_rx_poll(struct napi_struct *napi, int quota)
> +{
> +       struct net_device *dev = napi->dev;
> +       struct virtio_can_priv *priv = netdev_priv(dev);
> +       struct virtqueue *vq = priv->vqs[VIRTIO_CAN_QUEUE_RX];
> +       int work_done = 0;
> +
> +       work_done += virtio_can_handle_busoff(dev);
> +
> +       while (work_done < quota && virtio_can_read_rx_queue(vq) != 0)
> +               work_done++;
> +
> +       if (work_done < quota)
> +               virtqueue_napi_complete(napi, vq, work_done);
> +
> +       return work_done;
> +}
> +
> +static void virtio_can_rx_intr(struct virtqueue *vq)
> +{
> +       struct virtio_can_priv *can_priv = vq->vdev->priv;
> +
> +       virtqueue_disable_cb(vq);
> +       napi_schedule(&can_priv->napi);
> +}
> +
> +static void virtio_can_control_intr(struct virtqueue *vq)
> +{
> +       struct virtio_can_priv *can_priv = vq->vdev->priv;
> +
> +       complete(&can_priv->ctrl_done);
> +}
> +
> +static void virtio_can_config_changed(struct virtio_device *vdev)
> +{
> +       struct virtio_can_priv *can_priv = vdev->priv;
> +       u16 status;
> +
> +       status = virtio_cread16(vdev, offsetof(struct virtio_can_config,
> +                                              status));
> +
> +       if (!(status & VIRTIO_CAN_S_CTRL_BUSOFF))
> +               return;
> +
> +       if (!can_priv->busoff_pending &&
> +           can_priv->can.state < CAN_STATE_BUS_OFF) {
> +               can_priv->busoff_pending = true;
> +               napi_schedule(&can_priv->napi);
> +       }
> +}
> +
> +static void virtio_can_populate_vqs(struct virtio_device *vdev)
> +
> +{
> +       struct virtio_can_priv *priv = vdev->priv;
> +       struct virtqueue *vq;
> +       unsigned int idx;
> +       int ret;
> +
> +       /* Fill RX queue */
> +       vq = priv->vqs[VIRTIO_CAN_QUEUE_RX];
> +       for (idx = 0; idx < ARRAY_SIZE(priv->rpkt); idx++) {
> +               ret = virtio_can_add_inbuf(vq, &priv->rpkt[idx],
> +                                          sizeof(struct virtio_can_rx));
> +               if (ret < 0) {
> +                       dev_dbg(&vdev->dev, "rpkt fill: ret=%d, idx=%u\n",
> +                               ret, idx);
> +                       break;
> +               }
> +       }
> +       dev_dbg(&vdev->dev, "%u rpkt added\n", idx);
> +}
> +
> +static int virtio_can_find_vqs(struct virtio_can_priv *priv)
> +{
> +       /* The order of RX and TX is exactly the opposite as in console and
> +        * network. Does not play any role but is a bad trap.
> +        */
> +       static const char * const io_names[VIRTIO_CAN_QUEUE_COUNT] = {
> +               "can-tx",
> +               "can-rx",
> +               "can-state-ctrl"
> +       };
> +
> +       priv->io_callbacks[VIRTIO_CAN_QUEUE_TX] = virtio_can_tx_intr;
> +       priv->io_callbacks[VIRTIO_CAN_QUEUE_RX] = virtio_can_rx_intr;
> +       priv->io_callbacks[VIRTIO_CAN_QUEUE_CONTROL] = virtio_can_control_intr;
> +
> +       /* Find the queues. */
> +       return virtio_find_vqs(priv->vdev, VIRTIO_CAN_QUEUE_COUNT, priv->vqs,
> +                              priv->io_callbacks, io_names, NULL);
> +}
> +
> +/* Function must not be called before virtio_can_find_vqs() has been run */
> +static void virtio_can_del_vq(struct virtio_device *vdev)
> +{
> +       struct virtio_can_priv *priv = vdev->priv;
> +       struct list_head *cursor, *next;
> +       struct virtqueue *vq;
> +
> +       /* Reset the device */
> +       if (vdev->config->reset)
> +               vdev->config->reset(vdev);
> +
> +       /* From here we have dead silence from the device side so no locks
> +        * are needed to protect against device side events.
> +        */
> +
> +       vq = priv->vqs[VIRTIO_CAN_QUEUE_CONTROL];
> +       while (virtqueue_detach_unused_buf(vq))
> +               ; /* Do nothing, content allocated statically */
> +
> +       vq = priv->vqs[VIRTIO_CAN_QUEUE_RX];
> +       while (virtqueue_detach_unused_buf(vq))
> +               ; /* Do nothing, content allocated statically */
> +
> +       vq = priv->vqs[VIRTIO_CAN_QUEUE_TX];
> +       while (virtqueue_detach_unused_buf(vq))
> +               ; /* Do nothing, content to be de-allocated separately */
> +
> +       /* Is keeping track of allocated elements by an own linked list
> +        * really necessary or may this be optimized using only
> +        * virtqueue_detach_unused_buf()?
> +        */
> +       list_for_each_safe(cursor, next, &priv->tx_list) {
> +               struct virtio_can_tx *can_tx;
> +
> +               can_tx = list_entry(cursor, struct virtio_can_tx, list);
> +               list_del(cursor);
> +               kfree(can_tx);
> +       }
> +
> +       if (vdev->config->del_vqs)
> +               vdev->config->del_vqs(vdev);
> +}
> +
> +/* See virtio_net.c/virtnet_remove() and also m_can.c/m_can_plat_remove() */
> +static void virtio_can_remove(struct virtio_device *vdev)
> +{
> +       struct virtio_can_priv *priv = vdev->priv;
> +       struct net_device *dev = priv->dev;
> +
> +       unregister_candev(dev);
> +
> +       /* No calls of netif_napi_del() needed as free_candev() will do this */
> +
> +       virtio_can_del_vq(vdev);
> +
> +       virtio_can_free_candev(dev);
> +}
> +
> +static int virtio_can_validate(struct virtio_device *vdev)
> +{
> +       /* CAN needs always access to the config space.
> +        * Check that the driver can access the config space
> +        */
> +       if (!vdev->config->get) {
> +               dev_err(&vdev->dev, "%s failure: config access disabled\n",
> +                       __func__);
> +               return -EINVAL;
> +       }
> +
> +       if (!virtio_has_feature(vdev, VIRTIO_F_VERSION_1)) {
> +               dev_err(&vdev->dev,
> +                       "device does not comply with spec version 1.x\n");
> +               return -EINVAL;
> +       }
> +
> +       return 0;
> +}
> +
> +static int virtio_can_probe(struct virtio_device *vdev)
> +{
> +       struct net_device *dev;
> +       struct virtio_can_priv *priv;
> +       int err;
> +
> +       dev = alloc_candev(sizeof(struct virtio_can_priv),
> +                          VIRTIO_CAN_ECHO_SKB_MAX);
> +       if (!dev)
> +               return -ENOMEM;
> +
> +       priv = netdev_priv(dev);
> +
> +       ida_init(&priv->tx_putidx_ida);
> +
> +       netif_napi_add(dev, &priv->napi, virtio_can_rx_poll);
> +       netif_napi_add(dev, &priv->napi_tx, virtio_can_tx_poll);
> +
> +       SET_NETDEV_DEV(dev, &vdev->dev);
> +
> +       priv->dev = dev;
> +       priv->vdev = vdev;
> +       vdev->priv = priv;
> +
> +       priv->can.do_set_mode = virtio_can_set_mode;
> +       /* Set Virtio CAN supported operations */
> +       priv->can.ctrlmode_supported = CAN_CTRLMODE_BERR_REPORTING;
> +       if (virtio_has_feature(vdev, VIRTIO_CAN_F_CAN_FD)) {
> +               err = can_set_static_ctrlmode(dev, CAN_CTRLMODE_FD);
> +               if (err != 0)
> +                       goto on_failure;
> +       }
> +
> +       /* Initialize virtqueues */
> +       err = virtio_can_find_vqs(priv);
> +       if (err != 0)
> +               goto on_failure;
> +
> +       INIT_LIST_HEAD(&priv->tx_list);
> +
> +       spin_lock_init(&priv->tx_lock);
> +       mutex_init(&priv->ctrl_lock);
> +
> +       init_completion(&priv->ctrl_done);
> +
> +       virtio_can_populate_vqs(vdev);
> +
> +       register_virtio_can_dev(dev);
> +
> +       napi_enable(&priv->napi);
> +       napi_enable(&priv->napi_tx);
> +
> +       /* Request device going live */
> +       virtio_device_ready(vdev); /* Optionally done by virtio_dev_probe() */
> +
> +       return 0;
> +
> +on_failure:
> +       virtio_can_free_candev(dev);
> +       return err;
> +}
> +
> +/* Compare with m_can.c/m_can_suspend(), virtio_net.c/virtnet_freeze() and
> + * virtio_card.c/virtsnd_freeze()
> + */
> +static int __maybe_unused virtio_can_freeze(struct virtio_device *vdev)
> +{
> +       struct virtio_can_priv *priv = vdev->priv;
> +       struct net_device *ndev = priv->dev;
> +
> +       napi_disable(&priv->napi);
> +       napi_disable(&priv->napi_tx);
> +
> +       if (netif_running(ndev)) {
> +               netif_stop_queue(ndev);
> +               netif_device_detach(ndev);
> +               virtio_can_stop(ndev);
> +       }
> +
> +       priv->can.state = CAN_STATE_SLEEPING;
> +
> +       virtio_can_del_vq(vdev);
> +
> +       return 0;
> +}
> +
> +/* Compare with m_can.c/m_can_resume(), virtio_net.c/virtnet_restore() and
> + * virtio_card.c/virtsnd_restore()
> + */
> +static int __maybe_unused virtio_can_restore(struct virtio_device *vdev)
> +{
> +       struct virtio_can_priv *priv = vdev->priv;
> +       struct net_device *ndev = priv->dev;
> +       int err;
> +
> +       err = virtio_can_find_vqs(priv);
> +       if (err != 0)
> +               return err;
> +       virtio_can_populate_vqs(vdev);
> +
> +       priv->can.state = CAN_STATE_ERROR_ACTIVE;
> +
> +       if (netif_running(ndev)) {
> +               virtio_can_start(ndev);
> +               netif_device_attach(ndev);
> +               netif_start_queue(ndev);
> +       }
> +
> +       napi_enable(&priv->napi);
> +       napi_enable(&priv->napi_tx);
> +
> +       return 0;
> +}
> +
> +static struct virtio_device_id virtio_can_id_table[] = {
> +       { VIRTIO_ID_CAN, VIRTIO_DEV_ANY_ID },
> +       { 0 },
> +};
> +
> +static unsigned int features[] = {
> +       VIRTIO_CAN_F_CAN_CLASSIC,
> +       VIRTIO_CAN_F_CAN_FD,
> +       VIRTIO_CAN_F_LATE_TX_ACK,
> +       VIRTIO_CAN_F_RTR_FRAMES,
> +};
> +
> +static struct virtio_driver virtio_can_driver = {
> +       .feature_table = features,
> +       .feature_table_size = ARRAY_SIZE(features),
> +       .driver.name = KBUILD_MODNAME,
> +       .driver.owner = THIS_MODULE,
> +       .id_table = virtio_can_id_table,
> +       .validate = virtio_can_validate,
> +       .probe = virtio_can_probe,
> +       .remove = virtio_can_remove,
> +       .config_changed = virtio_can_config_changed,
> +#ifdef CONFIG_PM_SLEEP
> +       .freeze = virtio_can_freeze,
> +       .restore = virtio_can_restore,
> +#endif
> +};
> +
> +module_virtio_driver(virtio_can_driver);
> +MODULE_DEVICE_TABLE(virtio, virtio_can_id_table);
> +
> +MODULE_AUTHOR("OpenSynergy GmbH");
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("CAN bus driver for Virtio CAN controller");
> diff --git a/include/uapi/linux/virtio_can.h b/include/uapi/linux/virtio_can.h
> new file mode 100644
> index 000000000000..f59a2ca6ebd1
> --- /dev/null
> +++ b/include/uapi/linux/virtio_can.h
> @@ -0,0 +1,71 @@
> +/* SPDX-License-Identifier: BSD-3-Clause */
> +/*
> + * Copyright (C) 2021-2023 OpenSynergy GmbH
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
> +#define VIRTIO_CAN_F_CAN_CLASSIC        0
> +#define VIRTIO_CAN_F_CAN_FD             1
> +#define VIRTIO_CAN_F_LATE_TX_ACK        2
> +#define VIRTIO_CAN_F_RTR_FRAMES         3

Why do we need both VIRTIO_CAN_F_RTR_FRAMES VIRTIO_CAN_FLAGS_RTR?

Is it to manage devices not able to sent remote frames? If so, we may
also need to add a CAN_CTRLMODE_RTR in linux/can/netlink.h?

> +
> +/* CAN Result Types */
> +#define VIRTIO_CAN_RESULT_OK            0
> +#define VIRTIO_CAN_RESULT_NOT_OK        1

Silly question, but what is the rationale of not using the error code
from errno.h?

I do see that some other virtio devices do the same:

  https://elixir.bootlin.com/linux/v4.6/source/include/uapi/linux/virtio_net.h#L140

But I am genuinely curious to understand why virtio do not use more
standard error codes.

> +/* CAN flags to determine type of CAN Id */
> +#define VIRTIO_CAN_FLAGS_EXTENDED       0x8000
> +#define VIRTIO_CAN_FLAGS_FD             0x4000
> +#define VIRTIO_CAN_FLAGS_RTR            0x2000
> +
> +struct virtio_can_config {
> +#define VIRTIO_CAN_S_CTRL_BUSOFF (1u << 0) /* Controller BusOff */
> +       /* CAN controller status */
> +       __le16 status;
> +};
> +
> +/* TX queue message types */
> +struct virtio_can_tx_out {
> +#define VIRTIO_CAN_TX                   0x0001
> +       __le16 msg_type;
> +       __le16 length; /* 0..8 CC, 0..64 CAN-FD, 0..2048 CAN-XL, 12 bits */
> +       __le32 reserved; /* May be needed in part for CAN XL priority */
> +       __le32 flags;
> +       __le32 can_id;
> +       __u8 sdu[64];
> +};
> +
> +struct virtio_can_tx_in {
> +       __u8 result;
> +};
> +
> +/* RX queue message types */
> +struct virtio_can_rx {
> +#define VIRTIO_CAN_RX                   0x0101
> +       __le16 msg_type;
> +       __le16 length; /* 0..8 CC, 0..64 CAN-FD, 0..2048 CAN-XL, 12 bits */
> +       __le32 reserved; /* May be needed in part for CAN XL priority */

Can we use this field to report the classical CAN DLC greater than 8?
If also needed by CAN XL, the field can be turned into a union.

> +       __le32 flags;
> +       __le32 can_id;
> +       __u8 sdu[64];
> +};
> +
> +/* Control queue message types */
> +struct virtio_can_control_out {
> +#define VIRTIO_CAN_SET_CTRL_MODE_START  0x0201
> +#define VIRTIO_CAN_SET_CTRL_MODE_STOP   0x0202
> +       __le16 msg_type;
> +};
> +
> +struct virtio_can_control_in {
> +       __u8 result;
> +};
> +
> +#endif /* #ifndef _LINUX_VIRTIO_VIRTIO_CAN_H */
> --
> 2.34.1
>

