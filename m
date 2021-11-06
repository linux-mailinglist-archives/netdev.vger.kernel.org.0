Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 132FA446FB2
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 19:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233608AbhKFSIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 14:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233197AbhKFSIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 14:08:13 -0400
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC61C061570;
        Sat,  6 Nov 2021 11:05:31 -0700 (PDT)
Received: by mail-ua1-x931.google.com with SMTP id i6so23287198uae.6;
        Sat, 06 Nov 2021 11:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=krTWN/ceNm/6U9BJVS8d2qvq7V/v+pe3LLg5LXbxW0Y=;
        b=GjQ6Thro5L+xcJM00WuquscV6q/JII5pY29L2fL4/2NHecF4zpJ8eOiQPMhDCEDdlI
         FOTEbuFAEAz/OlCOzA6yE2sf1dQba9JkZ9RLnz6kL1608w/GGQWDoD9LIs6q9R0LKoK8
         KP6yiY9b77a2HNrDUp4Xd0P5KZWlRn2RJV2Y19EjxIhfCyzR5qYK14IRX/5o2+pE59KO
         qQB/jKtAEuD3NEbuF/OGbrz6tjLi6fO4dNvAYe5JZ9QdSHSyNqBUoFfUEIe8DUyRxcNk
         FFY8SY/IcK3WnwWa8/bn45QObM8WLRvKqSSGFilNRdYyzMjoCNDsSbV7v/vjAM9xUWnZ
         HY2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=krTWN/ceNm/6U9BJVS8d2qvq7V/v+pe3LLg5LXbxW0Y=;
        b=xL5++5LayOqUKNt9d8SBNIQzEo2sYp6yD28fvUJmzrf5547HFTQHTHhCoQJ5ApnjYF
         pj94Uuz9rDGKVRZeCs1kAAODwdQROuEsfzFUzbndGojb8OG8VmllCVNZd2yNYCvBGOPA
         A4CcBLhOi4LyKCRwOLwd/2orAy+E1oxf4pr74mAjzdLKBLo5Dj7Eav/gHcx7SxWxP1gB
         CVvSS2RQqwwyHuxAeewhTroxo1ZOAyK7oiSnQbpFjYt48DgkXOe/aqWR7Qg/Pyt4Dkud
         /C2YRsdQrqxd/vZxcQDeoqd/b2XlgmS5bsY5Z0RsO6iUFsiLHRo2lqtx4Spwg/y73/j7
         6GfA==
X-Gm-Message-State: AOAM532EtPxvMPFV7qi8lM40mEx8VRZIeh86gRBGhL2ZILhiWFXXP30A
        r0vPX25p2W/A8wiiGGUstqMvjq1lIB/6OJZQ8Hg=
X-Google-Smtp-Source: ABdhPJz3QgoIQte5+SntN2R6Foe7pNdoxgXoFbor4tLKVG51EZAQtSqs5NOV74TDRDcvdW9EkYh2DUhlfio5c7mYmhU=
X-Received: by 2002:ab0:5925:: with SMTP id n34mr78661499uad.46.1636221930863;
 Sat, 06 Nov 2021 11:05:30 -0700 (PDT)
MIME-Version: 1.0
References: <20211101035635.26999-1-ricardo.martinez@linux.intel.com> <20211101035635.26999-5-ricardo.martinez@linux.intel.com>
In-Reply-To: <20211101035635.26999-5-ricardo.martinez@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Sat, 6 Nov 2021 21:06:33 +0300
Message-ID: <CAHNKnsSbrxXNhwaxD6PhpYni=jDy5F-_pn6nU9cprM5FCa3hug@mail.gmail.com>
Subject: Re: [PATCH v2 04/14] net: wwan: t7xx: Add port proxy infrastructure
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        chandrashekar.devegowda@intel.com,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        mika.westerberg@linux.intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        suresh.nagaraj@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 1, 2021 at 6:57 AM Ricardo Martinez
<ricardo.martinez@linux.intel.com> wrote:
> Port-proxy provides a common interface to interact with different types
> of ports. Ports export their configuration via `struct t7xx_port` and
> operate as defined by `struct port_ops`.

[skipped]

