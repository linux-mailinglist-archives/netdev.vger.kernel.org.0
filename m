Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71F3D45D16D
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 00:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237267AbhKXX6z convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 24 Nov 2021 18:58:55 -0500
Received: from mail-qk1-f176.google.com ([209.85.222.176]:47101 "EHLO
        mail-qk1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236146AbhKXX6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 18:58:55 -0500
Received: by mail-qk1-f176.google.com with SMTP id a11so6234157qkh.13;
        Wed, 24 Nov 2021 15:55:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GN3PIwpL+ERryD6L7UO03x3iOUbpm53NcLZtTh43TYo=;
        b=BUpo+JmbTy2HA+I/UYbRbnrXaB6hEc6QwTapjASmFp0e6xPFqyqPAFOtMqelfezvdX
         rC0mWKVRlgmSJd7TUG8TgmSX5hW9TM0D41xGloa8CIrRIAkspktU1BdmVOZSB3WP70Q9
         tIqqjjMODEbhl5TVZA/98rJ8I70iCo18SmBukc1EIgd4ymDd1Dwf/s3C1FAKn440yV+K
         YN68fVkDgrnhDX5007Io9UMCBv9Vb26HIcZ11vH0Q6pVYztfQLqZNl1VayFzA4E4pLK7
         +S2cp1Q37kOzOHGUbqA8iPgEzG/4XnMNu4D3/hs5V6wsfDNHaiqg3+IN6JAZak1DaJsK
         yEbA==
X-Gm-Message-State: AOAM530cdBz5wWA226sZdKmiDZsbCm1qHTbEvME+IXgcYeWYAKpvb4d3
        +pijurXt2l8TZkb3DNsTbSvkn8j31EH1B88bUC/IluYTVPU=
X-Google-Smtp-Source: ABdhPJzcIGpIB9SJjGWBHDNUsIoxo4sDxPgxKlEvJaTIxZRIUV/Klnk+NGISbDOBvWup4NClDAcRVy7RrGGl+wn3jQU=
X-Received: by 2002:a25:ae62:: with SMTP id g34mr1445748ybe.388.1637798144105;
 Wed, 24 Nov 2021 15:55:44 -0800 (PST)
MIME-Version: 1.0
References: <20211123115333.624335-1-mailhol.vincent@wanadoo.fr>
 <20211123115333.624335-3-mailhol.vincent@wanadoo.fr> <e2d90af1cf41bb9893225289822f93f036d415bb.camel@esd.eu>
In-Reply-To: <e2d90af1cf41bb9893225289822f93f036d415bb.camel@esd.eu>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Thu, 25 Nov 2021 08:55:33 +0900
Message-ID: <CAMZ6RqKKe=hooYH7xSGyJC2n+MGG8vSOZtZVfbT7-QQ_Ax=Hww@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] can: do not increase rx_bytes statistics for RTR frames
To:     =?UTF-8?Q?Stefan_M=C3=A4tje?= <Stefan.Maetje@esd.eu>
Cc:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "appana.durga.rao@xilinx.com" <appana.durga.rao@xilinx.com>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "mripard@kernel.org" <mripard@kernel.org>,
        "wens@csie.org" <wens@csie.org>,
        "jernej.skrabec@gmail.com" <jernej.skrabec@gmail.com>,
        "yashi@spacecubics.com" <yashi@spacecubics.com>,
        "rcsekar@samsung.com" <rcsekar@samsung.com>,
        "naga.sureshkumar.relli@xilinx.com" 
        <naga.sureshkumar.relli@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-sunxi@lists.linux.dev" <linux-sunxi@lists.linux.dev>,
        "s.grosjean@peak-system.com" <s.grosjean@peak-system.com>,
        "ludovic.desroches@microchip.com" <ludovic.desroches@microchip.com>,
        "extja@kvaser.com" <extja@kvaser.com>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefan,

