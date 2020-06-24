Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98A3D206D0A
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 08:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389513AbgFXGvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 02:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389338AbgFXGvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 02:51:14 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 274EFC061573;
        Tue, 23 Jun 2020 23:51:14 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id h23so923424qtr.0;
        Tue, 23 Jun 2020 23:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZQE4YvQBARjgNn/6GwkSXJxgkp2xKpAqvWgX0PYG4OM=;
        b=WSAo2cNcFy3k9EJh7FUe9wo7xbNJ2yArWE6QQHJYy8w0aYk1O/BDy9vEirQ5Vovi3B
         94XTY+NchAw3kgL8uA9rrgA2Og5yFt8wLLHVShfne/RGUgZ3Xge6SVSyKI3oROEed65D
         msfoVIenoGij4CV09r3PBmYE3YgkqbaHllEV0IUFmI17V7QVRoq0Y2g79gpyFb3BK3Y+
         8QHm6+D/k/I0S9M7yuYpJqyA9l0hF18tbrLpQ7H2D8zPOmlAQm8a3KTLLmTnn5kreXGA
         ibgNWg2xjGlusa250nZfe5BKitCuAvbEXUbmGG/lHoohxerJFtc/pxkc9V6f5OGQr9/D
         Ez0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZQE4YvQBARjgNn/6GwkSXJxgkp2xKpAqvWgX0PYG4OM=;
        b=J8+vVXrgLueokkol5HLPt7rvzbZfpl6ctAVLkgmilaQfN3jep6oq2HSZqeMDSv2VWM
         I4sfnIfyb2zouINVV5wpqUoAQUI+P6aFNnBZzWS0irLLJ8v1sU5E8OxWFZKMxUzRbTkd
         V4Z/3CwP0NEFIvHiJo9mg2vvYRrTo8uzimbGfQRbMIbs+B3q5y2iEWruqiRem0oQ7DXH
         RB8KIacH5rUSmSEpg8LUpxFSPcZXiIw+4PgMTcCbQSHw59cR3J1MHxkuGzmgQu3YBWtY
         l0UJXrCGFSAWhx9MIjwqwNyp9ZaNsQEgx7qlNhsx69hu5b1z8V66eL5Hdg/1+ZjDdvXz
         7/kg==
X-Gm-Message-State: AOAM5328e+rkNeAe2EVlT8ctD3kY5RIcncNjV8HKTlPWDAqn0aVuanad
        PLCrwgI3NP4/2FoUQHxWptHofjJRIeIqMYYEIuA=
X-Google-Smtp-Source: ABdhPJyXrqTs254Se3wAcsorqSXv+pgjDBhPqsXgNh+1Nlw2b8SqFTwxa0r+XkwHw7ZDgNTVd6K+IRLGVDPfT1NsFrk=
X-Received: by 2002:ac8:64b:: with SMTP id e11mr2862494qth.117.1592981472961;
 Tue, 23 Jun 2020 23:51:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200623032224.4020118-1-andriin@fb.com> <20200623032224.4020118-2-andriin@fb.com>
 <7ed6ada5-2539-3090-0db7-0f65b67e4699@iogearbox.net> <CAEf4BzbsRyt5Y4-oMaKTUNu_ijnRD09+WW3iA+bfGLZcLpd77w@mail.gmail.com>
 <ee6df475-b7d4-b8ed-dc91-560e42d2e7fc@iogearbox.net> <20200623232503.yzm4g24rwx7khudf@ast-mbp.dhcp.thefacebook.com>
 <f1ec2d3b-4897-1a40-e373-51bed4fd3b87@fb.com> <CAEf4BzZTWyii7k6MjdygJP+VfAHnnr8jbxjG1Ge96ioKq5ZEeQ@mail.gmail.com>
 <5ef2ecf4b7bd9_37452b132c4de5bcc@john-XPS-13-9370.notmuch>
