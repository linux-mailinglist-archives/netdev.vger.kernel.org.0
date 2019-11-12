Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84925F9CC0
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 23:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfKLWEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 17:04:02 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:39345 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726896AbfKLWEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 17:04:02 -0500
Received: by mail-qt1-f194.google.com with SMTP id t8so210876qtc.6;
        Tue, 12 Nov 2019 14:04:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qchgFnXkW5hmO+rd/GICcBGT90gKS/uvPtjNgVlolsY=;
        b=oTCIy34WdLasU1zMoNNh1s9Edrec2oWtenxgLHF2PHp0AIr12T5CIYIXugOdwBIHTq
         4gv0Yw9BY3FCIofgEzO/cSF7W263CHWrjY3ZQMdnh5yo79CLapgAY6qFIwcZbUjOUBrG
         aIxnDMsc8LK/AA0z/pygyYRuJSPE6p7rJXuKFbXXz4/00u+FZiqB+ozgj9N8q8jEjm2I
         E7WnwOgXhL/FL69CrTtvfp4a1P8NjxsipxhUKk4oF6mkBz4zVuFM0n9HVrOZ7irB31VM
         rSUbZUyanBbVNIO3pDH4VNBEvdpgr9y1CxbrwQI7xLRP905WtZC2pXOWfwLvWE0vJ+Uf
         l8Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qchgFnXkW5hmO+rd/GICcBGT90gKS/uvPtjNgVlolsY=;
        b=GNuNyT+tksk0Q344lp0MJZVDcu9J6DRTinCHCfxeL4s8MwV3zOJA+JWYl2LCRgqBIP
         +jUfsNjzEGVN5FjP0DYvuFnQJw5JwZDW9A6NmVjqBtG7kfMXnPROiXugQOjWCT27Aa/N
         PXtI4636w4o+P2RRCMcYoKGEi3xF4eyKdDkSyQ/6yT2mSMdysq5OlHBV4bEpwkrgC8RR
         X58MqdWfNTAX0H0EKfp4f3OrBVkFmgvXkyLbKIcBE0LUg9tcT6IkF8gu5v7lkCRTg6OM
         KwgFk0ArqHQs8PlocDLgUKQkbyL2HuXkAeEAvgjbt6VtICJ11BjJvOftmognQYivU99V
         qhMA==
X-Gm-Message-State: APjAAAURr9ICsLJk5asM/t44LSMQ2zGh/6Y6HZAYd+s72lfsSHsizSoV
        xV7bIW6D9aGk+iaCEqyXZXrnGJSblXjAUg63U4c=
X-Google-Smtp-Source: APXvYqzzWdncV+0bgiPmO/AMbdJP4M7hoh1SkUMgCm9OrTYosctedDVFOpaHhY42ZzyyblH7twXnNSnizcPWFB+Q8Z8=
X-Received: by 2002:ac8:3fed:: with SMTP id v42mr33263518qtk.171.1573596241395;
 Tue, 12 Nov 2019 14:04:01 -0800 (PST)
MIME-Version: 1.0
References: <20191109080633.2855561-1-andriin@fb.com> <20191109080633.2855561-2-andriin@fb.com>
 <20191111103743.1c3a38a3@cakuba> <CAEf4Bzay-sCd5+5Y1+toJuEd6vNh+R7pkosYA7V7wDqTdoDxdw@mail.gmail.com>
 <20191112111750.2168b131@cakuba>
In-Reply-To: <20191112111750.2168b131@cakuba>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 12 Nov 2019 14:03:50 -0800
Message-ID: <CAEf4Bzbx0WvgX9uGF4U1HM41m6kfdvWHCeYBSBRnQhR3egGy5w@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: add mmap() support for BPF_MAP_TYPE_ARRAY
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Rik van Riel <riel@surriel.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 11:17 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Mon, 11 Nov 2019 18:06:42 -0800, Andrii Nakryiko wrote:
> > So let's say if sizeof(struct bpf_array) is 300, then I'd have to either:
> >
> > - somehow make sure that I allocate 4k (for data) + 300 (for struct
> > bpf_array) in such a way that those 4k of data are 4k-aligned. Is
> > there any way to do that?
> > - assuming there isn't, then another way would be to allocate entire
> > 4k page for struct bpf_array itself, but put it at the end of that
> > page, so that 4k of data is 4k-aligned. While wasteful, the bigger
> > problem is that pointer to bpf_array is not a pointer to allocated
> > memory anymore, so we'd need to remember that and adjust address
> > before calling vfree().
> >
> > Were you suggesting #2 as a solution? Or am I missing some other way to do this?
>
> I am suggesting #2, that's the way to do it in the kernel.

So I'm concerned about this approach, because it feels like a bunch of
unnecessarily wasted memory. While there is no way around doing
round_up(PAGE_SIZE) for data itself, it certainly is not necessary to
waste almost entire page for struct bpf_array. And given this is going
to be used for BPF maps backing global variables, there most probably
will be at least 3 (.data, .bss, .rodata) per each program, and could
be more. Also, while on x86_64 page is 4k, on other architectures it
can be up to 64KB, so this seems wasteful.

What's your concern exactly with the way it's implemented in this patch?

>
> You could make the assumption that if you're allocating memory aligned
> to PAGE_SIZE, the address for vfree() is:
>
>         addr = map;
>         if (map->flags & MMAPABLE)
>                 addr = round_down(addr, PAGE_SIZE);
>         vfree(addr);
>
> Just make a note of the fact that we depend on vmalloc()s alignment in
> bpf_map_area_alloc().

will add comment for that
