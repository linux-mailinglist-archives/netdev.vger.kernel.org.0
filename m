Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E54D11A7007
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 02:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390435AbgDNA0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 20:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727878AbgDNA0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 20:26:33 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF63C0A3BDC;
        Mon, 13 Apr 2020 17:26:32 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id h205so6250692ybg.6;
        Mon, 13 Apr 2020 17:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=O+y4L2R5i+2Cj/w1MoSPDF15kI4P0C4wXhYRfC0S+a0=;
        b=RXV5ZIiOsQWh1Fej0gg2cEZQeEIboBrqTlWubPw/OOd0c4Sk+c9ODtFtyqocX4vs8/
         ni2vCShDQpt3Es0dl9Mr5tnCf4aD9iIKAB93QmnOaB6hih2ThvupWKUBFALyxo/+MLDi
         EhOSPAH7QWuc+QDXMtXqSir8odhrm22itaSv44+cwa8wRLzJ6lUvy7LsRUaARP1eYStQ
         to87+SLw+2lwSBf7wOsYa2QwyXJlESpPxoOz+fwudX0SfngcNFfiGaZqOgbf5OcA1MQV
         gyqc1U/hNMTT001NVAJGULodZRpBErBsC0Fi/P/5hej4ayzTc9e0XmHo7ZWvPpKnCOv0
         4B1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=O+y4L2R5i+2Cj/w1MoSPDF15kI4P0C4wXhYRfC0S+a0=;
        b=jyXl0HeGyl0GJoBJ4a4TA87xoEXKM+vTDgK+53111SnN7m1fHPDf5aie29Lu6eWFcd
         wIHKXKRAoGdpsV5vNrRbWQBk1Wc98hoQF7ge7UrQDF2eNk/pUXRCAICENt3+5lm0Nr7x
         yblabDLsdSr7ieIBuOMSwXN7db6u69z1qGz+nZH9CPJJuitCNKMv/2LQHVC+QtpWGbX1
         6rldCrYxysUo0d/EtvZN2uUOeVMHIEWnFQBTMj6Hky7QUxdkAfJ9x4za+f+yYnRL18x7
         oIBhSBVm4wZMwnNimLjBPvDBdrnT0wuxsZzP0fWjIgnj+D3rMPzjB69FuRLaEw+Dyu6h
         GohA==
X-Gm-Message-State: AGi0PuY/6uHLurP7trUlgYthtPzx8hWIIOojH2zWJDX/qK+qz8vFn+M3
        co9SeFQHO8vBYmqDe2tDPGmfkm/NJQLzD3sFgHCUinFDIg==
X-Google-Smtp-Source: APiQypKp7ptTA/UqEHj7E2VMr1cGfjqOpvk5NXLb2DirK77mDlNKNaT/eQDr9deOvWbkwb6V1fWxDzbHoFthSVbGNjc=
X-Received: by 2002:a25:1485:: with SMTP id 127mr28989993ybu.464.1586823991299;
 Mon, 13 Apr 2020 17:26:31 -0700 (PDT)
MIME-Version: 1.0
References: <CAEKGpzh3drL1ywEfnJWhAqULcjaqGi+8GZSwG9XV-iYK4DnCpA@mail.gmail.com>
In-Reply-To: <CAEKGpzh3drL1ywEfnJWhAqULcjaqGi+8GZSwG9XV-iYK4DnCpA@mail.gmail.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Tue, 14 Apr 2020 09:26:15 +0900
Message-ID: <CAEKGpzhSm1hmK0WuK=s-2ROE3yb2HpaQbMaDx4==TM1hwM+smA@mail.gmail.com>
Subject: Re: BPF program attached on BPF map function (read,write) is not working?
To:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ping?

