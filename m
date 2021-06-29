Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 910E13B6E49
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 08:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232041AbhF2GhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 02:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231881AbhF2GhO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 02:37:14 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF932C061574;
        Mon, 28 Jun 2021 23:34:47 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id o139so14697683ybg.9;
        Mon, 28 Jun 2021 23:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XMjNfG7HCmhIg2XdFhVdhog2BoQPzw8oK2UVjh5idtg=;
        b=P/W1yE0a2J8eo3mrLNqdLTEBDO41VD4AE7fdWusiHVEc2BzfoHbi0Ibiid2hA7hL20
         O27TRR7AtWIlboTK924llxsHeMjko7G/oW9EjKACD02fiRNosZ2Tn4iJXOHnUWBUzqe+
         WxxEGKbyahKUQc9s0OclHDJtKYmhIGSd7EuN6d3X+QwwmFr6wJSejrtUT0OvnIZMiWYJ
         bMqvyUGkEP6Z0QBkzxqHwo5eBI3Xio/AC6ilJ3XC0zh2k2v88026lpW5bFIIHfkV+cA6
         Jm+UNi49wQoP65U5/OHWNdiH86pxZwHXRyVI6cpT3PS90SIgnE5vYWh8prCWyAKMdIPD
         gMQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XMjNfG7HCmhIg2XdFhVdhog2BoQPzw8oK2UVjh5idtg=;
        b=J+UsERyi1+cEDT1JHmwYfIA9svC1UCxGLAO6Acfg0DciOctb4K21vo/Boj8nxt+Ey8
         FV1MtIVaEG0XtnugptdstJu6mcW7HPpSeF+WLGnv6V/Tpva0pGgw+A25esytiPqzCd0Y
         SZnZgSMC+Hi/NdXH8jg7vA62jvDIFbCgmK6IrWwzWI5mM5Q6imi22VkygjJbC6I9QaB6
         PRjVpJlGxkksJuS3esC3pbWofNq8Ysn8nhYX9VWu9lqX5Jd6HqPCSuWfRv/hLLX5CdKU
         RFWtD0JmZvg4ksEJaID1GEZdpPr4WWmjxZBHfb8e6O8gPNsxOfZ/2vDLAGpsu+82WiC3
         E55Q==
X-Gm-Message-State: AOAM531EPbFDm+vohp2xCP4tMmE/ZgtDdwV3btIjF9ByI+jhyXYKQLrz
        LcMQ3gJu+9SjjI9zESosqtgFq4TUg9lJxvvv5uc=
X-Google-Smtp-Source: ABdhPJyDBQ95l7vySFhoeCjLmdaSRe6SrVMaofp9ZmVZoqkB66iEa+i1bIgKxRRY1IQ44B2NDp2GNR+DTl1LRmpKAK8=
X-Received: by 2002:a5b:701:: with SMTP id g1mr21355958ybq.459.1624948486728;
 Mon, 28 Jun 2021 23:34:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210624022518.57875-1-alexei.starovoitov@gmail.com>
 <20210624022518.57875-2-alexei.starovoitov@gmail.com> <fd30895e-475f-c78a-d367-2abdf835c9ef@fb.com>
 <20210629014607.fz5tkewb6n3u6pvr@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210629014607.fz5tkewb6n3u6pvr@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 29 Jun 2021 09:34:36 +0300
