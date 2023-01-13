Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE0466963C
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 12:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241590AbjAMLyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 06:54:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241396AbjAMLws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 06:52:48 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC9659F9A
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 03:50:45 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id h192so14809139pgc.7
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 03:50:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VKr2IcEjQYKUOGmfMnCG8Z4Ll7w3dbY4sA34uXRH2+Q=;
        b=xdEoSnmbfyghqkvytXMDa15001/0dGlcU9yVaiemKrUxVWsFmO84VZtKGKeoSOjxfb
         NbfgtHTm0MwWHv7WZwbyQ5AyhsYLrbNLXTpIo6nYl1Y4RkEx/V6f60jE1brLAzdm3Y6o
         /74xdnuuJn3vWfDveW0rtZeAHpmO60/nMVp3q5ADF5lF8L15VVVxwLEKX2qujGNCI8aC
         7rbtYTmJWqj5mXCtmj9nWBVRI60+qcjNaGyxZtbNtMz77JqtZnFm/ilMMpD26fR8DdlZ
         gs0OLROmdkV4V97FWe6jsxWwFJ/vhLSs1aIffNeDEGIefWFvfRLwyw526YFbMUYfcBCv
         fC7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VKr2IcEjQYKUOGmfMnCG8Z4Ll7w3dbY4sA34uXRH2+Q=;
        b=2SVErpi7tBKpSdRhWDmrSubH3sfGDE0IDdVhWlc5IGkOWWweA8VmuVAYgYz3gX20l5
         rTAsVWWD4V0tjCVeBAZLhansfwxrQTULVUbFWIm6uO9KUsxHxU8nWtNjR6HPrAryvenL
         MS7LARAZ6JxZ71qW1hikn0a5ILA0No6TH6RHONv5SbqWPon2UAIpBy1Lgd9HTLPkPUBB
         I3gg22L7sF3rwWYRl8IDaXQmJlOdXlruWjW5AjXU91+KufTejI/xk7hhXtrODeJLPnAs
         Es/AHB5gvZy6Aoef4QzfrFgPykU8A8TBaGxCcL5rg/0hEPrt7aomp3nsl+eNIJdCXi00
         1bRQ==
X-Gm-Message-State: AFqh2kqn2+QNfx2oedVb/W721QBFgpFBpG+fFgjrtHU+94RcBTuR3b+D
        uB87W7TyDDQ90Fz4H+9wa7ea6+oFo/8OTFDqmy9kug==
X-Google-Smtp-Source: AMrXdXvXKuc2aF8g+pZC1CqyDlr5t4/A2y+HCHs+bfew042ix5z0lxmQoU7Z0ppIgzQFFKh0zpEoe8x+QXzUBbNveXw=
X-Received: by 2002:a05:6a00:27a9:b0:58b:a40d:68ca with SMTP id
 bd41-20020a056a0027a900b0058ba40d68camr415435pfb.28.1673610644676; Fri, 13
 Jan 2023 03:50:44 -0800 (PST)
MIME-Version: 1.0
References: <20230111142331.34518-1-ilpo.jarvinen@linux.intel.com> <20230111142331.34518-7-ilpo.jarvinen@linux.intel.com>
In-Reply-To: <20230111142331.34518-7-ilpo.jarvinen@linux.intel.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Fri, 13 Jan 2023 12:50:08 +0100
Message-ID: <CAPDyKFo4=AtY=iijz6ye5oPk9Jqr=JUfEPZ2kzp-Gmd7Yc7Ajg@mail.gmail.com>
Subject: Re: [PATCH v3 06/13] tty: Convert ->carrier_raised() and callchains
 to bool
To:     =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc:     linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        =?UTF-8?Q?Samuel_Iglesias_Gons=C3=A1lvez?= <siglesias@igalia.com>,
        Rodolfo Giometti <giometti@enneenne.com>,
        Arnd Bergmann <arnd@arndb.de>, Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Jan 2023 at 15:24, Ilpo J=C3=A4rvinen
