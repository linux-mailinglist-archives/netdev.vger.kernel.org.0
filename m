Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF49A2165D8
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 07:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgGGFPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 01:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726906AbgGGFPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 01:15:19 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C86C061755;
        Mon,  6 Jul 2020 22:15:19 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id a32so597736qtb.5;
        Mon, 06 Jul 2020 22:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FrGu3k4LEO5ifNJJ/x8Y51cGL1ewzzEAMvn+CLSzWwE=;
        b=Acxjcp6Uo4H4QDWgltMdr46OZVc06Rmk64Vlxy7g9YQxMfovbKTHQwBQP3aqJVT1+4
         oflt0dyTPCcOnIg6cIfplFWMZ+9g4ZmAY7MZ7/hGeM1Gqlcep1XT6sud3AhWWHHabK+1
         QwahthI38Ithony7B1g02joSZN0Zo0attNaZQLir4su3ibP1XL0JOGmoppT8gZDDYdLL
         cwRR4p0pSw7JTJC+fw4HydI9C9bfz9VgwMPBfettrlh/jGZnyT/zvnNenaYSGBkXI60D
         YnhHPOSqjtgabvEVEDlDbOKmxHkye3GSbdAn0DazGQMwBb0hFhXA18fjX8vfmZxfB8WI
         Kvtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FrGu3k4LEO5ifNJJ/x8Y51cGL1ewzzEAMvn+CLSzWwE=;
        b=MEN/XP4KmNgkfsD9NY2H3eXYqB5y0xR8gH+CTzEeswlaAgGU5C8rCU05anaHz6T+FB
         dKHsdRpRoIyMMFYQmBkquqn05Am2qvGhJI9Phbv2brfLK8ViHeS5oDKIS+TnuUHdTDKg
         N1mDtBf9NnB6iJqvEB5rmyLHJJi0dEXPItnFgekr8Jr3aCTrBFjWgveN54K7OplyfM7Z
         G63zdrY01odjvnlAc57o7EQB6r4ba/9YQsVZtD8lYRdFP4jcnl+5OV6C/1qhsNTSVX4G
         ZSpccQ5J4L7C1rnQWbv3EV4Io4EqXfj+pCYAkRn0OXLvcaz6+pi9CPSFYO+tEftFyDEs
         C9TA==
X-Gm-Message-State: AOAM531O4IUxyfQBa2xDD5VLmLb3InCHuRYLjDu3kO2v2J5UsTc0jL8x
        JQ6TgbFtXupJnls0SqIoUc1NIPkr2d604EkDMZQ=
X-Google-Smtp-Source: ABdhPJwIueYIiY5HenfNSXHJ3c+nqySzWBhmYbrvwqRyTWgkhcl6GqmVQw9YltB73yoE8rmYQbMs8CI2w0ussurCZF8=
X-Received: by 2002:ac8:1991:: with SMTP id u17mr50760173qtj.93.1594098918762;
 Mon, 06 Jul 2020 22:15:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200702021646.90347-1-danieltimlee@gmail.com>
 <20200702021646.90347-2-danieltimlee@gmail.com> <c4061b5f-b42e-4ecc-e3fb-7a70206da417@fb.com>
 <CAEKGpzhU31p=i=xbD3Fk2vJh_btrk73CgkJXMXDgM1umsEaEpg@mail.gmail.com>
 <41ca5ad1-2b79-dbc2-5f6e-e466712fe7a9@fb.com> <CAEKGpzjpm36YFnqSqTxh7RsS_PH6Xk31NM3174gd74ABbMNVWw@mail.gmail.com>
 <CAEf4BzYx8dT3nFx69-oXXqmwBXia62bTbjG3Nb9X7vz=OxefFg@mail.gmail.com> <CAEKGpzi65SaHbaF3RHCB5P9Ro+Wt7_4HFJZxRd2HSXhg07P_Gg@mail.gmail.com>
In-Reply-To: <CAEKGpzi65SaHbaF3RHCB5P9Ro+Wt7_4HFJZxRd2HSXhg07P_Gg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 6 Jul 2020 22:15:05 -0700
Message-ID: <CAEf4BzZJnm3Hhwc+NpHwUqgs8zuzh8Ug6_ZDHc+qTK8DjAGm5Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] samples: bpf: fix bpf programs with
 kprobe/sys_connect event
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
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

