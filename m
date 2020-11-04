Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88E792A7338
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 00:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732814AbgKDXxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 18:53:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387413AbgKDXvf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 18:51:35 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B6A2C0613CF;
        Wed,  4 Nov 2020 15:51:35 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id c129so388203yba.8;
        Wed, 04 Nov 2020 15:51:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5SXEw3JSIGW3Psk2prScqqxL6pBfWjo/0m1owJI93UY=;
        b=d8xV+8dKCCv9EA1kEN6XgcwCnwwYy7tlpjp1NEEPGmtgVLIPTEF84WFfFiUJDP8bvU
         JSG/4hUTcKmD2AbDssL54Lb76tHumfWA725Tjog/+vdz3LEtsS6RxiEVGD71L3VgmZq4
         AoSNxrHTntcqIyXsIBWOO1oDjMGFOCylr6lGnOq2DudE3G1TkfuLKJWtA9/97zNDhJ8B
         wwUi7rKX2W93b/C+yJ0z2YSbA1y+0GoVgGhRAXFTTQE0B6wjgqnyCJONInmXya+qy1/6
         4t7eKUqlOWH7BB8zeC5akZyFjJsmBI8C0woQ2qUUH1TORikgcr+G4q3L1aDKtw1oynlg
         oBFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5SXEw3JSIGW3Psk2prScqqxL6pBfWjo/0m1owJI93UY=;
        b=MBzMujUsQCRc6vkAfJUl0e4dnWOVUCmH6dNi2zCUQ6o+FgZbdrKz/2NmgU4tAZroVq
         IZtIQcQ/ki3AhTTZhdohNWBTZQO5LdSkYbB2dE2qULtRGzarlqqhiGvd0u9sK7AcRjkq
         +ITWpvB6wOE5ETY3ozec7LrNlyMlpMexRWQH1WQ4j5ATL1Yeu6sksABaGt/pjeuW6xiX
         be/G/LLnbllySsbD9qTAgoLFmHH3tPqrk/q63VlevEfTcc/fOXRauJm0lWo1GICdXUvW
         aix1f2Q+N2EOp+4DMrnkhKvW/1Fh/iLvWMpbcnQrkQhRW445hPbQD821zcyvSPR+wONy
         U0yQ==
X-Gm-Message-State: AOAM533R5pG3iRLGVW/7vs6nH8wlsD5DsfTyQWgV2QyHq5IRB/rSsp/a
        etWSqxxNdLM8iLDx1cTABpdQYS2I0Ihecx+VLQ3pZld431g=
X-Google-Smtp-Source: ABdhPJwtTVLfQcirFVXCxHmbcB52Rbb4SjVg1g4xwnGgXxY7y2cWiDak7j7X7aE45Yrkhj2+6ombDdaqe1M15tkfz0g=
X-Received: by 2002:a25:afc1:: with SMTP id d1mr386276ybj.27.1604533894306;
 Wed, 04 Nov 2020 15:51:34 -0800 (PST)
MIME-Version: 1.0
References: <20201029005902.1706310-1-andrii@kernel.org> <20201029005902.1706310-5-andrii@kernel.org>
 <DE5FDF1D-0E5B-409B-80DF-EDA5349FE3A6@fb.com> <CAEf4BzanQsEopXA7cGQi51hf_Q0hNb7NUTvtnkD8xg9AHoU9Ng@mail.gmail.com>
 <80AB5729-CBCA-4306-9048-8E8114EB0A66@fb.com>
In-Reply-To: <80AB5729-CBCA-4306-9048-8E8114EB0A66@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 4 Nov 2020 15:51:23 -0800
Message-ID: <CAEf4BzYUfvgYx-MPY05_rtwZics1ze0812xVxYBn=RSqSvhDpg@mail.gmail.com>
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

