Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 621A9285178
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 20:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgJFSSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 14:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbgJFSSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 14:18:09 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE69BC061755;
        Tue,  6 Oct 2020 11:18:09 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id v60so9658306ybi.10;
        Tue, 06 Oct 2020 11:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VysxtNhPQhXZy3gNg3Z4uRahv5tdiKC/RdAYMAu0FwA=;
        b=UUvRRztgSlCV0pK2P3zg+4DO+RcBzBD3TUc2MGbQzi0+GClDupAjE6yEcmi2owwrlu
         2Zizl7TL7nk64yPrvLoi4CeHGtNh/jZKLO0FHGns00r2Yba69vkjlTXPzRIxqpKOttVc
         rYsXaK+Y4MOxNMqueLYOsyrOOwKuXeQxLNyzHmxgrxD9vsokOfsFfpDXglofkep8AygY
         fKqdQjfrxaYJOoDOhK+myqCOuunLWwMG0TD9Iag8uGR7LkspKxKJgibXOzt9NC8d5Ekl
         U1D3ihmMJRCt8lzya49COijv8XzOQ5iZRHx4cTgQzafDeK7058J7pEi0vaWPNttEZDSA
         Gxeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VysxtNhPQhXZy3gNg3Z4uRahv5tdiKC/RdAYMAu0FwA=;
        b=dcN5bD0kxmsjitoeQLCElGRlCFKiDQXd2cRX4hUP3Q/JyQGK/ye4fOycHz+L34rLz0
         p49cMEFgZ33kq4z46QwM7iDyjiRgT0QccllK+optQ0HmezKdtO1fMPDB1c6/DfZSgy35
         4DnUCpQRhp74OWRfYPx47iVQEXEUo/z/024zyoOflOJPjSYFgy4OFn5gn+y5XCK8D8UI
         nb1mbeFCxUIvxZRjUb6krzUiqvLCY1JOGcCht01Rvxyc55yQ0YI8r3C6tw3GqFSXXKSR
         o/hxYdkJos7yb0lRHqf5qwvR5hlEI0fmGpFldZki2sAVbUs3xpIqxty8ylSHmFt3yRof
         r72g==
X-Gm-Message-State: AOAM533pkTZS4NaU365mbsgohuN3COHQmzSZ1jCAM2xZmNkUra5qJRNH
        qUdDBt27FDGqUWWWVolyoTXoYhrSgcKkkIigfVo=
X-Google-Smtp-Source: ABdhPJyVNeLFasM169AMMdirQwwUj58ADOa4jqNtRyWgHRiSbgQm0A69M2imvN8++U8d36TG8I+a1BvjqcJ6vI/Yv78=
X-Received: by 2002:a25:2596:: with SMTP id l144mr8476311ybl.510.1602008288863;
 Tue, 06 Oct 2020 11:18:08 -0700 (PDT)
MIME-Version: 1.0
References: <20201002010633.3706122-1-andriin@fb.com> <20201002010633.3706122-2-andriin@fb.com>
 <20201006180839.lvoigzpmr32rrroj@ast-mbp>
In-Reply-To: <20201006180839.lvoigzpmr32rrroj@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 6 Oct 2020 11:17:58 -0700
Message-ID: <CAEf4BzaF+pLa0vGFaQCfLrF=9pjqYmkUhSC7d8yS2-Dv3DCsMA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] libbpf: support safe subset of load/store
 instruction resizing with CO-RE
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Tony Ambardar <tony.ambardar@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 6, 2020 at 11:08 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Oct 01, 2020 at 06:06:31PM -0700, Andrii Nakryiko wrote:
> > Add support for patching instructions of the following form:
> >   - rX = *(T *)(rY + <off>);
> >   - *(T *)(rX + <off>) = rY;
> >   - *(T *)(rX + <off>) = <imm>, where T is one of {u8, u16, u32, u64}.
>
> llvm doesn't generate ST instruction. It never did.
> STX is generated, but can it actually be used with relocations?

interesting, so whe you do `some_struct->some_field = 123;` Clang will still do:

r1 = 123;
*(u32 *)(r2 + 0) = r1;

?

I'll add a test with constant and see what gets generated.

To answer the second part, unless someone is willing to manually
generate .BTF.ext for assembly instruction, then no, you can't really
use it with CO-RE relocation.

> Looking at the test in patch 3... it's testing LDX only.
> ST/STX suppose to work by analogy, but would be good to have a test.
> At least of STX.

yep, will add.

>
> > +static int insn_mem_sz_to_bytes(struct bpf_insn *insn)
> > +{
> > +     switch (BPF_SIZE(insn->code)) {
> > +     case BPF_DW: return 8;
> > +     case BPF_W: return 4;
> > +     case BPF_H: return 2;
> > +     case BPF_B: return 1;
> > +     default: return -1;
> > +     }
> > +}
> > +
> > +static int insn_bytes_to_mem_sz(__u32 sz)
> > +{
> > +     switch (sz) {
> > +     case 8: return BPF_DW;
> > +     case 4: return BPF_W;
> > +     case 2: return BPF_H;
> > +     case 1: return BPF_B;
> > +     default: return -1;
> > +     }
> > +}
>
> filter.h has these two helpers. They're named bytes_to_bpf_size() and bpf_size_to_bytes().
> I guess we cannot really share kernel and libbpf implementation, but
> could you please name them the same way so it's easier to follow
> for folks who read both kernel and libbpf code?

yes, of course. I actually spent some time searching for them, but
couldn't find them in kernel code. I remembered seeing them
previously, but it never occurred to me to chekc filter.h.

>
> > +             if (res->new_sz != res->orig_sz) {
> > +                     mem_sz = insn_mem_sz_to_bytes(insn);
> > +                     if (mem_sz != res->orig_sz) {
> > +                             pr_warn("prog '%s': relo #%d: insn #%d (LDX/ST/STX) unexpected mem size: got %u, exp %u\n",
> > +                                     prog->name, relo_idx, insn_idx, mem_sz, res->orig_sz);
> > +                             return -EINVAL;
> > +                     }
> > +
> > +                     mem_sz = insn_bytes_to_mem_sz(res->new_sz);
> > +                     if (mem_sz < 0) {
>
> Please use new variable here appropriately named.
> Few lines above mem_sz is in bytes while here it's encoding opcode.

ok
