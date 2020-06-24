Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD2120692C
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 02:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388207AbgFXAxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 20:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729700AbgFXAxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 20:53:42 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D110FC061573;
        Tue, 23 Jun 2020 17:53:41 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id l6so351682qkc.6;
        Tue, 23 Jun 2020 17:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ymHm30ThJM9+li2gmthHOsqDagx7sxI4jvkVj/K8ePc=;
        b=dS7Hc/5aI8bMQTD0bwlip3iJRkphZWhCc7eKbxLymSvVdRhOp8yNhw6aeo9j5fCamd
         ELjc268nyut2Pq9tpwZQnXIaZ6ydwQCvhMgX6yIaqvzct3nePMZwI3HoLT8eSOwybJAy
         1A1r2t7p5EJ98EdVupMcO36LZC3gWifzvojLpdCG3iWSOTnereDglVhq3MbkFcijBvcK
         +PJmx7ntl9dAH6k/sVUZoRpFAlmpnKDu7YjUrSRU4WkankERDO4+KCnUTQpGijaTyYJv
         TGtUgwCc7u90XuX5OAs9BltHsDmLmRH0ncG9ATrBSC7DH8tjNPLfmJWZhpUGaGfvYlU+
         kXLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ymHm30ThJM9+li2gmthHOsqDagx7sxI4jvkVj/K8ePc=;
        b=TcCPzEFNQK9Q5M9WTmpIv+bms3ZJLKLeuYbd0UNh+v/ETrUs5dfNagUmS2MLz/7K/I
         1kuY3GNdIkqhu1vtvCJ9BGP7+9zjRwE6CZ00VNrvQ2Pr4+KntwpQiF780PZREL6Bt8pX
         71T//k4bMuNyRHiysIsmXyFDJcYoVZtoWk6wOxut7wUDKrNH1BOOajl0XN2/TFkXrc7D
         mC9X8cziCLDISuhMRwcMhWg4f+/IOU0CuhxFABno40sHMgdujhqIVVS6/scsHco+rf3/
         dlOax6EW/J08oUjnGOuqh+OURMT6/76yv/ZGX7a136BTUsloE3RCnMlvKYh4oSknETPZ
         ugCw==
X-Gm-Message-State: AOAM533+c+qrfWO30AdWzHqQFn3IaXr9lGxKdOE+4EM2Qh29nFQBbDt2
        Ug7EbFsWxZUP3jzoA3uv7YQUvTlJften2dgq/tA=
X-Google-Smtp-Source: ABdhPJzX25sDXemnw8Lt0C16ukxRj69LsNFmY1UIYkf+uqliNFyKcLBxEH28CXHfk3X7LtH4nF3gljWekyiO3eKv5lw=
X-Received: by 2002:a05:620a:2409:: with SMTP id d9mr17056507qkn.36.1592960020879;
 Tue, 23 Jun 2020 17:53:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200623032224.4020118-1-andriin@fb.com> <20200623032224.4020118-2-andriin@fb.com>
 <7ed6ada5-2539-3090-0db7-0f65b67e4699@iogearbox.net> <CAEf4BzbsRyt5Y4-oMaKTUNu_ijnRD09+WW3iA+bfGLZcLpd77w@mail.gmail.com>
 <ee6df475-b7d4-b8ed-dc91-560e42d2e7fc@iogearbox.net> <20200623232503.yzm4g24rwx7khudf@ast-mbp.dhcp.thefacebook.com>
 <f1ec2d3b-4897-1a40-e373-51bed4fd3b87@fb.com>
