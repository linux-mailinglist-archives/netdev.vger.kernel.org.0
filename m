Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D23216413
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 04:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbgGGCdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 22:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbgGGCdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 22:33:46 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07575C061755;
        Mon,  6 Jul 2020 19:33:46 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id j202so19895182ybg.6;
        Mon, 06 Jul 2020 19:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jwg9JBylbv/mt3zy7tsoj2gPTnZdsmGTQJYmuhzzU2k=;
        b=f9njYXtSl/MI/zWIxxyFsktgTHGv/YhUD2LN05DcUef3rmwgG/bO6eTl2Q0RjPGrwo
         ujGHmLg+Li2sbscsyYPNm+n+PVeGsvGDGRYvRhXXJC/8POs7s9zM7QYz7yDKibRfyG9a
         3MPScBDlVtG0hDP51M6iqNspumfvJVB66a9YVmcW66G1l2aizLvChrZQUJeLmb520Qtw
         4YBKOCW+b/g25Nkxpkpsbs2bgujDGu6OfrDpiSpg40ESkddKnRwoZ/t4iSu7e7AHsJmE
         wKPr1yGb8+Od6fPQSsiVyRzRIf76cHGP7Pk6eihT8hmCyAShVBYmdfD/1j9aUKbaOxES
         PEBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jwg9JBylbv/mt3zy7tsoj2gPTnZdsmGTQJYmuhzzU2k=;
        b=Sfo17fV453ZM/fxWjk17c3HFv1lX9KF8rPANlaMZLAeI0zM/1PVGN9xnCJUKBGKpC4
         lovGU1rtJg98ra8cplyYpz2LF04t32arVG1vH1CgWVUUrbBf1k57zVLyium+4o/VCpbl
         QyG/rV64vEQNcIk1kHKPt9yb5vD4b+NA+XPJVAymWfnLvH+7kkOIJLesVynb+IXHo+Ue
         vvPMf8y+JDupCwkIsBoRB8z2q8vUT3rDUYCxRl1JuVOfZLYPqhspwfOrOTVNgLNVNm4L
         01MNeUOVBuz3uCHXAWhN752bdaC9bGxL7B726qlePhpDwyV9bWG3j46/ZAFIA1uG6ukl
         fE1g==
X-Gm-Message-State: AOAM5332bSa3C5R1w8CZx234s0qAt3Dn4soNvNGnQzJ13b3ULgM3luAK
        n/nWm70jN/hDpU6mIgrinLkYc74D9k4CHFq6vA==
X-Google-Smtp-Source: ABdhPJxqAfpg+87PDMwE3OEGT0C7FztkBglcboOMTqBXe6F1KTDv00tYkhzLTkP98Zj8sQLPgxcNszToEdny5GB7Zpc=
X-Received: by 2002:a25:a505:: with SMTP id h5mr612590ybi.419.1594089225208;
 Mon, 06 Jul 2020 19:33:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200702021646.90347-1-danieltimlee@gmail.com>
 <20200702021646.90347-2-danieltimlee@gmail.com> <c4061b5f-b42e-4ecc-e3fb-7a70206da417@fb.com>
 <CAEKGpzhU31p=i=xbD3Fk2vJh_btrk73CgkJXMXDgM1umsEaEpg@mail.gmail.com>
 <41ca5ad1-2b79-dbc2-5f6e-e466712fe7a9@fb.com> <CAEKGpzjpm36YFnqSqTxh7RsS_PH6Xk31NM3174gd74ABbMNVWw@mail.gmail.com>
 <CAEf4BzYx8dT3nFx69-oXXqmwBXia62bTbjG3Nb9X7vz=OxefFg@mail.gmail.com>