On Mon, Nov 2, 2020 at 9:41 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Nov 2, 2020, at 9:02 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Mon, Nov 2, 2020 at 3:24 PM Song Liu <songliubraving@fb.com> wrote:
> >>
> >>
> >>
> >>> On Oct 28, 2020, at 5:58 PM, Andrii Nakryiko <andrii@kernel.org> wrote:
> >>>
> >>
> >> [...]
> >>
> >>>
> >>> BTF deduplication is not yet supported for split BTF and support for it will
> >>> be added in separate patch.
> >>>
> >>> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> >>
> >> Acked-by: Song Liu <songliubraving@fb.com>
> >>
> >> With a couple nits:
> >>
> >>> ---
> >>> tools/lib/bpf/btf.c      | 205 ++++++++++++++++++++++++++++++---------
> >>> tools/lib/bpf/btf.h      |   8 ++
> >>> tools/lib/bpf/libbpf.map |   9 ++
> >>> 3 files changed, 175 insertions(+), 47 deletions(-)
> >>>
> >>> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> >>> index db9331fea672..20c64a8441a8 100644
> >>> --- a/tools/lib/bpf/btf.c
> >>> +++ b/tools/lib/bpf/btf.c
> >>> @@ -78,10 +78,32 @@ struct btf {
> >>>      void *types_data;
> >>>      size_t types_data_cap; /* used size stored in hdr->type_len */
> >>>
> >>> -     /* type ID to `struct btf_type *` lookup index */
> >>> +     /* type ID to `struct btf_type *` lookup index
> >>> +      * type_offs[0] corresponds to the first non-VOID type:
> >>> +      *   - for base BTF it's type [1];
> >>> +      *   - for split BTF it's the first non-base BTF type.
> >>> +      */
> >>>      __u32 *type_offs;
> >>>      size_t type_offs_cap;
> >>> +     /* number of types in this BTF instance:
> >>> +      *   - doesn't include special [0] void type;
> >>> +      *   - for split BTF counts number of types added on top of base BTF.
> >>> +      */
> >>>      __u32 nr_types;
> >>
> >> This is a little confusing. Maybe add a void type for every split BTF?
> >
> > Agree about being a bit confusing. But I don't want VOID in every BTF,
> > that seems sloppy (there's no continuity). I'm currently doing similar
> > changes on kernel side, and so far everything also works cleanly with
> > start_id == 0 && nr_types including VOID (for base BTF), and start_id
> > == base_btf->nr_type && nr_types has all the added types (for split
> > BTF). That seems a bit more straightforward, so I'll probably do that
> > here as well (unless I'm missing something, I'll double check).
>
> That sounds good.

So I don't think I can do that in libbpf representation,
unfortunately. I did miss something, turns out. The difference is that
in kernel BTF is always immutable, so we can store stable pointers for
id -> btf_type lookups. For libbpf, BTF can be modified, so pointers
could be invalidated. So I instead store offsets relative to the
beginning of the type data array. With such representation having VOID
as element #0 is more tricky (I actually tried, but it's too
cumbersome). So this representation will have to be slightly different
between kernel and libbpf. But that's ok, because it's just an
internal implementation. API abstracts all of that.

>
> >
> >>
> >>> +     /* if not NULL, points to the base BTF on top of which the current
> >>> +      * split BTF is based
> >>> +      */
> >>
> >> [...]
> >>
> >>>
> >>> @@ -252,12 +274,20 @@ static int btf_parse_str_sec(struct btf *btf)
> >>>      const char *start = btf->strs_data;
> >>>      const char *end = start + btf->hdr->str_len;
> >>>
> >>> -     if (!hdr->str_len || hdr->str_len - 1 > BTF_MAX_STR_OFFSET ||
> >>> -         start[0] || end[-1]) {
> >>> -             pr_debug("Invalid BTF string section\n");
> >>> -             return -EINVAL;
> >>> +     if (btf->base_btf) {
> >>> +             if (hdr->str_len == 0)
> >>> +                     return 0;
> >>> +             if (hdr->str_len - 1 > BTF_MAX_STR_OFFSET || end[-1]) {
> >>> +                     pr_debug("Invalid BTF string section\n");
> >>> +                     return -EINVAL;
> >>> +             }
> >>> +     } else {
> >>> +             if (!hdr->str_len || hdr->str_len - 1 > BTF_MAX_STR_OFFSET ||
> >>> +                 start[0] || end[-1]) {
> >>> +                     pr_debug("Invalid BTF string section\n");
> >>> +                     return -EINVAL;
> >>> +             }
> >>>      }
> >>> -
> >>>      return 0;
> >>
> >> I found this function a little difficult to follow. Maybe rearrange it as
> >>
> >>        /* too long, or not \0 terminated */
> >>        if (hdr->str_len - 1 > BTF_MAX_STR_OFFSET || end[-1])
> >>                goto err_out;
> >
> > this won't work, if str_len == 0. Both str_len - 1 will underflow, and
> > end[-1] will be reading garbage
> >
> > How about this:
> >
> > if (btf->base_btf && hdr->str_len == 0)
> >    return 0;
> >
> > if (!hdr->str_len || hdr->str_len - 1 > BTF_MAX_STR_OFFSET || end[-1])
> >    return -EINVAL;
> >
> > if (!btf->base_btf && start[0])
> >    return -EINVAL;
> >
> > return 0;
> >
> > This seems more straightforward, right?
>
> Yeah, I like this version. BTW, short comment for each condition will be
> helpful.
>
>
