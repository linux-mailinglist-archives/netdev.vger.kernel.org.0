Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39E7057F988
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 08:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbiGYGkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 02:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbiGYGkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 02:40:40 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7FB55BA
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 23:40:38 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id b21so4980208ljk.8
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 23:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3n2kEuwuuK7IkJ0ff/d4b/av1Jc3vPr0Y+VbQ9saI84=;
        b=LMFj5ZuaBlD5A8dOVY5use5OPng2TabtOQeQh3sj1+jQuFlqkgAZUEmCK8tSwYgexa
         o2MsvhXhVrSMXTC9diMSKAfs4wAZuvHIqEhL/GdOURDxkZOeJ7e/fIS5RBAjIuiKWfcA
         gqtQq0NLk4mZWY2TGmOQJx/c1R0bJUVAsjrac=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3n2kEuwuuK7IkJ0ff/d4b/av1Jc3vPr0Y+VbQ9saI84=;
        b=tHCZLAOlVsw2FRgcUX+GQL/Momnz2Uvg49wrRgdAs9RR+A554MGedlI39FZGw2oATQ
         Ny5JcfwSGRg6Py/bJsh83KRm4BGXHLPwo3cavc3EhlK+p2gydDWZKUDIs68hMFBqTHvN
         FrmhSxC/Cfer1zUY7/79YAr6uVss830VtxXYY4mYWe5k7EQMYMjM+LPmyg3+8Ho5TbpE
         EV1VgkuHEz6arRtF+u6ADobzctk2LmyjnfFxLGo8+cxqC3AfVWcjoxyo8qQuZRiAhIyt
         h4OgE6ITXZ4/47PUpz/BjJ74ddDMpG5i+m9ML+p0dPGuuSX5c65q/7O4AgM10jjZMv1s
         gIFw==
X-Gm-Message-State: AJIora90EBIrSQfksO90Ha7GEYIbyJ7WubeiNXUELsNJygBbxSfmT8xs
        EpsSs/uYBmooPSu7KbFg32a2c6EyEYC6lFUitlKUsA==
X-Google-Smtp-Source: AGRyM1sn3iWkEiLU6hMHnvyasmekyibSLlJDbi1WCJvYwpGTp4FtZLeav7l27mv0g0B0s3BIzRQHP86NWkxqKLRXK1k=
X-Received: by 2002:a2e:bf0e:0:b0:258:e99e:998c with SMTP id
 c14-20020a2ebf0e000000b00258e99e998cmr3841212ljr.365.1658731236073; Sun, 24
 Jul 2022 23:40:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220716170007.2020037-1-dario.binacchi@amarulasolutions.com>
 <20220716170007.2020037-3-dario.binacchi@amarulasolutions.com> <20220717233842.1451e349.max@enpas.org>
In-Reply-To: <20220717233842.1451e349.max@enpas.org>
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
Date:   Mon, 25 Jul 2022 08:40:24 +0200
Message-ID: <CABGWkvrgX+9J-rOb-EO1wXVAZQ5phwKKpbc-iD491rD9zn5UpQ@mail.gmail.com>
Subject: Re: [RFC PATCH 2/5] can: slcan: remove legacy infrastructure
To:     Max Staudt <max@enpas.org>
Cc:     linux-kernel@vger.kernel.org,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Max,

First of all thank you for your review, it took me a while to get back
to you because I wanted to
do some analysis and tests regarding the code you suggested I change
and also last week
was very busy.

