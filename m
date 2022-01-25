Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A006249BE6E
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 23:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233766AbiAYWZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 17:25:54 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36028 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233746AbiAYWZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 17:25:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D521461846;
        Tue, 25 Jan 2022 22:25:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED49C36AE2;
        Tue, 25 Jan 2022 22:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643149552;
        bh=CgPgPp263NLmkrJiBNhfQzbKnFkh/bQ4sDnWzA9Zl0A=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=l8GJHojB3JGf4lu7XI2VwTcjMozxxaI4DkE3NibQ3/0UeIPJi4KWrYV4XZe4AtBYr
         7FgbAjq2eN/yCEEOSLty1qsDg8VWY/rFgmHQdOrBodfJPcfT8+N5ZD9xhSRAM7TEH7
         IGFLT0oyC4jjEHaDV3acJ8a1Q4VbyYcqesPOjge7iJpceFG8zDkk1EHONFDHGAs2/y
         9fGveb4AkY84ApFNJh3yxrxAOphLf7KxENw0KBS2qucd5cKpzKJgPBVpVC41bAx8kl
         NxuGsZjpH8jKYEDAdZacKOfWHz6gj0p5pyjqqSJC2GD2NfURB0sr/mHDmCdAV22H0y
         iLFEp5TQoyOtA==
Received: by mail-yb1-f174.google.com with SMTP id m6so65903000ybc.9;
        Tue, 25 Jan 2022 14:25:52 -0800 (PST)
X-Gm-Message-State: AOAM531q+HtFL5TCOb83NvXt+Q9kvuDTmiSihjmwdnQanPcpMI5hysS7
        8p2b3Hu/aXyGcJ5sPA7Nl/QZhAik9UP+vTZ00Xs=
X-Google-Smtp-Source: ABdhPJx+1oakc2Ma4b8rswGDFhBRRPb1gSRcy+XQqJBHc5KWL0kWeRW8hCADJ1cEjDov1CaDTxuGhnF5ogVht3R3QFE=
X-Received: by 2002:a25:dc84:: with SMTP id y126mr33822491ybe.282.1643149551334;
 Tue, 25 Jan 2022 14:25:51 -0800 (PST)
MIME-Version: 1.0
References: <20220121194926.1970172-1-song@kernel.org> <20220121194926.1970172-7-song@kernel.org>
 <CAADnVQK6+gWTUDo2z1H6AE5_DtuBBetW+VTwwKz03tpVdfuoHA@mail.gmail.com>
 <7393B983-3295-4B14-9528-B7BD04A82709@fb.com> <CAADnVQJLHXaU7tUJN=EM-Nt28xtu4vw9+Ox_uQsjh-E-4VNKoA@mail.gmail.com>
 <5407DA0E-C0F8-4DA9-B407-3DE657301BB2@fb.com> <CAADnVQLOpgGG9qfR4EAgzrdMrfSg9ftCY=9psR46GeBWP7aDvQ@mail.gmail.com>
 <5F4DEFB2-5F5A-4703-B5E5-BBCE05CD3651@fb.com> <CAADnVQLXGu_eF8VT6NmxKVxOHmfx7C=mWmmWF8KmsjFXg6P5OA@mail.gmail.com>
 <5E70BF53-E3FB-4F7A-B55D-199C54A8FDCA@fb.com> <adec88f9-b3e6-bfe4-c09e-54825a60f45d@linux.ibm.com>
 <2AAC8B8C-96F1-400F-AFA6-D4AF41EC82F4@fb.com> <CAADnVQKgdMMeONmjUhbq_3X39t9HNQWteDuyWVfcxmTerTnaMw@mail.gmail.com>
 <CAPhsuW4AXLirZwjH4YfJLYj1VUU2muQx1wTkkUpeBBH9kvw2Ag@mail.gmail.com> <CAADnVQL8-Hq=g3u65AOoOcB5y-LcOEA4wwMb1Ep0usWdCCSAcA@mail.gmail.com>
