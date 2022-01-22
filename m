Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52D774968DE
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 01:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbiAVAlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 19:41:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiAVAlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 19:41:44 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB448C06173B;
        Fri, 21 Jan 2022 16:41:43 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id x11so4399205plg.6;
        Fri, 21 Jan 2022 16:41:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fUH6wx6zbhbRqS74dth2DQk00EDwOMZfIZfmxD/tU1g=;
        b=F9V2z9HMdvNcIoapqAzZUOUlat4ERVMJvUwcBI+LROt2CcdtuF9NHKBIpwMtbKexLK
         BzzbUry140aZ0JniyrB8gzVeqydQFKbJWP1Bhll4jMnaI8cl/8/Xb3cY+Jr3/H7uwNyf
         sIxxBBvJ3dcVyE6O+vKpcIJ0Ub4uiX+eeJOBoFsYFoh3BfFQh2a8JXjAdm0+sUutnpfR
         ehdZZZjtUBmypqYGuLoOlT+t7I/dxgLQwqF/nxWS7h68UTGjZ8DCnqTsrWEjeETZ/5Pb
         g4mtZzmpSwL/PXWHIvpoAlOreoLxEn7wHjdemFztw/LzKAXKGnKd3oU1/+GNNfr975TF
         RciA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fUH6wx6zbhbRqS74dth2DQk00EDwOMZfIZfmxD/tU1g=;
        b=1z3JUcOkAotZP7gHmyuGtYz533zMhcaIpV/Zz2IEOCxUz5bIDd7Yeszxa+lg1wdqCk
         vaqs6Ni+FN4y3/21c1k2OIcfOyHZYq4ImMSt8mM3lhx40J8UHE+bVcGz7dHqASJ7tCil
         hstFsnGx0Fka0wuyOIPPLgnIg0cr1zW+Us1jccm2qYpT0jvnWm2fziLimZmg5/ANT1np
         UCH+dl7EDBaZPI6KE4UeZKxv6fUYSdf3ECnrz+BnhpgxYMQSfJEU3LX2rpeEYydQpZTJ
         NtUjQ8Zf0JBwVdyzv0WiIfjmfIFrijc3isXBIvMMFg3qiaBNHbW/PN6hHOUl7maf65fF
         /rGQ==
X-Gm-Message-State: AOAM5315OYgd2Nyp7OKyJsRYxDNsNqNHtfGZOZW9SKYAu0mVdVZVd7iw
        vHvLI7ixWjTwRYl7/nyzabNE+gUyhHXGvGQGGV3ebTWY
X-Google-Smtp-Source: ABdhPJwNuWVCM8bqblSvIdzaZ4LY7UUFl1PSFOEOq477tVgiMa4SvZrgjoVdVpT0OQYWWpz9ui1cRzXi1taJME+74W8=
X-Received: by 2002:a17:902:6502:b0:149:1162:f0b5 with SMTP id
 b2-20020a170902650200b001491162f0b5mr6067399plk.126.1642812103123; Fri, 21
 Jan 2022 16:41:43 -0800 (PST)
MIME-Version: 1.0
References: <20220121194926.1970172-1-song@kernel.org> <20220121194926.1970172-7-song@kernel.org>
 <CAADnVQK6+gWTUDo2z1H6AE5_DtuBBetW+VTwwKz03tpVdfuoHA@mail.gmail.com> <7393B983-3295-4B14-9528-B7BD04A82709@fb.com>
In-Reply-To: <7393B983-3295-4B14-9528-B7BD04A82709@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 21 Jan 2022 16:41:31 -0800
Message-ID: <CAADnVQJLHXaU7tUJN=EM-Nt28xtu4vw9+Ox_uQsjh-E-4VNKoA@mail.gmail.com>
Subject: Re: [PATCH v6 bpf-next 6/7] bpf: introduce bpf_prog_pack allocator
To:     Song Liu <songliubraving@fb.com>
Cc:     Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
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

