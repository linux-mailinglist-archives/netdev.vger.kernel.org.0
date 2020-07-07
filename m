Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFFCE2165F8
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 07:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbgGGFrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 01:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727102AbgGGFrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 01:47:08 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D03FFC061755;
        Mon,  6 Jul 2020 22:47:08 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id x9so7229400ybd.4;
        Mon, 06 Jul 2020 22:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ATB1kP0yoFBz9oSnjF+0LMahRY9xaRu3e3Bkj2Byd2o=;
        b=PUeLt4JbpxNJfBSTiLU/VCpKFq/VQQRa50bJf4LPMqE0HH1B/dXXN8A/QWyN+kcbov
         rbELMbPrEDfV3e21fUG4BEBD4mb85qN8Q6w+bC+2NpEzFA/BNqw/XDeAHo5MACu+KMUX
         Ev9I4h/tylpbjYiXv+mdqC+dMnN+vwcyE6zQhsIOOmrJI0k4qs5fXw6Yf4S/ZAZYRKmL
         7ytl4RoO+dMI+ZH2dXw2Lps4PlEPHpUjQvQHUTQG29Z6mxizBTLzhsGzOpHGosHNO7p2
         5LdsMKJyj0ydBH7QDVJ6lmjPS0lnaqkWjVuFOsp+1HNZc5IwdiJnmPiXq4reAafLOL+H
         4upw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ATB1kP0yoFBz9oSnjF+0LMahRY9xaRu3e3Bkj2Byd2o=;
        b=LKDkiWzweg5k+kvmaLmYYJ/0olpps/zMvvDuNnMZsGun1WrYw0B9blizUnjV6Bm1DT
         vM2THJT7T8T2ttb+iXzERnW3hBOGxLPpE/widFb+NqMQuHzK9TLxK1WNNrrNYFGBVsjW
         C0uEHi42aJPhSDzKdn1/z1SCr934kdtUyd6s/CP97Q7ydq66K2HW7qkysuzwi3v3KJIQ
         b+YoYr10pug3nDUTVwDz5r3bP5DsSjjA53iF8ChVcMrnf7CgxxDWeM8JP2HHe03GwIpC
         0ESNN6yZX1u9VRRjgZ6Ld9i+h6DU9EsYNinfGxnpnd50skdh/VTMf+XjRAWHpLXCfH85
         DhSw==
X-Gm-Message-State: AOAM5306+w99/4XMkdA/6cuqjazUPN++3/MEwVG9wqpJyCXMzNjV2KaP
        wUzBU+QwceH+Bp2/TWFOkXf507IXgzRXOJQnUQ==
X-Google-Smtp-Source: ABdhPJzGsBNkXwm+Q7jPSrzZPZD8/XXyJEGBFwNp/D8K0kl29pIo7FLjRPeQecFnECqr6BAGPBm78ivAEQ9fJxMtnV0=
X-Received: by 2002:a25:ae0e:: with SMTP id a14mr19940684ybj.180.1594100827818;
 Mon, 06 Jul 2020 22:47:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200702021646.90347-1-danieltimlee@gmail.com>
 <20200702021646.90347-2-danieltimlee@gmail.com> <c4061b5f-b42e-4ecc-e3fb-7a70206da417@fb.com>
 <CAEKGpzhU31p=i=xbD3Fk2vJh_btrk73CgkJXMXDgM1umsEaEpg@mail.gmail.com>
 <41ca5ad1-2b79-dbc2-5f6e-e466712fe7a9@fb.com> <CAEKGpzjpm36YFnqSqTxh7RsS_PH6Xk31NM3174gd74ABbMNVWw@mail.gmail.com>
 <CAEf4BzYx8dT3nFx69-oXXqmwBXia62bTbjG3Nb9X7vz=OxefFg@mail.gmail.com>
 <CAEKGpzi65SaHbaF3RHCB5P9Ro+Wt7_4HFJZxRd2HSXhg07P_Gg@mail.gmail.com> <CAEf4BzZJnm3Hhwc+NpHwUqgs8zuzh8Ug6_ZDHc+qTK8DjAGm5Q@mail.gmail.com>
In-Reply-To: <CAEf4BzZJnm3Hhwc+NpHwUqgs8zuzh8Ug6_ZDHc+qTK8DjAGm5Q@mail.gmail.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Tue, 7 Jul 2020 14:46:48 +0900
Message-ID: <CAEKGpzju+rXGni+ik+EHDSkWadkM8MKYtBAoaNP1HZxMspgyQQ@mail.gmail.com>
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