<ilpo.jarvinen@linux.intel.com> wrote:
>
> Return boolean from ->carrier_raised() instead of 0 and 1. Make the
> return type change also to tty_port_carrier_raised() that makes the
> ->carrier_raised() call (+ cd variable in moxa into which its return
> value is stored).
>
> Also cleans up a few unnecessary constructs related to this change:
>
>         return xx ? 1 : 0;
>         -> return xx;
>
>         if (xx)
>                 return 1;
>         return 0;
>         -> return xx;
>
> Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
> Signed-off-by: Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>

Acked-by: Ulf Hansson <ulf.hansson@linaro.org> # For MMC

Kind regards
Uffe



> ---
>  drivers/char/pcmcia/synclink_cs.c | 8 +++-----
>  drivers/mmc/core/sdio_uart.c      | 7 +++----
>  drivers/tty/amiserial.c           | 2 +-
>  drivers/tty/moxa.c                | 4 ++--
>  drivers/tty/mxser.c               | 5 +++--
>  drivers/tty/n_gsm.c               | 8 ++++----
>  drivers/tty/serial/serial_core.c  | 9 ++++-----
>  drivers/tty/synclink_gt.c         | 7 ++++---
>  drivers/tty/tty_port.c            | 4 ++--
>  drivers/usb/serial/ch341.c        | 7 +++----
>  drivers/usb/serial/f81232.c       | 6 ++----
>  drivers/usb/serial/pl2303.c       | 7 ++-----
>  drivers/usb/serial/spcp8x5.c      | 7 ++-----
>  drivers/usb/serial/usb-serial.c   | 4 ++--
>  include/linux/tty_port.h          | 6 +++---
>  include/linux/usb/serial.h        | 2 +-
>  net/bluetooth/rfcomm/tty.c        | 2 +-
>  17 files changed, 42 insertions(+), 53 deletions(-)
>
> diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/sync=
link_cs.c
> index baa46e8a094b..4391138e1b8a 100644
> --- a/drivers/char/pcmcia/synclink_cs.c
> +++ b/drivers/char/pcmcia/synclink_cs.c
> @@ -377,7 +377,7 @@ static void async_mode(MGSLPC_INFO *info);
>
>  static void tx_timeout(struct timer_list *t);
>
> -static int carrier_raised(struct tty_port *port);
> +static bool carrier_raised(struct tty_port *port);
>  static void dtr_rts(struct tty_port *port, int onoff);
>
>  #if SYNCLINK_GENERIC_HDLC
> @@ -2430,7 +2430,7 @@ static void mgslpc_hangup(struct tty_struct *tty)
>         tty_port_hangup(&info->port);
>  }
>
> -static int carrier_raised(struct tty_port *port)
> +static bool carrier_raised(struct tty_port *port)
>  {
>         MGSLPC_INFO *info =3D container_of(port, MGSLPC_INFO, port);
>         unsigned long flags;
> @@ -2439,9 +2439,7 @@ static int carrier_raised(struct tty_port *port)
>         get_signals(info);
>         spin_unlock_irqrestore(&info->lock, flags);
>
> -       if (info->serial_signals & SerialSignal_DCD)
> -               return 1;
> -       return 0;
> +       return info->serial_signals & SerialSignal_DCD;
>  }
>
>  static void dtr_rts(struct tty_port *port, int onoff)
> diff --git a/drivers/mmc/core/sdio_uart.c b/drivers/mmc/core/sdio_uart.c
> index ae7ef2e038be..47f58258d8ff 100644
> --- a/drivers/mmc/core/sdio_uart.c
> +++ b/drivers/mmc/core/sdio_uart.c
> @@ -526,7 +526,7 @@ static void sdio_uart_irq(struct sdio_func *func)
>         port->in_sdio_uart_irq =3D NULL;
>  }
>
> -static int uart_carrier_raised(struct tty_port *tport)
> +static bool uart_carrier_raised(struct tty_port *tport)
>  {
>         struct sdio_uart_port *port =3D
>                         container_of(tport, struct sdio_uart_port, port);
> @@ -535,9 +535,8 @@ static int uart_carrier_raised(struct tty_port *tport=
)
>                 return 1;
>         ret =3D sdio_uart_get_mctrl(port);
>         sdio_uart_release_func(port);
> -       if (ret & TIOCM_CAR)
> -               return 1;
> -       return 0;
> +
> +       return ret & TIOCM_CAR;
>  }
>
>  /**
> diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
> index 460d33a1e70b..01c4fd3ce7c8 100644
> --- a/drivers/tty/amiserial.c
> +++ b/drivers/tty/amiserial.c
> @@ -1454,7 +1454,7 @@ static const struct tty_operations serial_ops =3D {
>         .proc_show =3D rs_proc_show,
>  };
>
> -static int amiga_carrier_raised(struct tty_port *port)
> +static bool amiga_carrier_raised(struct tty_port *port)
>  {
>         return !(ciab.pra & SER_DCD);
>  }
> diff --git a/drivers/tty/moxa.c b/drivers/tty/moxa.c
> index 2d9635e14ded..6a1e78e33a2c 100644
> --- a/drivers/tty/moxa.c
> +++ b/drivers/tty/moxa.c
> @@ -501,7 +501,7 @@ static int moxa_tiocmset(struct tty_struct *tty,
>  static void moxa_poll(struct timer_list *);
>  static void moxa_set_tty_param(struct tty_struct *, const struct ktermio=
s *);
>  static void moxa_shutdown(struct tty_port *);
> -static int moxa_carrier_raised(struct tty_port *);
> +static bool moxa_carrier_raised(struct tty_port *);
>  static void moxa_dtr_rts(struct tty_port *, int);
>  /*
>   * moxa board interface functions:
> @@ -1432,7 +1432,7 @@ static void moxa_shutdown(struct tty_port *port)
>         MoxaPortFlushData(ch, 2);
>  }
>
> -static int moxa_carrier_raised(struct tty_port *port)
> +static bool moxa_carrier_raised(struct tty_port *port)
>  {
>         struct moxa_port *ch =3D container_of(port, struct moxa_port, por=
t);
>         int dcd;
> diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
> index 2926a831727d..96c72e691cd7 100644
> --- a/drivers/tty/mxser.c
> +++ b/drivers/tty/mxser.c
> @@ -458,10 +458,11 @@ static void __mxser_stop_tx(struct mxser_port *info=
)
>         outb(info->IER, info->ioaddr + UART_IER);
>  }
>
> -static int mxser_carrier_raised(struct tty_port *port)
> +static bool mxser_carrier_raised(struct tty_port *port)
>  {
>         struct mxser_port *mp =3D container_of(port, struct mxser_port, p=
ort);
> -       return (inb(mp->ioaddr + UART_MSR) & UART_MSR_DCD)?1:0;
> +
> +       return inb(mp->ioaddr + UART_MSR) & UART_MSR_DCD;
>  }
>
>  static void mxser_dtr_rts(struct tty_port *port, int on)
> diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
> index 631539c17d85..81fc2ec3693f 100644
> --- a/drivers/tty/n_gsm.c
> +++ b/drivers/tty/n_gsm.c
> @@ -3770,16 +3770,16 @@ static int gsm_modem_update(struct gsm_dlci *dlci=
, u8 brk)
>         return -EPROTONOSUPPORT;
>  }
>
> -static int gsm_carrier_raised(struct tty_port *port)
> +static bool gsm_carrier_raised(struct tty_port *port)
>  {
>         struct gsm_dlci *dlci =3D container_of(port, struct gsm_dlci, por=
t);
>         struct gsm_mux *gsm =3D dlci->gsm;
>
>         /* Not yet open so no carrier info */
>         if (dlci->state !=3D DLCI_OPEN)
> -               return 0;
> +               return false;
>         if (debug & DBG_CD_ON)
> -               return 1;
> +               return true;
>
>         /*
>          * Basic mode with control channel in ADM mode may not respond
> @@ -3787,7 +3787,7 @@ static int gsm_carrier_raised(struct tty_port *port=
)
>          */
>         if (gsm->encoding =3D=3D GSM_BASIC_OPT &&
>             gsm->dlci[0]->mode =3D=3D DLCI_MODE_ADM && !dlci->modem_rx)
> -               return 1;
> +               return true;
>
>         return dlci->modem_rx & TIOCM_CD;
>  }
> diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial=
_core.c
> index f7074ac02801..20ed8a088b2d 100644
> --- a/drivers/tty/serial/serial_core.c
> +++ b/drivers/tty/serial/serial_core.c
> @@ -1861,7 +1861,7 @@ static void uart_port_shutdown(struct tty_port *por=
t)
>         }
>  }
>
> -static int uart_carrier_raised(struct tty_port *port)
> +static bool uart_carrier_raised(struct tty_port *port)
>  {
>         struct uart_state *state =3D container_of(port, struct uart_state=
, port);
>         struct uart_port *uport;
> @@ -1875,15 +1875,14 @@ static int uart_carrier_raised(struct tty_port *p=
ort)
>          * continue and not sleep
>          */
>         if (WARN_ON(!uport))
> -               return 1;
> +               return true;
>         spin_lock_irq(&uport->lock);
>         uart_enable_ms(uport);
>         mctrl =3D uport->ops->get_mctrl(uport);
>         spin_unlock_irq(&uport->lock);
>         uart_port_deref(uport);
> -       if (mctrl & TIOCM_CAR)
> -               return 1;
> -       return 0;
> +
> +       return mctrl & TIOCM_CAR;
>  }
>
>  static void uart_dtr_rts(struct tty_port *port, int raise)
> diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/synclink_gt.c
> index 81c94906f06e..4ba71ec764f7 100644
> --- a/drivers/tty/synclink_gt.c
> +++ b/drivers/tty/synclink_gt.c
> @@ -3126,7 +3126,7 @@ static int tiocmset(struct tty_struct *tty,
>         return 0;
>  }
>
> -static int carrier_raised(struct tty_port *port)
> +static bool carrier_raised(struct tty_port *port)
>  {
>         unsigned long flags;
>         struct slgt_info *info =3D container_of(port, struct slgt_info, p=
ort);
> @@ -3134,7 +3134,8 @@ static int carrier_raised(struct tty_port *port)
>         spin_lock_irqsave(&info->lock,flags);
>         get_gtsignals(info);
>         spin_unlock_irqrestore(&info->lock,flags);
> -       return (info->signals & SerialSignal_DCD) ? 1 : 0;
> +
> +       return info->signals & SerialSignal_DCD;
>  }
>
>  static void dtr_rts(struct tty_port *port, int on)
> @@ -3162,7 +3163,7 @@ static int block_til_ready(struct tty_struct *tty, =
struct file *filp,
>         int             retval;
>         bool            do_clocal =3D false;
>         unsigned long   flags;
> -       int             cd;
> +       bool            cd;
>         struct tty_port *port =3D &info->port;
>
>         DBGINFO(("%s block_til_ready\n", tty->driver->name));
> diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
> index 469de3c010b8..a573c500f95b 100644
> --- a/drivers/tty/tty_port.c
> +++ b/drivers/tty/tty_port.c
> @@ -444,10 +444,10 @@ EXPORT_SYMBOL_GPL(tty_port_tty_wakeup);
>   * to hide some internal details. This will eventually become entirely
>   * internal to the tty port.
>   */
> -int tty_port_carrier_raised(struct tty_port *port)
> +bool tty_port_carrier_raised(struct tty_port *port)
>  {
>         if (port->ops->carrier_raised =3D=3D NULL)
> -               return 1;
> +               return true;
>         return port->ops->carrier_raised(port);
>  }
>  EXPORT_SYMBOL(tty_port_carrier_raised);
> diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
> index 6e1b87e67304..792f01a4ed22 100644
> --- a/drivers/usb/serial/ch341.c
> +++ b/drivers/usb/serial/ch341.c
> @@ -413,12 +413,11 @@ static void ch341_port_remove(struct usb_serial_por=
t *port)
>         kfree(priv);
>  }
>
> -static int ch341_carrier_raised(struct usb_serial_port *port)
> +static bool ch341_carrier_raised(struct usb_serial_port *port)
>  {
>         struct ch341_private *priv =3D usb_get_serial_port_data(port);
> -       if (priv->msr & CH341_BIT_DCD)
> -               return 1;
> -       return 0;
> +
> +       return priv->msr & CH341_BIT_DCD;
>  }
>
>  static void ch341_dtr_rts(struct usb_serial_port *port, int on)
> diff --git a/drivers/usb/serial/f81232.c b/drivers/usb/serial/f81232.c
> index 891fb1fe69df..1a8c2925c26f 100644
> --- a/drivers/usb/serial/f81232.c
> +++ b/drivers/usb/serial/f81232.c
> @@ -774,7 +774,7 @@ static bool f81232_tx_empty(struct usb_serial_port *p=
ort)
>         return true;
>  }
>
> -static int f81232_carrier_raised(struct usb_serial_port *port)
> +static bool f81232_carrier_raised(struct usb_serial_port *port)
>  {
>         u8 msr;
>         struct f81232_private *priv =3D usb_get_serial_port_data(port);
> @@ -783,9 +783,7 @@ static int f81232_carrier_raised(struct usb_serial_po=
rt *port)
>         msr =3D priv->modem_status;
>         mutex_unlock(&priv->lock);
>
> -       if (msr & UART_MSR_DCD)
> -               return 1;
> -       return 0;
> +       return msr & UART_MSR_DCD;
>  }
>
>  static void f81232_get_serial(struct tty_struct *tty, struct serial_stru=
ct *ss)
> diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
> index 8949c1891164..4cb81746a149 100644
> --- a/drivers/usb/serial/pl2303.c
> +++ b/drivers/usb/serial/pl2303.c
> @@ -1050,14 +1050,11 @@ static int pl2303_tiocmget(struct tty_struct *tty=
)
>         return result;
>  }
>
> -static int pl2303_carrier_raised(struct usb_serial_port *port)
> +static bool pl2303_carrier_raised(struct usb_serial_port *port)
>  {
>         struct pl2303_private *priv =3D usb_get_serial_port_data(port);
>
> -       if (priv->line_status & UART_DCD)
> -               return 1;
> -
> -       return 0;
> +       return priv->line_status & UART_DCD;
>  }
>
>  static void pl2303_set_break(struct usb_serial_port *port, bool enable)
> diff --git a/drivers/usb/serial/spcp8x5.c b/drivers/usb/serial/spcp8x5.c
> index 09a972a838ee..8175db6c4554 100644
> --- a/drivers/usb/serial/spcp8x5.c
> +++ b/drivers/usb/serial/spcp8x5.c
> @@ -247,16 +247,13 @@ static void spcp8x5_set_work_mode(struct usb_serial=
_port *port, u16 value,
>                 dev_err(&port->dev, "failed to set work mode: %d\n", ret)=
;
>  }
>
> -static int spcp8x5_carrier_raised(struct usb_serial_port *port)
> +static bool spcp8x5_carrier_raised(struct usb_serial_port *port)
>  {
>         u8 msr;
>         int ret;
>
>         ret =3D spcp8x5_get_msr(port, &msr);
> -       if (ret || msr & MSR_STATUS_LINE_DCD)
> -               return 1;
> -
> -       return 0;
> +       return ret || msr & MSR_STATUS_LINE_DCD;
>  }
>
>  static void spcp8x5_dtr_rts(struct usb_serial_port *port, int on)
> diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-ser=
ial.c
> index 164521ee10c6..019720a63fac 100644
> --- a/drivers/usb/serial/usb-serial.c
> +++ b/drivers/usb/serial/usb-serial.c
> @@ -754,7 +754,7 @@ static struct usb_serial_driver *search_serial_device=
(
>         return NULL;
>  }
>
> -static int serial_port_carrier_raised(struct tty_port *port)
> +static bool serial_port_carrier_raised(struct tty_port *port)
>  {
>         struct usb_serial_port *p =3D container_of(port, struct usb_seria=
l_port, port);
>         struct usb_serial_driver *drv =3D p->serial->type;
> @@ -762,7 +762,7 @@ static int serial_port_carrier_raised(struct tty_port=
 *port)
>         if (drv->carrier_raised)
>                 return drv->carrier_raised(p);
>         /* No carrier control - don't block */
> -       return 1;
> +       return true;
>  }
>
>  static void serial_port_dtr_rts(struct tty_port *port, int on)
> diff --git a/include/linux/tty_port.h b/include/linux/tty_port.h
> index fa3c3bdaa234..cf098459cb01 100644
> --- a/include/linux/tty_port.h
> +++ b/include/linux/tty_port.h
> @@ -15,7 +15,7 @@ struct tty_struct;
>
>  /**
>   * struct tty_port_operations -- operations on tty_port
> - * @carrier_raised: return 1 if the carrier is raised on @port
> + * @carrier_raised: return true if the carrier is raised on @port
>   * @dtr_rts: raise the DTR line if @raise is nonzero, otherwise lower DT=
R
>   * @shutdown: called when the last close completes or a hangup finishes =
IFF the
>   *     port was initialized. Do not use to free resources. Turn off the =
device
> @@ -31,7 +31,7 @@ struct tty_struct;
>   *     the port itself.
>   */
>  struct tty_port_operations {
> -       int (*carrier_raised)(struct tty_port *port);
> +       bool (*carrier_raised)(struct tty_port *port);
>         void (*dtr_rts)(struct tty_port *port, int raise);
>         void (*shutdown)(struct tty_port *port);
>         int (*activate)(struct tty_port *port, struct tty_struct *tty);
> @@ -230,7 +230,7 @@ static inline void tty_port_set_kopened(struct tty_po=
rt *port, bool val)
>
>  struct tty_struct *tty_port_tty_get(struct tty_port *port);
>  void tty_port_tty_set(struct tty_port *port, struct tty_struct *tty);
> -int tty_port_carrier_raised(struct tty_port *port);
> +bool tty_port_carrier_raised(struct tty_port *port);
>  void tty_port_raise_dtr_rts(struct tty_port *port);
>  void tty_port_lower_dtr_rts(struct tty_port *port);
>  void tty_port_hangup(struct tty_port *port);
> diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
> index f7bfedb740f5..dc7f90522b42 100644
> --- a/include/linux/usb/serial.h
> +++ b/include/linux/usb/serial.h
> @@ -293,7 +293,7 @@ struct usb_serial_driver {
>         /* Called by the tty layer for port level work. There may or may =
not
>            be an attached tty at this point */
>         void (*dtr_rts)(struct usb_serial_port *port, int on);
> -       int  (*carrier_raised)(struct usb_serial_port *port);
> +       bool (*carrier_raised)(struct usb_serial_port *port);
>         /* Called by the usb serial hooks to allow the user to rework the
>            termios state */
>         void (*init_termios)(struct tty_struct *tty);
> diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
> index 8009e0e93216..5697df9d4394 100644
> --- a/net/bluetooth/rfcomm/tty.c
> +++ b/net/bluetooth/rfcomm/tty.c
> @@ -119,7 +119,7 @@ static int rfcomm_dev_activate(struct tty_port *port,=
 struct tty_struct *tty)
>  }
>
>  /* we block the open until the dlc->state becomes BT_CONNECTED */
> -static int rfcomm_dev_carrier_raised(struct tty_port *port)
> +static bool rfcomm_dev_carrier_raised(struct tty_port *port)
>  {
>         struct rfcomm_dev *dev =3D container_of(port, struct rfcomm_dev, =
port);
>
> --
> 2.30.2
>
