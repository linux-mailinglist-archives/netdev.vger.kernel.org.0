Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37EC236FE71
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 18:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbhD3Q0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 12:26:36 -0400
Received: from mail-ua1-f45.google.com ([209.85.222.45]:37831 "EHLO
        mail-ua1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbhD3Q0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 12:26:35 -0400
Received: by mail-ua1-f45.google.com with SMTP id z7so6375055uav.4;
        Fri, 30 Apr 2021 09:25:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vyfhlq7hGEBjlcLXsp8OFAhm0YdbcI9uJ3y5eLW21OQ=;
        b=tgh6jYd048JN+O26fh2CJeMByj35TsR9QlaIubNDIr7CZeVD70AM7m7oyQ8BhFAEdV
         IfIcxAh30rDJXnnWffjwBt1TQPdTIce6r4JYXJ9GPTfwpLQF0JVZqixrKEKSUSTPAD/a
         mTpCETJKQZOXLcYQ5TpYnsTrYasYvusPpQAoCrlkDkgzhSRKnem+R1vyRMCLgsjweD2j
         khd+M3KuDYZB0Cd2+Z4Dk1CHZumBD17KX9h19sePndOBXYM54T/alpQqiHMO/JSfq0Ol
         m0xf8HjJi32EHDEGfNpoFfRImL5OOaHbjHekhap8kqQb/IkZNuKgSTMuY5pFlsT4zpOu
         psjg==
X-Gm-Message-State: AOAM531UrfonhncQ0grLtDwAcYjBz8cGnGqgMOT/fRaZSu7ySrc+EQgZ
        2eZXM25Ex1IAyfCWxY/1gvf+7INmukxLYxWsCXE=
X-Google-Smtp-Source: ABdhPJwU0fCKp6BktVeOqEESHuf/4ZfhGpGcmBJNDT0Ovr/ViP3UF5VzrfRazXcWS/yHn5HzBgm63mASl/gtTMxKGpU=
X-Received: by 2002:ab0:2c16:: with SMTP id l22mr6093017uar.100.1619799946825;
 Fri, 30 Apr 2021 09:25:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210430095308.14465-1-o.rempel@pengutronix.de>
 <f0905c84-6bb2-702f-9ae7-614dcd85c458@infradead.org> <20210430154153.zhdnxzkm2fhcuogo@pengutronix.de>
In-Reply-To: <20210430154153.zhdnxzkm2fhcuogo@pengutronix.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 30 Apr 2021 18:25:35 +0200
Message-ID: <CAMuHMdWmuCZMCsd8NZqzVaWWP59ZFZpFYds-OpHmEC7OjERLTg@mail.gmail.com>
Subject: Re: [PATCH net-next v1 1/1] net: selftest: provide option to disable
 generic selftests
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij,

On Fri, Apr 30, 2021 at 5:42 PM Oleksij Rempel <o.rempel@pengutronix.de> wrote:
> On Fri, Apr 30, 2021 at 08:13:12AM -0700, Randy Dunlap wrote:
> > On 4/30/21 2:53 AM, Oleksij Rempel wrote:
> > > Some systems may need to disable selftests to reduce kernel size or for
> > > some policy reasons. This patch provide option to disable generic selftests.
> > >
> > > Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > > Fixes: 3e1e58d64c3d ("net: add generic selftest support")
> > > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > > ---
> > >  net/Kconfig | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > >
> > > diff --git a/net/Kconfig b/net/Kconfig
> > > index f5ee7c65e6b4..dac98c73fcd8 100644
> > > --- a/net/Kconfig
> > > +++ b/net/Kconfig
> > > @@ -431,7 +431,12 @@ config SOCK_VALIDATE_XMIT
> > >
> > >  config NET_SELFTESTS
> > >     def_tristate PHYLIB
> > > +   prompt "Support for generic selftests"
> > >     depends on PHYLIB && INET
> > > +   help
> > > +     These selftests are build automatically if any driver with generic
> >
> >                             built
> >
> > > +     selftests support is enabled. This option can be used to disable
> > > +     selftests to reduce kernel size.
> > >
> > >  config NET_SOCK_MSG
> > >     bool
> > >
> >
> > Thanks for the patch/option. But I think it should just default to n,
> > not PHYLIB.
>
> It should be enabled by default for every device supporting this kind of
> selftests. This tests extend functionality of cable tests, which are not
> optional. Disabling it by default makes even less sense, at least for
> me.

Drivers using it ( AG71XX, FEC, NET_DSA) already select it, right?
Or better, imply it, which assumes it's optional.

> It depends on PHYLIB, if PHYLIB is build as module, this
> this part should be build as module too. And since Geert asking to make
> it optional, I provided this patch.

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
