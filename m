Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2919F179EC6
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 05:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgCEEyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 23:54:47 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:34293 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbgCEEyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 23:54:47 -0500
Received: by mail-ot1-f66.google.com with SMTP id j16so4481409otl.1
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 20:54:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wxMB2pp+9PjI13jJjWt8ByuXtWLK+X9MK3SPC71Gnu4=;
        b=tJ/6smOavDVAgu3Gdv6UPcaz/ASw6W4rh6d3f/b7iBjY6Foxfv6i1G0OlFGnI0h645
         wA0vSFhrAVZuAr2PJDr9E4WHV/usr5bRjaixTFpn8JjPp3QzkHVa+tncWWsSfQ9gGU/O
         6OCZybxu/Ly8SyivT03y5Svx2ipVvnyrSkVDGOiGek+CA3OhEXmERwV4mxW5DXyzwWmt
         ODfNLKdcYqr5PNNI8tKVwTv4MkqptJjbpXUwR/rR/dN19neY/vhWLvyoY2YrNTsIPkvP
         nKghJJEO1ErZxQXjl2DWtHTDR4Lk8Iahf874jvpX4hFCMpZlNuHHd8+wXH5Jn3IHb92E
         JRsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wxMB2pp+9PjI13jJjWt8ByuXtWLK+X9MK3SPC71Gnu4=;
        b=aAeTOGbdSNLXK0imnELlZdu2+wt2AUfSialjFdAg6rwvWwxhonyVsQzGIz+jxnv9aQ
         VqInNT84vhvi4P4lPFUzmBVTusE/wHr6TEzTizS+DmxWMnRRuVaTNZorug9zi7czQBs/
         Xl5IyRE/l1IgrfqZJIu2eG9QRnowWEdh7GGujzT0M/7uWKUB3PxWzy8dWglJaj9AAYzj
         jqCR63geB15Awvb/odMdkxF0U5WO8ptFWiwXLcOxlpBuFs8+JO2afZMzDMKG11LQSXXF
         3jx9XNxcng93iGhxpWIYsh232cPCi9QB7VqLVJd+AYqEyCQyXQSrRhaXBZSA2b2yPbx4
         3OGw==
X-Gm-Message-State: ANhLgQ2bN6RVmn0Usbcjdj0CsxalNfpqx3QIMlEzDiltU8fL0kYhw5/Q
        E6n/eEGjguanRKVQFWz+TwSRyvxmWZ8lJ6X2VC7HLw==
X-Google-Smtp-Source: ADFU+vsA/fXuJ3IRHxsfbCJ4aVofj1cKFBMR9e3ak4P1jFEdSsgTVK8BlhVGbuvdGoUrb3G4k+2cTTJNUxh+RFfBW2k=
X-Received: by 2002:a9d:6:: with SMTP id 6mr5250710ota.191.1583384085099; Wed,
 04 Mar 2020 20:54:45 -0800 (PST)
MIME-Version: 1.0
References: <20200304233856.257891-1-shakeelb@google.com> <CANn89i+TiiLKsE7k4TyRqr03uNPW=UpkvpXL1LVWvTmhE_AUpA@mail.gmail.com>
 <CALvZod7MSXGsV6nDngWS+mS-5tfu0ww3aJyXQ8GV2hRkEEcYDg@mail.gmail.com> <CANn89iJF3vSNG=uw5=-Knu48dKpceqXyYLm8z6d7aDoxaGDgTw@mail.gmail.com>
