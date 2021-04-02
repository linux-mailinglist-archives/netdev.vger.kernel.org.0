Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 147AD352FC2
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 21:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236555AbhDBT2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 15:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235392AbhDBT23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 15:28:29 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC43C0613E6;
        Fri,  2 Apr 2021 12:28:27 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id x126so4131313pfc.13;
        Fri, 02 Apr 2021 12:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qzxHzGuLfubJaD1BeP2oz9tkIUBEYknTaCVf5njFEWo=;
        b=OJRWPZ5w7FNuCzY77omt+HggTbeJZP5z8Z/FCCwcE0MCEMx8mQY4m047Fbnm774bv0
         Jzr4cW2BQUSBW5Nw0q1R6D5L2npHtux+bRDHj7dLXMIzfFTjc4oAckUCS6mHJiqCJb1/
         8rRy/CMHCTRiQllYJcE5sf+oVdgobiPnyLMqUsDyBWIfZ04uZQ9mSGgIleZ+dG9c1LGB
         7eRMckpoy+l/iznz19BwqNbJE5X4R4fOlXMwBPPUZW98wUoea2yH0Qk9OYFaaTECLij4
         PFh7R4pt9G5lhd2Yl9lF5/K9KI6EoNKJGuOp+fsRZwscs/6vqod7BZy0p5exHG47XT9E
         iCSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qzxHzGuLfubJaD1BeP2oz9tkIUBEYknTaCVf5njFEWo=;
        b=Ba7wFl3DF8QEppmhh8EUZ6M9GZe+I0X2fwzg2iorRbcB5y03TcTxCd0cBdGgRwzVhL
         yfdTZht4KUmBE2puUHdeeGKFd7eiUXgx9udQHngDRnR398TiZAcTedUm61z34+1AAKBS
         xMJlHI2nRMVOl+YUWQKy1if3ES3gEMwQc9O11qbaY7jhWxPueqzywO9dST3M5xhk+Ft/
         AQPPOeYrpiSDFkUf8TOXqA4bxLpYdwg5K7Sqg8lkA2VFGUXye/lhY9iIT7at+49+SZrt
         NKtnGXeTLs1Mfn36EyKMF9a+l8mGdwlfw1kkPWO3xJT66NusKB9WDCwR5NQVTbAAwhsV
         z9hw==
X-Gm-Message-State: AOAM532RBzV4P3zTeYTY0FiHSchgoY8C1x3HWYlyB66/5mr91sV5jdSB
        s4lCNysyXvnf+Kywka6Xdxo=
X-Google-Smtp-Source: ABdhPJx4PjfkPbyc7P3i/GmC1X1a249mZSMk4ThiPFU/NO/Esr67XP+zgLRidqRR23aNWoP1UTBG6A==
X-Received: by 2002:a63:f258:: with SMTP id d24mr12901593pgk.174.1617391706601;
        Fri, 02 Apr 2021 12:28:26 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:f671])
        by smtp.gmail.com with ESMTPSA id t12sm8997127pga.85.2021.04.02.12.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 12:28:26 -0700 (PDT)
Date:   Fri, 2 Apr 2021 12:28:23 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        songmuchun@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Subject: Re: [RFC Patch bpf-next] bpf: introduce bpf timer
Message-ID: <20210402192823.bqwgipmky3xsucs5@ast-mbp>
References: <20210401042635.19768-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210401042635.19768-1-xiyou.wangcong@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 09:26:35PM -0700, Cong Wang wrote:

> This patch introduces a bpf timer map and a syscall to create bpf timer
> from user-space.

That will severely limit timer api usability.
I agree with Song here. If user space has to create it there is no reason
to introduce new sys_bpf command. Just do all timers in user space
and trigger bpf prog via bpf_prog_test_run cmd.

> 
> The reason why we have to use a map is because the lifetime of a timer,
> without a map, we have to delete the timer before exiting the eBPF program,
> this would significately limit its use cases. With a map, the timer can
> stay as long as the map itself and can be actually updated via map update
> API's too,

this part is correct.

> where the key is the timer ID and the value is the timer expire
> timer.

The timer ID is unnecessary. We cannot introduce new IDR for every new
bpf object. It doesn't scale.

> Timer creation is not easy either. In order to prevent users creating a
> timer but not adding it to a map, we have to enforce this in the API which
> takes a map parameter and adds the new timer into the map in one shot.

