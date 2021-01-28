Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE69306B33
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 03:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbhA1Cqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 21:46:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbhA1Cqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 21:46:51 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A55C061574;
        Wed, 27 Jan 2021 18:46:11 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id e18so4533131lja.12;
        Wed, 27 Jan 2021 18:46:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TrqL8fMmc/YuzLkjoUY1WX8ImMuGKrQku2H0kOgVXK8=;
        b=UN+NJtuH55rMzgqCQ+n1FytwSr7tk2GLxxQ2Z2dL0eb0aunqK8U+m6gaIFSAVX78HT
         rzAEie0oZ4FZOIiKH82CKwvXfGh3Q4cZ6M90QJdCLrUE8YhBSAWGnZkrum2boP2KOmtZ
         sltRaAp8z+EDGgs1U/uDAK5TedmDlXUvQsM58j21PFd7XISWxbKm0hQKL+IsR69r5iXG
         Rd+Vf3BwE1pVjeyH6eSiqNWLbqRzaNYtYd5HrGTRN37RwVpXf8q/c3Uyh4jyQ3k22srg
         9h3v3kkgkfm51t8bbLQTtrehs5Et0gdG81Rw3VPZVq0DZU5P6NUl4OtQdfq6RV0TdWKE
         48og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TrqL8fMmc/YuzLkjoUY1WX8ImMuGKrQku2H0kOgVXK8=;
        b=b77STCnb3sttMQN0h28Ed+8iF9irYwQfk3T095SwfLzX2EnO8UGhrrxEzvLUjzjmBU
         WktTSVMCPoZxdV9zKogrddNpzBvO/0n+8m3g2ZDF5WA4zlONwz5xwxnDovWjpcZO6cVB
         4NxQYqcdb22C68zoyl/hAxxfG5bOwQTOCRzYkiatQykFureZ2RlvLQ2ehLgTrIobX7/6
         yH6Ke4blJ/Jazz2rjbZlOE01TxvuA+efP4b7HY5w0GzUSyvjPvf7rgN2t7IJlp9UF1l5
         kI5EpLMbxRa/pCc3NUec5BpMoYOWK9igFTvcB0tLXWvsSshgRHk7kpQV9JVbweZtpKgI
         pszw==
X-Gm-Message-State: AOAM531d10rekcfq6m6SA4ceaxW8qZEEMl6BG1T68+hzor08W3xMZbem
        9wAzax+0cQY/w/qg9DbnnnPkX+xTJL2+KhICWxI=
X-Google-Smtp-Source: ABdhPJzIQqUaQ+XSqOhgdWdfBgfCvFsGd5UfFsYXCkSxVHxlPEgF+7tDHYQQfsZ5eTwhWxN/sTMkCna73rtCWIcCrEg=
X-Received: by 2002:a2e:54d:: with SMTP id 74mr6881989ljf.44.1611801969818;
 Wed, 27 Jan 2021 18:46:09 -0800 (PST)
MIME-Version: 1.0
References: <20210122205415.113822-1-xiyou.wangcong@gmail.com>
 <20210122205415.113822-2-xiyou.wangcong@gmail.com> <d69d44ca-206c-d818-1177-c8f14d8be8d1@iogearbox.net>
 <CAM_iQpW8aeh190G=KVA9UEZ_6+UfenQxgPXuw784oxCaMfXjng@mail.gmail.com>
 <CAADnVQKmNiHj8qy1yqbOrf-OMyhnn8fKm87w6YMfkiDHkBpJVg@mail.gmail.com> <b646c7b5-be91-79c6-4538-e41a10d4b9ae@iogearbox.net>
