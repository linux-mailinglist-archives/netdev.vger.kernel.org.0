Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F4F3549BC
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 02:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243016AbhDFAgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 20:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbhDFAgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 20:36:47 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34394C06174A;
        Mon,  5 Apr 2021 17:36:39 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id k23-20020a17090a5917b02901043e35ad4aso8696286pji.3;
        Mon, 05 Apr 2021 17:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nA4Gk67lHxGswabHyvFqI1FIav8jh1nEwYKQXOMUqOY=;
        b=gqrG0HUp9MvDKwKHgfpyEvbdET3KUFu38u4x1DSgcQA4aJKlrjZlz7VspjNQiy/WpX
         SreB6/mNOCURMnh1v64xiUzrqaz+2fZFnjKQOskON6hVgzK2HiJfuV87/QNPxvKHCGB/
         2t/iIHcDpwN/1hPLbeS/BdGhwoqPeadvVnvd2gE8aGYHTfS2FfhZ96S0CqEWbUxxpaN4
         7z1jiXopCMWGrIKyLJW6C9uoNspzMCqhtkL1FmHhnlAGp7uZ0QoxNVitZoSvBaX/ZwYM
         TDjKZVEx3i/BITBPreTWY/tS2Q6czfsxaJ5SWbKHPwNRzcCs1Vwdz+wnlfy0+bYJX12B
         ySqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nA4Gk67lHxGswabHyvFqI1FIav8jh1nEwYKQXOMUqOY=;
        b=rVkT8iRlMpeT+SKbnhpATVm8JJwz/BmkxRGYNLvGDUh8GbIBJUPicBY/8YFE8tamfP
         jNs90uwa9nem+FNlf+zIjqCem3O4UEWZdlOYRGo8xCB/tHgp0qs0A/as7FkELuDF21FU
         glcRRHeZZnU2YX8NAF28xWQJNddxFaJptsipbzg+5AuiyvIE/R0XxIiVO0qQmPQb45Ta
         CBpMPtceLkqviJU21ldc9UxXhG2DszhK1yCPFODygDt2UhLYzWELc8cWrEW1a1mynBC8
         X5Q+SAy1O3ynlkfYWu4gdirJHRgU5uqRmDdDEArHJOSyGM/Tgm5IFLA8uVSJS2PbwNsP
         iDpw==
X-Gm-Message-State: AOAM5311qixyjmJjrfjxOpXiItlMJuAvgY4edy7SrVLMeCBh6vwA7j7e
        lf96+r9LLgGckBbaHQp1v3k7y/BDENwzuelpe7F1AnBsFIcaZg==
X-Google-Smtp-Source: ABdhPJxdWOo2LrQgIM4goLWshuJiLw5QGMElzY/8LhssX47+FEwq5yNyoyMWo4x+BWhg2UhX1LwS1f2fmwp7yxkfUGg=
X-Received: by 2002:a17:90a:9f0b:: with SMTP id n11mr1770654pjp.56.1617669398775;
 Mon, 05 Apr 2021 17:36:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210401042635.19768-1-xiyou.wangcong@gmail.com>
 <20210402192823.bqwgipmky3xsucs5@ast-mbp> <CAM_iQpUfv7c19zFN1Y5-cSUiVwpk0bmtBMSxZoELgDOFCQ=qAw@mail.gmail.com>
 <20210402234500.by3wigegeluy5w7j@ast-mbp>
