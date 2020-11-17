Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8893F2B707C
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 21:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbgKQUxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 15:53:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726248AbgKQUxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 15:53:30 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D045DC0613CF
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 12:53:29 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id d1so8029154ybr.10
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 12:53:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8g620uWHc3A5sIgDaR6PVvadzdPJ5gfNnsu6wh4Ljzo=;
        b=sS97j3IR6shgWceJl31mLuVvsUlbnKG+qtOtRPJrDqPt64B79XI3enfEVPE/ab9clS
         XKwkYHyUCp+kF+E187DjBdFzkP7yhjWstI1bKNjhqz3fS0uUHlWmruroliFAWTRFv3It
         HNqoS6CAhbsxjRFIRh48GYL+GaTXm4mxJ56DBCxFj6vtoPI/VxKP3a0yj3UUgs/1YqAh
         kRTHRxBZwIzX74NbL7SiPU47JP6LN5xVNvb9fg8nR1rHLrkeZ4W+iyDr/gLJr7wOrP1z
         hST/JbdTx9Ymg9JJF7DVMLtAE1arpecRyycrh7nQ00Vqw58dv78XALoIkfqcfjIgoCP0
         VMAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8g620uWHc3A5sIgDaR6PVvadzdPJ5gfNnsu6wh4Ljzo=;
        b=cYNyGQiaZb4FRNI3K9ongFkutvnTAma4jOYB+DvOnzLlg4DMGadq2Q2uSuymrBMx7F
         rpg+sZZtMAg9ZQH4sKLDpL0uiWICc6EDC9Bt5MvERXhaAxHnQtjY3FMfxM1XMqvOLXo3
         f2vhMPXmz6WlwNL7UGbpPasTBrUaGZGgETGQPyjC0rxcvsipTIAHfLMcJ2oUD3Ox8s64
         Iq1mmOOVOhwdENc6hgiJTz0l0hj7lC8EOsFTxgNe+deUdlxG2SHGNYc3UeqAhV21edEx
         r7g8/1b5DRmu/Wsk5WUyTUTG6dzn+7BgfvsNRAiYIe8ChSeJlwhsVNM2YFKPJjJ2Abvh
         m1Gg==
X-Gm-Message-State: AOAM530lVpaCBoX8JYY/KL9AoCXIQM37+hS+NziXRrvDx4j01XcReG7o
        XvJaUJAu+fhnb/1CG7V2uAndk/iyBaatdDHRvLCXXA==
X-Google-Smtp-Source: ABdhPJywkBnFQZMNL/N/Swbmj088EfNAfzwoiPCBeddyLSzj12wuoLaKjfTKrSGRGjbwXbDP17DGMZR7a9IG4df+ED0=
X-Received: by 2002:a25:f816:: with SMTP id u22mr2144674ybd.505.1605646408684;
 Tue, 17 Nov 2020 12:53:28 -0800 (PST)
MIME-Version: 1.0
References: <20201111204308.3352959-1-jianyang.kernel@gmail.com>
 <20201114101709.42ee19e0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAF2d9jgYgUa4DPVT8CSsbMs9HFjE5fn_U8-P=JuZeOecfiYt-g@mail.gmail.com>
 <20201116123447.2be5a827@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAF2d9ji24VkLipTCFSAU+L8yqKt9nfPSNfks9_V1Tnb0ztPrfA@mail.gmail.com> <20201117171830.GA286718@shredder.lan>
In-Reply-To: <20201117171830.GA286718@shredder.lan>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Tue, 17 Nov 2020 12:53:12 -0800
Message-ID: <CAF2d9jhJq76KWaMGZLTTX4rLGvLDp+jLxCG9cTvv6jWZCtcFAA@mail.gmail.com>
Subject: Re: [PATCH net-next] net-loopback: allow lo dev initial state to be controlled
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jian Yang <jianyang.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        linux-netdev <netdev@vger.kernel.org>,
        Jian Yang <jianyang@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 9:18 AM Ido Schimmel <idosch@idosch.org> wrote:
>
> On Mon, Nov 16, 2020 at 01:03:32PM -0800, Mahesh Bandewar (=E0=A4=AE=E0=
=A4=B9=E0=A5=87=E0=A4=B6 =E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=
=A4=BE=E0=A4=B0) wrote:
> > On Mon, Nov 16, 2020 at 12:34 PM Jakub Kicinski <kuba@kernel.org> wrote=
:
> > >
> > > On Mon, 16 Nov 2020 12:02:48 -0800 Mahesh Bandewar (=E0=A4=AE=E0=A4=
=B9=E0=A5=87=E0=A4=B6 =E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=
=BE=E0=A4=B0) wrote:
> > > > > > diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
> > > > > > index a1c77cc00416..76dc92ac65a2 100644
> > > > > > --- a/drivers/net/loopback.c
> > > > > > +++ b/drivers/net/loopback.c
> > > > > > @@ -219,6 +219,13 @@ static __net_init int loopback_net_init(st=
ruct net *net)
> > > > > >
> > > > > >       BUG_ON(dev->ifindex !=3D LOOPBACK_IFINDEX);
> > > > > >       net->loopback_dev =3D dev;
> > > > > > +
> > > > > > +     if (sysctl_netdev_loopback_state) {
> > > > > > +             /* Bring loopback device UP */
> > > > > > +             rtnl_lock();
> > > > > > +             dev_open(dev, NULL);
> > > > > > +             rtnl_unlock();
> > > > > > +     }
> > > > >
> > > > > The only concern I have here is that it breaks notification order=
ing.
> > > > > Is there precedent for NETDEV_UP to be generated before all perne=
t ops
> > > > > ->init was called?
> > > > I'm not sure if any and didn't see any issues in our usage / tests.
> > > > I'm not even sure anyone is watching/monitoring for lo status as su=
ch.
> > >
> > > Ido, David, how does this sound to you?
> > >
> > > I can't think of any particular case where bringing the device up (an=
d
> > > populating it's addresses) before per netns init is finished could be
> > > problematic. But if this is going to make kernel coding harder the
> > > minor convenience of the knob is probably not worth it.
> >
> > +Eric Dumazet
> >
> > I'm not sure why kernel coding should get harder, but happy to listen
> > to the opinions.
>
> Hi,
>
> Sorry for the delay. Does not occur to me as a problematic change. I ran
> various tests with 'sysctl -qw net.core.netdev_loopback_state=3D1' and a
> debug config. Looks OK.

Thanks for the confirmation Ido. I think Jian is getting powerpc
config build fixed to address the build-bots findings and then he can
push the updated version.