In-Reply-To: <f1ec2d3b-4897-1a40-e373-51bed4fd3b87@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 23 Jun 2020 17:53:29 -0700
Message-ID: <CAEf4BzZTWyii7k6MjdygJP+VfAHnnr8jbxjG1Ge96ioKq5ZEeQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 2/3] selftests/bpf: add variable-length data
 concatenation pattern test
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 5:25 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 6/23/20 4:25 PM, Alexei Starovoitov wrote:
> > On Tue, Jun 23, 2020 at 11:15:58PM +0200, Daniel Borkmann wrote:
> >> On 6/23/20 10:52 PM, Andrii Nakryiko wrote:
> >>> On Tue, Jun 23, 2020 at 1:39 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >>>> On 6/23/20 5:22 AM, Andrii Nakryiko wrote:
> >>>>> Add selftest that validates variable-length data reading and concatentation
> >>>>> with one big shared data array. This is a common pattern in production use for
> >>>>> monitoring and tracing applications, that potentially can read a lot of data,
> >>>>> but overall read much less. Such pattern allows to determine precisely what
> >>>>> amount of data needs to be sent over perfbuf/ringbuf and maximize efficiency.
> >>>>>
> >>>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> >>>>
> >>>> Currently getting the below errors on these tests. My last clang/llvm git build
> >>>> is on 4676cf444ea2 ("[Clang] Skip adding begin source location for PragmaLoopHint'd
> >>>> loop when[...]"):
> >>>
> >>> Yeah, you need 02553b91da5d ("bpf: bpf_probe_read_kernel_str() has to
> >>> return amount of data read on success") from bpf tree.
> >>
> >> Fair point, it's in net- but not yet in net-next tree, so bpf-next sync needs
> >> to wait.
> >>
> >>> I'm eagerly awaiting bpf being merged into bpf-next :)
> >>
> >> I'll cherry-pick 02553b91da5d locally for testing and if it passes I'll push
> >> these out.
> >
> > I've merged the bpf_probe_read_kernel_str() fix into bpf-next and 3 extra commits
> > prior to that one so that sha of the bpf_probe_read_kernel_str() fix (02553b91da5de)
> > is exactly the same in bpf/net/linus/bpf-next. I think that shouldn't cause
> > issue during bpf-next pull into net-next and later merge with Linus's tree.
> > Crossing fingers, since we're doing this experiment for the first time.
> >
> > Daniel pushed these 3 commits as well.
> > Now varlen and kernel_reloc tests are good, but we have a different issue :(
> > ./test_progs-no_alu32 -t get_stack_raw_tp
> > is now failing, but for a different reason.
> >
> > 52: (85) call bpf_get_stack#67
> > 53: (bf) r8 = r0
> > 54: (bf) r1 = r8
> > 55: (67) r1 <<= 32
> > 56: (c7) r1 s>>= 32
> > ; if (usize < 0)
> > 57: (c5) if r1 s< 0x0 goto pc+26
> >   R0=inv(id=0,smax_value=800) R1_w=inv(id=0,umax_value=800,var_off=(0x0; 0x3ff)) R6=ctx(id=0,off=0,imm=0) R7=map_value(id=0,off=0,ks=4,vs=1600,imm=0) R8_w=inv(id=0,smax_value=800) R9=inv800 R10=fp0 fp-8=mmmm????
> > ; ksize = bpf_get_stack(ctx, raw_data + usize, max_len - usize, 0);
> > 58: (1f) r9 -= r8
> > ; ksize = bpf_get_stack(ctx, raw_data + usize, max_len - usize, 0);
> > 59: (bf) r2 = r7
> > 60: (0f) r2 += r1
> > regs=1 stack=0 before 52: (85) call bpf_get_stack#67
> > ; ksize = bpf_get_stack(ctx, raw_data + usize, max_len - usize, 0);
> > 61: (bf) r1 = r6
> > 62: (bf) r3 = r9
> > 63: (b7) r4 = 0
> > 64: (85) call bpf_get_stack#67
> >   R0=inv(id=0,smax_value=800) R1_w=ctx(id=0,off=0,imm=0) R2_w=map_value(id=0,off=0,ks=4,vs=1600,umax_value=800,var_off=(0x0; 0x3ff),s32_max_value=1023,u32_max_value=1023) R3_w=inv(id=0,umax_value=9223372036854776608) R4_w=inv0 R6=ctx(id=0?
> > R3 unbounded memory access, use 'var &= const' or 'if (var < const)'
> >
> > In the C code it was this:
> >          usize = bpf_get_stack(ctx, raw_data, max_len, BPF_F_USER_STACK);
> >          if (usize < 0)
> >                  return 0;
> >
> >          ksize = bpf_get_stack(ctx, raw_data + usize, max_len - usize, 0);
> >          if (ksize < 0)
> >                  return 0;
> >
> > We used to have problem with pointer arith in R2.
> > Now it's a problem with two integers in R3.
> > 'if (usize < 0)' is comparing R1 and makes it [0,800], but R8 stays [-inf,800].
> > Both registers represent the same 'usize' variable.
> > Then R9 -= R8 is doing 800 - [-inf, 800]
> > so the result of "max_len - usize" looks unbounded to the verifier while
> > it's obvious in C code that "max_len - usize" should be [0, 800].
> >
> > The following diff 'fixes' the issue for no_alu32:
> > diff --git a/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c b/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
> > index 29817a703984..93058136d608 100644
> > --- a/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
> > +++ b/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
> > @@ -2,6 +2,7 @@
> >
> >   #include <linux/bpf.h>
> >   #include <bpf/bpf_helpers.h>
> > +#define var_barrier(a) asm volatile ("" : "=r"(a) : "0"(a))
> >
> >   /* Permit pretty deep stack traces */
> >   #define MAX_STACK_RAWTP 100
> > @@ -84,10 +85,12 @@ int bpf_prog1(void *ctx)
> >                  return 0;
> >
> >          usize = bpf_get_stack(ctx, raw_data, max_len, BPF_F_USER_STACK);
> > +       var_barrier(usize);
> >          if (usize < 0)
> >                  return 0;
> >
> >          ksize = bpf_get_stack(ctx, raw_data + usize, max_len - usize, 0);
> > +       var_barrier(ksize);
> >          if (ksize < 0)
> >                  return 0;
> >
> > But it breaks alu32 case.
> >
> > I'm using llvm 11 fwiw.
> >
> > Long term Yonghong is working on llvm support to emit this kind
> > of workarounds automatically.
> > I'm still thinking what to do next. Ideas?
>

Funny enough, Alexei's fix didn't fix even no_alu32 case for me. Also
have one of the latest clang 11...

> The following source change will make both alu32 and non-alu32 happy:
>
>   SEC("raw_tracepoint/sys_enter")
>   int bpf_prog1(void *ctx)
>   {
> -       int max_len, max_buildid_len, usize, ksize, total_size;
> +       int max_len, max_buildid_len, total_size;
> +       long usize, ksize;

This does fix it, both alu32 and no-alu32 pass.

>          struct stack_trace_t *data;
>          void *raw_data;
>          __u32 key = 0;
>
> I have not checked the reason why it works. Mostly this confirms to
> the function signature so compiler generates more friendly code.

Yes, it's due to the compiler not doing all the casting/bit shifting.
Just straightforward use of a single register consistently across
conditional jump and offset calculations.
