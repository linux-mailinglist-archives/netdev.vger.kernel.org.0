Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 981272A3B9F
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 06:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbgKCFCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 00:02:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbgKCFCv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 00:02:51 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12388C0617A6;
        Mon,  2 Nov 2020 21:02:50 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id s89so13720996ybi.12;
        Mon, 02 Nov 2020 21:02:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y/zf1fidHoOUMZMOng7SS2sBqt5LEfn99qbN9X6BnF4=;
        b=Nq7IDZtBmq+EoQXtOIVIGJ0O+dMGzTU1ntfVsajoCtFsotDvv2n/D7XCCVIikdY+Ug
         FqF/m9dDy6+oQS2lj+DvVgM/s6ohv8bZMF03Kz63NUGvUip6yUJeAxkNz0UAH0/EmCj/
         C8K3u4JwTKxjl7M7ZyGq0n2m5BdsCVsGS/umekWBFm5OCBzcEk3FYq5/H+Jh3EnVQVIV
         uEHI3wDy4cqhM667lXhYaBinoWW+aNhjuRMHLpgBVvqbKIixGyb64AVYbQRdjeQJVZTI
         yt0yYZqEWcGfSv0Cs9u418JF7NldEjyU5lXipXvhlcbT82Sg2E7SpHCuIFqi6m/ka4M6
         zybQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y/zf1fidHoOUMZMOng7SS2sBqt5LEfn99qbN9X6BnF4=;
        b=W4soCdsN4EtFctCANvGSFoifdi3QW36JxPt8nQtg8y1uRI67/j/qEKU6BBkcEXO8P2
         BtHUr7CEJ9njihXUNNkTDCN4swmWUHEAkSTBcYpMzYLR2tkarU+uAyvavfK/jTEl/PTC
         VKJG7z0wIAWjHxvs6RXqYdtsrKeAtmHhnK7OnbYigp2fyY2+I3xGWmu5Lbm0hTgFdnOp
         uRbN2KOX0z9ikP1qPKfe2JAGJfQnojy1iz8BQQ/Oe4AvVaIdVfoV7GrIAt/EAtphdfC8
         rrs7QzR5904JbHcqtnR/i/3acw7x0R8SmXtrBHsed9R2kDrjAhOYQGe8Su8j/qIbVENH
         XHhA==
X-Gm-Message-State: AOAM533HM6LmWcD/GjwMxedYYctDfvHa/YZG8zbY93Q6ERyhGuUc5EkE
        TxyNalp1ikqO6wzs9hoSPfYZzHNmdAAxLMiyNC3bWCJaLlyj9w==
X-Google-Smtp-Source: ABdhPJxYWKmEL1x9/hs3HcsGG1MSubj9RdjhrnuFkSmgKPjEnib23Y3+y33FKIhztW3sZwahsvkFgJeM5rbXwsgkLIA=
X-Received: by 2002:a25:3443:: with SMTP id b64mr25057604yba.510.1604379769346;
 Mon, 02 Nov 2020 21:02:49 -0800 (PST)
MIME-Version: 1.0
References: <20201029005902.1706310-1-andrii@kernel.org> <20201029005902.1706310-5-andrii@kernel.org>
 <DE5FDF1D-0E5B-409B-80DF-EDA5349FE3A6@fb.com>
