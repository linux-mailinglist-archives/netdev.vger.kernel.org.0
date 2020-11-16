Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABAD22B5365
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 22:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731598AbgKPVDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 16:03:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbgKPVDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 16:03:51 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F4CC0613CF
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 13:03:49 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id v92so16935615ybi.4
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 13:03:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=foP1isf4P3TLs9q8v+O4LU3DNFQP1jXhFV6PTe7cBqE=;
        b=CAZ2EFmocKhgOACeHWxc6D5VjjSD/uM1DpxmiTKX9pMd7H4nEc0/XlbEyGSt6rT6qX
         0mCaE1WVUsvpHqmnvVbFTMXuvuvP130EwTBkQ1NvXQUB/BlqGI80SKMyhw3UeXqMiM5W
         8e4zN06Bm+Q/SiqMq43Y96vwoY5Y9TEbk6vp+o/vTeieDXmsv11cK7WSNLttSs1E3wm4
         9TztQaWjfemFr419zBDeutVVu5z+E5UvX7GUxMScRml1xBr7Letq6Q9Pvpza+P+YDZe0
         srcrlxBt/FTNDq2pQF1cKomC/3SPRLMQZTHnX6RXpFEpSzPjhthbRq9aPTTWGvQJt7e6
         Mwnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=foP1isf4P3TLs9q8v+O4LU3DNFQP1jXhFV6PTe7cBqE=;
        b=uk59YnE+mwruDwANzHm06SVHgUrP6AW01H5UgFAWBR4Gpi2ANJ3vy4IVWuvniEW0uZ
         cJMUIx7oy8RLYLsRt7CbXCiZvSVUYeqMWadLU3SdJxVXkrjI7p0qrNFGXKKLfownGFmo
         dUdCUxEUKWByJ/beTsYAMYf/SoOreGA0+l4sZCLqLcnHGj8biScl5mNnva4E5mYbjirA
         FYP9S4+2rHyP7b+QTMQaaBu348rRxFfB505LChS69hAvDKkGaHz/9c43WdE64H4hWHms
         UdOy9NP29ySlIo12cQGodeLvoQ4bjrRireWJptGvbKLjVkUIphmYB6aDw57k6ttgLbZL
         lFAA==
X-Gm-Message-State: AOAM533crkHOpwli1TklC3Gb4s8sua++6ilBs+zBzMaUH6qL6uVsCVe/
        Ea61feY4ZkmvT4ogkBWgIdo2xv2Wr8vl2ihjHoXtGw==
X-Google-Smtp-Source: ABdhPJwYgZT5DCFtzl1r1arxjPL20bLHJkBjxvDlhFXJnxhUu6Fgl5vk3dzGl13CQFpSOKOLhNcuizrg/+vasVfL5iI=
X-Received: by 2002:a25:32cb:: with SMTP id y194mr20706377yby.506.1605560628234;
 Mon, 16 Nov 2020 13:03:48 -0800 (PST)
MIME-Version: 1.0
References: <20201111204308.3352959-1-jianyang.kernel@gmail.com>
 <20201114101709.42ee19e0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAF2d9jgYgUa4DPVT8CSsbMs9HFjE5fn_U8-P=JuZeOecfiYt-g@mail.gmail.com> <20201116123447.2be5a827@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201116123447.2be5a827@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Mon, 16 Nov 2020 13:03:32 -0800
Message-ID: <CAF2d9ji24VkLipTCFSAU+L8yqKt9nfPSNfks9_V1Tnb0ztPrfA@mail.gmail.com>
Subject: Re: [PATCH net-next] net-loopback: allow lo dev initial state to be controlled
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, David Ahern <dsahern@gmail.com>,
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

On Mon, Nov 16, 2020 at 12:34 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 16 Nov 2020 12:02:48 -0800 Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=
=A5=87=E0=A4=B6 =E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=
=A4=B0) wrote:
> > > > diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
> > > > index a1c77cc00416..76dc92ac65a2 100644
> > > > --- a/drivers/net/loopback.c
> > > > +++ b/drivers/net/loopback.c
> > > > @@ -219,6 +219,13 @@ static __net_init int loopback_net_init(struct=
 net *net)
> > > >
> > > >       BUG_ON(dev->ifindex !=3D LOOPBACK_IFINDEX);
> > > >       net->loopback_dev =3D dev;
> > > > +
> > > > +     if (sysctl_netdev_loopback_state) {
> > > > +             /* Bring loopback device UP */
> > > > +             rtnl_lock();
> > > > +             dev_open(dev, NULL);
> > > > +             rtnl_unlock();
> > > > +     }
> > >
> > > The only concern I have here is that it breaks notification ordering.
> > > Is there precedent for NETDEV_UP to be generated before all pernet op=
s
> > > ->init was called?
> > I'm not sure if any and didn't see any issues in our usage / tests.
> > I'm not even sure anyone is watching/monitoring for lo status as such.
>
> Ido, David, how does this sound to you?
>
> I can't think of any particular case where bringing the device up (and
> populating it's addresses) before per netns init is finished could be
> problematic. But if this is going to make kernel coding harder the
> minor convenience of the knob is probably not worth it.

+Eric Dumazet

I'm not sure why kernel coding should get harder, but happy to listen
to the opinions.
