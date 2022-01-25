Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B72E949AE69
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 09:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1452446AbiAYIsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 03:48:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1452376AbiAYIql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 03:46:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961EDC055A8C;
        Mon, 24 Jan 2022 23:21:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FFE161307;
        Tue, 25 Jan 2022 07:21:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A75C340E8;
        Tue, 25 Jan 2022 07:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643095289;
        bh=/7vav1tP1IFHJLsPaTScBMjyW/1YdDoF34LK07MnAaw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=O2BCshx+Gvniy0Y60rn1m43b24EsUlYsOT6aMKgW8HlxYziOQZJiE79PEhUYG0ISg
         pCph+I+WK0BwuVIcqeEODNwzEfgOWgjPdVAqI3kPxC0340goLtbFMAyh8GFGX5c7tb
         jjEttOxIEKlFt8LZRUWRh6yJaMrMAkD3jLqFUoBekbt8FY7iwye7gNQXe9zmIQwsDS
         bjnLAS/424xi2N9ry4FETJlYKAsRCoEmHrjs3T2PWZzNIjlYG/EympisqdFXttfH7z
         Q6nKFMH7wnju6NVVBzuMelO4G/VlXRxiWQuwUIg6ouGrwX2BLtjT59DYRUHMcJPh2F
         Ld2dDFkb5pLkA==
Received: by mail-yb1-f177.google.com with SMTP id k17so3718029ybk.6;
        Mon, 24 Jan 2022 23:21:29 -0800 (PST)
X-Gm-Message-State: AOAM533pIRDiaHX8ID7cV64He8OZZRp5OnPNuiVNYONZN13Vsqr83Oqm
        xKMBz/rlfLamP1AmA5C5wFQzbvoB+9XjT6tm0M0=
X-Google-Smtp-Source: ABdhPJyqYR4DFbAGWIBtoB383m5E/+ETS5HAwrtiClUKnfSskVUeJQfarucshkcm6G/i3SfpNfQq1VBWaHCevUsDBfw=
X-Received: by 2002:a5b:c01:: with SMTP id f1mr27513023ybq.47.1643095288812;
 Mon, 24 Jan 2022 23:21:28 -0800 (PST)
MIME-Version: 1.0
References: <20220121194926.1970172-1-song@kernel.org> <20220121194926.1970172-7-song@kernel.org>
 <CAADnVQK6+gWTUDo2z1H6AE5_DtuBBetW+VTwwKz03tpVdfuoHA@mail.gmail.com>
 <7393B983-3295-4B14-9528-B7BD04A82709@fb.com> <CAADnVQJLHXaU7tUJN=EM-Nt28xtu4vw9+Ox_uQsjh-E-4VNKoA@mail.gmail.com>
 <5407DA0E-C0F8-4DA9-B407-3DE657301BB2@fb.com> <CAADnVQLOpgGG9qfR4EAgzrdMrfSg9ftCY=9psR46GeBWP7aDvQ@mail.gmail.com>
 <5F4DEFB2-5F5A-4703-B5E5-BBCE05CD3651@fb.com> <CAADnVQLXGu_eF8VT6NmxKVxOHmfx7C=mWmmWF8KmsjFXg6P5OA@mail.gmail.com>
 <5E70BF53-E3FB-4F7A-B55D-199C54A8FDCA@fb.com> <adec88f9-b3e6-bfe4-c09e-54825a60f45d@linux.ibm.com>
 <2AAC8B8C-96F1-400F-AFA6-D4AF41EC82F4@fb.com> <CAADnVQKgdMMeONmjUhbq_3X39t9HNQWteDuyWVfcxmTerTnaMw@mail.gmail.com>
In-Reply-To: <CAADnVQKgdMMeONmjUhbq_3X39t9HNQWteDuyWVfcxmTerTnaMw@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 24 Jan 2022 23:21:17 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4AXLirZwjH4YfJLYj1VUU2muQx1wTkkUpeBBH9kvw2Ag@mail.gmail.com>
Message-ID: <CAPhsuW4AXLirZwjH4YfJLYj1VUU2muQx1wTkkUpeBBH9kvw2Ag@mail.gmail.com>
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

On Mon, Jan 24, 2022 at 9:21 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Jan 24, 2022 at 10:27 AM Song Liu <songliubraving@fb.com> wrote:
> > >
> > > Are arches expected to allocate rw buffers in different ways? If not,
> > > I would consider putting this into the common code as well. Then
> > > arch-specific code would do something like
> > >
> > >  header = bpf_jit_binary_alloc_pack(size, &prg_buf, &prg_addr, ...);
> > >  ...
> > >  /*
> > >   * Generate code into prg_buf, the code should assume that its first
> > >   * byte is located at prg_addr.
> > >   */
> > >  ...
> > >  bpf_jit_binary_finalize_pack(header, prg_buf);
> > >
> > > where bpf_jit_binary_finalize_pack() would copy prg_buf to header and
> > > free it.
>
> It feels right, but bpf_jit_binary_finalize_pack() sounds 100% arch
> dependent. The only thing it will do is perform a copy via text_poke.
> What else?
>
> > I think this should work.
> >
> > We will need an API like: bpf_arch_text_copy, which uses text_poke_copy()
> > for x86_64 and s390_kernel_write() for x390. We will use bpf_arch_text_copy
> > to
> >   1) write header->size;
> >   2) do finally copy in bpf_jit_binary_finalize_pack().
>
> we can combine all text_poke operations into one.
>
> Can we add an 'image' pointer into struct bpf_binary_header ?

There is a 4-byte hole in bpf_binary_header. How about we put
image_offset there? Actually we only need 2 bytes for offset.

> Then do:
> int bpf_jit_binary_alloc_pack(size, &ro_hdr, &rw_hdr);
>
> ro_hdr->image would be the address used to compute offsets by JIT.

If we only do one text_poke(), we cannot write ro_hdr->image yet. We
can use ro_hdr + rw_hdr->image_offset instead.

> rw_hdr->image would point to kvmalloc-ed area for emitting insns.
> rw_hdr->size would already be populated.
>
> The JITs would write insns into rw_hdr->image including 'int 3' insns.
> At the end the JIT will do text_poke_copy(ro_hdr, rw_hdr, rw_hdr->size);
> That would be the only copy that will transfer everything into final
> location.
> Then kvfree(rw_hdr)

The only problem is the asymmetry of allocating rw_hdr from bpf/core.c,
and freeing it from arch/bpf_jit_comp.c. But it doesn't bother me too much.

Thanks,
Song