On Sun, Jul 17, 2022 at 11:38 PM Max Staudt <max@enpas.org> wrote:
>
> Hi Dario,
>
> This looks good, thank you for continuing to look after slcan!
>
> A few comments below.
>
>
>
> On Sat, 16 Jul 2022 19:00:04 +0200
> Dario Binacchi <dario.binacchi@amarulasolutions.com> wrote:
>
> [...]
>
>
> > @@ -68,7 +62,6 @@ MODULE_PARM_DESC(maxdev, "Maximum number of slcan interfaces");
> >                                  SLC_STATE_BE_TXCNT_LEN)
> >  struct slcan {
> >       struct can_priv         can;
> > -     int                     magic;
> >
> >       /* Various fields. */
> >       struct tty_struct       *tty;           /* ptr to TTY structure      */
> > @@ -84,17 +77,14 @@ struct slcan {
> >       int                     xleft;          /* bytes left in XMIT queue  */
> >
> >       unsigned long           flags;          /* Flag values/ mode etc     */
> > -#define SLF_INUSE            0               /* Channel in use            */
> > -#define SLF_ERROR            1               /* Parity, etc. error        */
> > -#define SLF_XCMD             2               /* Command transmission      */
> > +#define SLF_ERROR            0               /* Parity, etc. error        */
> > +#define SLF_XCMD             1               /* Command transmission      */
> >       unsigned long           cmd_flags;      /* Command flags             */
> >  #define CF_ERR_RST           0               /* Reset errors on open      */
> >       wait_queue_head_t       xcmd_wait;      /* Wait queue for commands   */
>
> I assume xcmd_wait() came in as part of the previous patch series?
>

Yes, correct.

>
> [...]
>
>
> >  /* Send a can_frame to a TTY queue. */
> > @@ -652,25 +637,21 @@ static int slc_close(struct net_device *dev)
> >       struct slcan *sl = netdev_priv(dev);
> >       int err;
> >
> > -     spin_lock_bh(&sl->lock);
> > -     if (sl->tty) {
> > -             if (sl->can.bittiming.bitrate &&
> > -                 sl->can.bittiming.bitrate != CAN_BITRATE_UNKNOWN) {
> > -                     spin_unlock_bh(&sl->lock);
> > -                     err = slcan_transmit_cmd(sl, "C\r");
> > -                     spin_lock_bh(&sl->lock);
> > -                     if (err)
> > -                             netdev_warn(dev,
> > -                                         "failed to send close command 'C\\r'\n");
> > -             }
> > -
> > -             /* TTY discipline is running. */
> > -             clear_bit(TTY_DO_WRITE_WAKEUP, &sl->tty->flags);
> > +     if (sl->can.bittiming.bitrate &&
> > +         sl->can.bittiming.bitrate != CAN_BITRATE_UNKNOWN) {
> > +             err = slcan_transmit_cmd(sl, "C\r");
> > +             if (err)
> > +                     netdev_warn(dev,
> > +                                 "failed to send close command 'C\\r'\n");
> >       }
> > +
> > +     /* TTY discipline is running. */
> > +     clear_bit(TTY_DO_WRITE_WAKEUP, &sl->tty->flags);
> > +     flush_work(&sl->tx_work);
> > +
> >       netif_stop_queue(dev);
> >       sl->rcount   = 0;
> >       sl->xleft    = 0;
>
> I suggest moving these two assignments to slc_open() - see below.
>
>
> [...]
>
>
> > @@ -883,72 +786,50 @@ static int slcan_open(struct tty_struct *tty)
> >       if (!tty->ops->write)
> >               return -EOPNOTSUPP;
> >
> > -     /* RTnetlink lock is misused here to serialize concurrent
> > -      * opens of slcan channels. There are better ways, but it is
> > -      * the simplest one.
> > -      */
> > -     rtnl_lock();
> > +     dev = alloc_candev(sizeof(*sl), 1);
> > +     if (!dev)
> > +             return -ENFILE;
> >
> > -     /* Collect hanged up channels. */
> > -     slc_sync();
> > +     sl = netdev_priv(dev);
> >
> > -     sl = tty->disc_data;
> > +     /* Configure TTY interface */
> > +     tty->receive_room = 65536; /* We don't flow control */
> > +     sl->rcount   = 0;
> > +     sl->xleft    = 0;
>
> I suggest moving the zeroing to slc_open() - i.e. to the netdev open
> function. As a bonus, you can then remove the same two assignments from
> slc_close() (see above). They are only used when netif_running(), with
> appropiate guards already in place as far as I can see.

I think it is better to keep the code as it is, since at the entry of
the netdev
open function, netif_running already returns true (it is set to true by the
calling function) and therefore it would be less safe to reset the
rcount and xleft
fields.

Thanks and regards,
Dario

>
>
> > +     spin_lock_init(&sl->lock);
> > +     INIT_WORK(&sl->tx_work, slcan_transmit);
> > +     init_waitqueue_head(&sl->xcmd_wait);
> >
> > -     err = -EEXIST;
> > -     /* First make sure we're not already connected. */
> > -     if (sl && sl->magic == SLCAN_MAGIC)
> > -             goto err_exit;
> > +     /* Configure CAN metadata */
> > +     sl->can.bitrate_const = slcan_bitrate_const;
> > +     sl->can.bitrate_const_cnt = ARRAY_SIZE(slcan_bitrate_const);
> >
> > -     /* OK.  Find a free SLCAN channel to use. */
> > -     err = -ENFILE;
> > -     sl = slc_alloc();
> > -     if (!sl)
> > -             goto err_exit;
> > +     /* Configure netdev interface */
> > +     sl->dev = dev;
> > +     strscpy(dev->name, "slcan%d", sizeof(dev->name));
>
> The third parameter looks... unintentional :)
>
> What do the maintainers think of dropping the old "slcan" name, and
> just allowing this to be a normal canX device? These patches do bring
> it closer to that, after all. In this case, this name string magic
> could be dropped altogether.
>
>
> [...]
>
>
>
> This looks good to me overall.
>
> Thanks Dario!
>
>
> Max



-- 

Dario Binacchi

Embedded Linux Developer

dario.binacchi@amarulasolutions.com

__________________________________


Amarula Solutions SRL

Via Le Canevare 30, 31100 Treviso, Veneto, IT

T. +39 042 243 5310
info@amarulasolutions.com

www.amarulasolutions.com
