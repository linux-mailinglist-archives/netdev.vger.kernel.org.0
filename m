Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC5D3D3E5F
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 19:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbhGWQid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 12:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhGWQiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 12:38:24 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265F0C061575;
        Fri, 23 Jul 2021 10:18:58 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id k65so3333204yba.13;
        Fri, 23 Jul 2021 10:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XYhOJx6SWRUy7hodbXYp4adRvpeYjlJi8muFxkL/D1Q=;
        b=eDqTLxR9Gw/Je8z62TzKChmp9FOXXH3A3ue1j7fkViu426FzOjKCXdP7/FS4oHHdeA
         RKrTOO2ebZn5Nh/e17gE74hSbNqtJcGIqzcRwRjoQVoS/YFx/we71+fdrVAKX+uFMsZ7
         xDdXiHfd4I31OoB4DZRt0GEAWjKzpf6mCurdmK5TxLI0/A0X+VQtJO0K63I/qTT2KZTN
         lKf15IIzXz1fNrNkexneTZ9D1x26oIhAsQGVMs/p8PGHbVvtBH7Sp7zy2XE/UuWdlvtP
         YP/gA/rvuI2/I7ShIDnV4zWxA6mpXJ1DaLfD9dTsdqHW64de4Zx/jQejVw1Xc+RmaDAs
         0OSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XYhOJx6SWRUy7hodbXYp4adRvpeYjlJi8muFxkL/D1Q=;
        b=eei+TLSRFijNe9BbJRehTdroqoaEUshvwJR+md1PaF32SvvZ1rOjVbmr4TBmCNzgiW
         c/5nTVTY+3lE9AEaQLlIEH5OMYlgtCQXvDt6dQsSUH1sXR+DaE3HzLcSya4RHpSEhwIM
         49GKub2m/RMkUJK1UPGlqOI2isdTbQOQq+FQF1TZ/8f9o+Aytf2AYCqHTxMXO1g68WFG
         g64lEBWdHBrwNf5i0Xe+sgOrlOS4kOJYGgxs+w6HXCdQohvF+TpUA/4tHC7BifR1I62e
         5Y4O2HP+kdPwa+WGJoCXOvFISRO8VQ8shzZBHW0tSOdKGJQzUOvDXRwbQ4WXTnsJEF6K
         6+XQ==
X-Gm-Message-State: AOAM533+sPO4N5VJj15XMwOJFGcSUtZeF7Y1gwgk0TSYNA5s2NNatMyK
        pyeQLS4Qdw09QXOgNi+jvUh8hv2uk1jWlKK7n14=
X-Google-Smtp-Source: ABdhPJweMZDH+WBXB+Sz0tUNWlFZSuAGAWbwZ+6Gv5YCnVMXWRKlBoAoYup+AJEeV9jTznmBHQlKno99DMdKuBTI2Uw=
X-Received: by 2002:a25:b203:: with SMTP id i3mr7699933ybj.260.1627060737365;
 Fri, 23 Jul 2021 10:18:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210721153808.6902-1-quentin@isovalent.com> <20210721153808.6902-3-quentin@isovalent.com>
 <CAEf4BzZqEZLt0_qgmniY-hqgEg7q0ur0Z5U0r8KFTwSz=2StSg@mail.gmail.com>
 <88d3cd19-5985-ad73-5f23-4f6f7d1b1be2@isovalent.com> <CAEf4BzY4jVKN=3CdaLU1WOekGbT915dweNx0R4KMrW8U7E20cw@mail.gmail.com>
 <004ebf5f-bac1-117b-e833-2f5ef6df0b4b@isovalent.com>
