Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A744237B08E
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 23:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbhEKVJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 17:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbhEKVJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 17:09:47 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDBD4C061574;
        Tue, 11 May 2021 14:08:39 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id j12so10587938pgh.7;
        Tue, 11 May 2021 14:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yeTmaLpBoDA9Ekt1gKnRp3RBMHLIvZWlfy842jaoV5M=;
        b=CqcA7WwPDBX4B24ONzqtDPGitezowFjBeo4a8DsZABJ4gIhmuoCFlW8p9VqgHCMISZ
         YkjMBRDCV7/q6QFy5zojPtF45duIZ94Wu+SaGyL5w4Z/pE5bvnsfYTJbTvGW1qIwVlu/
         mfVpfJJNZWOnEV0BFFGr5dgSj6Heg7q5HS1vgVhr8U2gUjIEZONXeUbDnCYdEO5gCdGa
         Ev12fXVUvEdAlMDeKNVQwWK5uLO0OOZP6w6efeaUTo5iroBXp5W4SEXQSOVFplDgIcEk
         fAKO3ZbBnxAQlL2W+KaAFh16rFNVIcvAgSwogT6laykolUtiZfKOOA6T+4PMOrOxMfBk
         5/gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yeTmaLpBoDA9Ekt1gKnRp3RBMHLIvZWlfy842jaoV5M=;
        b=NuiKNhBfM+j8nxj99mo1wGivXPC5vD9blTIHBvXPgmXAbHivDozwzRxDK6jFwoTv3M
         eSmZDrchYXmAh7SoTQgLB1S9Ctwl+WceoL48POKkrcoEggnGC0Ba+qOEvJCK3LUkzbrf
         nO5YP28kvJWruY+rcvtdKOKgn1E+JnCazzq2oJz12z+0J+BAR1hSHqELr7eIc2mO6cdC
         h9w29M435nmxL03w1lRvYyuQlpYHIHGEDwo825qUuqFoLPz2zHGKoQsY1RwTqaT4o5qe
         q4PLGoW830PSTTblzU2y49XOaaS54Z2jrz1NHkOTIbFwMVBcOGWIrZGwdMWWUYtlTrMU
         1Uyg==
X-Gm-Message-State: AOAM533trgfEw/RPMrvAqlgcoRV7mfncAcbLxY/qLfwt3kgPl74g2dbY
        +nNlczzen8HT6y6eBWLOh5dA/jHUogiFwvl2nks=
X-Google-Smtp-Source: ABdhPJw2EergD/NX50T4OkhnmC9+rTkdRU1qz0edm+NvDNtB5VB+K8fCZ8qgXabuqyD3CqZJSjTqnEnUtOf3VB7trqE=
X-Received: by 2002:a63:d014:: with SMTP id z20mr31821501pgf.428.1620767319364;
 Tue, 11 May 2021 14:08:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210402192823.bqwgipmky3xsucs5@ast-mbp> <CAM_iQpUfv7c19zFN1Y5-cSUiVwpk0bmtBMSxZoELgDOFCQ=qAw@mail.gmail.com>
 <20210402234500.by3wigegeluy5w7j@ast-mbp> <CAM_iQpWf2aYbY=tKejb=nx7LWBLo1woTp-n4wOLhkUuDCz8u-Q@mail.gmail.com>
 <20210412230151.763nqvaadrrg77kd@ast-mbp.dhcp.thefacebook.com>
 <CAM_iQpWePmmpr0RKqCrQ=NPiGrq2Tx9OU9y3e4CTzFjvh5t47w@mail.gmail.com>
 <CAADnVQLsmULxJYq9rHS4xyg=VAUeexJTh35vTWTVgjeqwX4D6g@mail.gmail.com>
 <CAM_iQpVtxgZNeqh4_Pqftc3D163JnRvP3AZRuFrYNeyWLgVBVA@mail.gmail.com>
 <CAADnVQLFehCeQRbwEQ9VM-=Y3V3es2Ze8gFPs6cZHwNH0Ct7vw@mail.gmail.com>
 <CAM_iQpWDhoY_msU=AowHFq3N3OuQpvxd2ADP_Z+gxBfGduhrPA@mail.gmail.com>
 <20210427020159.hhgyfkjhzjk3lxgs@ast-mbp.dhcp.thefacebook.com>
 <CAM_iQpVE4XG7SPAVBmV2UtqUANg3X-1ngY7COYC03NrT6JkZ+g@mail.gmail.com>
 <CAADnVQK9BgguVorziWgpMktLHuPCgEaKa4fz-KCfhcZtT46teQ@mail.gmail.com>
 <CAM_iQpWBrxuT=Y3CbhxYpE5a+QSk-O=Vj4euegggXAAKTHRBqw@mail.gmail.com> <CAOftzPh0cj_XRES8mrNWnyKFZDLpRez09NAofmu1F1JAZf43Cw@mail.gmail.com>