On Tue, Jul 7, 2020 at 2:15 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Jul 6, 2020 at 7:33 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> >
> > On Tue, Jul 7, 2020 at 8:50 AM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Mon, Jul 6, 2020 at 3:28 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> > > >
> > > > On Fri, Jul 3, 2020 at 1:04 AM Yonghong Song <yhs@fb.com> wrote:
> > > > >
> > > > >
> > > > >
> > > > > On 7/2/20 4:13 AM, Daniel T. Lee wrote:
> > > > > > On Thu, Jul 2, 2020 at 2:13 PM Yonghong Song <yhs@fb.com> wrote:
> > > > > >>
> > > > > >>
> > > > > >>
> > > > > >> On 7/1/20 7:16 PM, Daniel T. Lee wrote:
> > > > > >>> Currently, BPF programs with kprobe/sys_connect does not work properly.
> > > > > >>>
> > > > > >>> Commit 34745aed515c ("samples/bpf: fix kprobe attachment issue on x64")
> > > > > >>> This commit modifies the bpf_load behavior of kprobe events in the x64
> > > > > >>> architecture. If the current kprobe event target starts with "sys_*",
> > > > > >>> add the prefix "__x64_" to the front of the event.
> > > > > >>>
> > > > > >>> Appending "__x64_" prefix with kprobe/sys_* event was appropriate as a
> > > > > >>> solution to most of the problems caused by the commit below.
> > > > > >>>
> > > > > >>>       commit d5a00528b58c ("syscalls/core, syscalls/x86: Rename struct
> > > > > >>>       pt_regs-based sys_*() to __x64_sys_*()")
> > > > > >>>
> > > > > >>> However, there is a problem with the sys_connect kprobe event that does
> > > > > >>> not work properly. For __sys_connect event, parameters can be fetched
> > > > > >>> normally, but for __x64_sys_connect, parameters cannot be fetched.
> > > > > >>>
> > > > > >>> Because of this problem, this commit fixes the sys_connect event by
> > > > > >>> specifying the __sys_connect directly and this will bypass the
> > > > > >>> "__x64_" appending rule of bpf_load.
> > > > > >>
> > > > > >> In the kernel code, we have
> > > > > >>
> > > > > >> SYSCALL_DEFINE3(connect, int, fd, struct sockaddr __user *, uservaddr,
> > > > > >>                   int, addrlen)
> > > > > >> {
> > > > > >>           return __sys_connect(fd, uservaddr, addrlen);
> > > > > >> }
> > > > > >>
> > > > > >> Depending on compiler, there is no guarantee that __sys_connect will
> > > > > >> not be inlined. I would prefer to still use the entry point
> > > > > >> __x64_sys_* e.g.,
> > > > > >>      SEC("kprobe/" SYSCALL(sys_write))
> > > > > >>
> > > > > >
> > > > > > As you mentioned, there is clearly a possibility that problems may arise
> > > > > > because the symbol does not exist according to the compiler.
> > > > > >
> > > > > > However, in x64, when using Kprobe for __x64_sys_connect event, the
> > > > > > tests are not working properly because the parameters cannot be fetched,
> > > > > > and the test under selftests/bpf is using "kprobe/_sys_connect" directly.
> > > > >
> > > > > This is the assembly code for __x64_sys_connect.
> > > > >
> > > > > ffffffff818d3520 <__x64_sys_connect>:
> > > > > ffffffff818d3520: e8 fb df 32 00        callq   0xffffffff81c01520
> > > > > <__fentry__>
> > > > > ffffffff818d3525: 48 8b 57 60           movq    96(%rdi), %rdx
> > > > > ffffffff818d3529: 48 8b 77 68           movq    104(%rdi), %rsi
> > > > > ffffffff818d352d: 48 8b 7f 70           movq    112(%rdi), %rdi
> > > > > ffffffff818d3531: e8 1a ff ff ff        callq   0xffffffff818d3450
> > > > > <__sys_connect>
> > > > > ffffffff818d3536: 48 98                 cltq
> > > > > ffffffff818d3538: c3                    retq
> > > > > ffffffff818d3539: 0f 1f 80 00 00 00 00  nopl    (%rax)
> > > > >
> > > > > In bpf program, the step is:
> > > > >        struct pt_regs *real_regs = PT_REGS_PARM1(pt_regs);
> > > > >        param1 = PT_REGS_PARM1(real_regs);
> > > > >        param2 = PT_REGS_PARM2(real_regs);
> > > > >        param3 = PT_REGS_PARM3(real_regs);
> > > > > The same for s390.
> > > > >
> > > >
> > > > I'm sorry that I seem to get it wrong,
> > > > But is it available to access 'struct pt_regs *' recursively?
> > > >
> > > > It seems nested use of PT_REGS_PARM causes invalid memory access.
> > > >
> > > >     $ sudo ./test_probe_write_user
> > > >     libbpf: load bpf program failed: Permission denied
> > > >     libbpf: -- BEGIN DUMP LOG ---
> > > >     libbpf:
> > > >     Unrecognized arg#0 type PTR
> > > >     ; struct pt_regs *real_regs = PT_REGS_PARM1(ctx);
> > > >     0: (79) r1 = *(u64 *)(r1 +112)
> > > >     ; void *sockaddr_arg = (void *)PT_REGS_PARM2(real_regs);
> > > >     1: (79) r6 = *(u64 *)(r1 +104)
> > > >     R1 invalid mem access 'inv'
> > > >     processed 2 insns (limit 1000000) max_states_per_insn 0
> > > > total_states 0 peak_states 0 mark_read 0
> > > >
> > > >     libbpf: -- END LOG --
> > > >     libbpf: failed to load program 'kprobe/__x64_sys_connect'
> > > >     libbpf: failed to load object './test_probe_write_user_kern.o'
> > > >     ERROR: loading BPF object file failed
> > > >
> > > > I'm not fully aware of the BPF verifier's internal structure.
> > > > Is there any workaround to solve this problem?
> > >
> > > You need to use bpf_probe_read_kernel() to get those arguments from
> > > real_args. Or better just use PT_REGS_PARM1_CORE(x) and others, which
> > > does that for you (+ CO-RE relocation).
> > >
> > >
> >
> > Thanks for the tip!
> >
> > I've just tried the old hack '_(P)':
> > (which is similar implementation with BPF_CORE_READ())
> >
> >     #define _(P) ({typeof(P) val = 0; bpf_probe_read(&val,
> > sizeof(val), &P); val;})
> >     [...]
> >     struct pt_regs *regs = (struct pt_regs *)PT_REGS_PARM1(ctx);
> >     void *sockaddr_arg = (void *)_(PT_REGS_PARM2(regs));
> >     int sockaddr_len = (int)_(PT_REGS_PARM3(regs));
> >
> > and it works properly.
> >
> > Just wondering, why is the pointer chasing of the original ctx
> > considered as an unsafe pointer here?
> >
> >     ; struct pt_regs *real_regs = (struct pt_regs *)PT_REGS_PARM1(ctx);
> >     0: (79) r1 = *(u64 *)(r1 +112)
> >     [...]
> >     ; void *sockaddr_arg = (void *)PT_REGS_PARM2(real_regs);
> >     4: (79) r6 = *(u64 *)(r1 +104)
> >
> > Is it considered as an unsafe pointer since it is unknown what exists
> > in the pointer (r1 + 104), but the instruction is trying to access it?
> >
>
> Yes.
> Because after the initial pointer read, the verifier assumes that you
> are reading a random piece of memory.
>

