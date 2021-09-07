Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E534E402995
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 15:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344754AbhIGNVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 09:21:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344699AbhIGNVF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 09:21:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89B956112D;
        Tue,  7 Sep 2021 13:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631020799;
        bh=qYWci1SoCZOQNlWd+tCa0Fi+qEhu1uT7uC9+PXQtZBI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=uNNTAXYFUmPsGOq0aqc8tk25KZGoWx3U0MVOQPxY+Dksc88VIC1VTCi5/DhqwwWrG
         pswA8OEemVU2uVb1Z+LqROSD7cFhJ4+lFbxVrie8GEXAAHD8VupMpkl0wn7hp4n5MP
         J4hN2TU0HBASyu1hWiAEgBHCTuUiZ3FUp7daORH2JZZnMH8ymlWDGixxH/1PvFMMoO
         YtdATmK2LYedxp1edbso5CoVeXlotqqimtIEOBGKeztIc2PC+HEkzJXu8bEjTN0Ne+
         hSa1S1YtjZvEorJAi8nuEBP/LE4kK7g70Sg9YBhQvldDopJrPUtVFrl+JHvS6Sstdx
         fCyyIHQfHQjng==
Received: by mail-wr1-f41.google.com with SMTP id q11so14420219wrr.9;
        Tue, 07 Sep 2021 06:19:59 -0700 (PDT)
X-Gm-Message-State: AOAM531BA+5xfrsSfdQSR31Jugojc0CshT1653BrD14pSyerf643NXmL
        zqoCqCtRmkdmjMV4LOtwcZwPnmm4RoC6LaLhCVM=
X-Google-Smtp-Source: ABdhPJzMBRguq8oS0bFuYHxuoDHcWbD2fy6PvbPgdjL0OHi+WI3ao2kaGpIdYHxSBZAB6pMYVbu1Lz1c3zcXq7PP7aU=
X-Received: by 2002:a5d:4ed0:: with SMTP id s16mr18622368wrv.71.1631020798060;
 Tue, 07 Sep 2021 06:19:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210803114051.2112986-1-arnd@kernel.org> <20210803114051.2112986-11-arnd@kernel.org>
 <CAMuHMdVvBL=qZkWF5DXdKjFMKgT-3X-OUBnLYrqawQijoLG4Xw@mail.gmail.com> <CAMuHMdVhN-frrSgsxJ_28_5B+gYROTkN_dPT1yHBsQU+2U4_=g@mail.gmail.com>
In-Reply-To: <CAMuHMdVhN-frrSgsxJ_28_5B+gYROTkN_dPT1yHBsQU+2U4_=g@mail.gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Tue, 7 Sep 2021 15:19:42 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1qba2OxymYJtKyc5-x5rSD2_jcrCXyw2rV7pX+o0vdxw@mail.gmail.com>
Message-ID: <CAK8P3a1qba2OxymYJtKyc5-x5rSD2_jcrCXyw2rV7pX+o0vdxw@mail.gmail.com>
Subject: Re: [PATCH v2 10/14] [net-next] make legacy ISA probe optional
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     netdev <netdev@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Andrii Nakryiko <andriin@fb.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Doug Berger <opendmb@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Jessica Yu <jeyu@kernel.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Sam Creasey <sammy@sammy.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 7, 2021 at 10:24 AM Geert Uytterhoeven <geert@linux-m68k.org> w=
rote:
> On Wed, Aug 11, 2021 at 4:50 PM Geert Uytterhoeven <geert@linux-m68k.org>=
 wrote:
> > On Tue, Aug 3, 2021 at 1:41 PM Arnd Bergmann <arnd@kernel.org> wrote:
> > > From: Arnd Bergmann <arnd@arndb.de>
> > >
> > > There are very few ISA drivers left that rely on the static probing f=
rom
> > > drivers/net/Space.o. Make them all select a new CONFIG_NETDEV_LEGACY_=
INIT
> > > symbol, and drop the entire probe logic when that is disabled.
> > >
> > > The 9 drivers that are called from Space.c are the same set that
> > > calls netdev_boot_setup_check().
> > >
> > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> >
> > > --- a/drivers/net/ethernet/8390/ne.c
> > > +++ b/drivers/net/ethernet/8390/ne.c
> > > @@ -951,6 +951,7 @@ static int __init ne_init(void)
> > >  }
> > >  module_init(ne_init);
> > >
> > > +#ifdef CONFIG_NETDEV_LEGACY_INIT
> > >  struct net_device * __init ne_probe(int unit)
> > >  {
> > >         int this_dev;
> > > @@ -991,6 +992,7 @@ struct net_device * __init ne_probe(int unit)
> > >
> > >         return ERR_PTR(-ENODEV);
> > >  }
> > > +#endif
> > >  #endif /* MODULE */
> >
> > My rbtx4927 build log says:
> >
> > drivers/net/ethernet/8390/ne.c:909:20: warning: =E2=80=98ne_add_devices=
=E2=80=99
> > defined but not used [-Wunused-function]
>
> Same for atari_defconfig.

Sorry about that. I made the patch when you first reported it, and I was
sure I had sent it, but apparently not. Sent it now.

       Arnd