In-Reply-To: <CAEf4BzYx8dT3nFx69-oXXqmwBXia62bTbjG3Nb9X7vz=OxefFg@mail.gmail.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Tue, 7 Jul 2020 11:33:26 +0900
Message-ID: <CAEKGpzi65SaHbaF3RHCB5P9Ro+Wt7_4HFJZxRd2HSXhg07P_Gg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] samples: bpf: fix bpf programs with
 kprobe/sys_connect event
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 7, 2020 at 8:50 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Jul 6, 2020 at 3:28 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> >
> > On Fri, Jul 3, 2020 at 1:04 AM Yonghong Song <yhs@fb.com> wrote:
> > >
> > >
> > >
> > > On 7/2/20 4:13 AM, Daniel T. Lee wrote:
> > > > On Thu, Jul 2, 2020 at 2:13 PM Yonghong Song <yhs@fb.com> wrote:
> > > >>
> > > >>
> > > >>
> > > >> On 7/1/20 7:16 PM, Daniel T. Lee wrote:
> > > >>> Currently, BPF programs with kprobe/sys_connect does not work properly.
> > > >>>
> > > >>> Commit 34745aed515c ("samples/bpf: fix kprobe attachment issue on x64")
> > > >>> This commit modifies the bpf_load behavior of kprobe events in the x64
> > > >>> architecture. If the current kprobe event target starts with "sys_*",
> > > >>> add the prefix "__x64_" to the front of the event.
> > > >>>
> > > >>> Appending "__x64_" prefix with kprobe/sys_* event was appropriate as a
> > > >>> solution to most of the problems caused by the commit below.
> > > >>>
> > > >>>       commit d5a00528b58c ("syscalls/core, syscalls/x86: Rename struct
> > > >>>       pt_regs-based sys_*() to __x64_sys_*()")
> > > >>>
> > > >>> However, there is a problem with the sys_connect kprobe event that does
> > > >>> not work properly. For __sys_connect event, parameters can be fetched
> > > >>> normally, but for __x64_sys_connect, parameters cannot be fetched.
> > > >>>
> > > >>> Because of this problem, this commit fixes the sys_connect event by
> > > >>> specifying the __sys_connect directly and this will bypass the
> > > >>> "__x64_" appending rule of bpf_load.
> > > >>
> > > >> In the kernel code, we have
> > > >>
> > > >> SYSCALL_DEFINE3(connect, int, fd, struct sockaddr __user *, uservaddr,
> > > >>                   int, addrlen)
> > > >> {
> > > >>           return __sys_connect(fd, uservaddr, addrlen);
> > > >> }
> > > >>
> > > >> Depending on compiler, there is no guarantee that __sys_connect will
> > > >> not be inlined. I would prefer to still use the entry point
> > > >> __x64_sys_* e.g.,
> > > >>      SEC("kprobe/" SYSCALL(sys_write))
> > > >>
> > > >
> > > > As you mentioned, there is clearly a possibility that problems may arise
> > > > because the symbol does not exist according to the compiler.
> > > >
> > > > However, in x64, when using Kprobe for __x64_sys_connect event, the
> > > > tests are not working properly because the parameters cannot be fetched,
> > > > and the test under selftests/bpf is using "kprobe/_sys_connect" directly.
> > >
> > > This is the assembly code for __x64_sys_connect.
> > >
> > > ffffffff818d3520 <__x64_sys_connect>:
> > > ffffffff818d3520: e8 fb df 32 00        callq   0xffffffff81c01520
> > > <__fentry__>
> > > ffffffff818d3525: 48 8b 57 60           movq    96(%rdi), %rdx
> > > ffffffff818d3529: 48 8b 77 68           movq    104(%rdi), %rsi
> > > ffffffff818d352d: 48 8b 7f 70           movq    112(%rdi), %rdi
> > > ffffffff818d3531: e8 1a ff ff ff        callq   0xffffffff818d3450
> > > <__sys_connect>
> > > ffffffff818d3536: 48 98                 cltq
> > > ffffffff818d3538: c3                    retq
> > > ffffffff818d3539: 0f 1f 80 00 00 00 00  nopl    (%rax)
> > >
> > > In bpf program, the step is:
> > >        struct pt_regs *real_regs = PT_REGS_PARM1(pt_regs);
> > >        param1 = PT_REGS_PARM1(real_regs);
> > >        param2 = PT_REGS_PARM2(real_regs);
> > >        param3 = PT_REGS_PARM3(real_regs);
> > > The same for s390.
> > >
> >
> > I'm sorry that I seem to get it wrong,
> > But is it available to access 'struct pt_regs *' recursively?
> >
> > It seems nested use of PT_REGS_PARM causes invalid memory access.
> >
> >     $ sudo ./test_probe_write_user
> >     libbpf: load bpf program failed: Permission denied
> >     libbpf: -- BEGIN DUMP LOG ---
> >     libbpf:
> >     Unrecognized arg#0 type PTR
> >     ; struct pt_regs *real_regs = PT_REGS_PARM1(ctx);
> >     0: (79) r1 = *(u64 *)(r1 +112)
> >     ; void *sockaddr_arg = (void *)PT_REGS_PARM2(real_regs);
> >     1: (79) r6 = *(u64 *)(r1 +104)
> >     R1 invalid mem access 'inv'
> >     processed 2 insns (limit 1000000) max_states_per_insn 0
> > total_states 0 peak_states 0 mark_read 0
> >
> >     libbpf: -- END LOG --
> >     libbpf: failed to load program 'kprobe/__x64_sys_connect'
> >     libbpf: failed to load object './test_probe_write_user_kern.o'
> >     ERROR: loading BPF object file failed
> >
> > I'm not fully aware of the BPF verifier's internal structure.
> > Is there any workaround to solve this problem?
>
> You need to use bpf_probe_read_kernel() to get those arguments from
> real_args. Or better just use PT_REGS_PARM1_CORE(x) and others, which
> does that for you (+ CO-RE relocation).
>
>

Thanks for the tip!

I've just tried the old hack '_(P)':
(which is similar implementation with BPF_CORE_READ())

    #define _(P) ({typeof(P) val = 0; bpf_probe_read(&val,
sizeof(val), &P); val;})
    [...]
    struct pt_regs *regs = (struct pt_regs *)PT_REGS_PARM1(ctx);
    void *sockaddr_arg = (void *)_(PT_REGS_PARM2(regs));
    int sockaddr_len = (int)_(PT_REGS_PARM3(regs));