In-Reply-To: <5ef2ecf4b7bd9_37452b132c4de5bcc@john-XPS-13-9370.notmuch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 23 Jun 2020 23:51:01 -0700
Message-ID: <CAEf4BzZN+iH1zcH9VfYhe8CLS3LOrBW97e2e6SCsCTC=cThRqA@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 2/3] selftests/bpf: add variable-length data
 concatenation pattern test
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 11:04 PM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> Andrii Nakryiko wrote:
> > On Tue, Jun 23, 2020 at 5:25 PM Yonghong Song <yhs@fb.com> wrote:
> > >
> > >
> > >
> > > On 6/23/20 4:25 PM, Alexei Starovoitov wrote:
> > > > On Tue, Jun 23, 2020 at 11:15:58PM +0200, Daniel Borkmann wrote:
> > > >> On 6/23/20 10:52 PM, Andrii Nakryiko wrote:
> > > >>> On Tue, Jun 23, 2020 at 1:39 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > > >>>> On 6/23/20 5:22 AM, Andrii Nakryiko wrote:
> > > >>>>> Add selftest that validates variable-length data reading and concatentation
> > > >>>>> with one big shared data array. This is a common pattern in production use for
> > > >>>>> monitoring and tracing applications, that potentially can read a lot of data,
> > > >>>>> but overall read much less. Such pattern allows to determine precisely what
> > > >>>>> amount of data needs to be sent over perfbuf/ringbuf and maximize efficiency.
> > > >>>>>
> > > >>>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > >>>>
> > > >>>> Currently getting the below errors on these tests. My last clang/llvm git build
> > > >>>> is on 4676cf444ea2 ("[Clang] Skip adding begin source location for PragmaLoopHint'd
> > > >>>> loop when[...]"):
> > > >>>
> > > >>> Yeah, you need 02553b91da5d ("bpf: bpf_probe_read_kernel_str() has to
> > > >>> return amount of data read on success") from bpf tree.
> > > >>
> > > >> Fair point, it's in net- but not yet in net-next tree, so bpf-next sync needs
> > > >> to wait.
> > > >>
> > > >>> I'm eagerly awaiting bpf being merged into bpf-next :)
> > > >>
> > > >> I'll cherry-pick 02553b91da5d locally for testing and if it passes I'll push
> > > >> these out.
> > > >
> > > > I've merged the bpf_probe_read_kernel_str() fix into bpf-next and 3 extra commits
> > > > prior to that one so that sha of the bpf_probe_read_kernel_str() fix (02553b91da5de)
> > > > is exactly the same in bpf/net/linus/bpf-next. I think that shouldn't cause
> > > > issue during bpf-next pull into net-next and later merge with Linus's tree.
> > > > Crossing fingers, since we're doing this experiment for the first time.
> > > >
> > > > Daniel pushed these 3 commits as well.
> > > > Now varlen and kernel_reloc tests are good, but we have a different issue :(
> > > > ./test_progs-no_alu32 -t get_stack_raw_tp
> > > > is now failing, but for a different reason.
> > > >
> > > > 52: (85) call bpf_get_stack#67
> > > > 53: (bf) r8 = r0
> > > > 54: (bf) r1 = r8
> > > > 55: (67) r1 <<= 32
> > > > 56: (c7) r1 s>>= 32
> > > > ; if (usize < 0)
> > > > 57: (c5) if r1 s< 0x0 goto pc+26
> > > >   R0=inv(id=0,smax_value=800) R1_w=inv(id=0,umax_value=800,var_off=(0x0; 0x3ff)) R6=ctx(id=0,off=0,imm=0) R7=map_value(id=0,off=0,ks=4,vs=1600,imm=0) R8_w=inv(id=0,smax_value=800) R9=inv800 R10=fp0 fp-8=mmmm????
> > > > ; ksize = bpf_get_stack(ctx, raw_data + usize, max_len - usize, 0);
> > > > 58: (1f) r9 -= r8
> > > > ; ksize = bpf_get_stack(ctx, raw_data + usize, max_len - usize, 0);
> > > > 59: (bf) r2 = r7
> > > > 60: (0f) r2 += r1
> > > > regs=1 stack=0 before 52: (85) call bpf_get_stack#67
> > > > ; ksize = bpf_get_stack(ctx, raw_data + usize, max_len - usize, 0);
> > > > 61: (bf) r1 = r6
> > > > 62: (bf) r3 = r9
> > > > 63: (b7) r4 = 0
> > > > 64: (85) call bpf_get_stack#67
> > > >   R0=inv(id=0,smax_value=800) R1_w=ctx(id=0,off=0,imm=0) R2_w=map_value(id=0,off=0,ks=4,vs=1600,umax_value=800,var_off=(0x0; 0x3ff),s32_max_value=1023,u32_max_value=1023) R3_w=inv(id=0,umax_value=9223372036854776608) R4_w=inv0 R6=ctx(id=0?
> > > > R3 unbounded memory access, use 'var &= const' or 'if (var < const)'
> > > >
> > > > In the C code it was this:
> > > >          usize = bpf_get_stack(ctx, raw_data, max_len, BPF_F_USER_STACK);
> > > >          if (usize < 0)
> > > >                  return 0;
> > > >
> > > >          ksize = bpf_get_stack(ctx, raw_data + usize, max_len - usize, 0);
> > > >          if (ksize < 0)
> > > >                  return 0;
> > > >
> > > > We used to have problem with pointer arith in R2.
> > > > Now it's a problem with two integers in R3.
> > > > 'if (usize < 0)' is comparing R1 and makes it [0,800], but R8 stays [-inf,800].
> > > > Both registers represent the same 'usize' variable.
> > > > Then R9 -= R8 is doing 800 - [-inf, 800]
> > > > so the result of "max_len - usize" looks unbounded to the verifier while
> > > > it's obvious in C code that "max_len - usize" should be [0, 800].
> > > >
> > > > The following diff 'fixes' the issue for no_alu32:
> > > > diff --git a/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c b/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
> > > > index 29817a703984..93058136d608 100644
> > > > --- a/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
> > > > +++ b/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
> > > > @@ -2,6 +2,7 @@
> > > >
> > > >   #include <linux/bpf.h>
> > > >   #include <bpf/bpf_helpers.h>
> > > > +#define var_barrier(a) asm volatile ("" : "=r"(a) : "0"(a))
> > > >
> > > >   /* Permit pretty deep stack traces */
> > > >   #define MAX_STACK_RAWTP 100
> > > > @@ -84,10 +85,12 @@ int bpf_prog1(void *ctx)
> > > >                  return 0;
> > > >
> > > >          usize = bpf_get_stack(ctx, raw_data, max_len, BPF_F_USER_STACK);
> > > > +       var_barrier(usize);
> > > >          if (usize < 0)
> > > >                  return 0;
> > > >
> > > >          ksize = bpf_get_stack(ctx, raw_data + usize, max_len - usize, 0);
> > > > +       var_barrier(ksize);
> > > >          if (ksize < 0)
> > > >                  return 0;
> > > >
> > > > But it breaks alu32 case.
> > > >
> > > > I'm using llvm 11 fwiw.
> > > >
> > > > Long term Yonghong is working on llvm support to emit this kind
> > > > of workarounds automatically.
> > > > I'm still thinking what to do next. Ideas?
> > >
> >
> > Funny enough, Alexei's fix didn't fix even no_alu32 case for me. Also
> > have one of the latest clang 11...
> >
> > > The following source change will make both alu32 and non-alu32 happy:
> > >
> > >   SEC("raw_tracepoint/sys_enter")
> > >   int bpf_prog1(void *ctx)
> > >   {
> > > -       int max_len, max_buildid_len, usize, ksize, total_size;
> > > +       int max_len, max_buildid_len, total_size;
> > > +       long usize, ksize;
> >
> > This does fix it, both alu32 and no-alu32 pass.
> >
> > >          struct stack_trace_t *data;
> > >          void *raw_data;
> > >          __u32 key = 0;
> > >
> > > I have not checked the reason why it works. Mostly this confirms to
> > > the function signature so compiler generates more friendly code.
> >
> > Yes, it's due to the compiler not doing all the casting/bit shifting.
> > Just straightforward use of a single register consistently across
> > conditional jump and offset calculations.
>
> Another option is to drop the int->long uapi conversion and write the
> varlen test using >=0 tests. The below diff works for me also using
> recent clang-11, but maybe doesn't resolve Andrii's original issue.
> My concern is if we break existing code in selftests is there a risk
> users will get breaking code as well? Seems like without a few
> additional clang improvements its going to be hard to get all
> combinations working by just fiddling with the types.

I have bad news for you, John. Try running your variant of test_varlen
on, say, 5.6 kernel (upstream version). Both alu32 and no-alu32
version fail (that's with int helpers, of course):

libbpf: load bpf program failed: Permission denied
libbpf: -- BEGIN DUMP LOG ---
libbpf:
arg#0 type is not a struct
Unrecognized arg#0 type PTR
; int pid = bpf_get_current_pid_tgid() >> 32;
0: (85) call bpf_get_current_pid_tgid#14
; if (test_pid != pid || !capture)
1: (18) r1 = 0xffffc90000132200
3: (61) r1 = *(u32 *)(r1 +0)
 R0_w=inv(id=0) R1_w=map_value(id=0,off=512,ks=4,vs=1056,imm=0) R10=fp0
; int pid = bpf_get_current_pid_tgid() >> 32;
4: (77) r0 >>= 32
; if (test_pid != pid || !capture)
5: (5e) if w1 != w0 goto pc+37
 R0_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff))
R1_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff)) R10=fp0
6: (18) r1 = 0xffffc90000132204
8: (71) r1 = *(u8 *)(r1 +0)
 R0_w=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff))
