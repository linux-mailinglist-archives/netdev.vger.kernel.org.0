Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 662AFF35AE
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 18:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730573AbfKGR1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 12:27:08 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:34144 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730319AbfKGR1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 12:27:07 -0500
Received: by mail-qt1-f194.google.com with SMTP id c25so2592562qtq.1;
        Thu, 07 Nov 2019 09:27:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bNUfjY9utjUqmccXjc19478lbAnU/rdMUiXY2rfvMAA=;
        b=LTWuzWL1Rsl9bjpfLOlibZaV8vBvTUHoNaT6p7wD6H9AbyykBb24bjsCL+ziuISh+4
         9OLx6PFfBFNALGQnkMoJt8aD4gfhKRBQ0vuPpVgaP/SRiRgGoabLjW2bTSlSjyZXxm//
         GrjimIlAsc0pybM9jeB1CHn4OsdQokGTh//kFflXDCko52aH+Vjf8Mhui+yLM1iUQ/xY
         eeXUuTuSKbYUVvkAQySeSQOmRFhGNa/zbB1xqjGYBTwc6zN/5JdaUqQ2i+2bpdrmK/3P
         fX9mlXouUbW8zBU7c6DlLBNL/NlPkI3wqVvO3z2N9RpprhBTeipFsztlbyvVmuche1Rz
         Qf/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bNUfjY9utjUqmccXjc19478lbAnU/rdMUiXY2rfvMAA=;
        b=Dfl+RfiYUnJURhJjgcrgKyZJc9KTCX8wnpvI9fbLzKES1sLbU7rvpQOqjhJ332sDhg
         Om21B2tnJpB0eXT6AjWEuppbgEbW60eGC84aG2f2vng8okS1vFDIbhAS45PYIJSA5Mqp
         Htku07c1k+7xSdd9OqFd6wdILrovsd3WEta47BChcdeAOphGOEoFyxnEHgVDHYrpxIdc
         n3hRkZggqA+m+lifqJz1CaoVt629nQ6/WcG87unamCStvYCGH8pfaiX/HcDkbryUll/I
         g8n9R4TnWhrBb+Xg/5w3z4ebC1Nu+ArA0/Ggzhz7IplmN7gWE8BWPeUS2+sY8bKC6tBG
         p04Q==
X-Gm-Message-State: APjAAAVfwtVYFipnGDJ5UlVDO82d3qcOObQhCQMgKvjTUnKELhBRLGXw
        UiQZTFWpw4dSo+DXvbYQk3hBRwmZbjZDhyymKIE=
X-Google-Smtp-Source: APXvYqz1Y5If41prJI1O7jXyuvj7V2dEB/Oj5QBeF/66Mhsxij3ZAYkR1kM5KBwFBjxS0xyqa1drizBaZvZGfdDSLew=
X-Received: by 2002:ac8:4890:: with SMTP id i16mr4899105qtq.141.1573147626539;
 Thu, 07 Nov 2019 09:27:06 -0800 (PST)
MIME-Version: 1.0
References: <20191107014639.384014-1-kafai@fb.com> <20191107014643.384298-1-kafai@fb.com>
 <CAEf4BzaQOEjbJwV9Ycb1QdBVkFRQLB_3cyw1sfXTz-iV_pt4Yw@mail.gmail.com> <20191107172243.ptq3yqeacxjkmkbq@kafai-mbp>
In-Reply-To: <20191107172243.ptq3yqeacxjkmkbq@kafai-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 7 Nov 2019 09:26:55 -0800
Message-ID: <CAEf4BzbW9h68A=KhxtFYsS8gU7G0GrMT1671S6Vg95OSEVY-Lg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 2/3] bpf: Add array support to btf_struct_access
To:     Martin Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 7, 2019 at 9:22 AM Martin Lau <kafai@fb.com> wrote:
>
> On Wed, Nov 06, 2019 at 06:41:15PM -0800, Andrii Nakryiko wrote:
> > On Wed, Nov 6, 2019 at 5:49 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > This patch adds array support to btf_struct_access().
> > > It supports array of int, array of struct and multidimensional
> > > array.
> > >
> > > It also allows using u8[] as a scratch space.  For example,
> > > it allows access the "char cb[48]" with size larger than
> > > the array's element "char".  Another potential use case is
> > > "u64 icsk_ca_priv[]" in the tcp congestion control.
> > >
> > > btf_resolve_size() is added to resolve the size of any type.
> > > It will follow the modifier if there is any.  Please
> > > see the function comment for details.
> > >
> > > This patch also adds the "off < moff" check at the beginning
> > > of the for loop.  It is to reject cases when "off" is pointing
> > > to a "hole" in a struct.
> > >
> > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > ---
> >
> > Looks good, just two small nits.
> >
> > Acked-by: Andrii Nakryiko <andriin@fb.com>
> >
> > >  kernel/bpf/btf.c | 187 +++++++++++++++++++++++++++++++++++++++--------
> > >  1 file changed, 157 insertions(+), 30 deletions(-)
> > >
> > > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > > index 128d89601d73..5c4b6aa7b9f0 100644
> > > --- a/kernel/bpf/btf.c
> > > +++ b/kernel/bpf/btf.c
> > > @@ -1036,6 +1036,82 @@ static const struct resolve_vertex *env_stack_peak(struct btf_verifier_env *env)
> > >         return env->top_stack ? &env->stack[env->top_stack - 1] : NULL;
> > >  }
> > >
> >
> > [...]
> >
> > > -               if (off + size <= moff / 8)
> > > -                       /* won't find anything, field is already too far */
> > > +               /* offset of the field in bytes */
> > > +               moff = btf_member_bit_offset(t, member) / 8;
> > > +               if (off + size <= moff)
> >
> > you dropped useful comment :(
> good catch. will undo.

thanks!

>
> >
> > >                         break;
> > > +               /* In case of "off" is pointing to holes of a struct */
> > > +               if (off < moff)
> > > +                       continue;
> > >
> >
> > [...]
> >
> > > +
> > > +               mtrue_end = moff + msize;
> >
> > nit: there is no other _end, so might be just mend (in line with moff)
> I prefer to keep it.  For array, this _end is not the end of mtype.
> The intention is to distinguish it from the mtype/msize convention
> such that it is the true_end of the current struct's member.  I will
> add some comments to clarify.

Ok, sure, no problem.

>
> >
> > > +               if (off >= mtrue_end)
> > >                         /* no overlap with member, keep iterating */
> > >                         continue;
> > > +
> >
> > [...]
