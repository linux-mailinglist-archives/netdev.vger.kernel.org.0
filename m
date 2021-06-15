Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0B0F3A761A
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 06:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbhFOEvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 00:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhFOEvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 00:51:14 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6A6C061574;
        Mon, 14 Jun 2021 21:49:10 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id m9so18656190ybo.5;
        Mon, 14 Jun 2021 21:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z6vzThHCTK2adP4fn9UdBJ9Ugx409e5PgoPBUjudK/A=;
        b=U6J1C3H9dj8OO2GaM6JzYRq890E2OOLqDwA/09R3xPKnDQ1BZ44q4OYQzelPCy3x+o
         xuEr3EDHgKhLuoSU/rJZmNlyPkWWIvmv9pRbrPWBV/jz+0mfmqNmT6AIgo2lZ+1Q+b+9
         6poxwuFeiYyAJnmGmdig2/ycpLQr6VIecVSMFq1U9nDToZHVo4QM1iVLFWQgCbaWso3F
         KtcyzK5pXRODlcPH0g5Cc2KiiID65Cr+J1cITJFDa7kCwGQ7HM6N0AWWP7meF4NWE8J4
         6P+QzXhtncfZbOWkiqiO8aNUnK30Echd6eq+DGHmbWysMkNuQ9w163jPkNZK/I1TGiPZ
         uKYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z6vzThHCTK2adP4fn9UdBJ9Ugx409e5PgoPBUjudK/A=;
        b=deIrNIN+Y3TaoSE5xYZL+o01aCNC8P6i0luqBjCpOjq4gbRzNLaxuvven1ZfgLulGp
         jWeK+Dsc8GAghoUjcmHhiXJDATm43GBnmQIQh+/Tmq02lzXhLy7lSckE4UojCyDTkU6J
         x1B4PnJEbDDpsqkENZDW6jQDoX+AAO4IOa9bdRYqsD9v6GGp7DWCXfhHZjQVw1fRiGSx
         qC2RyJYzTxodtTsRtB40/wtnP8TGKu+kN5EHj+HrgbQKfajbgeLWYZf2Mtql0Kd/ny8s
         6jlhVVOuCnI+/4FnoNq9+1ZvIBoQzrBjLcitemdRuIwaXzrVdh1sb1c01QoVD8t4f1k/
         lKyw==
X-Gm-Message-State: AOAM530wo/wLfk/+iQcph2WRk343xCNIN9dsqPtcP24R7BuMMiPE0+4r
        KVi6IqA3lHEOHSCUiy23/7p55+4qQnUew0D6tgA=
X-Google-Smtp-Source: ABdhPJx7Hm35bXAnN+AmgxU7stl0zxrJ6v/Y24UZU+cjsv7q3pZzCOd3HgS/gaWMNLmg3nsX7R5K+tLsvP8PSdOKD7E=
X-Received: by 2002:a25:df82:: with SMTP id w124mr6126764ybg.425.1623732549748;
 Mon, 14 Jun 2021 21:49:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210611042442.65444-1-alexei.starovoitov@gmail.com> <20210611042442.65444-2-alexei.starovoitov@gmail.com>
In-Reply-To: <20210611042442.65444-2-alexei.starovoitov@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 14 Jun 2021 21:48:58 -0700
Message-ID: <CAEf4BzYo9HioS1BumMMTaKX7QpgC8D2SrQbrESfcbfqpvesXhw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: Introduce bpf_timer
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 9:24 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> Introduce 'struct bpf_timer { __u64 :64; __u64 :64; };' that can be embedded
> in hash/array/lru maps as regular field and helpers to operate on it:
>
> // Initialize the timer to call 'callback_fn' static function
> // First 4 bits of 'flags' specify clockid.
> // Only CLOCK_MONOTONIC, CLOCK_REALTIME, CLOCK_BOOTTIME are allowed.
> long bpf_timer_init(struct bpf_timer *timer, void *callback_fn, int flags);
>
> // Start the timer and set its expiration 'nsec' nanoseconds from the current time.
> long bpf_timer_start(struct bpf_timer *timer, u64 nsec);
>
> // Cancel the timer and wait for callback_fn to finish if it was running.
> long bpf_timer_cancel(struct bpf_timer *timer);
>
> Here is how BPF program might look like:
> struct map_elem {
>     int counter;
>     struct bpf_timer timer;
> };
>
> struct {
>     __uint(type, BPF_MAP_TYPE_HASH);
>     __uint(max_entries, 1000);
>     __type(key, int);
>     __type(value, struct map_elem);
> } hmap SEC(".maps");
>
> static int timer_cb(void *map, int *key, struct map_elem *val);
> /* val points to particular map element that contains bpf_timer. */
>
> SEC("fentry/bpf_fentry_test1")
> int BPF_PROG(test1, int a)
> {
>     struct map_elem *val;
>     int key = 0;
>
>     val = bpf_map_lookup_elem(&hmap, &key);
>     if (val) {
>         bpf_timer_init(&val->timer, timer_cb, CLOCK_REALTIME);
>         bpf_timer_start(&val->timer, 1000 /* call timer_cb2 in 1 usec */);
>     }
> }
>
> This patch adds helper implementations that rely on hrtimers
> to call bpf functions as timers expire.
> The following patch adds necessary safety checks.
>
> Only programs with CAP_BPF are allowed to use bpf_timer.
>
> The amount of timers used by the program is constrained by
> the memcg recorded at map creation time.
>
> The bpf_timer_init() helper is receiving hidden 'map' and 'prog' arguments
> supplied by the verifier. The prog pointer is needed to do refcnting of bpf
> program to make sure that program doesn't get freed while timer is armed.
>
> The bpf_map_delete_elem() and bpf_map_update_elem() operations cancel
> and free the timer if given map element had it allocated.
> "bpftool map update" command can be used to cancel timers.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