R1_w=map_value(id=0,off=516,ks=4,vs=1056,imm=0) R10=fp0
9: (16) if w1 == 0x0 goto pc+33
 R0=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff))
R1=inv(id=0,umax_value=255,var_off=(0x0; 0xff)) R10=fp0
; len = bpf_probe_read_kernel_str(payload, MAX_LEN, &buf_in1[0]);
10: (18) r6 = 0xffffc90000129218
12: (18) r1 = 0xffffc90000129218
14: (b4) w2 = 256
15: (18) r3 = 0xffffc90000132000
17: (85) call bpf_probe_read_kernel_str#115
 R0=inv(id=0,umax_value=4294967295,var_off=(0x0; 0xffffffff))
R1_w=map_value(id=0,off=536,ks=4,vs=1572,imm=0) R2_w=inv256
R3_w=map_value(id=0,off=0,ks=4,vs=1056,imm=0)
R6_w=map_value(id=0,off=536,ks=4,vs=1572,imm=0) R10=fp0
last_idx 17 first_idx 9
regs=4 stack=0 before 15: (18) r3 = 0xffffc90000132000
regs=4 stack=0 before 14: (b4) w2 = 256
; if (len >= 0) {
18: (c6) if w0 s< 0x0 goto pc+7
 R0_w=inv(id=0) R6_w=map_value(id=0,off=536,ks=4,vs=1572,imm=0) R10=fp0
; payload3_len1 = len;
19: (18) r1 = 0xffffc9000012920c
21: (63) *(u32 *)(r1 +0) = r0
 R0_w=inv(id=0) R1_w=map_value(id=0,off=524,ks=4,vs=1572,imm=0)
R6_w=map_value(id=0,off=536,ks=4,vs=1572,imm=0) R10=fp0
; len = bpf_probe_read_kernel_str(payload, MAX_LEN, &buf_in1[0]);
22: (bc) w1 = w0
; payload += len;
23: (18) r6 = 0xffffc90000129218
25: (0f) r6 += r1
last_idx 25 first_idx 9
regs=2 stack=0 before 23: (18) r6 = 0xffffc90000129218
regs=2 stack=0 before 22: (bc) w1 = w0
regs=1 stack=0 before 21: (63) *(u32 *)(r1 +0) = r0
regs=1 stack=0 before 19: (18) r1 = 0xffffc9000012920c
regs=1 stack=0 before 18: (c6) if w0 s< 0x0 goto pc+7
regs=1 stack=0 before 17: (85) call bpf_probe_read_kernel_str#115
; len = bpf_probe_read_kernel_str(payload, MAX_LEN, &buf_in2[0]);
26: (bf) r1 = r6
27: (b4) w2 = 256
28: (18) r3 = 0xffffc90000132100
30: (85) call bpf_probe_read_kernel_str#115
 R0=inv(id=0) R1_w=map_value(id=0,off=536,ks=4,vs=1572,umax_value=4294967295,var_off=(0x0;
0xffffffff)) R2_w=inv256
R3_w=map_value(id=0,off=256,ks=4,vs=1056,imm=0)
R6=map_value(id=0,off=536,ks=4,vs=1572,umax_value=4294967295,var_off=(0x00
R1 unbounded memory access, make sure to bounds check any array access
into a map
processed 23 insns (limit 1000000) max_states_per_insn 0 total_states
2 peak_states 2 mark_read 1

libbpf: -- END LOG --
libbpf: failed to load program 'raw_tp/sys_exit'
libbpf: failed to load object 'test_varlen'
libbpf: failed to load BPF skeleton 'test_varlen': -4007
test_varlen:FAIL:skel_open failed to open skeleton
#88 varlen:FAIL
Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED


Disassembly of section raw_tp/sys_exit:

0000000000000000 <handler64_signed>:
       0:       85 00 00 00 0e 00 00 00 call 14
       1:       18 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 r1 = 0 ll
       3:       61 11 00 00 00 00 00 00 r1 = *(u32 *)(r1 + 0)
       4:       77 00 00 00 20 00 00 00 r0 >>= 32
       5:       5e 01 25 00 00 00 00 00 if w1 != w0 goto +37 <LBB1_7>
       6:       18 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 r1 = 0 ll
       8:       71 11 00 00 00 00 00 00 r1 = *(u8 *)(r1 + 0)
       9:       16 01 21 00 00 00 00 00 if w1 == 0 goto +33 <LBB1_7>
      10:       18 06 00 00 00 00 00 00 00 00 00 00 00 00 00 00 r6 = 0 ll
      12:       18 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 r1 = 0 ll
      14:       b4 02 00 00 00 01 00 00 w2 = 256
      15:       18 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 r3 = 0 ll
      17:       85 00 00 00 73 00 00 00 call 115
      18:       c6 00 07 00 00 00 00 00 if w0 s< 0 goto +7 <LBB1_4>
      19:       18 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 r1 = 0 ll
      21:       63 01 00 00 00 00 00 00 *(u32 *)(r1 + 0) = r0
      22:       bc 01 00 00 00 00 00 00 w1 = w0
      23:       18 06 00 00 00 00 00 00 00 00 00 00 00 00 00 00 r6 = 0 ll
      25:       0f 16 00 00 00 00 00 00 r6 += r1

00000000000000d0 <LBB1_4>:
      26:       bf 61 00 00 00 00 00 00 r1 = r6
      27:       b4 02 00 00 00 01 00 00 w2 = 256
      28:       18 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 r3 = 0 ll
      30:       85 00 00 00 73 00 00 00 call 115
      31:       c6 00 05 00 00 00 00 00 if w0 s< 0 goto +5 <LBB1_6>
      32:       18 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 r1 = 0 ll
      34:       63 01 00 00 00 00 00 00 *(u32 *)(r1 + 0) = r0
      35:       bc 01 00 00 00 00 00 00 w1 = w0
      36:       0f 16 00 00 00 00 00 00 r6 += r1

0000000000000128 <LBB1_6>:
      37:       18 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 r1 = 0 ll
      39:       1c 16 00 00 00 00 00 00 w6 -= w1
      40:       18 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 r1 = 0 ll
      42:       63 61 00 00 00 00 00 00 *(u32 *)(r1 + 0) = r6

0000000000000158 <LBB1_7>:
      43:       b4 00 00 00 00 00 00 00 w0 = 0
      44:       95 00 00 00 00 00 00 00 exit


ALU32 code looks ok, but it's probably those verifier bugs that you've
fixed just recently that make it impossible to use? Don't know. So one
needs a quite recent kernel to make such code pattern work, while
unsigned variant works fine in practice.

Now, my variant also fails on 5.6 with default int helpers. If we have
longs, though, it suddenly works! Both alu32 and no-alu32!

And it makes sense, that's what I've been arguing all along. long
represent reality, it causes more straightforward code generation, if
you don't aritifically down-cast types. Even with downcasted types, in
many cases it's ok. If there are regressions (which are probably
impossible to avoid, unfortunately), at least in theory just casting
bpf helper's return result to int should be equivalent:

int len = (int)bpf_read_probe_str(...)

But even better is to just fix types of your local variables to match
native BPF size.

> Seems like without a few
> additional clang improvements its going to be hard to get all
> combinations working by just fiddling with the types.

I'd like to see the case yet in which synchronizing types didn't help, actually.

>
> diff --git a/tools/testing/selftests/bpf/progs/test_varlen.c b/tools/testing/selftests/bpf/progs/test_varlen.c
> index 0969185..01c992c 100644
> --- a/tools/testing/selftests/bpf/progs/test_varlen.c
> +++ b/tools/testing/selftests/bpf/progs/test_varlen.c
> @@ -31,20 +31,20 @@ int handler64(void *regs)

[...]
