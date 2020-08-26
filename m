Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74141252533
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 03:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbgHZBtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 21:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726611AbgHZBtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 21:49:32 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183C6C061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 18:49:32 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id i10so61560ybt.11
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 18:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vGkXtfCekbRYzWDnk43MYcczn7ykgtF52xiiEpLckBI=;
        b=d/8813Wq4lKNS4ZnCl/hnZGkWhSoCbCZPOMOHM4rTpHzlVGfeTMUXZoIoLAAHkPq+w
         grdmTL2bznlt66ByRAiqUi209T+8vEOPAmt0qGTluIn1FrcHAhmBYDLZw6MaoQkXp3Me
         BO62XgGD42TefLamnIDSf6gkQOUCGaGMIiyZh3rcjWlhFo1RxhMw2kqYty5XLGSG5eI4
         FCISzxUudw0EuiZ7GbZTi6VuodLp4lUkrnhZsSYfKRU6uuPOoUexAEfUjZVf9ce9HhER
         E3dOCAlknh5AiUvoKkkU+/t+b9PQTyUnWfpWXW7BMZVYd2c2Bcbe5vhIc3b0pyLXXltT
         dlCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vGkXtfCekbRYzWDnk43MYcczn7ykgtF52xiiEpLckBI=;
        b=AsI23bKg3y2nnSqBEwuWG1tOtCSAVxKjPuqFOhz2ANKpWy1VUeJCGUVRis1oVZ4jQ1
         mpD3MF+6uZaW/r4/zlTSCbT9ZQyRGnkdnqylL4VK4uEmGUoaT8I6rjg8xjB2cin+DWJl
         QkqRvLloiYBaOfwsGvAvTrYzGeS8prUzOuuRrz9TQbSc1lLm7nZvBI5/FD9PJWuRXUs8
         vfiA22pYumt5CfDWe4X+yTtwPIv26OZjbaKiPRq71vJwkntF2PHImBgh4R0BuIB80EcZ
         93T920/TrLLAoqFDQIdCEcDBhgXUIImSIEEbQShvUMQVHfQBjv8dgMz0PjaEpjAd0qOx
         YUCA==
X-Gm-Message-State: AOAM533wT/SnBS1N6XbWavhuaDyupHaB/qP2l2XMJRatbswqZTZbQ9Uz
        ilLqFN57tQOenMC6fDqmewC8BUPhQyLtUWOcPGXhiQ==
X-Google-Smtp-Source: ABdhPJxW+lxpvHoVlAs/OapMa4VtXwoRQIKEbfPg2kPoIn4x+fcWDb7gQahXAfFXLjbyH9i3Lwijh5iTYYsvpuUHcCk=
X-Received: by 2002:a25:5049:: with SMTP id e70mr18126348ybb.407.1598406570286;
 Tue, 25 Aug 2020 18:49:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200825224208.1268641-1-maheshb@google.com> <9fce7d7e-aa33-a451-ab4a-a297b1317310@infradead.org>
 <CAF2d9jiwH=GO3zd1sK-mURRV_W-_bfihbmc+ud=ZdV_SvYAuvg@mail.gmail.com> <CANP3RGdkSsjyM0vwY=f19rzsuLUCwAqDRHZT54i2BksgN58LKQ@mail.gmail.com>
