Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC4E179DC2
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 03:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbgCECTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 21:19:01 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:36243 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbgCECTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 21:19:01 -0500
Received: by mail-ot1-f66.google.com with SMTP id j14so4197982otq.3
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 18:19:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8Gmox/kCX2AOvaG1blFHqNiRizW+Wg7yNRzLpxgtKLU=;
        b=Oj+tVF6Mg8622gqzDs/4jpJI1NLx3VtEGWbfX7g0xxhbdfx+25pa99Lsk7g38hu0xr
         bW6MHWgTJ/Q+hCiWynOOt8aZ2fAfmlQtHHEkSS8/Woxe1P+Z2eOgeKdbM0LZxKpP0NPa
         LbatkAZDksdGn3Gadji/3AY/vi/Hd7HTMvZ/r8OKOtvZ9n4mCVwgjQ4O3yfxY84GfAZd
         d3EIO690GmWj4Pml5zsgwrTmFrey0GMiLKB0DrcSKznw8GLyRghPPl8B+d2mqC38Is09
         UQEPTrGsxGNV4g+AwmUv8YPXlOErgDtVtchuGrujjcxTIuWDEzOPO96OVkfArkdzm+wC
         5SzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8Gmox/kCX2AOvaG1blFHqNiRizW+Wg7yNRzLpxgtKLU=;
        b=MDl9R7FcX7JB+QBpXQPPOdUC1TSuTT9SAFgYj3RSTNYji8cUB8yKnHJ46MNcR7uJiX
         rvRTmznl9qruzcvCu7NCrOeuKHfzTpR+MVHgkE6h4FGGcn55seJokzWBYCR/SsduIsGf
         FTdFFTBS2JhzYRjQMZ5lH2iwo7r4ZCrErgARdnDbaJgQMlzEMY+IgJcwaPT2MO84wE35
         FpZC28zA/sQXNEE19VrUtgLgVaJUPw0mLWO5hrha1VzVWDqddGygokMfQdwzybyhkrWR
         ZwLIFW0b1cMY+f5ZKgEN7A7GUeVwHK+dG+U2bzY1z6ctys4QxpWiyfGmSsyZn8nJKesu
         X1LQ==
X-Gm-Message-State: ANhLgQ0Mjnxxt2qxq0zrtMZns8aRfdjovhYQqvF7q08br5zfcwKAqZVf
        6p6UKkf8QYoj++Wk5deM5dXs6BIP7jt7I/bvmW/8jw==
X-Google-Smtp-Source: ADFU+vucht722GyYw42Nwlm95SH5G6wJ3ZVu/v034CHYYgRaQtLUnV72QjnUmxeeCj4dZxFLaNJk5PCxnSwz75EsPJI=
X-Received: by 2002:a05:6830:46:: with SMTP id d6mr4856010otp.81.1583374739727;
 Wed, 04 Mar 2020 18:18:59 -0800 (PST)
MIME-Version: 1.0
References: <20200304233856.257891-1-shakeelb@google.com> <CANn89i+TiiLKsE7k4TyRqr03uNPW=UpkvpXL1LVWvTmhE_AUpA@mail.gmail.com>
In-Reply-To: <CANn89i+TiiLKsE7k4TyRqr03uNPW=UpkvpXL1LVWvTmhE_AUpA@mail.gmail.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Wed, 4 Mar 2020 18:18:48 -0800
Message-ID: <CALvZod7MSXGsV6nDngWS+mS-5tfu0ww3aJyXQ8GV2hRkEEcYDg@mail.gmail.com>
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

On Wed, Mar 4, 2020 at 5:36 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Wed, Mar 4, 2020 at 3:39 PM Shakeel Butt <shakeelb@google.com> wrote:
> >
> > If a TCP socket is allocated in IRQ context or cloned from unassociated
> > (i.e. not associated to a memcg) in IRQ context then it will remain
> > unassociated for its whole life. Almost half of the TCPs created on the
> > system are created in IRQ context, so, memory used by such sockets will
> > not be accounted by the memcg.
> >
> > This issue is more widespread in cgroup v1 where network memory
> > accounting is opt-in but it can happen in cgroup v2 if the source socket
> > for the cloning was created in root memcg.
> >
> > To fix the issue, just do the late association of the unassociated
> > sockets at accept() time in the process context and then force charge
> > the memory buffer already reserved by the socket.
> >
> > Signed-off-by: Shakeel Butt <shakeelb@google.com>
> > ---
> > Changes since v1:
> > - added sk->sk_rmem_alloc to initial charging.
> > - added synchronization to get memory usage and set sk_memcg race-free.
> >
> >  net/ipv4/inet_connection_sock.c | 19 +++++++++++++++++++
> >  1 file changed, 19 insertions(+)
> >
> > diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> > index a4db79b1b643..7bcd657cd45e 100644
> > --- a/net/ipv4/inet_connection_sock.c
> > +++ b/net/ipv4/inet_connection_sock.c
> > @@ -482,6 +482,25 @@ struct sock *inet_csk_accept(struct sock *sk, int flags, int *err, bool kern)
> >                 }
> >                 spin_unlock_bh(&queue->fastopenq.lock);
> >         }
> > +
> > +       if (mem_cgroup_sockets_enabled && !newsk->sk_memcg) {
> > +               int amt;
> > +
> > +               /* atomically get the memory usage and set sk->sk_memcg. */
> > +               lock_sock(newsk);
> > +
> > +               /* The sk has not been accepted yet, no need to look at
> > +                * sk->sk_wmem_queued.
> > +                */
> > +               amt = sk_mem_pages(newsk->sk_forward_alloc +
> > +                                  atomic_read(&sk->sk_rmem_alloc));
> > +               mem_cgroup_sk_alloc(newsk);
> > +
> > +               release_sock(newsk);
> > +
> > +               if (newsk->sk_memcg)
>
> Most sockets in accept queue should have amt == 0, so maybe avoid
> calling this thing only when amt == 0 ?
>

Thanks, will do in the next version. BTW I have tested with adding
mdelay() here and running iperf3 and I did see non-zero amt.

> Also  I would release_sock(newsk) after this, otherwise incoming
> packets could mess with newsk->sk_forward_alloc
>

I think that is fine. Once sk->sk_memcg is set then
mem_cgroup_charge_skmem() will be called for new incoming packets.
Here we just need to call mem_cgroup_charge_skmem() with amt before
sk->sk_memcg was set.

> if (amt && newsk->sk_memcg)
>       mem_cgroup_charge_skmem(newsk->sk_memcg, amt);
> release_sock(newsk);
>
> Also, I wonder if     mem_cgroup_charge_skmem() has been used at all
> these last four years
> on arches with PAGE_SIZE != 4096
>
> ( SK_MEM_QUANTUM is not anymore PAGE_SIZE, but 4096)
>

Oh so sk_mem_pages() does not really give the number of pages. Yeah
this needs a fix for non-4906 page size architectures. Though I can
understand why this has not been caught yet. Network memory accounting
is opt-in in cgroup v1 and most of the users still use v1. In cgroup
v2, it is enabled and there is no way to opt-out. Facebook is a
well-known v2 user and it seems like they don't have non-4096 page
size arch systems.
