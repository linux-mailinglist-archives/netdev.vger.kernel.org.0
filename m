Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7AE1D9959
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 16:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729210AbgESOTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 10:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728855AbgESOTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 10:19:00 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B08F2C08C5C0;
        Tue, 19 May 2020 07:18:59 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id g1so13895903ljk.7;
        Tue, 19 May 2020 07:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2v5cVIMALEZeOCe9AUN80g80L3FNOhF6glvveRpwVFA=;
        b=iSR8N/kAOeN+6XftZH9tOlczL62NRBF9Wr+lfL+YQluPicNV2tOvnzBbITewqLcSb1
         SevDYGcylG+pTcM5cwc5pS9s22x/iVnmIflxgvRU4gida3p8h7NNcQAiq16GbVpqCRnS
         HgQGpxJaOa+638qLgq2RISA3EADTFzXunD1FD0T+yQeoqaVgsXlNTGLUBlOEhj0GqG2x
         9dGDrO60Ycznp4aUCHwPuYC8I6tzMrOhKL7mMNSIPHSPZboHh0RvfzPMO0aksDbeKA8W
         dEo6lxh8+LIxFcLUD0iGRoLBJ4D1SKRWaFxEhfoGvWgWdRyf2OG+kdLL6xFE4ACiNBsv
         Et3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2v5cVIMALEZeOCe9AUN80g80L3FNOhF6glvveRpwVFA=;
        b=TXJJsqhPeimBZIdc9704bBEdJMqeloB5G6Q65Mk2qWJctKHQYzfbrlt7FjKnrkf8OC
         dVD/pkJaX8pG3YScZDPjS5GGMD8GcUMF+pLZZbCYLqhfPi8NdEphl3SqJyBgX87qOh1X
         y9IwjeBaXY/i39vZA1A9OtvJ83uFDHnMdLQOEXqft69pP/PIvx41E5vEplg3F8kjXkjD
         ugwS0q5dXH/ae1w0z0Cokuk1wsAOX4sUmP81/C2oMAeGvqV1usmjSNFRKzAENutIZrYK
         hi4279PJpW5wfuWDIWcmTcY5VwVJrqTs4RlCdDlOJBxba3JR09vaNdFIb60zsnXXR365
         HXhw==
X-Gm-Message-State: AOAM533e1U+qnWPt8THMMc0Gj8pR/E/rt669biLZMCxn9xXdiPV8IE95
        JbohmIOyHIsHhB8SjkHVfFXXrJ+NTzKDxNo/aDI=
X-Google-Smtp-Source: ABdhPJx27ZkhuciouKC7SjdVXrdjgBwhM4OCO7NFDiSiRSYi2n/V6eNVQEGKPSZXCvLB3LQPUFZxfacVSwuXd7ILHzo=
X-Received: by 2002:a2e:920f:: with SMTP id k15mr12804493ljg.131.1589897938056;
 Tue, 19 May 2020 07:18:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200515013556.5582-1-kim.andrewsy@gmail.com> <20200517171654.8194-1-kim.andrewsy@gmail.com>
 <alpine.LFD.2.21.2005182027460.4524@ja.home.ssi.bg> <CABc050G-yW-frv0mCmg=hMnC4iOx9Ht2Zv8eoS1cxQ8uKX6NQw@mail.gmail.com>
 <CANHHuCW6i0BjLRMYkfY8eZGZJZTnE-NO9EH+-gfH94cc6yYn1A@mail.gmail.com>
In-Reply-To: <CANHHuCW6i0BjLRMYkfY8eZGZJZTnE-NO9EH+-gfH94cc6yYn1A@mail.gmail.com>
From:   Andrew Kim <kim.andrewsy@gmail.com>
Date:   Tue, 19 May 2020 10:18:45 -0400
Message-ID: <CABc050Fb_aX1tOqyhcLJyVv_RvBRQ9EH_aBkUHtMV6MKb_+m9Q@mail.gmail.com>
Subject: Re: [PATCH] netfilter/ipvs: immediately expire UDP connections
 matching unavailable destination if expire_nodest_conn=1
To:     Marco Angaroni <marcoangaroni@gmail.com>
Cc:     Julian Anastasov <ja@ssi.bg>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Jakub Kicinski <kuba@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "open list:IPVS" <netdev@vger.kernel.org>,
        "open list:IPVS" <lvs-devel@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
        "open list:NETFILTER" <coreteam@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marco,

> could you please confirm if/how this patch is changing any of the?
> following behaviours, which I=E2=80=99m listing below as per my understan=
ding?

This patch would optimize b) where the chances of packets being silently
dropped is lower.

> However I'm confused about the references to OPS mode.
> And why you need to expire all the connections at once: if you expire
> on a per connection basis, the client experiences the same behaviour
> (no more re-transmissions), but you avoid the complexities of a new
> thread.

I agree for TCP the client would experience the same behavior. This is most=
ly
problematic for UDP when there are many entries in the connection hash
from the same client to 1 destination. If we only expire connections
on receiving
packets, there can be many dropped packets before all entries are expired (=
or
we reached the UDP timeout). Expiring all UDP packets immediately would
reduce the number of packets dropped significantly.

