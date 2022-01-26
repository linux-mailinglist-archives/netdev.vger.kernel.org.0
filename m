Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1316649C03E
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 01:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235370AbiAZAiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 19:38:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235363AbiAZAim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 19:38:42 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF905C06161C;
        Tue, 25 Jan 2022 16:38:41 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id g20so1584373pgn.10;
        Tue, 25 Jan 2022 16:38:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NtkJr2IBKuac+Zd2uR46StBGmwougS0PNqmUosDvkQE=;
        b=ERJrUj0ckOW0ncuvoPEMrR79XbmGd+VR+98pCyf6EEG5If+dsGjozeLcQac4tZ6xoa
         zW7KxMyw9qBmPshd5LWZMsCPNQMkg+Cw+7Q1NB0ikDDxkbn813Y+8qEl3XqVh/Vf4BZa
         pxP22kzZCQBYgvoPr6MQGv+Nc/8fDttiGkuhi1Wk+0eMyUYbjPe5zaXoqIfGJJ8HFWoh
         x20ivMvWo+ZsfiOBCsYXyGzjihV72esPMbQM6VMem45reHC5LwKDqhKgqQiJMpx5QUTi
         LxWXe1JexZTPYOiucsJx3ZNNC+5HfqHzaeMkwwNzJUKT+F4NwwCMDoQ5DE+y0QnIIW0z
         pBEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NtkJr2IBKuac+Zd2uR46StBGmwougS0PNqmUosDvkQE=;
        b=3hvMXKryw5oJp0lXxze+veAszofChtKY6oCTCePceMDFSaJZR2q95Trgy5BS7ifSWR
         rX4sCp2c7REIHxDUcWoNiJDtpPEb7TXsHpQ+UsmHjI6dPOXTRc6c/joEweTuVOYGLK17
         vpna6jo+ggISgbSuuLwcjzrVXtJQ1acIdPmH83Lbz/Y8kKuRfGiwhGLviMHDE6wa0c8g
         3r6yulVGEMGXzADYuaUJqdwf1G9buULcz3LUIfSiBel0rMV2Pl5O4Bh+LkHfCPN6XJMH
         inlc6BBUEwiJ3m42n9ziW0wLLQoqwG/o3bdNIbpJohJ8KmDWAXtnKhxzm7IJMxyo0+tL
         VF3A==
X-Gm-Message-State: AOAM533xXRvx5Gn1nZZcB6wxWmXEmJGCmwKKDBhL/Q+SFMpsuHvfcx9o
        VXPDsDuMc7N6CaS5FiAAn6OoOMFYCvz4TtfyK00=
X-Google-Smtp-Source: ABdhPJzWVrOM6sLb47lYb6dRtbJ/jn8y+2WF2SWulFpMqyO0i74Tr7bgDB8kYHMJNr48JMU2FyE2cQ07nDz6kx5qBHQ=
X-Received: by 2002:a63:8043:: with SMTP id j64mr686536pgd.95.1643157521317;
 Tue, 25 Jan 2022 16:38:41 -0800 (PST)
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
 <CAADnVQJ8-XVYb21bFRgsaoj7hzd89NSbSOBj0suwsYSL89pxsg@mail.gmail.com> <CAPhsuW7AzQL5y+4stw_MZCg2sR3e5qe1YS0L1evxhCvfTWF5+Q@mail.gmail.com>
In-Reply-To: <CAPhsuW7AzQL5y+4stw_MZCg2sR3e5qe1YS0L1evxhCvfTWF5+Q@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 25 Jan 2022 16:38:30 -0800
Message-ID: <CAADnVQLn0UFjMx_5rQhWbSPXK1PUbJR04cxSgrTH-KuUVy8C9g@mail.gmail.com>
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

