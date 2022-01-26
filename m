Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D782349C0A3
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 02:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235650AbiAZBUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 20:20:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235637AbiAZBUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 20:20:34 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5352C06161C;
        Tue, 25 Jan 2022 17:20:33 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id i65so21310943pfc.9;
        Tue, 25 Jan 2022 17:20:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WE+J2QanX13xauZhQxfLJNljbHtY1NDRSbKC9uOnr2o=;
        b=gSkvFnU4pgpgk4OsxmF61xsJl8bNGgbJUvL0FPtC0ZyRHBYyUCz/8NhllYwdnlaOxp
         c7IZ9JrEco5VSg8M9ZLd6O/dcDonX9EfaWBB5O11HhC8VxvrcNeLHXXTstA9onTn9oQF
         wbhggwvilhc5x5sPaAE8zbZPIlW5npLzVyENZqQXpNR6kNdDl2x0lrMWQdPbTUNb9CN8
         Qx7BO5x55eW9twzQbRyNo/SfbvjbzQcTSsYi9LDfgYOuSSc3NHiBT6vlO/tgOJBfP9j4
         hn7rrmh/xmubjESQ6cVSAEmRjuvlJbA21jBhNQ7YBdGTqKKHZJITOkwRVxQC0ctVwkOf
         dLhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WE+J2QanX13xauZhQxfLJNljbHtY1NDRSbKC9uOnr2o=;
        b=cIot47b26lhJDrktmtyOAZZlXerhtqs/LWf78MZhVxCnxQkvOy+/xCeciJvBOsTi5Y
         QdxZTe3fLNzk3RKRBLn8NB05QAFEd0qd5dzwDL528DkWVAUSJBxWDURprV5eW4YY/SAZ
         mXegIoQ4oEUFiZYhiAO11JICJEX1X5V1KCW553q6EJSsMz4jDvuBH5N9VYNnrKmt0X9w
         7w0Oy/XPGrvPStmtKJp/rz8bYt9ulXxq9zJyYa4nLsis0ScDXG4l/TbvjWtZ9+HWEt+k
         9bFqoMazWguYEklStnr5xY2HYuAfmOzXdyecPAMMmcTigAFCxuSA1h+5G5THikucpZjG
         PxvQ==
X-Gm-Message-State: AOAM531z3s8b7mDPRyVkbm3w0fo9Mh2mai7/uwj35Bokrz9ICMAc+ObU
        1LNyys3pfSD3DoLUAu+Ix2bpTt2+1tTFXd3BI5TBwaVN998=
X-Google-Smtp-Source: ABdhPJwQTMH5/DHZgu3DKyHRWyXH6IIp+Rhea7gHlNOo4Z5Qu18pmApee45Tc2amOWOU4clAWQ1BhGyZGdHAkjC3/Vk=
X-Received: by 2002:aa7:888d:0:b0:4c2:7965:950d with SMTP id
 z13-20020aa7888d000000b004c27965950dmr20945167pfe.46.1643160032469; Tue, 25
 Jan 2022 17:20:32 -0800 (PST)
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
 <CAADnVQLn0UFjMx_5rQhWbSPXK1PUbJR04cxSgrTH-KuUVy8C9g@mail.gmail.com> <CAPhsuW4YUT4r+9HSXxUMXjP8KjPq__npmxo6O4K8p0FSaZ6s0A@mail.gmail.com>
In-Reply-To: <CAPhsuW4YUT4r+9HSXxUMXjP8KjPq__npmxo6O4K8p0FSaZ6s0A@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 25 Jan 2022 17:20:21 -0800
Message-ID: <CAADnVQ+xiQx4SWuEqm+vCjXs-GCo_jsVcF9DB7JyoEP=C_=-QA@mail.gmail.com>
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