In-Reply-To: <CAOftzPh0cj_XRES8mrNWnyKFZDLpRez09NAofmu1F1JAZf43Cw@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 11 May 2021 14:08:27 -0700
Message-ID: <CAM_iQpXfbjQUpo56DUHrBmJ_LnNDi7axKn-dSYA2Uu5oewVn7A@mail.gmail.com>
Subject: Re: [RFC Patch bpf-next] bpf: introduce bpf timer
To:     Joe Stringer <joe@cilium.io>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 10, 2021 at 10:06 PM Joe Stringer <joe@cilium.io> wrote:
>
> Hi Cong,
>
> On Sat, May 8, 2021 at 10:39 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Tue, Apr 27, 2021 at 11:34 AM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Tue, Apr 27, 2021 at 9:36 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > >
> > > > We don't go back to why user-space cleanup is inefficient again,
> > > > do we? ;)
> > >
> > > I remain unconvinced that cilium conntrack _needs_ timer apis.
> > > It works fine in production and I don't hear any complaints
> > > from cilium users. So 'user space cleanup inefficiencies' is
> > > very subjective and cannot be the reason to add timer apis.
> >
> > I am pretty sure I showed the original report to you when I sent
> > timeout hashmap patch, in case you forgot here it is again:
> > https://github.com/cilium/cilium/issues/5048
> >
> > and let me quote the original report here:
> >
> > "The current implementation (as of v1.2) for managing the contents of
> > the datapath connection tracking map leaves something to be desired:
> > Once per minute, the userspace cilium-agent makes a series of calls to
> > the bpf() syscall to fetch all of the entries in the map to determine
> > whether they should be deleted. For each entry in the map, 2-3 calls
> > must be made: One to fetch the next key, one to fetch the value, and
> > perhaps one to delete the entry. The maximum size of the map is 1
> > million entries, and if the current count approaches this size then
> > the garbage collection goroutine may spend a significant number of CPU
> > cycles iterating and deleting elements from the conntrack map."
>
> I'm also curious to hear more details as I haven't seen any recent
> discussion in the common Cilium community channels (GitHub / Slack)
> around deficiencies in the conntrack garbage collection since we
> addressed the LRU issues upstream and switched back to LRU maps.
> There's an update to the report quoted from the same link above:
>
> "In recent releases, we've moved back to LRU for management of the CT
> maps so the core problem is not as bad; furthermore we have
> implemented a backoff for GC depending on the size and number of
> entries in the conntrack table, so that in active environments the
> userspace GC is frequent enough to prevent issues but in relatively
> passive environments the userspace GC is only rarely run (to minimize
> CPU impact)."

Thanks for sharing the update. I am sure Jamal/Pedro measured LRU
and percpu LRU as well, hope they can share the numbers here.

>
> By "core problem is not as bad", I would have been referring to the
> way that failing to garbage collect hashtables in a timely manner can
> lead to rejecting new connections due to lack of available map space.
> Switching back to LRU mitigated this concern. With a reduced frequency

LRU eviction only kicks in when the space is full, which is already too
late. More importantly, with LRU, when an entry becomes "expired"
is nondeterministic, which contradicts the definition of conntrack,
which is time based.

> of running the garbage collection logic, the CPU impact is lower as
> well. I don't think we've explored batched map ops for this use case
> yet either, which would already serve to improve the CPU usage
> situation without extending the kernel.

Sure, if we could let GC run once every year, the amortized CPU
overhead would become literally zero. ;) I am sure this is not what
you really want to suggest.

>
> The main outstanding issue I'm aware of is that we will often have a
> 1:1 mapping of entries in the CT map and the NAT map, and ideally we'd
> like them to have tied fates but currently we have no mechanism to do
> this with LRU. When LRU eviction occurs, the entries can get out of
> sync until the next GC. I could imagine timers helping with this if we
> were to switch back to hash maps since we could handle this problem in
> custom eviction logic, but that would reintroduce the entry management
> problem above. So then we'd still need more work to figure out how to
> address that with a timers approach. If I were to guess right now, the
> right solution for this particular problem is probably associating
> programs with map entry lifecycle events (like LRU eviction) rather
> than adding timers to trigger the logic we want, but that's a whole
> different discussion.

I proposed a timeout hashmap before this ebpf timer, it is Alexei
who suggested abstracting it as a timer, which makes sense to me.
So, I am not sure what you are suggesting here, at least we are not
going back to timeout hashmap or anything similarly tied closely
with a map.

Thanks.