Thanks,

Andrew Sy Kim

On Tue, May 19, 2020 at 7:46 AM Marco Angaroni <marcoangaroni@gmail.com> wr=
ote:
>
> Hi Andrew, Julian,
>
> could you please confirm if/how this patch is changing any of the
> following behaviours, which I=E2=80=99m listing below as per my understan=
ding
> ?
>
> When expire_nodest is set and real-server is unavailable, at the
> moment the following happens to a packet going through IPVS:
>
> a) TCP (or other connection-oriented protocols):
>    the packet is silently dropped, then the following retransmission
> causes the generation of a RST from the load-balancer to the client,
> which will then re-open a new TCP connection
> b) UDP:
>    the packet is silently dropped, then the following retransmission
> is rescheduled to a new real-server
> c) UDP in OPS mode:
>    the packet is rescheduled to a new real-server, as no previous
> connection exists in IPVS connection table, and a new OPS connection
> is created (but it lasts only the time to transmit the packet)
> d) UDP in OPS mode + persistent-template:
>    the packet is rescheduled to a new real-server, as previous
> template-connection is invalidated, a new template-connection is
> created, and a new OPS connection is created (but it lasts only the
> time to transmit the packet)
>
> It seems to me that you are trying to optimize case a) and b),
> avoiding the first step where the packet is silently dropped and
> consequently avoiding the retransmission.
> And contextually expire also all the other connections pointing to the
> unavailable real-sever.
>
> However I'm confused about the references to OPS mode.
> And why you need to expire all the connections at once: if you expire
> on a per connection basis, the client experiences the same behaviour
> (no more re-transmissions), but you avoid the complexities of a new
> thread.
>
> Maybe also the documentation of expire_nodest_conn sysctl should be updat=
ed.
> When it's stated:
>
>         If this feature is enabled, the load balancer will expire the
>         connection immediately when a packet arrives and its
>         destination server is not available, then the client program
>         will be notified that the connection is closed
>
> I think it should be at least "and the client program" instead of
> "then the client program".
> Or a more detailed explanation.
>
> Thanks
> Marco Angaroni
>
>
> Il giorno lun 18 mag 2020 alle ore 22:06 Andrew Kim
> <kim.andrewsy@gmail.com> ha scritto:
> >
> > Hi Julian,
> >
> > Thank you for getting back to me. I will update the patch based on
> > your feedback shortly.
> >
> > Regards,
> >
> > Andrew
> >
> > On Mon, May 18, 2020 at 3:10 PM Julian Anastasov <ja@ssi.bg> wrote:
> > >
> > >
> > >         Hello,
> > >
> > > On Sun, 17 May 2020, Andrew Sy Kim wrote:
> > >
> > > > If expire_nodest_conn=3D1 and a UDP destination is deleted, IPVS sh=
ould
> > > > also expire all matching connections immiediately instead of waitin=
g for
> > > > the next matching packet. This is particulary useful when there are=
 a
