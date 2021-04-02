Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E6C3530B9
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 23:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234856AbhDBVZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 17:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbhDBVZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 17:25:04 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB78FC0613E6;
        Fri,  2 Apr 2021 14:25:02 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id x21-20020a17090a5315b029012c4a622e4aso3089162pjh.2;
        Fri, 02 Apr 2021 14:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=REnjUaO4dSkHWzrvqClmbcudiU/3/42KFbTsWqJ/3KQ=;
        b=objpJKmcu4+Jsuyj1Wvic//PQJ4qGlkGdZIc6mFKN9NjwxOy0hxh669uA61UpdhT7A
         kQHrf+Ccdp2dNRJrkyeEgnsbNnB3A+m0YwsTdwH3bSr9/ynFTBcOxnU0tSOzLZqX7Ps+
         jRzxT1+tZb1V5t+B1Nb13g62VXJTIdVLDpKKSjiqEeHE1LQcGVgIf5sh3331QSyxB/V7
         VC0qgMPeLZJ1qGZYIoC6LfVmgaYx4oRyRb17JydW+6l97ZM9H/5Q4o+bP8PXOhJHQ/AD
         mHY6nXS9EJtKwDlyMlrCN1E1I9ZAllbzeUyI4snxI88HLabRbJbnYDK0VhyfC6+O3Z4e
         Nzcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=REnjUaO4dSkHWzrvqClmbcudiU/3/42KFbTsWqJ/3KQ=;
        b=i/L/x18HIAie813+ob5+i1kkLr1n6ApYN470z8Ay/ayQTVQXEai8MGMZJbsN/fMUET
         cOljTAFnjDEhGe6bwxAixkqrKKj5NV4csricyVsn4Kxlc0lNUKadJ3xUKHxSI6Hd7SqU
         hWgET/LCkm2aGxkbx0LfVi2kAL9lNGcckbwIkwH14wZYk99GOFYfFicrqb/n2P+2ftWQ
         6HEWvzC1L3ryJLkSxYP2KHKIEacVDznLj9DvQbqXt3V2+9VlNNfWTd76wzVQKCiFR12e
         ax1h4LmF7bwEHQU5+H6/jGvXOza/TPEqfV1ObOC/a+hXBXoHaUApyVV0YbqCHHmCWBiK
         LC0w==
X-Gm-Message-State: AOAM533ezcQLaomBv8gaWbElwcrKt/mMeU4JnDdrm2/Tia8C5TnPYlBJ
        uyw3t/RSNE2TkELqhKtKZUNfChzAYf2MUT/MrrU=
X-Google-Smtp-Source: ABdhPJxpL0dyGrUzK31PXUuQ6+/oDmmqwawzg1sHhFNyEY1lR+MJPdLU7C0P3TRXa3gMk2gS6X3Cjt6H2V+sUNR5qO0=
X-Received: by 2002:a17:90b:514:: with SMTP id r20mr15629029pjz.145.1617398702295;
 Fri, 02 Apr 2021 14:25:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210401042635.19768-1-xiyou.wangcong@gmail.com> <20210402192823.bqwgipmky3xsucs5@ast-mbp>
In-Reply-To: <20210402192823.bqwgipmky3xsucs5@ast-mbp>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 2 Apr 2021 14:24:51 -0700
Message-ID: <CAM_iQpUfv7c19zFN1Y5-cSUiVwpk0bmtBMSxZoELgDOFCQ=qAw@mail.gmail.com>
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

On Fri, Apr 2, 2021 at 12:28 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Mar 31, 2021 at 09:26:35PM -0700, Cong Wang wrote:
>
> > This patch introduces a bpf timer map and a syscall to create bpf timer
> > from user-space.
>
> That will severely limit timer api usability.
> I agree with Song here. If user space has to create it there is no reason
> to introduce new sys_bpf command. Just do all timers in user space
> and trigger bpf prog via bpf_prog_test_run cmd.

I think you misunderstand my point, the reason why the creation is done
in user-space is not I like it, it is because it looks impossible to
create timers
in kernel-space, hence I have to move it to user-space.

>
> >
> > The reason why we have to use a map is because the lifetime of a timer,
> > without a map, we have to delete the timer before exiting the eBPF program,
> > this would significately limit its use cases. With a map, the timer can
> > stay as long as the map itself and can be actually updated via map update
> > API's too,
>
> this part is correct.
>
> > where the key is the timer ID and the value is the timer expire
> > timer.
>
> The timer ID is unnecessary. We cannot introduce new IDR for every new
> bpf object. It doesn't scale.

The IDR is per map, not per timer.

>
> > Timer creation is not easy either. In order to prevent users creating a
> > timer but not adding it to a map, we have to enforce this in the API which
> > takes a map parameter and adds the new timer into the map in one shot.
>
> Not quite true. The timer memory should be a part of the map otherwise
> the timer life time is hard to track. But arming the timer and initializing
> it with a callback doesn't need to be tied with allocation of timer memory.
>
> > And because timer is asynchronous, we can not just use its callback like
> > bpf_for_each_map_elem().
>
> Not quite. We can do it the same way as bpf_for_each_map_elem() despite
> being async.