> diff --git a/drivers/net/wwan/t7xx/t7xx_port.h b/drivers/net/wwan/t7xx/t7xx_port.h
> ...
> +struct t7xx_port {
> +       /* members used for initialization, do not change the order */

As already suggested by Andy, use C99 initializers to initialize the
md_ccci_ports array and drop the above comment about the strict order
requirements.

> +       enum ccci_ch            tx_ch;
> +       enum ccci_ch            rx_ch;
> +       unsigned char           txq_index;
> +       unsigned char           rxq_index;
> +       unsigned char           txq_exp_index;
> +       unsigned char           rxq_exp_index;
> +       enum cldma_id           path_id;
> +       unsigned int            flags;
> +       struct port_ops         *ops;
> +       unsigned int            minor;
> +       char                    *name;

Why did you need these two fields with the port name and minor number?
The WWAN subsystem will care about these data for you. It is its
purpose.

> +       enum wwan_port_type     mtk_port_type;
> +
> +       /* members un-initialized in definition */
> +       struct wwan_port        *mtk_wwan_port;
> +       struct mtk_pci_dev      *mtk_dev;
> +       struct device           *dev;
> +       short                   seq_nums[2];
> +       struct port_proxy       *port_proxy;
> +       atomic_t                usage_cnt;
> +       struct                  list_head entry;
> +       struct                  list_head queue_entry;
> +       unsigned int            major;
> +       unsigned int            minor_base;
> +       /* TX and RX flows are asymmetric since ports are multiplexed on
> +        * queues.
> +        *
> +        * TX: data blocks are sent directly to a queue. Each port
> +        * does not maintain a TX list; instead, they only provide
> +        * a wait_queue_head for blocking writes.
> +        *
> +        * RX: Each port uses a RX list to hold packets,
> +        * allowing the modem to dispatch RX packet as quickly as possible.
> +        */
> +       struct sk_buff_head     rx_skb_list;
> +       bool                    skb_from_pool;
> +       spinlock_t              port_update_lock; /* protects port configuration */
> +       wait_queue_head_t       rx_wq;
> +       int                     rx_length_th;
> +       port_skb_handler        skb_handler;
> +       unsigned char           chan_enable;
> +       unsigned char           chn_crt_stat;
> +       struct cdev             *cdev;
> +       struct task_struct      *thread;
> +       struct mutex            tx_mutex_lock; /* protects the seq number operation */
> +};

You should split the t7xx_port structure at least for two parts. A
first part with static configuration can remain in the structure and
statically initialized in the md_ccci_ports array. All non-shareable
runtime state fields (e.g. SKB lists, pointers to dynamically
allocated device instance structures) should be moved to a device
state container.

[skipped]

> diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.c b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
> ...
> +#define PORT_NETLINK_MSG_MAX_PAYLOAD           32
> +#define PORT_NOTIFY_PROTOCOL                   NETLINK_USERSOCK

There is a clear statement in the include/uapi/linux/netlink.h file
that NETLINK_USERSOCK is reserved for user mode socket protocols.
Please do not abuse netlink protocol numbers.

If you really need a special Netlink interface to communicate with
userspace, consider creating a new generic netlink family. But it
looks like all the Netlink stuff here is a leftover of a debug
interface that was used at an earlier driver development stage. So I
suggest to just remove all Netlink usage here and consider using
dynamic debug logging, or switch to the kernel tracing.

> ...
> +static struct port_proxy *port_prox;

This is another one pointer that should be placed into a device
runtime state structure to avoid driver crash with multiple modems.

> ...
> +static struct port_ops dummy_port_ops;

Why do you need this dummy ops structure? You anyway remove it in the
next patch. If you need it as a placeholder for the md_ccci_ports
array below, then it is safe to define an empty md_ccci_ports array
and then just fill it. Please consider removing this structure to
avoid ping-pong changes.

