Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3065D381DA5
	for <lists+netdev@lfdr.de>; Sun, 16 May 2021 11:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234521AbhEPJ3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 May 2021 05:29:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231187AbhEPJ3a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 May 2021 05:29:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6166E61104;
        Sun, 16 May 2021 09:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621157296;
        bh=fFd2d0XlbgMYyrzCgiskzC9VaHK5qDI8g3rJ7OxTXXw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=MbKIOqJpJOFM58gaPee85wsnzEMyVwDOUOB4XWhlvdhA9bABdq97BmVg+9gecI+Kc
         BbBq5KmyJdrTkGfIzMfzXy9Ig89bzf6XE80SRTCs0N+dcZQAEeZaZ5qOWlCHSF+Rkb
         YKskHYFn5rl5t9Zk5mPSAf6hirGc3Qr6bp8ShNY+tiNpG1AFzOpeQrdW/yW2PEhNXs
         Rjgo4gFxZcEg8YaVtoMqPo8prQHWlxLh1RRm5QTIc6oVww7S6ropE5z7RZ8wl1Csf5
         H5WithiPk6LIwGHbbNtnJcV+DqMPh1UWH5reEXUN+rgGYhQOkbxshxSKW7Rbm+k6yS
         O7bYpbH+LGGrg==
Received: by mail-wr1-f43.google.com with SMTP id r12so3318099wrp.1;
        Sun, 16 May 2021 02:28:16 -0700 (PDT)
X-Gm-Message-State: AOAM533Q/W8Vdy2z6MAipAtF4FxEWIYfIa60mbZTtVspcFCjhx9zdqPb
        IUE3iGvTYvjorF8Xa3+5py5B9z0oj+KH45kEi6Y=
X-Google-Smtp-Source: ABdhPJzqTuvFO+QTf5+WsSOlZsU5ksZomCt+AxH8tQFExcL2xlflMUftwOBDNVAtEwbfp821gF2dTircpUfQRqj/g6Q=
X-Received: by 2002:a5d:6dc4:: with SMTP id d4mr70402713wrz.105.1621157295043;
 Sun, 16 May 2021 02:28:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210515221320.1255291-1-arnd@kernel.org> <alpine.DEB.2.21.2105160145080.3032@angie.orcam.me.uk>
In-Reply-To: <alpine.DEB.2.21.2105160145080.3032@angie.orcam.me.uk>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Sun, 16 May 2021 11:27:09 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1ytpYNNGkoJJGXf669TxOuzC9_Txn7c593YCCL=ATJ0Q@mail.gmail.com>
Message-ID: <CAK8P3a1ytpYNNGkoJJGXf669TxOuzC9_Txn7c593YCCL=ATJ0Q@mail.gmail.com>
Subject: Re: [RFC 00/13] [net-next] drivers/net/Space.c cleanup
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     Networking <netdev@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sam Creasey <sammy@sammy.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        linux-kernel@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 16, 2021 at 2:06 AM Maciej W. Rozycki <macro@orcam.me.uk> wrote:
>
> On Sun, 16 May 2021, Arnd Bergmann wrote:
>
> > For the ISA drivers, there is usually no way to probe multiple devices
> > at boot time other than the netdev= arguments, so all that logic is left
> > in place for the moment, but centralized in a single file that only gets
> > included in the kernel build if one or more of the drivers are built-in.
>
>  As I recall at least some ISA drivers did probe multiple interfaces in
> their monolithic configuration; I used a configuration with as many as
> five ne2k clones for a bridge machine for a fairly large network (~300
> machines) and as I recall it required no command-line parameters (but then
> it was some 25 years ago, so I may well not remember correctly anymore).
> It may have been with ISA PnP though (damn!).
>
>  For modular drivers it was deemed too dangerous, for obvious reasons, and
> explicit parameters were the only way.

I did use two ne2k compatible pre-PnP cards in a router, by loading two
copies of the same driver module, and I'm fairly sure that would still work,
but it's obviously not how it was meant to be used. ;-)

To clarify: the code drivers/net/Space.c logic can probe these drivers
both with and without explicit configuration. Using the netdev= arguments
will result in reliable assignment of device names and prevent drivers
from poking ports that may be used by other devices, but drivers can
also implement their own device detection, in case of
drivers/net/ethernet/8390/ne.c, it can find devices at up to six addresses:
static unsigned int netcard_portlist[] __initdata = {
    0x300, 0x280, 0x320, 0x340, 0x360, 0x380, 0
};

> > * Most of ISA drivers could be trivially converted to use the module_init()
> >   entry point, which would slightly change the command line syntax and
> >   still support a single device of that type, but not more than one. We
> >   could decide that this is fine, as few users remain that have any of
> >   these devices, let alone more than one.
> >
> > * Alternatively, the fact that the ISA drivers have never been cleaned
> >   up can be seen as an indication that there isn't really much remaining
> >   interest in them. We could move them to drivers/staging along with the
> >   consolidated contents of drivers/net/Space.c and see if anyone still
> >   uses them and eventually remove the ones that nobody has.
>
>  I have a 3c509b interface in active use (although in the EISA mode, so no
> need for weird probing, but it can be reconfigured),

The 3c509 driver already doesn't use the drivers/net/Space.c probing,
Marc Zyngier addressed this when he added EISA support in 2003.
It also supports multiple non-PnP cards with module parameters
as well as pre-standard jumperless autoconfiguration. My only change
to this driver was to remove a few lines of dead code that I guess Marc
missed at the time.

I probably should have listed the drivers that still use Space.c after
my series. Here is the list I'm talking about:

3com:
    3c515/corkscrew: supports PnP mode, ignores command line and
        module parameters but scans for devices on all ports
8390:
   wd80x3: supports module parameters up to four cards, no PnP
   smc-ultra: supports up to four devices with module parameters, plus PnP
   ne2k/iosa: supports up to four devices with module parameters, plus PnP
amd
   lance: supports up to eight devices with module parameters, no PnP
   ni65: supports only one device as loadable module, no PnP
smsc
   smc9194: supports only one device as loadable module, no PnP
cirrus
   cs89x0 (supports only one device as loadable module, plus custom
        PnP-like probing in built-in mode)

> and I have an ne2k clone in storage, so I could do some run-time
> verification if there is no one else available.  I'll see if I can do some driver
> polishing for these devices, but given the number of other tasks on my
> table this is somewhat low priority for me.

I don't think it's necessary to validate the changes I did to the
ne2k driver specifically, though it might be nice to see that I didn't
break the overall logic in Space.c.

        Arnd