Thanks for the confirmation. It's very helpful to me.

> >
> > I am a little concerned about using PT_REGS_PARM1_CORE
> > because it is not a CORE-related patch, but if using CORE is the
> > direction BPF wants to take, I will use PT_REGS_PARM1_CORE()
> > instead of _(P) hack using bpf_probe_read().
>
> bpf_probe_read() works as well. But yeah, BPF CO-RE is the way modern
> tracing applications are leaning, look at selftests and see how many
> are using CO-RE already. It's pretty much the only way to write
> portable tracing BPF applications, short of taking Clang/LLVM
> **runtime** dependency, the way BCC makes you do.
>

I see. I'll stick with PT_REGS_PARM1_CORE approach.

I will send the next version of the patch soon.

Thank you for your time and effort for the review.
Daniel

> >
> > In addition, PT_REGS_PARM1_CORE() allows me to write code
> > neatly without having to define additional macro _(P).
> >
> > Thank you for your time and effort for the review.
> > Daniel
> >
> > > >
> > > > Thanks for your time and effort for the review.
> > > > Daniel.
> > > >
> > > > >
> > > > > For other architectures, no above indirection is needed.
> > > > >
> > > > > I guess you can abstract the above into trace_common.h?
> > > > >
> > > > > >
> > > > > > I'm not sure how to deal with this problem. Any advice and suggestions
> > > > > > will be greatly appreciated.
> > > > > >
> > > > > > Thanks for your time and effort for the review.
> > > > > > Daniel
> > > > > >
> > > > > >>>
> > > > > >>> Fixes: 34745aed515c ("samples/bpf: fix kprobe attachment issue on x64")
> > > > > >>> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > > > > >>> ---
>
> [...]
