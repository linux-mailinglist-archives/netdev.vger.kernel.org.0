Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6226349BC90
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 21:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbiAYUAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 15:00:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbiAYUAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 15:00:03 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FDA2C06173B;
        Tue, 25 Jan 2022 12:00:03 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id x11so14618548plg.6;
        Tue, 25 Jan 2022 12:00:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9X2ZcgdBzzi0ZX9fvwZzZ7gaHC1Kk1vB/k5NLqJ0IPE=;
        b=DUKdgoAMoX+gtYjEAzMZvB6j2w8MF8dH1MImCtcnwgmo4ok+D3IhwYUWWo41gCtacw
         SqKchHEFlU7KIEM++Oxkss8hAnEsIHWbsdXvCSfeRk3hoWOk9bcN41OtdXSghcUWW1EH
         x0CjZap4fUmmdqu9rxgRMDC58TkhpfoCzgNIN2jejSmnzf1JOXxJoVu5sjYlLE5eFUvT
         1FcCxdpWIe+P3iD8c/yngW0paL2qIPLAX/E2PYFwtlgL1e0gB1NPN8w6Qfnf3K3D62Xk
         /Ls6Rj0O8QQa4pHCHZ8HZqBfLOYx7CEn3w35ZvQZ7LGLviQ5sQ/L/nCnA2QNmIzGOEo/
         bZkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9X2ZcgdBzzi0ZX9fvwZzZ7gaHC1Kk1vB/k5NLqJ0IPE=;
        b=PIOycowuUSqBI3fM8Ei09+YDTFRcFmkQv9kaHoOfrMJT137Wz0+2veWTuBsj2ZwW7/
         evD0bNaiHnS5yGDTULKg39uVwSthMc8xxC6x5WUWpEgNnEcsXsCn7C6zIoCAR/Mlzfq1
         6jTWRp25JH7K9asHFMf2e0mMWrR9wNGsXw6cabQktBl8YSKSwBjXFzdvUCKiC8PoiK3G
         rmq9HdRdd7TX4iQUL+l52tKrSwF7Uo3CTF5bnRZpLr+ARCPO2yFoC2XnXURXtu8/qaZS
         F4nqPd2TsIGNfT8qedur3EQBzubNb7hzz+1aWCMRgDO81HI3GKHknmvq106XHRqgQhoX
         omPw==
X-Gm-Message-State: AOAM532I25ggLT5yBYk4fZeYr33HIyJBRykMMOBLvAWwcilOMZA2tq34
        X8xmyJPHNWzH7pVQOhi+xx1EUgylX7SqlHe7VFM=
X-Google-Smtp-Source: ABdhPJwy3Xakob1c5344opF4tPZz4oyzp0SgB9WD0qOlMcQ02vHS4XYx4ikmANnsFHLbmoMkeU37nFCgiMTbHpdhfuI=
X-Received: by 2002:a17:902:cec6:b0:14b:81e8:ad1b with SMTP id
 d6-20020a170902cec600b0014b81e8ad1bmr2198226plg.116.1643140802319; Tue, 25
 Jan 2022 12:00:02 -0800 (PST)
MIME-Version: 1.0
References: <20220121194926.1970172-1-song@kernel.org> <20220121194926.1970172-7-song@kernel.org>
 <CAADnVQK6+gWTUDo2z1H6AE5_DtuBBetW+VTwwKz03tpVdfuoHA@mail.gmail.com>
 <7393B983-3295-4B14-9528-B7BD04A82709@fb.com> <CAADnVQJLHXaU7tUJN=EM-Nt28xtu4vw9+Ox_uQsjh-E-4VNKoA@mail.gmail.com>
 <5407DA0E-C0F8-4DA9-B407-3DE657301BB2@fb.com> <CAADnVQLOpgGG9qfR4EAgzrdMrfSg9ftCY=9psR46GeBWP7aDvQ@mail.gmail.com>
 <5F4DEFB2-5F5A-4703-B5E5-BBCE05CD3651@fb.com> <CAADnVQLXGu_eF8VT6NmxKVxOHmfx7C=mWmmWF8KmsjFXg6P5OA@mail.gmail.com>
 <5E70BF53-E3FB-4F7A-B55D-199C54A8FDCA@fb.com> <adec88f9-b3e6-bfe4-c09e-54825a60f45d@linux.ibm.com>
 <2AAC8B8C-96F1-400F-AFA6-D4AF41EC82F4@fb.com> <CAADnVQKgdMMeONmjUhbq_3X39t9HNQWteDuyWVfcxmTerTnaMw@mail.gmail.com>
 <CAPhsuW4AXLirZwjH4YfJLYj1VUU2muQx1wTkkUpeBBH9kvw2Ag@mail.gmail.com>
