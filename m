Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF86B1D8D22
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 03:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727957AbgESBad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 21:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgESBac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 21:30:32 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AF9C061A0C;
        Mon, 18 May 2020 18:30:32 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id dh1so1874872qvb.13;
        Mon, 18 May 2020 18:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dKVPJF/NEdnmBXWDMMPJJBCWq4APWNkeLoswoZMG3Ww=;
        b=I75n233fSllmNqXPDvlYaKSzbi9lYJnoYrDss99O5N5J83UuSJ/DxQY+YqNsWWGKY6
         4nbbPnTvENBt04qqdbjofYwUwQPUsHSyjZj5zviEWx5HPBHx6MAvMSgXwy0IM7C3Vq/4
         KakPFaUf4vfhQJ1h039eq5zTM2f6UkNWa+BOiXTaxIkFhuJOHPruDh5sVcFz0L3Xp32G
         KFo4K1L4v/hrT/UuuMwR5rsodFFR3Loe1OHWPjnXI0UIvOL9azOyAzhrC/GwU0XI6JIX
         DNC0C1pGBenK+qCtFlxQjIDN88Xdwh21c7W/2QV89PTOKrvMIpmi7b1I6MEHCLBGFy0u
         X7BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dKVPJF/NEdnmBXWDMMPJJBCWq4APWNkeLoswoZMG3Ww=;
        b=pW/mTdrUVje8Dys2rtzgw1iMV1t1BA+z1cJqutIW9ByY4qPkfF8xc83QSvzLW04Wt7
         L0IefGSIQkRFumsd3AqIDcjyQ/H6e7P3ZuMxPZm5t0hOjDagbN5XS4BVV/0KYsHYrhVR
         /c25emBBera7cOsB0j3flW60pX01PYT79sHOYIM0Q8x3kA7cU3oibzeJJw4nMjCyrBvU
         6ufIem9bsrkJkG//f8oql5D8xHWNjgye3C0tFh3yJSfzc+qD5z9fT5wFI4O8ENyOwakx
         PaqVkxHX4lGxftMoLpoiMhjDRR4ZZE89EkizaYFyZd2JWUFGbnS54E7JhM4TBdjigmgy
         Ccxw==
X-Gm-Message-State: AOAM532u40N96O+y1aOg6EMCFdHBRhiVP74ix0LFfGAUWh2KjL+hFevP
        hVFMHHGF+EsRhQuV6IQgHu2Kq5J6E9gJEIy4jds=
X-Google-Smtp-Source: ABdhPJwduNWTZvoufiV1M2qPAsvy9XRLIUzSaqdPrQn350b2t77KBGnh6PwB9dY3VQ6J9ODHIUKoegKuft0fwP6UwN4=
X-Received: by 2002:ad4:55ea:: with SMTP id bu10mr19629870qvb.163.1589851831727;
 Mon, 18 May 2020 18:30:31 -0700 (PDT)
MIME-Version: 1.0
References: <CAG=TAF6mfrwxF1-xEJJ9dL675uMUa7RZrOa_eL2mJizZJ-U7iQ@mail.gmail.com>
 <CAEf4BzazvGOoJbm+zNMqTjhTPJAnVLVv9V=rXkdXZELJ4FPtiA@mail.gmail.com>
 <CAG=TAF6aqo-sT2YE30riqp7f47KyXH_uhNJ=M9L12QU6EEEfqQ@mail.gmail.com>
 <CAEf4BzaBfnDL=WpRP-7rYFhocOsCQyFuZaLvM0+k9sv2t_=rVw@mail.gmail.com> <45f9ef5d-18e3-c92f-e7a9-1c6d6405e478@fb.com>
In-Reply-To: <45f9ef5d-18e3-c92f-e7a9-1c6d6405e478@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 18 May 2020 18:30:20 -0700
Message-ID: <CAEf4Bza4++AxxU4ikMEfjeYLMiudWqc=Tk=5iTeBBNRjZjZZkQ@mail.gmail.com>
Subject: Re: UBSAN: array-index-out-of-bounds in kernel/bpf/arraymap.c:177
To:     Yonghong Song <yhs@fb.com>
Cc:     Qian Cai <cai@lca.pw>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 18, 2020 at 6:00 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 5/18/20 5:25 PM, Andrii Nakryiko wrote:
> > On Mon, May 18, 2020 at 5:09 PM Qian Cai <cai@lca.pw> wrote:
> >>
> >> On Mon, May 18, 2020 at 7:55 PM Andrii Nakryiko
> >> <andrii.nakryiko@gmail.com> wrote:
> >>>
> >>> On Sun, May 17, 2020 at 7:45 PM Qian Cai <cai@lca.pw> wrote:
> >>>>
> >>>> With Clang 9.0.1,
> >>>>
> >>>> return array->value + array->elem_size * (index & array->index_mask);
> >>>>
> >>>> but array->value is,
> >>>>
> >>>> char value[0] __aligned(8);
> >>>
> >>> This, and ptrs and pptrs, should be flexible arrays. But they are in a
> >>> union, and unions don't support flexible arrays. Putting each of them
> >>> into anonymous struct field also doesn't work:
> >>>
> >>> /data/users/andriin/linux/include/linux/bpf.h:820:18: error: flexible
> >>> array member in a struct with no named members
> >>>     struct { void *ptrs[] __aligned(8); };
> >>>
> >>> So it probably has to stay this way. Is there a way to silence UBSAN
> >>> for this particular case?
> >>
> >> I am not aware of any way to disable a particular function in UBSAN
> >> except for the whole file in kernel/bpf/Makefile,
> >>
> >> UBSAN_SANITIZE_arraymap.o := n
> >>
> >> If there is no better way to do it, I'll send a patch for it.
> >
> >
> > That's probably going to be too drastic, we still would want to
> > validate the rest of arraymap.c code, probably. Not sure, maybe
> > someone else has better ideas.
>
> Maybe something like below?
>
>    struct bpf_array {
>          struct bpf_map map;
>          u32 elem_size;
>          u32 index_mask;
>          struct bpf_array_aux *aux;
>          union {
>                  char value;
>                  void *ptrs;
>                  void __percpu *pptrs;
>          } u[] __aligned(8);

That will require wider code changes, and would look quite unnatural:

array->u[whatever].pptrs

instead of current

array->pptrs[whatever]

>    };
