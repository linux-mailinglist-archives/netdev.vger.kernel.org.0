Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 738AD360117
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 06:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbhDOEZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 00:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbhDOEZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 00:25:46 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D9BDC061574;
        Wed, 14 Apr 2021 21:25:23 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id r128so9954335lff.4;
        Wed, 14 Apr 2021 21:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r4zzdJ0IxLSyxUwM339lis0IISSEGTGoxgRaj8Zl4Nw=;
        b=il+lXT0/PAFVsHb96xsN4hTcjpwW4rlW8WjMRgMPVP7LBDhgaFsY4LxtFrHqcyMkVp
         iYxZpoi1j8Ue9RaszMqbNxWYaUDuGkSM/6jMQKkLgkmmxxxi16ncUtURqU0weJBqATV8
         ZzgKRM/6Ys/oGXX26Owmqnt3Qt8iVHzNmvpWkxq/cEOypqdPgZ8x03E0H8FRg3UyruFx
         ABx0Xux6J0P92ajl9gz56NrKonoqUxZ6FUz2Tu0Jvcy4oJrZfnT/t4MrlIA62GPA5RBY
         lwZS0FcEjY79N5Kafbf2oHmAlY7selDteP9bzUxUNI7RCA4AH7QTR6x4hs6wNCe/gcNT
         WQFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r4zzdJ0IxLSyxUwM339lis0IISSEGTGoxgRaj8Zl4Nw=;
        b=F1tif7GrkRsymSSUhQaBrZ8aBm/F3buIIZCLIJojMepXpgE+dRzpJh4LC1iRmqrTFw
         l3zbDIAsZm9N/EnzuYXWRQqqm85HbTxh0LYR9YCGzUeQunMojZKBauWTF1pQ55MWJONH
         PeaM0rS0e92I90Ks8JsMFKF6npA5q1r9MtMIOV3oeeydLmSNBnHYZCLF8J36RdkizP8M
         50Sl6at4Nh23yz0JGuTA1ecn1OffeUWu9FEeDojCdf8lc21J5cHbJQsnCTwrY5AoJN2e
         j9c1E9IieUOodrv5G4XbwzL1XH2rzS9vSVD7m5MP7C0wSeLvPk/oR05SFKVKRmSqGMP1
         ogYg==
X-Gm-Message-State: AOAM533ux7EwehrJ2dhAAPYRbkKLRMhjcA/QK6mSSFqMwkV9MRG2/0kO
        d7ktBXswLXe1kaXyQU+vkxCsVymicpR1LDwkX3lBB6DDyHs=
X-Google-Smtp-Source: ABdhPJxS2fxZYkIvMbEd3CY6uvI0RGfv3VSsbXmSs3U9fnuMdRTQFVJ4v+V7UFgAV91K+5lg4HIljqeBDrWgumkWoBE=
X-Received: by 2002:a05:6512:21a5:: with SMTP id c5mr1118532lft.534.1618460721871;
 Wed, 14 Apr 2021 21:25:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210401042635.19768-1-xiyou.wangcong@gmail.com>
 <20210402192823.bqwgipmky3xsucs5@ast-mbp> <CAM_iQpUfv7c19zFN1Y5-cSUiVwpk0bmtBMSxZoELgDOFCQ=qAw@mail.gmail.com>
 <20210402234500.by3wigegeluy5w7j@ast-mbp> <CAM_iQpWf2aYbY=tKejb=nx7LWBLo1woTp-n4wOLhkUuDCz8u-Q@mail.gmail.com>
 <20210412230151.763nqvaadrrg77kd@ast-mbp.dhcp.thefacebook.com> <CAM_iQpWePmmpr0RKqCrQ=NPiGrq2Tx9OU9y3e4CTzFjvh5t47w@mail.gmail.com>
