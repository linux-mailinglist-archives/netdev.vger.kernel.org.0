Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8885E38F388
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 21:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233386AbhEXTO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 15:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233026AbhEXTO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 15:14:57 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C40C061574;
        Mon, 24 May 2021 12:13:27 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id w1so28237349ybt.1;
        Mon, 24 May 2021 12:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jW7c0XVzwPeVeUp6pAiTwyKDbuhnujwu7/emCVZNlHg=;
        b=YKQrxghkSrQOBR7PLzYQSqtt8fDzd+Axu5Z7VkvmaeLW1dnpY4j8LwB6s0YtoE3FhK
         M7g7w3u7Tg9H0r0/W3YkNVomRSWab3NpLQIWAeILrNRKGPws6We03qeLNve2zUAb24fN
         0DguhjhSrC0zF0TyjomZhP0EBFzQROENVFpfRTij124krE4Sy+1KHWSLBnY++G3LKX4j
         2NTa+yGYxT6j2GpSM5itBdpdG68A9adURXW8eCzhLffwP5uqEGOQHIgrHmy/g4qnlSBO
         oKwrC4wnlqEzUoNlC75IvL1awfJgRMfjKRwRKMs0Dog7bst+veTEnushQUpFTOUhlKmg
         sHAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jW7c0XVzwPeVeUp6pAiTwyKDbuhnujwu7/emCVZNlHg=;
        b=faxM4h6hEDX7Hwgm3hv5hl0/Qw6IFOCv3YxODJicHWEW0/uKjEobpcF8EvTZHeP8Bw
         vg1bAgeOSGc+9+9PV5SjjUzd6hK44Rq+P/GNq9a5tS77AwjB6S2UBhcWlZG/7fFaXMd2
         gT0YXvTvRaectxFMcjgTXPRODv2Fi8uyKWyxBMDBuxh5+EgwwLgWSvNEYwbOEvW6xIUV
         iUnyDakpRLoRUX6qCpcfR5rWVZ1XwPLHvHgZ9ryxWmg0RM70I2KW6Vy27WuyEqqCrjj/
         rugLZEfCwamChJyVK9c8NtWH23c44Pdf1Zif2KNs0JNh5FQYooznlIfHSyQQasXo6rl/
         ZLxw==
X-Gm-Message-State: AOAM533BETH4qJUwIyBgUgr9FuHBGYmgsky89eoU/JsvuNYc6u2yda8K
        OuGJe5OV35FkKahvJ1ayJuuscKf6qeLLmmcsnEo=
X-Google-Smtp-Source: ABdhPJxwWqUz5py5wqgc/u6Ti1oEGx9AMqw9e/5uEL0oOVbxJaimE3UnEDuPvH8MBbftrDj03dqjM639g1s44k8JUN0=
X-Received: by 2002:a5b:286:: with SMTP id x6mr38949959ybl.347.1621883606890;
 Mon, 24 May 2021 12:13:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210520185550.13688-1-alexei.starovoitov@gmail.com>
 <CACAyw9-7dPx1vLNQeYP9Zqx=OwNcd2t1VK3XGD_aUZZG-twrOg@mail.gmail.com> <CAADnVQLqa6skQKsUK=LO5JDZr8xM_rwZPOgA1F39UQRim1P8vw@mail.gmail.com>
