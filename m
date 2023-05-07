Return-Path: <netdev+bounces-750-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D85DB6F981E
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 11:59:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C8F7B1C21493
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 09:58:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04B9A290A;
	Sun,  7 May 2023 09:58:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15337C
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 09:58:56 +0000 (UTC)
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCADF559A;
	Sun,  7 May 2023 02:58:53 -0700 (PDT)
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-24df6bbf765so3138571a91.0;
        Sun, 07 May 2023 02:58:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683453533; x=1686045533;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oBIAHGn0KAxvYdKD6xUNalflSued6Yl8FyrXJmVWpxE=;
        b=CYn/UdsWmyFIaaijxwwQ2XZj0JCWoTpLYhvPHvS+1gM0nnBiA13k+/gWoGVJ0DSzth
         a4JVHbEE3JlbAqTjOHmJMifpar4oEdg5TNIg+z35cV+VDpT7ZA42esEJnGzdiBuF3Bkj
         xtw6YACn9U0EunEItHRG1xXytw0WzkL/tbz+Wo2H9i6npT+hyyOUoj8eXUblg069l7on
         c7YDtXlVMxx8/iupr1VpVDEVBsdxdIJY9W5gy9zhTEYSFonoRY3GzZHPrSVaLLkZA734
         Gohn/EfE22fT7GZGpKjrAS4UNYoViJ/RCuPNUZcbyWbGWkBA3hEc+FKZXfxvfwtVwU+a
         j7EA==
X-Gm-Message-State: AC+VfDwm9V/iLisN61sgTJ22fMCCRnkDx2o3/5K/XcJa4VrPXM4B1J7+
	Vz/jSKuTYLUcMERgaBjeknSifLSYe+7tn8ABANjKdteFizs=
X-Google-Smtp-Source: ACHHUZ7XpRKvzNlVB5xYgyzi/qrEaPRCYr9ljf0mQu36+Zfm1UeVzL0+f5/7OGqyn7DqPrqlGLtm15xKNEnmxx0tSho=
X-Received: by 2002:a17:90a:a683:b0:23e:f855:79ed with SMTP id
 d3-20020a17090aa68300b0023ef85579edmr7218107pjq.28.1683453533002; Sun, 07 May
 2023 02:58:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230504154414.1864615-1-frank.jungclaus@esd.eu> <20230504154414.1864615-3-frank.jungclaus@esd.eu>
In-Reply-To: <20230504154414.1864615-3-frank.jungclaus@esd.eu>
From: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date: Sun, 7 May 2023 18:58:41 +0900
Message-ID: <CAMZ6RqKgJs-yJaaqREmN1SkUzE1EkGtjBzXiATKx5WL+=J48dQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] can: esd_usb: Add support for esd CAN-USB/3
To: Frank Jungclaus <frank.jungclaus@esd.eu>
Cc: linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>, 
	Wolfgang Grandegger <wg@grandegger.com>, =?UTF-8?Q?Stefan_M=C3=A4tje?= <stefan.maetje@esd.eu>, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Frank,

Thank you for your patch. Here is my first batch of comments.

Some comments also apply to the existing code. So you may want to
address those in separate clean-up patches first.

On Fri. 5 May 2023 at 01:16, Frank Jungclaus <frank.jungclaus@esd.eu> wrote:
> Add support for esd CAN-USB/3 and CAN FD to esd_usb.
>
> Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
> ---
>  drivers/net/can/usb/esd_usb.c | 282 ++++++++++++++++++++++++++++++----
>  1 file changed, 249 insertions(+), 33 deletions(-)
>
> diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
> index e24fa48b9b42..48cf5e88d216 100644
> --- a/drivers/net/can/usb/esd_usb.c
> +++ b/drivers/net/can/usb/esd_usb.c
> @@ -1,6 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>  /*
> - * CAN driver for esd electronics gmbh CAN-USB/2 and CAN-USB/Micro
> + * CAN driver for esd electronics gmbh CAN-USB/2, CAN-USB/3 and CAN-USB/Micro
>   *
>   * Copyright (C) 2010-2012 esd electronic system design gmbh, Matthias Fuchs <socketcan@esd.eu>
>   * Copyright (C) 2022-2023 esd electronics gmbh, Frank Jungclaus <frank.jungclaus@esd.eu>
> @@ -18,17 +18,19 @@
>
>  MODULE_AUTHOR("Matthias Fuchs <socketcan@esd.eu>");
>  MODULE_AUTHOR("Frank Jungclaus <frank.jungclaus@esd.eu>");
> -MODULE_DESCRIPTION("CAN driver for esd electronics gmbh CAN-USB/2 and CAN-USB/Micro interfaces");
> +MODULE_DESCRIPTION("CAN driver for esd electronics gmbh CAN-USB/2, CAN-USB/3 and CAN-USB/Micro interfaces");
>  MODULE_LICENSE("GPL v2");
>
>  /* USB vendor and product ID */
>  #define USB_ESDGMBH_VENDOR_ID  0x0ab4
>  #define USB_CANUSB2_PRODUCT_ID 0x0010
>  #define USB_CANUSBM_PRODUCT_ID 0x0011
> +#define USB_CANUSB3_PRODUCT_ID 0x0014
>
>  /* CAN controller clock frequencies */
>  #define ESD_USB2_CAN_CLOCK     60000000
>  #define ESD_USBM_CAN_CLOCK     36000000
> +#define ESD_USB3_CAN_CLOCK     80000000