Not quite true. The timer memory should be a part of the map otherwise
the timer life time is hard to track. But arming the timer and initializing
it with a callback doesn't need to be tied with allocation of timer memory.

> And because timer is asynchronous, we can not just use its callback like
> bpf_for_each_map_elem().

Not quite. We can do it the same way as bpf_for_each_map_elem() despite
being async.

> More importantly, we have to properly reference
> count its struct bpf_prog too. 

It's true that callback prog or subprog has to stay alive while timer
is alive.
Traditional maps can live past the time of the progs that use them.
Like bpf prog can load with a pointer to already created hash map.
Then prog can unload and hashmap will stay around just fine.
All maps are like this with the exception of prog_array.
The progs get deleted from the prog_array map when appropriate.
The same thing can work for maps with embedded timers.
For example the subprog/prog can to be deleted from the timer if
that prog is going away. Similar to ref/uref distinction we have for prog_array.

> It seems impossible to do this either in
> verifier or in JIT, so we have to make its callback code a separate eBPF
> program and pass a program fd from user-space. Fortunately, timer callback
> can still live in the same object file with the rest eBPF code and share
> data too.
> 
> Here is a quick demo of the timer callback code:
> 
> static __u64
> check_expired_elem(struct bpf_map *map, __u32 *key, __u64 *val,
>                   int *data)
> {
>   u64 expires = *val;
> 
>   if (expires < bpf_jiffies64()) {
>     bpf_map_delete_elem(map, key);
>     *data++;
>   }
>   return 0;
> }
> 
> SEC("timer")
> u32 timer_callback(void)
> {
>   int count = 0;
> 
>   bpf_for_each_map_elem(&map, check_expired_elem, &count, 0);
>   if (count)
>      return 0; // not re-arm this timer
>   else
>      return 10; // reschedule this timeGr after 10 jiffies
> }

As Song pointed out the exact same thing can be done with timers in user space
and user space triggering prog exec with bpf_prog_test_run.

Here is how more general timers might look like:
https://lore.kernel.org/bpf/20210310011905.ozz4xahpkqbfkkvd@ast-mbp.dhcp.thefacebook.com/

include/uapi/linux/bpf.h:
struct bpf_timer {
  u64 opaque;
};
The 'opaque' field contains a pointer to dynamically allocated struct timer_list and other data.

The prog would do:
struct map_elem {
    int stuff;
    struct bpf_timer timer;
};

struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(max_entries, 1);
    __type(key, int);
    __type(value, struct map_elem);
} hmap SEC(".maps");

static int timer_cb(struct map_elem *elem)
{
    if (whatever && elem->stuff)
        bpf_timer_mod(&elem->timer, new_expire);
}

int bpf_timer_test(...)
{
    struct map_elem *val;

    val = bpf_map_lookup_elem(&hmap, &key);
    if (val) {
        bpf_timer_init(&val->timer, timer_cb, flags);
        val->stuff = 123;
        bpf_timer_mod(&val->timer, expires);
    }
}

bpf_map_update_elem() either from bpf prog or from user space
allocates map element and zeros 8 byte space for the timer pointer.
bpf_timer_init() allocates timer_list and stores it into opaque if opaque == 0.
The validation of timer_cb() is done by the verifier.
bpf_map_delete_elem() either from bpf prog or from user space
does del_timer() if elem->opaque != 0.
If prog refers such hmap as above during prog free the kernel does
for_each_map_elem {if (elem->opaque) del_timer().}
I think that is the simplest way of prevent timers firing past the prog life time.
There could be other ways to solve it (like prog_array and ref/uref).

Pseudo code:
int bpf_timer_init(struct bpf_timer *timer, void *timer_cb, int flags)
{
  if (timer->opaque)
    return -EBUSY;
  t = alloc timer_list
  t->cb = timer_cb;
  t->..
  timer->opaque = (long)t;
}

int bpf_timer_mod(struct bpf_timer *timer, u64 expires)
{
  if (!time->opaque)
    return -EINVAL;
  t = (struct timer_list *)timer->opaque;
  mod_timer(t,..);
}

int bpf_timer_del(struct bpf_timer *timer)
{
  if (!time->opaque)
    return -EINVAL;
  t = (struct timer_list *)timer->opaque;
  del_timer(t);
}

The verifier would need to check that 8 bytes occupied by bpf_timer and not accessed
via load/store by the program. The same way it does it for bpf_spin_lock.