In-Reply-To: <20210402234500.by3wigegeluy5w7j@ast-mbp>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 5 Apr 2021 17:36:27 -0700
Message-ID: <CAM_iQpWf2aYbY=tKejb=nx7LWBLo1woTp-n4wOLhkUuDCz8u-Q@mail.gmail.com>
Subject: Re: [RFC Patch bpf-next] bpf: introduce bpf timer
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 2, 2021 at 4:45 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Apr 02, 2021 at 02:24:51PM -0700, Cong Wang wrote:
> > > > where the key is the timer ID and the value is the timer expire
> > > > timer.
> > >
> > > The timer ID is unnecessary. We cannot introduce new IDR for every new
> > > bpf object. It doesn't scale.
> >
> > The IDR is per map, not per timer.
>
> Per-map is not acceptable. One IDR for all maps with timers is not acceptable either.
> We have 3 IDRs now: for progs, for maps, and for links.
> No other objects need IDRs.
>
> > > Here is how more general timers might look like:
> > > https://lore.kernel.org/bpf/20210310011905.ozz4xahpkqbfkkvd@ast-mbp.dhcp.thefacebook.com/
> > >
> > > include/uapi/linux/bpf.h:
> > > struct bpf_timer {
> > >   u64 opaque;
> > > };
> > > The 'opaque' field contains a pointer to dynamically allocated struct timer_list and other data.
> >
> > This is my initial design as we already discussed, it does not work,
> > please see below.
>
> It does work. The perceived "issue" you referred to is a misunderstanding. See below.
>
> > >
> > > The prog would do:
> > > struct map_elem {
> > >     int stuff;
> > >     struct bpf_timer timer;
> > > };
> > >
> > > struct {
> > >     __uint(type, BPF_MAP_TYPE_HASH);
> > >     __uint(max_entries, 1);
> > >     __type(key, int);
> > >     __type(value, struct map_elem);
> > > } hmap SEC(".maps");
> > >
> > > static int timer_cb(struct map_elem *elem)
> > > {
> > >     if (whatever && elem->stuff)
> > >         bpf_timer_mod(&elem->timer, new_expire);
> > > }
> > >
> > > int bpf_timer_test(...)
> > > {
> > >     struct map_elem *val;
> > >
> > >     val = bpf_map_lookup_elem(&hmap, &key);
> > >     if (val) {
> > >         bpf_timer_init(&val->timer, timer_cb, flags);
> > >         val->stuff = 123;
> > >         bpf_timer_mod(&val->timer, expires);
> > >     }
> > > }
> > >
> > > bpf_map_update_elem() either from bpf prog or from user space
> > > allocates map element and zeros 8 byte space for the timer pointer.
> > > bpf_timer_init() allocates timer_list and stores it into opaque if opaque == 0.
> > > The validation of timer_cb() is done by the verifier.
> > > bpf_map_delete_elem() either from bpf prog or from user space
> > > does del_timer() if elem->opaque != 0.
> > > If prog refers such hmap as above during prog free the kernel does
> > > for_each_map_elem {if (elem->opaque) del_timer().}
> > > I think that is the simplest way of prevent timers firing past the prog life time.
> > > There could be other ways to solve it (like prog_array and ref/uref).
> > >
> > > Pseudo code:
> > > int bpf_timer_init(struct bpf_timer *timer, void *timer_cb, int flags)
> > > {
> > >   if (timer->opaque)
> > >     return -EBUSY;
> > >   t = alloc timer_list
> > >   t->cb = timer_cb;
> > >   t->..
> > >   timer->opaque = (long)t;
> > > }
> > >
> > > int bpf_timer_mod(struct bpf_timer *timer, u64 expires)
> > > {
> > >   if (!time->opaque)
> > >     return -EINVAL;
> > >   t = (struct timer_list *)timer->opaque;
> > >   mod_timer(t,..);
> > > }
> > >
> > > int bpf_timer_del(struct bpf_timer *timer)
> > > {
> > >   if (!time->opaque)
> > >     return -EINVAL;
> > >   t = (struct timer_list *)timer->opaque;
> > >   del_timer(t);
> > > }
> > >
> > > The verifier would need to check that 8 bytes occupied by bpf_timer and not accessed
> > > via load/store by the program. The same way it does it for bpf_spin_lock.
> >
> > This does not work, because bpf_timer_del() has to be matched
> > with bpf_timer_init(), otherwise we would leak timer resources.
> > For example:
> >
> > SEC("foo")
> > bad_ebpf_code()
> > {
> >   struct bpf_timer t;
> >   bpf_timer_init(&t, ...); // allocate a timer
> >   bpf_timer_mod(&t, ..);
> >   // end of BPF program
> >   // now the timer is leaked, no one will delete it
> > }
> >
> > We can not enforce the matching in the verifier, because users would
> > have to call bpf_timer_del() before exiting, which is not what we want
> > either.
>
> ```
> bad_ebpf_code()
> {
>   struct bpf_timer t;
> ```
> is not at all what was proposed. This kind of code will be rejected by the verifier.
>
> 'struct bpf_timer' has to be part of the map element and the verifier will enforce that
> just like it does so for bpf_spin_lock.
> Try writing the following program:
> ```
> bad_ebpf_code()
> {
>   struct bpf_spin_lock t;
>   bpf_spin_lock(&t);
> }
> ``
> and then follow the code to see why the verifier rejects it.

Well, embedding a spinlock makes sense as it is used to protect
the value it is associated with, but for a timer, no, it has no value
to associate. Even if it does, updating it requires a lock as the
callback can run concurrently with value update. So, they are very
different hence should be treated differently rather than similarly.

>
> The implementation of what I'm proposing is straightforward.
> I certainly understand that it might look intimidating and "impossible",
> but it's really quite simple.

How do you refcnt the struct bpf_prog with your approach? Or with
actually any attempt to create timers in kernel-space. I am not intimidated
but quite happy to hear. If you do it in the verifier, we do not know which
code path is actually executed when running it. If you do it with JIT, I do
not see how JIT can even get the right struct bpf_prog pointer in context.

This is how I concluded it looks impossible, which has nothing to do
with whether we have a map or not. Map issue is much easier to solve,
whether using what you mentioned or what I showed.

Thanks.