In-Reply-To: <CAADnVQL8-Hq=g3u65AOoOcB5y-LcOEA4wwMb1Ep0usWdCCSAcA@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 25 Jan 2022 14:25:40 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4K+oDsytLvz4n44Fe3Pbjmpu6tnCk63A-UVxCZpz_rjg@mail.gmail.com>
Message-ID: <CAPhsuW4K+oDsytLvz4n44Fe3Pbjmpu6tnCk63A-UVxCZpz_rjg@mail.gmail.com>
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

On Tue, Jan 25, 2022 at 12:00 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Jan 24, 2022 at 11:21 PM Song Liu <song@kernel.org> wrote:
> >
> > On Mon, Jan 24, 2022 at 9:21 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Mon, Jan 24, 2022 at 10:27 AM Song Liu <songliubraving@fb.com> wrote:
> > > > >
> > > > > Are arches expected to allocate rw buffers in different ways? If not,
> > > > > I would consider putting this into the common code as well. Then
> > > > > arch-specific code would do something like
> > > > >
> > > > >  header = bpf_jit_binary_alloc_pack(size, &prg_buf, &prg_addr, ...);
> > > > >  ...
> > > > >  /*
> > > > >   * Generate code into prg_buf, the code should assume that its first
> > > > >   * byte is located at prg_addr.
> > > > >   */
> > > > >  ...
> > > > >  bpf_jit_binary_finalize_pack(header, prg_buf);
> > > > >
> > > > > where bpf_jit_binary_finalize_pack() would copy prg_buf to header and
> > > > > free it.
> > >
> > > It feels right, but bpf_jit_binary_finalize_pack() sounds 100% arch
> > > dependent. The only thing it will do is perform a copy via text_poke.
> > > What else?
> > >
> > > > I think this should work.
> > > >
> > > > We will need an API like: bpf_arch_text_copy, which uses text_poke_copy()
> > > > for x86_64 and s390_kernel_write() for x390. We will use bpf_arch_text_copy
> > > > to
> > > >   1) write header->size;
> > > >   2) do finally copy in bpf_jit_binary_finalize_pack().
> > >
> > > we can combine all text_poke operations into one.
> > >
> > > Can we add an 'image' pointer into struct bpf_binary_header ?
> >
> > There is a 4-byte hole in bpf_binary_header. How about we put
> > image_offset there? Actually we only need 2 bytes for offset.
> >
> > > Then do:
> > > int bpf_jit_binary_alloc_pack(size, &ro_hdr, &rw_hdr);
> > >
> > > ro_hdr->image would be the address used to compute offsets by JIT.
> >
> > If we only do one text_poke(), we cannot write ro_hdr->image yet. We
> > can use ro_hdr + rw_hdr->image_offset instead.
>
> Good points.
> Maybe let's go back to Ilya's suggestion and return 4 pointers
> from bpf_jit_binary_alloc_pack ?

How about we use image_offset, like:

struct bpf_binary_header {
        u32 size;
        u32 image_offset;
        u8 image[] __aligned(BPF_IMAGE_ALIGNMENT);
};

Then we can use

image = (void *)header + header->image_offset;

In this way, we will only have two output pointers.

>
> > > rw_hdr->image would point to kvmalloc-ed area for emitting insns.
> > > rw_hdr->size would already be populated.
> > >
> > > The JITs would write insns into rw_hdr->image including 'int 3' insns.
> > > At the end the JIT will do text_poke_copy(ro_hdr, rw_hdr, rw_hdr->size);
> > > That would be the only copy that will transfer everything into final
> > > location.
> > > Then kvfree(rw_hdr)
> >
> > The only problem is the asymmetry of allocating rw_hdr from bpf/core.c,
> > and freeing it from arch/bpf_jit_comp.c. But it doesn't bother me too much.
>
> Indeed. Asymmetry needs to be fixed.
> Let's then pass 4 pointers back into
> bpf_jit_binary_finalize_pack()
> which will call arch dependent weak function to do text_poke_copy
> or use default __weak function that returns eopnotsupp
> and then kvfree the rw_hdr ?
> I'd like to avoid callbacks. imo __weak is easier to follow.

Yeah, I also like __weak function better.

Thanks,
Song
