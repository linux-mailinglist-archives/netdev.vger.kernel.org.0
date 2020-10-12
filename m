Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD36628B1CE
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 11:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387472AbgJLJxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 05:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbgJLJxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 05:53:39 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D326C0613D1
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 02:53:39 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id n9so13726277pgf.9
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 02:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sn6xmUdTB1gp5VGgvXCTEMXAJuxSUuB9tlWw8Fq4HPM=;
        b=S/Uy5/9opCRWAvXzlKUsyfnuZH3nXfZuek8qLpeXaXtoTgaMHqMjFB5J2Jaix/Uwhj
         XNWc3JMXvST3cZmD/26t/lODN3tnZFTzPhvhvqy0pWDbXyil+lwS5gSRdQxaBDSiPKGC
         JInmtJ24vb4sJA9K4IaSnG3Ib6bIEfusm/ej0bT/tLxyBUCpMTfeDCV53PVWTjX2RJgc
         5rt+YMd9xEy4+Y4SIeF/ISKwkaHtJX3fYLKUaQRDA1aUkUezT1qrgRYxrsxIc/rHMobo
         jr48Ir65g6U8N1A7x5Cs7XdVXR8dMTn2ra4ki4rDO6CcBr/hOMEMbkzxnRAImKM0E0kV
         Yd/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sn6xmUdTB1gp5VGgvXCTEMXAJuxSUuB9tlWw8Fq4HPM=;
        b=GZ+3GkloR61bKtvAOcAhrLhkL9du22qvkypXOcPRVnBxSU/vei1yDOHF8/uhpWdxr9
         8JdzOpFdvq7GGHpaJ8iJHC74Vjkjc3z9/d5WMflSDVzOZVrAgrJJ0Bg5AoJaFQlgBjyQ
         NbXBwEfbiVS0jC6Sm0TXcYh03l7fLQfONqbDv+K1uwMcLTmN+vc0Vmbil90TClRLH5du
         mGeApSTG1x4x3Z6Uzh9TXYphLF1nEgWHw8s+t4+8VXyT45sNx/q3GUOb+vF2EQvHy3QS
         q+rQiutAsURPQVWK1CRnGH38XRA0FAa5DkkFwxuOnakzrN7xV0fjVCvs1B05sYDX4VsV
         plXQ==
X-Gm-Message-State: AOAM533lLiF37yd+u2+i+jzDyGv8054xttEm4lQBjmFLw5DqN64b4EJ2
        hSZfLXvPQHAOvYZFOjZYn3NA2tO9T/hKwMOchFxjjA==
X-Google-Smtp-Source: ABdhPJyZzFLu56q7KSwjoqmED0nD/Mf8NBR5wmig0VDfTyRAvWQtaIbkn88N932UzTVPy2+058Fq79lgqoFQOV16kaQ=
X-Received: by 2002:a17:90a:4749:: with SMTP id y9mr6534556pjg.229.1602496418720;
 Mon, 12 Oct 2020 02:53:38 -0700 (PDT)
MIME-Version: 1.0
References: <20201010103854.66746-1-songmuchun@bytedance.com>
 <CAM_iQpUQXctR8UBNRP6td9dWTA705tP5fWKj4yZe9gOPTn_8oQ@mail.gmail.com>
 <CAMZfGtUhVx_iYY3bJZRY5s1PG0N1mCsYGS9Oku8cTqPiMDze-g@mail.gmail.com>
 <CANn89iKprp7WYeZy4RRO5jHykprnSCcVBc7Tk14Ui_MA9OK7Fg@mail.gmail.com>
 <CAMZfGtXVKER_GM-wwqxrUshDzcEg9FkS3x_BaMTVyeqdYPGSkw@mail.gmail.com> <9262ea44-fc3a-0b30-54dd-526e16df85d1@gmail.com>
In-Reply-To: <9262ea44-fc3a-0b30-54dd-526e16df85d1@gmail.com>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Mon, 12 Oct 2020 17:53:01 +0800
Message-ID: <CAMZfGtVF6OjNuJFUExRMY1k-EaDS744=nKy6_a2cYdrJRncTgQ@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] mm: proc: add Sock to /proc/meminfo
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>, rafael@kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Shakeel Butt <shakeelb@google.com>,
        Will Deacon <will@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Roman Gushchin <guro@fb.com>, Neil Brown <neilb@suse.de>,
        rppt@kernel.org, Sami Tolvanen <samitolvanen@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Feng Tang <feng.tang@intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Florian Westphal <fw@strlen.de>, gustavoars@kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Dexuan Cui <decui@microsoft.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Thomas Gleixner <tglx@linutronix.de>, dave@stgolabs.net,
        Michel Lespinasse <walken@google.com>,
        Jann Horn <jannh@google.com>, chenqiwu@xiaomi.com,
        christophe.leroy@c-s.fr, Minchan Kim <minchan@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 12, 2020 at 5:24 PM Eric Dumazet <eric.dumazet@gmail.com> wrote=
:
>
>
>
> On 10/12/20 10:39 AM, Muchun Song wrote:
> > On Mon, Oct 12, 2020 at 3:42 PM Eric Dumazet <edumazet@google.com> wrot=
e:
> >>
> >> On Mon, Oct 12, 2020 at 6:22 AM Muchun Song <songmuchun@bytedance.com>=
 wrote:
> >>>
> >>> On Mon, Oct 12, 2020 at 2:39 AM Cong Wang <xiyou.wangcong@gmail.com> =
wrote:
> >>>>
> >>>> On Sat, Oct 10, 2020 at 3:39 AM Muchun Song <songmuchun@bytedance.co=
m> wrote:
> >>>>>
> >>>>> The amount of memory allocated to sockets buffer can become signifi=
cant.
> >>>>> However, we do not display the amount of memory consumed by sockets
> >>>>> buffer. In this case, knowing where the memory is consumed by the k=
ernel
> >>>>
> >>>> We do it via `ss -m`. Is it not sufficient? And if not, why not addi=
ng it there
> >>>> rather than /proc/meminfo?
> >>>
> >>> If the system has little free memory, we can know where the memory is=
 via
> >>> /proc/meminfo. If a lot of memory is consumed by socket buffer, we ca=
nnot
> >>> know it when the Sock is not shown in the /proc/meminfo. If the unawa=
re user
> >>> can't think of the socket buffer, naturally they will not `ss -m`. Th=
e
> >>> end result
> >>> is that we still don=E2=80=99t know where the memory is consumed. And=
 we add the
> >>> Sock to the /proc/meminfo just like the memcg does('sock' item in the=
 cgroup
> >>> v2 memory.stat). So I think that adding to /proc/meminfo is sufficien=
t.
> >>>
> >>>>
> >>>>>  static inline void __skb_frag_unref(skb_frag_t *frag)
> >>>>>  {
> >>>>> -       put_page(skb_frag_page(frag));
> >>>>> +       struct page *page =3D skb_frag_page(frag);
> >>>>> +
> >>>>> +       if (put_page_testzero(page)) {
> >>>>> +               dec_sock_node_page_state(page);
> >>>>> +               __put_page(page);
> >>>>> +       }
> >>>>>  }
> >>>>
> >>>> You mix socket page frag with skb frag at least, not sure this is ex=
actly
> >>>> what you want, because clearly skb page frags are frequently used
> >>>> by network drivers rather than sockets.
> >>>>
> >>>> Also, which one matches this dec_sock_node_page_state()? Clearly
> >>>> not skb_fill_page_desc() or __skb_frag_ref().
> >>>
> >>> Yeah, we call inc_sock_node_page_state() in the skb_page_frag_refill(=
).
> >>> So if someone gets the page returned by skb_page_frag_refill(), it mu=
st
> >>> put the page via __skb_frag_unref()/skb_frag_unref(). We use PG_priva=
te
> >>> to indicate that we need to dec the node page state when the refcount=
 of
> >>> page reaches zero.
> >>>
> >>
> >> Pages can be transferred from pipe to socket, socket to pipe (splice()
> >> and zerocopy friends...)
> >>
> >>  If you want to track TCP memory allocations, you always can look at
> >> /proc/net/sockstat,
> >> without adding yet another expensive memory accounting.
> >
> > The 'mem' item in the /proc/net/sockstat does not represent real
> > memory usage. This is just the total amount of charged memory.
> >
> > For example, if a task sends a 10-byte message, it only charges one
> > page to memcg. But the system may allocate 8 pages. Therefore, it
> > does not truly reflect the memory allocated by the above memory
> > allocation path. We can see the difference via the following message.
> >
> > cat /proc/net/sockstat
> >   sockets: used 698
> >   TCP: inuse 70 orphan 0 tw 617 alloc 134 mem 13
> >   UDP: inuse 90 mem 4
> >   UDPLITE: inuse 0
> >   RAW: inuse 1
> >   FRAG: inuse 0 memory 0
> >
> > cat /proc/meminfo | grep Sock
> >   Sock:              13664 kB
> >
> > The /proc/net/sockstat only shows us that there are 17*4 kB TCP
> > memory allocations. But apply this patch, we can see that we truly
> > allocate 13664 kB(May be greater than this value because of per-cpu
> > stat cache). Of course the load of the example here is not high. In
> > some high load cases, I believe the difference here will be even
> > greater.
> >
>
> This is great, but you have not addressed my feedback.
>
> TCP memory allocations are bounded by /proc/sys/net/ipv4/tcp_mem
>
> Fact that the memory is forward allocated or not is a detail.
>
> If you think we must pre-allocate memory, instead of forward allocations,
> your patch does not address this. Adding one line per consumer in /proc/m=
eminfo looks
> wrong to me.

I think that the consumer which consumes a lot of memory should be added
to the /proc/meminfo. This can help us know the user of large memory.

>
> If you do not want 9.37 % of physical memory being possibly used by TCP,
> just change /proc/sys/net/ipv4/tcp_mem accordingly ?

We are not complaining about TCP using too much memory, but how do
we know that TCP uses a lot of memory. When I firstly face this problem,
I do not know who uses the 25GB memory and it is not shown in the /proc/mem=
info.
If we can know the amount memory of the socket buffer via /proc/meminfo, we
may not need to spend a lot of time troubleshooting this problem. Not every=
one
knows that a lot of memory may be used here. But I believe many people
should know /proc/meminfo to confirm memory users.

Thanks.

>
>


--=20
Yours,
Muchun
