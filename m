Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9CA749C053
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 01:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235413AbiAZAur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 19:50:47 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58452 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231603AbiAZAuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 19:50:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C305A614D6;
        Wed, 26 Jan 2022 00:50:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2928EC340EB;
        Wed, 26 Jan 2022 00:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643158245;
        bh=t4Z/WfYkK3uj/UKoOQ40fNev4XYPlLXV7KObT+UC1LY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=adVzEdLPNWoHvIba+lidyAMI9aM481KpjFq/2NUaIGVgFbJZFzXe73k8Gli4KC/z4
         dVts7qDTgtmy6WWYZ4z4SuwKRTQjjDOuS4hCyGHbpRpimkoDshvtmJNMt1AoqlxrlY
         GDxblaOn+hSDfytxX+gGN413XTSE4TS6a6CPfk0TnNIbQ5pfKjXOI7A1OBnnySXwJr
         MpDud8rA+zNpcG8drtO1bueaCa2B7TWrR4ZfQLvu52vi+9JkGBihub+yHLNTcgF9lB
         vavpt11kL2ZQTiEzy6F3I/5TlGIPmN6MgqheZ+MFezod1BCAAgaQ+qfto1bLeRBBNz
         wFqKPsVDl4NeA==
Received: by mail-yb1-f177.google.com with SMTP id h14so66659788ybe.12;
        Tue, 25 Jan 2022 16:50:45 -0800 (PST)
X-Gm-Message-State: AOAM533FE4NPZAX0087em8WGUeJ/MB5LLuEMT/vxlAcxiUUfMzSdrBoE
        jMSwV2lIR+ZIPTlRi2hACETGk9dSksV0FDyugRY=
X-Google-Smtp-Source: ABdhPJyLuKtJNHQUrqJpyf9ilerXHtRQOBSFdz4Wiet4IYy0dTh6L/t5aLFcrA4LAau9JJliX11d9wQbzHBPZqM1viw=
X-Received: by 2002:a25:8d0d:: with SMTP id n13mr34127251ybl.208.1643158244272;
 Tue, 25 Jan 2022 16:50:44 -0800 (PST)
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
 <CAPhsuW7AzQL5y+4stw_MZCg2sR3e5qe1YS0L1evxhCvfTWF5+Q@mail.gmail.com> <CAADnVQLn0UFjMx_5rQhWbSPXK1PUbJR04cxSgrTH-KuUVy8C9g@mail.gmail.com>
In-Reply-To: <CAADnVQLn0UFjMx_5rQhWbSPXK1PUbJR04cxSgrTH-KuUVy8C9g@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 25 Jan 2022 16:50:33 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4YUT4r+9HSXxUMXjP8KjPq__npmxo6O4K8p0FSaZ6s0A@mail.gmail.com>
Message-ID: <CAPhsuW4YUT4r+9HSXxUMXjP8KjPq__npmxo6O4K8p0FSaZ6s0A@mail.gmail.com>
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