In-Reply-To: <CANn89iJF3vSNG=uw5=-Knu48dKpceqXyYLm8z6d7aDoxaGDgTw@mail.gmail.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Wed, 4 Mar 2020 20:54:34 -0800
Message-ID: <CALvZod7ksLOKkTLN9RZnALUYziCfO6vCtu1ivhWqG3RNUwVjXw@mail.gmail.com>
Subject: Re: [PATCH v2] net: memcg: late association of sock to memcg
To:     Eric Dumazet <edumazet@google.com>
Cc:     Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Cgroups <cgroups@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 4, 2020 at 8:38 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Wed, Mar 4, 2020 at 6:19 PM Shakeel Butt <shakeelb@google.com> wrote:
> >
> > On Wed, Mar 4, 2020 at 5:36 PM Eric Dumazet <edumazet@google.com> wrote:
> > >
> > > On Wed, Mar 4, 2020 at 3:39 PM Shakeel Butt <shakeelb@google.com> wrote:
> > > >
> > > > If a TCP socket is allocated in IRQ context or cloned from unassociated
> > > > (i.e. not associated to a memcg) in IRQ context then it will remain
> > > > unassociated for its whole life. Almost half of the TCPs created on the
> > > > system are created in IRQ context, so, memory used by such sockets will
> > > > not be accounted by the memcg.
> > > >
> > > > This issue is more widespread in cgroup v1 where network memory
> > > > accounting is opt-in but it can happen in cgroup v2 if the source socket
> > > > for the cloning was created in root memcg.
> > > >
> > > > To fix the issue, just do the late association of the unassociated
> > > > sockets at accept() time in the process context and then force charge
> > > > the memory buffer already reserved by the socket.
> > > >
> > > > Signed-off-by: Shakeel Butt <shakeelb@google.com>
> > > > ---
> > > > Changes since v1:
> > > > - added sk->sk_rmem_alloc to initial charging.
> > > > - added synchronization to get memory usage and set sk_memcg race-free.
> > > >
> > > >  net/ipv4/inet_connection_sock.c | 19 +++++++++++++++++++
> > > >  1 file changed, 19 insertions(+)
> > > >
> > > > diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> > > > index a4db79b1b643..7bcd657cd45e 100644
> > > > --- a/net/ipv4/inet_connection_sock.c
> > > > +++ b/net/ipv4/inet_connection_sock.c
> > > > @@ -482,6 +482,25 @@ struct sock *inet_csk_accept(struct sock *sk, int flags, int *err, bool kern)
> > > >                 }
> > > >                 spin_unlock_bh(&queue->fastopenq.lock);
> > > >         }
> > > > +
> > > > +       if (mem_cgroup_sockets_enabled && !newsk->sk_memcg) {
> > > > +               int amt;
> > > > +
> > > > +               /* atomically get the memory usage and set sk->sk_memcg. */
> > > > +               lock_sock(newsk);
> > > > +
> > > > +               /* The sk has not been accepted yet, no need to look at
> > > > +                * sk->sk_wmem_queued.
> > > > +                */
> > > > +               amt = sk_mem_pages(newsk->sk_forward_alloc +
> > > > +                                  atomic_read(&sk->sk_rmem_alloc));
> > > > +               mem_cgroup_sk_alloc(newsk);
> > > > +
> > > > +               release_sock(newsk);
> > > > +
> > > > +               if (newsk->sk_memcg)
> > >
> > > Most sockets in accept queue should have amt == 0, so maybe avoid
> > > calling this thing only when amt == 0 ?
> > >
> >
> > Thanks, will do in the next version. BTW I have tested with adding
> > mdelay() here and running iperf3 and I did see non-zero amt.
> >
> > > Also  I would release_sock(newsk) after this, otherwise incoming
> > > packets could mess with newsk->sk_forward_alloc
> > >
> >
> > I think that is fine. Once sk->sk_memcg is set then
> > mem_cgroup_charge_skmem() will be called for new incoming packets.
> > Here we just need to call mem_cgroup_charge_skmem() with amt before
> > sk->sk_memcg was set.
>
>
> Unfortunately, as soon as release_sock(newsk) is done, incoming
> packets can be fed to the socket,
> and completely change memory usage of the socket.
>
> For example, the whole queue might have been zapped, or collapsed, if
> we receive a RST packet,
> or if memory pressure asks us to prune the out of order queue.
>
> So you might charge something, then never uncharge it, since at
> close() time the socket will have zero bytes to uncharge.
>

Ok, thanks for the explanation. I will fix this in the next version.
