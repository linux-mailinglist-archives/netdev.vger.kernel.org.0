Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A3B2986E7
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 07:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1770479AbgJZGiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 02:38:03 -0400
Received: from mail-ej1-f66.google.com ([209.85.218.66]:37437 "EHLO
        mail-ej1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1770472AbgJZGiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 02:38:02 -0400
Received: by mail-ej1-f66.google.com with SMTP id p9so11753052eji.4;
        Sun, 25 Oct 2020 23:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dpR6HKBvLiwoLwNCGNwWMmEuYGZxFvFCHdWRL099Ijk=;
        b=APjI9pp3dxEgoubORj970OY1HMGaZmmrNtD6GSJ4ALYEzB1E/1Px55Qm+guW09n/ql
         2qa9jNO7fJ+jf/NGCSX7aBm8UIjg5Ck7TfnQ686uc3F4JmI4v58GhhAMr8PMPn421qQw
         V3Xt8wK6aSVa1x9iqUbBgf+U/YQfpxFGSMOjZGzLG7NTBnfq6oo+2wsAy5uBz8N8DRxm
         VAK1lPJg1XlSSgG75NgHW7q4e78QnXtNAWQ9GoeN6rbD37wynMoh2grQhvzFulFFJKCb
         IoYynB6xWsgkZhYE4A8DUjJ7Y/eJETanuaFZKj91osHhz/g6EyFTgDUPEDR3/8u7y/7H
         4ULg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dpR6HKBvLiwoLwNCGNwWMmEuYGZxFvFCHdWRL099Ijk=;
        b=Y7yIzWM/PQOTKm7hdDKFWupV6Pi2hu9coWkshOLe1Jm3syM1rCMOXZy3bzTEnlu6uS
         hj1FOXwNSkOYVm+sCmF6fwPq+Lu4AZYFsGN4G/kwU7d8Oj8GPCT9AQd/HZGV9ECIY1Ih
         XzcKPqWq8ofO9vHl5bpxLPmC9QySzO1x0cHpK2PmtyaAfwQ7jDx0dk4YZ0Udyx6+d2py
         XR91k1FStaL2jCCXNSteH3JzI5v+gh6AXZ+49Qd7UKCrOievBRGr1C1O3q1MxydT6tFy
         8PphOFRh9iKndcL1DOqUs7vd/TJcyjDR+5Qm2X8jzHaDJEHycFsX0n807fVcpBqQQKfV
         U1CQ==
X-Gm-Message-State: AOAM532MtCSqMKAPdFc/4TiZYRu8M5ymOdbnRoPe4b6J9NQW6vxI0VQs
        B3cdoxRyZptc+Po++aR2SGAvg1Nse5mio25D5/U=
X-Google-Smtp-Source: ABdhPJxTwpbIrN+pmdDG9MX150R5eZazoaLR4My17R2VWPLwTd+VNsH9VziuTiklU0xBcEMNeT2Dz0YdXIs3x4wCMQ4=
X-Received: by 2002:a17:906:a00d:: with SMTP id p13mr14561926ejy.183.1603694280382;
 Sun, 25 Oct 2020 23:38:00 -0700 (PDT)
MIME-Version: 1.0
References: <20201024154233.4024-1-fujiwara.masahiro@gmail.com> <20201025140550.1e29f770@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201025140550.1e29f770@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Masahiro Fujiwara <fujiwara.masahiro@gmail.com>
Date:   Mon, 26 Oct 2020 15:37:48 +0900
Message-ID: <CABBAZC+oQ64BcMRDgtXHes-Ri=20bh2GC-DuSZy7gPpKTFRMQw@mail.gmail.com>
Subject: Re: [PATCH net] gtp: fix an use-before-init in gtp_newlink()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Harald Welte <laforge@gnumonks.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andreas Schultz <aschultz@tpip.net>,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thanks for the review. Will send a new patch with the fixes soon.

----
Fujiwara

On Mon, Oct 26, 2020 at 6:05 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sat, 24 Oct 2020 15:42:33 +0000 Masahiro Fujiwara wrote:
> > *_pdp_find() from gtp_encap_recv() would trigger a crash when a peer
> > sends GTP packets while creating new GTP device.
> >
> > RIP: 0010:gtp1_pdp_find.isra.0+0x68/0x90 [gtp]
> > <SNIP>
> > Call Trace:
> >  <IRQ>
> >  gtp_encap_recv+0xc2/0x2e0 [gtp]
> >  ? gtp1_pdp_find.isra.0+0x90/0x90 [gtp]
> >  udp_queue_rcv_one_skb+0x1fe/0x530
> >  udp_queue_rcv_skb+0x40/0x1b0
> >  udp_unicast_rcv_skb.isra.0+0x78/0x90
> >  __udp4_lib_rcv+0x5af/0xc70
> >  udp_rcv+0x1a/0x20
> >  ip_protocol_deliver_rcu+0xc5/0x1b0
> >  ip_local_deliver_finish+0x48/0x50
> >  ip_local_deliver+0xe5/0xf0
> >  ? ip_protocol_deliver_rcu+0x1b0/0x1b0
> >
> > gtp_encap_enable() should be called after gtp_hastable_new() otherwise
> > *_pdp_find() will access the uninitialized hash table.
>
> Looks good, minor nits:
>
>  - is the time zone broken on your system? Looks like your email has
>    arrived with the date far in the past, so the build systems have
>    missed it. Could you double check the time on your system?
>
> > Fixes: 1e3a3abd8 ("gtp: make GTP sockets in gtp_newlink optional")
>
> The hash looks short, should be at lest 12 chars:
>
> Fixes: 1e3a3abd8b28 ("gtp: make GTP sockets in gtp_newlink optional")
>
> > Signed-off-by: Masahiro Fujiwara <fujiwara.masahiro@gmail.com>
>
> > diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
> > index 8e47d0112e5d..6c56337b02a3 100644
> > --- a/drivers/net/gtp.c
> > +++ b/drivers/net/gtp.c
> > @@ -663,10 +663,6 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
> >
> >       gtp = netdev_priv(dev);
> >
> > -     err = gtp_encap_enable(gtp, data);
> > -     if (err < 0)
> > -             return err;
> > -
> >       if (!data[IFLA_GTP_PDP_HASHSIZE]) {
> >               hashsize = 1024;
> >       } else {
> > @@ -676,13 +672,18 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
> >       }
> >
> >       err = gtp_hashtable_new(gtp, hashsize);
> > +     if (err < 0) {
> > +             return err;
> > +     }
>
> no need for braces around single statement
>
> > +
> > +     err = gtp_encap_enable(gtp, data);
> >       if (err < 0)
> >               goto out_encap;
> >
> >       err = register_netdevice(dev);
> >       if (err < 0) {
> >               netdev_dbg(dev, "failed to register new netdev %d\n", err);
> > -             goto out_hashtable;
> > +             goto out_encap;
> >       }
> >
> >       gn = net_generic(dev_net(dev), gtp_net_id);
> > @@ -693,11 +694,10 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
> >
> >       return 0;
> >
> > -out_hashtable:
> > -     kfree(gtp->addr_hash);
> > -     kfree(gtp->tid_hash);
> >  out_encap:
> >       gtp_encap_disable(gtp);
>
> I'd personally move the out_hashtable: label here and keep it, just for
> clarity. Otherwise reader has to double check that gtp_encap_disable()
> can be safely called before gtp_encap_enable().
>
> Also gtp_encap_disable() could change in the future breaking this
> assumption.
>
> > +     kfree(gtp->addr_hash);
> > +     kfree(gtp->tid_hash);
> >       return err;
> >  }
> >
>