Looks great!

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  include/linux/bpf.h            |   2 +
>  include/uapi/linux/bpf.h       |  40 ++++++
>  kernel/bpf/helpers.c           | 227 +++++++++++++++++++++++++++++++++
>  kernel/bpf/verifier.c          | 109 ++++++++++++++++
>  kernel/trace/bpf_trace.c       |   2 +-
>  scripts/bpf_doc.py             |   2 +
>  tools/include/uapi/linux/bpf.h |  40 ++++++
>  7 files changed, 421 insertions(+), 1 deletion(-)
>

[...]

> + *
> + * long bpf_timer_init(struct bpf_timer *timer, void *callback_fn, int flags)
> + *     Description
> + *             Initialize the timer to call *callback_fn* static function.
> + *             First 4 bits of *flags* specify clockid. Only CLOCK_MONOTONIC,
> + *             CLOCK_REALTIME, CLOCK_BOOTTIME are allowed.
> + *             All other bits of *flags* are reserved.
> + *     Return
> + *             0 on success.
> + *             **-EBUSY** if *timer* is already initialized.
> + *             **-EINVAL** if invalid *flags* are passed.
> + *
> + * long bpf_timer_start(struct bpf_timer *timer, u64 nsecs)
> + *     Description
> + *             Start the timer and set its expiration N nanoseconds from the
> + *             current time. The timer callback_fn will be invoked in soft irq
> + *             context on some cpu and will not repeat unless another
> + *             bpf_timer_start() is made. In such case the next invocation can
> + *             migrate to a different cpu.

This is a nice description, thanks.

> + *     Return
> + *             0 on success.
> + *             **-EINVAL** if *timer* was not initialized with bpf_timer_init() earlier.
> + *
> + * long bpf_timer_cancel(struct bpf_timer *timer)
> + *     Description
> + *             Cancel the timer and wait for callback_fn to finish if it was running.
> + *     Return
> + *             0 if the timer was not active.
> + *             1 if the timer was active.
> + *             **-EINVAL** if *timer* was not initialized with bpf_timer_init() earlier.
> + *             **-EDEADLK** if callback_fn tried to call bpf_timer_cancel() on its own timer
> + *             which would have led to a deadlock otherwise.
>   */

[...]

> +       ret = BPF_CAST_CALL(t->callback_fn)((u64)(long)map,
> +                                           (u64)(long)key,
> +                                           (u64)(long)t->value, 0, 0);
> +       WARN_ON(ret != 0); /* Next patch disallows 1 in the verifier */
> +
> +       /* The bpf function finished executed. Drop the prog refcnt.

typo: execution

> +        * It could reach zero here and trigger free of bpf_prog
> +        * and subsequent free of the maps that were holding timers.
> +        * If callback_fn called bpf_timer_start on this timer
> +        * the prog refcnt will be > 0.
> +        *
> +        * If callback_fn deleted map element the 't' could have been freed,
> +        * hence t->prog deref is done earlier.
> +        */
> +       bpf_prog_put(prog);
> +       this_cpu_write(hrtimer_running, NULL);
> +       return HRTIMER_NORESTART;
> +}
> +

[...]