On Thu. 25 Nov 2021 at 02:59, Stefan Mätje <Stefan.Maetje@esd.eu> wrote:
> Hi Vincent,
>
> I would like to suggest a slightly different patch for the esd_usb2.c (as
> added below).
>
> Best regards,
>     Stefan Mätje
>
> Am Dienstag, den 23.11.2021, 20:53 +0900 schrieb Vincent Mailhol:
> > The actual payload length of the CAN Remote Transmission Request (RTR)
> > frames is always 0, i.e. nothing is transmitted on the wire. However,
> > those RTR frames still uses the DLC to indicate the length of the
> > requested frame.
> >
> > As such, net_device_stats:rx_bytes should not be increased for the RTR
> > frames.
> >
> > This patch fixes all the CAN drivers.
> >
> > CC: Jimmy Assarsson <extja@kvaser.com>
> > CC: Marc Kleine-Budde <mkl@pengutronix.de>
> > CC: Nicolas Ferre <nicolas.ferre@microchip.com>
> > CC: Alexandre Belloni <alexandre.belloni@bootlin.com>
> > CC: Ludovic Desroches <ludovic.desroches@microchip.com>
> > CC: Chandrasekar Ramakrishnan <rcsekar@samsung.com>
> > CC: Maxime Ripard <mripard@kernel.org>
> > CC: Chen-Yu Tsai <wens@csie.org>
> > CC: Jernej Skrabec <jernej.skrabec@gmail.com>
> > CC: Yasushi SHOJI <yashi@spacecubics.com>
> > CC: Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>
> > CC: Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>
> > CC: Michal Simek <michal.simek@xilinx.com>
> > CC: Stephane Grosjean <s.grosjean@peak-system.com>
> > Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> > ---
> >  drivers/net/can/at91_can.c                        | 3 ++-
> >  drivers/net/can/c_can/c_can_main.c                | 3 ++-
> >  drivers/net/can/cc770/cc770.c                     | 3 ++-
> >  drivers/net/can/dev/rx-offload.c                  | 3 ++-
> >  drivers/net/can/grcan.c                           | 3 ++-
> >  drivers/net/can/ifi_canfd/ifi_canfd.c             | 3 ++-
> >  drivers/net/can/janz-ican3.c                      | 3 ++-
> >  drivers/net/can/kvaser_pciefd.c                   | 3 ++-
> >  drivers/net/can/m_can/m_can.c                     | 3 ++-
> >  drivers/net/can/mscan/mscan.c                     | 3 ++-
> >  drivers/net/can/pch_can.c                         | 3 ++-
> >  drivers/net/can/peak_canfd/peak_canfd.c           | 3 ++-
> >  drivers/net/can/rcar/rcar_can.c                   | 3 ++-
> >  drivers/net/can/rcar/rcar_canfd.c                 | 3 ++-
> >  drivers/net/can/sja1000/sja1000.c                 | 3 ++-
> >  drivers/net/can/slcan.c                           | 3 ++-
> >  drivers/net/can/spi/hi311x.c                      | 3 ++-
> >  drivers/net/can/spi/mcp251x.c                     | 3 ++-
> >  drivers/net/can/sun4i_can.c                       | 3 ++-
> >  drivers/net/can/usb/ems_usb.c                     | 3 ++-
> >  drivers/net/can/usb/esd_usb2.c                    | 3 ++-
> >  drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 6 ++++--
> >  drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 3 ++-
> >  drivers/net/can/usb/mcba_usb.c                    | 3 ++-
> >  drivers/net/can/usb/peak_usb/pcan_usb.c           | 3 ++-
> >  drivers/net/can/usb/peak_usb/pcan_usb_fd.c        | 8 ++++----
> >  drivers/net/can/usb/peak_usb/pcan_usb_pro.c       | 9 +++++----
> >  drivers/net/can/usb/ucan.c                        | 3 ++-
> >  drivers/net/can/usb/usb_8dev.c                    | 8 ++++----
> >  drivers/net/can/xilinx_can.c                      | 8 +++++---
> >  30 files changed, 72 insertions(+), 42 deletions(-)
> >
...
> >
> > diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
> > index 5f6915a27b3d..ac65ddfe814d 100644
> > --- a/drivers/net/can/usb/esd_usb2.c
> > +++ b/drivers/net/can/usb/esd_usb2.c
> > @@ -335,7 +335,8 @@ static void esd_usb2_rx_can_msg(struct esd_usb2_net_priv *priv,
> >               }
> >
> >               stats->rx_packets++;
> > -             stats->rx_bytes += cf->len;
> > +             if (!(cf->can_id & CAN_RTR_FLAG))
> > +                     stats->rx_bytes += cf->len;
> >               netif_rx(skb);
> >       }
> >
>
> The version below would save us adding another if() statement to check for RTR or
> normal frame that is already tested in the if() statement directly before.
>
> diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
> index c6068a251fbe..2f91a18fe592 100644
> --- a/drivers/net/can/usb/esd_usb2.c
> +++ b/drivers/net/can/usb/esd_usb2.c
> @@ -332,14 +332,14 @@ static void esd_usb2_rx_can_msg(struct esd_usb2_net_priv *priv,
>                 if (msg->msg.rx.dlc & ESD_RTR) {
>                         cf->can_id |= CAN_RTR_FLAG;
>                 } else {
>                         for (i = 0; i < cf->len; i++)
>                                 cf->data[i] = msg->msg.rx.data[i];
> +                       stats->rx_bytes += cf->len;
>                 }
> -
>                 stats->rx_packets++;
> -               stats->rx_bytes += cf->len;
> +
>                 netif_rx(skb);
>         }
>
>         return;
>  }

Work for me! I will add this in the v2 (under preparation).

Yours sincerely,
Vincent Mailhol