> > > > lot of packets coming from a few number of clients. Those clients a=
re
> > > > likely to match against existing entries if a source port in the
> > > > connection hash is reused. When the number of entries in the connec=
tion
> > > > tracker is large, we can significantly reduce the number of dropped
> > > > packets by expiring all connections upon deletion.
> > > >
> > > > Signed-off-by: Andrew Sy Kim <kim.andrewsy@gmail.com>
> > > > ---
> > > >  include/net/ip_vs.h             |  7 ++++++
> > > >  net/netfilter/ipvs/ip_vs_conn.c | 38 +++++++++++++++++++++++++++++=
++++
> > > >  net/netfilter/ipvs/ip_vs_core.c |  5 -----
> > > >  net/netfilter/ipvs/ip_vs_ctl.c  |  9 ++++++++
> > > >  4 files changed, 54 insertions(+), 5 deletions(-)
> > > >
> > >
> > > > diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/i=
p_vs_conn.c
> > > > index 02f2f636798d..c69dfbbc3416 100644
> > > > --- a/net/netfilter/ipvs/ip_vs_conn.c
> > > > +++ b/net/netfilter/ipvs/ip_vs_conn.c
> > > > @@ -1366,6 +1366,44 @@ static void ip_vs_conn_flush(struct netns_ip=
vs *ipvs)
> > > >               goto flush_again;
> > > >       }
> > > >  }
> > > > +
> > > > +/*   Flush all the connection entries in the ip_vs_conn_tab with a
> > > > + *   matching destination.
> > > > + */
> > > > +void ip_vs_conn_flush_dest(struct netns_ipvs *ipvs, struct ip_vs_d=
est *dest)
> > > > +{
> > > > +     int idx;
> > > > +     struct ip_vs_conn *cp, *cp_c;
> > > > +
> > > > +     rcu_read_lock();
> > > > +     for (idx =3D 0; idx < ip_vs_conn_tab_size; idx++) {
> > > > +             hlist_for_each_entry_rcu(cp, &ip_vs_conn_tab[idx], c_=
list) {
> > > > +                     if (cp->ipvs !=3D ipvs)
> > > > +                             continue;
> > > > +
> > > > +                     if (cp->dest !=3D dest)
> > > > +                             continue;
> > > > +
> > > > +                     /* As timers are expired in LIFO order, resta=
rt
> > > > +                      * the timer of controlling connection first,=
 so
> > > > +                      * that it is expired after us.
> > > > +                      */
> > > > +                     cp_c =3D cp->control;
> > > > +                     /* cp->control is valid only with reference t=
o cp */
> > > > +                     if (cp_c && __ip_vs_conn_get(cp)) {
> > > > +                             IP_VS_DBG(4, "del controlling connect=
ion\n");
> > > > +                             ip_vs_conn_expire_now(cp_c);
> > > > +                             __ip_vs_conn_put(cp);
> > > > +                     }
> > > > +                     IP_VS_DBG(4, "del connection\n");
> > > > +                     ip_vs_conn_expire_now(cp);
> > > > +             }
> > > > +             cond_resched_rcu();
> > >
> > >         Such kind of loop is correct if done in another context:
> > >
> > > 1. kthread
> > > or
> > > 2. delayed work: mod_delayed_work(system_long_wq, ...)
> > >
> > >         Otherwise cond_resched_rcu() can schedule() while holding
> > > __ip_vs_mutex. Also, it will add long delay if many dests are
> > > removed.
> > >
> > >         If such loop analyzes instead all cp->dest for
> > > IP_VS_DEST_F_AVAILABLE, it should be done after calling
> > > __ip_vs_conn_get().
> > >
> > > >  static int sysctl_snat_reroute(struct netns_ipvs *ipvs) { return 0=
; }
> > > > diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip=
_vs_ctl.c
> > > > index 8d14a1acbc37..f87c03622874 100644
> > > > --- a/net/netfilter/ipvs/ip_vs_ctl.c
> > > > +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> > > > @@ -1225,6 +1225,15 @@ ip_vs_del_dest(struct ip_vs_service *svc, st=
ruct ip_vs_dest_user_kern *udest)
> > > >        */
> > > >       __ip_vs_del_dest(svc->ipvs, dest, false);
> > > >
> > > > +     /*      If expire_nodest_conn is enabled and protocol is UDP,
> > > > +      *      attempt best effort flush of all connections with thi=
s
> > > > +      *      destination.
> > > > +      */
> > > > +     if (sysctl_expire_nodest_conn(svc->ipvs) &&
> > > > +         dest->protocol =3D=3D IPPROTO_UDP) {
> > > > +             ip_vs_conn_flush_dest(svc->ipvs, dest);
> > >
> > >         Above work should be scheduled from __ip_vs_del_dest().
> > > Check for UDP is not needed, sysctl_expire_nodest_conn() is for
> > > all protocols.
> > >
> > >         If the flushing is complex to implement, we can still allow
> > > rescheduling for unavailable dests:
> > >
> > > - first we should move this block above the ip_vs_try_to_schedule()
> > > block because:
> > >
> > >         1. the scheduling does not return unavailabel dests, even
> > >         for persistence, so no need to check new connections for
> > >         the flag
> > >
> > >         2. it will allow to create new connection if dest for
> > >         existing connection is unavailable
> > >
> > >         if (cp && cp->dest && !(cp->dest->flags & IP_VS_DEST_F_AVAILA=
BLE)) {
> > >                 /* the destination server is not available */
> > >
> > >                 if (sysctl_expire_nodest_conn(ipvs)) {
> > >                         bool uses_ct =3D ip_vs_conn_uses_conntrack(cp=
, skb);
> > >
> > >                         ip_vs_conn_expire_now(cp);
> > >                         __ip_vs_conn_put(cp);
> > >                         if (uses_ct)
> > >                                 return NF_DROP;
> > >                         cp =3D NULL;
> > >                 } else {
> > >                         __ip_vs_conn_put(cp);
> > >                         return NF_DROP;
> > >                 }
> > >         }
> > >
> > >         if (unlikely(!cp)) {
> > >                 int v;
> > >
> > >                 if (!ip_vs_try_to_schedule(ipvs, af, skb, pd, &v, &cp=
, &iph))
> > >                         return v;
> > >         }
> > >
> > >         Before now, we always waited one jiffie connection to expire,
> > > now one packet will:
> > >
> > > - schedule expiration for existing connection with unavailable dest,
> > > as before
> > >
> > > - create new connection to available destination that will be found
> > > first in lists. But it can work only when sysctl var "conntrack" is 0=
,
> > > we do not want to create two netfilter conntracks to different
> > > real servers.
> > >
> > >         Note that we intentionally removed the timer_pending() check
> > > because we can not see existing ONE_PACKET connections in table.
> > >
> > > Regards
> > >
> > > --
> > > Julian Anastasov <ja@ssi.bg>
