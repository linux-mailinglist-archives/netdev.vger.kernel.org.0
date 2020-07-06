Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07DF921557F
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 12:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728886AbgGFK0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 06:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728738AbgGFK0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 06:26:51 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 034A3C061794;
        Mon,  6 Jul 2020 03:26:51 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id l19so5883080ybl.1;
        Mon, 06 Jul 2020 03:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X6ExojPsT3jD66HR3turabnI3/FexOCsFkjAHl/6BtI=;
        b=vImv4b3C2E7pMd48wxBzelVOwatqPPo64SH2Y+9XUtaZDUUaSiRzAY1oSKTz9YdMKY
         3wmrW84Hb8Un7MCqNEL4W6whQer71tX+fE5y2kvzIt0ky2dTrrKIWCMaUtMax4ysVWzS
         jZgNxVJki0Mei+/3C2SZp0Quiq5D+4xf9tIbujiDtsS691n4305385vn9/C7hTnF47ZL
         uUohao15k8MpMWBJCslTOiIrYCtdCxaUW+SsY0HJhxS+k+baV8a7n26nYgmPsK2neMtl
         1tNDfg7kkVUxyfdY3gH0avMTouZo3QG7XBlhNTvav2a3sKnPel53B3Z/9meVbiyjMunn
         JH9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X6ExojPsT3jD66HR3turabnI3/FexOCsFkjAHl/6BtI=;
        b=KbS8bSJNuXrJ9hy6003KNRzICpQWshiDnEMsSbNMNuAvfIrAA1GatoE2brYvLbtFOK
         IqGrwBaTy8g3V78LU+7+nJPfnCChnrR8DAijGk0YHZD3ZCrEhA7IHtdNqo6EwGxjxnlx
         I6J1WpxFcQA4fDf1AttSxwMEnO6jNATDK2p8pqbiDqjANZ3OVbpsaF6deqXY5c1m0Ibz
         1GlKA+YtlMU6U95y1ls5QsuFulTyW3HEDWWg7BFc2AAAa4ULsTPYI8SwbSHzzlLr9/x7
         C44zZQMChr/dLrtm2zUsmayK1CQs0zf3/o+24Edss2S4GQVZvU4K1mM0FpTVJlqzeVfX
         i26A==
X-Gm-Message-State: AOAM531UBODQbo81gyAmA8NVxBBn6H9tQznbVyqK09S5Njb93e3yVw5O
        YrEK3RoguFE7ohqo6Vi1j5VZUs6EsgrpaWjhaA==
X-Google-Smtp-Source: ABdhPJyqBC+vy0sGER39Em1hmL4BDow8p3rFc7gr5waxDZELxLG3HmXi9/xpi8lN/sjdOxQZND8aQHGwzTpIpCD0AcM=
X-Received: by 2002:a05:6902:692:: with SMTP id i18mr79955829ybt.164.1594031210064;
 Mon, 06 Jul 2020 03:26:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200702021646.90347-1-danieltimlee@gmail.com>
 <20200702021646.90347-2-danieltimlee@gmail.com> <c4061b5f-b42e-4ecc-e3fb-7a70206da417@fb.com>
 <CAEKGpzhU31p=i=xbD3Fk2vJh_btrk73CgkJXMXDgM1umsEaEpg@mail.gmail.com> <41ca5ad1-2b79-dbc2-5f6e-e466712fe7a9@fb.com>
In-Reply-To: <41ca5ad1-2b79-dbc2-5f6e-e466712fe7a9@fb.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Mon, 6 Jul 2020 19:26:30 +0900
Message-ID: <CAEKGpzjpm36YFnqSqTxh7RsS_PH6Xk31NM3174gd74ABbMNVWw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] samples: bpf: fix bpf programs with
 kprobe/sys_connect event