On Mon, Jul 6, 2020 at 7:33 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> On Tue, Jul 7, 2020 at 8:50 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Mon, Jul 6, 2020 at 3:28 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> > >
> > > On Fri, Jul 3, 2020 at 1:04 AM Yonghong Song <yhs@fb.com> wrote:
> > > >
> > > >
> > > >
> > > > On 7/2/20 4:13 AM, Daniel T. Lee wrote:
> > > > > On Thu, Jul 2, 2020 at 2:13 PM Yonghong Song <yhs@fb.com> wrote:
> > > > >>
> > > > >>
> > > > >>
> > > > >> On 7/1/20 7:16 PM, Daniel T. Lee wrote:
> > > > >>> Currently, BPF programs with kprobe/sys_connect does not work properly.
> > > > >>>
> > > > >>> Commit 34745aed515c ("samples/bpf: fix kprobe attachment issue on x64")
> > > > >>> This commit modifies the bpf_load behavior of kprobe events in the x64
> > > > >>> architecture. If the current kprobe event target starts with "sys_*",
> > > > >>> add the prefix "__x64_" to the front of the event.
> > > > >>>
> > > > >>> Appending "__x64_" prefix with kprobe/sys_* event was appropriate as a
> > > > >>> solution to most of the problems caused by the commit below.
> > > > >>>
> > > > >>>       commit d5a00528b58c ("syscalls/core, syscalls/x86: Rename struct
> > > > >>>       pt_regs-based sys_*() to __x64_sys_*()")
> > > > >>>
> > > > >>> However, there is a problem with the sys_connect kprobe event that does
> > > > >>> not work properly. For __sys_connect event, parameters can be fetched
> > > > >>> normally, but for __x64_sys_connect, parameters cannot be fetched.
> > > > >>>
> > > > >>> Because of this problem, this commit fixes the sys_connect event by
> > > > >>> specifying the __sys_connect directly and this will bypass the
> > > > >>> "__x64_" appending rule of bpf_load.
> > > > >>
> > > > >> In the kernel code, we have
> > > > >>
> > > > >> SYSCALL_DEFINE3(connect, int, fd, struct sockaddr __user *, uservaddr,
> > > > >>                   int, addrlen)
> > > > >> {
> > > > >>           return __sys_connect(fd, uservaddr, addrlen);
> > > > >> }
> > > > >>
> > > > >> Depending on compiler, there is no guarantee that __sys_connect will
> > > > >> not be inlined. I would prefer to still use the entry point
> > > > >> __x64_sys_* e.g.,
> > > > >>      SEC("kprobe/" SYSCALL(sys_write))
> > > > >>
> > > > >
> > > > > As you mentioned, there is clearly a possibility that problems may arise
> > > > > because the symbol does not exist according to the compiler.
> > > > >
> > > > > However, in x64, when using Kprobe for __x64_sys_connect event, the
> > > > > tests are not working properly because the parameters cannot be fetched,
> > > > > and the test under selftests/bpf is using "kprobe/_sys_connect" directly.
> > > >
> > > > This is the assembly code for __x64_sys_connect.
> > > >
> > > > ffffffff818d3520 <__x64_sys_connect>:
> > > > ffffffff818d3520: e8 fb df 32 00        callq   0xffffffff81c01520
> > > > <__fentry__>
> > > > ffffffff818d3525: 48 8b 57 60           movq    96(%rdi), %rdx
> > > > ffffffff818d3529: 48 8b 77 68           movq    104(%rdi), %rsi
> > > > ffffffff818d352d: 48 8b 7f 70           movq    112(%rdi), %rdi
> > > > ffffffff818d3531: e8 1a ff ff ff        callq   0xffffffff818d3450
> > > > <__sys_connect>
> > > > ffffffff818d3536: 48 98                 cltq
> > > > ffffffff818d3538: c3                    retq
> > > > ffffffff818d3539: 0f 1f 80 00 00 00 00  nopl    (%rax)
> > > >
> > > > In bpf program, the step is:
> > > >        struct pt_regs *real_regs = PT_REGS_PARM1(pt_regs);
> > > >        param1 = PT_REGS_PARM1(real_regs);
> > > >        param2 = PT_REGS_PARM2(real_regs);
> > > >        param3 = PT_REGS_PARM3(real_regs);
> > > > The same for s390.
> > > >
> > >
> > > I'm sorry that I seem to get it wrong,
> > > But is it available to access 'struct pt_regs *' recursively?
> > >
> > > It seems nested use of PT_REGS_PARM causes invalid memory access.
> > >
> > >     $ sudo ./test_probe_write_user
> > >     libbpf: load bpf program failed: Permission denied
> > >     libbpf: -- BEGIN DUMP LOG ---
> > >     libbpf:
> > >     Unrecognized arg#0 type PTR
> > >     ; struct pt_regs *real_regs = PT_REGS_PARM1(ctx);
> > >     0: (79) r1 = *(u64 *)(r1 +112)
> > >     ; void *sockaddr_arg = (void *)PT_REGS_PARM2(real_regs);
> > >     1: (79) r6 = *(u64 *)(r1 +104)
> > >     R1 invalid mem access 'inv'
> > >     processed 2 insns (limit 1000000) max_states_per_insn 0
> > > total_states 0 peak_states 0 mark_read 0
> > >
> > >     libbpf: -- END LOG --
> > >     libbpf: failed to load program 'kprobe/__x64_sys_connect'
> > >     libbpf: failed to load object './test_probe_write_user_kern.o'
> > >     ERROR: loading BPF object file failed
> > >
> > > I'm not fully aware of the BPF verifier's internal structure.
> > > Is there any workaround to solve this problem?
> >
> > You need to use bpf_probe_read_kernel() to get those arguments from
> > real_args. Or better just use PT_REGS_PARM1_CORE(x) and others, which
> > does that for you (+ CO-RE relocation).
> >
> >
>
> Thanks for the tip!
>
> I've just tried the old hack '_(P)':
> (which is similar implementation with BPF_CORE_READ())
>
>     #define _(P) ({typeof(P) val = 0; bpf_probe_read(&val,
> sizeof(val), &P); val;})
>     [...]
>     struct pt_regs *regs = (struct pt_regs *)PT_REGS_PARM1(ctx);
>     void *sockaddr_arg = (void *)_(PT_REGS_PARM2(regs));
>     int sockaddr_len = (int)_(PT_REGS_PARM3(regs));
>
> and it works properly.
>
> Just wondering, why is the pointer chasing of the original ctx
> considered as an unsafe pointer here?
>
>     ; struct pt_regs *real_regs = (struct pt_regs *)PT_REGS_PARM1(ctx);
>     0: (79) r1 = *(u64 *)(r1 +112)
>     [...]
>     ; void *sockaddr_arg = (void *)PT_REGS_PARM2(real_regs);
>     4: (79) r6 = *(u64 *)(r1 +104)
>
> Is it considered as an unsafe pointer since it is unknown what exists
> in the pointer (r1 + 104), but the instruction is trying to access it?
>