In-Reply-To: <CAPhsuW4AXLirZwjH4YfJLYj1VUU2muQx1wTkkUpeBBH9kvw2Ag@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 25 Jan 2022 11:59:50 -0800
Message-ID: <CAADnVQL8-Hq=g3u65AOoOcB5y-LcOEA4wwMb1Ep0usWdCCSAcA@mail.gmail.com>
Subject: Re: [PATCH v6 bpf-next 6/7] bpf: introduce bpf_prog_pack allocator
To:     Song Liu <song@kernel.org>
Cc:     Song Liu <songliubraving@fb.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 24, 2022 at 11:21 PM Song Liu <song@kernel.org> wrote:
>
> On Mon, Jan 24, 2022 at 9:21 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Mon, Jan 24, 2022 at 10:27 AM Song Liu <songliubraving@fb.com> wrote:
> > > >
> > > > Are arches expected to allocate rw buffers in different ways? If not,
> > > > I would consider putting this into the common code as well. Then
> > > > arch-specific code would do something like
> > > >
> > > >  header = bpf_jit_binary_alloc_pack(size, &prg_buf, &prg_addr, ...);
> > > >  ...
> > > >  /*
> > > >   * Generate code into prg_buf, the code should assume that its first
> > > >   * byte is located at prg_addr.
> > > >   */
> > > >  ...
> > > >  bpf_jit_binary_finalize_pack(header, prg_buf);
> > > >
> > > > where bpf_jit_binary_finalize_pack() would copy prg_buf to header and
> > > > free it.
> >
> > It feels right, but bpf_jit_binary_finalize_pack() sounds 100% arch
> > dependent. The only thing it will do is perform a copy via text_poke.
> > What else?
> >
> > > I think this should work.
> > >
> > > We will need an API like: bpf_arch_text_copy, which uses text_poke_copy()
> > > for x86_64 and s390_kernel_write() for x390. We will use bpf_arch_text_copy
> > > to
> > >   1) write header->size;
> > >   2) do finally copy in bpf_jit_binary_finalize_pack().
> >
> > we can combine all text_poke operations into one.
> >
> > Can we add an 'image' pointer into struct bpf_binary_header ?
>
> There is a 4-byte hole in bpf_binary_header. How about we put
> image_offset there? Actually we only need 2 bytes for offset.
>
> > Then do:
> > int bpf_jit_binary_alloc_pack(size, &ro_hdr, &rw_hdr);
> >
> > ro_hdr->image would be the address used to compute offsets by JIT.
>
> If we only do one text_poke(), we cannot write ro_hdr->image yet. We
> can use ro_hdr + rw_hdr->image_offset instead.

Good points.
Maybe let's go back to Ilya's suggestion and return 4 pointers
from bpf_jit_binary_alloc_pack ?

> > rw_hdr->image would point to kvmalloc-ed area for emitting insns.
> > rw_hdr->size would already be populated.
> >
> > The JITs would write insns into rw_hdr->image including 'int 3' insns.
> > At the end the JIT will do text_poke_copy(ro_hdr, rw_hdr, rw_hdr->size);
> > That would be the only copy that will transfer everything into final
> > location.
> > Then kvfree(rw_hdr)
>
> The only problem is the asymmetry of allocating rw_hdr from bpf/core.c,
> and freeing it from arch/bpf_jit_comp.c. But it doesn't bother me too much.

Indeed. Asymmetry needs to be fixed.
Let's then pass 4 pointers back into
bpf_jit_binary_finalize_pack()
which will call arch dependent weak function to do text_poke_copy
or use default __weak function that returns eopnotsupp
and then kvfree the rw_hdr ?
I'd like to avoid callbacks. imo __weak is easier to follow.
