Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8AE820797E
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 18:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404859AbgFXQs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 12:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404017AbgFXQs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 12:48:56 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6619AC061573;
        Wed, 24 Jun 2020 09:48:56 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id a12so2872812ion.13;
        Wed, 24 Jun 2020 09:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=j+vupQwJgJpD6TXcNKxzMwgs+LZz1XG6+iLLZ6A1ZqM=;
        b=ihAik6ryxNDy40B3iFsuWHDd27JPhZdwoj5gqbIBq7ULPmIQKBGUsv4zBKdm9biOFX
         G4bf002ryD6lBoyG3k1LS0j32D8ZLsBeE85msMlZco/M6oGgACCrEMriauN9WKdYg6Zc
         XEh3Y+sy6C0TT0Y8j7boExKV/RzCRrST9r3LhtpJ1hCpjizeVjYSfQa35x60y8mjjR0f
         qa2JCT2Etxk1qFKrrRRg7Qh/OeILrDSBiRM/W6viOEKjNoK51CGZV/PTV/bC8maN1+Hn
         LKQIYY0LsdIHRDrir0m+N1ssg9KRcpXyDtFt6tCK8QNK6lbcNyPuF8v4WdnhSFnnAI9E
         JYrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=j+vupQwJgJpD6TXcNKxzMwgs+LZz1XG6+iLLZ6A1ZqM=;
        b=nifEKLC7xUw+BMVrySFDVr7FvryAzMZ2pQjDNZEYGJLR6luZpuE9R+qd+zDem1Vkk0
         hL3ZtAXwDL5rCpzG842dejcHMAD6KeV+3hLYN3okWW6P8n/rSAkMvk9b5Abx3cIVcsyt
         42PqnDOPYPvX1JKhc8AZzTAQlyc8eG7I6Rh0Zt4K4HuGR+xo0K//r0y0i5DcFjzK8BzV
         VZjCqUxhuKwYGYJu9Q5HgKk2Njlyc5b7ujVJdxsk706H44HVarMUgmF/dP09O7jf8l9n
         RVLZAwF/1B8c2kF56bLQ10yt2kJDUCpvqiShM+YBtPGCxYUbunPnzoOqfNf6aHcD61uX
         q4uQ==
X-Gm-Message-State: AOAM531p1PYWAT4qoAjY0+AE4tJXmDqVtceraZRPKUQ+WUC5mDWjhOYu
        cUu2lMV84WOscdvFCElq8mI=
X-Google-Smtp-Source: ABdhPJwR7CHz/Z7lXi2MLm+yLMtEvGU1cm/wAMkJPWPC4dyHfbWa+jblxSsCEnxtCGJGUt8dj111wQ==
X-Received: by 2002:a6b:14cc:: with SMTP id 195mr31857855iou.117.1593017335451;
        Wed, 24 Jun 2020 09:48:55 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id a10sm11501589ilb.31.2020.06.24.09.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 09:48:54 -0700 (PDT)
