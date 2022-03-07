Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDE74CEFCB
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 03:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234854AbiCGCxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 21:53:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbiCGCxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 21:53:20 -0500
Received: from mail-ua1-x932.google.com (mail-ua1-x932.google.com [IPv6:2607:f8b0:4864:20::932])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC0255A8;
        Sun,  6 Mar 2022 18:52:25 -0800 (PST)
Received: by mail-ua1-x932.google.com with SMTP id j7so5939208uap.5;
        Sun, 06 Mar 2022 18:52:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zytDkFFlh57r4G8QyTvdL+7qtyrHFZIQs/20CzLJkyE=;
        b=GzRRQLE768E7NN6N7O2S7ImwEEJFHH6+6YxyzBMZtQb2Jhni3zjVqzwk/g3fJle2sV
         TKSMGV+QAXUMeHJiWPjX6ylTDVniVtoip+HERqXkV0+zeaUwHIawJYnczILsJEyqSsJl
         RXCHokEu9MS3/RDRRyGGkSLHHwxaA/fDPHEAXLICvTKAmXIzPcxnU6UXCZSHhfgu5Yy5
         PZfskjZ5e/otXj5eDwPFhtSLh9oB+iuEYmr1nIf2ByZ+Pqt/bkbUR8Haq27RP5PbkOQP
         KBoD9BW6XW4eAGCKc0D4XdUxRR2aMMqh8Loq80Osm+5s1oq/aK1Uar9wJtDErPkh4c3h
         w3IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zytDkFFlh57r4G8QyTvdL+7qtyrHFZIQs/20CzLJkyE=;
        b=17sFsqkzm62ReksChmz+5E0nVnozOaFXxgNlJtljAhFksSqrsKmeW1yQ6UdHwTPboU
         XhCHTKtlAY/SEO5IHRtSiADt9iGGdwLHnQsLa5S12Pr/GhDazaSuRaegqfgGNnSLSob9
         J1fxkiKNbiK+zDDILOgkPJ0viFJnFbFaaGRybOd+rR2wY2ryssuMHgYwYupYSRWocBum
         fsWuLRCtSjZJlK1iQCA/cViLZh0aujRC+GESJnLv1cs92AmUVk2rq9us5gTtVXK15Pvu
         pCqt3EZVZShKev6VicEfGw4UQNl0LtUjd2giCMt06zrDkiE92F753U2bE9WcWCgEU0vQ
         BZsw==
X-Gm-Message-State: AOAM532vgaRnAfRyFHzt91DzqlnzwxCj+DFJdbr8aOQg2D1hyJf9THY6
        dffeZhbyIBx4B2noSbMwicGRhwREYnMxkYvqJfY=
X-Google-Smtp-Source: ABdhPJx7EZzjf6kz1b2nLPaoGe1CURu+qtL7jT2z9IQFrOTh5rYQdw0Brb5ppdCHdQ/HiR8GlJ0mClr5kLHbx6cNagU=
X-Received: by 2002:a9f:2d91:0:b0:346:ee5e:c827 with SMTP id
 v17-20020a9f2d91000000b00346ee5ec827mr2688260uaj.84.1646621544811; Sun, 06
 Mar 2022 18:52:24 -0800 (PST)
MIME-Version: 1.0
References: <20220223223326.28021-1-ricardo.martinez@linux.intel.com> <20220223223326.28021-5-ricardo.martinez@linux.intel.com>
In-Reply-To: <20220223223326.28021-5-ricardo.martinez@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Mon, 7 Mar 2022 05:52:34 +0300
Message-ID: <CAHNKnsTihx8XmNWOSE+Awx+LO0QDq_D-A3zftN0YmMvV8a5Htg@mail.gmail.com>
Subject: Re: [PATCH net-next v5 04/13] net: wwan: t7xx: Add port proxy infrastructure
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        chandrashekar.devegowda@intel.com,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>, amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        ilpo.johannes.jarvinen@intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        madhusmita.sahu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 1:35 AM Ricardo Martinez
<ricardo.martinez@linux.intel.com> wrote:
> From: Haijun Liu <haijun.liu@mediatek.com>
>
> Port-proxy provides a common interface to interact with different types
> of ports. Ports export their configuration via `struct t7xx_port` and
> operate as defined by `struct port_ops`.

[skipped]

> --- /dev/null
> +++ b/drivers/net/wwan/t7xx/t7xx_port.h
> ...
> +#define PORT_F_RX_ALLOW_DROP   BIT(0)  /* Packet will be dropped if port's RX buffer full */

