Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31D6749686A
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 00:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbiAUXz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 18:55:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiAUXz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 18:55:26 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545D0C06173B;
        Fri, 21 Jan 2022 15:55:26 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id d5so8086101pjk.5;
        Fri, 21 Jan 2022 15:55:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q8HQt1HvGyw6p2m9jE0xI96X7Drt+WwhJJItVuCPdG4=;
        b=AEn3ht+IvGHRh+8N2pnJhxmlOQxdgAcLE62J40D76oDg3HTNW2LI0IC5t8s+/fgRZR
         n4oIQYpZNAYulc9nvN+b7EMOwNWMUPygVccUBjj/vhUIXX7b5IWwe9OHPKkAEyPZcFSu
         5+U6IU8MYGETZY7qh/eL9qnshHH+14EREYGRUR+p+22k9gNc7YOYsubGRGfHPYcgL9GE
         NHZjIOaUgLDikXWKZ8PNWkt4chPfHsXyBAyQcBNAG41rGk/l4XZQQ9cIEN+u9ayL2fii
         OZo1GJBdkyVm1Wfd6tiTHzy8YrOFY2CebPcQLWd25GPDcUJ1jhNW3MXAppkBc4ACpSSw
         GrHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q8HQt1HvGyw6p2m9jE0xI96X7Drt+WwhJJItVuCPdG4=;
        b=UuiWopMktPOYS5lYZwPoAEoDZ5scfSDYBzNNkL5D7dXRBtx9SuMviadnDqJJsS2JPt
         +iculaQtj8KC5mVdvuaVc8QG7IGd0sjMyEQSZP15FPO0bVXcAnfNLMoFrF6mJuw2+unr
         3F9+fmywcPiPISF71QaO+ghkzTLp2F7x21wGJ4cNijdySa49Zph+GhNUC4VMhqGVuQ7L
         rsG2IFzRs/O+mu/4pPgNR+4k/k3YxK1bgcn2ND9Qjro1YwGnyVo+kyRMhxIrqeNi4YDR
         lcVSPfHEX0oBuKCavkPL7HdAdOGqV0/mmIi21snEYW2UiPVRw8jsx8hawJrjzMGi2t0J
         rSug==
X-Gm-Message-State: AOAM531+ZpxSn2spcGO2q2JTeO40AI8is1cy5/RGLci0DhBkFRg56nfy
        pY9xQqNz8qyQYWcMgQllCfs6ApXVJuohBbaAG7HYtpbZC6g=
X-Google-Smtp-Source: ABdhPJx86p3K7XTaMBGZAt5t6KGfJNh508gK3uEngsI/OO5MJW6GbRwsKvZTTAPLgnbfwt3tSHrhBg3IaYflv0hOL1g=
X-Received: by 2002:a17:90a:c78b:: with SMTP id gn11mr3015934pjb.138.1642809325739;
 Fri, 21 Jan 2022 15:55:25 -0800 (PST)