Nitpick: consider using the unit suffixes from linux/units.h:

  #define ESD_USB3_CAN_CLOCK (80 * MEGA)

>  /* Maximum number of CAN nets */
>  #define ESD_USB_MAX_NETS       2
> @@ -43,6 +45,9 @@ MODULE_LICENSE("GPL v2");
>
>  /* esd CAN message flags - dlc field */
>  #define ESD_DLC_RTR            0x10
> +#define ESD_DLC_NO_BRS         0x10
> +#define ESD_DLC_ESI            0x20
> +#define ESD_DLC_FD             0x80

Use the BIT() macro:

#define ESD_DLC_NO_BRS BIT(4)
#define ESD_DLC_ESI BIT(5)
#define ESD_DLC_FD BIT(7)

Also, if this is specific to the ESD_USB3 then add it in the prefix.

>  /* esd CAN message flags - id field */
>  #define ESD_EXTID              0x20000000
> @@ -72,6 +77,28 @@ MODULE_LICENSE("GPL v2");
>  #define ESD_USB2_BRP_INC       1
>  #define ESD_USB2_3_SAMPLES     0x00800000
>
> +/* Bit timing CAN-USB/3 */
> +#define ESD_USB3_TSEG1_MIN     1
> +#define ESD_USB3_TSEG1_MAX     256
> +#define ESD_USB3_TSEG2_MIN     1
> +#define ESD_USB3_TSEG2_MAX     128
> +#define ESD_USB3_SJW_MAX       128
> +#define ESD_USB3_BRP_MIN       1
> +#define ESD_USB3_BRP_MAX       1024
> +#define ESD_USB3_BRP_INC       1
> +/* Bit timing CAN-USB/3, data phase */
> +#define ESD_USB3_DATA_TSEG1_MIN        1
> +#define ESD_USB3_DATA_TSEG1_MAX        32
> +#define ESD_USB3_DATA_TSEG2_MIN        1
> +#define ESD_USB3_DATA_TSEG2_MAX        16
> +#define ESD_USB3_DATA_SJW_MAX  8
> +#define ESD_USB3_DATA_BRP_MIN  1
> +#define ESD_USB3_DATA_BRP_MAX  32
> +#define ESD_USB3_DATA_BRP_INC  1

There is no clear benefit to define macros for some initializers of a
const struct.

Doing as below has zero ambiguity:

static const struct can_bittiming_const esd_usb3_bittiming_const = {
         .name = "esd_usb3",
         .tseg1_min = 1,
         .tseg1_max = 256,
         .tseg2_min = 1,
         .tseg2_max = 128,
         .sjw_max = 128,
         .brp_min = 1,
         .brp_max = 1024,
         .brp_inc = 1,
};

