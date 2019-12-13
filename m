Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0914911DEEB
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 08:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbfLMHwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 02:52:00 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45468 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbfLMHwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 02:52:00 -0500
Received: by mail-qk1-f194.google.com with SMTP id x1so980403qkl.12;
        Thu, 12 Dec 2019 23:51:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eOhZfdsH4ZhnMM3thVTXjE27rl7mYEWauYsiEfwcDD0=;
        b=obp+yA92U2syhauhwW6v2bdT3q9+Q5EL5LmbuXRmvLg2xvGT+ACMcOJ1YIgVmo4PKq
         MWphTyLc04ATrsGNik520qobH3NVr4VI6Ar1nGBQuK22J9ds8RuY82Bb8gqPiWFg+JVP
         NI/iWJBJZQS1PdrZh34MI5Ujrw+GZtcC76Do7k4nMzwwfcxN6IRI/wVSjs4020yZs7nA
         XO69MaOMnAkKo3MI1BQ+8grYKd9c1P9tlSxAtITZJoBotlclPndj9ssC/L5aNPfhk1Nv
         L1/ETgq5NaCy4FSQ9WqjFrZwmVryyZax0hKVrDJWDB2NfNttohXjQnLbykJhiMYznijY
         3aBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eOhZfdsH4ZhnMM3thVTXjE27rl7mYEWauYsiEfwcDD0=;
        b=aIWReTcpFvtE60y8CoWKZfP9WvJcNfofi2bZTyX7X/86fjylu/QAwLdZZdZ+fQ3ZDQ
         yKb8GEBkgQVCKUMCIp4pNokxlMFXlFcSc7ygopDUamdpdHZkgowjg+7iSSuQcEtdv+eK
         EzNhPEAvlON4+nWEypQV1TGUUpYA+2EO6XUKsRsUHlj+ge25hfqf7WSYL1+9yyFjyrM5
         alJHdGZKR+LvnHlaf0Tc8e0hPMRHyChmZxpg1zM2TSmZ1hI63N9A3CSV57ucSXEbdXVg
         NIXjMZrgcmuyhzuefaEOssl22N+TTkiGzFKhT5t2owOxKopI04s8W9fLhfg1YfoHl8pF
         D1Eg==
X-Gm-Message-State: APjAAAX/3cuz94Lo9jN6XlL10YT6zeM+Ttc2Q4/jrSm3x12gVdgMoWH6
        Dt+cxQzmGvG9E3116KC7sUQT4WD6UE8ky1qOdTA=
X-Google-Smtp-Source: APXvYqwX9F0EfpmPBESc2noLsOrfss42HsBRxiULHkc0HzCWWXs8hq3weanQIQ8OMT3JkQIPUo5AYPWAxDRqOcqQD8o=
X-Received: by 2002:a37:9c0f:: with SMTP id f15mr12326770qke.297.1576223518916;
 Thu, 12 Dec 2019 23:51:58 -0800 (PST)
MIME-Version: 1.0
References: <20191211123017.13212-1-bjorn.topel@gmail.com> <20191211123017.13212-3-bjorn.topel@gmail.com>
 <20191213053054.l3o6xlziqzwqxq22@ast-mbp>