On Fri, Jan 21, 2022 at 4:23 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Jan 21, 2022, at 3:55 PM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> >
> > On Fri, Jan 21, 2022 at 11:49 AM Song Liu <song@kernel.org> wrote:
> >>
> >> +static struct bpf_binary_header *
> >> +__bpf_jit_binary_alloc(unsigned int proglen, u8 **image_ptr,
> >> +                      unsigned int alignment,
> >> +                      bpf_jit_fill_hole_t bpf_fill_ill_insns,
> >> +                      u32 round_up_to)
> >> +{
> >> +       struct bpf_binary_header *hdr;
> >> +       u32 size, hole, start;
> >> +
> >> +       WARN_ON_ONCE(!is_power_of_2(alignment) ||
> >> +                    alignment > BPF_IMAGE_ALIGNMENT);
> >> +
> >> +       /* Most of BPF filters are really small, but if some of them
> >> +        * fill a page, allow at least 128 extra bytes to insert a
> >> +        * random section of illegal instructions.
> >> +        */
> >> +       size = round_up(proglen + sizeof(*hdr) + 128, round_up_to);
> >> +
> >> +       if (bpf_jit_charge_modmem(size))
> >> +               return NULL;
> >> +       hdr = bpf_jit_alloc_exec(size);
> >> +       if (!hdr) {
> >> +               bpf_jit_uncharge_modmem(size);
> >> +               return NULL;
> >> +       }
> >> +
> >> +       /* Fill space with illegal/arch-dep instructions. */
> >> +       bpf_fill_ill_insns(hdr, size);
> >> +
> >> +       hdr->size = size;
> >> +       hole = min_t(unsigned int, size - (proglen + sizeof(*hdr)),
> >> +                    PAGE_SIZE - sizeof(*hdr));
> >
> > It probably should be 'round_up_to' instead of PAGE_SIZE ?
>
> Actually, some of these change is not longer needed after the following
> change in v6:
>
>   4. Change fall back round_up_to in bpf_jit_binary_alloc_pack() from
>      BPF_PROG_MAX_PACK_PROG_SIZE to PAGE_SIZE.
>
> My initial thought (last year) was if we allocate more than 2MB (either
> 2.1MB or 3.9MB), we round up to 4MB to save page table entries.
> However, when I revisited this earlier today, I thought we should still
> round up to PAGE_SIZE to save memory
>
> Right now, I am not sure which way is better. What do you think? If we
> round up to PAGE_SIZE, we don't need split out __bpf_jit_binary_alloc().

The less code duplication the better.

> >
> >> +       start = (get_random_int() % hole) & ~(alignment - 1);
> >> +
> >> +       /* Leave a random number of instructions before BPF code. */
> >> +       *image_ptr = &hdr->image[start];
> >> +
> >> +       return hdr;
> >> +}
> >> +
> >> struct bpf_binary_header *
> >> bpf_jit_binary_alloc(unsigned int proglen, u8 **image_ptr,
> >>                     unsigned int alignment,
> >>                     bpf_jit_fill_hole_t bpf_fill_ill_insns)
> >> +{
> >> +       return __bpf_jit_binary_alloc(proglen, image_ptr, alignment,
> >> +                                     bpf_fill_ill_insns, PAGE_SIZE);
> >> +}
> >> +
> >> +struct bpf_binary_header *
> >> +bpf_jit_binary_alloc_pack(unsigned int proglen, u8 **image_ptr,
> >> +                         unsigned int alignment,
> >> +                         bpf_jit_fill_hole_t bpf_fill_ill_insns)
> >> {
> >>        struct bpf_binary_header *hdr;
> >>        u32 size, hole, start;
> >> @@ -875,11 +1034,16 @@ bpf_jit_binary_alloc(unsigned int proglen, u8 **image_ptr,
> >>         * fill a page, allow at least 128 extra bytes to insert a
> >>         * random section of illegal instructions.
> >>         */
> >> -       size = round_up(proglen + sizeof(*hdr) + 128, PAGE_SIZE);
> >> +       size = round_up(proglen + sizeof(*hdr) + 128, BPF_PROG_CHUNK_SIZE);
> >> +
> >> +       /* for too big program, use __bpf_jit_binary_alloc. */
> >> +       if (size > BPF_PROG_MAX_PACK_PROG_SIZE)
> >> +               return __bpf_jit_binary_alloc(proglen, image_ptr, alignment,
> >> +                                             bpf_fill_ill_insns, PAGE_SIZE);
> >>
> >>        if (bpf_jit_charge_modmem(size))
> >>                return NULL;
> >> -       hdr = bpf_jit_alloc_exec(size);
> >> +       hdr = bpf_prog_pack_alloc(size);
> >>        if (!hdr) {
> >>                bpf_jit_uncharge_modmem(size);
> >>                return NULL;
> >> @@ -888,9 +1052,8 @@ bpf_jit_binary_alloc(unsigned int proglen, u8 **image_ptr,
> >>        /* Fill space with illegal/arch-dep instructions. */
> >>        bpf_fill_ill_insns(hdr, size);
> >>
> >> -       hdr->size = size;
> >
> > I'm missing where it's assigned.
> > Looks like hdr->size stays zero, so free is never performed?
>
> This is read only memory, so we set it in bpf_fill_ill_insns(). There was a
> comment in x86/bpf_jit_comp.c. I guess we also need a comment here.

Ahh. Found it. Pls don't do it in fill_insn.
It's the wrong layering.
It feels that callbacks need to be redesigned.
I would operate on rw_header here and use
existing arch specific callback fill_insn to write into rw_image.
Both insns during JITing and 0xcc on both sides of the prog.
Populate rw_header->size (either before or after JITing)
and then do single text_poke_copy to write the whole thing
into the correct spot.