On Thu, Apr 9, 2020 at 12:26 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> Currently, BPF program attached on BPF map function (read,write) is not called.
> To be specific, the bpf kprobe program on 'htab_map_get_next_key'
> doesn't called at all. To test this behavior, you can try ./tracex6
> from the 'samples/bpf'. (It does not work properly at all)
>
> By using 'git bisect', found the problem is derived from below commit.(v5.0-rc3)
> commit 7c4cd051add3 ("bpf: Fix syscall's stackmap lookup potential deadlock")
> The code below is an excerpt of only the problematic code from the entire code.
>
>    diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
>    index b155cd17c1bd..8577bb7f8be6 100644
>    --- a/kernel/bpf/syscall.c
>    +++ b/kernel/bpf/syscall.c
>    @@ -713,8 +713,13 @@ static int map_lookup_elem(union bpf_attr *attr)
>
>            if (bpf_map_is_dev_bound(map)) {
>                    err = bpf_map_offload_lookup_elem(map, key, value);
>                    goto done;
>            }
>
>            preempt_disable();
>    +      this_cpu_inc(bpf_prog_active);
>            if (map->map_type == BPF_MAP_TYPE_PERCPU_HASH ||
>                map->map_type == BPF_MAP_TYPE_LRU_PERCPU_HASH) {
>                    err = bpf_percpu_hash_copy(map, key, value);
>            } else if (map->map_type == BPF_MAP_TYPE_PERCPU_ARRAY) {
>                    err = bpf_percpu_array_copy(map, key, value);
>    @@ -744,7 +749,10 @@ static int map_lookup_elem(union bpf_attr *attr)
>                    }
>                    rcu_read_unlock();
>            }
>    +      this_cpu_dec(bpf_prog_active);
>            preempt_enable();
>
>    done:
>            if (err)
>                    goto free_value;
>
> As you can see from this snippet, bpf_prog_active value (flag I guess?)
> increases and decreases within the code snippet. And this action create a
> problem where bpf program on map is not called.
>
>    # kernel/trace/bpf_trace.c:74
>    unsigned int trace_call_bpf(struct trace_event_call *call, void *ctx)
>    {
>        ...
>         preempt_disable();
>
>         if (unlikely(__this_cpu_inc_return(bpf_prog_active) != 1)) {
>                 /*
>                  * since some bpf program is already running on this cpu,
>                  * don't call into another bpf program (same or different)
>                  * and don't send kprobe event into ring-buffer,
>                  * so return zero here
>                  */
>                 ret = 0;
>                 goto out;
>         }
>        ...
>        ret = BPF_PROG_RUN_ARRAY_CHECK(call->prog_array, ctx, BPF_PROG_RUN);
>
>    out:
>        __this_cpu_dec(bpf_prog_active);
>        preempt_enable();
>
>
> So from trace_call_bpf() at kernel/trace/bpf_trace.c check whether
> bpf_prog_active is 1, and if it is, it skips the execution of bpf program.
>
> Back to latest Kernel 5.6, this this_cpu_{inc|dec}() has been wrapped with
> bpf_{enable|disable}_instrumentation().
>
>    # include/linux/bpf.h
>    static inline void bpf_enable_instrumentation(void)
>    {
>            if (IS_ENABLED(CONFIG_PREEMPT_RT))
>                    this_cpu_dec(bpf_prog_active);
>            else
>                    __this_cpu_dec(bpf_prog_active);
>            migrate_enable();
>    }
>
> And the functions which uses this wrapper are described below.
>
>    bpf_map_update_value
>    bpf_map_copy_value
>    map_delete_elem
>    generic_map_delete_batch
>
> Which is basically most of the map operation.
>
> So, I think this 'unable to attach bpf program on BPF map function (read,write)'
> is a bug. Or is it desired action?
>
> If it is a bug, bpf_{enable|disable}_instrumentation() should only
> cover stackmap
> as the upper commit intended. Not sure but adding another flag for
> lock might work?
>
> Or if this is an desired action, this should be covered at
> documentation with a limitation
> and tracex6 sample has to be removed.
