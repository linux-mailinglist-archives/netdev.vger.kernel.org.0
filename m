Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33CA335D398
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 01:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243068AbhDLXCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 19:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236485AbhDLXCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 19:02:15 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4576C061574;
        Mon, 12 Apr 2021 16:01:56 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id 20so3224520pll.7;
        Mon, 12 Apr 2021 16:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NFjsI6bwmXUQ0SCQBw0blOVsAQQKD/rmVjqwUMs7mW0=;
        b=rrpTJXjjMLLsFPC25oYXZAMD2Hp6nrEWoBjENExN83VkpIRqZb7G9U0rzir1tOcDO1
         oSrnNaQ9rvnPfWvcRPLfbg8A5r2bXjKMrNEpyc7TYxm6/NykiXMbFmW3rm2PI1QhFqAn
         xbQQpYeoSJ9CCnVzed+0/4M3c9FVBHqqji/7peCQ+q9m92Au1/gnbkXou/irIKtnCFiN
         khSe0CBlrd3vgiUoDsbYg9tmb3C6FrycT1GOBfpg4WVXjTOfTJRselVfMlxdXkpRQv29
         g461CwxAt55QBgjomqOJKkHTVEbVb7EFBMlLb1hai5DNjyYpeRntLj9Sriz2knfLFKKt
         rqQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NFjsI6bwmXUQ0SCQBw0blOVsAQQKD/rmVjqwUMs7mW0=;
        b=H5HKTKMFprax//vM3Ye66oxD285PQD431aWpNAC3CeV12lK7Sb1V5faV5QVetavaU4
         Ylysk3skJlmAIt4ej9u5CJL5mEXr3mmFhUuZ5UTP/uqxsVNpbUnD47PvWkUIQWfukwOh
         Lv189ojVz+/J3kbJ73J0yt6rZtCjzy5LzuHYmK+BoU0Vamt/zlTuxawj0wFbJibarpIb
         71CqUGvcvixCLeU3HSxcT3mfZzM36BTcguMG3EJ/DG17VZbJby/DO0NlI0Dh2sYi5t5c
         x/JlTb46ARmQLc2KdryaggNcHWHfj0xQy9rf80tjBMTVUEZwa9m5FkkHMnp1cPYj27q6
         B83A==
X-Gm-Message-State: AOAM531KGR/76f26Scd7YsN52kUL3r4XZDL0kJsejol/6ZlXk/J2rrWL
        FsNKrI6QPlaV7ml0teTwDZsklvuuxRc=
X-Google-Smtp-Source: ABdhPJx7nCzt0K3IRVeTxzsDZhcs0q46vMgbHtEkChuoj06WGAQyS9Bwk0eae0cfG4OnsE1AOXTcdA==
X-Received: by 2002:a17:90b:1b4e:: with SMTP id nv14mr1556718pjb.228.1618268515517;
        Mon, 12 Apr 2021 16:01:55 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:ccf5])
        by smtp.gmail.com with ESMTPSA id k3sm12381425pgq.57.2021.04.12.16.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 16:01:54 -0700 (PDT)
Date:   Mon, 12 Apr 2021 16:01:51 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
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
Subject: Re: [RFC Patch bpf-next] bpf: introduce bpf timer
Message-ID: <20210412230151.763nqvaadrrg77kd@ast-mbp.dhcp.thefacebook.com>
References: <20210401042635.19768-1-xiyou.wangcong@gmail.com>
 <20210402192823.bqwgipmky3xsucs5@ast-mbp>
 <CAM_iQpUfv7c19zFN1Y5-cSUiVwpk0bmtBMSxZoELgDOFCQ=qAw@mail.gmail.com>
 <20210402234500.by3wigegeluy5w7j@ast-mbp>
 <CAM_iQpWf2aYbY=tKejb=nx7LWBLo1woTp-n4wOLhkUuDCz8u-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpWf2aYbY=tKejb=nx7LWBLo1woTp-n4wOLhkUuDCz8u-Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 05, 2021 at 05:36:27PM -0700, Cong Wang wrote:
> On Fri, Apr 2, 2021 at 4:45 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Fri, Apr 02, 2021 at 02:24:51PM -0700, Cong Wang wrote:
> > > > > where the key is the timer ID and the value is the timer expire
> > > > > timer.
> > > >
> > > > The timer ID is unnecessary. We cannot introduce new IDR for every new
> > > > bpf object. It doesn't scale.
> > >
> > > The IDR is per map, not per timer.
> >
> > Per-map is not acceptable. One IDR for all maps with timers is not acceptable either.
> > We have 3 IDRs now: for progs, for maps, and for links.
> > No other objects need IDRs.
> >
> > > > Here is how more general timers might look like:
> > > > https://lore.kernel.org/bpf/20210310011905.ozz4xahpkqbfkkvd@ast-mbp.dhcp.thefacebook.com/
> > > >
> > > > include/uapi/linux/bpf.h:
> > > > struct bpf_timer {
> > > >   u64 opaque;
> > > > };
> > > > The 'opaque' field contains a pointer to dynamically allocated struct timer_list and other data.
> > >
> > > This is my initial design as we already discussed, it does not work,
> > > please see below.
> >
> > It does work. The perceived "issue" you referred to is a misunderstanding. See below.
> >
> > > >
> > > > The prog would do:
> > > > struct map_elem {
> > > >     int stuff;
> > > >     struct bpf_timer timer;
> > > > };
> > > >
> > > > struct {
> > > >     __uint(type, BPF_MAP_TYPE_HASH);
> > > >     __uint(max_entries, 1);
> > > >     __type(key, int);
> > > >     __type(value, struct map_elem);
> > > > } hmap SEC(".maps");
> > > >
> > > > static int timer_cb(struct map_elem *elem)
> > > > {
> > > >     if (whatever && elem->stuff)
> > > >         bpf_timer_mod(&elem->timer, new_expire);
> > > > }
> > > >
> > > > int bpf_timer_test(...)
> > > > {
> > > >     struct map_elem *val;
> > > >
> > > >     val = bpf_map_lookup_elem(&hmap, &key);
> > > >     if (val) {
> > > >         bpf_timer_init(&val->timer, timer_cb, flags);
> > > >         val->stuff = 123;
> > > >         bpf_timer_mod(&val->timer, expires);
> > > >     }
> > > > }
> > > >
> > > > bpf_map_update_elem() either from bpf prog or from user space
> > > > allocates map element and zeros 8 byte space for the timer pointer.
> > > > bpf_timer_init() allocates timer_list and stores it into opaque if opaque == 0.
> > > > The validation of timer_cb() is done by the verifier.
> > > > bpf_map_delete_elem() either from bpf prog or from user space
> > > > does del_timer() if elem->opaque != 0.
> > > > If prog refers such hmap as above during prog free the kernel does
> > > > for_each_map_elem {if (elem->opaque) del_timer().}
> > > > I think that is the simplest way of prevent timers firing past the prog life time.
> > > > There could be other ways to solve it (like prog_array and ref/uref).
> > > >
> > > > Pseudo code:
> > > > int bpf_timer_init(struct bpf_timer *timer, void *timer_cb, int flags)
> > > > {
> > > >   if (timer->opaque)
> > > >     return -EBUSY;
> > > >   t = alloc timer_list
> > > >   t->cb = timer_cb;
> > > >   t->..
> > > >   timer->opaque = (long)t;
> > > > }
> > > >
> > > > int bpf_timer_mod(struct bpf_timer *timer, u64 expires)
> > > > {
> > > >   if (!time->opaque)
> > > >     return -EINVAL;
> > > >   t = (struct timer_list *)timer->opaque;
> > > >   mod_timer(t,..);
> > > > }
> > > >
> > > > int bpf_timer_del(struct bpf_timer *timer)
> > > > {
> > > >   if (!time->opaque)
> > > >     return -EINVAL;
> > > >   t = (struct timer_list *)timer->opaque;
> > > >   del_timer(t);
> > > > }
> > > >
> > > > The verifier would need to check that 8 bytes occupied by bpf_timer and not accessed
> > > > via load/store by the program. The same way it does it for bpf_spin_lock.
> > >
> > > This does not work, because bpf_timer_del() has to be matched
> > > with bpf_timer_init(), otherwise we would leak timer resources.
> > > For example:
> > >
> > > SEC("foo")
> > > bad_ebpf_code()
> > > {
> > >   struct bpf_timer t;
> > >   bpf_timer_init(&t, ...); // allocate a timer
> > >   bpf_timer_mod(&t, ..);
> > >   // end of BPF program
> > >   // now the timer is leaked, no one will delete it
> > > }
> > >
> > > We can not enforce the matching in the verifier, because users would
> > > have to call bpf_timer_del() before exiting, which is not what we want
> > > either.
> >
> > ```
> > bad_ebpf_code()
> > {
> >   struct bpf_timer t;
> > ```
> > is not at all what was proposed. This kind of code will be rejected by the verifier.
> >
> > 'struct bpf_timer' has to be part of the map element and the verifier will enforce that
> > just like it does so for bpf_spin_lock.
> > Try writing the following program:
> > ```
> > bad_ebpf_code()
> > {
> >   struct bpf_spin_lock t;
> >   bpf_spin_lock(&t);
> > }
> > ``
> > and then follow the code to see why the verifier rejects it.
> 
> Well, embedding a spinlock makes sense as it is used to protect
> the value it is associated with, but for a timer, no, it has no value
> to associate. 

The way kernel code is using timers is alwasy by embedding timer_list
into another data structure and then using container_of() in a callback.
So all existing use cases of timers disagree with your point.

> Even if it does, updating it requires a lock as the
> callback can run concurrently with value update. 

No lock is necessary.
map_value_update_elem can either return EBUSY if timer_list != NULL
or it can del_timer() before updating the whole value.
Both choices can be expressed with flags.

> So, they are very
> different hence should be treated differently rather than similarly.
> 
> >
> > The implementation of what I'm proposing is straightforward.
> > I certainly understand that it might look intimidating and "impossible",
> > but it's really quite simple.
> 
> How do you refcnt the struct bpf_prog with your approach? Or with

you don't. More so prog must not be refcnted otherwise it's a circular
dependency between progs and maps.
We did that in the past with prog_array and the api became unpleasant
and not user friendly. Not going to repeat the same mistake again.

> actually any attempt to create timers in kernel-space. I am not intimidated
> but quite happy to hear. If you do it in the verifier, we do not know which
> code path is actually executed when running it. If you do it with JIT, I do
> not see how JIT can even get the right struct bpf_prog pointer in context.

Neither. See pseudo code for bpf_timer_init/bpf_timer_mod in the earlier email.

> This is how I concluded it looks impossible.

Please explain what 'impossible' or buggy you see in the pseudo code.