To:     Yonghong Song <yhs@fb.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 3, 2020 at 1:04 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 7/2/20 4:13 AM, Daniel T. Lee wrote:
> > On Thu, Jul 2, 2020 at 2:13 PM Yonghong Song <yhs@fb.com> wrote:
> >>
> >>
> >>
> >> On 7/1/20 7:16 PM, Daniel T. Lee wrote:
> >>> Currently, BPF programs with kprobe/sys_connect does not work properly.
> >>>
> >>> Commit 34745aed515c ("samples/bpf: fix kprobe attachment issue on x64")
> >>> This commit modifies the bpf_load behavior of kprobe events in the x64
> >>> architecture. If the current kprobe event target starts with "sys_*",
> >>> add the prefix "__x64_" to the front of the event.
> >>>
> >>> Appending "__x64_" prefix with kprobe/sys_* event was appropriate as a
> >>> solution to most of the problems caused by the commit below.
> >>>
> >>>       commit d5a00528b58c ("syscalls/core, syscalls/x86: Rename struct
> >>>       pt_regs-based sys_*() to __x64_sys_*()")
> >>>
> >>> However, there is a problem with the sys_connect kprobe event that does
> >>> not work properly. For __sys_connect event, parameters can be fetched
> >>> normally, but for __x64_sys_connect, parameters cannot be fetched.
> >>>
> >>> Because of this problem, this commit fixes the sys_connect event by
> >>> specifying the __sys_connect directly and this will bypass the
> >>> "__x64_" appending rule of bpf_load.
> >>
> >> In the kernel code, we have
> >>
> >> SYSCALL_DEFINE3(connect, int, fd, struct sockaddr __user *, uservaddr,
> >>                   int, addrlen)
> >> {
> >>           return __sys_connect(fd, uservaddr, addrlen);
> >> }
> >>
> >> Depending on compiler, there is no guarantee that __sys_connect will
> >> not be inlined. I would prefer to still use the entry point
> >> __x64_sys_* e.g.,
> >>      SEC("kprobe/" SYSCALL(sys_write))
> >>
> >
> > As you mentioned, there is clearly a possibility that problems may arise
> > because the symbol does not exist according to the compiler.
> >
> > However, in x64, when using Kprobe for __x64_sys_connect event, the
> > tests are not working properly because the parameters cannot be fetched,
> > and the test under selftests/bpf is using "kprobe/_sys_connect" directly.
>
> This is the assembly code for __x64_sys_connect.
>
> ffffffff818d3520 <__x64_sys_connect>:
> ffffffff818d3520: e8 fb df 32 00        callq   0xffffffff81c01520
> <__fentry__>
> ffffffff818d3525: 48 8b 57 60           movq    96(%rdi), %rdx
> ffffffff818d3529: 48 8b 77 68           movq    104(%rdi), %rsi
> ffffffff818d352d: 48 8b 7f 70           movq    112(%rdi), %rdi
> ffffffff818d3531: e8 1a ff ff ff        callq   0xffffffff818d3450
> <__sys_connect>
> ffffffff818d3536: 48 98                 cltq
> ffffffff818d3538: c3                    retq
> ffffffff818d3539: 0f 1f 80 00 00 00 00  nopl    (%rax)
>
> In bpf program, the step is:
>        struct pt_regs *real_regs = PT_REGS_PARM1(pt_regs);
>        param1 = PT_REGS_PARM1(real_regs);
>        param2 = PT_REGS_PARM2(real_regs);
>        param3 = PT_REGS_PARM3(real_regs);
> The same for s390.
>

I'm sorry that I seem to get it wrong,
But is it available to access 'struct pt_regs *' recursively?

It seems nested use of PT_REGS_PARM causes invalid memory access.

    $ sudo ./test_probe_write_user
    libbpf: load bpf program failed: Permission denied
    libbpf: -- BEGIN DUMP LOG ---
    libbpf:
    Unrecognized arg#0 type PTR
    ; struct pt_regs *real_regs = PT_REGS_PARM1(ctx);
    0: (79) r1 = *(u64 *)(r1 +112)
    ; void *sockaddr_arg = (void *)PT_REGS_PARM2(real_regs);
    1: (79) r6 = *(u64 *)(r1 +104)
    R1 invalid mem access 'inv'
    processed 2 insns (limit 1000000) max_states_per_insn 0
total_states 0 peak_states 0 mark_read 0

    libbpf: -- END LOG --
    libbpf: failed to load program 'kprobe/__x64_sys_connect'
    libbpf: failed to load object './test_probe_write_user_kern.o'
    ERROR: loading BPF object file failed

I'm not fully aware of the BPF verifier's internal structure.
Is there any workaround to solve this problem?

Thanks for your time and effort for the review.
Daniel.

>
> For other architectures, no above indirection is needed.
>
> I guess you can abstract the above into trace_common.h?
>
> >
> > I'm not sure how to deal with this problem. Any advice and suggestions
> > will be greatly appreciated.
> >
> > Thanks for your time and effort for the review.
> > Daniel
> >
> >>>
> >>> Fixes: 34745aed515c ("samples/bpf: fix kprobe attachment issue on x64")
> >>> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> >>> ---
> >>>    samples/bpf/map_perf_test_kern.c         | 2 +-
> >>>    samples/bpf/test_map_in_map_kern.c       | 2 +-
> >>>    samples/bpf/test_probe_write_user_kern.c | 2 +-
> >>>    3 files changed, 3 insertions(+), 3 deletions(-)
> >>>
> >>> diff --git a/samples/bpf/map_perf_test_kern.c b/samples/bpf/map_perf_test_kern.c
> >>> index 12e91ae64d4d..cebe2098bb24 100644
> >>> --- a/samples/bpf/map_perf_test_kern.c
> >>> +++ b/samples/bpf/map_perf_test_kern.c
> >>> @@ -154,7 +154,7 @@ int stress_percpu_hmap_alloc(struct pt_regs *ctx)
> >>>        return 0;
> >>>    }
> >>>
> >>> -SEC("kprobe/sys_connect")
> >>> +SEC("kprobe/__sys_connect")
> >>>    int stress_lru_hmap_alloc(struct pt_regs *ctx)
> >>>    {
> >>>        char fmt[] = "Failed at stress_lru_hmap_alloc. ret:%dn";
> >>> diff --git a/samples/bpf/test_map_in_map_kern.c b/samples/bpf/test_map_in_map_kern.c
> >>> index 6cee61e8ce9b..b1562ba2f025 100644
> >>> --- a/samples/bpf/test_map_in_map_kern.c
> >>> +++ b/samples/bpf/test_map_in_map_kern.c
> >>> @@ -102,7 +102,7 @@ static __always_inline int do_inline_hash_lookup(void *inner_map, u32 port)
> >>>        return result ? *result : -ENOENT;
> >>>    }
> >>>
> >>> -SEC("kprobe/sys_connect")
> >>> +SEC("kprobe/__sys_connect")
> >>>    int trace_sys_connect(struct pt_regs *ctx)
> >>>    {
> >>>        struct sockaddr_in6 *in6;
> >>> diff --git a/samples/bpf/test_probe_write_user_kern.c b/samples/bpf/test_probe_write_user_kern.c
> >>> index 6579639a83b2..9b3c3918c37d 100644
> >>> --- a/samples/bpf/test_probe_write_user_kern.c
> >>> +++ b/samples/bpf/test_probe_write_user_kern.c
> >>> @@ -26,7 +26,7 @@ struct {
> >>>     * This example sits on a syscall, and the syscall ABI is relatively stable
> >>>     * of course, across platforms, and over time, the ABI may change.
> >>>     */
> >>> -SEC("kprobe/sys_connect")
> >>> +SEC("kprobe/__sys_connect")
> >>>    int bpf_prog1(struct pt_regs *ctx)
> >>>    {
> >>>        struct sockaddr_in new_addr, orig_addr = {};
> >>>