Message-ID: <CAEf4BzaPPDEUvsx51mEpp_vJoXVwJQrLu5QnL4pSnL9YAPXevw@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 1/8] bpf: Introduce bpf timers.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 29, 2021 at 4:46 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Jun 25, 2021 at 09:54:11AM -0700, Yonghong Song wrote:
> >
> >
> > On 6/23/21 7:25 PM, Alexei Starovoitov wrote:
> > > From: Alexei Starovoitov <ast@kernel.org>
> > >
> > > Introduce 'struct bpf_timer { __u64 :64; __u64 :64; };' that can be embedded
> > > in hash/array/lru maps as a regular field and helpers to operate on it:
> > >
> > > // Initialize the timer.
> > > // First 4 bits of 'flags' specify clockid.
> > > // Only CLOCK_MONOTONIC, CLOCK_REALTIME, CLOCK_BOOTTIME are allowed.
> > > long bpf_timer_init(struct bpf_timer *timer, int flags);
> > >
> > > // Arm the timer to call callback_fn static function and set its
> > > // expiration 'nsec' nanoseconds from the current time.
> > > long bpf_timer_start(struct bpf_timer *timer, void *callback_fn, u64 nsec);
> > >
> > > // Cancel the timer and wait for callback_fn to finish if it was running.
> > > long bpf_timer_cancel(struct bpf_timer *timer);
> > >
> > > Here is how BPF program might look like:
> > > struct map_elem {
> > >      int counter;
> > >      struct bpf_timer timer;
> > > };
> > >
> > > struct {
> > >      __uint(type, BPF_MAP_TYPE_HASH);
> > >      __uint(max_entries, 1000);
> > >      __type(key, int);
> > >      __type(value, struct map_elem);
> > > } hmap SEC(".maps");
> > >
> > > static int timer_cb(void *map, int *key, struct map_elem *val);
> > > /* val points to particular map element that contains bpf_timer. */
> > >
> > > SEC("fentry/bpf_fentry_test1")
> > > int BPF_PROG(test1, int a)
> > > {
> > >      struct map_elem *val;
> > >      int key = 0;
> > >
> > >      val = bpf_map_lookup_elem(&hmap, &key);
> > >      if (val) {
> > >          bpf_timer_init(&val->timer, CLOCK_REALTIME);
> > >          bpf_timer_start(&val->timer, timer_cb, 1000 /* call timer_cb2 in 1 usec */);
> > >      }
> > > }
> > >
> > > This patch adds helper implementations that rely on hrtimers
> > > to call bpf functions as timers expire.
> > > The following patches add necessary safety checks.
> > >
> > > Only programs with CAP_BPF are allowed to use bpf_timer.
> > >
> > > The amount of timers used by the program is constrained by
> > > the memcg recorded at map creation time.
> > >
> > > The bpf_timer_init() helper is receiving hidden 'map' argument and
> > > bpf_timer_start() is receiving hidden 'prog' argument supplied by the verifier.
> > > The prog pointer is needed to do refcnting of bpf program to make sure that
> > > program doesn't get freed while the timer is armed. This apporach relies on
> > > "user refcnt" scheme used in prog_array that stores bpf programs for
> > > bpf_tail_call. The bpf_timer_start() will increment the prog refcnt which is
> > > paired with bpf_timer_cancel() that will drop the prog refcnt. The
> > > ops->map_release_uref is responsible for cancelling the timers and dropping
> > > prog refcnt when user space reference to a map reaches zero.
> > > This uref approach is done to make sure that Ctrl-C of user space process will
> > > not leave timers running forever unless the user space explicitly pinned a map
> > > that contained timers in bpffs.
> > >
> > > The bpf_map_delete_elem() and bpf_map_update_elem() operations cancel
> > > and free the timer if given map element had it allocated.
> > > "bpftool map update" command can be used to cancel timers.
> > >
> > > The 'struct bpf_timer' is explicitly __attribute__((aligned(8))) because
> > > '__u64 :64' has 1 byte alignment of 8 byte padding.
> > >
> > > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > > ---
> > >   include/linux/bpf.h            |   3 +
> > >   include/uapi/linux/bpf.h       |  55 +++++++
> > >   kernel/bpf/helpers.c           | 281 +++++++++++++++++++++++++++++++++
> > >   kernel/bpf/verifier.c          | 138 ++++++++++++++++
> > >   kernel/trace/bpf_trace.c       |   2 +-
> > >   scripts/bpf_doc.py             |   2 +
> > >   tools/include/uapi/linux/bpf.h |  55 +++++++
> > >   7 files changed, 535 insertions(+), 1 deletion(-)
> > >
> > [...]
> > > @@ -12533,6 +12607,70 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
> > >                     continue;
> > >             }
> > > +           if (insn->imm == BPF_FUNC_timer_init) {
> > > +                   aux = &env->insn_aux_data[i + delta];
> > > +                   if (bpf_map_ptr_poisoned(aux)) {
> > > +                           verbose(env, "bpf_timer_init abusing map_ptr\n");
> > > +                           return -EINVAL;
> > > +                   }
> > > +                   map_ptr = BPF_MAP_PTR(aux->map_ptr_state);
> > > +                   {
> > > +                           struct bpf_insn ld_addrs[2] = {
> > > +                                   BPF_LD_IMM64(BPF_REG_3, (long)map_ptr),
> > > +                           };
> > > +
> > > +                           insn_buf[0] = ld_addrs[0];
> > > +                           insn_buf[1] = ld_addrs[1];
> > > +                   }
> > > +                   insn_buf[2] = *insn;
> > > +                   cnt = 3;
> > > +
> > > +                   new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, cnt);
> > > +                   if (!new_prog)
> > > +                           return -ENOMEM;
> > > +
> > > +                   delta    += cnt - 1;
> > > +                   env->prog = prog = new_prog;
> > > +                   insn      = new_prog->insnsi + i + delta;
> > > +                   goto patch_call_imm;
> > > +           }
> > > +
> > > +           if (insn->imm == BPF_FUNC_timer_start) {
> > > +                   /* There is no need to do:
> > > +                    *     aux = &env->insn_aux_data[i + delta];
> > > +                    *     if (bpf_map_ptr_poisoned(aux)) return -EINVAL;
> > > +                    * for bpf_timer_start(). If the same callback_fn is shared
> > > +                    * by different timers in different maps the poisoned check
> > > +                    * will return false positive.
> > > +                    *
> > > +                    * The verifier will process callback_fn as many times as necessary
> > > +                    * with different maps and the register states prepared by
> > > +                    * set_timer_start_callback_state will be accurate.
> > > +                    *
> > > +                    * There is no need for bpf_timer_start() to check in the
> > > +                    * run-time that bpf_hrtimer->map stored during bpf_timer_init()
> > > +                    * is the same map as in bpf_timer_start()
> > > +                    * because it's the same map element value.
> >
> > I am puzzled by above comments. Maybe you could explain more?
> > bpf_timer_start() checked whether timer is initialized with timer->timer
> > NULL check. It will proceed only if a valid timer has been
> > initialized. I think the following scenarios are also supported:
> >   1. map1 is shared by prog1 and prog2
> >   2. prog1 call bpf_timer_init for all map1 elements
> >   3. prog2 call bpf_timer_start for some or all map1 elements.
> > So for prog2 verification, bpf_timer_init() is not even called.
>
> Right. Such timer sharing between two progs is supported.
> From prog2 pov the bpf_timer_init() was not called, but it certainly
> had to be called by this or ther other prog.
> I'll rephrase the last paragraph.
>
> While talking to Martin about the api he pointed out that
> callback_fn in timer_start() doesn't achieve the full use case
> of replacing a prog. So in the next spin I'll split it into
> bpf_timer_set_callback(timer, callback_fn);
> bpf_timer_start(timer, nsec);
> This way callback and prog can be replaced without resetting
> timer expiry which could be useful.

Have you considered alternatively to implement something like
bpf_ringbuf_query() for BPF ringbuf that will allow to query various
things about the timer (e.g., whether it is active or not, and, of
course, remaining expiry time). That will be more general, easier to
extend, and will cover this use case:

long exp = bpf_timer_query(&t->timer, BPF_TIMER_EXPIRY);
bpf_timer_start(&t->timer, new_callback, exp);

This will keep common timer scenarios to just two steps, init + start,
but won't prevent more complicated ones. Things like extending
expiration by one second relative that what was remaining will be
possible as well.

>
> Also Daniel and Andrii reminded that cpu pinning would be next


Awesome!

> feature request. The api extensibility allows to add it in the future.
> I'm going to delay implementing it until bpf_smp_call_single()
> implications are understood.