Yes.
Because after the initial pointer read, the verifier assumes that you
are reading a random piece of memory.

>
> I am a little concerned about using PT_REGS_PARM1_CORE
> because it is not a CORE-related patch, but if using CORE is the
> direction BPF wants to take, I will use PT_REGS_PARM1_CORE()
> instead of _(P) hack using bpf_probe_read().

bpf_probe_read() works as well. But yeah, BPF CO-RE is the way modern
tracing applications are leaning, look at selftests and see how many
are using CO-RE already. It's pretty much the only way to write
portable tracing BPF applications, short of taking Clang/LLVM
**runtime** dependency, the way BCC makes you do.

>
> In addition, PT_REGS_PARM1_CORE() allows me to write code
> neatly without having to define additional macro _(P).
>
> Thank you for your time and effort for the review.
> Daniel
>
> > >
> > > Thanks for your time and effort for the review.
> > > Daniel.
> > >
> > > >
> > > > For other architectures, no above indirection is needed.
> > > >
> > > > I guess you can abstract the above into trace_common.h?
> > > >
> > > > >
> > > > > I'm not sure how to deal with this problem. Any advice and suggestions
> > > > > will be greatly appreciated.
> > > > >
> > > > > Thanks for your time and effort for the review.
> > > > > Daniel
> > > > >
> > > > >>>
> > > > >>> Fixes: 34745aed515c ("samples/bpf: fix kprobe attachment issue on x64")
> > > > >>> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > > > >>> ---

[...]