The flag is advertised as an overflow policy, but it is actually only
used for WWAN (AT&MBIM) ports, and only to free skb in case of an
error. Should it be removed and skb consumption rethought?

> +#define PORT_F_RX_FULLED       BIT(1)  /* RX buffer has been detected to be full */

This flag is set, but is never checked.

> +#define PORT_F_USER_HEADER     BIT(2)  /* CCCI header will be provided by user, but not by CCCI */

Above flag is never set and looks like a leftover from earlier driver
development. Should it be removed?

> +#define PORT_F_RX_EXCLUSIVE    BIT(3)  /* RX queue only has this one port */

This flag is not used at all.

> +#define PORT_F_RX_ADJUST_HEADER        BIT(4)  /* Check whether need remove CCCI header while recv skb */

This flag is set for WWAN ports, but the control port code
unconditionally strips the CCCI header. Should the header be always
stripped and this flag removed from the code?

> +#define PORT_F_RX_CH_TRAFFIC   BIT(5)  /* Enable port channel traffic */

This flag is set for wwan ports, but is not ever checked.

> +#define PORT_F_RX_CHAR_NODE    BIT(7)  /* Requires exporting char dev node to userspace */

This flag is not used at all.

> +#define PORT_F_CHAR_NODE_SHOW  BIT(10) /* The char dev node is shown to userspace by default */

This flag is checked but is never set.


[skipped]

> +#define        PORT_INVALID_CH_ID      GENMASK(15, 0)

Looks like this macro is never used, should it be removed? And BTW,
why is this value defined as a mask?

> +/* Channel ID and Message ID definitions.
> + * The channel number consists of peer_id(15:12) , channel_id(11:0)
> + * peer_id:
> + * 0:reserved, 1: to sAP, 2: to MD
> + */
> +enum port_ch {
> +       /* to MD */
> +       PORT_CH_CONTROL_RX = 0x2000,
> +       PORT_CH_CONTROL_TX = 0x2001,
> +       PORT_CH_UART1_RX = 0x2006,      /* META */
> +       PORT_CH_UART1_TX = 0x2008,
> +       PORT_CH_UART2_RX = 0x200a,      /* AT */
> +       PORT_CH_UART2_TX = 0x200c,
> +       PORT_CH_MD_LOG_RX = 0x202a,     /* MD logging */
> +       PORT_CH_MD_LOG_TX = 0x202b,
> +       PORT_CH_LB_IT_RX = 0x203e,      /* Loop back test */
> +       PORT_CH_LB_IT_TX = 0x203f,
> +       PORT_CH_STATUS_RX = 0x2043,     /* Status polling */

There is no STATUS_TX channel, so how is the polling performed? Is it
performed through the CONTROL_TX channel? Or should the comment be
changed to "status events"?

> +       PORT_CH_MIPC_RX = 0x20ce,       /* MIPC */
> +       PORT_CH_MIPC_TX = 0x20cf,
> +       PORT_CH_MBIM_RX = 0x20d0,
> +       PORT_CH_MBIM_TX = 0x20d1,
> +       PORT_CH_DSS0_RX = 0x20d2,
> +       PORT_CH_DSS0_TX = 0x20d3,
> +       PORT_CH_DSS1_RX = 0x20d4,
> +       PORT_CH_DSS1_TX = 0x20d5,
> +       PORT_CH_DSS2_RX = 0x20d6,
> +       PORT_CH_DSS2_TX = 0x20d7,
> +       PORT_CH_DSS3_RX = 0x20d8,
> +       PORT_CH_DSS3_TX = 0x20d9,
> +       PORT_CH_DSS4_RX = 0x20da,
> +       PORT_CH_DSS4_TX = 0x20db,
> +       PORT_CH_DSS5_RX = 0x20dc,
> +       PORT_CH_DSS5_TX = 0x20dd,
> +       PORT_CH_DSS6_RX = 0x20de,
> +       PORT_CH_DSS6_TX = 0x20df,
> +       PORT_CH_DSS7_RX = 0x20e0,
> +       PORT_CH_DSS7_TX = 0x20e1,
> +};
> +
> ...
> +
> +struct t7xx_port_static {

I do not care too much, but the purpose of this structure is to carry
static port configuration. And the main word here is "configuration",
not "static". So why not name this structure port_conf or port_params?

> +       enum port_ch            tx_ch;
> +       enum port_ch            rx_ch;
> +       unsigned char           txq_index;
> +       unsigned char           rxq_index;
> +       unsigned char           txq_exp_index;
> +       unsigned char           rxq_exp_index;
> +       enum cldma_id           path_id;
> +       unsigned int            flags;

This field is not used.

> +       struct port_ops         *ops;
> +       char                    *name;
> +       enum wwan_port_type     port_type;
> +};