On Tue, Jan 25, 2022 at 3:09 PM Song Liu <song@kernel.org> wrote:
>
> On Tue, Jan 25, 2022 at 2:48 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Jan 25, 2022 at 2:25 PM Song Liu <song@kernel.org> wrote:
> > >
> > > On Tue, Jan 25, 2022 at 12:00 PM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Mon, Jan 24, 2022 at 11:21 PM Song Liu <song@kernel.org> wrote:
> > > > >
> > > > > On Mon, Jan 24, 2022 at 9:21 PM Alexei Starovoitov
> > > > > <alexei.starovoitov@gmail.com> wrote:
> > > > > >
> > > > > > On Mon, Jan 24, 2022 at 10:27 AM Song Liu <songliubraving@fb.com> wrote:
> > > > > > > >
> > > > > > > > Are arches expected to allocate rw buffers in different ways? If not,
> > > > > > > > I would consider putting this into the common code as well. Then
> > > > > > > > arch-specific code would do something like
> > > > > > > >
> > > > > > > >  header = bpf_jit_binary_alloc_pack(size, &prg_buf, &prg_addr, ...);
> > > > > > > >  ...
> > > > > > > >  /*
> > > > > > > >   * Generate code into prg_buf, the code should assume that its first
> > > > > > > >   * byte is located at prg_addr.
> > > > > > > >   */
> > > > > > > >  ...
> > > > > > > >  bpf_jit_binary_finalize_pack(header, prg_buf);
> > > > > > > >
> > > > > > > > where bpf_jit_binary_finalize_pack() would copy prg_buf to header and
> > > > > > > > free it.
> > > > > >
> > > > > > It feels right, but bpf_jit_binary_finalize_pack() sounds 100% arch
> > > > > > dependent. The only thing it will do is perform a copy via text_poke.
> > > > > > What else?
> > > > > >
> > > > > > > I think this should work.
> > > > > > >
> > > > > > > We will need an API like: bpf_arch_text_copy, which uses text_poke_copy()
> > > > > > > for x86_64 and s390_kernel_write() for x390. We will use bpf_arch_text_copy
> > > > > > > to
> > > > > > >   1) write header->size;
> > > > > > >   2) do finally copy in bpf_jit_binary_finalize_pack().
> > > > > >
> > > > > > we can combine all text_poke operations into one.
> > > > > >
> > > > > > Can we add an 'image' pointer into struct bpf_binary_header ?
> > > > >
> > > > > There is a 4-byte hole in bpf_binary_header. How about we put
> > > > > image_offset there? Actually we only need 2 bytes for offset.
> > > > >
> > > > > > Then do:
> > > > > > int bpf_jit_binary_alloc_pack(size, &ro_hdr, &rw_hdr);
> > > > > >
> > > > > > ro_hdr->image would be the address used to compute offsets by JIT.
> > > > >
> > > > > If we only do one text_poke(), we cannot write ro_hdr->image yet. We
> > > > > can use ro_hdr + rw_hdr->image_offset instead.
> > > >
> > > > Good points.
> > > > Maybe let's go back to Ilya's suggestion and return 4 pointers
> > > > from bpf_jit_binary_alloc_pack ?
> > >
> > > How about we use image_offset, like:
> > >
> > > struct bpf_binary_header {
> > >         u32 size;
> > >         u32 image_offset;
> > >         u8 image[] __aligned(BPF_IMAGE_ALIGNMENT);
> > > };
> > >
> > > Then we can use
> > >
> > > image = (void *)header + header->image_offset;
> >
> > I'm not excited about it, since it leaks header details into JITs.
> > Looks like we don't need JIT to be aware of it.
> > How about we do random() % roundup(sizeof(struct bpf_binary_header), 64)
> > to pick the image start and populate
> > image-sizeof(struct bpf_binary_header) range
> > with 'int 3'.
> > This way we can completely hide binary_header inside generic code.
> > The bpf_jit_binary_alloc_pack() would return ro_image and rw_image only.
> > And JIT would pass them back into bpf_jit_binary_finalize_pack().
> > From the image pointer it would be trivial to get to binary_header with &63.
> > The 128 byte offset that we use today was chosen arbitrarily.
> > We were burning the whole page for a single program, so 128 bytes zone
> > at the front was ok.
> > Now we will be packing progs rounded up to 64 bytes, so it's better
> > to avoid wasting those 128 bytes regardless.
>
> In bpf_jit_binary_hdr(), we calculate header as image & PAGE_MASK.
> If we want s/PAGE_MASK/63 for x86_64, we will have different versions
> of bpf_jit_binary_hdr(). It is not on any hot path, so we can use __weak for
> it. Other than this, I think the solution works fine.

I think it can stay generic.

The existing bpf_jit_binary_hdr() will do & PAGE_MASK
while bpf_jit_binary_hdr_pack() will do & 63.



> Thanks,
> Song
