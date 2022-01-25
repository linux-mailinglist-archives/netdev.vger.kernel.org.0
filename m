Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46A8F49ACC7
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 07:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376967AbiAYGzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 01:55:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376960AbiAYGwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 01:52:04 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 568CCC0419D2;
        Mon, 24 Jan 2022 21:21:40 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id h12so18743179pjq.3;
        Mon, 24 Jan 2022 21:21:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2JyjXhsZHrYi9l/DoJTaQgjCKN4lD5LnNO41dT9vNks=;
        b=SeWhln3X4+SoMhpZU+pjXcqQ0y1Pm6fDTjhiHF8opWSSWcMpymGPTTmwhedeVyuIYm
         BrIMDsEOvf8qdVKDWkOsTi0XxDM9CaPQVPQiAa3CM5C5CcitkQYVp1EQSHTdy14vRuRp
         mN3ybN6shHshovx9QBMN25j03uj04XQT+qmLS8+7LeoBXPCI4YNNk2dGP7w1yjb1reho
         +kFWHLmEeryjmpwEG43M0dn2Qkx0YopIIELYZBVk6DcQGmHlJnW6ZTkjlqQg1PTfQTim
         5RMVR3Hu7kBCV/SyNTy0zBXkFY3DCREvTgWlkkDZJU0/JxmqQHQXRZoBfPW2Ivgm9VIb
         fnWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2JyjXhsZHrYi9l/DoJTaQgjCKN4lD5LnNO41dT9vNks=;
        b=rxE2HwACPRLcpepLfkc9RxslZ+T28wt4mpxuOphr3nntZWwB/BDNpzxIuKHqwZ9v6t
         664zpX/+PgcxKQNGqRFf4MKycHWWGEqBz6iDn0fA6vOpyCEZW9R7wtGT47A6ndl3PH+Q
         LzZE9+1qZwpMT51T5FermIq3otJTVpo/u7W04p5Ak8xppw8lMT/PGKYM9g8917Qt9xv0
         5/evKnGIp4QwsKiqAPbx6dVKAST8Pam9d6VpkvFMMzdJRYZLs58ueeaidCypPRAtJs8R
         AY0qbdJrnuM9ejnbQaPGe55q7MuZGpdAI2G5jKesWUtq3YBLZcjsa6ye+l8LTSalam2N
         jizw==
X-Gm-Message-State: AOAM532d14Ymb4jUWzvFF9eKX6Vx9MqzLBbzbe6H+d81DSSqJ7uMr04E
        eO/Ee3JfkGik8kAhG5hyDFk/tgMEGwzGk7HqXt4=
X-Google-Smtp-Source: ABdhPJzhmi79JGKGRPuYnoxbQJpn2/dNIGOqCLfn+2p6JavciXjFEjoRJ2CYqqHW7AIvi8+sKVxt6L+HkH/sflr3dGs=
X-Received: by 2002:a17:90b:3b4c:: with SMTP id ot12mr1826113pjb.62.1643088099826;
 Mon, 24 Jan 2022 21:21:39 -0800 (PST)
MIME-Version: 1.0
References: <20220121194926.1970172-1-song@kernel.org> <20220121194926.1970172-7-song@kernel.org>
 <CAADnVQK6+gWTUDo2z1H6AE5_DtuBBetW+VTwwKz03tpVdfuoHA@mail.gmail.com>
 <7393B983-3295-4B14-9528-B7BD04A82709@fb.com> <CAADnVQJLHXaU7tUJN=EM-Nt28xtu4vw9+Ox_uQsjh-E-4VNKoA@mail.gmail.com>
 <5407DA0E-C0F8-4DA9-B407-3DE657301BB2@fb.com> <CAADnVQLOpgGG9qfR4EAgzrdMrfSg9ftCY=9psR46GeBWP7aDvQ@mail.gmail.com>
 <5F4DEFB2-5F5A-4703-B5E5-BBCE05CD3651@fb.com> <CAADnVQLXGu_eF8VT6NmxKVxOHmfx7C=mWmmWF8KmsjFXg6P5OA@mail.gmail.com>
 <5E70BF53-E3FB-4F7A-B55D-199C54A8FDCA@fb.com> <adec88f9-b3e6-bfe4-c09e-54825a60f45d@linux.ibm.com>
 <2AAC8B8C-96F1-400F-AFA6-D4AF41EC82F4@fb.com>
In-Reply-To: <2AAC8B8C-96F1-400F-AFA6-D4AF41EC82F4@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 24 Jan 2022 21:21:28 -0800
Message-ID: <CAADnVQKgdMMeONmjUhbq_3X39t9HNQWteDuyWVfcxmTerTnaMw@mail.gmail.com>
Subject: Re: [PATCH v6 bpf-next 6/7] bpf: introduce bpf_prog_pack allocator
To:     Song Liu <songliubraving@fb.com>
Cc:     Ilya Leoshkevich <iii@linux.ibm.com>, Song Liu <song@kernel.org>,
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

On Mon, Jan 24, 2022 at 10:27 AM Song Liu <songliubraving@fb.com> wrote:
> >
> > Are arches expected to allocate rw buffers in different ways? If not,
> > I would consider putting this into the common code as well. Then
> > arch-specific code would do something like
> >
> >  header = bpf_jit_binary_alloc_pack(size, &prg_buf, &prg_addr, ...);
> >  ...
> >  /*
> >   * Generate code into prg_buf, the code should assume that its first
> >   * byte is located at prg_addr.
> >   */
> >  ...
> >  bpf_jit_binary_finalize_pack(header, prg_buf);
> >
> > where bpf_jit_binary_finalize_pack() would copy prg_buf to header and
> > free it.

It feels right, but bpf_jit_binary_finalize_pack() sounds 100% arch
dependent. The only thing it will do is perform a copy via text_poke.
What else?

> I think this should work.
>
> We will need an API like: bpf_arch_text_copy, which uses text_poke_copy()
> for x86_64 and s390_kernel_write() for x390. We will use bpf_arch_text_copy
> to
>   1) write header->size;
>   2) do finally copy in bpf_jit_binary_finalize_pack().

we can combine all text_poke operations into one.

Can we add an 'image' pointer into struct bpf_binary_header ?
Then do:
int bpf_jit_binary_alloc_pack(size, &ro_hdr, &rw_hdr);

ro_hdr->image would be the address used to compute offsets by JIT.
rw_hdr->image would point to kvmalloc-ed area for emitting insns.
rw_hdr->size would already be populated.

The JITs would write insns into rw_hdr->image including 'int 3' insns.
At the end the JIT will do text_poke_copy(ro_hdr, rw_hdr, rw_hdr->size);
That would be the only copy that will transfer everything into final
location.
Then kvfree(rw_hdr)

wdyt?