> +static struct t7xx_port md_ccci_ports[] = {
> +       {0, 0, 0, 0, 0, 0, ID_CLDMA1, 0, &dummy_port_ops, 0xff, "dummy_port",},

As already suggested by Andy, use C99 initializers here. E.g.

        {
                .tx_ch = 0,
                .rx_ch = 0,
                .txq_index = 0,
                .rxq_index = 0,
                .txq_exp_index = 0,
                .rxq_exp_index = 0,
                .path_id = ID_CLDMA1,
                .ops = &dummy_port_ops,
                .name = "dummy_port",
        }, {
               ...
       }, {
               ...
       }

> ...
> +/* Sequence numbering to track for lost packets */
> +void port_proxy_set_seq_num(struct t7xx_port *port, struct ccci_header *ccci_h)
> +{
> +       if (ccci_h && port) {
> +               ccci_h->status &= ~HDR_FLD_SEQ;
> +               ccci_h->status |= FIELD_PREP(HDR_FLD_SEQ, port->seq_nums[MTK_OUT]);
> +               ccci_h->status &= ~HDR_FLD_AST;
> +               ccci_h->status |= FIELD_PREP(HDR_FLD_AST, 1);
> +       }

Endians handling required here.

> +}
> +
> +static u16 port_check_rx_seq_num(struct t7xx_port *port, struct ccci_header *ccci_h)
> +{
> +       u16 channel, seq_num, assert_bit;
> +
> +       channel = FIELD_GET(HDR_FLD_CHN, ccci_h->status);
> +       seq_num = FIELD_GET(HDR_FLD_SEQ, ccci_h->status);
> +       assert_bit = FIELD_GET(HDR_FLD_AST, ccci_h->status);

Field endians handling is missed here. Probably you should first
convert status field data to CPU endians and only then parse it. E.g.

        u32 status = le32_to_cpu(ccci_h->status);

        channel = FIELD_GET(HDR_FLD_CHN, status);
        seq_num = FIELD_GET(HDR_FLD_SEQ, status);
        assert_bit = FIELD_GET(HDR_FLD_AST, status);

> +       if (assert_bit && port->seq_nums[MTK_IN] &&
> +           ((seq_num - port->seq_nums[MTK_IN]) & CHECK_RX_SEQ_MASK) != 1) {
> +               dev_err(port->dev, "channel %d seq number out-of-order %d->%d (data: %X, %X)\n",
> +                       channel, seq_num, port->seq_nums[MTK_IN],
> +                       ccci_h->data[0], ccci_h->data[1]);

dev_err_ratelimited() ?

> +       }
> +
> +       return seq_num;
> +}
> ...
> +int port_recv_skb(struct t7xx_port *port, struct sk_buff *skb)
> +{
> ...
> +       if (port->flags & PORT_F_RX_ALLOW_DROP) {
> +               dev_err(port->dev, "port %s RX full, drop packet\n", port->name);

Should the ratelimited variant be used here? And why is so high
message level used?

> +               return -ENETDOWN;

Why ENETDOWN on buffer space exhaustion?

> +       }
> +
> +       return -ENOBUFS;
> +}
> ...
> +int port_proxy_send_skb(struct t7xx_port *port, struct sk_buff *skb, bool from_pool)
> +{
> +       struct ccci_header *ccci_h;
> ...
> +       ccci_h = (struct ccci_header *)(skb->data);
> ...
> +       port_proxy_set_seq_num(port, (struct ccci_header *)ccci_h);

cchi_h is already of type ccci_header, no casting is required here.

> ...
> +
> +/* inject CCCI message to modem */
> +void port_proxy_send_msg_to_md(int ch, unsigned int msg, unsigned int resv)

This function is not called by any code in this patch. Should the
function be moved to the "net: wwan: t7xx: Add control port" patch
along with the ctrl_msg_header structure definition?

> +{
> +       struct ctrl_msg_header *ctrl_msg_h;
> +       struct ccci_header *ccci_h;
> +       struct t7xx_port *port;
> +       struct sk_buff *skb;
> +       int ret;
> +
> +       port = port_get_by_ch(ch);
> +       if (!port)
> +               return;
> +
> +       skb = ccci_alloc_skb_from_pool(&port->mtk_dev->pools, sizeof(struct ccci_header),
> +                                      GFS_BLOCKING);
> +       if (!skb)
> +               return;
> +
> +       if (ch == CCCI_CONTROL_TX) {
> +               ccci_h = (struct ccci_header *)(skb->data);
> +               ccci_h->data[0] = CCCI_HEADER_NO_DATA;
> +               ccci_h->data[1] = sizeof(struct ctrl_msg_header) + CCCI_H_LEN;
> +               ccci_h->status &= ~HDR_FLD_CHN;
> +               ccci_h->status |= FIELD_PREP(HDR_FLD_CHN, ch);
> +               ccci_h->reserved = 0;
> +               ctrl_msg_h = (struct ctrl_msg_header *)(skb->data + CCCI_H_LEN);
> +               ctrl_msg_h->data_length = 0;
> +               ctrl_msg_h->reserved = resv;
> +               ctrl_msg_h->ctrl_msg_id = msg;
> +               skb_put(skb, CCCI_H_LEN + sizeof(struct ctrl_msg_header));
> +       } else {
> +               ccci_h = skb_put(skb, sizeof(struct ccci_header));
> +               ccci_h->data[0] = CCCI_HEADER_NO_DATA;
> +               ccci_h->data[1] = msg;
> +               ccci_h->status &= ~HDR_FLD_CHN;
> +               ccci_h->status |= FIELD_PREP(HDR_FLD_CHN, ch);
> +               ccci_h->reserved = resv;
> +       }

Endians handling missed here as well.

> +       ret = port_proxy_send_skb(port, skb, port->skb_from_pool);
> +       if (ret) {
> +               dev_err(port->dev, "port%s send to MD fail\n", port->name);
> +               ccci_free_skb(&port->mtk_dev->pools, skb);
> +       }
> +}
> ...
> +static int proxy_register_char_dev(void)
> +{
> +       dev_t dev = 0;
> +       int ret;
> +
> +       if (port_prox->major) {
> +               dev = MKDEV(port_prox->major, port_prox->minor_base);
> +               ret = register_chrdev_region(dev, TTY_IPC_MINOR_BASE, MTK_DEV_NAME);
> +       } else {
> +               ret = alloc_chrdev_region(&dev, port_prox->minor_base,
> +                                         TTY_IPC_MINOR_BASE, MTK_DEV_NAME);
> +               if (ret)
> +                       dev_err(port_prox->dev, "failed to alloc chrdev region, ret=%d\n", ret);
> +
> +               port_prox->major = MAJOR(dev);
> +       }

For what do you need these character devices? The WWAN subsystem
already handle all these tasks.

> +       return ret;
> +}
> ...
> +static int proxy_alloc(struct mtk_modem *md)
> +{
> +       int ret;
> +
> +       port_prox = devm_kzalloc(&md->mtk_dev->pdev->dev, sizeof(*port_prox), GFP_KERNEL);
> +       if (!port_prox)
> +               return -ENOMEM;

This pointer should be placed into the mtk_modem, not to a global variable.

> ...
> +int port_proxy_broadcast_state(struct t7xx_port *port, int state)
> +{
> +       char msg[PORT_NETLINK_MSG_MAX_PAYLOAD];
> +
> +       if (state >= MTK_PORT_STATE_INVALID)
> +               return -EINVAL;
> +
> +       switch (state) {
> +       case MTK_PORT_STATE_ENABLE:
> +               snprintf(msg, PORT_NETLINK_MSG_MAX_PAYLOAD, "enable %s", port->name);
> +               break;
> +
> +       case MTK_PORT_STATE_DISABLE:
> +               snprintf(msg, PORT_NETLINK_MSG_MAX_PAYLOAD, "disable %s", port->name);
> +               break;
> +
> +       default:
> +               snprintf(msg, PORT_NETLINK_MSG_MAX_PAYLOAD, "invalid operation");
> +               break;
> +       }
> +
> +       return port_netlink_send_msg(port, PORT_STATE_BROADCAST_GROUP, msg, strlen(msg) + 1);

Netlink by nature is a binary protocol. You need to emit messages of
different types per port state with a port name attribute inside. Or
emit a single type message with two separate attributes: one to carry
a port state and a separate attribute to carry a port name.

Or, as I suggested above, just drop this Netlink abuse and switch to
dynamic debug logging. Or even better, consider switching to the
kernel tracing API.

[skipped]

> diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.h b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
> ...
> +struct ctrl_msg_header {
> +       u32                     ctrl_msg_id;
> +       u32                     reserved;
> +       u32                     data_length;

All three of these fields should be of type __be32, since the
structure is passed to the modem as is.

> +       u8                      data[0];
> +};
> +
> +struct port_msg {
> +       u32                     head_pattern;
> +       u32                     info;
> +       u32                     tail_pattern;

Same here.

> +       u8                      data[0]; /* port set info */
> +};

[skipped]

> diff --git a/drivers/net/wwan/t7xx/t7xx_state_monitor.c b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
> ...
> @@ -202,11 +208,29 @@ static void fsm_routine_exception(struct ccci_fsm_ctl *ctl, struct ccci_fsm_comm
> ...
>                         spin_unlock_irqrestore(&ctl->event_lock, flags);
> +                       if (pass) {
> +                               log_port = port_get_by_name("ttyCMdLog");
> +                               if (log_port)
> +                                       log_port->ops->enable_chl(log_port);
> +                               else
> +                                       dev_err(dev, "ttyCMdLog port not found\n");
> +
> +                               meta_port = port_get_by_name("ttyCMdMeta");
> +                               if (meta_port)
> +                                       meta_port->ops->enable_chl(meta_port);
> +                               else
> +                                       dev_err(dev, "ttyCMdMeta port not found\n");

Looks like this change does not belong to this patch. The "ttyCMdLog"
port entry will be created only by the last patch.

--
Sergey
