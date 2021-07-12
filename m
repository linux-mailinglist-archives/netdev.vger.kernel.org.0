Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7445F3C6701
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 01:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbhGLXf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 19:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbhGLXf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 19:35:26 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A72FC0613DD;
        Mon, 12 Jul 2021 16:32:37 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id k184so31738338ybf.12;
        Mon, 12 Jul 2021 16:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PZPtH4nVdxlVXkZmk51f+RlarZoc6wW1S0RE0OujGy0=;
        b=YjQK7qfppcSq3P/TkSX0iKabfN/zXXobkOItLw1RPAzgLFkqJwf14Kh9yQCr+iiWUv
         Iy9r6wiQwJayjH79DWEM+QKtK2Y/WHdnnaZMAclg2ed20X1A5f4uB1dxNOc070yM8TwX
         KSrk/LZk6N6kj32z1PwNnp37GfCfUgUVBB1IgZCq/rZwDfhkI8MXF6WVnk2NIJENT9VQ
         S03xlMB9CYy7oPnYZqGJmbLaNScVfWjgPqyeHgPMS8XhlmZxlHrNdf26vK8Ge776bb+q
         z1T2tFtE/VyCS0n9hf10/3l7/3oxd3vWrssgm19cD8jXG63vvJt/lqkGVyqM1jLUF/LG
         Exsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PZPtH4nVdxlVXkZmk51f+RlarZoc6wW1S0RE0OujGy0=;
        b=XrZND3ngVTheL1brlmqfwr/uUlO9nBG0Yi2aEcKMWtCBunyHCwVffIrFXowheQvGvK
         yIBRCE3MeBP0PsYtyZ8jihbrhT3GfF+0Q4YThmiI/Fc3IoLSyui+B9vms+l0ueuajRVu
         0KlpdKA8hfVU2QRxPWmMon/i5t/D4szYik//TFO7SKYEIncMFneopXQ8uoKchqz8xRQU
         uwrO5OZbckJyPbbO7P8NSDTOMuI/76h+MeT8gYjKnFEoAob9KwJnd1o7ig+xv/ttZeWw
         qtg2nNrnpZVZ+DVYqu6fkzzesW2GxP44wxcCq76Kl3bb1VjN9V+zD2He1v6ZK55t43kV
         hm/w==
X-Gm-Message-State: AOAM533JjimOSBxv6WklK06mkgJs/EbqvGEkaWwMowWR60Z6tFeb0NeG
        WUgMC20OteNpJEpi0ey9Z2nACRWtDdwkDwvm5OA=
X-Google-Smtp-Source: ABdhPJx1IutpkW/TgoAbxFW4w5X6X9Jjk3DSYhzGzkIb8BzyeyRns/ckqWWcZ/kjdyNhDoj6qrT3jTAu/PoVQNMkJtY=
X-Received: by 2002:a25:1455:: with SMTP id 82mr1920085ybu.403.1626132756474;
 Mon, 12 Jul 2021 16:32:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210707214751.159713-1-jolsa@kernel.org> <20210707214751.159713-8-jolsa@kernel.org>
 <CAEf4Bzb9DTtGWubdEgMYirWLT-AiYbU2LfB-cSpGNzk6L0z8Kg@mail.gmail.com> <YOsEsb1sMasi1WyR@krava>
In-Reply-To: <YOsEsb1sMasi1WyR@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 12 Jul 2021 16:32:25 -0700
Message-ID: <CAEf4BzYQfe6-UngVn=kTE9gg6Gc7HFdDQ2NGX7p0+uuO27RETA@mail.gmail.com>
Subject: Re: [PATCHv3 bpf-next 7/7] selftests/bpf: Add test for
 bpf_get_func_ip in kprobe+offset probe
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alan Maguire <alan.maguire@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 11, 2021 at 7:48 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Wed, Jul 07, 2021 at 05:18:49PM -0700, Andrii Nakryiko wrote:
> > On Wed, Jul 7, 2021 at 2:54 PM Jiri Olsa <jolsa@redhat.com> wrote:
> > >
> > > Adding test for bpf_get_func_ip in kprobe+ofset probe.
> >
> > typo: offset
> >
> > > Because of the offset value it's arch specific, adding
> > > it only for x86_64 architecture.
> >
> > I'm not following, you specified +0x5 offset explicitly, why is this
> > arch-specific?
>
> I need some instruction offset != 0 in the traced function,
> x86_64's fentry jump is 5 bytes, other archs will be different

Right, ok. I don't see an easy way to detect this offset, but the
#ifdef __x86_64__ detection doesn't work because we are compiling with
-target bpf. Please double-check that it actually worked in the first
place.

I think a better way would be to have test6 defined unconditionally in
BPF code, but then disable loading test6 program on anything but
x86_64 platform at runtime with bpf_program__set_autoload(false).

>
> >
> > >
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> > >  .../testing/selftests/bpf/progs/get_func_ip_test.c  | 13 +++++++++++++
> > >  1 file changed, 13 insertions(+)
> > >
> > > diff --git a/tools/testing/selftests/bpf/progs/get_func_ip_test.c b/tools/testing/selftests/bpf/progs/get_func_ip_test.c
> > > index 8ca54390d2b1..e8a9428a0ea3 100644
> > > --- a/tools/testing/selftests/bpf/progs/get_func_ip_test.c
> > > +++ b/tools/testing/selftests/bpf/progs/get_func_ip_test.c
> > > @@ -10,6 +10,7 @@ extern const void bpf_fentry_test2 __ksym;
> > >  extern const void bpf_fentry_test3 __ksym;
> > >  extern const void bpf_fentry_test4 __ksym;
> > >  extern const void bpf_modify_return_test __ksym;
> > > +extern const void bpf_fentry_test6 __ksym;
> > >
> > >  __u64 test1_result = 0;
> > >  SEC("fentry/bpf_fentry_test1")
> > > @@ -60,3 +61,15 @@ int BPF_PROG(fmod_ret_test, int a, int *b, int ret)
> > >         test5_result = (const void *) addr == &bpf_modify_return_test;
> > >         return ret;
> > >  }
> > > +
> > > +#ifdef __x86_64__
> > > +__u64 test6_result = 0;
> >
> > see, and you just forgot to update the user-space part of the test to
> > even check test6_result...
> >
> > please group variables together and do explicit ASSERT_EQ
>
> right.. will change
>
> thanks,
> jirka
>
> >
> > > +SEC("kprobe/bpf_fentry_test6+0x5")
> > > +int test6(struct pt_regs *ctx)
> > > +{
> > > +       __u64 addr = bpf_get_func_ip(ctx);
> > > +
> > > +       test6_result = (const void *) addr == &bpf_fentry_test6 + 5;
> > > +       return 0;
> > > +}
> > > +#endif
> > > --
> > > 2.31.1
> > >
> >
>