In-Reply-To: <20191213053054.l3o6xlziqzwqxq22@ast-mbp>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 13 Dec 2019 08:51:47 +0100
Message-ID: <CAJ+HfNiYHM1v8SXs54rkT86MrNxuB5V_KyHjwYupcjUsMf1nSQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/6] bpf: introduce BPF dispatcher
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <thoiland@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Dec 2019 at 06:30, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Dec 11, 2019 at 01:30:13PM +0100, Bj=C3=B6rn T=C3=B6pel wrote:
> > +
> > +#define DEFINE_BPF_DISPATCHER(name)                                  \
> > +     unsigned int name##func(                                        \
> > +             const void *xdp_ctx,                                    \
> > +             const struct bpf_insn *insnsi,                          \
> > +             unsigned int (*bpf_func)(const void *,                  \
> > +                                      const struct bpf_insn *))      \
> > +     {                                                               \
> > +             return bpf_func(xdp_ctx, insnsi);                       \
> > +     }                                                               \
> > +     EXPORT_SYMBOL(name##func);                      \
> > +     struct bpf_dispatcher name =3D BPF_DISPATCHER_INIT(name);
>
> The dispatcher function is a normal function. EXPORT_SYMBOL doesn't make =
it
> 'noinline'. struct bpf_dispatcher takes a pointer to it and that address =
is
> used for text_poke.
>
> In patch 3 __BPF_PROG_RUN calls dfunc() from two places.
> What stops compiler from inlining it? Or partially inlining it in one
> or the other place?
>

Good catch. No inlining for the XDP dispatcher is possible, since the
trampoline function is in a different compilation unit (filter.o),
than the users of bpf_prog_run_xdp(). Turning on LTO, this would no
longer be true. So, *not* having it marked as noinline is a bug.

> I guess it works, because your compiler didn't inline it?
> Could you share how asm looks for bpf_prog_run_xdp()
> (where __BPF_PROG_RUN is called) and asm for name##func() ?
>

Sure! bpf_prog_run_xdp() is always inlined, so let's look at:
net/bpf/test_run.c:bpf_test_run:

        if (xdp)
            *retval =3D bpf_prog_run_xdp(prog, ctx);
        else
            *retval =3D BPF_PROG_RUN(prog, ctx);

translates to:

   0xffffffff8199f522 <+162>:   nopl   0x0(%rax,%rax,1)
./include/linux/filter.h:
716             return __BPF_PROG_RUN(prog, xdp,
   0xffffffff8199f527 <+167>:   mov    0x30(%rbp),%rdx
   0xffffffff8199f52b <+171>:   mov    %r14,%rsi
   0xffffffff8199f52e <+174>:   mov    %r13,%rdi
   0xffffffff8199f531 <+177>:   callq  0xffffffff819586d0
<bpf_dispatcher_xdpfunc>
   0xffffffff8199f536 <+182>:   mov    %eax,%ecx

net/bpf/test_run.c:
48                              *retval =3D BPF_PROG_RUN(prog, ctx);
   0xffffffff8199f538 <+184>:   mov    (%rsp),%rax
   0xffffffff8199f53c <+188>:   mov    %ecx,(%rax)
...
net/bpf/test_run.c:
45                      if (xdp)
   0xffffffff8199f582 <+258>:   test   %r15b,%r15b
   0xffffffff8199f585 <+261>:   jne    0xffffffff8199f522 <bpf_test_run+162=
>
   0xffffffff8199f587 <+263>:   nopl   0x0(%rax,%rax,1)

./include/linux/bpf.h:
497             return bpf_func(ctx, insnsi);
   0xffffffff8199f58c <+268>:   mov    0x30(%rbp),%rax
   0xffffffff8199f590 <+272>:   mov    %r14,%rsi
   0xffffffff8199f593 <+275>:   mov    %r13,%rdi
   0xffffffff8199f596 <+278>:   callq  0xffffffff81e00eb0
<__x86_indirect_thunk_rax>
   0xffffffff8199f59b <+283>:   mov    %eax,%ecx
   0xffffffff8199f59d <+285>:   jmp    0xffffffff8199f538 <bpf_test_run+184=
>

The "dfunc":

net/core/filter.c:
8944    DEFINE_BPF_DISPATCHER(bpf_dispatcher_xdp)
   0xffffffff819586d0 <+0>:     callq  0xffffffff81c01680 <__fentry__>
   0xffffffff819586d5 <+5>:     jmpq   0xffffffff81e00f10
<__x86_indirect_thunk_rdx>


> I hope my guess that compiler didn't inline it is correct. Then extra noi=
nline
> will not hurt and that's the only thing needed to avoid the issue.
>

I'd say it's broken not marking it as noinline, and I was lucky. It
would break if other BPF entrypoints that are being called from
filter.o would appear. I'll wait for more comments, and respin a v5
after the weekend.


Thanks,
Bj=C3=B6rn
