Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A7C32B3AE
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449924AbhCCEEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:04:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1580980AbhCBScd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 13:32:33 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F7DC061788;
        Tue,  2 Mar 2021 10:31:53 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id h82so7935504ybc.13;
        Tue, 02 Mar 2021 10:31:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p5mQjzoE3xnTJG7PmrlFzhti+trlvTo1ic3oTokLMMc=;
        b=Y0Ubm2IqkOgR4zN9cLivDAIzbZ8wOHHcMayKC/hM/QadVWehA+GemhY0JUtHmknVRP
         P5qxmjvvlFInrnpkvhgz5nblA+JxhGj08gDDAAEf+lIJdyxnqGuU/uIP4S5VRAwtrDUT
         kfTSKtx7Xd8w80NX+fKfmMYXr8kIIa3wM2eO0YkNLc2pvzO9EZiqO3gj4nRju61xDhfn
         JlWE7hhdAhqMOmCIPKProsDfA5CBuY1/Ld7N6i02FJht5O164WylrME3yBVecxR6KlCm
         UYltiOjb6YrG968ul1LANwtnfL9Yojbk+2/slh5LuIrFcr7nKGkyGLFwGGR02ceZou8x
         Xnsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p5mQjzoE3xnTJG7PmrlFzhti+trlvTo1ic3oTokLMMc=;
        b=c0qkr8ozzeogxHlqxr0XeAGKh+cq4W5cgkgxET3SCUUJ8bOFlo+K+0rvQUrNaqg42+
         omU68XF+S1riTKk+WxZVWOFkNTgdiEaicB4oAmc+p5T6XpDf4d89+BVwqaKEtvHDuzx/
         cJWQxMMVQwH3a3/lpqRSLed4s4zFS6OUlUBJE4RlO3lXgQkF3qsrAMd6eykY8jHU5/GO
         XI2HsSxGUaVFRxrKmQtrbKecNJXI5is0yZtRU3TnsxCz3j9s028qx/SIIkk/2wr+cg+F
         5+mFbmjyCkt9fhVF9CEcUd8qj49oFsucZfqHkd86u1/h1fiqLdGt8K1zHo2THGlscHty
         hs6A==
X-Gm-Message-State: AOAM533697R9JPyMLBLIIcpb1a5mGLI2Q3euXU+iCHZcEC56564AVCS9
        AKhq6ZjIi4rD3+XVYPGD18MJ0th1+UkzhamB+M/DfBmYA84=
X-Google-Smtp-Source: ABdhPJyQwwgASrpAqh0D+gy2eaMl5TSk+tWWgM0z9Yq8pKwMSkIRx55hvjrAWYBTJUmIDgK1d+EgiI9R2qZlD4PSn2Y=
X-Received: by 2002:a25:c6cb:: with SMTP id k194mr32076441ybf.27.1614709912374;
 Tue, 02 Mar 2021 10:31:52 -0800 (PST)
MIME-Version: 1.0
References: <20210301190416.90694-1-jolsa@kernel.org> <CAEf4BzbBnR3M60HepC_CFDsdMQDBYoEWiWtREUaLxrrxyBce0Q@mail.gmail.com>
 <YD4d+dmay+oKyiot@krava>
In-Reply-To: <YD4d+dmay+oKyiot@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 2 Mar 2021 10:31:41 -0800
Message-ID: <CAEf4Bzah8Au01NvtwSogpkr3etwQ3_bObj3GObG8Lb3N0DqZwA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix test_attach_probe for powerpc uprobes
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Yauheni Kaliuta <ykaliuta@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 2, 2021 at 3:14 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Mon, Mar 01, 2021 at 04:34:24PM -0800, Andrii Nakryiko wrote:
> > On Mon, Mar 1, 2021 at 11:11 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > When testing uprobes we the test gets GEP (Global Entry Point)
> > > address from kallsyms, but then the function is called locally
> > > so the uprobe is not triggered.
> > >
> > > Fixing this by adjusting the address to LEP (Local Entry Point)
> > > for powerpc arch.
> > >
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> > >  .../selftests/bpf/prog_tests/attach_probe.c    | 18 +++++++++++++++++-
> > >  1 file changed, 17 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/tools/testing/selftests/bpf/prog_tests/attach_probe.c b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> > > index a0ee87c8e1ea..c3cfb48d3ed0 100644
> > > --- a/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> > > +++ b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> > > @@ -2,6 +2,22 @@
> > >  #include <test_progs.h>
> > >  #include "test_attach_probe.skel.h"
> > >
> > > +#if defined(__powerpc64__)
> > > +/*
> > > + * We get the GEP (Global Entry Point) address from kallsyms,
> > > + * but then the function is called locally, so we need to adjust
> > > + * the address to get LEP (Local Entry Point).
> > > + */
> > > +#define LEP_OFFSET 8
> > > +
> > > +static ssize_t get_offset(ssize_t offset)
> >
> > if we mark this function __weak global, would it work as is? Would it
> > get an address of a global entry point? I know nothing about this GEP
> > vs LEP stuff, interesting :)
>
> you mean get_base_addr? it's already global
>
> all the calls to get_base_addr within the object are made
> to get_base_addr+0x8
>
> 00000000100350c0 <test_attach_probe>:
>     ...
>     100350e0:   59 fd ff 4b     bl      10034e38 <get_base_addr+0x8>
>     ...
>     100358a8:   91 f5 ff 4b     bl      10034e38 <get_base_addr+0x8>
>
>
> I'm following perf fix we had for similar issue:
>   7b6ff0bdbf4f perf probe ppc64le: Fixup function entry if using kallsyms lookup
>
> I'll get more info on that

My thinking was that if you mark the function as __weak, then the
compiler is not allowed to assume that the actual implementation of
that function will come from the same object (because it might be
replaced by the linker later), so it has to be pessimistic and use
global entry, no? Totally theoritizing here, of course.

>
> jirka
>
> >
> > > +{
> > > +       return offset + LEP_OFFSET;
> > > +}
> > > +#else
> > > +#define get_offset(offset) (offset)
> > > +#endif
> > > +
> > >  ssize_t get_base_addr() {
> > >         size_t start, offset;
> > >         char buf[256];
> > > @@ -36,7 +52,7 @@ void test_attach_probe(void)
> > >         if (CHECK(base_addr < 0, "get_base_addr",
> > >                   "failed to find base addr: %zd", base_addr))
> > >                 return;
> > > -       uprobe_offset = (size_t)&get_base_addr - base_addr;
> > > +       uprobe_offset = get_offset((size_t)&get_base_addr - base_addr);
> > >
> > >         skel = test_attach_probe__open_and_load();
> > >         if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
> > > --
> > > 2.29.2
> > >
> >
>