On Tue, Jan 25, 2022 at 4:50 PM Song Liu <song@kernel.org> wrote:
>
> On Tue, Jan 25, 2022 at 4:38 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Jan 25, 2022 at 3:09 PM Song Liu <song@kernel.org> wrote:
> > >
> > > On Tue, Jan 25, 2022 at 2:48 PM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Tue, Jan 25, 2022 at 2:25 PM Song Liu <song@kernel.org> wrote:
> > > > >
> > > > > On Tue, Jan 25, 2022 at 12:00 PM Alexei Starovoitov
> > > > > <alexei.starovoitov@gmail.com> wrote:
> > > > > >
> > > > > > On Mon, Jan 24, 2022 at 11:21 PM Song Liu <song@kernel.org> wrote:
> > > > > > >
> > > > > > > On Mon, Jan 24, 2022 at 9:21 PM Alexei Starovoitov
> > > > > > > <alexei.starovoitov@gmail.com> wrote:
> > > > > > > >
> > > > > > > > On Mon, Jan 24, 2022 at 10:27 AM Song Liu <songliubraving@fb.com> wrote:
> > > > > > > > > >
> > > > > > > > > > Are arches expected to allocate rw buffers in different ways? If not,
> > > > > > > > > > I would consider putting this into the common code as well. Then
> > > > > > > > > > arch-specific code would do something like
> > > > > > > > > >
> > > > > > > > > >  header = bpf_jit_binary_alloc_pack(size, &prg_buf, &prg_addr, ...);
> > > > > > > > > >  ...
> > > > > > > > > >  /*
> > > > > > > > > >   * Generate code into prg_buf, the code should assume that its first
> > > > > > > > > >   * byte is located at prg_addr.
> > > > > > > > > >   */
> > > > > > > > > >  ...
> > > > > > > > > >  bpf_jit_binary_finalize_pack(header, prg_buf);
> > > > > > > > > >
> > > > > > > > > > where bpf_jit_binary_finalize_pack() would copy prg_buf to header and
> > > > > > > > > > free it.
> > > > > > > >
> > > > > > > > It feels right, but bpf_jit_binary_finalize_pack() sounds 100% arch
> > > > > > > > dependent. The only thing it will do is perform a copy via text_poke.
> > > > > > > > What else?
> > > > > > > >
> > > > > > > > > I think this should work.
> > > > > > > > >
> > > > > > > > > We will need an API like: bpf_arch_text_copy, which uses text_poke_copy()
> > > > > > > > > for x86_64 and s390_kernel_write() for x390. We will use bpf_arch_text_copy
> > > > > > > > > to
> > > > > > > > >   1) write header->size;
> > > > > > > > >   2) do finally copy in bpf_jit_binary_finalize_pack().
> > > > > > > >
> > > > > > > > we can combine all text_poke operations into one.
> > > > > > > >
> > > > > > > > Can we add an 'image' pointer into struct bpf_binary_header ?
> > > > > > >
> > > > > > > There is a 4-byte hole in bpf_binary_header. How about we put
> > > > > > > image_offset there? Actually we only need 2 bytes for offset.
> > > > > > >
> > > > > > > > Then do:
> > > > > > > > int bpf_jit_binary_alloc_pack(size, &ro_hdr, &rw_hdr);
> > > > > > > >
> > > > > > > > ro_hdr->image would be the address used to compute offsets by JIT.
> > > > > > >
> > > > > > > If we only do one text_poke(), we cannot write ro_hdr->image yet. We
> > > > > > > can use ro_hdr + rw_hdr->image_offset instead.
> > > > > >
> > > > > > Good points.
> > > > > > Maybe let's go back to Ilya's suggestion and return 4 pointers
> > > > > > from bpf_jit_binary_alloc_pack ?
> > > > >
> > > > > How about we use image_offset, like:
> > > > >
> > > > > struct bpf_binary_header {
> > > > >         u32 size;
> > > > >         u32 image_offset;
> > > > >         u8 image[] __aligned(BPF_IMAGE_ALIGNMENT);
> > > > > };
> > > > >
> > > > > Then we can use
> > > > >
> > > > > image = (void *)header + header->image_offset;
> > > >
> > > > I'm not excited about it, since it leaks header details into JITs.
> > > > Looks like we don't need JIT to be aware of it.
> > > > How about we do random() % roundup(sizeof(struct bpf_binary_header), 64)
> > > > to pick the image start and populate
> > > > image-sizeof(struct bpf_binary_header) range
> > > > with 'int 3'.
> > > > This way we can completely hide binary_header inside generic code.
> > > > The bpf_jit_binary_alloc_pack() would return ro_image and rw_image only.
> > > > And JIT would pass them back into bpf_jit_binary_finalize_pack().
> > > > From the image pointer it would be trivial to get to binary_header with &63.
> > > > The 128 byte offset that we use today was chosen arbitrarily.
> > > > We were burning the whole page for a single program, so 128 bytes zone
> > > > at the front was ok.
> > > > Now we will be packing progs rounded up to 64 bytes, so it's better
> > > > to avoid wasting those 128 bytes regardless.
> > >
> > > In bpf_jit_binary_hdr(), we calculate header as image & PAGE_MASK.
> > > If we want s/PAGE_MASK/63 for x86_64, we will have different versions
> > > of bpf_jit_binary_hdr(). It is not on any hot path, so we can use __weak for
> > > it. Other than this, I think the solution works fine.
> >
> > I think it can stay generic.
> >
> > The existing bpf_jit_binary_hdr() will do & PAGE_MASK
> > while bpf_jit_binary_hdr_pack() will do & 63.
>
> The problem with this approach is that we need bpf_prog_ksym_set_addr
> to be smart to pick bpf_jit_binary_hdr() or bpf_jit_binary_hdr_pack().

We can probably add a true JIT image size to bpf_prog_aux.
bpf_prog_ksym_set_addr() is approximating the end:
prog->aux->ksym.end   = addr + hdr->pages * PAGE_SIZE
which doesn't have to include all the 'int 3' padding after the end.

Or add a flag to bpf_prog_aux.
Ideally bpf_jit_free() would stay generic too.