[skipped]

> --- /dev/null
> +++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
> ...
> +static struct t7xx_port_static t7xx_md_ports[1];

This array can be defined from the beginning as:

static struct t7xx_port_static t7xx_md_ports[] = {
};

This will reduce a number of ping-pong changes in the further patches.


[skipped]

> +int t7xx_port_recv_skb(struct t7xx_port *port, struct sk_buff *skb)
> +{
> +       struct ccci_header *ccci_h;
> +       unsigned long flags;
> +       u32 channel;
> +       int ret = 0;
> +
> +       spin_lock_irqsave(&port->rx_wq.lock, flags);
> +       if (port->rx_skb_list.qlen >= port->rx_length_th) {
> +               port->flags |= PORT_F_RX_FULLED;
> +               spin_unlock_irqrestore(&port->rx_wq.lock, flags);
> +
> +               return -ENOBUFS;
> +       }
> +       ccci_h = (struct ccci_header *)skb->data;
> +       port->flags &= ~PORT_F_RX_FULLED;
> +       if (port->flags & PORT_F_RX_ADJUST_HEADER)
> +               t7xx_port_adjust_skb(port, skb);
> +       channel = FIELD_GET(CCCI_H_CHN_FLD, le32_to_cpu(ccci_h->status));
> +       if (channel == PORT_CH_STATUS_RX) {
> +               ret = port->skb_handler(port, skb);

This handler will never be called. A message with channel =
PORT_CH_STATUS_RX will be dropped in the t7xx_port_proxy_recv_skb()
function, since the corresponding port is nonexistent.

> +       } else {
> +               if (port->wwan_port)
> +                       wwan_port_rx(port->wwan_port, skb);
> +               else
> +                       __skb_queue_tail(&port->rx_skb_list, skb);
> +       }
> +       spin_unlock_irqrestore(&port->rx_wq.lock, flags);
> +
> +       wake_up_all(&port->rx_wq);
> +       return ret;
> +}

Whole this function looks like a big unintentional duct tape. On the
one hand, each port type has a specific recv_skb callback. But in
fact, all message processing paths pass through this place. And here
the single function forced to take into account the specialties of
each port type:
a) immediately passes status events to the handler via the indirect call;
b) enqueues control messages to the rx queue;
c) directly passes WWAN management (MBIM & AT) message to the WWAN subsystem.

I would like to suggest the following reworking plan for the function:
1) move the common processing code (header stripping code) to the
t7xx_port_proxy_recv_skb() function, where it belongs;
2) add a dedicated port ops for the PORT_CH_STATUS_RX channel and call
control_msg_handler() from its recv_skb callback (lets call it
t7xx_port_status_recv_skb()); this will solve both issues: status
messages will no more dropped and status message hook will be removed;
3) move the wwan_port_rx() call to the t7xx_port_wwan_recv_skb()
callback; this will remove another one hook;
4) finally rename t7xx_port_recv_skb() to t7xx_port_enqueue_skb(),
since after the hooks removing, the only purpose of this function will
be to enqueue received skb(s).

[skipped]

> +int t7xx_port_proxy_send_skb(struct t7xx_port *port, struct sk_buff *skb)
> +{
> +       struct ccci_header *ccci_h = (struct ccci_header *)(skb->data);
> +       struct cldma_ctrl *md_ctrl;
> +       unsigned char tx_qno;
> +       int ret;
> +
> +       tx_qno = t7xx_port_get_queue_no(port);
> +       t7xx_port_proxy_set_tx_seq_num(port, ccci_h);
> +
> +       md_ctrl = get_md_ctrl(port);
> +       ret = t7xx_cldma_send_skb(md_ctrl, tx_qno, skb);
> +       if (ret) {
> +               dev_err(port->dev, "Failed to send skb: %d\n", ret);
> +               return ret;
> +       }
> +
> +       port->seq_nums[MTK_TX]++;
> +
> +       return 0;
> +}
> +
> +int t7xx_port_send_skb_to_md(struct t7xx_port *port, struct sk_buff *skb)

This function looks like a duplicate of the above
t7xx_port_proxy_send_skb(). Why can not t7xx_port_proxy_send_skb() be
used to send a WWAN (MBIM&AT) port skb?

If you need to bypass some checks in t7xx_port_send_skb_to_md() then
you can create an exception as already done for PORT_CH_MD_LOG_TX. Or,
better, create a set of two functions: first will perform checks and
call an actual skb send routine. E.g.