In-Reply-To: <CANP3RGdkSsjyM0vwY=f19rzsuLUCwAqDRHZT54i2BksgN58LKQ@mail.gmail.com>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Tue, 25 Aug 2020 18:49:14 -0700
Message-ID: <CAF2d9jj9bv=mUFgAsi9Xu4NHpFoAUdxzJA4yFqitT2AhnmZAAQ@mail.gmail.com>
Subject: Re: [PATCHv2 next] net: add option to not create fall-back tunnels in
 root-ns as well
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        Jian Yang <jianyang@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 25, 2020 at 5:42 PM Maciej =C5=BBenczykowski <maze@google.com> =
wrote:
>
> On Tue, Aug 25, 2020 at 4:00 PM Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=A5=
=87=E0=A4=B6 =E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=A4=
=B0)
> <maheshb@google.com> wrote:
> >
> > On Tue, Aug 25, 2020 at 3:47 PM Randy Dunlap <rdunlap@infradead.org> wr=
ote:
> > >
> > > On 8/25/20 3:42 PM, Mahesh Bandewar wrote:
> > > > The sysctl that was added  earlier by commit 79134e6ce2c ("net: do
> > > > not create fallback tunnels for non-default namespaces") to create
> > > > fall-back only in root-ns. This patch enhances that behavior to pro=
vide
> > > > option not to create fallback tunnels in root-ns as well. Since mod=
ules
> > > > that create fallback tunnels could be built-in and setting the sysc=
tl
> > > > value after booting is pointless, so added a kernel cmdline options=
 to
> > > > change this default. The default setting is preseved for backward
> > > > compatibility. The kernel command line option of fb_tunnels=3Dinitn=
s will
> > > > set the sysctl value to 1 and will create fallback tunnels only in =
initns
> > > > while kernel cmdline fb_tunnels=3Dnone will set the sysctl value to=
 2 and
> > > > fallback tunnels are skipped in every netns.
> > > >
> > > > Signed-off-by: Mahesh Bandewar <maheshb@google.com>
> > > > Cc: Eric Dumazet <edumazet@google.com>
> > > > Cc: Maciej Zenczykowski <maze@google.com>
> > > > Cc: Jian Yang <jianyang@google.com>
> > > > ---
> > > > v1->v2
> > > >   Removed the Kconfig option which would force rebuild and replaced=
 with
> > > >   kcmd-line option
> > > >
> > > >  .../admin-guide/kernel-parameters.txt         |  5 +++++
> > > >  Documentation/admin-guide/sysctl/net.rst      | 20 +++++++++++++--=
----
> > > >  include/linux/netdevice.h                     |  7 ++++++-
> > > >  net/core/sysctl_net_core.c                    | 17 ++++++++++++++-=
-
> > > >  4 files changed, 40 insertions(+), 9 deletions(-)
> > > >
> > > > diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Docu=
mentation/admin-guide/kernel-parameters.txt
> > > > index a1068742a6df..09a51598c792 100644
> > > > --- a/Documentation/admin-guide/kernel-parameters.txt
> > > > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > > > @@ -801,6 +801,11 @@
> > > >
> > > >       debug_objects   [KNL] Enable object debugging
> > > >
> > > > +     fb_tunnels=3D     [NET]
> > > > +                     Format: { initns | none }
> > > > +                     See Documentation/admin-guide/sysctl/net.rst =
for
> > > > +                     fb_tunnels_only_for_init_ns
> > > > +
> > >
> > > Not at this location in this file.
> > > Entries in this file are meant to be in alphabetical order (mostly).
> > >
> > > So leave debug_objects and no_debug_objects together, and insert fb_t=
unnels
> > > between fail_make_request=3D and floppy=3D.
> > >
> > I see. I'll fix it in the next revision.
> > thanks for the suggestion.
> > --mahesh..
> >
> > > Thanks.
> > >
> > > >       no_debug_objects
> > > >                       [KNL] Disable object debugging
> > > >
> > >
> > > --
> > > ~Randy
>
> Setting it to 1 via kcmdline doesn't seem all that useful, since
> instead of that you can just use initrc/sysctl.conf/etc.
>
> Would it be simpler if it was just 'no_fb_tunnels' or
> 'no_fallback_tunnels' and the function just set the sysctl to 2
> unconditionally?
> (ie. no =3D.... parsing at all) that would also be less code...
>
To make it simple; all methods should be able to set all values. Otherwise =
I
agree that it makes less sense to set value =3D 1 via kcmd. Also one can as=
sign
value =3D 2 to sysctl once kernel is booted, it may not produce desired res=
ults
always but would work if you load modules after changing the sysctl value. =
I
guess the idea here is to give user full control on what their
situation is and choose
the correct method for the desired end result.

> btw. I also don't understand the '!IS_ENABLED(CONFIG_SYSCTL) ||'
> piece.  Why not just delete that?
> This seems to force fallback tunnels if you disable CONFIG_SYSCTL...
> but (a) then the kcmdline option doesn't work,
> and (b) that should already just happen by virtue of the sysctl defaultin=
g to 0.
agreed. will remove it (!IS_ENABLED(CONFIG_SYSCTL) check) in the next revis=
ion.