In-Reply-To: <004ebf5f-bac1-117b-e833-2f5ef6df0b4b@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 23 Jul 2021 10:18:46 -0700
Message-ID: <CAEf4BzZAW_n=tgCNvsDY83FRL37DY_wODfhp+XNr6DA7C3A1qw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/5] libbpf: rename btf__get_from_id() as btf__load_from_kernel_by_id()
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 9:13 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2021-07-23 08:54 UTC-0700 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > On Fri, Jul 23, 2021 at 2:31 AM Quentin Monnet <quentin@isovalent.com> wrote:
> >>
> >> 2021-07-22 17:39 UTC-0700 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
> >>> On Wed, Jul 21, 2021 at 8:38 AM Quentin Monnet <quentin@isovalent.com> wrote:
> >>>>
> >>>> Rename function btf__get_from_id() as btf__load_from_kernel_by_id() to
> >>>> better indicate what the function does. Change the new function so that,
> >>>> instead of requiring a pointer to the pointer to update and returning
> >>>> with an error code, it takes a single argument (the id of the BTF
> >>>> object) and returns the corresponding pointer. This is more in line with
> >>>> the existing constructors.
> >>>>
> >>>> The other tools calling the deprecated btf__get_from_id() function will
> >>>> be updated in a future commit.
> >>>>
> >>>> References:
> >>>>
> >>>> - https://github.com/libbpf/libbpf/issues/278
> >>>> - https://github.com/libbpf/libbpf/wiki/Libbpf:-the-road-to-v1.0#btfh-apis
> >>>>
>
> >>>> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> >>>> index 7e0de560490e..6654bdee7ad7 100644
> >>>> --- a/tools/lib/bpf/btf.c
> >>>> +++ b/tools/lib/bpf/btf.c
> >>>> @@ -1383,21 +1383,30 @@ struct btf *btf_get_from_fd(int btf_fd, struct btf *base_btf)
> >>>>         return btf;
> >>>>  }
> >>>>
> >>>> +struct btf *btf__load_from_kernel_by_id(__u32 id)
> >>>> +{
> >>>> +       struct btf *btf;
> >>>> +       int btf_fd;
> >>>> +
> >>>> +       btf_fd = bpf_btf_get_fd_by_id(id);
> >>>> +       if (btf_fd < 0)
> >>>> +               return ERR_PTR(-errno);
> >>>
> >>> please use libbpf_err_ptr() for consistency, see
> >>> bpf_object__open_mem() for an example
> >>
> >> I can do that, but I'll need to uncouple btf__get_from_id() from the new
> >> function. If it calls btf__load_from_kernel_by_id() and
> >> LIBBPF_STRICT_CLEAN_PTRS is set, it would change its return value.
> >
> > No it won't, if libbpf_get_error() is used right after the API call.
>
> But we cannot be sure that users currently call libbpf_get_error() after
> btf__get_from_id()? I'm fine if we assume they do (users currently
> selecting the CLEAN_PTRS are probably savvy enough to call it I guess),
> I'll update as you suggest.

I think you are still confused. It doesn't matter what the user does,
the contract is for libbpf API to either return ERR_PTR(err) if no
CLEAN_PTRS is requested, or return NULL and set errno to -err.
libbpf_err_ptr() does that from inside the libbpf API (so you don't
have to check CLEAN_PTRS explicitly, you are just passing an error to
be returned, regardless of libbpf mode).

If a user opted into CLEAN_PTRS, they don't have to use
libbpf_get_error(), it's enough to check for NULL. If they care about
the error code itself, they'll need to use -errno. If they haven't
opted into CLEAN_PTRS yet, they have to use libbpf_get_error(), as
that's the only supported way. Sure, they could check for NULL and
that's a bug (and that's a very common one, which motivated
CLEAN_PTRS), or they implement the IS_ERR() macro from the kernel
(which is not officially supported, but works, of course). But again,
all that is orthogonal to how libbpf has to return errors from inside
for pointer-returning APIs.

>
> > With CLEAN_PTRS the result pointer is NULL but actual error is passed
> > through errno. libbpf_get_error() knows about this and extracts error
> > from errno if passed NULL pointer. With returning ERR_PTR(-errno) from
> > btf__load_from_kernel_by_id() you are breaking CLEAN_PTRS guarantees.
> OK right, this makes sense to me for btf__load_from_kernel_by_id().