In-Reply-To: <DE5FDF1D-0E5B-409B-80DF-EDA5349FE3A6@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 2 Nov 2020 21:02:38 -0800
Message-ID: <CAEf4BzanQsEopXA7cGQi51hf_Q0hNb7NUTvtnkD8xg9AHoU9Ng@mail.gmail.com>
Subject: Re: [PATCH bpf-next 04/11] libbpf: implement basic split BTF support
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 2, 2020 at 3:24 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Oct 28, 2020, at 5:58 PM, Andrii Nakryiko <andrii@kernel.org> wrote:
> >
>
> [...]
>
> >
> > BTF deduplication is not yet supported for split BTF and support for it will
> > be added in separate patch.
> >
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>
> Acked-by: Song Liu <songliubraving@fb.com>
>
> With a couple nits:
>
> > ---
> > tools/lib/bpf/btf.c      | 205 ++++++++++++++++++++++++++++++---------
> > tools/lib/bpf/btf.h      |   8 ++
> > tools/lib/bpf/libbpf.map |   9 ++
> > 3 files changed, 175 insertions(+), 47 deletions(-)
> >
> > diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> > index db9331fea672..20c64a8441a8 100644
> > --- a/tools/lib/bpf/btf.c
> > +++ b/tools/lib/bpf/btf.c
> > @@ -78,10 +78,32 @@ struct btf {
> >       void *types_data;
> >       size_t types_data_cap; /* used size stored in hdr->type_len */
> >
> > -     /* type ID to `struct btf_type *` lookup index */
> > +     /* type ID to `struct btf_type *` lookup index
> > +      * type_offs[0] corresponds to the first non-VOID type:
> > +      *   - for base BTF it's type [1];
> > +      *   - for split BTF it's the first non-base BTF type.
> > +      */
> >       __u32 *type_offs;
> >       size_t type_offs_cap;
> > +     /* number of types in this BTF instance:
> > +      *   - doesn't include special [0] void type;
> > +      *   - for split BTF counts number of types added on top of base BTF.
> > +      */
> >       __u32 nr_types;
>
> This is a little confusing. Maybe add a void type for every split BTF?

Agree about being a bit confusing. But I don't want VOID in every BTF,
that seems sloppy (there's no continuity). I'm currently doing similar
changes on kernel side, and so far everything also works cleanly with
start_id == 0 && nr_types including VOID (for base BTF), and start_id
== base_btf->nr_type && nr_types has all the added types (for split
BTF). That seems a bit more straightforward, so I'll probably do that
here as well (unless I'm missing something, I'll double check).

>
> > +     /* if not NULL, points to the base BTF on top of which the current
> > +      * split BTF is based
> > +      */
>
> [...]
>
> >
> > @@ -252,12 +274,20 @@ static int btf_parse_str_sec(struct btf *btf)
> >       const char *start = btf->strs_data;
> >       const char *end = start + btf->hdr->str_len;
> >
> > -     if (!hdr->str_len || hdr->str_len - 1 > BTF_MAX_STR_OFFSET ||
> > -         start[0] || end[-1]) {
> > -             pr_debug("Invalid BTF string section\n");
> > -             return -EINVAL;
> > +     if (btf->base_btf) {
> > +             if (hdr->str_len == 0)
> > +                     return 0;
> > +             if (hdr->str_len - 1 > BTF_MAX_STR_OFFSET || end[-1]) {
> > +                     pr_debug("Invalid BTF string section\n");
> > +                     return -EINVAL;
> > +             }
> > +     } else {
> > +             if (!hdr->str_len || hdr->str_len - 1 > BTF_MAX_STR_OFFSET ||
> > +                 start[0] || end[-1]) {
> > +                     pr_debug("Invalid BTF string section\n");
> > +                     return -EINVAL;
> > +             }
> >       }
> > -
> >       return 0;
>
> I found this function a little difficult to follow. Maybe rearrange it as
>
>         /* too long, or not \0 terminated */
>         if (hdr->str_len - 1 > BTF_MAX_STR_OFFSET || end[-1])
>                 goto err_out;

this won't work, if str_len == 0. Both str_len - 1 will underflow, and
end[-1] will be reading garbage

How about this:

if (btf->base_btf && hdr->str_len == 0)
    return 0;

if (!hdr->str_len || hdr->str_len - 1 > BTF_MAX_STR_OFFSET || end[-1])
    return -EINVAL;

if (!btf->base_btf && start[0])
    return -EINVAL;

return 0;

This seems more straightforward, right?


>
>         /* for base btf, .... */
>         if (!btf->base_btf && (!hdr->str_len || start[0]))
>                 goto err_out;
>
>         return 0;
> err_out:
>         pr_debug("Invalid BTF string section\n");
>         return -EINVAL;
> }
> > }
> >
> > @@ -372,19 +402,9 @@ static int btf_parse_type_sec(struct btf *btf)
> >       struct btf_header *hdr = btf->hdr;
> >       void *next_type = btf->types_data;
> >       void *end_type = next_type + hdr->type_len;
> > -     int err, i = 0, type_size;
>
> [...]
>