> +/* Transmitter Delay Compensation */
> +#define ESD_TDC_MODE_AUTO      0
> +
>  /* esd IDADD message */
>  #define ESD_ID_ENABLE          0x80
>  #define ESD_MAX_ID_SEGMENT     64
> @@ -95,6 +122,21 @@ MODULE_LICENSE("GPL v2");
>  #define MAX_RX_URBS            4
>  #define MAX_TX_URBS            16 /* must be power of 2 */
>
> +/* Modes for NTCAN_BAUDRATE_X */
> +#define ESD_BAUDRATE_MODE_DISABLE      0 /* remove from bus */
> +#define ESD_BAUDRATE_MODE_INDEX                1 /* ESD (CiA) bit rate idx */
> +#define ESD_BAUDRATE_MODE_BTR_CTRL     2 /* BTR values (Controller)*/
> +#define ESD_BAUDRATE_MODE_BTR_CANONICAL        3 /* BTR values (Canonical) */
> +#define ESD_BAUDRATE_MODE_NUM          4 /* numerical bit rate */
> +#define ESD_BAUDRATE_MODE_AUTOBAUD     5 /* autobaud */
> +
> +/* Flags for NTCAN_BAUDRATE_X */
> +#define ESD_BAUDRATE_FLAG_FD   0x0001 /* enable CAN FD Mode */
> +#define ESD_BAUDRATE_FLAG_LOM  0x0002 /* enable Listen Only mode */
> +#define ESD_BAUDRATE_FLAG_STM  0x0004 /* enable Self test mode */
> +#define ESD_BAUDRATE_FLAG_TRS  0x0008 /* enable Triple Sampling */
> +#define ESD_BAUDRATE_FLAG_TXP  0x0010 /* enable Transmit Pause */
> +
>  struct header_msg {
>         u8 len; /* len is always the total message length in 32bit words */
>         u8 cmd;
> @@ -129,6 +171,7 @@ struct rx_msg {
>         __le32 id; /* upper 3 bits contain flags */
>         union {
>                 u8 data[8];
> +               u8 data_fd[64];
>                 struct {
>                         u8 status; /* CAN Controller Status */
>                         u8 ecc;    /* Error Capture Register */
> @@ -144,8 +187,11 @@ struct tx_msg {
>         u8 net;
>         u8 dlc;
>         u32 hnd;        /* opaque handle, not used by device */
> -       __le32 id; /* upper 3 bits contain flags */
> -       u8 data[8];
> +       __le32 id;      /* upper 3 bits contain flags */
> +       union {
> +               u8 data[8];
> +               u8 data_fd[64];

Nitpick, use the macro:

                  u8 data[CAN_MAX_DLEN];
                  u8 data_fd[CANFD_MAX_DLEN];

> +       };
>  };
>
>  struct tx_done_msg {
> @@ -165,12 +211,37 @@ struct id_filter_msg {
>         __le32 mask[ESD_MAX_ID_SEGMENT + 1];
>  };
>
> +struct baudrate_x_cfg {
> +       __le16 brp;     /* bit rate pre-scaler */
> +       __le16 tseg1;   /* TSEG1 register */
> +       __le16 tseg2;   /* TSEG2 register */
> +       __le16 sjw;     /* SJW register */
> +};
> +
> +struct tdc_cfg {

Please prefix all the structures with the device name. e.g.

  struct esd_usb3_tdc_cfg {

> +       u8 tdc_mode;    /* transmitter Delay Compensation mode  */
> +       u8 ssp_offset;  /* secondary Sample Point offset in mtq */
> +       s8 ssp_shift;   /* secondary Sample Point shift in mtq */
> +       u8 tdc_filter;  /* Transmitter Delay Compensation */
> +};
> +
> +struct baudrate_x {

The x in baudrate_x and baudrate_x_cfg is confusing me. Is it meant to
signify that the structure applies to both nominal and data baudrate?
In that case, just put a comment and remove the x from the name.

> +       __le16 mode;    /* mode word */
> +       __le16 flags;   /* control flags */
> +       struct tdc_cfg tdc;     /* TDC configuration */
> +       struct baudrate_x_cfg arb;      /* bit rate during arbitration phase  */

/* nominal bit rate */

The comment is incorrect. CAN-FD may use the nominal bitrate for the
data phase if the bit rate switch (BRS) is not set.

> +       struct baudrate_x_cfg data;     /* bit rate during data phase */

/* data bit rate */

Please adjust the field names accordingly.

> +};
> +
>  struct set_baudrate_msg {
>         u8 len;
>         u8 cmd;
>         u8 net;
>         u8 rsvd;
> -       __le32 baud;
> +       union {
> +               __le32 baud;
> +               struct baudrate_x baud_x;
> +       };
>  };
>
>  /* Main message type used between library and application */
> @@ -188,6 +259,7 @@ union __packed esd_usb_msg {
>  static struct usb_device_id esd_usb_table[] = {
>         {USB_DEVICE(USB_ESDGMBH_VENDOR_ID, USB_CANUSB2_PRODUCT_ID)},
>         {USB_DEVICE(USB_ESDGMBH_VENDOR_ID, USB_CANUSBM_PRODUCT_ID)},
> +       {USB_DEVICE(USB_ESDGMBH_VENDOR_ID, USB_CANUSB3_PRODUCT_ID)},
>         {}
>  };
>  MODULE_DEVICE_TABLE(usb, esd_usb_table);
> @@ -326,11 +398,13 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
>  static void esd_usb_rx_can_msg(struct esd_usb_net_priv *priv,
>                                union esd_usb_msg *msg)
>  {
> +       bool is_canfd = msg->rx.dlc & ESD_DLC_FD ? true : false;

This is redundant. Just this is enough:

  bool is_canfd = msg->rx.dlc & ESD_DLC_FD;

This variable being used only twice, you may want to consider not
declaring it and simply doing directly:

          if (msg->rx.dlc & ESD_DLC_FD)

>         struct net_device_stats *stats = &priv->netdev->stats;
>         struct can_frame *cf;
> +       struct canfd_frame *cfd;
>         struct sk_buff *skb;
> -       int i;
>         u32 id;
> +       u8 len;
>
>         if (!netif_device_present(priv->netdev))
>                 return;
> @@ -340,27 +414,42 @@ static void esd_usb_rx_can_msg(struct esd_usb_net_priv *priv,
>         if (id & ESD_EVENT) {
>                 esd_usb_rx_event(priv, msg);
>         } else {
> -               skb = alloc_can_skb(priv->netdev, &cf);
> +               if (is_canfd) {
> +                       skb = alloc_canfd_skb(priv->netdev, &cfd);
> +               } else {
> +                       skb = alloc_can_skb(priv->netdev, &cf);
> +                       cfd = (struct canfd_frame *)cf;
> +               }
> +
>                 if (skb == NULL) {
>                         stats->rx_dropped++;
>                         return;
>                 }
>
> -               cf->can_id = id & ESD_IDMASK;
> -               can_frame_set_cc_len(cf, msg->rx.dlc & ~ESD_DLC_RTR,
> -                                    priv->can.ctrlmode);
> -
> -               if (id & ESD_EXTID)
> -                       cf->can_id |= CAN_EFF_FLAG;
> +               cfd->can_id = id & ESD_IDMASK;
>
> -               if (msg->rx.dlc & ESD_DLC_RTR) {
> -                       cf->can_id |= CAN_RTR_FLAG;
> +               if (is_canfd) {
> +                       /* masking by 0x0F is already done within can_fd_dlc2len() */
> +                       cfd->len = can_fd_dlc2len(msg->rx.dlc);
> +                       len = cfd->len;
> +                       if ((msg->rx.dlc & ESD_DLC_NO_BRS) == 0)
> +                               cfd->flags |= CANFD_BRS;
> +                       if (msg->rx.dlc & ESD_DLC_ESI)
> +                               cfd->flags |= CANFD_ESI;
>                 } else {
> -                       for (i = 0; i < cf->len; i++)
> -                               cf->data[i] = msg->rx.data[i];
> -
> -                       stats->rx_bytes += cf->len;
> +                       can_frame_set_cc_len(cf, msg->rx.dlc & ~ESD_DLC_RTR, priv->can.ctrlmode);
> +                       len = cf->len;
> +                       if (msg->rx.dlc & ESD_DLC_RTR) {
> +                               cf->can_id |= CAN_RTR_FLAG;
> +                               len = 0;
> +                       }
>                 }
> +
> +               if (id & ESD_EXTID)
> +                       cfd->can_id |= CAN_EFF_FLAG;
> +
> +               memcpy(cfd->data, msg->rx.data_fd, len);
> +               stats->rx_bytes += len;
>                 stats->rx_packets++;
>
>                 netif_rx(skb);
> @@ -735,7 +824,7 @@ static netdev_tx_t esd_usb_start_xmit(struct sk_buff *skb,
>         struct esd_usb *dev = priv->usb;
>         struct esd_tx_urb_context *context = NULL;
>         struct net_device_stats *stats = &netdev->stats;
> -       struct can_frame *cf = (struct can_frame *)skb->data;
> +       struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
>         union esd_usb_msg *msg;
>         struct urb *urb;
>         u8 *buf;
> @@ -768,19 +857,28 @@ static netdev_tx_t esd_usb_start_xmit(struct sk_buff *skb,
>         msg->hdr.len = 3; /* minimal length */
>         msg->hdr.cmd = CMD_CAN_TX;
>         msg->tx.net = priv->index;
> -       msg->tx.dlc = can_get_cc_dlc(cf, priv->can.ctrlmode);
> -       msg->tx.id = cpu_to_le32(cf->can_id & CAN_ERR_MASK);
>
> -       if (cf->can_id & CAN_RTR_FLAG)
> -               msg->tx.dlc |= ESD_DLC_RTR;
> +       if (can_is_canfd_skb(skb)) {
> +               msg->tx.dlc = can_fd_len2dlc(cfd->len);
> +               msg->tx.dlc |= ESD_DLC_FD;
> +
> +               if ((cfd->flags & CANFD_BRS) == 0)
> +                       msg->tx.dlc |= ESD_DLC_NO_BRS;
> +       } else {
> +               msg->tx.dlc = can_get_cc_dlc((struct can_frame *)cfd, priv->can.ctrlmode);
> +
> +               if (cfd->can_id & CAN_RTR_FLAG)
> +                       msg->tx.dlc |= ESD_DLC_RTR;
> +       }
>
> -       if (cf->can_id & CAN_EFF_FLAG)
> +       msg->tx.id = cpu_to_le32(cfd->can_id & CAN_ERR_MASK);
> +
> +       if (cfd->can_id & CAN_EFF_FLAG)
>                 msg->tx.id |= cpu_to_le32(ESD_EXTID);
>
> -       for (i = 0; i < cf->len; i++)
> -               msg->tx.data[i] = cf->data[i];
> +       memcpy(msg->tx.data_fd, cfd->data, cfd->len);
>
> -       msg->hdr.len += (cf->len + 3) >> 2;
> +       msg->hdr.len += (cfd->len + 3) >> 2;

I do not get the logic.

Assuming cfd->len is 8. Then

  hdr.len += (8 + 3) >> 2
  hdr.len += 2

And because hdr.len is initially 3, hdr.len becomes 5. Right? Shouldn't it be 8?

>         for (i = 0; i < MAX_TX_URBS; i++) {
>                 if (priv->tx_contexts[i].echo_index == MAX_TX_URBS) {
> @@ -966,6 +1064,108 @@ static int esd_usb2_set_bittiming(struct net_device *netdev)
>         return err;
>  }
>
> +static const struct can_bittiming_const esd_usb3_bittiming_const = {
> +       .name = "esd_usb3",
> +       .tseg1_min = ESD_USB3_TSEG1_MIN,
> +       .tseg1_max = ESD_USB3_TSEG1_MAX,
> +       .tseg2_min = ESD_USB3_TSEG2_MIN,
> +       .tseg2_max = ESD_USB3_TSEG2_MAX,
> +       .sjw_max = ESD_USB3_SJW_MAX,
> +       .brp_min = ESD_USB3_BRP_MIN,
> +       .brp_max = ESD_USB3_BRP_MAX,
> +       .brp_inc = ESD_USB3_BRP_INC,
> +};
> +
> +static const struct can_bittiming_const esd_usb3_data_bittiming_const = {
> +       .name = "esd_usb3",
> +       .tseg1_min = ESD_USB3_DATA_TSEG1_MIN,
> +       .tseg1_max = ESD_USB3_DATA_TSEG1_MAX,
> +       .tseg2_min = ESD_USB3_DATA_TSEG2_MIN,
> +       .tseg2_max = ESD_USB3_DATA_TSEG2_MAX,
> +       .sjw_max = ESD_USB3_DATA_SJW_MAX,
> +       .brp_min = ESD_USB3_DATA_BRP_MIN,
> +       .brp_max = ESD_USB3_DATA_BRP_MAX,
> +       .brp_inc = ESD_USB3_DATA_BRP_INC,
> +};
> +
> +static int esd_usb3_set_bittiming(struct net_device *netdev)
> +{
> +       struct esd_usb_net_priv *priv = netdev_priv(netdev);
> +       struct can_bittiming *bt   = &priv->can.bittiming;
> +       struct can_bittiming *d_bt = &priv->can.data_bittiming;
> +       union esd_usb_msg *msg;
> +       int err;
> +       u16 mode;
> +       u16 flags = 0;
> +       u16 brp, tseg1, tseg2, sjw;
> +       u16 d_brp, d_tseg1, d_tseg2, d_sjw;
> +
> +       msg = kmalloc(sizeof(*msg), GFP_KERNEL);
> +       if (!msg)
> +               return -ENOMEM;
> +
> +       /* Canonical is the most reasonable mode for SocketCAN on CAN-USB/3 ... */
> +       mode = ESD_BAUDRATE_MODE_BTR_CANONICAL;
> +
> +       if (priv->can.ctrlmode & CAN_CTRLMODE_LISTENONLY)
> +               flags |= ESD_BAUDRATE_FLAG_LOM;
> +
> +       if (priv->can.ctrlmode & CAN_CTRLMODE_3_SAMPLES)
> +               flags |= ESD_BAUDRATE_FLAG_TRS;
> +
> +       brp = bt->brp & (ESD_USB3_BRP_MAX - 1);
> +       sjw = bt->sjw & (ESD_USB3_SJW_MAX - 1);
> +       tseg1 = (bt->prop_seg + bt->phase_seg1) & (ESD_USB3_TSEG1_MAX - 1);
> +       tseg2 = bt->phase_seg2 & (ESD_USB3_TSEG2_MAX - 1);

I am not convinced by the use of these intermediate variables brp,
sjw, tseg1 and tseg2. I think you can directly assign them to baud_x.

> +       msg->setbaud.baud_x.arb.brp = cpu_to_le16(brp);
> +       msg->setbaud.baud_x.arb.sjw = cpu_to_le16(sjw);
> +       msg->setbaud.baud_x.arb.tseg1 = cpu_to_le16(tseg1);
> +       msg->setbaud.baud_x.arb.tseg2 = cpu_to_le16(tseg2);

You may want to declare a local variable

  struct baudrate_x *baud_x = &msg->setbaud.baud_x;

so that you do not have to do msg->setbaud.baud_x each time.

> +       if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
> +               d_brp = d_bt->brp & (ESD_USB3_DATA_BRP_MAX - 1);
> +               d_sjw = d_bt->sjw & (ESD_USB3_DATA_SJW_MAX - 1);
> +               d_tseg1 = (d_bt->prop_seg + d_bt->phase_seg1) & (ESD_USB3_DATA_TSEG1_MAX - 1);
> +               d_tseg2 = d_bt->phase_seg2 & (ESD_USB3_DATA_TSEG2_MAX - 1);
> +               flags |= ESD_BAUDRATE_FLAG_FD;
> +       } else {
> +               d_brp = 0;
> +               d_sjw = 0;
> +               d_tseg1 = 0;
> +               d_tseg2 = 0;
> +       }
> +
> +       msg->setbaud.baud_x.data.brp = cpu_to_le16(d_brp);
> +       msg->setbaud.baud_x.data.sjw = cpu_to_le16(d_sjw);
> +       msg->setbaud.baud_x.data.tseg1 = cpu_to_le16(d_tseg1);
> +       msg->setbaud.baud_x.data.tseg2 = cpu_to_le16(d_tseg2);
> +       msg->setbaud.baud_x.mode = cpu_to_le16(mode);
> +       msg->setbaud.baud_x.flags = cpu_to_le16(flags);
> +       msg->setbaud.baud_x.tdc.tdc_mode = ESD_TDC_MODE_AUTO;
> +       msg->setbaud.baud_x.tdc.ssp_offset = 0;
> +       msg->setbaud.baud_x.tdc.ssp_shift = 0;
> +       msg->setbaud.baud_x.tdc.tdc_filter = 0;

It seems that your device supports TDC. What is the reason to not configure it?

Please have a look at struct can_tdc:

  https://elixir.bootlin.com/linux/v6.2/source/include/linux/can/bittiming.h#L21

Please refer to this patch if you want an example of how to use TDC:

  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1010a8fa9608

> +       msg->hdr.len = 7;

What is this magic number? If possible, replace it with a sizeof().

It seems that this relates to the size of struct set_baudrate_msg, but
that structure is 8 bytes. Is the last byte of struct set_baudrate_msg
really used? If not, reflect this in the declaration of the structure.

> +       msg->hdr.cmd = CMD_SETBAUD;
> +
> +       msg->setbaud.net = priv->index;
> +       msg->setbaud.rsvd = 0;
> +
> +       netdev_info(netdev,
> +                   "ctrlmode=%#x/%#x, esd-net=%u, esd-mode=%#x, esd-flg=%#x, arb: brp=%u, ts1=%u, ts2=%u, sjw=%u, data: dbrp=%u, dts1=%u, dts2=%u dsjw=%u\n",
> +                   priv->can.ctrlmode, priv->can.ctrlmode_supported,
> +                   priv->index, mode, flags,
> +                   brp, tseg1, tseg2, sjw,
> +                   d_brp, d_tseg1, d_tseg2, d_sjw);

Remove this debug message. The bittiming information can be retrieved
with the ip tool.

  ip --details link show canX

> +       err = esd_usb_send_msg(priv->usb, msg);
> +
> +       kfree(msg);

esd_usb_send_msg() uses usb_bulk_msg() which does a synchronous call.
It would be great to go asynchronous and use usb_submit_urb() so that
you minimize the time spent in the driver.

I know that  esd_usb2_set_bittiming() also uses the synchronous call,
so I am fine to have it as-is for this patch but for the future, it
would be great to consider refactoring this.

> +       return err;
> +}
> +
>  static int esd_usb_get_berr_counter(const struct net_device *netdev,
>                                     struct can_berr_counter *bec)
>  {
> @@ -1023,16 +1223,32 @@ static int esd_usb_probe_one_net(struct usb_interface *intf, int index)
>                 CAN_CTRLMODE_CC_LEN8_DLC |
>                 CAN_CTRLMODE_BERR_REPORTING;
>
> -       if (le16_to_cpu(dev->udev->descriptor.idProduct) ==
> -           USB_CANUSBM_PRODUCT_ID)
> +       switch (le16_to_cpu(dev->udev->descriptor.idProduct)) {

Instead of doing a switch on idProduct, you can use the driver_info
field from struct usb_device_id to store the device quirks.

You can pass either a pointer or some flags into driver_info. Examples:

  https://elixir.bootlin.com/linux/v6.2/source/drivers/net/can/usb/peak_usb/pcan_usb_core.c#L30
  https://elixir.bootlin.com/linux/v6.2/source/drivers/net/can/usb/etas_es58x/es58x_core.c#L37

> +       case USB_CANUSB3_PRODUCT_ID:
> +               priv->can.clock.freq = ESD_USB3_CAN_CLOCK;
> +               priv->can.ctrlmode_supported |= CAN_CTRLMODE_3_SAMPLES;
> +               priv->can.ctrlmode_supported |= CAN_CTRLMODE_FD;
> +               priv->can.bittiming_const = &esd_usb3_bittiming_const;
> +               priv->can.data_bittiming_const = &esd_usb3_data_bittiming_const;
> +               priv->can.do_set_bittiming = esd_usb3_set_bittiming;
> +               priv->can.do_set_data_bittiming = esd_usb3_set_bittiming;
> +               break;
> +
> +       case USB_CANUSBM_PRODUCT_ID:
>                 priv->can.clock.freq = ESD_USBM_CAN_CLOCK;
> -       else {
> +               priv->can.bittiming_const = &esd_usb2_bittiming_const;
> +               priv->can.do_set_bittiming = esd_usb2_set_bittiming;
> +               break;
> +
> +       case USB_CANUSB2_PRODUCT_ID:
> +       default:
>                 priv->can.clock.freq = ESD_USB2_CAN_CLOCK;
>                 priv->can.ctrlmode_supported |= CAN_CTRLMODE_3_SAMPLES;
> +               priv->can.bittiming_const = &esd_usb2_bittiming_const;
> +               priv->can.do_set_bittiming = esd_usb2_set_bittiming;
> +               break;
>         }
>
> -       priv->can.bittiming_const = &esd_usb2_bittiming_const;
> -       priv->can.do_set_bittiming = esd_usb2_set_bittiming;
>         priv->can.do_set_mode = esd_usb_set_mode;
>         priv->can.do_get_berr_counter = esd_usb_get_berr_counter;
>
> --
> 2.25.1
>

