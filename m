Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D46049C0C6
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 02:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235872AbiAZBcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 20:32:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232531AbiAZBcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 20:32:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83CB1C06161C;
        Tue, 25 Jan 2022 17:32:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18480615BE;
        Wed, 26 Jan 2022 01:32:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB0AC340E0;
        Wed, 26 Jan 2022 01:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643160723;
        bh=5j8Og1hjoL1NLBflY/iku+q+IgVnwadiegZjmrsb2kQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=oAOXTcwfDHWLJLeChHxT1cLbBk3oKFT7ogwubviyDlVtBtQpYS8xgGC5hN/dwHLnc
         OCBPRPPYlFjSZ30zE65ETeIFK5wieqXVwENi4nYE0AmvH/xDNdhCI7iz8Tcy0hIq6c
         /BQYoitVsUpHRVE87JiG2Jj+hKClMwttXgzhQ8EF7Ir9gpdud1NK/zbD0G/+pZQlPR
         VvJXKm/x4txFZWsuYu5PUouCJP8gIGSx3Tb/VtJbe0jEyc6rXPT8OGj35wVQPhnBLF
         P7eFR4VxE/2FgLoj00icRRjsorXlai7NTI/LIf52UafWUkrgMpyWygFnc1AsQlcJBt
         48iE0fOYMWmog==
Received: by mail-yb1-f170.google.com with SMTP id p5so66800019ybd.13;
        Tue, 25 Jan 2022 17:32:03 -0800 (PST)
X-Gm-Message-State: AOAM533O/3Do1OMdfBlHNK6af9MXx4XHc3GSrx/RUj5ePK4QxvAsFzNB
        XZaa6j/mu98RG9IlzeZ6up26xoZiHHsIJMEBSkw=
X-Google-Smtp-Source: ABdhPJzRJcVJvbT2O9egjz4+nocgJIveDDLBp7j1jarhnzDEVDM9Og81hFZbeYJu210K3fPrpC0KjQO7v4yZFb/NC7w=
X-Received: by 2002:a25:8b85:: with SMTP id j5mr32153498ybl.558.1643160722604;
 Tue, 25 Jan 2022 17:32:02 -0800 (PST)
MIME-Version: 1.0
References: <20220121194926.1970172-1-song@kernel.org> <20220121194926.1970172-7-song@kernel.org>
 <CAADnVQK6+gWTUDo2z1H6AE5_DtuBBetW+VTwwKz03tpVdfuoHA@mail.gmail.com>
 <7393B983-3295-4B14-9528-B7BD04A82709@fb.com> <CAADnVQJLHXaU7tUJN=EM-Nt28xtu4vw9+Ox_uQsjh-E-4VNKoA@mail.gmail.com>
 <5407DA0E-C0F8-4DA9-B407-3DE657301BB2@fb.com> <CAADnVQLOpgGG9qfR4EAgzrdMrfSg9ftCY=9psR46GeBWP7aDvQ@mail.gmail.com>
 <5F4DEFB2-5F5A-4703-B5E5-BBCE05CD3651@fb.com> <CAADnVQLXGu_eF8VT6NmxKVxOHmfx7C=mWmmWF8KmsjFXg6P5OA@mail.gmail.com>
 <5E70BF53-E3FB-4F7A-B55D-199C54A8FDCA@fb.com> <adec88f9-b3e6-bfe4-c09e-54825a60f45d@linux.ibm.com>
 <2AAC8B8C-96F1-400F-AFA6-D4AF41EC82F4@fb.com> <CAADnVQKgdMMeONmjUhbq_3X39t9HNQWteDuyWVfcxmTerTnaMw@mail.gmail.com>
 <CAPhsuW4AXLirZwjH4YfJLYj1VUU2muQx1wTkkUpeBBH9kvw2Ag@mail.gmail.com>
 <CAADnVQL8-Hq=g3u65AOoOcB5y-LcOEA4wwMb1Ep0usWdCCSAcA@mail.gmail.com>
 <CAPhsuW4K+oDsytLvz4n44Fe3Pbjmpu6tnCk63A-UVxCZpz_rjg@mail.gmail.com>
 <CAADnVQJ8-XVYb21bFRgsaoj7hzd89NSbSOBj0suwsYSL89pxsg@mail.gmail.com>
 <CAPhsuW7AzQL5y+4stw_MZCg2sR3e5qe1YS0L1evxhCvfTWF5+Q@mail.gmail.com>
 <CAADnVQLn0UFjMx_5rQhWbSPXK1PUbJR04cxSgrTH-KuUVy8C9g@mail.gmail.com>
 <CAPhsuW4YUT4r+9HSXxUMXjP8KjPq__npmxo6O4K8p0FSaZ6s0A@mail.gmail.com>
 <CAADnVQ+xiQx4SWuEqm+vCjXs-GCo_jsVcF9DB7JyoEP=C_=-QA@mail.gmail.com> <CAPhsuW5gVLZeKznY0U2ccYbSzDht5K4fz2-9ScT15WBBJXeUJw@mail.gmail.com>
In-Reply-To: <CAPhsuW5gVLZeKznY0U2ccYbSzDht5K4fz2-9ScT15WBBJXeUJw@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 25 Jan 2022 17:31:51 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4Ci9m=XW-ceHV1HBJQqxOmvK9F=yvg6CpwMzALcyTEeA@mail.gmail.com>
Message-ID: <CAPhsuW4Ci9m=XW-ceHV1HBJQqxOmvK9F=yvg6CpwMzALcyTEeA@mail.gmail.com>
Subject: Re: [PATCH v6 bpf-next 6/7] bpf: introduce bpf_prog_pack allocator
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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

On Tue, Jan 25, 2022 at 5:28 PM Song Liu <song@kernel.org> wrote:
>
> On Tue, Jan 25, 2022 at 5:20 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Jan 25, 2022 at 4:50 PM Song Liu <song@kernel.org> wrote:
> > >
> > > On Tue, Jan 25, 2022 at 4:38 PM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> [...]
> > > > >
> > > > > In bpf_jit_binary_hdr(), we calculate header as image & PAGE_MASK.
> > > > > If we want s/PAGE_MASK/63 for x86_64, we will have different versions
> > > > > of bpf_jit_binary_hdr(). It is not on any hot path, so we can use __weak for
> > > > > it. Other than this, I think the solution works fine.
> > > >
> > > > I think it can stay generic.
> > > >
> > > > The existing bpf_jit_binary_hdr() will do & PAGE_MASK
> > > > while bpf_jit_binary_hdr_pack() will do & 63.
> > >
> > > The problem with this approach is that we need bpf_prog_ksym_set_addr
> > > to be smart to pick bpf_jit_binary_hdr() or bpf_jit_binary_hdr_pack().
> >
> > We can probably add a true JIT image size to bpf_prog_aux.
> > bpf_prog_ksym_set_addr() is approximating the end:
> > prog->aux->ksym.end   = addr + hdr->pages * PAGE_SIZE
> > which doesn't have to include all the 'int 3' padding after the end.

Actually, we can use prog->jited_len in bpf_prog_ksym_set_addr(), right?

Song