On Tue, Jan 25, 2022 at 4:38 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Jan 25, 2022 at 3:09 PM Song Liu <song@kernel.org> wrote:
> >
> > On Tue, Jan 25, 2022 at 2:48 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Tue, Jan 25, 2022 at 2:25 PM Song Liu <song@kernel.org> wrote:
> > > >
> > > > On Tue, Jan 25, 2022 at 12:00 PM Alexei Starovoitov
> > > > <alexei.starovoitov@gmail.com> wrote:
> > > > >
> > > > > On Mon, Jan 24, 2022 at 11:21 PM Song Liu <song@kernel.org> wrote:
> > > > > >
> > > > > > On Mon, Jan 24, 2022 at 9:21 PM Alexei Starovoitov
> > > > > > <alexei.starovoitov@gmail.com> wrote:
> > > > > > >
> > > > > > > On Mon, Jan 24, 2022 at 10:27 AM Song Liu <songliubraving@fb.com> wrote:
> > > > > > > > >
> > > > > > > > > Are arches expected to allocate rw buffers in different ways? If not,
> > > > > > > > > I would consider putting this into the common code as well. Then
> > > > > > > > > arch-specific code would do something like
> > > > > > > > >
> > > > > > > > >  header = bpf_jit_binary_alloc_pack(size, &prg_buf, &prg_addr, ...);
> > > > > > > > >  ...
> > > > > > > > >  /*
> > > > > > > > >   * Generate code into prg_buf, the code should assume that its first
> > > > > > > > >   * byte is located at prg_addr.
> > > > > > > > >   */
> > > > > > > > >  ...
> > > > > > > > >  bpf_jit_binary_finalize_pack(header, prg_buf);
> > > > > > > > >
> > > > > > > > > where bpf_jit_binary_finalize_pack() would copy prg_buf to header and
> > > > > > > > > free it.
> > > > > > >
> > > > > > > It feels right, but bpf_jit_binary_finalize_pack() sounds 100% arch
> > > > > > > dependent. The only thing it will do is perform a copy via text_poke.
> > > > > > > What else?
> > > > > > >
> > > > > > > > I think this should work.
> > > > > > > >
> > > > > > > > We will need an API like: bpf_arch_text_copy, which uses text_poke_copy()
> > > > > > > > for x86_64 and s390_kernel_write() for x390. We will use bpf_arch_text_copy
> > > > > > > > to
> > > > > > > >   1) write header->size;
> > > > > > > >   2) do finally copy in bpf_jit_binary_finalize_pack().
> > > > > > >
> > > > > > > we can combine all text_poke operations into one.
> > > > > > >
> > > > > > > Can we add an 'image' pointer into struct bpf_binary_header ?
> > > > > >
> > > > > > There is a 4-byte hole in bpf_binary_header. How about we put
> > > > > > image_offset there? Actually we only need 2 bytes for offset.
> > > > > >
> > > > > > > Then do:
> > > > > > > int bpf_jit_binary_alloc_pack(size, &ro_hdr, &rw_hdr);
> > > > > > >
> > > > > > > ro_hdr->image would be the address used to compute offsets by JIT.
> > > > > >
> > > > > > If we only do one text_poke(), we cannot write ro_hdr->image yet. We
> > > > > > can use ro_hdr + rw_hdr->image_offset instead.
> > > > >
> > > > > Good points.
> > > > > Maybe let's go back to Ilya's suggestion and return 4 pointers
> > > > > from bpf_jit_binary_alloc_pack ?
> > > >
> > > > How about we use image_offset, like:
> > > >
> > > > struct bpf_binary_header {
> > > >         u32 size;
> > > >         u32 image_offset;
> > > >         u8 image[] __aligned(BPF_IMAGE_ALIGNMENT);
> > > > };
> > > >
> > > > Then we can use
> > > >
> > > > image = (void *)header + header->image_offset;
> > >
> > > I'm not excited about it, since it leaks header details into JITs.
> > > Looks like we don't need JIT to be aware of it.
> > > How about we do random() % roundup(sizeof(struct bpf_binary_header), 64)
> > > to pick the image start and populate
> > > image-sizeof(struct bpf_binary_header) range
> > > with 'int 3'.
> > > This way we can completely hide binary_header inside generic code.
> > > The bpf_jit_binary_alloc_pack() would return ro_image and rw_image only.
> > > And JIT would pass them back into bpf_jit_binary_finalize_pack().
> > > From the image pointer it would be trivial to get to binary_header with &63.
> > > The 128 byte offset that we use today was chosen arbitrarily.
> > > We were burning the whole page for a single program, so 128 bytes zone
> > > at the front was ok.
> > > Now we will be packing progs rounded up to 64 bytes, so it's better
> > > to avoid wasting those 128 bytes regardless.
> >
> > In bpf_jit_binary_hdr(), we calculate header as image & PAGE_MASK.
> > If we want s/PAGE_MASK/63 for x86_64, we will have different versions
> > of bpf_jit_binary_hdr(). It is not on any hot path, so we can use __weak for
> > it. Other than this, I think the solution works fine.
>
> I think it can stay generic.
>
> The existing bpf_jit_binary_hdr() will do & PAGE_MASK
> while bpf_jit_binary_hdr_pack() will do & 63.

The problem with this approach is that we need bpf_prog_ksym_set_addr
to be smart to pick bpf_jit_binary_hdr() or bpf_jit_binary_hdr_pack().

Song