int __t7xx_port_proxy_send_skb(...)
{
    return t7xx_cldma_send_skb(...);
}

int t7xx_port_proxy_send_skb(...)
{
    /* Perform checks here */
    return __t7xx_port_proxy_send_skb(...)
}

This way code duplication will be reduced and if someone calls
__t7xx_port_proxy_send_skb() directly bypassing state checks, then it
will be clear that such call is a special case.

> +{
> +       struct t7xx_port_static *port_static = port->port_static;
> +       struct t7xx_fsm_ctl *ctl = port->t7xx_dev->md->fsm_ctl;
> +       struct cldma_ctrl *md_ctrl;
> +       enum md_state md_state;
> +       unsigned int fsm_state;
> +
> +       md_state = t7xx_fsm_get_md_state(ctl);
> +
> +       fsm_state = t7xx_fsm_get_ctl_state(ctl);
> +       if (fsm_state != FSM_STATE_PRE_START) {
> +               if (md_state == MD_STATE_WAITING_FOR_HS1 || md_state == MD_STATE_WAITING_FOR_HS2)
> +                       return -ENODEV;
> +
> +               if (md_state == MD_STATE_EXCEPTION && port_static->tx_ch != PORT_CH_MD_LOG_TX &&
> +                   port_static->tx_ch != PORT_CH_UART1_TX)

There are no ports defined for PORT_CH_MD_LOG_TX and PORT_CH_UART1_TX
channels, should this check be removed?

> +                       return -EBUSY;
> +
> +               if (md_state == MD_STATE_STOPPED || md_state == MD_STATE_WAITING_TO_STOP ||
> +                   md_state == MD_STATE_INVALID)
> +                       return -ENODEV;

Did you consider to convert the above tests into a big switch? e.g.:

switch (md_state) {
case MD_STATE_WAITING_FOR_HS1:
case ...:
case MD_STATE_INVALID:
    return -ENODEV;
case MD_STATE_EXCEPTION:
    if (port_static->tx_ch != PORT_CH_MD_LOG_TX &&
        port_static->tx_ch != PORT_CH_UART1_TX)
        return -EBUSY;
    break;
}

> +       }
> +
> +       md_ctrl = get_md_ctrl(port);
> +       return t7xx_cldma_send_skb(md_ctrl, t7xx_port_get_queue_no(port), skb);
> +}

[skipped]

> +static struct t7xx_port *t7xx_port_proxy_find_port(struct t7xx_pci_dev *t7xx_dev,
> +                                                  struct cldma_queue *queue, u16 channel)
> +{
> +       struct port_proxy *port_prox = t7xx_dev->md->port_prox;
> +       struct list_head *port_list;
> +       struct t7xx_port *port;
> +       u8 ch_id;
> +
> +       ch_id = FIELD_GET(PORT_CH_ID_MASK, channel);
> +       port_list = &port_prox->rx_ch_ports[ch_id];
> +       list_for_each_entry(port, port_list, entry) {
> +               struct t7xx_port_static *port_static = port->port_static;
> +
> +               if (queue->md_ctrl->hif_id == port_static->path_id &&
> +                   channel == port_static->rx_ch)
> +                       return port;
> +       }
> +
> +       return NULL;
> +}
> +
> +/**
> + * t7xx_port_proxy_recv_skb() - Dispatch received skb.
> + * @queue: CLDMA queue.
> + * @skb: Socket buffer.
> + *
> + * Return:
> + ** 0          - Packet consumed.
> + ** -ERROR     - Failed to process skb.
> + */
> +static int t7xx_port_proxy_recv_skb(struct cldma_queue *queue, struct sk_buff *skb)
> +{
> +       struct ccci_header *ccci_h = (struct ccci_header *)skb->data;
> +       struct t7xx_pci_dev *t7xx_dev = queue->md_ctrl->t7xx_dev;
> +       struct t7xx_fsm_ctl *ctl = t7xx_dev->md->fsm_ctl;
> +       struct device *dev = queue->md_ctrl->dev;
> +       struct t7xx_port_static *port_static;
> +       struct t7xx_port *port;
> +       u16 seq_num, channel;
> +       int ret;
> +
> +       if (!skb)
> +               return -EINVAL;
> +
> +       channel = FIELD_GET(CCCI_H_CHN_FLD, le32_to_cpu(ccci_h->status));
> +       if (t7xx_fsm_get_md_state(ctl) == MD_STATE_INVALID) {
> +               dev_err_ratelimited(dev, "Packet drop on channel 0x%x, modem not ready\n", channel);
> +               goto drop_skb;
> +       }
> +
> +       port = t7xx_port_proxy_find_port(t7xx_dev, queue, channel);
> +       if (!port) {
> +               dev_err_ratelimited(dev, "Packet drop on channel 0x%x, port not found\n", channel);
> +               goto drop_skb;
> +       }
> +
> +       seq_num = t7xx_port_next_rx_seq_num(port, ccci_h);
> +       port_static = port->port_static;
> +       ret = port_static->ops->recv_skb(port, skb);
> +       if (ret && port->flags & PORT_F_RX_ALLOW_DROP) {
> +               port->seq_nums[MTK_RX] = seq_num;
> +               dev_err_ratelimited(dev, "Packed drop on port %s, error %d\n",
> +                                   port_static->name, ret);
> +               goto drop_skb;
> +       }
> +
> +       if (ret)
> +               return ret;
> +
> +       port->seq_nums[MTK_RX] = seq_num;
> +       return 0;
> +
> +drop_skb:
> +       dev_kfree_skb_any(skb);
> +       return 0;
> +}