and it works properly.

Just wondering, why is the pointer chasing of the original ctx
considered as an unsafe pointer here?

    ; struct pt_regs *real_regs = (struct pt_regs *)PT_REGS_PARM1(ctx);
    0: (79) r1 = *(u64 *)(r1 +112)
    [...]
    ; void *sockaddr_arg = (void *)PT_REGS_PARM2(real_regs);
    4: (79) r6 = *(u64 *)(r1 +104)

Is it considered as an unsafe pointer since it is unknown what exists
in the pointer (r1 + 104), but the instruction is trying to access it?


I am a little concerned about using PT_REGS_PARM1_CORE
because it is not a CORE-related patch, but if using CORE is the
direction BPF wants to take, I will use PT_REGS_PARM1_CORE()
instead of _(P) hack using bpf_probe_read().

In addition, PT_REGS_PARM1_CORE() allows me to write code
neatly without having to define additional macro _(P).

Thank you for your time and effort for the review.
Daniel

> >
> > Thanks for your time and effort for the review.
> > Daniel.
> >
> > >
> > > For other architectures, no above indirection is needed.
> > >
> > > I guess you can abstract the above into trace_common.h?
> > >
> > > >
> > > > I'm not sure how to deal with this problem. Any advice and suggestions
> > > > will be greatly appreciated.
> > > >
> > > > Thanks for your time and effort for the review.
> > > > Daniel
> > > >
> > > >>>
> > > >>> Fixes: 34745aed515c ("samples/bpf: fix kprobe attachment issue on x64")
> > > >>> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > > >>> ---
> > > >>>    samples/bpf/map_perf_test_kern.c         | 2 +-
> > > >>>    samples/bpf/test_map_in_map_kern.c       | 2 +-
> > > >>>    samples/bpf/test_probe_write_user_kern.c | 2 +-
> > > >>>    3 files changed, 3 insertions(+), 3 deletions(-)
> > > >>>
> > > >>> diff --git a/samples/bpf/map_perf_test_kern.c b/samples/bpf/map_perf_test_kern.c
> > > >>> index 12e91ae64d4d..cebe2098bb24 100644
> > > >>> --- a/samples/bpf/map_perf_test_kern.c
> > > >>> +++ b/samples/bpf/map_perf_test_kern.c
> > > >>> @@ -154,7 +154,7 @@ int stress_percpu_hmap_alloc(struct pt_regs *ctx)
> > > >>>        return 0;
> > > >>>    }
> > > >>>
> > > >>> -SEC("kprobe/sys_connect")
> > > >>> +SEC("kprobe/__sys_connect")
> > > >>>    int stress_lru_hmap_alloc(struct pt_regs *ctx)
> > > >>>    {
> > > >>>        char fmt[] = "Failed at stress_lru_hmap_alloc. ret:%dn";
> > > >>> diff --git a/samples/bpf/test_map_in_map_kern.c b/samples/bpf/test_map_in_map_kern.c
> > > >>> index 6cee61e8ce9b..b1562ba2f025 100644
> > > >>> --- a/samples/bpf/test_map_in_map_kern.c
> > > >>> +++ b/samples/bpf/test_map_in_map_kern.c
> > > >>> @@ -102,7 +102,7 @@ static __always_inline int do_inline_hash_lookup(void *inner_map, u32 port)
> > > >>>        return result ? *result : -ENOENT;
> > > >>>    }
> > > >>>
> > > >>> -SEC("kprobe/sys_connect")
> > > >>> +SEC("kprobe/__sys_connect")
> > > >>>    int trace_sys_connect(struct pt_regs *ctx)
> > > >>>    {
> > > >>>        struct sockaddr_in6 *in6;
> > > >>> diff --git a/samples/bpf/test_probe_write_user_kern.c b/samples/bpf/test_probe_write_user_kern.c
> > > >>> index 6579639a83b2..9b3c3918c37d 100644
> > > >>> --- a/samples/bpf/test_probe_write_user_kern.c
> > > >>> +++ b/samples/bpf/test_probe_write_user_kern.c
> > > >>> @@ -26,7 +26,7 @@ struct {
> > > >>>     * This example sits on a syscall, and the syscall ABI is relatively stable
> > > >>>     * of course, across platforms, and over time, the ABI may change.
> > > >>>     */
> > > >>> -SEC("kprobe/sys_connect")
> > > >>> +SEC("kprobe/__sys_connect")
> > > >>>    int bpf_prog1(struct pt_regs *ctx)
> > > >>>    {
> > > >>>        struct sockaddr_in new_addr, orig_addr = {};
> > > >>>