In-Reply-To: <CAADnVQLqa6skQKsUK=LO5JDZr8xM_rwZPOgA1F39UQRim1P8vw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 24 May 2021 12:13:15 -0700
Message-ID: <CAEf4Bza2cupmVZZRx4yWOQBQ7fnaw5pwCQJx9j1HWp=0eUiA1A@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next] bpf: Introduce bpf_timer
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 24, 2021 at 7:56 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, May 24, 2021 at 4:50 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> >
> > On Thu, 20 May 2021 at 19:55, Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > From: Alexei Starovoitov <ast@kernel.org>
> > >
> > > Introduce 'struct bpf_timer' that can be embedded in most BPF map types
> > > and helpers to operate on it:
> > > long bpf_timer_init(struct bpf_timer *timer, void *callback, int flags)
> > > long bpf_timer_mod(struct bpf_timer *timer, u64 msecs)
> > > long bpf_timer_del(struct bpf_timer *timer)
> >
> > I like invoking the callback with a pointer to the map element it was
> > defined in, since it solves lifetime of the context and user space
> > introspection of the same. I'm not so sure about being able to put it
> > into all different kinds of maps, is that really going to be used?
>
> Certainly. At least in array and hash maps.
> The global data is an array.
> A single global timer is a simple and easy to use pattern.
>
> >
> > It would be useful if Cong Wang could describe their use case, it's
> > kind of hard to tell what the end goal is. Should user space be able
> > to create and arm timers? Or just BPF? In the other thread it seems
> > like a primitive for waiting on a timer is proposed. Why? It also begs
> > the question how we would wait on multiple timers.
>
> In the proposed api the same callback can be invoked for multiple timers.
> The user space can create/destroy timers via prog_run cmd.
> It will also destroy timers by map_delete_elem cmd.
>
> > > + *
> > > + * long bpf_timer_init(struct bpf_timer *timer, void *callback, int flags)
> >
> > In your selftest the callback has a type (int)(*callback)(struct
> > bpf_map *map, int *key, struct map_elem *val).
>
> Correct. I'll update the comment.
>
> > > + *     Description
> > > + *             Initialize the timer to call given static function.
> > > + *     Return
> > > + *             zero
> > > + *
> > > + * long bpf_timer_mod(struct bpf_timer *timer, u64 msecs)
> > > + *     Description
> > > + *             Set the timer expiration N msecs from the current time.
> > > + *     Return
> > > + *             zero
> > > + *
> > > + * long bpf_timer_del(struct bpf_timer *timer)
> > > + *     Description
> > > + *             Deactivate the timer.
> > > + *     Return
> > > + *             zero
> > >   */
> > >  #define __BPF_FUNC_MAPPER(FN)          \
> > >         FN(unspec),                     \
> > > @@ -4932,6 +4950,9 @@ union bpf_attr {
> > >         FN(sys_bpf),                    \
> > >         FN(btf_find_by_name_kind),      \
> > >         FN(sys_close),                  \
> > > +       FN(timer_init),                 \
> > > +       FN(timer_mod),                  \
> > > +       FN(timer_del),                  \
> > >         /* */
> >
> > How can user space force stopping of timers (required IMO)?
>
> We can add new commands, of course, but I don't think it's
> necessary, since test_run can be used to achieve the same
> and map_delete_elem will stop them too.

I second the use of BPF_PROG_TEST_RUN (a.k.a. BPF_PROG_RUN now) to
"mirror" such APIs to user-space. We have so much BPF-side
functionality and APIs that reflecting all of that with special
user-space-facing BPF commands is becoming quite impractical. E.g., a
long time ago there was a proposal to add commands to push data to BPF
ringbuf from user-space for all kinds of testing scenarios. We never
did that because no one bothered enough, but now I'd advocate that a
small custom BPF program that is single-shot through BPF_PROG_RUN is a
better way to do this. Similarly for timers and whatever other
functionality. By doing everything from BPF program we also side-step
potential subtle differences in semantics between BPF-side and
user-space-side.

We just need to remember to enable all such functionality to
BPF_PROG_TYPE_SYSCALL as it's sleepable and always runs from user
context, so is most powerful in terms of what's safe to do through
such program type. And, of course, ideally for other types of programs
where it makes sense.


>
> > >
> > >  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> > > @@ -6038,6 +6059,10 @@ struct bpf_spin_lock {
> > >         __u32   val;
> > >  };
> > >
> > > +struct bpf_timer {
> > > +       __u64 opaque;
> > > +};
> > > +
> >
> > This might be clear already, but we won't be able to modify the size
> > of bpf_timer later since it would break uapi, right?
>
> Correct. The internal implementation can change. The 'opaque'
> is just the pointer to the internal struct.
> When do you think we'd need to change this uapi struct?