Well, at least bpf_for_each_map_elem() can use stack variables etc.,
but timers can't. They are very different to me.

>
> > More importantly, we have to properly reference
> > count its struct bpf_prog too.
>
> It's true that callback prog or subprog has to stay alive while timer
> is alive.
> Traditional maps can live past the time of the progs that use them.
> Like bpf prog can load with a pointer to already created hash map.
> Then prog can unload and hashmap will stay around just fine.
> All maps are like this with the exception of prog_array.
> The progs get deleted from the prog_array map when appropriate.
> The same thing can work for maps with embedded timers.
> For example the subprog/prog can to be deleted from the timer if
> that prog is going away. Similar to ref/uref distinction we have for prog_array.
>
> > It seems impossible to do this either in
> > verifier or in JIT, so we have to make its callback code a separate eBPF
> > program and pass a program fd from user-space. Fortunately, timer callback
> > can still live in the same object file with the rest eBPF code and share
> > data too.
> >
> > Here is a quick demo of the timer callback code:
> >
> > static __u64
> > check_expired_elem(struct bpf_map *map, __u32 *key, __u64 *val,
> >                   int *data)
> > {
> >   u64 expires = *val;
> >
> >   if (expires < bpf_jiffies64()) {
> >     bpf_map_delete_elem(map, key);
> >     *data++;
> >   }
> >   return 0;
> > }
> >
> > SEC("timer")
> > u32 timer_callback(void)
> > {
> >   int count = 0;
> >
> >   bpf_for_each_map_elem(&map, check_expired_elem, &count, 0);
> >   if (count)
> >      return 0; // not re-arm this timer
> >   else
> >      return 10; // reschedule this timeGr after 10 jiffies
> > }
>
> As Song pointed out the exact same thing can be done with timers in user space
> and user space triggering prog exec with bpf_prog_test_run.
>
> Here is how more general timers might look like:
> https://lore.kernel.org/bpf/20210310011905.ozz4xahpkqbfkkvd@ast-mbp.dhcp.thefacebook.com/
>
> include/uapi/linux/bpf.h:
> struct bpf_timer {
>   u64 opaque;
> };
> The 'opaque' field contains a pointer to dynamically allocated struct timer_list and other data.

This is my initial design as we already discussed, it does not work,
please see below.

>
> The prog would do:
> struct map_elem {
>     int stuff;
>     struct bpf_timer timer;
> };
>
> struct {
>     __uint(type, BPF_MAP_TYPE_HASH);
>     __uint(max_entries, 1);
>     __type(key, int);
>     __type(value, struct map_elem);
> } hmap SEC(".maps");
>
> static int timer_cb(struct map_elem *elem)
> {
>     if (whatever && elem->stuff)
>         bpf_timer_mod(&elem->timer, new_expire);
> }
>
> int bpf_timer_test(...)
> {
>     struct map_elem *val;
>
>     val = bpf_map_lookup_elem(&hmap, &key);
>     if (val) {
>         bpf_timer_init(&val->timer, timer_cb, flags);
>         val->stuff = 123;
>         bpf_timer_mod(&val->timer, expires);
>     }
> }
>
> bpf_map_update_elem() either from bpf prog or from user space
> allocates map element and zeros 8 byte space for the timer pointer.
> bpf_timer_init() allocates timer_list and stores it into opaque if opaque == 0.
> The validation of timer_cb() is done by the verifier.
> bpf_map_delete_elem() either from bpf prog or from user space
> does del_timer() if elem->opaque != 0.
> If prog refers such hmap as above during prog free the kernel does
> for_each_map_elem {if (elem->opaque) del_timer().}
> I think that is the simplest way of prevent timers firing past the prog life time.
> There could be other ways to solve it (like prog_array and ref/uref).
>
> Pseudo code:
> int bpf_timer_init(struct bpf_timer *timer, void *timer_cb, int flags)
> {
>   if (timer->opaque)
>     return -EBUSY;
>   t = alloc timer_list
>   t->cb = timer_cb;
>   t->..
>   timer->opaque = (long)t;
> }
>
> int bpf_timer_mod(struct bpf_timer *timer, u64 expires)
> {
>   if (!time->opaque)
>     return -EINVAL;
>   t = (struct timer_list *)timer->opaque;
>   mod_timer(t,..);
> }
>
> int bpf_timer_del(struct bpf_timer *timer)
> {
>   if (!time->opaque)
>     return -EINVAL;
>   t = (struct timer_list *)timer->opaque;
>   del_timer(t);
> }
>
> The verifier would need to check that 8 bytes occupied by bpf_timer and not accessed
> via load/store by the program. The same way it does it for bpf_spin_lock.

This does not work, because bpf_timer_del() has to be matched
with bpf_timer_init(), otherwise we would leak timer resources.
For example:

SEC("foo")
bad_ebpf_code()
{
  struct bpf_timer t;
  bpf_timer_init(&t, ...); // allocate a timer
  bpf_timer_mod(&t, ..);
  // end of BPF program
  // now the timer is leaked, no one will delete it
}

We can not enforce the matching in the verifier, because users would
have to call bpf_timer_del() before exiting, which is not what we want
either.

Thanks.
