Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D17C2F4B1F
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 13:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbhAMMP7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 13 Jan 2021 07:15:59 -0500
Received: from mail-yb1-f179.google.com ([209.85.219.179]:40771 "EHLO
        mail-yb1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbhAMMP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 07:15:58 -0500
Received: by mail-yb1-f179.google.com with SMTP id b64so1936762ybg.7;
        Wed, 13 Jan 2021 04:15:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2wUt4z1Zsz9iM7CRpKvt0vyz96nLLvj41PURHjsvbRY=;
        b=dXeAPX2XjiEE5II0IEyDDiQPMuePlULqb1drABdrYCLEtzeOjJ1TOQYa0UEJLnnVnW
         snV/ZrkYxF3CMCaIjGwqhfJrkkG3+EMi4RtWCiA1rEalmvBEV2anEiydzfsUBWwCORYH
         Ru2Xek1tM7VYSxHf9RYn3Ysky6JhGj2qn7L7HhmIF07Gjm5cgTgfQfcgWQ7ZT4rY5RD/
         Ie7wS/hwGi6I7GiEzwzr6+lKAh8av7QX7WFaHI8cP3neovY8xmmKqC/88zmDGyd50arT
         nL0MBCq8Vb0dO36mItOA+d5vcCbW++1/M5LC7/Y++z0F1LE1/ocWjf/Xs0HP4WPNoSbD
         y0dQ==
X-Gm-Message-State: AOAM531xNA+TaH0ZotMcxNRsNQDmgIQdFMPA2AoIo7211+gydgi5wvp3
        f8XMJWukP4X3LIn9TZYUq4H47wnXasPTo9R/IdI=
X-Google-Smtp-Source: ABdhPJzyffLUsPWd7j0/OwP119CbOrw/CMuKEU+UdoLUXyhfReHpjKOZhWKYwv87TuYgK/xA0o3hBbwOX2LdHv5K3sI=
X-Received: by 2002:a25:f30a:: with SMTP id c10mr2658250ybs.514.1610540117068;
 Wed, 13 Jan 2021 04:15:17 -0800 (PST)
MIME-Version: 1.0
References: <20210112130538.14912-1-mailhol.vincent@wanadoo.fr>
 <20210112130538.14912-2-mailhol.vincent@wanadoo.fr> <7643bd48-6594-9ede-b791-de6e155c62c1@pengutronix.de>
In-Reply-To: <7643bd48-6594-9ede-b791-de6e155c62c1@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Wed, 13 Jan 2021 21:15:04 +0900
Message-ID: <CAMZ6Rq+HggK2HHkPn_QTKzz-niyiU8AkHc4rP5AXE+AqJmkbrg@mail.gmail.com>
Subject: Re: [PATCH v10 1/1] can: usb: etas_es58X: add support for ETAS ES58X
 CAN USB interfaces
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can <linux-can@vger.kernel.org>,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jimmy Assarsson <extja@kvaser.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        "open list : NETWORKING DRIVERS" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

Thanks for the comments!

On Wed. 13 Jan 2021 à 18:33, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> On 1/12/21 2:05 PM, Vincent Mailhol wrote:
> > This driver supports the ES581.4, ES582.1 and ES584.1 interfaces from
> > ETAS GmbH (https://www.etas.com/en/products/es58x.php).
> >
> > Co-developed-by: Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>
> > Signed-off-by: Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>
> > Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
>
> [...]
>
> > diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
> > new file mode 100644
> > index 000000000000..30692d78d8e6
> > --- /dev/null
> > +++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
> > @@ -0,0 +1,2589 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +/* Driver for ETAS GmbH ES58X USB CAN(-FD) Bus Interfaces.
> > + *
> > + * File es58x_core.c: Core logic to manage the network devices and the
> > + * USB interface.
> > + *
> > + * Copyright (C) 2019 Robert Bosch Engineering and Business
> > + * Solutions. All rights reserved.
> > + * Copyright (C) 2020 ETAS K.K.. All rights reserved.
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/moduleparam.h>
> > +#include <linux/usb.h>
> > +#include <linux/crc16.h>
> > +#include <linux/spinlock.h>
> > +#include <asm/unaligned.h>
> > +
> > +#include "es58x_core.h"
> > +
> > +#define DRV_VERSION "1.00"
> > +MODULE_AUTHOR("Mailhol Vincent <mailhol.vincent@wanadoo.fr>");
> > +MODULE_AUTHOR("Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>");
> > +MODULE_DESCRIPTION("Socket CAN driver for ETAS ES58X USB adapters");
> > +MODULE_VERSION(DRV_VERSION);
> > +MODULE_LICENSE("GPL v2");
> > +
> > +/* Vendor and product id */
> > +#define ES58X_MODULE_NAME "etas_es58x"
> > +#define ES58X_VENDOR_ID 0x108C
> > +#define ES581_4_PRODUCT_ID 0x0159
> > +#define ES582_1_PRODUCT_ID 0x0168
> > +#define ES584_1_PRODUCT_ID 0x0169
> > +
> > +/* Table of devices which work with this driver */
> > +static const struct usb_device_id es58x_id_table[] = {
> > +     {USB_DEVICE(ES58X_VENDOR_ID, ES581_4_PRODUCT_ID)},
> > +     {USB_DEVICE(ES58X_VENDOR_ID, ES582_1_PRODUCT_ID)},
> > +     {USB_DEVICE(ES58X_VENDOR_ID, ES584_1_PRODUCT_ID)},
> > +     {}                      /* Terminating entry */
> > +};
> > +
> > +MODULE_DEVICE_TABLE(usb, es58x_id_table);
> > +
> > +#define es58x_print_hex_dump(buf, len)                                       \
> > +     print_hex_dump(KERN_DEBUG,                                      \
> > +                    ES58X_MODULE_NAME " " __stringify(buf) ": ",     \
> > +                    DUMP_PREFIX_NONE, 16, 1, buf, len, false)
> > +
> > +#define es58x_print_hex_dump_debug(buf, len)                          \
> > +     print_hex_dump_debug(ES58X_MODULE_NAME " " __stringify(buf) ": ",\
> > +                          DUMP_PREFIX_NONE, 16, 1, buf, len, false)
> > +
> > +/* The last two bytes of an ES58X command is a CRC16. The first two
> > + * bytes (the start of frame) are skipped and the CRC calculation
> > + * starts on the third byte.
> > + */
> > +#define ES58X_CRC_CALC_OFFSET        2
> > +
> > +/**
> > + * es58x_calculate_crc() - Compute the crc16 of a given URB.
> > + * @urb_cmd: The URB command for which we want to calculate the CRC.
> > + * @urb_len: Length of @urb_cmd. Must be at least bigger than 4
> > + *   (ES58X_CRC_CALC_OFFSET + sizeof(crc))
> > + *
> > + * Return: crc16 value.
> > + */
> > +static u16 es58x_calculate_crc(const union es58x_urb_cmd *urb_cmd, u16 urb_len)
> > +{
> > +     u16 crc;
> > +     ssize_t len = urb_len - ES58X_CRC_CALC_OFFSET - sizeof(crc);
> > +
> > +     WARN_ON(len < 0);
>
> Is it possible to ensure earlier, that the urbs are of correct length?

Easy answer: it is ensured. On the Tx branch, I create the urbs so I
know for sure that the length is correct. On the Rx branch, I have a
dedicated function: es58x_check_rx_urb() for this purpose.  I
will remove that WARN_ON() and the one in es58x_get_crc().

I will also check the other WARN_ON() in my code to see if they
can be removed (none on my test throughout the last ten months or
so could trigger any of these WARN_ON() so should be fine to
remove but I will double check).

> > +     crc = crc16(0, &urb_cmd->raw_cmd[ES58X_CRC_CALC_OFFSET], len);
> > +     return crc;
> > +}
>
> [...]
>
> > +/**
> > + * struct es58x_priv - All information specific to a CAN channel.
> > + * @can: struct can_priv must be the first member (Socket CAN relies
> > + *   on the fact that function netdev_priv() returns a pointer to
> > + *   a struct can_priv).
> > + * @es58x_dev: pointer to the corresponding ES58X device.
> > + * @tx_urb: Used as a buffer to concatenate the TX messages and to do
> > + *   a bulk send. Please refer to es58x_start_xmit() for more
> > + *   details.
> > + * @echo_skb_spinlock: Spinlock to protect the access to the echo skb
> > + *   FIFO.
> > + * @current_packet_idx: Keeps track of the packet indexes.
> > + * @echo_skb_tail_idx: beginning of the echo skb FIFO, i.e. index of
> > + *   the first element.
> > + * @echo_skb_head_idx: end of the echo skb FIFO plus one, i.e. first
> > + *   free index.
> > + * @num_echo_skb: actual number of elements in the FIFO. Thus, the end
> > + *   of the FIFO is echo_skb_head = (echo_skb_tail_idx +
> > + *   num_echo_skb) % can.echo_skb_max.
> > + * @tx_total_frame_len: sum, in bytes, of the length of each of the
> > + *   CAN messages contained in @tx_urb. To be used as an input of
> > + *   netdev_sent_queue() for BQL.
> > + * @tx_can_msg_cnt: Number of messages in @tx_urb.
> > + * @tx_can_msg_is_fd: false: all messages in @tx_urb are Classical
> > + *   CAN, true: all messages in @tx_urb are CAN FD. Rationale:
> > + *   ES58X FD devices do not allow to mix Classical CAN and FD CAN
> > + *   frames in one single bulk transmission.
> > + * @err_passive_before_rtx_success: The ES58X device might enter in a
> > + *   state in which it keeps alternating between error passive
> > + *   and active state. This counter keeps track of the number of
> > + *   error passive and if it gets bigger than
> > + *   ES58X_CONSECUTIVE_ERR_PASSIVE_MAX, es58x_rx_err_msg() will
> > + *   force the status to bus-off.
> > + * @channel_idx: Channel index, starts at zero.
> > + */
> > +struct es58x_priv {
> > +     struct can_priv can;
> > +     struct es58x_device *es58x_dev;
> > +     struct urb *tx_urb;
> > +
> > +     spinlock_t echo_skb_spinlock;   /* Comments: c.f. supra */
> > +     u32 current_packet_idx;
> > +     u16 echo_skb_tail_idx;
> > +     u16 echo_skb_head_idx;
> > +     u16 num_echo_skb;
>
> Can you explain me how the tx-path works, especially why you need the
> current_packet_idx.
>
> In the mcp251xfd driver, the number of TX buffers is a power of two, that makes
> things easier. tx_heads % len points to the next buffer to be filled, tx_tail %
> len points to the next buffer to be completed. tx_head - tx_tail is the fill
> level of the FIFO. This works without spinlocks.

For what I understand of your explanations here are the equivalences
between the etas_es58x and the mcp251xfd drivers:

 +--------------------+-------------------+
 | etas_es58x         | mcp251xfd         |
 +--------------------+-------------------+
 | current_packet_idx | tx_head           |
 | echo_skb_tail_idx  | tx_tail % len     |
 | echo_skb_head_idx  | tx_head % len     |
 | num_echo_skb       | tx_head - tx_tail |
 +--------------------+-------------------+

Especially, the current_packet_idx is sent to the device and returned
to the driver upon completion.

I wish the TX buffers were a power of two which is unfortunately not
the case. The theoretical TX buffer sizes are 330 and 500 for the two
devices so I wrote the code to work with those values. The exact size
of the TX buffer is actually even more of a mystery because during
testing both devices were unstable when using the theoretical values
and I had to lower these. There is a comment at the bottom of
es581_4.c and es58x_fd.c to reflect those issues. Because I do not
have access to the source code of the firmware, I could not identify
the root cause.

My understanding is that having a queue size being a power of two is
required in order not to use spinlocks (else, modulo operations would
break when the index wraparound back to zero). I tried to minimize the
number of spinlock: only one per bulk send or bulk receive.


Yours sincerely,
Vincent


> > +
> > +     u16 tx_total_frame_len;
> > +     u8 tx_can_msg_cnt;
> > +     bool tx_can_msg_is_fd;
> > +
> > +     u8 err_passive_before_rtx_success;
> > +
> > +     u8 channel_idx;
> > +};
>
> Marc
>
> --
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
>