MIME-Version: 1.0
References: <20220121194926.1970172-1-song@kernel.org> <20220121194926.1970172-7-song@kernel.org>
In-Reply-To: <20220121194926.1970172-7-song@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 21 Jan 2022 15:55:14 -0800
Message-ID: <CAADnVQK6+gWTUDo2z1H6AE5_DtuBBetW+VTwwKz03tpVdfuoHA@mail.gmail.com>
Subject: Re: [PATCH v6 bpf-next 6/7] bpf: introduce bpf_prog_pack allocator
To:     Song Liu <song@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, X86 ML <x86@kernel.org>,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 11:49 AM Song Liu <song@kernel.org> wrote:
>
> +static struct bpf_binary_header *
> +__bpf_jit_binary_alloc(unsigned int proglen, u8 **image_ptr,
> +                      unsigned int alignment,
> +                      bpf_jit_fill_hole_t bpf_fill_ill_insns,
> +                      u32 round_up_to)
> +{
> +       struct bpf_binary_header *hdr;
> +       u32 size, hole, start;
> +
> +       WARN_ON_ONCE(!is_power_of_2(alignment) ||
> +                    alignment > BPF_IMAGE_ALIGNMENT);
> +
> +       /* Most of BPF filters are really small, but if some of them
> +        * fill a page, allow at least 128 extra bytes to insert a
> +        * random section of illegal instructions.
> +        */
> +       size = round_up(proglen + sizeof(*hdr) + 128, round_up_to);
> +
> +       if (bpf_jit_charge_modmem(size))
> +               return NULL;
> +       hdr = bpf_jit_alloc_exec(size);
> +       if (!hdr) {
> +               bpf_jit_uncharge_modmem(size);
> +               return NULL;
> +       }
> +
> +       /* Fill space with illegal/arch-dep instructions. */
> +       bpf_fill_ill_insns(hdr, size);
> +
> +       hdr->size = size;
> +       hole = min_t(unsigned int, size - (proglen + sizeof(*hdr)),
> +                    PAGE_SIZE - sizeof(*hdr));

It probably should be 'round_up_to' instead of PAGE_SIZE ?

> +       start = (get_random_int() % hole) & ~(alignment - 1);
> +
> +       /* Leave a random number of instructions before BPF code. */
> +       *image_ptr = &hdr->image[start];
> +
> +       return hdr;
> +}
> +
>  struct bpf_binary_header *
>  bpf_jit_binary_alloc(unsigned int proglen, u8 **image_ptr,
>                      unsigned int alignment,
>                      bpf_jit_fill_hole_t bpf_fill_ill_insns)
> +{
> +       return __bpf_jit_binary_alloc(proglen, image_ptr, alignment,
> +                                     bpf_fill_ill_insns, PAGE_SIZE);
> +}
> +
> +struct bpf_binary_header *
> +bpf_jit_binary_alloc_pack(unsigned int proglen, u8 **image_ptr,
> +                         unsigned int alignment,
> +                         bpf_jit_fill_hole_t bpf_fill_ill_insns)
>  {
>         struct bpf_binary_header *hdr;
>         u32 size, hole, start;
> @@ -875,11 +1034,16 @@ bpf_jit_binary_alloc(unsigned int proglen, u8 **image_ptr,
>          * fill a page, allow at least 128 extra bytes to insert a
>          * random section of illegal instructions.
>          */
> -       size = round_up(proglen + sizeof(*hdr) + 128, PAGE_SIZE);
> +       size = round_up(proglen + sizeof(*hdr) + 128, BPF_PROG_CHUNK_SIZE);
> +
> +       /* for too big program, use __bpf_jit_binary_alloc. */
> +       if (size > BPF_PROG_MAX_PACK_PROG_SIZE)
> +               return __bpf_jit_binary_alloc(proglen, image_ptr, alignment,
> +                                             bpf_fill_ill_insns, PAGE_SIZE);
>
>         if (bpf_jit_charge_modmem(size))
>                 return NULL;
> -       hdr = bpf_jit_alloc_exec(size);
> +       hdr = bpf_prog_pack_alloc(size);
>         if (!hdr) {
>                 bpf_jit_uncharge_modmem(size);
>                 return NULL;
> @@ -888,9 +1052,8 @@ bpf_jit_binary_alloc(unsigned int proglen, u8 **image_ptr,
>         /* Fill space with illegal/arch-dep instructions. */
>         bpf_fill_ill_insns(hdr, size);
>
> -       hdr->size = size;

I'm missing where it's assigned.
Looks like hdr->size stays zero, so free is never performed?

>         hole = min_t(unsigned int, size - (proglen + sizeof(*hdr)),
> -                    PAGE_SIZE - sizeof(*hdr));
> +                    BPF_PROG_CHUNK_SIZE - sizeof(*hdr));

Before this change size - (proglen + sizeof(*hdr)) would
be at least 128 and potentially bigger than PAGE_SIZE
when extra 128 crossed page boundary.
Hence min() was necessary with the 2nd arg being PAGE_SIZE - sizeof(*hdr).

With new code size - (proglen + sizeof(*hdr)) would
be between 128 and 128+64
while BPF_PROG_CHUNK_SIZE - sizeof(*hdr) is a constant less than 64.
What is the point of min() ?
