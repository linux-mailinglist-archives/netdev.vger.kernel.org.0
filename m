Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 795D05815CC
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 16:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239465AbiGZO72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 10:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239173AbiGZO7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 10:59:25 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 841682C650
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 07:59:24 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id q23so9816451lfr.3
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 07:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n0HjOM/d2+hqNFb0LUzBClLdan9uRjh/1pepW+TXnpw=;
        b=mRMJjULNmr1ZBAkPkI4xlsy1SUjQapLFdJNzkiWMYFeJMg7+A4HHMRuyX54Uq459Hn
         I2Aq5aTaF8MwK3dcOipuPuX3IWDr9R+MLjgH6hIdiCM69uDbuZ00q+TQ3PldgBYy8G7c
         OjkZ6OPf7zUadap6/teHx/KXbuiRJldpmFknY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n0HjOM/d2+hqNFb0LUzBClLdan9uRjh/1pepW+TXnpw=;
        b=J1SgdX58B2bqiK59gZScLrzjDS94sRNfDjA+pGYXDMTEbEQqLKo390kAHumNfGhn9w
         1WoNJdGy2XGeXpkTaKvWyv5ELWgp6KQeKI7lz3BqU4RZhRlvIBtPRxm6KjGg4l8uXQOQ
         KxeFXjGHIyjQwNajEWHdbCs+oZXpcqJESUPCuVS0q9H01J6Wr03BV2iB1go5tAijgseT
         EVQ+tqc+wvxTpIvX6tHEkGoFPVSdGIty86mbrZcJbkOfrraMgGF+jtAxwhCwS13aqoNX
         13hwDyJ0Yv8+C+kvbKf/p2cgIJy3gnCIUp9UNMWDM6QnGg6e6O+Su0WTg0+WPICek1sc
         AEeA==
X-Gm-Message-State: AJIora9LSnX1ZWhBoXxztMxTcmn0hWouJru9mvkqd1TvRmUETSEzB3Ne
        gDYfMybS6aS7zzxLeNgYGwZOADeN8Cu92QtME6F5pQ==
X-Google-Smtp-Source: AGRyM1urKoX+dO3rgXCo+AGf4sf4Fw8Y+JA37WQkI1fKzO+Be3+QzS0kr3W37l+QsB0zB6/X62ZFRALtDjds5CKQ3wM=
X-Received: by 2002:a05:6512:3c88:b0:48a:86d8:dbad with SMTP id
 h8-20020a0565123c8800b0048a86d8dbadmr4525794lfv.172.1658847562848; Tue, 26
 Jul 2022 07:59:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220716170007.2020037-1-dario.binacchi@amarulasolutions.com>
 <20220716170007.2020037-3-dario.binacchi@amarulasolutions.com>
 <20220717233842.1451e349.max@enpas.org> <CABGWkvrgX+9J-rOb-EO1wXVAZQ5phwKKpbc-iD491rD9zn5UpQ@mail.gmail.com>
 <20220725150920.63ac3a77.max@enpas.org>
In-Reply-To: <20220725150920.63ac3a77.max@enpas.org>
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
Date:   Tue, 26 Jul 2022 16:59:11 +0200
Message-ID: <CABGWkvqghRsP2w+yw6LXVCnJy4ju10jmQnofS858Vh+VVZzMMQ@mail.gmail.com>
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Max,

On Mon, Jul 25, 2022 at 3:09 PM Max Staudt <max@enpas.org> wrote:
>
> On Mon, 25 Jul 2022 08:40:24 +0200
> Dario Binacchi <dario.binacchi@amarulasolutions.com> wrote:
>
> > > > @@ -883,72 +786,50 @@ static int slcan_open(struct tty_struct *tty)
> > > >       if (!tty->ops->write)
> > > >               return -EOPNOTSUPP;
> > > >
> > > > -     /* RTnetlink lock is misused here to serialize concurrent
> > > > -      * opens of slcan channels. There are better ways, but it is
> > > > -      * the simplest one.
> > > > -      */
> > > > -     rtnl_lock();
> > > > +     dev = alloc_candev(sizeof(*sl), 1);
> > > > +     if (!dev)
> > > > +             return -ENFILE;
> > > >
> > > > -     /* Collect hanged up channels. */
> > > > -     slc_sync();
> > > > +     sl = netdev_priv(dev);
> > > >
> > > > -     sl = tty->disc_data;
> > > > +     /* Configure TTY interface */
> > > > +     tty->receive_room = 65536; /* We don't flow control */
> > > > +     sl->rcount   = 0;
> > > > +     sl->xleft    = 0;
> > >
> > > I suggest moving the zeroing to slc_open() - i.e. to the netdev open
> > > function. As a bonus, you can then remove the same two assignments from
> > > slc_close() (see above). They are only used when netif_running(), with
> > > appropiate guards already in place as far as I can see.
> >
> > I think it is better to keep the code as it is, since at the entry of
> > the netdev
> > open function, netif_running already returns true (it is set to true by the
> > calling function) and therefore it would be less safe to reset the
> > rcount and xleft
> > fields.
>
> Wow, great catch!
>
> I wonder why __LINK_STATE_START is set before ->ndo_open() is called...?
>
>
> Since the drivers are similar, I've checked can327. It is unaffected,
> because the counters are additionally guarded by a spinlock. Same in
> slcan, where netdev_close() takes the spinlock to reset the counters.
>
> So you *could* move them to netdev_open() *if* they are always guarded
> by the slcan lock.
>
> Or, leave it as it is, as it seems to be correct. Your choice :)

If possible I prefer not to use spin_lock. So I prefer to keep the code as is.
Thanks and regards,
Dario

>
>
> Thank you!
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