Date:   Wed, 24 Jun 2020 09:48:47 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>
Message-ID: <5ef383efe8a58_1e202b09a37705c4dc@john-XPS-13-9370.notmuch>
In-Reply-To: <CAEf4BzZN+iH1zcH9VfYhe8CLS3LOrBW97e2e6SCsCTC=cThRqA@mail.gmail.com>
References: <20200623032224.4020118-1-andriin@fb.com>
 <20200623032224.4020118-2-andriin@fb.com>
 <7ed6ada5-2539-3090-0db7-0f65b67e4699@iogearbox.net>
 <CAEf4BzbsRyt5Y4-oMaKTUNu_ijnRD09+WW3iA+bfGLZcLpd77w@mail.gmail.com>
 <ee6df475-b7d4-b8ed-dc91-560e42d2e7fc@iogearbox.net>
 <20200623232503.yzm4g24rwx7khudf@ast-mbp.dhcp.thefacebook.com>
 <f1ec2d3b-4897-1a40-e373-51bed4fd3b87@fb.com>
 <CAEf4BzZTWyii7k6MjdygJP+VfAHnnr8jbxjG1Ge96ioKq5ZEeQ@mail.gmail.com>
 <5ef2ecf4b7bd9_37452b132c4de5bcc@john-XPS-13-9370.notmuch>
 <CAEf4BzZN+iH1zcH9VfYhe8CLS3LOrBW97e2e6SCsCTC=cThRqA@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 2/3] selftests/bpf: add variable-length data
 concatenation pattern test
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> On Tue, Jun 23, 2020 at 11:04 PM John Fastabend
> <john.fastabend@gmail.com> wrote:
> >
> > Andrii Nakryiko wrote:
> > > On Tue, Jun 23, 2020 at 5:25 PM Yonghong Song <yhs@fb.com> wrote:
> > > >
> > > >
> > > >
> > > > On 6/23/20 4:25 PM, Alexei Starovoitov wrote:
> > > > > On Tue, Jun 23, 2020 at 11:15:58PM +0200, Daniel Borkmann wrote:
> > > > >> On 6/23/20 10:52 PM, Andrii Nakryiko wrote:
> > > > >>> On Tue, Jun 23, 2020 at 1:39 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > > > >>>> On 6/23/20 5:22 AM, Andrii Nakryiko wrote:
> > > > >>>>> Add selftest that validates variable-length data reading and concatentation
> > > > >>>>> with one big shared data array. This is a common pattern in production use for
> > > > >>>>> monitoring and tracing applications, that potentially can read a lot of data,
> > > > >>>>> but overall read much less. Such pattern allows to determine precisely what
> > > > >>>>> amount of data needs to be sent over perfbuf/ringbuf and maximize efficiency.
> > > > >>>>>
> > > > >>>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > > >>>>
> > > > >>>> Currently getting the below errors on these tests. My last clang/llvm git build
> > > > >>>> is on 4676cf444ea2 ("[Clang] Skip adding begin source location for PragmaLoopHint'd
> > > > >>>> loop when[...]"):
> > > > >>>
> > > > >>> Yeah, you need 02553b91da5d ("bpf: bpf_probe_read_kernel_str() has to
> > > > >>> return amount of data read on success") from bpf tree.
> > > > >>
> > > > >> Fair point, it's in net- but not yet in net-next tree, so bpf-next sync needs
> > > > >> to wait.
> > > > >>
> > > > >>> I'm eagerly awaiting bpf being merged into bpf-next :)
> > > > >>
> > > > >> I'll cherry-pick 02553b91da5d locally for testing and if it passes I'll push
> > > > >> these out.
> > > > >
> > > > > I've merged the bpf_probe_read_kernel_str() fix into bpf-next and 3 extra commits
> > > > > prior to that one so that sha of the bpf_probe_read_kernel_str() fix (02553b91da5de)
> > > > > is exactly the same in bpf/net/linus/bpf-next. I think that shouldn't cause
> > > > > issue during bpf-next pull into net-next and later merge with Linus's tree.
> > > > > Crossing fingers, since we're doing this experiment for the first time.
> > > > >
> > > > > Daniel pushed these 3 commits as well.
> > > > > Now varlen and kernel_reloc tests are good, but we have a different issue :(
> > > > > ./test_progs-no_alu32 -t get_stack_raw_tp
> > > > > is now failing, but for a different reason.
> > > > >
> > > > > 52: (85) call bpf_get_stack#67
> > > > > 53: (bf) r8 = r0
> > > > > 54: (bf) r1 = r8
> > > > > 55: (67) r1 <<= 32
> > > > > 56: (c7) r1 s>>= 32
> > > > > ; if (usize < 0)
> > > > > 57: (c5) if r1 s< 0x0 goto pc+26
> > > > >   R0=inv(id=0,smax_value=800) R1_w=inv(id=0,umax_value=800,var_off=(0x0; 0x3ff)) R6=ctx(id=0,off=0,imm=0) R7=map_value(id=0,off=0,ks=4,vs=1600,imm=0) R8_w=inv(id=0,smax_value=800) R9=inv800 R10=fp0 fp-8=mmmm????
> > > > > ; ksize = bpf_get_stack(ctx, raw_data + usize, max_len - usize, 0);
> > > > > 58: (1f) r9 -= r8
> > > > > ; ksize = bpf_get_stack(ctx, raw_data + usize, max_len - usize, 0);
> > > > > 59: (bf) r2 = r7
> > > > > 60: (0f) r2 += r1
> > > > > regs=1 stack=0 before 52: (85) call bpf_get_stack#67
> > > > > ; ksize = bpf_get_stack(ctx, raw_data + usize, max_len - usize, 0);
> > > > > 61: (bf) r1 = r6
> > > > > 62: (bf) r3 = r9
> > > > > 63: (b7) r4 = 0
> > > > > 64: (85) call bpf_get_stack#67
> > > > >   R0=inv(id=0,smax_value=800) R1_w=ctx(id=0,off=0,imm=0) R2_w=map_value(id=0,off=0,ks=4,vs=1600,umax_value=800,var_off=(0x0; 0x3ff),s32_max_value=1023,u32_max_value=1023) R3_w=inv(id=0,umax_value=9223372036854776608) R4_w=inv0 R6=ctx(id=0?
> > > > > R3 unbounded memory access, use 'var &= const' or 'if (var < const)'
> > > > >
> > > > > In the C code it was this:
> > > > >          usize = bpf_get_stack(ctx, raw_data, max_len, BPF_F_USER_STACK);
> > > > >          if (usize < 0)
> > > > >                  return 0;
> > > > >
> > > > >          ksize = bpf_get_stack(ctx, raw_data + usize, max_len - usize, 0);
> > > > >          if (ksize < 0)
> > > > >                  return 0;
> > > > >
> > > > > We used to have problem with pointer arith in R2.
> > > > > Now it's a problem with two integers in R3.
> > > > > 'if (usize < 0)' is comparing R1 and makes it [0,800], but R8 stays [-inf,800].
> > > > > Both registers represent the same 'usize' variable.
> > > > > Then R9 -= R8 is doing 800 - [-inf, 800]
> > > > > so the result of "max_len - usize" looks unbounded to the verifier while
> > > > > it's obvious in C code that "max_len - usize" should be [0, 800].
> > > > >
> > > > > The following diff 'fixes' the issue for no_alu32:
> > > > > diff --git a/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c b/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
> > > > > index 29817a703984..93058136d608 100644
> > > > > --- a/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
> > > > > +++ b/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
> > > > > @@ -2,6 +2,7 @@
> > > > >
> > > > >   #include <linux/bpf.h>
> > > > >   #include <bpf/bpf_helpers.h>
> > > > > +#define var_barrier(a) asm volatile ("" : "=r"(a) : "0"(a))
> > > > >
> > > > >   /* Permit pretty deep stack traces */
> > > > >   #define MAX_STACK_RAWTP 100
> > > > > @@ -84,10 +85,12 @@ int bpf_prog1(void *ctx)
> > > > >                  return 0;
> > > > >
> > > > >          usize = bpf_get_stack(ctx, raw_data, max_len, BPF_F_USER_STACK);
> > > > > +       var_barrier(usize);
> > > > >          if (usize < 0)
> > > > >                  return 0;
> > > > >
> > > > >          ksize = bpf_get_stack(ctx, raw_data + usize, max_len - usize, 0);
> > > > > +       var_barrier(ksize);
> > > > >          if (ksize < 0)
> > > > >                  return 0;
> > > > >
> > > > > But it breaks alu32 case.
> > > > >
> > > > > I'm using llvm 11 fwiw.
> > > > >
> > > > > Long term Yonghong is working on llvm support to emit this kind
> > > > > of workarounds automatically.
> > > > > I'm still thinking what to do next. Ideas?
> > > >
> > >
> > > Funny enough, Alexei's fix didn't fix even no_alu32 case for me. Also
> > > have one of the latest clang 11...
> > >
> > > > The following source change will make both alu32 and non-alu32 happy:
> > > >
> > > >   SEC("raw_tracepoint/sys_enter")
> > > >   int bpf_prog1(void *ctx)
> > > >   {
> > > > -       int max_len, max_buildid_len, usize, ksize, total_size;
> > > > +       int max_len, max_buildid_len, total_size;
> > > > +       long usize, ksize;
> > >
> > > This does fix it, both alu32 and no-alu32 pass.
> > >
> > > >          struct stack_trace_t *data;
> > > >          void *raw_data;
> > > >          __u32 key = 0;
> > > >
> > > > I have not checked the reason why it works. Mostly this confirms to
> > > > the function signature so compiler generates more friendly code.
> > >
> > > Yes, it's due to the compiler not doing all the casting/bit shifting.
> > > Just straightforward use of a single register consistently across
> > > conditional jump and offset calculations.
> >
> > Another option is to drop the int->long uapi conversion and write the
> > varlen test using >=0 tests. The below diff works for me also using
> > recent clang-11, but maybe doesn't resolve Andrii's original issue.
> > My concern is if we break existing code in selftests is there a risk
> > users will get breaking code as well? Seems like without a few
> > additional clang improvements its going to be hard to get all
> > combinations working by just fiddling with the types.
> 
> I have bad news for you, John. Try running your variant of test_varlen
> on, say, 5.6 kernel (upstream version). Both alu32 and no-alu32
> version fail (that's with int helpers, of course):

OK. 

[...]

> 
> ALU32 code looks ok, but it's probably those verifier bugs that you've
> fixed just recently that make it impossible to use? Don't know. So one
> needs a quite recent kernel to make such code pattern work, while
> unsigned variant works fine in practice.

Correct bounds tracking broke above.

>
> Now, my variant also fails on 5.6 with default int helpers. If we have
> longs, though, it suddenly works! Both alu32 and no-alu32!

OK that is a win.

> 
> And it makes sense, that's what I've been arguing all along. long
> represent reality, it causes more straightforward code generation, if
> you don't aritifically down-cast types. Even with downcasted types, in
> many cases it's ok. If there are regressions (which are probably
> impossible to avoid, unfortunately), at least in theory just casting
> bpf helper's return result to int should be equivalent:
> 
> int len = (int)bpf_read_probe_str(...)
> 
> But even better is to just fix types of your local variables to match
> native BPF size.

I've already done this on code I own so no problem from me.

> 
> > Seems like without a few
> > additional clang improvements its going to be hard to get all
> > combinations working by just fiddling with the types.
> 
> I'd like to see the case yet in which synchronizing types didn't help, actually.

The case is when the output of read_probe_str(..) is fed back into
a call with an int arg. But we can probably change those to longs
as well. At any rate its obscure and arguably those types just
need to be syncchronized as well.

For what its worth I'm not try to stop the patch I ACKed it at
one point I believe. As long as the <=0 test continues to work
which it does I'm happy. Mostly the point I wanted to make is
the bpf-next verifier is happy with either code. I briefly
forgot you also want to push this into libbpf github most
likely and run it everywhere.

> 
> >
> > diff --git a/tools/testing/selftests/bpf/progs/test_varlen.c b/tools/testing/selftests/bpf/progs/test_varlen.c
> > index 0969185..01c992c 100644
> > --- a/tools/testing/selftests/bpf/progs/test_varlen.c
> > +++ b/tools/testing/selftests/bpf/progs/test_varlen.c
> > @@ -31,20 +31,20 @@ int handler64(void *regs)
> 
> [...]