In-Reply-To: <b646c7b5-be91-79c6-4538-e41a10d4b9ae@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 27 Jan 2021 18:45:58 -0800
Message-ID: <CAADnVQLB_+MS7EB9GbONV_DXdFP8AdQsjqEhxOEDRHfCmUp+wg@mail.gmail.com>
Subject: Re: [Patch bpf-next v5 1/3] bpf: introduce timeout hash map
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 2:48 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 1/27/21 7:00 PM, Alexei Starovoitov wrote:
> > On Tue, Jan 26, 2021 at 11:00 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >>>>                ret = PTR_ERR(l_new);
> >>>> +             if (ret == -EAGAIN) {
> >>>> +                     htab_unlock_bucket(htab, b, hash, flags);
> >>>> +                     htab_gc_elem(htab, l_old);
> >>>> +                     mod_delayed_work(system_unbound_wq, &htab->gc_work, 0);
> >>>> +                     goto again;
> >>>
> >>> Also this one looks rather worrying, so the BPF prog is stalled here, loop-waiting
> >>> in (e.g. XDP) hot path for system_unbound_wq to kick in to make forward progress?
> >>
> >> In this case, the old one is scheduled for removal in GC, we just wait for GC
> >> to finally remove it. It won't stall unless GC itself or the worker scheduler is
> >> wrong, both of which should be kernel bugs.
> >>
> >> If we don't do this, users would get a -E2BIG when it is not too big. I don't
> >> know a better way to handle this sad situation, maybe returning -EBUSY
> >> to users and let them call again?
> >
> > I think using wq for timers is a non-starter.
> > Tying a hash/lru map with a timer is not a good idea either.
>
> Thinking some more, given we have jiffies64 helper and atomic ops for BPF by now,
> we would technically only need the ability to delete entries via bpf iter progs
> (d6c4503cc296 ("bpf: Implement bpf iterator for hash maps")) which could then be
> kicked off from user space at e.g. dynamic intervals which would be the equivalent
> for the wq in here. That patch could then be implemented this way. I presume
> the ability to delete map entries from bpf iter progs would be generic and useful
> enough anyway.

I think bpf_iter for maps doesn't hold bucket lock anymore, so delete of the
same element should be allowed already. Unless I've mistaken wip patches
with landed ones.
Soon there will be support for bpf_map_for_each_elem() iterator
running from the bpf program itself, so even more ways to do GC like work.

> > I think timers have to be done as independent objects similar to
> > how the kernel uses them.
> > Then there will be no question whether lru or hash map needs it.
> > The bpf prog author will be able to use timers with either.
> > The prog will be able to use timers without hash maps too.
> >
> > I'm proposing a timer map where each object will go through
> > bpf_timer_setup(timer, callback, flags);
> > where "callback" is a bpf subprogram.
> > Corresponding bpf_del_timer and bpf_mod_timer would work the same way
> > they are in the kernel.
> > The tricky part is kernel style of using from_timer() to access the
> > object with additional info.
>
> Would this mean N timer objs for N map elems? I presume not given this could be
> racy and would have huge extra mem overhead.

hmm. Not sure I got the point about overhead.
sizeof(struct timer_list) == 40 bytes.
Not a lot of overhead even if there is a timer object per flow.
When bpf_map_for_each_elem() lands the bpf prog could have one
timer that will kick one a second (or whatever GC period the prog author wants)
and does bpf_map_for_each_elem() once callback fires to delete elems
older than whatever interval the prog needs.
imo that would be a true generic way to combine
bpf_maps, bpf_iters and bpf_timers.

> Either way, timer obj could work, but
> then at the same time you could probably also solve it with the above; it's not
> like you need the timer to kick in at some /exact/ time, but rather at some point
> to clean up stale entries before the map gets full and worst case refuses updates
> for new entries. (In the ideal case though we wouldn't need the extra effort to
> search deeply for elements w/o penalizing the fast-path lookup costs too much when
> walking the bucket.)

Right. I wasn't suggesting to mess with the timer object at every lookup.
My understanding that mod_timer() isn't that fast to call a million
times a second.
bpf progs would have to be smart.

Instead of timer objects as a timer map (a collection of timers that
bpf progs can manipulate)
we can introduce them similar to "struct bpf_spin_lock".
Then "struct bpf_timer foo;" field can be embedded inside any map value
(both hash and array). The verifier work would be a bit trickier than
support for bpf_spin_lock,
but certainly doable.

My main point was that bpf should grow with small composable
building blocks instead of single purpose constructs.
I view hashmap+GC as an example of something that should be split
into smaller blocks.