In-Reply-To: <CAM_iQpWePmmpr0RKqCrQ=NPiGrq2Tx9OU9y3e4CTzFjvh5t47w@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 14 Apr 2021 21:25:10 -0700
Message-ID: <CAADnVQLsmULxJYq9rHS4xyg=VAUeexJTh35vTWTVgjeqwX4D6g@mail.gmail.com>
Subject: Re: [RFC Patch bpf-next] bpf: introduce bpf timer
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 9:02 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Mon, Apr 12, 2021 at 4:01 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Mon, Apr 05, 2021 at 05:36:27PM -0700, Cong Wang wrote:
> > > On Fri, Apr 2, 2021 at 4:45 PM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Fri, Apr 02, 2021 at 02:24:51PM -0700, Cong Wang wrote:
> > > > > > > where the key is the timer ID and the value is the timer expire
> > > > > > > timer.
> > > > > >
> > > > > > The timer ID is unnecessary. We cannot introduce new IDR for every new
> > > > > > bpf object. It doesn't scale.
> > > > >
> > > > > The IDR is per map, not per timer.
> > > >
> > > > Per-map is not acceptable. One IDR for all maps with timers is not acceptable either.
> > > > We have 3 IDRs now: for progs, for maps, and for links.
> > > > No other objects need IDRs.
> > > >
> > > > > > Here is how more general timers might look like:
> > > > > > https://lore.kernel.org/bpf/20210310011905.ozz4xahpkqbfkkvd@ast-mbp.dhcp.thefacebook.com/
> > > > > >
> > > > > > include/uapi/linux/bpf.h:
> > > > > > struct bpf_timer {
> > > > > >   u64 opaque;
> > > > > > };
> > > > > > The 'opaque' field contains a pointer to dynamically allocated struct timer_list and other data.
> > > > >
> > > > > This is my initial design as we already discussed, it does not work,
> > > > > please see below.
> > > >
> > > > It does work. The perceived "issue" you referred to is a misunderstanding. See below.
> > > >
> > > > > >
> > > > > > The prog would do:
> > > > > > struct map_elem {
> > > > > >     int stuff;
> > > > > >     struct bpf_timer timer;
> > > > > > };
> > > > > >
> > > > > > struct {
> > > > > >     __uint(type, BPF_MAP_TYPE_HASH);
> > > > > >     __uint(max_entries, 1);
> > > > > >     __type(key, int);
> > > > > >     __type(value, struct map_elem);
> > > > > > } hmap SEC(".maps");
> > > > > >
> > > > > > static int timer_cb(struct map_elem *elem)
> > > > > > {
> > > > > >     if (whatever && elem->stuff)
> > > > > >         bpf_timer_mod(&elem->timer, new_expire);
> > > > > > }
> > > > > >
> > > > > > int bpf_timer_test(...)
> > > > > > {
> > > > > >     struct map_elem *val;
> > > > > >
> > > > > >     val = bpf_map_lookup_elem(&hmap, &key);
> > > > > >     if (val) {
> > > > > >         bpf_timer_init(&val->timer, timer_cb, flags);
> > > > > >         val->stuff = 123;
> > > > > >         bpf_timer_mod(&val->timer, expires);
> > > > > >     }
> > > > > > }
> > > > > >
> > > > > > bpf_map_update_elem() either from bpf prog or from user space
> > > > > > allocates map element and zeros 8 byte space for the timer pointer.
> > > > > > bpf_timer_init() allocates timer_list and stores it into opaque if opaque == 0.
> > > > > > The validation of timer_cb() is done by the verifier.
> > > > > > bpf_map_delete_elem() either from bpf prog or from user space
> > > > > > does del_timer() if elem->opaque != 0.
> > > > > > If prog refers such hmap as above during prog free the kernel does
> > > > > > for_each_map_elem {if (elem->opaque) del_timer().}
> > > > > > I think that is the simplest way of prevent timers firing past the prog life time.
> > > > > > There could be other ways to solve it (like prog_array and ref/uref).
> > > > > >
> > > > > > Pseudo code:
> > > > > > int bpf_timer_init(struct bpf_timer *timer, void *timer_cb, int flags)
> > > > > > {
> > > > > >   if (timer->opaque)
> > > > > >     return -EBUSY;
> > > > > >   t = alloc timer_list
> > > > > >   t->cb = timer_cb;
> > > > > >   t->..
> > > > > >   timer->opaque = (long)t;
> > > > > > }
> > > > > >
> > > > > > int bpf_timer_mod(struct bpf_timer *timer, u64 expires)
> > > > > > {
> > > > > >   if (!time->opaque)
> > > > > >     return -EINVAL;
> > > > > >   t = (struct timer_list *)timer->opaque;
> > > > > >   mod_timer(t,..);
> > > > > > }
> > > > > >
> > > > > > int bpf_timer_del(struct bpf_timer *timer)
> > > > > > {
> > > > > >   if (!time->opaque)
> > > > > >     return -EINVAL;
> > > > > >   t = (struct timer_list *)timer->opaque;
> > > > > >   del_timer(t);
> > > > > > }
> > > > > >
> > > > > > The verifier would need to check that 8 bytes occupied by bpf_timer and not accessed
> > > > > > via load/store by the program. The same way it does it for bpf_spin_lock.
> > > > >
> > > > > This does not work, because bpf_timer_del() has to be matched
> > > > > with bpf_timer_init(), otherwise we would leak timer resources.
> > > > > For example:
> > > > >
> > > > > SEC("foo")
> > > > > bad_ebpf_code()
> > > > > {
> > > > >   struct bpf_timer t;
> > > > >   bpf_timer_init(&t, ...); // allocate a timer
> > > > >   bpf_timer_mod(&t, ..);
> > > > >   // end of BPF program
> > > > >   // now the timer is leaked, no one will delete it
> > > > > }
> > > > >
> > > > > We can not enforce the matching in the verifier, because users would
> > > > > have to call bpf_timer_del() before exiting, which is not what we want
> > > > > either.
> > > >
> > > > ```
> > > > bad_ebpf_code()
> > > > {
> > > >   struct bpf_timer t;
> > > > ```
> > > > is not at all what was proposed. This kind of code will be rejected by the verifier.
> > > >
> > > > 'struct bpf_timer' has to be part of the map element and the verifier will enforce that
> > > > just like it does so for bpf_spin_lock.
> > > > Try writing the following program:
> > > > ```
> > > > bad_ebpf_code()
> > > > {
> > > >   struct bpf_spin_lock t;
> > > >   bpf_spin_lock(&t);
> > > > }
> > > > ``
> > > > and then follow the code to see why the verifier rejects it.
> > >
> > > Well, embedding a spinlock makes sense as it is used to protect
> > > the value it is associated with, but for a timer, no, it has no value
> > > to associate.
> >
> > The way kernel code is using timers is alwasy by embedding timer_list
> > into another data structure and then using container_of() in a callback.
> > So all existing use cases of timers disagree with your point.
>
> Not always. Data can be passed as a global data structure visible to
> timer callback.

global data is racy. That's not an option at all.

> >
> > > Even if it does, updating it requires a lock as the
> > > callback can run concurrently with value update.
> >
> > No lock is necessary.
> > map_value_update_elem can either return EBUSY if timer_list != NULL
> > or it can del_timer() before updating the whole value.
> > Both choices can be expressed with flags.
>
> This sounds problematic, because the hash map is visible to
> users but not the timers associated, hence in user-space users
> just unexpectedly get EBUSY.

As I said earlier:
"
bpf_map_update_elem() either from bpf prog or from user space
allocates map element and zeros 8 byte space for the timer pointer.
"
and also said that EBUSY could be default or non default behavior
expressed with flags passed into update.

> >
> > > So, they are very
> > > different hence should be treated differently rather than similarly.
> > >
> > > >
> > > > The implementation of what I'm proposing is straightforward.
> > > > I certainly understand that it might look intimidating and "impossible",
> > > > but it's really quite simple.
> > >
> > > How do you refcnt the struct bpf_prog with your approach? Or with
> >
> > you don't. More so prog must not be refcnted otherwise it's a circular
> > dependency between progs and maps.
> > We did that in the past with prog_array and the api became unpleasant
> > and not user friendly. Not going to repeat the same mistake again.
>
> Then how do you prevent prog being unloaded when the timer callback
> is still active?

As I said earlier:
"
If prog refers such hmap as above during prog free the kernel does
for_each_map_elem {if (elem->opaque) del_timer().}
"

>
> >
> > > actually any attempt to create timers in kernel-space. I am not intimidated
> > > but quite happy to hear. If you do it in the verifier, we do not know which
> > > code path is actually executed when running it. If you do it with JIT, I do
> > > not see how JIT can even get the right struct bpf_prog pointer in context.
> >
> > Neither. See pseudo code for bpf_timer_init/bpf_timer_mod in the earlier email.
> >
> > > This is how I concluded it looks impossible.
> >
> > Please explain what 'impossible' or buggy you see in the pseudo code.
>
> Your pseudo code never shows how to refcnt the struct bpf_prog, which
> is critical to the bpf timer design.

As I said earlier: nack to refcnt progs.
