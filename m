Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB12CB10A
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 23:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732305AbfJCVZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 17:25:44 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42888 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731710AbfJCVZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 17:25:44 -0400
Received: by mail-qt1-f193.google.com with SMTP id w14so5686733qto.9;
        Thu, 03 Oct 2019 14:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BSKuxHT2xAHCYLM1Ym0NERaeEGeJVbfWwClMg1Uc40w=;
        b=ZcT37FrK0BIQkeHKhDQoLXDbR6uy06PZYIV27tZpT38IpbAufO+4XSz5uuNZG3pnvJ
         45fkCbO0mKPThN3xiLAcHaFgMiIWtbhpAQQZs9fyTn+WPKezJTFdP/jdBLnPwTHk8vy2
         Vhl05+dLt1DqPBtw63ODDmLfKcoD0nZ9Jfkd4y7yPY1OEWCVC0PQktjNadXL9udQpkMT
         /1ag5tF3kCy2LL9TmsKpA9JR3m188pqFra/WNPkSQqco5XGDcBhUZtuaPxxrnDVHRHNx
         rzriaKYNQ7jGXv8xGV+jMOKtngqlINqumRQHlLUuiBFNYaiV8h1l54q20LPF+B2uYq/N
         Qvbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BSKuxHT2xAHCYLM1Ym0NERaeEGeJVbfWwClMg1Uc40w=;
        b=q3j5tJ3OAE/UMXBeksWcmadCJo0ZaZTEm42etGw+34/PCYsrJxj047TxVnbDh78IZU
         nINF+rcbRjVyaElo1A8jonzpjioyWoa4ItredDDddQaruQNgLG/p2gdjue3Xu/AJAmur
         uUKm4fL82hbPhhMz7+gIgZFDtNh5rocXsi401wApw83DigDCG8xiaiQ5CdGdY/z+fWRw
         sNal/OvyVhl4L0pb2oy/PPcyH2zLLyjtMiPXpq0ft26auIZI81/Zo5WtF+Dl9ZZ6xvqo
         0E6gVxfiglluLroo3iVh7Tt8AWLvKKiTFJlN0cAovVv6+cYDDoinhoQnTKRH5DqssP/Y
         c3Ew==
X-Gm-Message-State: APjAAAXlO/TXiqWFxmtkXC20ANWKZHhb0WFCtt7qVg5uAld9ECxCgXGJ
        cpCpf3xUU1ih5XWkYYQwBinYJVfp6bZBT2iHOyY=
X-Google-Smtp-Source: APXvYqzl1dVvK6AtYxU5EVWu5pb14Rh/y3kA2k+E0RVEMQrxFeCtEDSb68BqmyfndJ9XNOGq0/cnZDpuEy11rOZUbKE=
X-Received: by 2002:ac8:c01:: with SMTP id k1mr12124435qti.59.1570137943226;
 Thu, 03 Oct 2019 14:25:43 -0700 (PDT)
MIME-Version: 1.0
References: <20191002215041.1083058-1-andriin@fb.com> <20191002215041.1083058-7-andriin@fb.com>
 <CAPhsuW4OOx6nDwPpzjXmnKRj6dBaXuF=GVjG6D4YmF_OWwsKcA@mail.gmail.com>
In-Reply-To: <CAPhsuW4OOx6nDwPpzjXmnKRj6dBaXuF=GVjG6D4YmF_OWwsKcA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 3 Oct 2019 14:25:32 -0700
Message-ID: <CAEf4BzZmFELN7wzTPhQBfoQFaZkFO9EkUG+9Ws+FJsSCZu9+Sg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 6/7] libbpf: add BPF_CORE_READ/BPF_CORE_READ_INTO
 helpers
To:     Song Liu <liu.song.a23@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 3, 2019 at 1:35 PM Song Liu <liu.song.a23@gmail.com> wrote:
>
> On Wed, Oct 2, 2019 at 3:02 PM Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > Add few macros simplifying BCC-like multi-level probe reads, while also
> > emitting CO-RE relocations for each read.
> >
> > Acked-by: John Fastabend <john.fastabend@gmail.com>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/lib/bpf/bpf_helpers.h | 143 ++++++++++++++++++++++++++++++++++++
> >  1 file changed, 143 insertions(+)
> >
> > diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> > index cb9d4d2224af..847dfd7125e4 100644
> > --- a/tools/lib/bpf/bpf_helpers.h
> > +++ b/tools/lib/bpf/bpf_helpers.h
> > @@ -19,6 +19,10 @@
> >   */
> >  #define SEC(NAME) __attribute__((section(NAME), used))
> >
> > +#ifndef __always_inline
> > +#define __always_inline __attribute__((always_inline))
> > +#endif
> > +
> >  /* helper functions called from eBPF programs written in C */
> >  static void *(*bpf_map_lookup_elem)(void *map, const void *key) =
> >         (void *) BPF_FUNC_map_lookup_elem;
> > @@ -312,4 +316,143 @@ struct bpf_map_def {
> >         bpf_probe_read(dst, sz,                                             \
> >                        (const void *)__builtin_preserve_access_index(src))
> >
> > +/*
>
> nit: extra /*.
>
> Well, I actually don't have a strong preference with this. Just to highlight
> we are mixing two styles, which we already do in current bpf_helpers.h.

I made it consistent, thanks.

>
> There are multiple other instances below.
>
> Besides these.
>
> Acked-by: Song Liu <songliubraving@fb.com>