[skipped]

> +/**
> + * t7xx_port_proxy_node_control() - Create/remove node.
> + * @md: Modem.
> + * @port_msg: Message.
> + *
> + * Used to control create/remove device node.
> + *
> + * Return:
> + * * 0         - Success.
> + * * -EFAULT   - Message check failure.
> + */
> +int t7xx_port_proxy_node_control(struct t7xx_modem *md, struct port_msg *port_msg)
> +{
> +       u32 *port_info_base = (void *)port_msg + sizeof(*port_msg);
> +       struct device *dev = &md->t7xx_dev->pdev->dev;
> +       unsigned int version, ports, i;
> +
> +       version = FIELD_GET(PORT_MSG_VERSION, le32_to_cpu(port_msg->info));
> +       if (version != PORT_ENUM_VER ||
> +           le32_to_cpu(port_msg->head_pattern) != PORT_ENUM_HEAD_PATTERN ||
> +           le32_to_cpu(port_msg->tail_pattern) != PORT_ENUM_TAIL_PATTERN) {
> +               dev_err(dev, "Invalid port control message %x:%x:%x\n",
> +                       version, le32_to_cpu(port_msg->head_pattern),
> +                       le32_to_cpu(port_msg->tail_pattern));
> +               return -EFAULT;
> +       }
> +
> +       ports = FIELD_GET(PORT_MSG_PRT_CNT, le32_to_cpu(port_msg->info));
> +       for (i = 0; i < ports; i++) {
> +               struct t7xx_port_static *port_static;
> +               u32 *port_info = port_info_base + i;
> +               struct t7xx_port *port;
> +               unsigned int ch_id;
> +               bool en_flag;
> +
> +               ch_id = FIELD_GET(PORT_INFO_CH_ID, *port_info);
> +               port = t7xx_proxy_get_port_by_ch(md->port_prox, ch_id);
> +               if (!port) {
> +                       dev_dbg(dev, "Port:%x not found\n", ch_id);
> +                       continue;
> +               }
> +
> +               en_flag = !!(PORT_INFO_ENFLG & *port_info);
> +
> +               if (t7xx_fsm_get_md_state(md->fsm_ctl) == MD_STATE_READY) {
> +                       port_static = port->port_static;
> +
> +                       if (en_flag) {
> +                               if (port_static->ops->enable_chl)
> +                                       port_static->ops->enable_chl(port);
> +                       } else {
> +                               if (port_static->ops->disable_chl)
> +                                       port_static->ops->disable_chl(port);
> +                       }
> +               } else {
> +                       port->chan_enable = en_flag;
> +               }
> +       }
> +
> +       return 0;
> +}

Should most of this function (message parsing and verification code)
be moved to the control port code, and left only the channel
enable/disable code here? The port_msg structure definition should
probably be moved to the control port code too.

I mean, the port message belongs more to the control protocol and the
proxy should not care too much about this top level protocol
internals.

[skipped]

> +struct port_proxy {
> +       int                             port_number;
> +       struct t7xx_port_static         *ports_shared;

This field is not actually used and probably should be removed.

> +       struct t7xx_port                *ports_private;

Since the 'ports_shared' field should be removed, this field can be
renamed to 'ports' for simplicity.

BTW, the ports array can be moved to the end of the structure in form
of flexible array:

struct t7xx_port ports[];

so it will be possible to allocate memory for the main proxy data and
for ports array as a single block.

> +       struct list_head                rx_ch_ports[PORT_CH_ID_MASK + 1];
> +       struct list_head                queue_ports[CLDMA_NUM][MTK_QUEUES];
> +       struct device                   *dev;
> +};

--
Sergey
